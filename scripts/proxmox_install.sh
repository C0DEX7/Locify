#!/usr/bin/env bash

# ======================================================================================
# LOCIFY PROXMOX HELPER SCRIPT
# Description: Installs Locify (Self-hosted Music Mirror) in a Proxmox LXC
# ======================================================================================
if [ ! -d /etc/pve ]; then
    echo "❌ Error: This script must be run on a Proxmox VE host!"
    exit 1
fi

set -e

# --- Configuration ---
NEXTID=$(pvesh get /cluster/nextid)
CT_NAME="Locify-Server"
CT_IMAGE="debian-12-standard_12.2-1_amd64.tar.zst" # Default Debian 12 Template
CT_RAM="2048"
CT_DISK="20"
CT_CPU="2"

echo "🚀 Starting Locify LXC Installation..."

# 1. Select Storage for the Container
STORAGE_LIST=$(pvesm status -content rootdir | awk 'NR>1 {print $1}')
echo "Available storage for the OS disk: $STORAGE_LIST"
read -p "Select storage (default 'local-lvm'): " STORAGE
STORAGE=${STORAGE:-local-lvm}

# 2. Ask for Music Media Path (The Bind Mount)
echo ""
echo "📂 Locify needs access to your physical hard drive for music storage."
read -p "Enter the FULL path to your music folder on the Proxmox HOST: " HOST_MUSIC_PATH

if [ ! -d "$HOST_MUSIC_PATH" ]; then
    echo "❌ Error: $HOST_MUSIC_PATH does not exist on the host."
    exit 1
fi

# 3. Create the LXC Container
echo "🏗️ Creating LXC Container ($CT_NAME) with ID $NEXTID..."
pct create $NEXTID \
  local:vztmpl/$CT_IMAGE \
  --hostname $CT_NAME \
  --description "Locify Music Mirror Server" \
  --cores $CT_CPU \
  --memory $CT_RAM \
  --net0 name=eth0,bridge=vmbr0,firewall=1,ip=dhcp \
  --rootfs $STORAGE:$CT_DISK \
  --unprivileged 1 \
  --features nesting=1 \
  --start 1

# 4. Set up the Bind Mount (Mapping Host Music to Container Music)
echo "🔗 Mapping $HOST_MUSIC_PATH to /mnt/locify_media inside the container..."
pct set $NEXTID -mp0 "$HOST_MUSIC_PATH,mp=/mnt/locify_media"

# 5. Run the Internal Setup Script
echo "⚙️ Setting up Locify software inside the container..."
sleep 5 # Wait for LXC to initialize network

pct exec $NEXTID -- bash -c "
  apt-get update && apt-get install -y curl git sudo ffmpeg
  
  # Install Docker
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  
  # Clone Locify Repository
  mkdir -p /opt/locify
  git clone https://github.com/YOUR_GITHUB_USERNAME/Locify.git /opt/locify
  
  # Set up Environment
  cd /opt/locify
  cp .env.example .env
  
  # Start Locify
  docker compose up -d
"

# 6. Final Instructions
IP_ADDRESS=$(pct exec $NEXTID -- hostname -I | awk '{print $1}')

echo "========================================================="
echo "✅ LOCIFY INSTALLATION COMPLETE!"
echo "========================================================="
echo "🌐 Access the UI at: http://$IP_ADDRESS:3000"
echo "📂 Your music is being synced to: /mnt/locify_media"
echo ""
echo "⚠️  IMPORTANT: Edit /opt/locify/.env inside the container"
echo "   to add your Spotify/Apple Music API credentials."
echo "========================================================="


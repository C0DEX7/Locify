#!/usr/bin/env bash
# Proxmox LXC Install Script for Locify
# Run this directly on your Proxmox Host shell.

set -e

# Default settings
CTID=105
HOSTNAME="locify"
TEMPLATE="local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
PASSWORD="locify"
CORES=2
RAM=2048
DISK=10
BIND_MOUNT_SRC="/mnt/pve/your-hdd/locify-media" # CHANGE THIS to your actual host HDD path
BIND_MOUNT_DST="/media"

echo "Creating LXC Container $CTID for Locify..."

# 1. Create the container (unprivileged)
pct create $CTID $TEMPLATE \
  --arch amd64 \
  --hostname $HOSTNAME \
  --cores $CORES \
  --memory $RAM \
  --swap 512 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp \
  --rootfs local-lvm:${DISK} \
  --password $PASSWORD \
  --unprivileged 1 \
  --features nesting=1 # Required for Docker

# 2. Add bind mount for media storage
if [ ! -d "$BIND_MOUNT_SRC" ]; then
    echo "Warning: Source path $BIND_MOUNT_SRC does not exist on host. Creating it..."
    mkdir -p "$BIND_MOUNT_SRC"
fi

# We have to handle mapping for unprivileged containers so the container root (100000) can read/write it,
# but for a simple setup, ensuring wide permissions on the host folder often suffices if mapping isn't strictly needed.
chmod -R 777 "$BIND_MOUNT_SRC"

pct set $CTID -mp0 $BIND_MOUNT_SRC,mp=$BIND_MOUNT_DST

# Start the container
echo "Starting container..."
pct start $CTID

# Wait for IP and networking
echo "Waiting for networking..."
sleep 5

# 3. Install Docker & Dependencies inside the LXC
echo "Installing Docker..."
pct exec $CTID -- bash -c "apt-get update && apt-get upgrade -y"
pct exec $CTID -- bash -c "apt-get install -y curl wget git python3 python3-pip ffmpeg"

pct exec $CTID -- bash -c "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"

echo "========================================================="
echo "Locify LXC setup complete!"
echo "You can now enter the container, clone the repository, and run docker-compose up -d"
echo "To enter: pct enter $CTID"
echo "========================================================="

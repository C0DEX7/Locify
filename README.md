# 🎵Locify
**Your music. Your server. Your terms.**

Locify is a self-hosted music server that creates a **1:1 physical mirror** of your Spotify and Apple Music libraries on your home hardware. It doesn't just link to your accounts—it downloads and organizes them into a indestructible local archive.
### ✨ Key Features
* **State-Sync Mirroring:** If you add/remove a song on Spotify, Locify mirrors the change on your disk instantly.
* **Reference-Counted Storage:** Smart de-duplication. If a song is in 10 playlists, it's stored once. It's only deleted if it's removed from *every* playlist.
* **Offline-First:** No internet? No problem. Locify streams directly from your local metadata (.json) and media (.mp4).
* **Multi-Tenant:** Host a server for your whole family; each user gets their own private Spotify/Apple sync.
### 📦 The Locify Bundle Structure
Every track is stored as a self-contained unit:
```text
Playlist_Name/
├── song_name.mp4  (Audio/Video)
├── song_name.png  (Cover Art)
└── song_name.json (Metadata)

```
### 🚀 Proxmox Quick Install
Run this command in your Proxmox shell to create a Locify LXC container:
bash -c "$(wget -qO- [https://raw.githubusercontent.com/C0DEX7/Locify/main/scripts/proxmox_install.sh](https://raw.githubusercontent.com/C0DEX7/Locify/main/scripts/proxmox_install.sh))"

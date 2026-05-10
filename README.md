# 🎵Locify
**Your music. Your server. Your terms.**

Locify is a self-hosted backend engine that creates a **1:1 physical mirror** of your Spotify and Apple Music libraries on your own hardware. Unlike other tools, Locify doesn't just "link" to your accounts—it archives your music into a structured local library that you stream to native Locify apps on your phone or computer.
### 🚀 The Vision
 * **Total Ownership:** Your music stays on your server even if it's removed from streaming platforms.
 * **Zero-Internet Playback:** Since the server lives in your home, you can stream your entire library over your local Wi-Fi even if the global internet goes down.
 * **Native Experience:** No web browsers. Use native Locify apps for iOS, Android, and Desktop that connect directly to your server's IP.
### ✨ Key Features
 * **State-Sync Mirroring:** Locify monitors your Spotify/Apple playlists. Add a song on your phone; the server downloads it. Remove it; the server deletes the link.
 * **Smart De-duplication:** Uses **Reference Counting**. If a song appears in 5 playlists, it is stored physically only once. It is only deleted from disk when it is removed from *every* playlist on the server.
 * **Bundle Storage:** Every track is stored as a self-contained "bundle" for maximum portability:
   * song.mp4 (The high-quality stream source)
   * song.png (High-res album art)
   * song.json (Full metadata: ISRC, Artist, Album, Source ID)
 * **Multi-Tenant:** Create separate profiles for family members. Each user chooses their "Active Source" (Spotify or Apple Music) within the app.
### 📂 Mirror File Structure
Locify organizes your hard drive into a clean, human-readable hierarchy:
```text
/music-library/
├── [master files]/
│   ├── song1.mp4
│   ├── song1.png
│   ├── song1.json <- metadata
│   ├── trackA.mp4
│   ├── trackA.png
│   └── trackA.json <- metadata
└── [User_Name]/
    ├── [Spotify]/
    │   └── [Playlist_Name]/
    │       └── song1_sym.json
    └── [Apple_Music]/
        └── [Playlist_Name]/
            └── trackA_sym.json

```
### 🛠️ Proxmox Quick Install
Locify is optimized for **Proxmox VE**. Run this command in your Proxmox shell to deploy the Locify Backend Engine in an LXC container:
```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/C0DEX7/Locify/main/scripts/proxmox_install.sh)"

```
### 📱 How it Works
 1. **Deploy the Backend:** Use the Proxmox script to set up the "Brain" and "Storage."
 2. **Connect the Apps:** Open the Locify app on your Phone or PC and enter your server's IP address.
 3. **Sync & Stream:** The server mirrors your cloud playlists to your hard drive. Your app then streams that music directly from your home server using high-performance byte-range requests.
### 📝 Metadata Schema (.json)
Each song bundle includes a JSON file to ensure the library remains functional even without a database:
```json
{
  "title": "Song Name",
  "artist": "Artist Name",
  "album": "Album Name",
  "source": "spotify",
  "external_id": "4cOdK2wGZYmSnuA3n",
  "downloaded_at": "2026-05-08",
  "is_explicit": true
}
```
### 📝 Symlink Schema (.json)
```json
{
  "music_file": "song1.mp4",
  "music_art": "song1.png",
  "music_metadata": "song1.json"
}
```
### 🛡️ License
Distributed under the MIT License. See LICENSE for more information.

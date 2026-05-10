# 🎵Locify
**Your music. Your server. Your terms.**

Locify is a self-hosted backend ecosystem that creates a true 1:1 local mirror of your Spotify and Apple Music libraries. By transforming your home hardware into a private streaming cloud, Locify gives you full ownership of your music, ensuring offline access and eliminating dependency on external cloud providers.

### 🚀 Features
-Multi-Provider Synchronization: Link Spotify, Apple Music, or both to a single local server.

-Intelligent Mirroring: Automated "diffing" keeps your local library perfectly in sync with your remote playlists (Additions/Removals).

-Custom Library Support: Manually upload rare bootlegs or personal recordings with integrated metadata and artwork management.

-Space-Efficient Storage: Uses Reference Counting and Symbolic Links (Symlinks)—if a song exists in multiple playlists, it is stored physically only once.

-Robust Integrity: SHA-256 checksums are maintained for every song bundle, ensuring data health during backups or migrations.

-Offline Resilience: The UI is 100% functional (metadata, search, navigation) even when the external internet is down.

-Spotify-Clone UI: A high-fidelity, dark-mode interface for Mobile and Desktop that provides a seamless streaming experience.

### 🛠 Technical Specifications
**Backend & Deployment**
-Environment: Designed for Proxmox LXC or Docker containers.

-Engine: Leverages spotDL for high-quality audio resolution and ffmpeg for tagging.

-Resource Requirements:

-CPU: 2 vCPUs (Burst-capable for conversion/tagging tasks).

-RAM: 1GB - 2GB.

-Storage: Scalable (avg. 10MB per song).

### 🔗 Sync Triggers
-Instant: Triggered upon opening the mobile/desktop app.

-Scheduled: Background "diff" every 1 hour.

-Manual: Triggered upon page refresh.

### 📂 File Structure
Locify organizes your media into a structured, self-contained format:

```Plaintext
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
    │       ├── playlist_cover.png
    │       └── song1_sym.json
    └── [Apple_Music]/
        └── [Playlist_Name]/
		        ├── playlist_cover.png
            └── trackA_sym.json
```
**Metadata Schema** (.json)
```JSON
{
  "title": "Song Name",
  "artist": "Artist Name",
  "album": "Album Name",
  "source": "spotify",
  "external_id": "4cOdK2wGZYmSnuA3n",
  "checksum": "a1b2c3d4....",
  "downloaded_at": "2026-03-20",
  "is_explicit": true
}
```
**symlink schema:**

```json
{
  "music_file": "song1.mp4",
  "music_art": "song1.png",
  "music_metadata": "song1.json"
}
```
 ###📱 Native Apps
Built with Flutter/React Native, the client app connects to your server via IP/Hostname.

Onboarding: Secure login flow with support for password resets.

Streaming: Uses HTTP Byte-Range requests for instant, seamless seeking.

Source Toggle: Easily switch between "Spotify Mirror" and "Apple Music Mirror" while maintaining a consistent, Spotify-inspired aesthetic.

⚙️ Deployment
(Instructions for Docker/Proxmox setup will go here)

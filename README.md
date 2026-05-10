# 🎵Locify
**Your music. Your server. Your terms.**

Locify is a self-hosted backend ecosystem designed to create a **1:1 local mirror** of your Spotify and Apple Music libraries. It acts as a private streaming cloud, allowing users to host their own music on home hardware (LXC) and stream them to any device, maintaining full ownership and offline access.

### **Core Functionality**

- **Multi-User & Multi-Provider:** Each user creates a local server account. Within their settings, they link a Spotify account, an Apple Music account, or both.
- **The "Source" Toggle:** Upon opening the app, users choose which service library (spotify/apple music) they want to interact with.
- **Automated Mirroring:** The server constantly "diffs" the local library against the remote Spotify/Apple APIs.
    - **Additions:** New songs added to a remote playlist are automatically downloaded.
    - **Removals:** If a song is removed from a playlist, the server removes it from that local folder immediately.
    - **Trigger A:** Instant sync when a user opens the desktop/mobile app.
    - **Trigger B:** Background "Diff" every **1 hour** to catch changes made while the app was closed
    - **Trigger C:** instant sync when user refreshes the page
- **Custom Library Uploads:** Users can bypass cloud providers by manually uploading custom music files (e.g., rare bootlegs, personal recordings).
    - **Manual Requirements:** To maintain system consistency, users must manually provide the high-resolution **Album Art** and add the **Metadata** (Title, optional-artist,album) during the upload process.
- **Intelligent Storage (Reference Counting):**
    - If a song exists in multiple playlists, it is stored physically only **once** to save space.
    - The backend only deletes the physical file from the hard drive when it is no longer present in **any** playlist across the entire server.
- **spotDL Integration:** Uses the spotDL engine to resolve Spotify metadata into high-quality .mp4 files, automatically embedding metadata and album art.

### **Technical Specifications**

- **Deployment:** Designed to run as **Open Source** software within a **Proxmox LXC, Docker container**.
- **Backend Logic:**
    - **Database:** Tracks file paths, unique IDs, and "reference counts" for every song.
    - **Filesystem:** Uses **Symbolic Links (Symlinks)** to show songs in multiple playlist folders without duplicating data.
- **Resource Allocation:**
    - **CPU:** 2 vCPUs (Burst-capable). spotDL and ffmpeg require short CPU spikes during the conversion and tagging process.
    - **RAM:** 1GB - 2GB. Most of the time it will sit idle, but a buffer is needed for scanning large libraries.
    - **Storage:** Scalable based on library size (average 10MB per song).
    - **Integrity Layer:** Every song bundle includes a **SHA-256 Checksum** stored in the JSON sidecar. This allows the system to verify file health during backups or migrations.
- **UI/UX:** A high-fidelity "Spotify-like" interface for Mobile and Desktop, supporting local server streaming and offline caching.

### **Mirror File Structure**

The backend organizes the storage so that every song is a self-contained bundle of media, metadata, and artwork within its respective playlist folder:

- **Playlist Name/**
    - song_name.mp4 (The high-quality audio)
    - song_name.png (High-resolution album art)
    - song_name.json (Detailed track metadata)

```
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

**Example Metadata Schema (song_name.json):**

```json
{
  "title": "Song Name",
  "artist": "Artist Name",
  "album": "Album Name",
  "source": "spotify",
  "external_id": "4cOdK2wGZYmSnuA3n",
  "checksum": "a1b2c3d4...."
  "downloaded_at": "2026-03-20",
  "is_explicit": true
}
```

**Example symlink schema:**

```json
{
  "music_file": "song1.mp4",
  "music_art": "song1.png",
  "music_metadata": "song1.json"
}
```

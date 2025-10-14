# 🐳 RGSX Docker

A lightweight Docker wrapper for [Retro Game Sets Xtra (RGSX)](https://github.com/RetroGameSets/RGSX) that provides an easy way to run RGSX on NAS, servers, or any Docker-capable hardware with the official web interface.

This repository **only contains Docker configuration files**. The RGSX application is automatically pulled from the [upstream repository](https://github.com/RetroGameSets/RGSX) during the Docker build process, ensuring you always have access to the latest features and updates without manual intervention.

## 📋 About RGSX

RGSX is a Python application developed using Pygame for graphics, created for the community by RetroGameSets. It is completely free.

**Key Features:**
- Download retro games from multiple sources (myrient, 1fichier, etc.)
- Web-based interface for remote management
- Download history and queue management
- Multi-select batch downloads
- Search and filter across all platforms
- Multilingual support
- 1fichier premium API key support

For the full RGSX application (Batocera/Retrobat installation), visit the [upstream repository](https://github.com/RetroGameSets/RGSX).

**Support:** https://discord.gg/Vph9jwg3VV

---

## 🐳 Docker Support

This project includes support for running RGSX in a Docker container with the official web interface.

<img width="1566" height="813" alt="Screenshot_20250830_233936" src="https://github.com/user-attachments/assets/1887c02b-5b1e-40d0-b299-633967ed21ef" />

### Quick Start (Prebuilt Image)

Pull the latest image from GitHub Container Registry:

```bash
docker pull ghcr.io/brownster/rgsx-docker:latest
```

Run the container:

```bash
docker run -d --name rgsx \
  -p 8080:8080 \
  -v /path/to/your/roms:/roms \
  -v /path/to/your/saves:/saves \
  ghcr.io/brownster/rgsx-docker:latest
```

Access the web UI at `http://localhost:8080`

### Building the Docker Image (Optional)

If you prefer to build from source:

```bash
docker build -t rgsx .
```

### Running with Docker Compose

The easiest way to run the application with Docker is to use Docker Compose. A `docker-compose.yml` file is provided for this purpose.

1.  **Configure the volumes:** Open the `docker-compose.yml` file and edit the `volumes` section to map your local ROMs and saves directories to the container's `/roms` and `/saves` directories.

    ```yaml
    volumes:
      # Point these to your NAS paths
      - /path/to/your/roms:/roms
      - /path/to/your/saves:/saves
    ```

2.  **Start the container:** Run the following command to start the container in the background:

    ```bash
    docker-compose up -d
    ```

The web UI will be available at `http://<your-docker-host>:8080`.

### Available Tags

- `ghcr.io/brownster/rgsx-docker:latest` - Latest stable release
- `ghcr.io/brownster/rgsx-docker:v1.0.0` - Specific version (recommended for production)

### Environment Variables

The following environment variables can be used to configure the Docker container:

| Variable              | Description                               | Default |
| --------------------- | ----------------------------------------- | ------- |
| `TZ`                  | Timezone for the container                | `UTC`   |
| `RGSX_MODE`           | Set to `web` to enable the web UI         | `web`   |
| `WEB_PORT`            | Port for the web UI                       | `8080`  |
| `ONEFICHIER_API_KEY`  | Pre-seed 1fichier API key                 | -       |
| `RGSX_DISABLE_UPDATER`| Disable automatic updates                 | `1`     |

To run the container as a specific user/group, set the `user:` field in your compose file.

---

## 🌐 Web UI

RGSX now includes a web-based user interface that allows you to manage your retro game collection from a web browser.

### Features

-   **Browse platforms and games:** View your entire collection of platforms and games.
-   **Download games:** Start and monitor game downloads directly from the web UI.
-   **View download history:** See a list of all your downloaded games.
-   **Search:** Quickly find games across all your platforms.
-   **1Fichier API Key:** Configure your 1Fichier API key.

### Accessing the Web UI

When running RGSX with Docker, the web UI is enabled by default. You can access it at:

`http://<your-docker-host>:8080`


## 🚀 Usage

### First Run

On first startup, the web UI will:
1. Automatically download the platform/game database from upstream
2. Create necessary directories in `/saves/ports/rgsx/`
3. Be ready to browse and download games

### 1fichier API Key Setup

If you have a 1fichier premium account, you can provide your API key in two ways:

**Option 1: Environment Variable (Recommended)**
```bash
docker run -d --name rgsx \
  -e ONEFICHIER_API_KEY="your-api-key-here" \
  -p 8080:8080 \
  -v /path/to/roms:/roms \
  -v /path/to/saves:/saves \
  ghcr.io/brownster/docker-rgsx:latest
```

**Option 2: Manual File**
Create the file `/saves/ports/rgsx/1fichierAPI.txt` with your API key.

### GUI Mode (Optional)

Set `RGSX_MODE=gui` to launch the SDL interface under Xvfb with VNC access:
```bash
docker run -d --name rgsx \
  -e RGSX_MODE=gui \
  -p 5900:5900 \
  -p 6080:6080 \
  -v /path/to/roms:/roms \
  -v /path/to/saves:/saves \
  ghcr.io/brownster/docker-rgsx:latest
```

Access via VNC on port 5900 or noVNC (web) on port 6080.

---

## 🤝 Contributing

Contributions to the Docker wrapper are welcome!

### Report a Docker-related Bug

1. Check container logs: `docker logs <container-name>`
2. Open an issue on this repository with details

### For RGSX Application Issues

Report bugs to the [upstream RGSX repository](https://github.com/RetroGameSets/RGSX/issues).

### Contribute to Docker Configuration

1. Fork this repository
2. Create a branch: `git checkout -b feature/your-feature`
3. Test your changes
4. Submit a pull request

---

## 📝 License

This Docker wrapper is free and open source. The RGSX application is developed by RetroGameSets and follows its own license terms.

---

**Repository:** https://github.com/Brownster/docker-RGSX
**Upstream RGSX:** https://github.com/RetroGameSets/RGSX
**Support:** https://discord.gg/Vph9jwg3VV

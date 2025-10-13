# RGSX Docker Web UI

This image wraps the upstream [RetroGameSets/RGSX](https://github.com/RetroGameSets/RGSX) project and exposes its official HTTP web interface. The container fetches the latest RGSX sources at build time, so you inherit any improvements (history view, download fixes, controller updates, etc.) without manually syncing the codebase.

## Features

- **Official RGSX web UI** – identical functionality to the standalone project (history, search, download queue, support package, settings)
- **Docker friendly** – bind mounts for ROM storage and saves; optional GUI mode if you still want the Pygame experience
- **Easy updates** – rebuild the image to pick up new upstream commits or pin a specific tag/commit with build args
- **1fichier helpers** – auto-seed the API key via env vars, matching the upstream behaviour

## Quick Start (Prebuilt Image)

Pull and run the latest image:

```bash
docker pull ghcr.io/brownster/rgsx-docker:latest

docker run -d --name rgsx \
  -p 8080:8080 \
  -v /path/to/your/roms:/roms \
  -v /path/to/your/saves:/saves \
  ghcr.io/brownster/rgsx-docker:latest
```

Open `http://localhost:8080` to use the official RGSX web interface.

## Quick Start (Docker Compose)

1. Copy the environment template and edit paths:
   ```bash
   cp .env.example .env
   # Update NAS_ROMS and RGSX_SAVES to match your system
   ```

2. Launch the default stack:
   ```bash
   docker-compose up -d
   ```

3. Open `http://localhost:8080` to use the official RGSX web interface.

## Compose Profiles

- `docker-compose.yml` – simple single-container setup (web UI by default)
- `docker-compose.web.example.yml` – example mapping for NAS paths
- `docker-compose.dev.yml` – handy for hacking with local volumes

Set `RGSX_MODE=gui` in any compose file if you want the original Pygame UI over VNC/noVNC.

## Configuration

| Variable | Default | Purpose |
|----------|---------|---------|
| `RGSX_MODE` | `web` | `web` for the HTTP UI, `gui` for the SDL/VNC build |
| `WEB_PORT` | `8080` | Port the upstream `rgsx_web.py` listens on |
| `TZ` | `UTC` | Container timezone |
| `ONEFICHIER_API_KEY` | – | Pre-seed `/saves/ports/rgsx/1fichierAPI.txt` |
| `RGSX_DISABLE_UPDATER` | `1` | Keep code updates disabled inside the container |

Mounts required in every compose variant:

| Host Path | Container Path | Description |
|-----------|----------------|-------------|
| `/path/to/roms` | `/roms` | Where games are downloaded |
| `/path/to/rgsx-saves` | `/saves` | Settings, cache, history |

## Building Your Own Image

The Dockerfile now accepts two build arguments:

```bash
docker build \
  --build-arg RGSX_REF=v2.2.4.2 \
  --build-arg RGSX_REPO=https://github.com/RetroGameSets/RGSX.git \
  -t my-rgsx .
```

- `RGSX_REF` can be a tag, branch, or commit SHA
- The build needs outbound network access to clone the repository

## Web UI Notes

- The upstream server exposes HTTP JSON endpoints under `/api` exactly like the desktop build. Any enhancements the maintainer ships arrive automatically on rebuild.
- Support ZIP generation saves to the browser; no extra Nginx rules are needed.
- History and active download state remain in `/saves/ports/rgsx/history.json` – mount that directory if you want persistence.

## GUI Mode (Optional)

Set `RGSX_MODE=gui` to launch the SDL interface under Xvfb. The image already includes `xvfb`, `x11vnc`, `websockify`, and `novnc`. Exposed ports:

- `5900` – raw VNC
- `6080` – noVNC (HTML5)

## Troubleshooting

- **Nothing loads** – check logs with `docker logs rgsx`
- **Missing platforms** – use the web UI Settings → Update cache or delete the cache files inside `/saves/ports/rgsx`
- **1fichier issues** – confirm your API key was written to `/saves/ports/rgsx/1fichierAPI.txt`
- **Permission errors** – ensure the host paths are writable by the container user, or set `PUID`/`PGID` in compose

## Keeping Upstream in Sync

- Rebuild locally: `docker-compose build --no-cache` (or `docker build`) whenever the upstream project publishes a new release
- For repeatable builds, pin `RGSX_REF` to a specific tag/commit instead of `main`
- If you need to patch the upstream code, mount your local `ports/RGSX` tree over `/opt/RGSX` using the dev compose file

Enjoy the official RGSX experience without maintaining a forked codebase.

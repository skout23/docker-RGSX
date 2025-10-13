## Upstream RGSX Web Interface

The container no longer ships a custom FastAPI wrapper. Instead it launches the official `rgsx_web.py` server bundled with the upstream project. That keeps behaviour in sync with the desktop release (history actions, support ZIP generation, controller updates, etc.).

### Main Endpoints

All routes live on the same port (default `8080`, override with `WEB_PORT`). The HTML UI hits these JSON endpoints under the hood:

- `GET /` – Single-page interface with tabs for platforms, downloads, history, and settings
- `GET /api/platforms` – List available systems with localized names
- `GET /api/games?platform=<id>` – Games for a platform (name, size, URL)
- `POST /api/download` – Start a download using the same logic as the GUI build
- `POST /api/cancel` – Cancel a download in progress
- `GET /api/progress` – Snapshot of active downloads
- `GET /api/history` – Completed/failed downloads (newest first)
- `POST /api/update-cache` – Clear cached platform/game metadata so it is refreshed on next use
- `POST /api/support` – Generate a ZIP with logs/settings for support requests
- `GET /assets/...` – Static files served directly from `/saves/ports/rgsx`

### Data Bootstrap

On first launch the server mirrors the GUI flow:
- Ensures `/saves/ports/rgsx` exists
- Downloads the latest data pack if `sources.json` or cached game files are missing
- Creates empty API key files (1fichier, AllDebrid, RealDebrid) so you can fill them in later

Mount the `/saves` volume to persist this cache between container rebuilds.

### Running with Docker Compose

```bash
# adapt the paths to your NAS/host
NAS_ROMS=/mnt/nas/roms \
RGSX_SAVES=/mnt/nas/rgsx-saves \
docker compose -f docker-compose.web.example.yml up -d --build
```

Then open `http://<host>:8080` in your browser. All translations and UI enhancements added upstream appear automatically after the next rebuild.

### Authentication & Rate Limiting

`rgsx_web.py` does not currently implement request authentication or rate limiting. If you need those features, place the container behind a reverse proxy (Traefik, Nginx, Caddy) that adds auth headers or IP throttling.

### Customising Behaviour

If you want to patch the official server, mount your local `ports/RGSX` directory over `/opt/RGSX` using the dev compose file, restart the container, and iterate on the Python sources locally.

### GUI Fallback

Set `RGSX_MODE=gui` to restore the SDL interface. The web server is disabled in that mode and the entrypoint launches `python -m RGSX` under Xvfb.

## RGSX in Docker (Pi + NAS)

The container now runs the upstream `rgsx_web.py` server by default, giving you the same web interface that ships with RetroGameSets/RGSX. Downloads land in `/roms/<system>`, while settings and history persist under `/saves/ports/rgsx`.

### What you get
- Official RGSX web UI on `http://<host>:8080`
- Optional SDL/VNC mode for the legacy Pygame experience (`RGSX_MODE=gui`)
- Multi-arch image (amd64, arm64, armv7) ready for Raspberry Pi or NAS boxes
- First-run data bootstrap identical to the upstream project

### Repo layout
- `Dockerfile` – clones upstream RGSX and stages it inside the image
- `docker/entrypoint.sh` – toggles between web and GUI launches
- `docker-compose.yml` – basic service definition with volume mounts
- `docker-compose.web.example.yml` – example for NAS paths with environment variables
- `docker-compose.dev.yml` – development setup with local volume mounts

### Quick start (Web mode)
1. Build or pull the image
   ```bash
   docker compose build
   ```

2. Edit paths in `docker-compose.yml` or use environment variables
   ```yaml
   volumes:
     - /path/to/your/roms:/roms
     - /path/to/your/saves:/saves
   ```

3. Launch
   ```bash
   docker compose up -d
   ```

4. Browse to `http://<host>:8080`
   - Platforms, downloads, history, and settings mirror the desktop build
   - Support ZIPs download directly in your browser

5. First run notes
   - The server downloads the dataset automatically if missing
   - API key placeholders are created in `/saves/ports/rgsx/*.txt`

### Volume mappings
- `/roms` → Where new ROMs are written (one subfolder per system)
- `/saves` → Persistent config/cache (`/saves/ports/rgsx` inside)

### GUI (VNC) variant
- Switch `RGSX_MODE=gui`
- Ports: `5900` (VNC) and `6080` (noVNC via browser)
- Adjust `DISPLAY_WIDTH`, `DISPLAY_HEIGHT`, `DISPLAY_DEPTH` as desired

### Raspberry Pi / handheld tips
- Mount your NAS share to `/roms` and `/saves`
- Refresh EmulationStation/EmuDeck gamelists after downloads complete
- When running on handheld Linux builds, keep the container headless and use the web UI from another device

### Troubleshooting
- **Blank page:** check container logs (`docker logs rgsx`) for bootstrap errors
- **`ModuleNotFoundError: No module named 'pygame'`:** rebuild the image from this repo so the container picks up the bundled `pygame` runtime required by the upstream web server
- **No platforms:** clear `/saves/ports/rgsx/sources.json` and refresh via Settings in the UI
- **1fichier failures:** verify `/saves/ports/rgsx/1fichierAPI.txt` contains a valid key or set `ONEFICHIER_API_KEY`
- **Permission issues:** set `user: "1000:1000"` (or similar) in compose to match your NAS permissions

### Updater controls
- `RGSX_DISABLE_UPDATER=1` keeps the in-app OTA updater disabled. Rebuild the image instead of allowing code writes inside the container.
- `WEB_PORT` overrides the listen port (container and host mapping). Defaults to `8080` if unset.

### Staying current
- Rebuild with `docker compose build --no-cache` to grab the latest upstream commit
- Pin a specific release by passing `--build-arg RGSX_REF=v2.2.4.2`
- For experiments, mount a local `ports/RGSX` directory over `/opt/RGSX` using `docker-compose.dev.yml`

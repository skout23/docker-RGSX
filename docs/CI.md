## CI: Multi-arch Docker images on tags

This repository includes a GitHub Actions workflow that builds and publishes multi-arch Docker images whenever you push a tag (e.g., `v1.2.3`).

Workflow: `.github/workflows/docker-multiarch.yml`

What it does
- Builds for `linux/amd64`, `linux/arm64`, and `linux/arm/v7`.
- Pushes to GitHub Container Registry (GHCR) by default as `ghcr.io/<owner>/<repo>:<tag>` and `:latest`.
- Optionally pushes to Docker Hub if credentials are provided.
- Clones the upstream RGSX repository during the image build (matching the Dockerfile behaviour locally) so you inherit the official web UI.

Trigger
- Pushing a tag that matches `v*` or `V*`.
- Manual run via “Run workflow”.

Configuration
- GHCR requires no extra secrets; `GITHUB_TOKEN` is used automatically.
- Docker Hub (optional): set the following in repo Settings → Secrets and variables → Actions:
  - Secrets:
    - `DOCKERHUB_USERNAME`
    - `DOCKERHUB_TOKEN` (Create a Docker Hub access token)
  - Variable (or Secret):
    - `DOCKERHUB_IMAGE` (e.g., `myuser/rgsx`)

How tags map to images
- Tag `v1.2.3` → images tagged `:v1.2.3` and `:latest`.
- You can also add more tag patterns in the workflow if you need.

Usage
- After a tag build completes, pull the image on any host:
  - GHCR: `docker pull ghcr.io/<owner>/<repo>:v1.2.3`
  - Docker Hub (if enabled): `docker pull myuser/rgsx:v1.2.3`

Manual release (single tag + release)
- Workflow: `.github/workflows/manual-release.yml`
- In GitHub → Actions → "Manual Release and Tag" → Run workflow
  - Set `version` (e.g., `0.0.1`)
  - Optionally set `prerelease` and notes
  - The workflow:
    - Creates a single tag: `v0.0.1`
    - Creates a GitHub Release for `v0.0.1`
    - Pushing `v0.0.1` triggers the Docker multi-arch workflow to publish GHCR images

Notes
- The same image supports both GUI and Web modes via `RGSX_MODE` env (`gui` or `web`).
- Consider pinning exact tags (e.g., `v1.2.3`) in production instead of `latest`.
- The workflow honours the `RGSX_REF` build argument; set it at dispatch time if you want to pin a specific upstream release.

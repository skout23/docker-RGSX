FROM python:3.11-slim-bookworm

# Upstream imports pygame even in web mode, so keep the runtime available by default.
ARG INCLUDE_PYGAME=1
ARG RGSX_REPO=https://github.com/RetroGameSets/RGSX.git
ARG RGSX_REF=main

# Install runtime deps for both web and GUI modes.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git iputils-ping curl \
       unrar-free \
       python3-dev build-essential \
       libsdl2-2.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0 libsdl2-ttf-2.0-0 \
       libjpeg62-turbo libpng16-16 libfreetype6 libgl1 libglu1-mesa \
       # GUI/VNC tools only when running GUI mode; harmless to have present in web mode\
       xvfb x11vnc fluxbox websockify novnc \
    && rm -rf /var/lib/apt/lists/*

# Python requirements shared by both modes
RUN pip install --no-cache-dir --upgrade pip setuptools wheel \
    && pip install --no-cache-dir requests

# Install pygame by default so the upstream web entrypoint can import display.py.
RUN if [ "$INCLUDE_PYGAME" = "1" ]; then \
      set -eux; \
      pip install --no-cache-dir pygame==2.5.2; \
    fi

# App location and data mount points
WORKDIR /opt
RUN mkdir -p /roms /saves

# Fetch RGSX sources from upstream and stage the application package
RUN git clone --depth 1 --branch "${RGSX_REF}" "${RGSX_REPO}" /tmp/RGSX \
    && cp -a /tmp/RGSX/ports/RGSX /opt/RGSX \
    && rm -rf /tmp/RGSX

# Environment for headless X and SDL
ENV DISPLAY=:0 \
    SDL_VIDEODRIVER=x11 \
    SDL_AUDIODRIVER=dummy \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Expose VNC (5900) and noVNC (6080) for GUI mode, and 8080 for Web mode
EXPOSE 5900 6080 8080

# Add entrypoint that starts Xvfb, VNC and launches RGSX
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

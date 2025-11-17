# =========================
# Stage 1 – Builder
# =========================
FROM ubuntu:24.04 AS builder

# ---- Configuration ----
ARG AMMC_VER=${AMMC_VER:-latest}

# ---- Install build tools ----
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /build

# ---- Download & unpack ----
RUN wget -q https://www.ammconverter.eu/ammc-${AMMC_VER}.zip \
    && unzip  ammc-${AMMC_VER}.zip \
    && rm ammc-${AMMC_VER}.zip

# =========================
# Stage 2 – Runtime
# =========================
FROM ubuntu:24.04

# ---- Install only runtime deps ----
RUN apt-get update && apt-get install -y \
    libstdc++6 \
    ca-certificates \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /app

# ---- Copy binaries from builder ----
COPY --from=builder /build/linux_x86-64/ .

# ----  Dependency to MyLaps X2 SDK id needed ----
ENV LIBRARY_PATH=/app
ENV LD_LIBRARY_PATH=/app

# ---- Ensure executable permissions ----
RUN chmod +x ./ammc-*

# ---- Default command ----
CMD []
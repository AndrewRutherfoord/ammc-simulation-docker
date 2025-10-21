# =========================
# Stage 1 – Builder
# =========================
FROM ubuntu:24.04 AS builder

# ---- Configuration ----
ARG AMMC_VER=7.5.0
ENV AMMC_VER=${AMMC_VER}

# ---- Install build tools ----
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /build

# ---- Download & unpack ----
RUN wget -q https://www.ammconverter.eu/ammc-v${AMMC_VER}.zip \
    && unzip -q ammc-v${AMMC_VER}.zip \
    && rm ammc-v${AMMC_VER}.zip

# ---- Ensure binaries are executable ----
RUN chmod +x ./linux64/ammc-* || true

# =========================
# Stage 2 – Runtime
# =========================
FROM ubuntu:24.04

# ---- Configuration ----
ARG AMMC_VER=7.5.0
ENV AMMC_VER=${AMMC_VER}

# ---- Install only runtime deps ----
RUN apt-get update && apt-get install -y \
    libstdc++6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /app

# ---- Copy binaries from builder ----
COPY --from=builder /build/linux64/ ./linux64/

# ---- Ensure executable permissions ----
RUN chmod +x ./linux64/ammc-* || true

# ---- Default command ----
CMD []
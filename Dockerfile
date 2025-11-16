# =========================
# Stage 1 – Builder
# =========================
FROM ubuntu:24.04 AS builder

# ---- Configuration ----
ARG AMMC_VER=latest
ARG TARGETARCH

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
    && unzip -q ammc-${AMMC_VER}.zip \
    && rm ammc-${AMMC_VER}.zip

# ---- Ensure binaries are executable ----
RUN chmod +x ./linux_x86-64/ammc-* || true
RUN chmod +x ./apple_m/ammc-* || true

# =========================
# Stage 2 – Runtime
# =========================
FROM ubuntu:24.04

# ---- Configuration ---
ARG AMMC_VER=latest
ARG TARGETARCH

# ---- Install only runtime deps ----
RUN apt-get update && apt-get install -y \
    libstdc++6 \
    ca-certificates \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# ---- Working directory ----
WORKDIR /app

# ---- Copy binaries from builder ----
COPY --from=builder /build/linux_x86-64/ ./linux_x86-64/
COPY --from=builder /build/apple_m/ ./apple_m/

RUN if [ "${TARGETARCH}" = "arm64" ]; then \
    cp -r ./apple_m/* ./; \
else \
    cp -r ./linux_x86-64/* ./; \
fi

RUN rm -rf ./linux_x86-64/ ./apple_m/

# ---- Ensure executable permissions ----
RUN chmod +x ./ammc-* || true

# ---- Default command ----
CMD []
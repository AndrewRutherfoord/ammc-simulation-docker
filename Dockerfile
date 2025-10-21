# Use Ubuntu as base image
FROM ubuntu:24.04

# ---- Configuration ----
# Allow overriding the AMMC version at build time
ARG AMMC_VER=7.5.0
ENV AMMC_VER=${AMMC_VER}

# ---- Setup ----
# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Working directory
WORKDIR /app

# ---- Download & unpack ----
RUN wget -q https://www.ammconverter.eu/ammc-v${AMMC_VER}.zip
RUN unzip -q ammc-v${AMMC_VER}.zip
RUN rm ammc-v${AMMC_VER}.zip

# ---- Permissions ----
RUN chmod +x ./linux64/ammc-* || true

# ---- Default command ----
CMD []
#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="ghcr.io/andrewrutherfoord/ammc"
PLATFORMS="linux/amd64,linux/arm64"

# Parse arguments
VERSION_TAG="${1:-}" # optional version tag, e.g. "v7.6.0"
DRY_RUN="${DRY_RUN:-false}" # set to true to skip push

# Setup buildx builder if not present
if ! docker buildx inspect multiarch-builder >/dev/null 2>&1; then
  echo "Creating buildx builder..."
  docker buildx create --name multiarch-builder --use
  docker buildx inspect --bootstrap
else
  docker buildx use multiarch-builder
fi

# Build command
BUILD_CMD=(
  docker buildx build .
  --platform "${PLATFORMS}"
  -t "${IMAGE_NAME}:latest"
)

if [[ -n "${VERSION_TAG}" ]]; then
  BUILD_CMD+=(-t "${IMAGE_NAME}:${VERSION_TAG}")
fi

if [[ "${DRY_RUN}" == "true" ]]; then
  echo "Dry run mode ON — images will not be pushed."
  BUILD_CMD+=(--load)  # load locally instead of pushing
else
  BUILD_CMD+=(--push)
fi

# Execute build
echo "Building Docker images for platforms: ${PLATFORMS}"
echo "Tagging as: latest${VERSION_TAG:+ and ${VERSION_TAG}}"
echo "Running command:"
echo "  ${BUILD_CMD[*]}"

# Run the build
"${BUILD_CMD[@]}"

echo "Build complete."
if [[ "${DRY_RUN}" == "true" ]]; then
  echo "Images loaded locally (not pushed)"
else
  echo "Images pushed to ${IMAGE_NAME}"
fi
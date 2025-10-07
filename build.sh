#!/bin/bash

# Build with BuildKit for cache mounts
DOCKER_BUILDKIT=1 docker build -f Dockerfile.sonicpi -t sonic-pi:4.6.0 --build-arg SONICPI_TAG=v4.6.0 .

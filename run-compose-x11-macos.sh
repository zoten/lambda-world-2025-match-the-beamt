#!/bin/bash

# Check if XQuartz is installed
if ! command -v xhost &> /dev/null; then
    echo "XQuartz is not installed. Please install it from: https://www.xquartz.org/"
    exit 1
fi

# Check if XQuartz is running, start it if not
if ! pgrep -x "XQuartz" > /dev/null; then
    echo "Starting XQuartz..."
    open -a XQuartz
    echo "Waiting for XQuartz to start..."
    sleep 5
    
    # Check again after waiting
    if ! pgrep -x "XQuartz" > /dev/null; then
        echo "Failed to start XQuartz. Please start it manually and ensure:"
        echo "1. XQuartz > Preferences > Security > 'Allow connections from network clients' is checked"
        echo "2. XQuartz is fully loaded"
        exit 1
    fi
fi

# Get the IP address that Docker can reach on macOS
IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
if [ -z "$IP" ]; then
    # Fallback to localhost if en0 doesn't work
    IP="127.0.0.1"
fi

# Set display to point to the Mac's IP
export DISPLAY=$IP:0

# Allow connections from the IP address
echo "Allowing X11 connections from $IP..."
xhost +$IP

# Also allow localhost connections as fallback
xhost +localhost

export UID=$(id -u)
export GID=$(id -g)

echo "Starting Sonic Pi with DISPLAY=$DISPLAY"
echo "If this fails, please check that:"
echo "1. XQuartz is running"
echo "2. XQuartz > Preferences > Security > 'Allow connections from network clients' is enabled"
echo "3. You may need to restart XQuartz after changing preferences"

# Run the Docker container
docker compose --profile x11 run --remove-orphans -it --rm sonicpi

# Clean up X11 permissions
echo "Cleaning up X11 permissions..."
xhost -$IP
xhost -localhost

#!/bin/bash

#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ./run-compose-x11-macos.sh
    exit $?
fi

# Allow the container to connect to your X server
xhost +si:localuser:$(whoami)

export UID=$(id -u)
export GID=$(id -g)

XAUTH=/tmp/.docker.xauth
touch "$XAUTH"
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
chmod 644 "$XAUTH"

# docker compose --profile x11 up --build
docker compose --profile x11 run --remove-orphans -it --rm sonicpi

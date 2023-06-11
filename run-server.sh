#!/bin/bash

set -e
set -o pipefail

# get some environment variables
set -o allexport
source config/world-server.env
set +o allexport

# start the containers
docker compose -p world-server \
  --env-file config/world-server.env \
  -f compose.yaml \
  up --build

echo "Db server running on port: ${DB_PORT}"
echo "Tile server running on port: ${TILE_PORT}"

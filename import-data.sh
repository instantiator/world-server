#!/bin/bash

brew install osm2pgsql --quiet

set -e
set -o pipefail

# get some environment variables
set -o allexport
source config/world-server.env
set +o allexport

osm2pgsql --database=${DATABASE_URL_LOCAL} \
  --create data/great-britain-latest.osm.pbf

#!/bin/bash

set -e
set -o pipefail

DATA_FILE=great-britain-lastest.osm.pbf
BACKUP_FILE=great-britain-lastest.osm.pbf.backup

# backup existing data
pushd data
if test -f "$BACKUP_FILE"; then
    rm $BACKUP_FILE
fi
if test -f "$DATA_FILE"; then
    mv $DATA_FILE $BACKUP_FILE
fi

# data comes from Geofabrik. See: http://download.geofabrik.de/europe/great-britain.html
wget http://download.geofabrik.de/europe/great-britain-latest.osm.pbf
popd data

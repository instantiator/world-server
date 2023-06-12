#!/bin/bash

set -e
set -o pipefail

# data comes from Geofabrik. See: http://download.geofabrik.de/europe/great-britain.html
DATA_PATH=europe
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

wget http://download.geofabrik.de/${DATA_PATH}/${DATA_FILE}
popd data

#!/bin/bash

set -e
set -o pipefail

# defaults
ALL=false
DATA="data/great-britain-latest.osm.pbf"
SCRIPT="scripts/import-campsites.lua"

# definitions
usage() {
  cat << EOF
Import data from a provided .osm.pbf file into a local postgis database.

Options:
    -d <path>     --data <path>       Specify the .osm.pbf data source
    -s            --script <path>     Control import activity with a lua script
    -a            --all               Import all data from the data source
    -h            --help              Prints this help message and exits

Defaults:
    -a $ALL
    -d $DATA
    -s $SCRIPT
EOF
}

# parameters
while [ -n "$1" ]; do
  case $1 in
  -d | --data)
    shift
    DATA=$1
    ;;
  -s | --script)
    shift
    ALL=false
    SCRIPT=$1
    ;;
  -a | --all)
    ALL=true
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  *)
    echo -e "Unknown option $1...\n"
    usage
    exit 1
    ;;
  esac
  shift
done

echo "Data: $DATA"
echo "All: $ALL"
echo "Script: $SCRIPT"

# check for and install osm2pgsql if not found
if brew ls --versions osm2pgsql > /dev/null; then
  echo "osm2pgsql is installed"
else
  echo "installing osm2pgsql..."
  brew install osm2pgsql --quiet
fi
echo

# get some environment variables
set -o allexport
source config/world-server.env
set +o allexport

if [ -z $DATA ]; then 
  echo "Please indicate which data file to use for the import.";
  usage
  exit 1  
fi

if [[ "$ALL" == false ]] && [ -z $SCRIPT ]; then
  echo "Please indicate a script or set the --all flag to indicate that all data should be imported."
  usage
  exit 1
fi

if [[ "$ALL" == true ]]; then
  echo "Importing all data..."
  osm2pgsql --database=${DATABASE_URL_LOCAL} --create $DATA
  exit 0
else
  if [ ${SCRIPT:+x} ]; then
    echo "Importing data with script: $SCRIPT"
    if [[ -f "$SCRIPT" ]]; then
      osm2pgsql --database=${DATABASE_URL_LOCAL} -O flex -S $SCRIPT --create $DATA
      exit 0
    else
      echo "Script not found: $SCRIPT"
      exit 1
    fi
  else
    echo "Script not provided."
    exit 1
  fi
fi
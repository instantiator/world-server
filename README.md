# world-server

Tools and scripts to host your own postgis database and tile server using [OpenStreetMap](https://www.openstreetmap.org/) data.

## Scripts

| script              | purpose                                                                                                                       |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `update-data.sh`    | Retrieves fresh data from [Geofabrik](http://download.geofabrik.de/europe/great-britain.html)                                 |
| `run-server.sh`     | Launches a [PostGIS](https://postgis.net/) database and [pg_tileserv](https://github.com/CrunchyData/pg_tileserv) tile server |
| `import-data.sh`    | Imports data into the database, using [osm2pgsql](https://osm2pgsql.org/)                                                     |
| `test-open-tile.sh` | Opens a browser view with a single tile showing the topmost world view                                                        |

_NB. `update-data.sh` is currently untested._

## Getting started

- Run `update-data.sh` to fetch a fresh copy of `data/great-britain-latest.osm.pbf`
- Run `run-server.sh` to start the database and tile server
- Run `time import-data.sh` to import all data into the database (NB. this can take a while...)
- Run `test-open-tile.sh` to view the topmost tile and assure yourself the data has imported

### Import times

Please submit additional data to help establish some import expectations...

| file                           | system               | import time |
| ------------------------------ | -------------------- | ----------- |
| `great-britain-latest.osm.pbf` | Macbook Pro M1, 2020 | TBC         |

## Security

_This application is assumed to be running on your personal machine and exposed, at most, to your local home network. In order to use it in any other context, you will need to take some precautionary steps..._

**The database password is published in this repository.** This means it is not safe. Do not use this password in production. Modify the values found in: `config/word-server.env` and do not commit these values to your repository if public.

**The tile server runs over HTTP.** Do not expose this tile server to the internet! Put it behind [NGINX](https://www.nginx.com/) or another suitable proxy.

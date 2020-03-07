#!/bin/bash
#title        : init.sh
#description  : Initializes by creating `.env` and external NETWORK defined in `.env`
#author       : abmruman
#usage        : `./scripts/init.sh` OR `make init`

set -e

source ./scripts/color.sh

docker version || (echo "${RED}docker: make sure docker is running.${RESET}" && exit 1)
docker-compose version || (echo "${RED}docker-compose: make sure docker-compose installed.${RESET}" && exit 1)
which htpasswd || (echo "${RED}htpasswd: apache2-utils required.${RESET} 'sudo apt-get install apache2-utils'" && exit 1)

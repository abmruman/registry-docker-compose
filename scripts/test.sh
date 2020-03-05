#!/bin/bash
#title        : test.sh
#description  : tests
#author       : abmruman
#usage        : `./scripts/test.sh` OR `make test`

set -ev

shopt -s expand_aliases
alias curl="curl -ILsS -X GET"
alias grep="grep -A 5 --color=auto"
alias echo="echo -e"


eval $(egrep '^HOST' .env | xargs)

curl $HOST | grep '200 OK' || exit 1
echo
curl $HOST/v2 | grep '200 OK' || exit 1
echo
curl $HOST/v2/_catalog | grep '200 OK' || exit 1
echo

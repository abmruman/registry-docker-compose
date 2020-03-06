#!/bin/bash
#title        : test.sh
#description  : tests
#author       : abmruman
#usage        : `./scripts/test.sh` OR `make test`

set -e
source ./scripts/color.sh

shopt -s expand_aliases
alias curl="curl -ILsS -X GET"
alias egrepc="egrep -o --color=auto"
alias echoe=" echo -e"

[[ -z "$HOST" ]] && eval $(egrep '^HOST' .env | xargs)

checkmark="$GREEN\xE2\x9C\x94 $RESET"
crossmark="$RED\xE2\x9D\x8C $RESET"
regex='HTTP/[12]([\.][0-9])? 200'

echoe "crul $YELLOW$HOST$RESET: "
curl $HOST | egrepc "$regex" && echoe "$checkmark PASSED" || echoe "$crossmark FAILED"
echo
echoe "crul $YELLOW$HOST/v2: "
curl $HOST/v2 | egrepc "$regex" && echoe "$checkmark PASSED" || echoe $crossmark "FAILED"
echo
echoe "crul $YELLOW$HOST/v2/_catalog$RESET: "
curl $HOST/v2/_catalog | egrepc "$regex" && echoe "$checkmark PASSED" || echoe $crossmark "FAILED"
echo

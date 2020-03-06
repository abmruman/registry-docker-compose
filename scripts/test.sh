#!/bin/bash
#title        : test.sh
#description  : tests registry HTTP status with curl
#author       : abmruman
#usage        : `./scripts/test.sh` OR `make test`

set -e

source ./scripts/color.sh

FAILED=0

shopt -s expand_aliases
alias curlf="curl -ILsS -X GET"
alias egrepc="egrep -o --color=auto"
alias echoe=" echo -e"

curl_test_200() {
  checkmark="$GREEN\xE2\x9C\x94 $RESET"
  crossmark="$RED\xE2\x9D\x8C $RESET"
  pattern='HTTP/[0-9]([\.][0-9])? 200'

  match=`curlf $1 | egrepc -c "$pattern"`

  if [ "$match" -gt 0 ] ; then
    echoe "$checkmark PASSED"
    status=0
  else
    echoe "$crossmark FAILED"
    status=1
  fi
  echo
}

test_uri() {
  echo
  uri="$1"
  echoe "${YELLOW}Testing URI:${RESET} $1"

  curl_test_200 "$uri" || (echo $? >/dev/null)
  [[ $status -gt 0 ]] && FAILED=1
  curlf "$uri"
}


[[ -z "$HOST" ]] && eval $(egrep '^HOST' .env | xargs)

test_uri "$HOST"
test_uri "$HOST/v2"
test_uri "$HOST/v2/_catalog"


exit $FAILED

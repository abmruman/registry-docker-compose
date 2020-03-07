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

CHECKMARK="$GREEN\xE2\x9C\x94 $RESET"
CROSSMARK="$RED\xE2\x9D\x8C $RESET"

curl_test_200() {
  pattern='HTTP/[0-9]([\.][0-9])? 200'
  if [ -z "$2" ] ; then
    match=`curlf $1 | egrepc -c "$pattern"`
  else
    match=`curlf --anyauth -u $2 $1 | egrepc -c "$pattern"`
  fi

  if [ "$match" -gt 0 ] ; then
    echoe "$CHECKMARK PASSED"
    status=0
  else
    echoe "$CROSSMARK FAILED"
    status=1
  fi
  echo
}

test_uri() {
  echo
  uri="$1"
  auth="$2"
  echoe "${YELLOW}Testing URI:${RESET} $1"

  curl_test_200 "$uri" "$auth" || (echo $? >/dev/null)
  [[ $status -gt 0 ]] && FAILED=1

  [[ -z "$auth" ]] && curlf "$uri" || curlf --anyauth -u "$auth" "$uri"
}


[[ -z "$HOST" ]] && eval $(egrep '^HOST' .env | xargs)
[[ -z "$USERS_FILE" ]] && eval $(egrep '^USERS_FILE' .env | xargs)

echo pass | htpasswd -iB auth/$USERS_FILE testuser

test_uri "$HOST"
test_uri "$HOST/v2" "testuser:pass"
test_uri "$HOST/v2/_catalog" "testuser:pass"

htpasswd -D auth/$USERS_FILE testuser
echo
echo

[[ "$FAILED" = 0 ]] \
  && echoe "$CHECKMARK$CHECKMARK$GREEN ALL TESTS PASSED$RESET" \
  || echoe "$CROSSMARK$CROSSMARK$RED TEST(S) FAILD$RESET"

exit $FAILED

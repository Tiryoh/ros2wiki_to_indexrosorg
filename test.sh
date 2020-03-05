#!/usr/bin/env bash
set -eu

SRC_DIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

FLAG=0

test_url () {
	local TARGET_URL=${1}
	local HTTP_STATUS=`curl -I ${TARGET_URL} -o /dev/null -w '%{http_code}\n' -s`
	if [[ ${HTTP_STATUS} -eq "200" ]]; then
		echo OK
	else
		echo ERR ${HTTP_STATUS} ${TARGET_URL}
		FLAG=1
	fi
}

for url in `cat ${SRC_DIR}/url.csv | grep http | sed -E "s/.*,.*(https.*)$/\1/g"`; do
	test_url "${url}"
	sleep 1
done

if [[ ${FLAG} -eq "1" ]]; then
	exit 1
fi

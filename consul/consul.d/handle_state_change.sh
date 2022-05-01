#!/bin/sh

# https://www.consul.io/api-docs/kv
# Using watcher output: 
#   https://stackoverflow.com/questions/67332879/get-failed-service-name-inside-consul-watch-handler
#   https://stackoverflow.com/questions/67085312/passing-more-information-to-consul-watch-handler
#   https://serverfault.com/questions/1033983/consul-script-handler-stdout-not-showing-up-in-logs-as-documented


set -e

read event_payload # event_payload is the payload from consul watcher
echo "The value of the key is $(echo $event_payload )"

dt=$(date '+%d/%m/%Y %H:%M:%S');
database=$1;

curl \
    --request PUT \
    --data "{ \"updated_at\": \"$dt\", \"payload\": $event_payload }" \
    http://127.0.0.1:8500/v1/kv/$database


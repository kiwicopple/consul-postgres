#!/bin/sh

set -e

export PGPASSWORD=$5
psql -h $1 -p $2 -U $3 -d $4 \
     -c '
     show wal_level;
     '

echo $?

exit 0 # exit successfully
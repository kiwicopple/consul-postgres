#!/bin/sh

set -e

export PGPASSWORD=$5
psql -h $1 -p $2 -U $3 -d $4 --quiet # check if it's accepting connections

# https://www.postgresql.org/docs/current/app-pg-isready.html
# 0 = accepting connections
# 1 = rejecting connections
# 2 = no response

# We could do a loop if there is a response 2, but for now we will fail immediately

if [ $? -eq "0" ]
then
    exit 0
else
    exit -1 # Postgres is not accepting connections
fi       

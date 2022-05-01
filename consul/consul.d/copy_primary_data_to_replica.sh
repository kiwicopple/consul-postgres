#!/bin/bash

# https://github.com/reactive-tech/kubegres/blob/b733b736b5845679250b121cdbf43986842445ef/controllers/spec/template/yaml/BaseConfigMapTemplate.yaml
# 
# This script replicates data from the Primary PostgreSql to the Replica database.
# It is executed once, the 1st time a Replica PostgreSql container is created.
# It is run in Replica containers.
#
# If you modify this script, there is a risk of breaking the operator.
#
# This script will be located in the folder "/tmp"

set -e

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt - Attempting to copy Primary DB to Replica DB...";

if [ -z "$(ls -A $PGDATA)" ]; then

    echo "$dt - Copying Primary DB to Replica DB folder: $PGDATA";
    echo "$dt - Running: pg_basebackup -R -h $PRIMARY_HOST_NAME -D $PGDATA -P -U replication;";

    pg_basebackup -R -h $PRIMARY_HOST_NAME -D $PGDATA -P -U replication;

    if [ $UID == 0 ]
    then
    chown -R postgres:postgres $PGDATA;
    fi

    echo "$dt - Copy completed";
    
else
    echo "$dt - Skipping copy from Primary DB because Replica DB already exists";
fi

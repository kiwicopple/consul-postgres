#!/bin/bash

# https://github.com/reactive-tech/kubegres/blob/b733b736b5845679250b121cdbf43986842445ef/controllers/spec/template/yaml/BaseConfigMapTemplate.yaml
# 
# This script promotes a Replica to a Primary by creating a trigger-file signaling PostgreSql to start the promotion process.
# It is executed once, when a Replica is set to become a Primary.
# It is run in a selected Replica container by the operator.
#
# If you modify this script, there is a risk of breaking the operator.
#
# This script will be located in the folder "/tmp"

set -e

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt - Attempting to promote a Replica PostgreSql to Primary...";

standbyFilePath="$PGDATA/standby.signal"

if [ ! -f "$standbyFilePath" ]; then
    echo "$dt - Skipping as this PostgreSql is already a Primary since the file '$standbyFilePath' does not exist."
    exit 0
fi

promotionTriggerFilePath="$PGDATA/promote_replica_to_primary.log"

if [ -f "$promotionTriggerFilePath" ]; then
    echo "$dt - Skipping as the promotion trigger file '$promotionTriggerFilePath' already exists"
    exit 0
fi

echo "$dt - Promoting by creating the promotion trigger file: '$promotionTriggerFilePath'"
touch $promotionTriggerFilePath

#!/bin/bash

set -e -u

series=$1
release=$2

CHARM_CHANNEL=edge
declare -A CHARM_TRACK

# This variable is set to avoid an "undefined" error but otherwise not used
ceph_release=octopus

SCRIPT_DIR=$(dirname $0)

. ${SCRIPT_DIR}/../charm_lists
. ${SCRIPT_DIR}/${series}
if [[ -f ${SCRIPT_DIR}/${series}-${release} ]]; then
  . ${SCRIPT_DIR}/${series}-${release}
fi
. ${SCRIPT_DIR}/any_series

output=$(mktemp)

for charm in \
  hacluster \
  mysql-{router,innodb-cluster} \
  ovn-{central,chassis,dedicated-chassis} \
  percona-cluster \
  rabbitmq-server \
  vault
do
  if [[ -v CHARM_TRACK[${charm}] ]]; then
    echo "${charm} ${CHARM_TRACK[${charm}]}" >> ${output}
  else
    echo "${charm} unset" >> ${output}
  fi
done
cat ${output} | column --table
rm ${output}

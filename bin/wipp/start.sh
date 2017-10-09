#!/bin/bash
#
network_name="wipp_net"
db_volume="mongo_wipp_data"
backend_memory="4G"

db_service="mongo_wipp"
master_service="wipp_master"
execute_service="wipp_exec"
wipp_service="wipp"


docker network create --driver overlay ${network_name}

# MongoDB container
echo "Starting mongo..."
docker service create --network ${network_name} --name ${db_service} \
                      --mount type=volume,source=${db_volume},destination=/data/db \
                      --constraint "node.labels.type == mdw" \
                      mongo:3.4

echo "Waiting for mongo to finish startup..."
while [ `docker service ls -f "name=${db_service}" --format "{{.Replicas}}"` != "1/1" ]
do
    sleep 5
done

# Master container
echo "Starting master..."
docker service create --network ${network_name} --name ${master_service} \
                      --constraint "node.labels.type == mdw" \
                      dscnaf/htcondor-debian:release-0.2.0 -m


echo "Waiting for master to finish startup..."
while [ `docker service ls -f "name=${master_service}" --format "{{.Replicas}}"` != "1/1" ]
do
    sleep 5
done

echo "Starting executor and frontend..."

# Executor container
docker service create --network ${network_name} --name ${execute_service} \
                      --mount type=bind,source=/mnt/wippdata,destination=/data/WIPP \
                      --constraint "node.labels.type == wkr" \
                      wipp/wipp_executor:1.1.0 -e ${master_service} \
                      ${backend_memory}

# WIPP container
docker service create --network ${network_name} --name ${wipp_service} \
                      --mount type=bind,source=/mnt/data/wipp,destination=/data/WIPP \
                      --mount type=volume,source=pegasus_home,destination=/home/wipp/.pegasus \
                      --mount type=volume,source=pegaus_workflows,destination=/data/pegasus-workflows \
                      --constraint "node.labels.type == frt" \
                      -p 50102:5005 -p 50103:8080 \
                      wipp/wipp:1.1.0 ${master_service} ${db_service}


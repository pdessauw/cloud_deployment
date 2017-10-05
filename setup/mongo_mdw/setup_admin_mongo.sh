#!/bin/bash
CONTAINER="integ_mongo_curator"
HOST=`docker ps -f "name=${CONTAINER}" --format "{{.Names}}"`
ADMIN_USER="admin"
ADMIN_PWD="admin"

echo "Creating admin user..."
docker cp admin.js $HOST:/
docker exec $HOST mongo admin admin.js

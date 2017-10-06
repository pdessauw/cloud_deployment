#!/bin/bash
LOOKUP="ocr_master"
HOST=`docker ps -f "name=${LOOKUP}" --format {{.Names}}`

docker exec -it $HOST tail -f /var/log/ocrpipe/app.log


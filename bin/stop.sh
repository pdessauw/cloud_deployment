#!/bin/bash
docker stack rm integ

# Check that containers are being shutdown
watch -n1 docker ps -aq

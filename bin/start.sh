#!/bin/bash
export STACK="integ"
env STACK=$STACK docker stack deploy -c docker-compose.yml $STACK

# Check service startup
if [ $? == 0 ]
then
	watch -n1 docker service ls
fi

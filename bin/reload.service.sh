#!/bin/bash
if [ $# != 1 ]
then
	echo "Wrong number of parameters ($# given). Expected parameter are: service_name"
fi

docker service update --force $1

# Check service reboot
docker service logs -f $1

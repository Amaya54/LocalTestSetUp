#!/bin/bash

# delete all previous images

# default gmp-stack_

GREP_STRING="localtest_*"

# Delete all the container with GREP_STRING regex
docker ps -a | awk '{ print $1,$2 }' | grep $GREP_STRING | awk '{print $1 }' | xargs -I {} docker rm {}

# After removing container remove the container now delete the images
docker rmi -f $(docker images | grep $GREP_STRING )

# To remove any untagged docker images
docker rmi -f $(docker images | grep "^<none>" | awk "{print $3}")
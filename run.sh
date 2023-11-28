#!/bin/bash

REPOSITORY_NAME="$(basename "$(dirname -- "$( readlink -f -- "$0"; )")")"

docker run -it --rm \
--network=host \
--ipc=host \
--pid=host \
--env UID=$(id -u) \
--env GID=$(id -g) \
--volume $(pwd)/livox_ros_driver2:/colcon_ws/src/livox_ros_driver2 \
--volume $(pwd)/Livox-SDK2:/Livox-SDK2 \
ghcr.io/rosblox/${REPOSITORY_NAME}:humble

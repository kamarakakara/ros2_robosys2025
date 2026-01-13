#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd "$dir/ros2_ws" || exit 1
colcon build || exit 1
source "$dir/.bashrc"

timeout 120 ros2 launch ros2_robosys2025 talk_listen.launch.py \
  > /tmp/ros2_robosys2025.log

tail -n +5 /tmp/ros2_robosys2025.log \
| grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' \
| uniq -c \
| awk '$1 >= 5 { exit 0 } END { exit 1 }'

exit $?


#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd "$dir/ros2_ws" || exit 1
colcon build || exit 1
source "$dir/.bashrc"


timeout 40 ros2 launch ros2_robosys2025 talk_listen.launch.py \
  > /tmp/ros2_robosys2025.log &
LAUNCH_PID=$!

(
  sleep 5
  ros2 topic pub --once /ram_usage std_msgs/msg/Float32 "{data: 90.0}"
) &

wait $LAUNCH_PID

count=$(tail -n +5 /tmp/ros2_robosys2025.log \
  | grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' \
  | wc -l)

cat /tmp/ros2_robosys2025.log

if [ "$count" -ge 4 ]; then
  exit 0
else
  exit 1
fi

#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source $dir/.bashrc
timeout 10 ros2 launch ros2_robosys2025 talk_listen.launch.py > /tmp/ros2_robosys2025.log

cat /tmp/ros2_robosys2025.log |
grep 'Current usage'

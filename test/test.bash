#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd "$dir/ros2_ws" || exit 1
colcon build || exit 1
source "$dir/.bashrc"


# 自動更新
timeout 40 ros2 launch ros2_robosys2025 talk_listen.launch.py \
  > /tmp/ros2_robosys2025.log

count=$(tail -n +5 /tmp/ros2_robosys2025.log \
| grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' \
| wc -l)


# 80を上回る、下回る
ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 50.00}"

ros2 run my_package listener &  # バックグラウンドで起動
LISTENER_PID=$!
sleep 5

ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 90}"
sleep 5

ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 50.00}"


sleep 2
kill $LISTENER_PID 2>/dev/null



total_count=$(grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' /tmp/ros2_robosys2025.log | wc -l)


if [ "$total_count" -ge 5 ]; then
  exit 0
else
  exit 1
fi


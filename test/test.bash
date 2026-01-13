#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd "$dir/ros2_ws" || exit 1
colcon build || exit 1
source "$dir/.bashrc"

LOG_FILE=/tmp/ros2_robosys2025.log
> "$LOG_FILE"


# 自動更新
timeout 40 ros2 launch ros2_robosys2025 talk_listen.launch.py > "$LOG_FILE"

count_auto=$(tail -n +5 "$LOG_FILE" \
  | grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' \
  | wc -l)


# 80を上回る、下回る
ros2 run my_package listener &
LISTENER_PID=$!
sleep 2

ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 50.00}"
sleep 5
ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 90}"
sleep 5
ros2 topic pub --once /rum_usage std_msgs/msg/Float32 "{data: 50.00}"
sleep 2

kill $LISTENER_PID 2>/dev/null

count_listener=$(tail -n +2 "$LOG_FILE" \
  | grep -E '^\[listener-[0-9]+\][[:space:]]+(0\.[0-9]+|[1-9][0-9]*(\.[0-9]+)?)$' \
  | wc -l)

# 合計
count=$((count_auto + count_listener))

if [ "$count" -eq 5 ]; then
  exit 0
else
  exit 1
fi


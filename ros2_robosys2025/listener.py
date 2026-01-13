#!/usr/bin/env python3
#SPDX-FileCopyrightText: 2025 Kamarakakara
#SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32
import time

WARNING_THRESHOLD = 80.0
is_warning = False
latest_usage = None
has_printed_initial = False

def callback(msg):
    global is_warning, latest_usage

    latest_usage = msg.data

    if latest_usage > WARNING_THRESHOLD and not is_warning:
        print("{latest_usage:.2f}", flush=True)
        is_warning = True

    elif latest_usage <= WARNING_THRESHOLD and is_warning:
        print(f"{latest_usage:.2f}", flush=True)
        is_warning = False

def main():
    global has_printed_initial

    rclpy.init()
    node = Node("ram_listener")

    node.create_subscription(
        Float32,
        "ram_usage",
        callback,
        10
    )

    last_print_time = time.time()

    try:
        while rclpy.ok():
            rclpy.spin_once(node, timeout_sec=1.0)
            now = time.time()

            if latest_usage is not None and not has_printed_initial:
                print(f"{latest_usage:.2f}", flush=True)
                has_printed_initial = True
                last_print_time = now

            elif latest_usage is not None and (now - last_print_time) >= 30.0:
                print(f"{latest_usage:.2f}", flush=True)
                last_print_time = now

    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()


if __name__ == "__main__":
    main()


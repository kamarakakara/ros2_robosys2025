#!/usr/bin/env python3
#SPDX-FileCopyrightText: 2025 Kamarakakara
#SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32
import time

def get_memory_usage():
    with open("/proc/meminfo", "r") as f:
        meminfo = f.readlines()

    mem_total = 0
    mem_available = 0

    for line in meminfo:
        if "MemTotal" in line:
            mem_total = int(line.split()[1])
        elif "MemAvailable" in line:
            mem_available = int(line.split()[1])

    used = mem_total - mem_available
    return (used / mem_total) * 100.0


def main():
    rclpy.init()
    node = Node("ram_talker")
    pub = node.create_publisher(Float32, "ram_usage", 10)

    try:
        while rclpy.ok():
            msg = Float32()
            msg.data = get_memory_usage()
            pub.publish(msg)
            time.sleep(1)

    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()


if __name__ == "__main__":
    main()


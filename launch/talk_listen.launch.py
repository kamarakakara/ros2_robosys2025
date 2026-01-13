import launch
import launch.actions
import launch.substitutions
import launch_ros.actions


def generate_launch_description():

    talker = launch_ros.actions.Node(
        package='ros2_robosys2025',
        executable='talker',
        emulate_tty=False
    )

    listener = launch_ros.actions.Node(
        package='ros2_robosys2025',
        executable='listener',
        output='screen'
    )

    return launch.LaunchDescription([talker, listener])


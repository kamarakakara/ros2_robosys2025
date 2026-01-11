import launch
import launch.actions
import launch.substitutions
import launch_ros.actions


def generate_launch_description():

    # talker: 端末出力なし、ログも残さず
    talker = launch_ros.actions.Node(
        package='ros2_robosys2025',
        executable='talker',
        output='log',        # 端末には出力されない
        emulate_tty=False     # flush 対応を安定させる
    )

    # listener: 端末に出力
    listener = launch_ros.actions.Node(
        package='ros2_robosys2025',
        executable='listener',
        output='screen'
    )

    return launch.LaunchDescription([talker, listener])


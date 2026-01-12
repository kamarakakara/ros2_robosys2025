# メモリチェッカー
## 概要
本パッケージはメモリの使用率の通知を行います。

## 使用方法
- launchを用いて一括で起動する方法
```
$ ros2 launch ros2_robosys2025 talk_listen.launch.py
[INFO] [launch]: All log files can be found below 
[INFO] [launch]: Default logging verbosity is set to INFO
[INFO] [talker-1]: process started with pid [218675]
[INFO] [listener-2]: process started with pid [218677]
[listener-2] Current usage : 10.46%
```
- 個別に起動する方法
1. talker
```
$ ros2 run ros2_robosys2025 talker
```
2. listener
```
$ ros2 run ros2_robosys2025 listener
Current usage : 10.60%
```
 
## ノード一覧
### ram_talker
メモリの使用率を計算し、計算結果をトピックとしてpublishする。

### ram_listener
publishされたメモリ使用率をsubscribeし、30秒毎に通知を行う。
使用率が80[%]を超過すると通知を行い、80[%]未満に戻った際も通知を行う。


## トピック
| トピック名 | 型 | 内容 |
| :--- | :--- | :--- |
| `/ram_usage` | `std_msgs/msg/Float32` | メモリの使用率[%] |

## テスト環境
- ubuntu-22.04 LTS
- ROS2 Humble
- Python 3.10.12

## 著作権・ライセンス
- このソフトウェアパッケージは、3条項BSDライセンスの下、再頒布および使用が許可されます。
- このパッケージは、下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを参考に製作され、本人の許可を得て自身の著作としたものです。
    - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 kamarakakara

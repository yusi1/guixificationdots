#!/usr/bin/env bash

rofi="rofi -dmenu -p MPD"

HOST="127.0.0.1"
PORT="6600"

mpc="mpc -h 127.0.0.1 -p 6600"

state=$($mpc | awk '/playing/ || /paused/' | awk '{print $1}')
song="$mpc | head -n1"
output="echo $state $song | rofi -dmenu"

echo "${state}"

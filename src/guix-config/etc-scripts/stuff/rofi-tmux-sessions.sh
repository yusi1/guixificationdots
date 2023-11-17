#!/bin/bash

session=$(tmux list-sessions | rofi -dmenu -p "tmux-sessions" | awk '{print $1}' | sed 's/\://g')

if [[ -n ${session} ]]; then
   case "${session}" in
    "new" )
	gnome-terminal -- tmux new-session
	;;
    *)
	gnome-terminal -- tmux attach -t ${session}
	;;
   esac
else
    exit 1
fi

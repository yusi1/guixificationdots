#!/bin/bash

if [ $(pgrep xfce4-volumed-pulse) ]; then
    exit 1
else
    xfce4-volumed-pulse --no-daemon
fi

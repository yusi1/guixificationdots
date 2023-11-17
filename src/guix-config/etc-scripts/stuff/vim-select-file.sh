#!/bin/sh

FILE=$(zenity --file-selection)

case $? in
    0 )
        vim -g "${FILE}" ;;
    1 )
        echo "You did not select a file!" ;;
    -1 )
        echo "Error occurred, please try again." ;;
esac

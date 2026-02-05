#!/bin/bash

cecho()
{
    if [ "$1" = "COL" ]; then
        shift
        color="$1"
        shift
    fi
    echo -ne "\033[${color}m$*\033[0m" 
}

while true; do 
    # for ((i=0; i<31; i++)); do
    # for ((i=0; i<90; i++)); do
    for ((i=0; i<60; i++)); do
        cecho COL $1 "$(($RANDOM*10/32767))$2"
    done
    echo
    sleep 0.1
    # sleep 0.2
done

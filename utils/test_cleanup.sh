#!/bin/bash
cleanup() {
    tput cnorm
    # Решение 1: переместить курсор
    tput cup $(( $(tput lines) - 2 )) 0 2>/dev/null
    clear
    echo -e "\nTest complete\n"
    exit 0
}
trap cleanup INT TERM

tput civis
clear
height=$(tput lines)
width=$(tput cols)

# Заполняем весь экран
for ((i=0; i<height; i++)); do
    line=""
    for ((j=0; j<width; j++)); do
        line+="X"
    done
    if (( i < height - 1 )); then
        echo "$line"
    else
        echo -n "$line"  # Без \n для последней строки
    fi
done

sleep 2
cleanup
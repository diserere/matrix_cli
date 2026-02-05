#!/usr/bin/env bash

# Тестирование координат tput

# Конфигурация
WIDTH=$(tput cols)
HEIGHT=$(tput lines)

# Цвета из 256-цветной палитры (зеленые оттенки)
COLORS=(
    "\033[38;5;120m"    # 0: Очень яркий зеленый
    "\033[38;5;46m"     # 1: Яркий зеленый
    "\033[38;5;40m"     # 2: Зеленый
    "\033[38;5;34m"     # 3: Темно-зеленый
    "\033[38;5;28m"     # 4: Очень темный зеленый
    "\033[38;5;22m"     # 5: Самый темный зеленый
)
RESET="\033[0m"

clear

# tput setaf 1
# echo "Hello World"
# tput sgr0
# echo "Hello World"

echo "WIDTH: ${WIDTH}"
echo "HEIGHT: ${HEIGHT}"

sleep 2

for ((x=0; x<${WIDTH}; x++)); do
    for ((y=0; y<${HEIGHT}; y++)); do
        COLOR=${COLORS[5]}
        # if [[ x -eq 0 -o y -eq 0 ]]; then
        if [[ x -eq 0 || x -eq WIDTH-1 || y -eq 0 || y -eq HEIGHT-1 ]]; then
            COLOR=${COLORS[0]}
        fi
        tput cup $y $x
        echo -en "${COLOR}.${RESET}"
    done
done

sleep 2
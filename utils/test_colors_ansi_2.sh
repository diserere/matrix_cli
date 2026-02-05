#!/usr/bin/env bash

# https://gist.github.com/JBlond/2fea43a3049b38287e5e9cefc87b2124


for code in {0..255}; do echo -e "\e[38;5;${code}m"'\\e[38;5;'"$code"m"\e[0m"; done

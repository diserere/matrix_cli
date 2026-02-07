#!/usr/bin/env bash

# Matrix CLI - Matrix-like console animation
# Version: 0.1.2
# Author: diserere
# GitHub: https://github.com/diserere/matrix_cli

# Press Ctrl+C to exit


# Version info
VERSION="0.1.2"
AUTHOR="diserere"
REPO_URL="https://github.com/diserere/matrix_cli"


# Конфигурация
SPEED=0.05
UPDATE_URL="https://raw.githubusercontent.com/diserere/matrix_cli/refs/heads/master/matrix.sh"

# Массивы для хранения данных колонок
declare -a positions
declare -a lengths
declare -a speeds

# Символы
CHARS_FULL="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#$%^&*()"
CHARS_BINARY="01"


# Флаги
BINARY_MODE=0      # 0 = полный набор, 1 = двоичный
ERASE_MODE=0       # 0 = не стирать хвост, 1 = стирать
GRAYSCALE_MODE=0   # 0 = зеленый, 1 = оттенки серого
FLASH_EFFECT=0     # 0 = нет вспышек, 1 = есть вспышки
TEST_COLORS=0     # 0 = обычный режим, 1 = режим тестирования цветов


# Функция для очистки при выходе
cleanup() {
    tput cnorm
    # Очистка экрана
    clear
    echo -e "\n${COLORS[5]}Wake up Neo.${RESET}\n"
    exit 0
}
trap cleanup INT TERM

# Тестируем цвета
test_colors() {
    init_colors
    echo
    echo -e "Тест цветов:"
    echo -e "${COLORS[0]}█ Самый яркий      [ \\${COLORS[0]} ]"
    echo -e "${COLORS[1]}█ Яркий            [ \\${COLORS[1]} ]"
    echo -e "${COLORS[2]}█ Обыный           [ \\${COLORS[2]} ]"
    echo -e "${COLORS[3]}█ Темный           [ \\${COLORS[3]} ]"
    echo -e "${COLORS[4]}█ Очень темный     [ \\${COLORS[4]} ]"
    echo -e "${COLORS[5]}█ Самый темный     [ \\${COLORS[5]} ]${RESET}"
    echo
}

# Инициализация цветов
init_colors() {
    if [ $GRAYSCALE_MODE -eq 1 ]; then
        # Оттенки серого (256 цветов)
        COLORS=(
            "\033[38;5;255m"    # 0: Белый

            # "\033[38;5;252m"    # 1: Светло-серый
            # "\033[38;5;249m"    # 2: Серый
            # "\033[38;5;246m"    # 3: Темно-серый
            # "\033[38;5;243m"    # 4: Очень темный серый
            # "\033[38;5;240m"    # 5: Почти черный

            "\033[38;5;251m"    # 1: Светло-серый
            "\033[38;5;247m"    # 2: Серый
            "\033[38;5;243m"    # 3: Темно-серый
            "\033[38;5;239m"    # 4: Очень темный серый
            "\033[38;5;235m"    # 5: Почти черный
        )
        THEME_NAME="GRAYSCALE"
    else
        # Зеленые оттенки (256 цветов)
        COLORS=(
            "\033[38;5;120m"    # 0: Очень яркий зеленый
            "\033[38;5;46m"     # 1: Яркий зеленый
            "\033[38;5;40m"     # 2: Зеленый
            "\033[38;5;34m"     # 3: Темно-зеленый
            "\033[38;5;28m"     # 4: Очень темный зеленый
            "\033[38;5;22m"     # 5: Самый темный зеленый
        )
        THEME_NAME="GREEN"
    fi
    # Сброс цвета
    RESET="\033[0m"
}

# Инициализация символов
init_chars() {
    if [ $BINARY_MODE -eq 1 ]; then
        CHARS="$CHARS_BINARY"
        CHARS_MODE="BINARY"
    else
        CHARS="$CHARS_FULL"
        CHARS_MODE="FULL"
    fi
}

# Проверка зависимостей
check_dependencies() {
    for dep in $1; do
        # echo "Проверка наличия $dep..."
        if ! command -v ${dep} &> /dev/null; then
            echo "Ошибка: ${dep} не установлен" >&2
            exit 1
        fi
    done
}

# Обновление скрипта
update_script() {
    local script_path="$0"
    local backup_path="${script_path}.backup.$(date +%Y%m%d_%H%M%S)"
    local temp_path="${script_path}.new"
    
    # Создаем backup
    cp "${script_path}" "${backup_path}"
    echo "Резервная копия создана: ${backup_path}"
    
    # Загружаем обновление
    echo "Загрузка обновления с GitHub..."
    
    if curl -f -sS -L "${UPDATE_URL}" -o "${temp_path}" \
        && [[ -s "${temp_path}" ]] \
        && head -1 "${temp_path}" | grep -q "^#!"; then
        
        chmod +x "${temp_path}"
        
        # Тестовый запуск на синтаксис
        if bash -n "${temp_path}"; then
            mv "${temp_path}" "${script_path}"
            echo "✅ Обновление успешно завершено!"
            echo "Резервная копия сохранена в: ${backup_path}"
            echo
            echo "- new version info:"
            echo
            ${script_path} -v
            return 0
        else
            echo "Ошибка: синтаксическая ошибка в новом скрипте" >&2
            rm -f "${temp_path}"
            return 1
        fi
    else
        echo "Ошибка загрузки обновления" >&2
        rm -f "${temp_path}"
        return 1
    fi
}

# Парсинг аргументов командной строки
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -b|--binary)
                BINARY_MODE=1
                shift
                ;;
            -e|--erase)
                ERASE_MODE=1
                shift
                ;;
            -g|--grayscale)
                GRAYSCALE_MODE=1
                shift
                ;;
            -t|--test)
                TEST_COLORS=1
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            -u|--update)
                check_dependencies "curl"
                echo "Вы уверены, что хотите обновить скрипт до последней версии? [y/N]"
                read -r response
                if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                    update_script
                else
                    echo "Обновление отменено"
                fi
                exit 0
                ;;
            *)
                echo "Неизвестный аргумент: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Показать справку
show_help() {
    echo "Использование: $0 [опции]"
    echo ""
    echo "Опции:"
    echo "  -b, --binary        Использовать двоичные символы (0 и 1)"
    echo "  -e, --erase         Включить стирание хвоста колонок"
    echo "  -g, --grayscale     Использовать оттенки серого вместо зеленого"
    echo "  -t, --test          Вывод тестовой таблицы цветов"
    echo "  -v, --version       Show version information"
    echo "  -u, --update        Обновить до последней версии из Github repo"
    echo "  -h, --help          Показать эту справку"
    echo ""
    echo "Управление:"
    echo "  Ctrl+C            Выход"
}

# Показать версию
show_version() {
    cat << EOF
Matrix CLI v${VERSION}
A terminal simulation of The Matrix digital rain animation

Author: ${AUTHOR}
Repository: ${REPO_URL}
License: MIT
EOF
}


# Генератор случайной скорости
random_speed() {
    echo -n $((1 + RANDOM % 5))
}

# Генератор случайной длины
random_length() {
    echo -n $((10 + RANDOM % 12))
}

# Основной цикл анимации
do_matrix() {

    check_dependencies "tput"

    while true; do
        for ((i=0; i<WIDTH; i+=3)); do
            # Двигаем колонку вниз
            positions[$i]=$((positions[$i] + speeds[$i]))
            # Выравниваем колонку по нижнему краю экрана
            if [ ${positions[$i]} -ge $HEIGHT ]; then
                positions[$i]=$((HEIGHT-1))
            fi

            # Рисуем колонку по строкам вверх от головного символа
            for ((j=0; j<${lengths[$i]}; j++)); do
                # Отрисовка символа в колонке
                line_pos=$((positions[$i] - j))
                # Проверяем, находится ли в пределах экрана
                if [ $line_pos -ge 0 ] && [ $line_pos -lt $HEIGHT ]; then
                    # Выбираем символ
                    char=${CHARS:$((RANDOM % ${#CHARS})):1}
                    # Выбираем градиент цвета по позиции в колонке
                    # Голова (самый нижний): позиция 0
                    if [ $j -eq 0 ]; then
                        color_idx=0
                    # Символ в позиции 1
                    elif [ $j -eq 1 ]; then
                        color_idx=1
                    # Символы в позиции 2-3
                    elif [ $j -lt 4 ]; then
                        color_idx=2
                    # Символы в позиции 4-6
                    elif [ $j -lt 7 ]; then
                        color_idx=3
                    # Символы в позиции 7-9
                    elif [ $j -lt 10 ]; then
                        color_idx=4
                    # Остальные символы в позиции 10 и выше
                    else
                        color_idx=5
                    fi

                    # Устанавливаем позицию курсора и выводим символ с цветом
                    tput cup $line_pos $i 2>/dev/null
                    echo -ne "${COLORS[$color_idx]}${char}"
                fi
            done

            if [ "${ERASE_MODE}" = 1 ]; then
                # Стираем хвост
                if [ ${speeds[$i]} -eq 1 ]; then
                    erase=$((positions[$i] - lengths[$i]))
                    if [ $erase -ge 0 ] && [ $erase -lt $HEIGHT ]; then
                        tput cup $erase $i 2>/dev/null
                        echo -n " "
                    fi
                fi
            fi

            # Если колонка дошла до конца экрана
            if [ ${positions[$i]} -eq $((HEIGHT-1)) ]; then
                # Сбрасываем позицию и в части случаев генерируем новую длину и скорость
                positions[$i]=0
                if [ $((RANDOM % 2)) -eq 0 ]; then
                    lengths[$i]=$(random_length)
                    speeds[$i]=$(random_speed)
                fi
            fi

        done
        
        # Небольшая задержка
        sleep $SPEED
    done
}

# Инициализация
do_init() {
    WIDTH=$(tput cols)
    HEIGHT=$(tput lines)

    init_chars
    init_colors

    for ((i=0; i<WIDTH; i+=3)); do
        lengths[$i]=$(random_length)
        positions[$i]=-$((RANDOM % lengths[$i]))
        speeds[$i]=$(random_speed)
    done

    # Очистка экрана и скрытие курсора
    clear
    tput civis

    echo -e "\n${COLORS[5]}The Matrix has you...${RESET}"
    sleep 1
    clear
}

do_main() {
    if [ "${TEST_COLORS}" = 1 ]; then
        test_colors
        exit 0
    fi
    do_init
    # Запуск анимации
    do_matrix
}


# Main
parse_args "$@"
do_main
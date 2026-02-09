#!/usr/bin/env bash

# Matrix CLI - Matrix-like console animation
# Version: 0.2.1
# Author: diserere
# GitHub: https://github.com/diserere/matrix_cli

# Press Ctrl+C to exit


# Version info
VERSION="0.2.1"
AUTHOR="diserere"
REPO_URL="https://github.com/diserere/matrix_cli"


# Конфигурация
DELAY=
UPDATE_URL="https://raw.githubusercontent.com/diserere/matrix_cli/refs/heads/master/matrix.sh"
FPS_LOG_FILE=/tmp/matrix_fps.log

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
TEST_FPS=0     # 0 = обычный режим, 1 = режим тестирования цветов


# Функция для очистки при выходе
cleanup() {
    tput cnorm
    # Очистка экрана
    clear
    echo -e "\n${COLORS[5]}Wake up Neo.${RESET}\n"

    if [ $TEST_FPS -eq 1 ]; then
        cat "$FPS_LOG_FILE" >&2
    fi

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
            "\033[38;5;118m"    # 0: Очень яркий зеленый
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
    CHARS_COUNT=${#CHARS}
}

# Проверка зависимостей
check_dependencies() {
    for dep in $1; do
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
            -f|--fps)
                TEST_FPS=1
                shift
                ;;
            -d|--delay)
                if [[ -n "$2" && "$2" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                    DELAY="$2"
                    shift 2
                else
                    echo "Ошибка: --speed требует числового значения"
                    exit 1
                fi
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
    echo "  -f, --fps           Тест производительности FPS (лог-файл ${FPS_LOG_FILE})"
    echo "  -d, --delay 0.1     Задержка в секундах при выводе буфера кадра"
    echo "  -v, --version       Показать информацию о версии"
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

# Основной цикл анимации (оптимизированная версия)
do_matrix() {
    check_dependencies "tput"
    
    # --- ПРЕДВЫЧИСЛЕНИЯ ДЛЯ ПРОИЗВОДИТЕЛЬНОСТИ ---
    
    # 1. Кэшируем цветовые строки (самая важная оптимизация!)
    declare -a COLOR_STRINGS
    for i in {0..5}; do
        COLOR_STRINGS[i]="${COLORS[i]}"
    done
    local RESET_STR="$RESET"
    
    # 2. Локальные переменные для часто используемых значений
    local width=$WIDTH
    local height=$HEIGHT
    local chars="$CHARS"
    local chars_count=$CHARS_COUNT
    
    # 3. Размер буфера и предвычисленные константы
    local buffer_size=$((width * height))
    local columns_step=1  # Можно увеличить до 4 или 5 для большей скорости
    local default_color_idx=5
    
    # --- ИНИЦИАЛИЗАЦИЯ БУФЕРОВ ---
    
    # Массивы для символов и цветов
    local -a char_buffer
    local -a color_buffer
    local -a prev_char_buffer  # Для частичной перерисовки (опционально)
    local -a prev_color_buffer # Для частичной перерисовки (опционально)
    
    # Заполняем буферы начальными значениями
    for ((idx=0; idx<buffer_size; idx++)); do
        char_buffer[idx]=" "
        color_buffer[idx]=$default_color_idx
        # Для частичной перерисовки:
        prev_char_buffer[idx]=""
        prev_color_buffer[idx]=-1
    done
    
    # --- ИНИЦИАЛИЗАЦИЯ СТАТИСТИКИ ---
    if (( TEST_FPS == 1 )); then
        local frame_count=0
        local start_time=$SECONDS
        
        echo "Matrix CLI Performance Test" > "$FPS_LOG_FILE"
        {
            echo "Screen: ${width}x${height}, Step: ${columns_step}" >> "$FPS_LOG_FILE"
            echo "Buffer size: $buffer_size cells" >> "$FPS_LOG_FILE"
            echo "Delay: ${DELAY}s" >> "$FPS_LOG_FILE"
            echo "----------------------------------------"
        } >> "$FPS_LOG_FILE"
    fi
    
    # --- ГЛАВНЫЙ ЦИКЛ АНИМАЦИИ ---
    
    while true; do
        # Засекаем время начала кадра (для точных замеров)
        if (( TEST_FPS == 1 )); then
            local frame_start_time
            if (( frame_count % 50 == 0 )); then
                frame_start_time=$(date +%s%N)
            fi
        fi
        
        # ОБНОВЛЕНИЕ ПОЗИЦИЙ КОЛОНОК И БУФЕРА
        for ((i=0; i<width; i+=columns_step)); do
            # Двигаем колонку вниз
            positions[i]=$((positions[i] + speeds[i]))
            
            # Выравниваем по нижнему краю
            if (( positions[i] >= height )); then
                positions[i]=$((height - 1))
            fi
            
            # ОПТИМИЗАЦИЯ: вычисляем границы отрисовки один раз
            local col_top=$((positions[i] - lengths[i] + 1))
            local col_bottom=${positions[i]}
            
            # Ограничиваем экраном
            if (( col_top < 0 )); then col_top=0; fi
            if (( col_bottom >= height )); then col_bottom=$((height - 1)); fi
            
            # ОБНОВЛЕНИЕ СИМВОЛОВ В КОЛОНКЕ
            for ((line_pos=col_top; line_pos<=col_bottom; line_pos++)); do
                local buffer_idx=$((line_pos * width + i))
                
                # 1. Обновляем символ (случайный из набора)
                char_buffer[buffer_idx]=${chars:$((RANDOM % chars_count)):1}
                
                # 2. Вычисляем цвет (математически вместо if/elif)
                local j=$((positions[i] - line_pos))
                local color_idx
                
                # ОПТИМИЗАЦИЯ: математическое вычисление вместо цепочки if
                if (( j == 0 )); then
                    color_idx=0
                elif (( j == 1 )); then
                    color_idx=1
                elif (( j < 4 )); then
                    color_idx=2
                elif (( j < 7 )); then
                    color_idx=3
                elif (( j < 10 )); then
                    color_idx=4
                else
                    color_idx=5
                fi
                
                # Альтернатива (немного быстрее, но менее читаемо):
                # color_idx=$(( j == 0 ? 0 : j == 1 ? 1 : j < 4 ? 2 : j < 7 ? 3 : j < 10 ? 4 : 5 ))
                
                color_buffer[buffer_idx]=$color_idx
            done
            
            # ОБРАБОТКА СТИРАНИЯ ХВОСТА (если включено)
            if (( ERASE_MODE == 1 && speeds[i] == 1 )); then
                local erase=$((positions[i] - lengths[i]))
                if (( erase >= 0 && erase < height )); then
                    local erase_idx=$((erase * width + i))
                    char_buffer[erase_idx]=" "
                    color_buffer[erase_idx]=$default_color_idx
                fi
            fi
            
            # ПЕРЕЗАПУСК КОЛОНКИ ПО ДОСТИЖЕНИИ НИЗА
            if (( positions[i] == height - 1 )); then
                positions[i]=0
                if (( RANDOM % 2 == 0 )); then
                    lengths[i]=$(random_length)
                    speeds[i]=$(random_speed)
                fi
            fi
        done
        
        # --- ФОРМИРОВАНИЕ И ВЫВОД КАДРА (самая критичная часть) ---
        
        local frame_buffer=""
        
        # ОПТИМИЗАЦИЯ: используем один цикл по буферу вместо вложенных
        for ((row=0; row<height; row++)); do
            local line_buffer=""
            local row_start=$((row * width))
            local row_end=$((row_start + width))
            
            # ОПТИМИЗАЦИЯ: прямой индекс в буфере вместо row*width+col
            for ((idx=row_start; idx<row_end; idx++)); do
                # Самая быстрая конкатенация (ваши замеры это подтвердили)
                line_buffer+=${COLOR_STRINGS[${color_buffer[idx]}]}${char_buffer[idx]}
            done

            # В последней строке не добавляем \n, чтобы не вызвать скролл за пределы экрана
            if (( row < height - 1 )); then
                frame_buffer+="$line_buffer\n"
            else
                frame_buffer+="$line_buffer"
            fi
        done
        
        # ВЫВОД КАДРА НА ЭКРАН
        # ОПТИМИЗАЦИЯ: tput cup быстрее чем clear
        tput cup 0 0 2>/dev/null
        echo -en "$frame_buffer"
        
        # --- СТАТИСТИКА И ЗАДЕРЖКА ---

        if ((TEST_FPS == 1)); then
            # СБОР СТАТИСТИКИ ПРОИЗВОДИТЕЛЬНОСТИ
            ((frame_count++))
            
            # Каждые 50 кадров записываем точное время отрисовки
            if (( frame_count % 50 == 0 )); then
                local frame_end_time=$(date +%s%N)
                local frame_time_ns=$((frame_end_time - frame_start_time))
                local frame_time_ms=$((frame_time_ns / 1000000))
                
                local elapsed_total=$((SECONDS - start_time))
                local fps=$((frame_count / (elapsed_total > 0 ? elapsed_total : 1)))
                
                # Записываем в лог
                echo "Frame: $frame_count, Buffer build: ~${frame_time_ms}ms, FPS: $fps" >> "$FPS_LOG_FILE"
                
            fi

            # Выводим FPS в углу экрана
            if (( fps > 0 )); then
                tput cup 0 0 2>/dev/null
                echo -ne "${COLOR_STRINGS[0]}${fps} fps "
            fi

            # Автоматический выход после N кадров (для бенчмарков)
            if (( frame_count >= 500 )); then
                echo "Benchmark complete: ${fps} FPS average" >> "$FPS_LOG_FILE"
                cleanup
            fi
        fi

        if [ -n "${DELAY}" ]; then
            sleep $DELAY
        fi
    done
}

# Инициализация
do_init() {
    WIDTH=$(tput cols)
    HEIGHT=$(tput lines)
    # WIDTH=80
    # HEIGHT=24

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
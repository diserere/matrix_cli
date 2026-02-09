Matrix Console Animation
---
Bash-скрипт, имитирующий визуализацию из фильма "Матрица" в терминале.

[![Version](https://img.shields.io/badge/version-0.2.1-green.svg)](https://github.com/diserere/matrix_cli/releases)


![Matrix Demo](images/animated_matrix_green_v0.2.0_600px.gif)

## Особенности

- **Два цветовых режима**: классический зелёный и градиент серого
- **Режимы символов**: полный набор символов или двоичный (только 0 и 1)
- **Эффект стирания**: опциональное стирание хвостов колонок
- **Адаптивный размер**: автоматически подстраивается под размер терминала

## Установка

```bash
# Скачать актуальную версию скрипта
curl -O https://raw.githubusercontent.com/diserere/matrix_cli/refs/heads/master/matrix.sh

# Сделать скрипт исполняемым
chmod +x matrix.sh

# Запустить
./matrix.sh
```

> [!TIP]
> Для лучшего опыта рекомендуется использовать терминал с поддержкой 256 цветов.

## Примеры использования

```bash
# Базовый запуск (зелёный Matrix)
./matrix.sh

# Двоичный Matrix (только 0 и 1)
./matrix.sh --binary

# Серый Matrix со стиранием хвостов
./matrix.sh --grayscale --erase

# Тест цветовой палитры
./matrix.sh --test
./matrix.sh --grayscale --test
./matrix.sh --test --grayscale

# Тест FPS для конкретного режима
./matrix.sh --fps --grayscale --binary --delay 0.05

# Показать справку
./matrix.sh --help

# Показать информацию о версии
./matrix.sh --version

# Обновить до последней версии из Github repo
./matrix.sh --update
```

## Параметры командной строки

| Параметр | Короткая версия | Описание |
|----------|----------------|----------|
| `--binary` | `-b` | Использовать только символы 0 и 1 |
| `--erase` | `-e` | Включить стирание хвостов колонок |
| `--grayscale` | `-g` | Использовать оттенки серого вместо зелёного |
| `--test` | `-t` | Показать тестовую таблицу цветов и выйти |
| `--fps` | `-f` | Тест производительности FPS |
| `--delay 0.1` | `-d 0.1` | Задержка в секундах при выводе буфера кадра |
| `--help` | `-h` | Показать справку по использованию |
| `--version` | `-v` | Показать информацию о версии |
| `--update` | `-u` | Обновить до последней версии из Github repo |

## Управление

- **Ctrl+C** - Выход из программы

## Цветовые схемы

### 1. Зелёная тема (по умолчанию)
Градиент от ярко-зелёного к тёмно-зелёному, максимально приближенный к оригинальной заставке из фильма.

### 2. Серо-белая тема
Альтернативный вариант с градиентом от белого к тёмно-серому.

## Технические детали

- **Язык**: Bash 4.0+
- **Зависимости**: `tput` (обычно входит в состав `ncurses`)
- **Поддержка терминалов**: Все терминалы с поддержкой 256 цветов
- **Размер**: Адаптивный, подстраивается под текущий размер окна терминала

## Совместимость

Протестировано на:
- Ubuntu/Debian (bash 5.0+)
- macOS (bash 3.2+ с установленным `coreutils`)
- Termux (Android)
> [!NOTE]
> Запуск в Termux требует установки пакета `ncurses-utils` из-за зависимости от `tput`:
> ```
> pkg update && pkg upgrade && pkg install ncurses-utils
> ``` 
<!-- - Windows WSL/WSL2 -->


## Производительность

> [!TIP]
> Используйте `--delay` для уменьшения скорости анимации на маленьких экранах:
> ```bash
> # Для терминала 80х24
> ./matrix.sh --delay 0.2
> ```

| Разрешение | FPS (без задержки) | Рекомендуемая задержка |
|------------|-------------------|------------------------|
| 80×24 (стандарт) | ~25 | 0.1-0.3s |
| 120×40 | ~12 | 0.05-0.2s |
| 238×65 (FullHD) | ~5 | no delay |


## Скриншоты

### Классический зелёный режим
![Зелёный Matrix](images/animated_matrix_green_v0.2.0_600px.gif)

### Двоичный режим (0 и 1), grayscale
![Двоичный Matrix](images/animated_matrix_gray_v0.2.0_600px.gif)


### Примеры режимов
- `matrix.sh`

![matrix_green_600px.png](images/matrix_green_600px.png)

- `matrix.sh --binary --erase`

![matrix_green_binary_600px.png](images/matrix_green_binary_600px.png)

- `matrix.sh --grayscale`

![matrix_gray_2.png](images/matrix_gray_2_600px.png)

- `matrix.sh --grayscale --binary --erase`

![matrix_gray_binary_2_600px.png](images/matrix_gray_binary_2_600px.png)

- `matrix.sh --test`

![matrix_color_test_600px.png](images/matrix_color_test_600px.png)

- `matrix.sh --fps --b -e -d 0.01`

![matrix_test_fps_1_600px.png](images/matrix_test_fps_1_600px.png)

![matrix_test_fps_2_600px.png](images/matrix_test_fps_2_600px.png)

- `matrix.sh --help`

![matrix_help_600px.png](images/matrix_help_600px.png)

- `matrix.sh --version`

![matrix_version_600px.png](images/matrix_version_600px.png)

- `matrix.sh --update`

![matrix_update_600px.png](images/matrix_update_600px.png)


## Лицензия

MIT License. Смотрите файл LICENSE для подробностей.

## Вклад в проект

Приветствуются пул-реквесты и сообщения о проблемах!

1. Форкните репозиторий
2. Создайте ветку для новой функции (`git checkout -b feature/amazing-feature`)
3. Зафиксируйте изменения (`git commit -m 'Add amazing feature'`)
4. Запушьте в ветку (`git push origin feature/amazing-feature`)
5. Откройте пул-реквест

## Благодарности

- Братьям Вачовски за вдохновение
- Сообществу Linux за прекрасные инструменты
- Большой языковой модели DEEPSEEK за помощь и консультации
- Всем тестерам и контрибьюторам

## Список изменений

[CHANGELOG.md](CHANGELOG.md) - подробная информация об в каждой версии.

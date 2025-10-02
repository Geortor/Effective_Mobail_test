#!/bin/bash

PROCESS_NAME="sleep"
MONITORING_URL="https://cronitor.link/p/d79eaddbe7c343e2872ef7baa2b0dda0/UVVpB7"
LOG_FILE="/var/log/monitoring.log"
PID_FILE="/var/run/monitor_${PROCESS_NAME}.pid"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

touch "$LOG_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
    echo "ОШИБКА: Невозможно создать или записать в лог-файл $LOG_FILE"
    exit 1
fi


CURRENT_PID=$(pgrep -x -n "$PROCESS_NAME")

OLD_PID=""
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
fi

if [ -n "$CURRENT_PID" ]; then
    if [ "$CURRENT_PID" != "$OLD_PID" ]; then
        log_message "INFO: Процесс '$PROCESS_NAME' запущен или перезапущен. Новый PID: $CURRENT_PID"
        echo "$CURRENT_PID" > "$PID_FILE"
    fi

    if ! curl --fail -sS -o /dev/null "$MONITORING_URL"; then
        log_message "ОШИБКА: Сервер мониторинга $MONITORING_URL недоступен."
    fi

else

    if [ -f "$PID_FILE" ]; then
        log_message "INFO: Процесс '$PROCESS_NAME' (предыдущий PID: $OLD_PID) был остановлен."
        rm "$PID_FILE"
    fi
fi

exit 0

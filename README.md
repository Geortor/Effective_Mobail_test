# Effective_Mobail_test
Тестовое задание для EM

*Для создания heartbeat запроса воспльзовался сторонним сервисов:*

![alt text](heart-beat.png)

*Для запуска скрипта каждую минуту создаем cron правило*

`* * * * * /usr/local/bin/monitor_process.sh >> /var/log/cron_monitoring.log 2>&1`

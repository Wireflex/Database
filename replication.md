192.168.0.70 Master-server :godmode:

192.168.0.8  Replica-server :japanese_goblin:

## Настройка Master-server :godmode:
Устанавливаем пароль( понадобится потом )
```
su - postgres
psql -c "ALTER ROLE postgres PASSWORD 'ВАШ_ПАРОЛЬ'"
exit
```
Разрешаем пользователю подключаться из Replica-сервера в Master. Для этого редактриуем файл
```
nano /etc/postgresql/16/main/pg_hba.conf
```
После блока «If you want to allow non-local connections, you need to add more» пишем

host    replication    postgres    192.168.0.8/32    md5   # Внутренний айпи реплики :japanese_goblin:

Далее указываем настройки репликации
```
nano /etc/postgresql/16/main/postgresql.conf
```
Находим, раскомментируем и подставляем значения

listen_addresses = 'localhost, 192.168.0.70 ' # Внутренний айпи мастера :godmode:
wal_level = hot_standby
archive_mode = on
archive_command = 'cd .'
max_wal_senders = 8
hot_standby = on

Перезапускаем постгрес

## Настройка Replica-server :japanese_goblin:

Для начала стопаем постгрес

Так же редактируем pg_hba.conf
```
nano /etc/postgresql/12/main/pg_hba.conf
```
host    replication    postgres    192.168.0.70/32    md5 # Внутренний айпи мастера :godmode:

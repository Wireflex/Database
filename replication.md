192.168.0.70 Master-server :godmode:

192.168.0.8  Replica-server :japanese_goblin:

# Настройка Master-server :godmode:
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

host    replication    postgres    192.168.0.8/32    md5   # айпи реплики :japanese_goblin:

Далее указываем настройки репликации
```
nano /etc/postgresql/16/main/postgresql.conf
```
Находим, раскомментируем и подставляем значения

listen_addresses = 'localhost, 192.168.0.70 ' # айпи мастера :godmode:

wal_level = hot_standby

archive_mode = on

archive_command = 'cd .'

max_wal_senders = 8

hot_standby = on

Перезапускаем постгрес

# Настройка Replica-server :japanese_goblin:

Для начала стопаем постгрес

Так же редактируем pg_hba.conf
```
nano /etc/postgresql/16/main/pg_hba.conf
```
host    replication    postgres    192.168.0.70/32    md5 # айпи мастера :godmode:

Редачим конфиг постгреса
```
nano /etc/postgresql/16/main/postgresql.conf
```
listen_addresses = 'localhost, 192.168.0.8' # Внутренний айпи реплики :japanese_goblin:

wal_level = hot_standby

archive_mode = on

archive_command = 'cd .'

max_wal_senders = 8

hot_standby = on

# pg_basebackup

Сейчас настройки сервов одинаковые, кроме 1 файла на реплике, standby.signal ( будет добавлен потом )

Прежде чем Replica-сервер сможет начать реплицировать данные, создаём новую БД, идентичную Master-серверу

На реплике :japanese_goblin:
```
su - postgres
    
cd /var/lib/postgresql/12/
    
rm -rf main; mkdir main; chmod go-rwx main
```
```pg_basebackup -P -R -X stream -c fast -h 192.168.0.70  -U postgres -D ./main``` # айпи мастера :godmode:

В этой команде есть важный параметр -R. Он означает, что PostgreSQL-сервер также создаст пустой файл standby.signal. Несмотря на то, что файл пустой, само наличие этого файла означает, что этот сервер — реплика.

Стартуем постгрес

На мастере создаём таблицу с 1 строчкой: :godmode:
```
su - postgres
psql -c "CREATE TABLE test_table (id INT, name TEXT);"
psql -c "INSERT INTO test_table (id, name) VALUES (1, 'test');"
```
![image](https://github.com/user-attachments/assets/ecb7499c-7c39-4d47-9154-26432b3113fe)

На реплике чекаем,что она появилась :japanese_goblin:
```
su - postgres
psql -c "SELECT * FROM test_table;"
```
![image](https://github.com/user-attachments/assets/4a846c82-f4b1-449c-aabe-9a4026fdf88d)

На реплике можно пробнуть создать новую таблицу, но, очевидно, это не получится, т.к это реплика :japanese_goblin:
```
psql -c "CREATE TABLE test_table2 (id INT, name TEXT);"
```
![image](https://github.com/user-attachments/assets/0848766c-ff1d-4e18-991b-c981d4966a88)

# Отвал мастера и тест реплики

На мастере стопаем постгрес :godmode:

На реплике под юзером постгрес переводим сервак в режим записи :japanese_goblin:
```
/usr/lib/postgresql/16/bin/pg_ctl promote -D /var/lib/postgresql/16/main
```
Теперь таблица создаётся 
```
psql -c "CREATE TABLE test_table2 (id INT, name TEXT);"
```
![image](https://github.com/user-attachments/assets/b589c0b8-b4ef-4ac6-8109-eeb89bb7fc83)

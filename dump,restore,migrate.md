# pg_dump

Создём тестовую базу данных
```
psql -U postgres -h localhost # (нужно предварительно поменять пароль) с рута su postgres && psql && ALTER USER postgres WITH PASSWORD 'новый_пароль';
CREATE DATABASE mydatabase;
```
Подключаемся к базе данных mydatabase
```\c mydatabase```

Создаем таблицу "users"
```
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);
```
Вставляем данные в таблицу
```
INSERT INTO users (name, email, created_at) VALUES
    ('John Doe', 'john.doe@example.com', NOW()),
    ('Jane Smith', 'jane.smith@example.com', NOW());
```
Юзаем pg_dump (от рута офк):
```pg_dump -h localhost -p 5432 -U postgres -d mydatabase -f /home/ubuntu/mydatabase.dump```

![image](https://github.com/user-attachments/assets/bdab548b-e1f2-4863-983a-90860eb55293)

# pg_restore
Для теста удаляем бд

``` DROP database mydatabase;```

Далее создаём новую(я с таким же названием сделал)

Зырим на users, но, понятное дело, там ничего нет

![image](https://github.com/user-attachments/assets/83d2f795-8fc8-4078-a58f-68669bf99785)

и восстанавливаем

```psql -U postgres -h localhost -d mydatabase -f /home/ubuntu/mydatabase.dump```

![image](https://github.com/user-attachments/assets/aa9b4d5b-a5c0-47ca-8ec6-80f4489ff838)

Чекаем - данные появились 

![image](https://github.com/user-attachments/assets/2d3fac61-703a-47a0-aaf4-85d546204f1a)

# Migration


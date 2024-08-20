### 1. Запросы в секунду ( QPS )
```
   SELECT
       SUM(calls) AS total_calls,
       SUM(calls) / EXTRACT(EPOCH FROM (now() - pg_postmaster_start_time())) AS qps
   FROM
       pg_stat_statements;
```
![image](https://github.com/user-attachments/assets/794cc675-8ee5-4f96-be01-be1f7b91309f)

### 2. Топ 5 самых частых запросов
```
SELECT query,calls FROM pg_stat_statements ORDER BY calls DESC LIMIT 5;
```
![image](https://github.com/user-attachments/assets/329fb03f-b610-4e8b-ba40-efaa1c76c067)

### 3. Топ 5 самых долгих запросов
```
SELECT
    query,
    calls,
    total_exec_time,
    total_exec_time / NULLIF(calls, 0) AS mean_exec_time
FROM
    pg_stat_statements
ORDER BY
    total_exec_time DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/da74c00b-f04f-4125-94b6-3eed0984c33d)

### 4. Топ 5 самых тяжелых запросов
```
SELECT
    query,
    shared_blks_hit + shared_blks_read + shared_blks_dirtied + shared_blks_written AS total_shared_blks
FROM
    pg_stat_statements
ORDER BY
    total_shared_blks DESC
LIMIT 5;
```
![image](https://github.com/user-attachments/assets/ec1cb282-d5fa-48fe-95b1-69d9f2fe9ee2)

### 5. Топ 5 самых "щедрых" запросов
```
SELECT query, rows FROM pg_stat_statements ORDER BY rows DESC LIMIT 5
```
![image](https://github.com/user-attachments/assets/4665eb86-17c8-4c33-9eaf-f711b52cc94c)

### 6. Среднее/Максимальное/Минимальное время отклика
```
SELECT
  AVG(total_exec_time::decimal / calls::decimal) AS average_execution_time,
  MAX(total_exec_time::decimal) AS max_execution_time,
  MIN(total_exec_time::decimal) AS min_execution_time,
  query
FROM pg_stat_statements
GROUP BY query;
```
![image](https://github.com/user-attachments/assets/1391f6e7-4ee6-46fd-b70c-5bca34f1bc47)

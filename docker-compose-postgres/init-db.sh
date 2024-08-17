#!/bin/bash
set -e

# Создаем расширение pg_stat_statements в базе данных
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"

# Создаем представление для метрик
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "

CREATE OR REPLACE VIEW pg_stat_statements_view AS
SELECT
  pg_get_userbyid(userid) AS user,
  pg_database.datname,
  pg_stat_statements.queryid,
  pg_stat_statements.calls,
  pg_stat_statements.total_time / 1000.0 AS seconds_total,
  pg_stat_statements.rows,
  pg_stat_statements.blk_read_time / 1000.0 AS block_read_seconds_total,
  pg_stat_statements.blk_write_time / 1000.0 AS block_write_seconds_total
FROM pg_stat_statements
JOIN pg_database ON pg_database.oid = pg_stat_statements.dbid
WHERE total_time > (
  SELECT percentile_cont(0.1) WITHIN GROUP (ORDER BY total_time)
  FROM pg_stat_statements
)
ORDER BY seconds_total DESC
LIMIT 500;
"

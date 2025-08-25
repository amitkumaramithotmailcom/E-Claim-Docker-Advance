#!/bin/bash
# wait-for-sql.sh

set -e

host="$1"
shift
cmd="$@"

echo "Waiting for SQL Server at $host..."
until /opt/mssql-tools/bin/sqlcmd -S "$host" -U SA -P "Amit@123" -Q "SELECT 1" > /dev/null 2>&1; do
  sleep 3
done

echo "SQL Server is ready! Starting the API..."
exec $cmd

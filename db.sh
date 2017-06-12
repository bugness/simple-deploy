#!/bin/bash

script_path=`dirname $0`

if [ ! -e ${script_path}/.env ]; then
  echo "Please create config file .env"
  exit 1
fi

. ${script_path}/.env

mysql="/usr/bin/mysql"
mysqldbcompare="/usr/bin/mysqldbcompare"
mysqldump="/usr/bin/mysqldump"

case "$1" in
  backup)
    ${mysqldump} -u ${db_user} -p${db_pass} ${db_name} > ${local_path}/sql/fulldump.sql
    ;;
  restore)
    ${mysql} -u ${db_user} -p${db_pass} ${db_name} < ${local_path}/sql/fulldump.sql
    ;;
  test)
    ${mysql} -u ${db_user} -p${db_pass} --execute="CREATE DATABASE IF NOT EXISTS \`${db_name}_test\`;"
    ${mysql} -u ${db_user} -p${db_pass} ${db_name}_test < ${local_path}/sql/fulldump.sql
    ${mysqldbcompare} \
      --server1=${db_user}:${db_pass}@localhost \
      --server2=${db_user}:${db_pass}@localhost \
      --run-all-tests --difftype sql \
      ${db_name}:${db_name}_test
    ;;
  *)
    echo "Use: ./db.sh {backup|restore|test}"
    ;;
esac

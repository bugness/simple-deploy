#!/bin/bash

script_path=`dirname $0`

if [ ! -e ${script_path}/.env ]; then
  echo "Please create config file .env"
  exit 1
fi

. ${script_path}/.env

rsync="/usr/bin/rsync"

case "$1" in
  force)
    ${rsync} -czavP --delete \
      ${local_path}/* \
      --exclude-from=${script_path}/.ignore \
      ${remote_path}
    ;;
  *)
    ${rsync} -nviazP --delete \
      ${local_path}/* \
      --exclude-from=${script_path}/.ignore \
      ${remote_path}
    ;;
esac

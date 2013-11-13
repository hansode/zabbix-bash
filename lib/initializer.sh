# -*-Shell-script-*-
#

# include files

. ${BASH_SOURCE[0]%/*}/curlet.sh

# variables

## System part

LANG=C
LC_ALL=C

## curlet part

function rc_path() {
  echo ${ZABBIX_RC:-${HOME}/.zabbixrc}
}

function request_header() {
  echo -H Content-Type:application/json-rpc
}

## ZABBIX part

load_rc

extract_args "$@"

API_VERSION=${API_VERSION:-1.8}
API_HOST=${API_HOST:-localhost}
API_PORT=${API_PORT:-80}
API_BASE_URI=${API_BASE_URI:-http://${API_HOST}:${API_PORT}}/zabbix/api_jsonrpc.php

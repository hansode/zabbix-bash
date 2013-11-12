# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/1.8/api/item
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_create() {
  # https://www.zabbix.com/documentation/1.8/api/item/create
  call_jsonrpc
}

task_delete() {
  # https://www.zabbix.com/documentation/1.8/api/item/delete
  call_jsonrpc
}

task_exists() {
  # https://www.zabbix.com/documentation/1.8/api/item/exists
  call_jsonrpc
}

task_get() {
  # https://www.zabbix.com/documentation/1.8/api/item/get
  call_jsonrpc
}

task_update() {
  # https://www.zabbix.com/documentation/1.8/api/item/update
  call_jsonrpc
}

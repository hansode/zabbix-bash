# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/1.8/api/host
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_create() {
  # https://www.zabbix.com/documentation/1.8/api/host/create
  call_jsonrpc
}

task_delete() {
  # https://www.zabbix.com/documentation/1.8/api/host/delete
  call_jsonrpc
}

task_exists() {
  # https://www.zabbix.com/documentation/1.8/api/host/exists
  call_jsonrpc
}

task_get() {
  # https://www.zabbix.com/documentation/1.8/api/host/get
  call_jsonrpc
}

task_massadd() {
  # https://www.zabbix.com/documentation/1.8/api/host/massadd
  call_jsonrpc
}

task_massremove() {
  # https://www.zabbix.com/documentation/1.8/api/host/massremove
  call_jsonrpc
}

task_massupdate() {
  # https://www.zabbix.com/documentation/1.8/api/host/massupdate
  call_jsonrpc
}

task_update() {
  # https://www.zabbix.com/documentation/1.8/api/host/update
  call_jsonrpc
}

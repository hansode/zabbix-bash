# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/1.8/api/event
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_acknowledge() {
  # https://www.zabbix.com/documentation/1.8/api/event/acknowledge
  call_jsonrpc
}

task_delete() {
  # https://www.zabbix.com/documentation/1.8/api/event/delete
  call_jsonrpc
}

task_get() {
  # https://www.zabbix.com/documentation/1.8/api/event/get
  call_jsonrpc
}

# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/1.8/api/user
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_login() {
  # https://www.zabbix.com/documentation/1.8/api/user/login
  params=$(
    cat <<-EOS
	"user": "${user}",
	"password": "${password}"
	EOS
  )
  call_jsonrpc
}

task_authenticate() {
  # https://www.zabbix.com/documentation/1.8/api/user/authenticate
  task_login $@
}

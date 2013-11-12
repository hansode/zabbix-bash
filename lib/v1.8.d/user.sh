# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/1.8/api/user
#

. ${BASH_SOURCE[0]%/*}/base.sh

task_login() {
  # https://www.zabbix.com/documentation/1.8/api/user/login

  call_api -X GET --data @- \
   $(base_uri) <<-EOS
	{
	  "jsonrpc": "2.0",
	  "method" : "${namespace}.${cmd}",
	  "params" : { "user": "${user}", "password": "${password}" },
	  "id"     : "${id:-$(date +%Y%m%d%H%M%S.%N)}",
	  "auth"   : ${auth:-null}
	}
	EOS
}

task_authenticate() {
  # https://www.zabbix.com/documentation/1.8/api/user/authenticate
  task_login $@
}

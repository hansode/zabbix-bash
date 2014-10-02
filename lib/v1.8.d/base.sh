# -*-Shell-script-*-
#
# https://www.zabbix.com/documentation/doku.php?id=1.8/api
#

call_jsonrpc() {
  call_api -X GET --data @- \
   $(base_uri) <<-EOS
	{
	  "jsonrpc": "2.0",
	  "method" : "${namespace}.${cmd}",
	  "params" : { ${params} },
	  "id"     : "${id:-$(date +%Y%m%d%H%M%S.%N)}",
	  "auth"   : "${auth:-}"
	}
	EOS
}

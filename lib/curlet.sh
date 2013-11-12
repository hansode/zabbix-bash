# -*-Shell-script-*-
#

COMMAND_PROMPT='$'
COMMAND_ARGS=
COMMAND_FRONTEND=${COMMAND_FRONTEND:-noninteractive} # [ interactive | noninteractive ]

function extract_args() {
  COMMAND_ARGS=
  local arg= key= value= key_prefix=
  while [[ $# != 0 ]]; do
    arg="$1" key= value=
    case "${arg}" in
    --*=*)
      key=${arg%%=*}; key=${key##--}; key=${key//-/_}
      value="${value} ${arg##--*=}"
      eval "${key}=\"${value}\""; value="\${${key}}"; value=$(eval echo ${value}); eval "${key}=\"${value## }\""
      ;;
    --*)
      key=${arg##--}; key=${key//-/_}
      case "$2" in
      --*|"")
        eval "${key}=1"
        ;;
      *)
        value="\${${key}} $2"
        eval "${key}=\"${value}\""; value="\${${key}}"; value=$(eval echo ${value}); eval "${key}=\"${value## }\""
        shift
        ;;
      esac
      ;;
    *)
      COMMAND_ARGS="${COMMAND_ARGS} ${arg}"
      ;;
    esac
    shift
  done
  # trim
  COMMAND_ARGS=${COMMAND_ARGS%% }
  COMMAND_ARGS=${COMMAND_ARGS## }
}

function shlog() {
  COMMAND_LOGLEVEL=$(echo ${COMMAND_LOGLEVEL:-info} | tr A-Z a-z)
  COMMAND_DRY_RUN=$(echo ${COMMAND_DRY_RUN:-} | tr A-Z a-z)

  case "${COMMAND_LOGLEVEL}" in
  debug)
    echo "${COMMAND_PROMPT} $@"
    ;;
  *)
    ;;
  esac

  case "${COMMAND_DRY_RUN}" in
  y|yes|on|1)
    :
   ;;
  *)
    eval $@ </dev/stdin
    ;;
  esac
}

function curl_opts() {
  echo -fsSkL $(request_header)
}

function request_header() {
  :
}

function request_param() {
  echo $@
}

function base_uri() {
  echo ${API_BASE_URI}
}

function data_type() {
  echo --data # --data-urlencode
}

function urlencode_data() {
  # "echo $( ... )" means removing each line \n
  echo $(
    while [[ "${1}" ]]; do
      echo $(data_type) ${1}
      shift
    done
  )
}

function query_string() {
  # "echo $( ... )" means removing each line \n
  local query_string=$(
    echo $(
      while [[ "${1}" ]]; do
        echo ${1}
        shift
      done
    )
  )
  echo ${query_string// /\\&} # "a=b c=d" => "a=b\&c=d"
}

function strfile_type() {
  local key=$1
  [[ -n "${key}" ]] || { echo "[ERROR] 'key' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  eval "
   if [[ -f "\${${key}}" ]]; then
     # file: key@${key}
     echo "${key}@\${${key}}"
   else
     # str: key=${key}
     echo "${key}=\${${key}}"
   fi
  "
}

function add_param() {
  local param_key=$1 param_type=${2:-string}
  [[ -n "${param_key}" ]] || { echo "[ERROR] 'param_key' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  eval "
   [[ -n "\${${param_key}}" ]] || return 0

   case "${param_type}" in
    string) echo   "${param_key}=\${${param_key}}" ;;
     array) local i; for i in \${${param_key}}; do echo "${param_key}[]=\${i}"; done ;;
   strfile) strfile_type ${param_key}            ;;
  strplain) echo "\${${param_key}}" ;;
      hash) local i; for i in \${${param_key}}; do echo \${param_key}[\${i%%=*}]=\${i##*=}; done ;;
   esac
  "
}

## cmd_*

function call_api() {
  shlog curl $(curl_opts) $(request_param $@)
}

## tasklet

function invoke_task() {
  local namespace=$1 cmd=${2//-/_}
  [[ -n "${namespace}" ]] || { echo "[ERROR] 'namespace' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -n "${cmd}"       ]] || { echo "[ERROR] 'cmd' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  declare -f task_${cmd} >/dev/null || { echo "[ERROR] undefined task: 'task_${cmd}' (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  shift; shift
  eval task_${cmd} $@
}

task_help() {
  cmd_help ${namespace} "$(echo $(declare -f | egrep ^task_ | egrep -v 'task_help|task_default' | sed 's,^task_,,; s,(,,; s,),,;') | sort | sed 's, ,|,g')"
}

## controller

function namespace_dir() {
  echo ${BASH_SOURCE[0]%/*}/v${API_VERSION}.d
}

function namespace_path() {
  echo $(namespace_dir)/${namespace}.sh
}

function run_cmd() {
  local namespace=$1 cmd=$2
  [[ -n "${namespace}" ]] || { echo "[ERROR] 'namespace' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -n "${cmd}"       ]] || { echo "[ERROR] 'cmd' is empty (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  local namespace_path=$(namespace_path)
  [[ -f "${namespace_path}" ]] || {
    echo "[ERROR] no such namespace '${namespace}'" >&2
    return 1
  }

  . ${namespace_path}
  invoke_task $@
}

function rc_path() {
  :
}

function load_rc() {
  local rc_path=$(rc_path)
  if [[ -f "${rc_path}" ]]; then
    . ${rc_path}
  fi
}

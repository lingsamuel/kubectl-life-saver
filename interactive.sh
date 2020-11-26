#!/bin/bash

iknx() { # inetractive knx
  local CMD=${1:-bash}
  local LEN=${#@}
  local ARGS=""
  if (( LEN > 1 )); then
    shift
    ARGS="$@"
  fi
  local POD=$(kngp | peco | awk '{print $1}')
  if [[ -z $POD ]]; then
    echo "Aborted"
    return
  fi
  knx $POD ${=ARGS} $CMD
}
 
iknl () { # interactive knl
  local POD=$(kngp | peco | awk '{print $1}')
  if [[ -z $POD ]]; then
    echo "Aborted"
    return
  fi
  knl $POD $@
}
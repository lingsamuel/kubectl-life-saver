#!/bin/bash

kp() {
  ns=$1
  rs=$2
  name=$3
  cmd=$4

  __backup_kp_cmd() {
    mkdir -p $HOME/.kp
    echo $ns > $HOME/.kp/last_ns
    echo $rs > $HOME/.kp/last_rs
    echo $name > $HOME/.kp/last_name
    echo $cmd > $HOME/.kp/last_cmd
  }

  exit_kp() {
    echo "Aborted."
    __backup_kp_cmd
  }

  # Get Namespace
  if [[ -z $ns ]]; then
    ns=$(echo "all\n$(kubectl get ns)" | peco | awk '{print $1}')
  fi
  echo Namespace: $ns
  if [[ -z $ns ]]; then
    echo "Aborted." # don't call exit_kp while kp is exited at first argument, keep last executed information
    return 0
  fi
  selected_ns="-n $ns"
  if [[ $ns = "all" ]]; then
    selected_ns="--all-namespaces"
  fi

  # Get Resource
  if [[ -z $rs ]]; then
    rs=$(echo "all\n$(kubectl api-resources)" | peco | awk '{print $1}')
  fi
  echo Resource: $rs
  if [[ -z $rs ]]; then
    exit_kp
    return 0
  fi
  
  # Get Name
  if [[ -z $name ]]; then
    data=$(kubectl get $rs -o wide ${=selected_ns} | peco)
    if [[ $ns = "all" ]]; then
      selected_ns="-n $(echo $data | awk '{print $1}')"
      name=$(echo $data | awk '{print $2}')
    else
      name=$(echo $data | awk '{print $1}')
    fi
  fi
  if [[ -z $name ]]; then
    exit_kp
    return 0
  fi

  echo Name: $name

  # Generate/Get commands
  cmd_list="describe\nedit\ndelete"
  if [[ $rs = "pods" ]] || [[ $rs = "all" && $name = "pod/"* ]] ; then
    cmd_list="${cmd_list}\nlogs\nexec"
    fi

    if [[ -z $cmd ]]; then
      cmd=$(echo "$cmd_list" | peco)
    fi
  echo Cmd: $cmd

    # Execute
  total_cmd="NOT_EXECUTED"
  if [[ ! -z $cmd ]]; then
    set -ex
    if [[ $cmd = "logs" ]]; then # logs doesn't need rs
      total_cmd="kubectl $cmd ${=selected_ns} $name"
    elif [[ $cmd = "exec" ]]; then # exec need -it and bash
      total_cmd="kubectl $cmd -it ${=selected_ns} $name bash"
    elif [[ $rs = "all" ]]; then # name contains resource type if rs=all
      total_cmd="kubectl $cmd ${=selected_ns} $name"
    else
      total_cmd="kubectl $cmd ${=selected_ns} $rs $name"
    fi
    set +ex
    else
      exit_kp
      return 0
    fi
    echo $total_cmd > $HOME/.kp/last_exec
    eval $total_cmd
    __backup_kp_cmd
}

lkp(){
    cat $HOME/.kp/last_exec
}

rkp(){
  revert_num=$1
  if [[ -z $revert_num ]]; then
    eval $(lkp)
  elif [[ $revert_num = "1" ]]; then
    kp $(cat $HOME/.kp/last_ns)
  elif [[ $revert_num = "2" ]]; then
    kp $(cat $HOME/.kp/last_ns) $(cat $HOME/.kp/last_rs)
  elif [[ $revert_num = "3" ]]; then
    kp $(cat $HOME/.kp/last_ns) $(cat $HOME/.kp/last_rs) $(cat $HOME/.kp/last_name)
  fi
}
#!/bin/bash

# Generate kubectl shortcut aliases
## k[n|a]<command><resource> [other-options]
# Usage:
# kubectl -n kube-system get pod => NS=kube-system; kngp
## [n|a] (Note that not all commands can combine with --all-namespaces)
### n => -n $NS
### a => --all-namespaces
## Command List
### l => logs
### x => exec -it
_K8S_COMMAND_LIST=(
  'g/get'
  'd/describe'
  'e/edit'
  'r/delete'
)
_K8S_RESOURCE_LIST=(
  ## Cluster Resources List
  'n/Nodes'
  'ns/Namespaces'
  'l/LimitRanges'
  ## RBAC Resources List
  'crb/ClusterRoleBindings'
  'rb/RoleBindings'
  'cr/ClusterRoles'
  'r/Roles'
  ## App Related Resources List
  'ds/DaemonSets'
  'd/Deployments'
  'rs/ReplicaSets'
  'ss/StatefulSets'
  'rc/ReplicationControllers'
  'p/Pods'
  'j/Jobs'
  'cj/Cronjob'
  'pvc/PersistentVolumeClaims'
  'pv/PersistentVolumes'
  'q/ResourceQuotas'
  'svc/Services'
  'c/ConfigMaps'
  'cm/ConfigMaps'
  'i/Ingresses'
  'e/Events'
  's/Secrets'
  'sa/ServiceAccounts'
  'sc/StorageClasses'
  'np/NetworkPolicies'
  'ep/Endpoints'
)
__generate_k8s_aliases() {
  local OUTPUT=${1:-"$HOME/.k8s_aliases.sh"}
  cat << 'EOF' >> $OUTPUT
export NS=default
alias ns='echo $NS'
alias k='kubectl'
alias kn='kubectl -n $NS'
alias ka='kubectl --all-namespaces'

alias kg='kubectl get'
alias kng='kubectl get -n $NS'
alias kag='kubectl get --all-namespaces'
alias ke='kubectl edit'
alias kne='kubectl edit -n $NS'
alias kd='kubectl describe'
alias knd='kubectl describe -n $NS'
alias kr='kubectl delete'
alias knr='kubectl delete -n $NS'

# exec and logs doesn't need resource
alias kx='kubectl exec -it'
alias kl='kubectl logs'
alias knx='kubectl -n $NS exec -it'
alias knl='kubectl -n $NS logs'

EOF
  for command in "${_K8S_COMMAND_LIST[@]}"; do
    echo "# Command $command" >> $OUTPUT
    for resource in "${_K8S_RESOURCE_LIST[@]}"; do
      echo "## Resource $resource" >> $OUTPUT
      cmd_shortcut=$(echo "$command" | awk -F '/' '{print $1}')
      rs_shortcut=$(echo "$resource" | awk -F '/' '{print $1}')
      cmd=$(echo "$command" | awk -F '/' '{print $2}')
      rs=$(echo "$resource" | awk -F '/' '{print $2}')
      echo "alias k${cmd_shortcut}${rs_shortcut}='kubectl $cmd $rs'" >> $OUTPUT
      echo "alias kn${cmd_shortcut}${rs_shortcut}='kubectl -n \$NS $cmd $rs'" >> $OUTPUT
      echo "alias ka${cmd_shortcut}${rs_shortcut}='kubectl $cmd --all-namespaces $rs'" >> $OUTPUT
      echo "" >> $OUTPUT
    done
  done
}
if [[ ! -f "$HOME/.k8s_aliases.sh" ]]; then
  __generate_k8s_aliases $HOME/.k8s_aliases.sh
fi
source $HOME/.k8s_aliases.sh

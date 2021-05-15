# Kubectl Life Saver

Kubectl shortcut aliases and a interactive command builder.

## Installation

Source scripts you want in your `.rc` files, such as `.bashrc` or `.zshrc`.

# Alias generator

Generator will generates aliases store at `$HOME/.k8s_aliases.sh`.

Script will detect if this file exists. If not, the script will generate it.

## Usage

```ebnf
k[n|a]<command><resource> [other-options]
k[n]<x|l> <podname> [other-options]
```

- k: `kubectl`
- n: `-n $NS`
- a: `--all-namespaces`

Set `NS=xx` before use `kn` aliases. If you added ksn.sh in your rc file, you can use `ksn` to auto set the `NS` with completion from your current kube context.

```
ksn kube-system
ksn kube-sys[TAB] -> ksn kube-system
```

Check namespace by `ns` or it's equivalent `echo $NS`.

### Example

```bash
kgn # kubectl get nodes
kgn -o wide # kubectl get nodes -o wide

ksn kube-system
kngp # kubectl -n $NS get pods
kngp --watch # kubectl -n $NS get pods --watch
knl podname # kubectl -n $NS logs podname
knx podname bash # kubectl -n $NS exec -it podname bash
```

The script may generate some invalid aliases or override some existed commands, use it at your own risk.

If you don't want to use variable `NS`, case-sensitive search `NS` and replace it.

## All commands

You can add/edit/remove command aliases in the array `_K8S_COMMAND_LIST` with format `<shortname>/<command>`.

- g: `get`
- d: `describe`
- e: `edit`
- r: `delete`

### Special commands

- x: `exec -it`, the only aliases are `kx` and `knx`.
- l: `logs`, the only aliases are `kl` and `knl`.

## All resources

Resources store in array `_K8S_RESOURCE_LIST` with same rule like commands.

- n: Nodes
- ns: Namespaces
- l: LimitRanges
- lr: LimitRanges
- crb: ClusterRoleBindings
- rb: RoleBindings
- cr: ClusterRoles
- r: Roles
- ds: DaemonSets
- d: Deployments
- rs: ReplicaSets
- ss: StatefulSets
- rc: ReplicationControllers
- p: Pods
- j: Jobs
- cj: Cronjob
- pvc: PersistentVolumeClaims
- pv: PersistentVolumes
- q: ResourceQuotas
- svc: Services
- c: ConfigMaps
- cm: ConfigMaps
- i: Ingresses
- e: Events
- s: Secrets
- sa: ServiceAccounts
- sc: StorageClasses
- np: NetworkPolicies

# Interactive command builder using peco

`kp` means `kubectl-peco`. It provides a interactive command builder using [peco](https://github.com/peco/peco), you need install it first.

## Usage

`kp` will ask you four information, namespace, resource, name, and command.

`lkp` will display `last-kp` command.

`rkp` will re-run last `kp` command, and parameter can be `1~3`. `rkp N` will provide first N parameters in last executed `kp` command. 

Last executed info stored in folder `$HOME/.kp`.

### Example

```bash
kp # run kp without parameters, will ask you 4 params
kp kube-system pod # provide N parameters will skip first N ask process
rkp 2 # In this situation, it equals to `kp kube-system pod`
rkp 1 # Equals to `kp kube-system`
lkp # Display last executed command
```

# Interactive exec/logs command

This two functions let you exec/logs pod without copy/paste podname, using `peco`.

Requires `knx` and `knl` generated above.

## Example

```bash
iknx # default cmd is `bash`
iknx sh # provide args replace cmd
iknx cat /etc/hosts

iknl
iknl -f
```


Enjoy!

ksn(){
        export NS=$1
}

complete -C 'kubectl get namespace' ksn

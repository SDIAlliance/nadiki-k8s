# Debug Commands

This daemonset is useful to test network functionality etc. on all cluster nodes

## Test DNS on all nodes
``for i in `k get pods -n default -o name | grep debug-helper`; do k exec -it $i -- nslookup www.nu.nl; done``

## Test connectivity to internet
``for i in `k get pods -n default -o name | grep debug-helper`; do k exec -it $i -- nc -vz github.com 443; done``
``for i in `k get pods -n default -o name | grep debug-helper`; do k exec -it $i -- ping -c 2 www.nu.nl; done``
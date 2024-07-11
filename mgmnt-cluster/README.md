
# Tantlinger - Kubernetes as a Service on Hetzner

## Introduction

This repository contains the [Ansible](https://www.ansible.com/) playbook to install & configure the Kubernetes management cluster on Hetzner cloud servers

## Prerequisites

### Dependencies

Install the latest versions of `ansible`,`clusterctl` , `argocd` and `kubectl` through your preferred package manager


## Kubernetes Management Cluster

The Kubernetes management cluster infrastructure is managed through [Terraform](https://www.terraform.io/). The Kubernetes cluster itself is bootstrapped through on Ansible & [Kubespray](https://github.com/kubernetes-sigs/kubespray).

### Longhorn

[Longhorn](https://longhorn.io/) provides distributed block storage for the management cluster.

The GUI can be accessed on `http://localhost:8080/#/dashboard` through `kubectl port-forward`:
`kubectl -n longhorn-system port-forward svc/longhorn-frontend 8080:80`

### ArgoCD

ArgoCD is used to automatically deploy resources in the master cluster, to deploy the worker clusters and to deploy resources in the worker cluster.
The GUI is available through the ArgoCD cli at `http://localhost:8080`:

`kubectl config set-context --current --namespace=argocd`
`argocd login --core`
`argocd admin dashboard`

### Prometheus - Grafana

The Prometheus GUI an be accessed on `http://localhost:9090` through `kubectl port-forward`:
`kubectl --namespace monitoring port-forward svc/prometheus-operated 9090`

The Grafana Dashboard can be accessed on `http://localhost:8082` through `kubectl port-forward`:
`kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 8082:80`

Grafana username is 'admin' and password can be found through: `kubectl get secret --namespace monitoring kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

The Alert Manager GUI an be accessed on `http://localhost:9093` through `kubectl port-forward`:
`kubectl --namespace monitoring port-forward svc/alertmanager-operated 9093`

### KubeVirt Manager

KubeVirt Manager is a GUI for kubevirt/libvirt. It allows access to the VM console through a browser.
Can be accessed on `http://localhost:8888` through `kubectl port-forward`:
`kubectl -n kubevirt-manager port-forward svc/kubevirt-manager 8888:8080`


#### Applications

ArgoCD `Applications` & `ApplicationSet` are defined in repository `mgmnt-cluster-argocd-base`
Manifests can be found in the `base` directory.

#### Tenant Clusters

Tenant clusters are defined in a config file in repository `mgmnt-cluster-argocd-tenants`.
Structure: `/tenants/<CLUSTER TYPE>/<TENANT NAME>/config.yaml`

## API Definitions

### cluster-api

API definitions can be found at: https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api@v1.5.2

### cluster-api-provider-kubevirt

API definitions can be found at: https://doc.crds.dev/github.com/kubernetes-sigs/cluster-api-provider-kubevirt@v0.1.2

### cluster-api-provider-hetzner

API definitions can be found at: https://doc.crds.dev/github.com/syself/cluster-api-provider-hetzner@v1.0.0-beta.17

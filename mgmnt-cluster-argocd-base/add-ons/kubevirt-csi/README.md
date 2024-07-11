# README

git clone git@github.com:kubevirt/csi-driver.git kubevirt-csi-driver

cd kubevirt-csi-driver

kubectl kustomize ./deploy/controller-infra/base/ > ../mgmnt-cluster-argocd-base/add-ons/kubevirt-csi/host/controller.yaml

kubectl kustomize ./deploy/tenant/base/ > ../mgmnt-cluster-argocd-base/add-ons/kubevirt-csi/tenant/deploy.yaml
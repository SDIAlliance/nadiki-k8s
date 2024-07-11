# Management Cluster for the Clouds of Europe

It all starts with: github.com/tantlinger/mgmnt-cluster/k8s/argocd-base-app.yaml:

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: private-repo-creds
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repo-creds
stringData:
  type: git
  url: https://github.com/tantlinger/
  password: ${ARGOCD_GITHUB_TOKEN}
  username: ""  # Username should be empty when using github token
---
apiVersion: v1
kind: Secret
metadata:
  name: tantlinger-argocd-mgmnt
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: https://github.com/tantlinger/mgmnt-cluster-argocd-base
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: base
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/tantlinger/mgmnt-cluster-argocd-base
    targetRevision: main
    path: base
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      allowEmpty: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true
```

This defines the github credentials and the ‘base’ app.

The base app will pick up all manifests defined in [https://github.com/tantlinger/mgmnt-cluster-argocd-base/base](https://github.com/tantlinger/mgmnt-cluster-argocd-base/base)

The base consists of two types of ArgoCD applications:

* `Application` (for example: `cert-manager.yaml`)
* `ApplicationSet` (for example: `cilium.yaml`)

`Application` are installed on a singular target, usually `https://kubernetes.default.svc` (the local cluster Argocd runs on) in our case.

`ApplicationSet` are installed on multiple targets, depending on the `Generator` used.

The `ApplicationSet` in `cilium.yaml` will be installed on all clusters labeled `tenant` for example:

```yaml
generators:
    - clusters:
        selector:
          matchLabels:
            clusterType: "tenant"
```

While `longhorn.yaml` will be installed on the host cluster:

```yaml
generators:
    - clusters:
        selector:
          matchLabels:
            clusterType: "host"
```

Most of the Applications or ApplicationSets use third party Helm charts to install applications, for example `kyverno.yaml`:

```yaml
source:
    chart: kyverno
    repoURL: https://kyverno.github.io/kyverno/
    targetRevision: '3.0.2'
    helm:
      releaseName: kyverno
      values: |
        config:
          logging:
            verbosity: 4
        admissionController:
          replicas: 1
        cleanupController:
          rbac:
            clusterRole:
              extraResources:
              - apiGroups:
                  - ''
                resources:
                  - namespaces
                  - secrets
```

Some however refer to ‘locally’ defined manifests or helm charts, for example the Kyverno policies:

```yaml
source:
    repoURL: https://github.com/tantlinger/mgmnt-cluster-argocd-base
    targetRevision: main
    path: add-ons/kyverno-policies
```
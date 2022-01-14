[comment]: # ( Copyright Contributors to the Open Cluster Management project )

# cluster-lifecycle-chart

[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)

## cluster-lifecycle-chart

The following components are deployed with the cluster-lifecycle-chart:
- [managedcluster-import-controller](https://github.com/stolostron/managedcluster-import-controller)
- [klusterlet-addon-controller](https://github.com/stolostron/klusterlet-addon-controller)
- [cluster-curator-controller](https://github.com/stolostron/cluster-curator-controller)
- [clusterlifecycle-state-metrics](https://github.com/stolostron/clusterlifecycle-state-metrics)

Go to the [Contributing guide](CONTRIBUTING.md) to learn how to get involved.

## Getting started

### Steps for development:

- To push that chart onto an ACM environment for test run:

```
oc annotate mch multiclusterhub mch-pause=true -n open-cluster-management --overwrite

helm get values  -n open-cluster-management `helm ls -n open-cluster-management | cut -d' ' -f1 | grep cluster-lifecycle` > old-values.yaml

cp stable/cluster-lifecycle/values.yaml new-values.yaml

#Edit new-values.yaml and replace global.imageOverrides: with the same section in old-values.yaml

oc delete appsub cluster-lifecycle-sub  -n open-cluster-management

helm install cluster-lifecycle stable/cluster-lifecycle -f new-values.yaml -n open-cluster-management
```

- once you finished your test run again:

```
helm uninstall cluster-lifecycle -n open-cluster-management
oc annotate mch multiclusterhub mch-pause=false -n open-cluster-management --overwrite
```

### Security
- Check the [Security guide](SECURITY.md) if you need to report a security issue.

## References

- The cluster-lifecycle-chart is part of the `open-cluster-management` community. For more information, visit: [open-cluster-management.io](https://open-cluster-management.io).
- Optional: List and link of additional references if needed.

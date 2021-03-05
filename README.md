[comment]: # ( Copyright Contributors to the Open Cluster Management project )

# cluster-lifecycle-chart


## Getting Started
To push that chart into an ACM environment for test run:

```
oc annotate mch multiclusterhub mch-pause=true -n open-cluster-management --overwrite
oc delete managedcluster local-cluster -n open-cluster-management
oc delete appsub rcm-sub  -n open-cluster-management
helm install cluster-lifecycle stable/cluster-lifecycle -f stable/cluster-lifecycle/values.yaml -n open-cluster-management
```

once you finished your test run again:

```
helm uninstall rcm -n open-cluster-management
oc annotate mch multiclusterhub mch-pause=false -n open-cluster-management --overwrite
```

# rcm-chart

## Testing

To push that chart into an environment for test run:

```
oc annotate mch multiclusterhub mch-pause=true -n open-cluster-management
oc delete appsub rcm-sub  -n open-cluster-management
helm install rcm stable/rcm -f stable/rcm/values.yaml -n open-cluster-management
```

once you finished your test run again

```
helm uninstall rcm -n open-cluster-management
oc annotate mch multiclusterhub mch-pause=false -n open-cluster-management --overwrite
```
Install the rosa and oc cli tools

Export the following variable and their values

```shell
export AWS_PROFILE=<aws account secret and key profile>
export ACCOUNT_ID=<associated account>
export AWS_REGION=<aws region to build the cluster>
export RHCS_TOKEN=<token to connect with OCM to build ROSA cluster>
export TF_VAR_admin_credentials_password=<password>
export TF_VAR_cluster_name=<cluster name>
```

run

```shell
./build_cluster.sh
```

from the root of the repo.
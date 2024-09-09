# Run terraform to get output, this can be check as you will still have to manually confirm the apply
# Whole start to cluster ready should take around 20 minutes
echo "Run terraform"
cd tf_rosa-hcp
terraform init
terraform plan -out planfile.tf

terraform apply planfile.tf

cd ..

# Cluster in place but some pods might still be starting up.
# Grab the cluster API first and then cycle until you can log in
CLUSTER_API=`rosa describe cluster -c $TF_VAR_cluster-name --region $AWS_REGION -o json | jq -r '.api.url'`

sucessful_login="^Login successful*"
while True
do
	response=`oc login $CLUSTER_API --username cluster-admin --password $TF_VAR_admin_credentials_password`
	echo $response
	if [[ $response =~ $sucessful_login ]]; then
		echo "Break"
		break
	else
		sleep 60
	fi 
done

echo "Api URL"
echo $CLUSTER_API

echo "Console URL"
echo `rosa describe cluster -c $TF_VAR_cluster-name --region $AWS_REGION -o json | jq -r '.console.url'`
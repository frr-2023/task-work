#!/usr/bin/env bash
#We declare the different helm paths with their namespace in a hash table
declare -A helm_installations=(
  [".dependencies/helm/prometheus"]="prometheus"
  [".dependencies/helm/redis"]="felfel"
  ["helm/task-work"]="felfel"
)

deploy_release_helm(){
  release_name=$(basename $1)
  namespace=$2
  cd $1
  helm dependency build
  helm install -f values.yaml ${release_name} . -n ${namespace}
  sleep 3
  cd -
}




#Create dependencies as namespaces and the secret for redis.
#This resources are created with a simple manifests.

#echo "Creating Dependencies..."
kubectl apply -f .dependencies/resources.yaml


#Loop for calling the function that builds the dependencies and installs the helm release
for helm_dir in "${!helm_installations[@]}"
  do
    deploy_release_helm "$helm_dir" "${helm_installations[$helm_dir]}"
    pwd
  done
echo "All applications installed with helm!"

exit 0
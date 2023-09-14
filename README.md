# FELFEL TASK-WORK

## Description
The purpose of this repository is to have all the files needed for executing the exercise required in the hiring process.

In this document you will find all the files required. And some explanations related with the different tasks required.


## Directory Structure

```shell script
├── .dependencies --> On a real project this would not be commited. But, for setup purpose was included
├── compose --> Directory for the compose definition used building and executing the application locally.
│   └── docker-compose.yaml
├── Dockerfile
├── helm  --> Helm Manifests
│   ├── prometheus --> Dependency as we is needed a prometheus in the K8S clusters. In a real application it would not be here.
│   ├── redis --> Dependency as we is needed a redis. In a real application it would not be here.
│   └── task-work --> Helm files for deploying the python application with the needed resources.
├── README.md
├── task-work --> Application Directory
│   ├── api.py
│   ├── prom_metrics.py
│   └── requirements.txt
```


## Tasks

##Task1: Python build

You can find the [requirements.txt](task-work/requirements.txt) with the definition of the dependencies and locked versions.

##Task2: Docker build

The [Dockerfile](Dockerfile) has a simple definition related with the parent imagechase and with the typical commands for copying
 the files and install the dependencies with PIP.

##Task3: Docker Compose

The [docker-compose](compose/docker-compose.yaml) file specifies the python and redis containers that has the systems. The environment variables
that configures the  access to the redis is mainly empty as we are not configure any type of access in the redis instance.

##Task4: Prometheus

The code [directory](task-work) has the file [prom_metrics.py](task-work/prom_metrics.py) where a Gauge metric is defined for having the count of the 
hits that [api.py](task-work/api.py) will be setting on each call.

##Task5: Helm Manifests

The sub-directory [helm/task-work](helm/task-work) contains the helm manifests for deploying the resources in K8S.
This directory was created using the `helm create task-work` and it was modified according to needs. 

```
service:
  type: ClusterIP
  port: 8080
  annotations:  # We add annotations for the auto discovery of prometheus to get the metrics.
    felfel.prometheus/scrape: "true"
    felfel.prometheus/path: "/metrics"
[...]
ingress:
  enabled: true
  hosts:
    - host: task-work.test
      paths:
        - path: /
          pathType: ImplementationSpecific
[...]
env:     # We configure the environment of the python container, so redis would be configured. 
  - name: REDIS_PASSWORD   # As the chart that we are using for deploying redis allows to create a redis instance with a existing secret that we previoulsy launched, we populate the variable here.
    valueFrom:
      secretKeyRef:
        name: redis-secret
        key: redis-password
  - name: REDIS_HOST
    value: "redis-master"
  - name: REDIS_USERNAME
    value: ""
  - name: REDIS_PORT
    value: "6379"
  - name: REDIS_DB
    value: "0"
```


#Task6: Bash Script

For this deploying in the local cluster, we are assuming that we have enabled the ingress
```shell script
minikube addons enable ingress
minikube addons enable ingress-dns
```

My current setup also includes the configuration of dnsmasq to resolve the dns queries with the k8s dns cluster.

```shell script
$ cat/etc/NetworkManager/conf.d/00-use-dnsmasq.conf
# /etc/NetworkManager/conf.d/00-use-dnsmasq.conf
#
# This enabled the dnsmasq plugin.
[main]
dns=dnsmasq

$ cat /etc/NetworkManager/dnsmasq.d/minikube.conf
server=/test/192.168.49.2
```

Links:
http://task-work.test/
http://task-work.test/metrics
http://prometheus.test/



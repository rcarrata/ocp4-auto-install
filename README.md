# Openshift4 Auto Install

This repository provides a way for deploying openshift4 IPI in AWS (and Azure in WIP)
and perform the Post Install and Day2Operations

Openshift installer is used along with Ansible for creation and customization of the Openshift Cluster.

The main features are:

* Easy deployment of OCP4 cluster IPI in AWS or Azure
* No Bastion needed and no local software additional installation (installation and configuration within a container)
* Configuration of the PostInstall and Day2Operations
* Low Requirements for the deployment (only podman is needed)
* Fully running in RHEL, Fedora and Centos
* Modularized for working certain day2ops
* Idempotent (I hope!) and repetible

## Requirements

* Podman
* Some hope and time :)

## Create/Customize the Variables yaml

* Copy or generate the vars.yml and customize to fill your needs:

```
cp -pr examples/vars.yml vars/vars.yml
```

* Generate a Vault-File with the credentials of AWS/Azure and OCP4 PullSecret:

```
$ ansible-vault edit vault/vault.yml
```

and fill inside the vault.yml with:

```
aws_access_key_id: SECRET
aws_secret_access_key: SECRET
ocp4_pull_secret: '<<< pull_secret_azure >>>'
```

for obtain the pull_secret go to [OCP4 Install](https://cloud.redhat.com/openshift/install)

* Generate the .vault-password-file and put the password

```
touch .vault-password-file
echo "yourpasswordfancy" >> .vault-password-file
```

## Automated deployment end2end of Openshift4 cluster (end2end)

Execute and wait a little bit:

```
./ocp4-auto-install.sh
```

In this way, podman will be used for build and run the centos8 container that will be used for the installation and configuration of the Openshift4 cluster.

## Custom Deployment

The container for the installation could be used for Post Install or Day2Operations without deploy the whole cluster

## Customizations

#### Openshift Cluster Variables

```
ocp4_version: '4.3.3'
cloud_provider: 'ec2' or 'azure'
cluster_name: 'myfancycluster'
ocp4_base_domain: 'yourbasedomain'
aws_region: eu-central-1
master_instance_type: m5.xlarge
master_instance_count: 3
worker_instance_type: m5.xlarge
worker_instance_count: 3
```

#### Day2Operations Variables

* Deploy only the post-install without deploy the cluster

```
only_post_install: False
```

* Configure the OAuth between htpasswd, ldap, Google OAuth and Azure(wip):

```
# OAuth
oauth: htpasswd
removekubeadmin: False
removeselfprovisioning: False
```

Azure: azure
Google OAuth: google
LDAP/IDM: ldap
Htpasswd: htpasswd

* Deploy worker nodes (WIP)

```
# Worker Nodes
worker_nodes: True
```

* Deploy infra nodes (WIP)

```
# Infra Nodes
infra_nodes: True
disk_size: 1024
instance_type: r5.xlarge
```

* Deploy OCS4 (WIP)

```
# OCS4
ocs: True
```

* Deploy Logging EFK (WIP)

```
# Logging
logging: True
```

* Deploy Monitoring (WIP)

```
# Monitoring
monitoring: True
```

## TODO:

* Run Container in no root mode
* Build and Push to Quay the image
* Add more day2ops
* Customize the SSH-Key to add
* Add latest version to the installation


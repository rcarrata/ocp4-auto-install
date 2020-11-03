# Openshift4 Auto Install

> **Note**: This is a WIP repository. Expect some changes, and modifications in the future.

This repository provides a way for deploying openshift4 IPI in AWS (and Azure in WIP)
and perform the Post Install and Day2Operations 100% automatically

Openshift installer is used along with Ansible for creation and customization of the Openshift Cluster.

<img align="center" width="750" src="/pics/wf1.png">

Each day2 operations in this repo can be executed isolated (e.g. only execute day2ops logging for
configure logging stack)

## Features

The main features are:

* Easy deployment of OCP4 cluster IPI in AWS or Azure
* No Bastion needed and no local software additional installation (only Ansible is needed)
* Configuration of the PostInstall and Day2Operations
* Ansible Tower friendly!
* Modularized & Capable of executing specific day2ops (only execute logging)
* Idempotent and easy to debug
* Versatile and modular with parameters

## Installation & Prerequisites

### Requirements

* Ansible
* Ansible Tower (optional)
* Some pip modules (boto3, kubernetes, openshift and pylint)

### Create/Customize the Variables yaml

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

* Opt: If you want to generate Let's Encrypt Certificates install the collection requirements

```
ansible-galaxy collection install -r collections/requirements.yml
```

## Usage

### Automated deployment end2end of Openshift4 cluster (end2end)

Execute and wait a little bit:

```
./auto_deploy.sh
```

## Custom Deployment

The container for the installation could be used for Post Install or Day2Operations without deploy the whole cluster

* For Deploy only day2ops:

```
ansible-playbook -i ,localhost deploy_day2ops.yml --ask-vault-pass
```

* For install only and no day2ops:

```
ansible-playbook -i ,localhost deploy_only.yml --ask-vault-pass
```

* For install only an specific day2ops:

```
ansible-playbook -i ,localhost deploy_only_<MY_DAY2OPS>.yml
```

## Customizations (WIP)

#### Kubeconfig

The installer will look at specific kubeconfig at {{ user_path }}/auth/kubeconfig but you can use
your own kubeconfig in order to deploy this day2ops whenever its using it:

```
kubeconfig: ~/.kube/ocp4-opentlc
```

#### Openshift Cluster Variables

```
ocp4_version: '4.4.3'
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
only_post_install: True
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

* Deploy worker nodes

```
# Worker Nodes
worker_nodes: True
```

* Deploy infra nodes

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

* Deploy Logging EFK

```
# Logging
logging: True
```

* Deploy Monitoring

```
# Monitoring
monitoring: True
```

## Tower Integrations

The installation and the day2ops are prepared to be integrated into Tower, and executed in workflows
and Job Templates.

An example of execution could be the following:

* Workflow
![Tower Workflow](/pics/tower1.png)

* Survey
<img width="250" src="/pics/tower2.png" >

* Webhook Execution
<img align="center" width="250" src="/pics/tower3.png">

* Status in GH and Tower
<img align="center" width="250" src="/pics/tower4.jpg">

## TODO:

* Finish the Tower integrations and fully automations
* Add molecule to testing this modules
* Add Github actions
* Add more day2ops
* Customize the SSH-Key to add
* Add latest version to the installation
* Add more documentation to each day2ops
* Time Control between infra nodes and the migrate of logging, monitoring, registry
* Move vault from the first creds and move it after

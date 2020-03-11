FROM centos:8

RUN dnf -y upgrade && dnf -y install git unzip jq wget python3 python3-pip gcc libffi-devel openssl-devel tmux unzip vim python3-dev httpd-tools
RUN pip3 install ansible yq ansible-lint psutil kubernetes openshift htpasswd

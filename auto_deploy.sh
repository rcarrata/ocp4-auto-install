#!/bin/bash

echo "Welcome to OCP4 Auto install"
echo "Executing Ansible Playbooks..."

ansible-playbook -i localhost --password-file .password-file deploy_all.yml

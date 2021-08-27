#!/bin/bash

echo "Welcome to OCP4 Auto install"
echo "Executing Ansible Playbooks..."

ansible-playbook -i localhost --vault-password-file .vault-password-file deploy_all.yml

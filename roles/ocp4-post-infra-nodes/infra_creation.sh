#!/usr/bin/env bash

export REGION="eu-west-1"
export AZS="${REGION}a ${REGION}b ${REGION}c"
export FLAVOR="m5.xlarge"

MACHINESET_PREFIX=$(oc get machineset -n openshift-machine-api -o json| jq '.items[0].metadata.labels."machine.openshift.io/cluster-api-cluster"' | tr -d '""')

for AZ in ${AZS}; do
  export NAME="${MACHINESET_PREFIX}-ocpqa-infra-${AZ}"
  export AZ=$AZ
  export SUBNET=${MACHINESET_PREFIX}-private-${AZ}

  echo " ** Generating JSON for Infra node $NAME (AZ: ${AZ})"
  oc get machineset -n openshift-machine-api -o json\
  | jq '.items[0]' \
  | jq '.metadata.name=env["NAME"]'\
  | jq '.metadata.selfLink=""'\
  | jq '.metadata.uid=""'\
  | jq '.spec.selector.matchLabels."machine.openshift.io/cluster-api-machineset"=env["NAME"]'\
  | jq '.spec.template.metadata.labels."machine.openshift.io/cluster-api-machineset"=env["NAME"]'\
  | jq '.spec.template.spec.providerSpec.value.placement.availabilityZone=env["AZ"]'\
  | jq '.spec.template.spec.providerSpec.value.placement.region=env["REGION"]'\
  | jq '.spec.template.spec.metadata.labels."node-role.kubernetes.io/infra"=""'\
  | jq '.spec.template.spec.providerSpec.value.subnet.filters[0].values[0]=env["SUBNET"]' \
  | jq 'del (.metadata.annotations)' \
  | jq '.spec.template.spec.providerSpec.value.instanceType=env["FLAVOR"]' \
  > ./infranode-machineset-$NAME.json

done


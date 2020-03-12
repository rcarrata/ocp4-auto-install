apiVersion: machine.openshift.io/v1beta1
kind: MachineSet
metadata:
  labels:
    machine.openshift.io/cluster-api-cluster: ${infraID}
  name: ${infraID}-${infra_node}
  namespace: openshift-machine-api
spec:
  replicas: ${replicas}
  selector:
    matchLabels:
      machine.openshift.io/cluster-api-cluster: ${infraID}
      machine.openshift.io/cluster-api-machine-role: infra
      machine.openshift.io/cluster-api-machine-type: infra
      machine.openshift.io/cluster-api-machineset: ${infraID}-${infra_node}
  template:
    metadata:
      labels:
        machine.openshift.io/cluster-api-cluster: ${infraID}
        machine.openshift.io/cluster-api-machine-role: infra
        machine.openshift.io/cluster-api-machine-type: infra
        machine.openshift.io/cluster-api-machineset: ${infraID}-${infra_node}
    spec:
      metadata:
        labels:
          node-role.kubernetes.io/infra: ""
      providerSpec:
        value:
          ami:
            id: ${ami_id}
          apiVersion: awsproviderconfig.openshift.io/v1beta1
          blockDevices:
          - ebs:
              iops: 0
              volumeSize: 120
              volumeType: gp2
          credentialsSecret:
            name: aws-cloud-credentials
          deviceIndex: 0
          iamInstanceProfile:
            id: ${infraID}-infra-profile
          instanceType: ${instanceType}
          kind: AWSMachineProviderConfig
          metadata:
            creationTimestamp: null
          placement:
            availabilityZone: ${az}
            region: ${AWS_REGION}
          publicIp: null
          securityGroups:
          - filters:
            - name: tag:Name
              values:
              - ${infraID}-sg-infra
          subnet:
            filters:
            - name: tag:Name
              values:
              - vpc-ocp-private-${az}
          tags:
          - name: kubernetes.io/cluster/${infraID}
            value: owned
          userDataSecret:
            name: worker-user-data
status:
  fullyLabeledReplicas: 1
  observedGeneration: 1
  replicas: 1

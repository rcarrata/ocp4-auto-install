apiVersion: v1
data:
  clientSecret: ${clientSecret}
kind: Secret
metadata:
  name: openid-client-secret-qa
  namespace: openshift-config
type: Opaque

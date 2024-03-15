# Objective
- Create a developer centric secure supply chain SLSA L3
- Have a safe path from build to production
- Use standards of security for supply chain

# Platform
2 Kind clusters 
- `chain-prod`
- `chain-dev`

Argo Workflow and Argo Event deployed in `chain-prod` in `argo` namespace.

Contour Ingress Controller deployed in `chain-prod` in `projectcontour` namespace. 


# Create environment 
```
kind create cluster --config kind-cluster/kind-conf-dev.yaml --name chain-dev
kind create cluster --config kind-cluster/kind-conf-prod.yaml --name chain-prod
```

Save both kubeconfig:
- `kind-cluster/chain-dev.config`
- `kind-cluster/chain-prod.config`

Make sure the `server` url in `kind-cluster/chain-dev.config` is reachable from `chain-prod`

# Install Ingress controller
```
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
kubectl patch daemonsets -n projectcontour envoy -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"}}}}}'
```

# Install Argo
```
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argo argowf -f deployments/argowf-values.yaml argo/argo-workflows 
```
Argo is exposed using `argo.chain-prod.com`, feel free to adapt the exposition

# Install Argo Event
```
helm repo add argo https://argoproj.github.io/argo-helm
helm install -n argo argoev -f deployments/argoev-values.yaml argo/argo-events
```

# Create secrets
1. Create the following secret on `chain-prod`
```
kubectl create secret generic dev-kubeconfig -n argo --from-file kind-cluster/chain-deb.config
```

2. Login to `DockerHub` using `docker login`
```
kubectl create secret -n argo docker-registry tutorial-registry-credentials --from-file=.dockerconfigjson=<path_to>.docker/config.json --from-file=config.json=<path_to>.docker/config.json
```
Note: Some apps (Cosign, Syft) uses `config.json` and Kpack uses `.dockerconfigjson`. There is many ways, better than this one to handle this :) 

3. Create a `cosign` key 
Follow [the install guide](https://docs.sigstore.dev/system_config/installation/) if you don't have `cosign` setup
```
cosign generate-key-pair k8s://argo/cosign
```

# Service Accounts
1. In `argo` namespace, make sure the `argowf-argo-workflows-workflow` role has the following permissions :

```
rules:
- apiGroups:
  - ""
  resources:
  - pods
  - secrets
  verbs:
  - get
  - watch
  - patch
- apiGroups:
  - ""
  resources:
  - pods/log
  verbs:
  - get
  - watch
- apiGroups:
  - ""
  resources:
  - pods/exec
  verbs:
  - create
- apiGroups:
  - argoproj.io
  resources:
  - '*'
  verbs:
  - '*'
- apiGroups:
  - argoproj.io
  resources:
  - workflowtaskresults
  verbs:
  - create
  - patch
- apiGroups:
  - argoproj.io
  resources:
  - workflowtasksets
  - workflowartifactgctasks
  verbs:
  - list
  - watch
- apiGroups:
  - argoproj.io
  resources:
  - workflowtasksets/status
  - workflowartifactgctasks/status
  verbs:
  - patch
- apiGroups:
  - argoproj.io
  resources:
  - workflowtaskresults
  verbs:
  - create
  - patch
```

2. Create the `app` namespace, and create a `role` and `rolebinding`:

This allows the `deployment steps` to deploy in the `app` namespace 
```
kubectl create ns app
kubectl create role -n app argo-app --resource pods --resource ingress --resource svc --verb "*" --resource deployments
kubectl create rolebinding argo-app -n app --role=argo-app  --serviceaccount=argo:argo-workflow-sa
```

3. Apply the `rbac` for `argo event`
```
kubectl apply -n argo -f deployments/argoev-rbac.yaml 
```

# Fork the app
Fork the [spring-petclinic](https://github.com/spring-projects/spring-petclinic) app in your Github account.

# Deploy the event source
Connect on Github and create an API token (you can use the fine-grain beta version available on Github)
Grant access to your repository and provide the `webhook` permission
[More info](https://argoproj.github.io/argo-events/eventsources/setup/github/#setup)

Create the `github-access` secret:
```
kubectl create secret generic github-access -n argo --from-literal=token=<your token>
```

Update the file `deployments/github-event-source.yaml`

Change the `owner` with your own Github account name. 
You can change the `repository` if you change the name while forking it. 
`vm-ip` in this case is the IP of the VM where `chain-prod` Kind cluster is installed and will be use by Github to trigger the webhook. It uses the same port as defined in `kind-conf-prod.yaml`

```
...
  github:
    spring-petclinic:
      owner: ""
      repository: "spring-petclinic"
      webhook:
        endpoint: "/github-webhook"
        port: "13000"
        method: "POST"
        url: http://<vm-ip>:33080
```
You can check on Github under `<your_repo> -> Settings -> Webhooks` to see a newly created Webhook with above `url` information. 

```
kubectl apply -n argo -f deployments/github-event-source.yaml
```
Now expose the `source` :

Adapt the file `deployments/argoev-ingress.yaml` if you are using a FQDN to access your cluster. 

The exposition will use the IP adress of the VM and catch the `/github-webhook` path and route it to the `github-event-source`.
```
kubectl apply -n argo -f deployments/argoev-ingress.yaml 
```
# Deploy the sensor
Deploy the `sensor` containing the `workflow`.
```
kubectl apply -n argo -f workflow/myawesomegitopssecuresupplychain.yaml
```

# Trigger the supply chain
Make an edit in the app and see the magic happen :) 

# Next: how we can enforce secure policies in our chain-prod cluster by verifying signatures and the content of all SBOMs.
To come :) 

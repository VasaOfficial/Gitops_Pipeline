# Gitops_Pipeline

## Prerequisites for this project

Sonarqube cloud account
Snyk account
AWS account
Github account
Docker hub account

All of the env variables in the ci/cd configuration file should be added to the github secrets of the repo

## Guide for configuring monitoring and argocd

1. Use this command to access eks cluster

```
aws eks update-kubeconfig --name your-cluster-name --region your-region
```

check the kubectl

```
kubectl get svc
```

Now for helm installation, im using linux for my eks os but if you are using mac or windows LOL, you should go to the aws docs to check how to install helm
Here is the installation for linux:

```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

If you get a message that openssl must first be installed, you can install it with the following command.

```
sudo yum install openssl
```

Check to see if the help has been installed

```
helm version | cut -d + -f 1
```

### Configuring Monitoring and ArgoCD

1. Run following commands:

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

2. Install prometheus

```
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
```

3. Install grafana

```
helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

4. Installing ArgoCD

```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

```
helm install argocd argo/argo-cd --namespace argocd --create-namespace
```

5. Accessing Grafana and Prometheus ArgoCD

Run this to get all services, look for the "EXTERNAL-IP" column, there will be the public ip of the service:

```
kubectl get services
```

For the Grafana add to the url port 3000, for the prometheus 9090 and for argocd 80 or 443

6. Getting the sign in credentials for agrocd, username=admin is the default username

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

7. Getting the url for the Grafana and Prometheus, use EXTERNAL-IP and add port 3000 for grafana, for the prometheus 9090

```
kubectl get svc -n monitoring
```

for getting the grafana password, username is admin:

```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d
```

After login in into grafana add prometheus as data source, and for import these dashboards 6417, 15757, 15760, 15759, 15758, 15761 (these are optional)

8. Argocd configuration: login argocd and add project, add application name, project name is default, sync policy is automatic
   for the source repo add a github url and for the path add kubernetes, select cluster url and for namespace add frontend, do the same for backend

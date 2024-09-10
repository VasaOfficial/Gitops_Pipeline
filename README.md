# Gitops_Pipeline

## CI/CD Pipeline Diagram

![pipeline-min](https://github.com/user-attachments/assets/a3a00b88-c48c-443a-952b-600c75980e5b)

## AWS Architecture Diagram

![Screenshot_7](https://github.com/user-attachments/assets/e8b4fb95-6916-4a90-80ef-861d27b327f9)


## Prerequisites for this project:

Sonarqube cloud account
<br />
Snyk account
<br />
AWS account
<br />
Github account
<br />
Docker hub account

All of the env variables in the ci/cd configuration file should be added to the github secrets of the repo

## Guide for configuring monitoring and argocd

Use this command to access eks cluster

```
aws eks update-kubeconfig --name your-cluster-name --region your-region
```

check the kubectl

```
kubectl get svc
```

Now for helm installation, im using linux for my eks os but if you are using mac or windows LOL, you should go to the aws docs to check how to install helm
<br />
Here is the installation for linux:

```
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
```

If you get a message that openssl must first be installed, you can install it with the following command

```
sudo yum install openssl
```

Check to see if the help has been installed

```
helm version | cut -d + -f 1
```

### Configuring Monitoring and ArgoCD

Run following commands:

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Install prometheus

```
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace
```

Install grafana

```
helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

Installing ArgoCD

```
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

```
helm install argocd argo/argo-cd --namespace argocd --create-namespace
```

Accessing Grafana and Prometheus ArgoCD

Run this to get all services, look for the "EXTERNAL-IP" column, there will be the public ip of the service:

```
kubectl get services
```

For the Grafana add to the url port 3000, for the prometheus 9090 and for argocd 80 or 443

Getting the sign in credentials for agrocd, username=admin is the default username

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Getting the url for the Grafana and Prometheus, use EXTERNAL-IP and add port 3000 for grafana, for the prometheus 9090

```
kubectl get svc -n monitoring
```

for getting the grafana password, username is admin:

```
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 -d
```

After login in into grafana add prometheus as data source, and for import these dashboards 6417, 15757, 15760, 15759, 15758, 15761 (these are optional)

Argocd configuration: login argocd and add project, add application name, project name is default, sync policy is automatic
for the source repo add a github url and for the path add kubernetes, select cluster url and for namespace add frontend, do the same for backend

# Install Kong Istio Gateway in local k3s
We will have to change the helm configuration to have postgres installed and enabled
the Kong admin API, also change the admin type to ClusterIP. Side note is postgres 
we are using is 9.6 version otherwise it will have issue.

    kubectl create namespace kong-istio
    kubectl label namespace kong-istio istio-injection=enabled
    helm repo add kong https://charts.konghq.com && helm repo update
    helm install -n kong-istio kong-istio kong/kong -f values.yaml

## Disable mTLS within the cluster
You will have to disable the PeerAuthentication mTLS within k3s cluster with istio, or 
you will see Kong admin api calling failed.

    kubectl apply -f mtls-disable.yaml

# Install monitoring Prometheus and Kiali
If you already had Prometheus install, no need to install again, having Kiali can
have better visualized way on checking your route and traffic to inner services.

    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/kiali.yaml

    istioctl dashboard kiali

# Install Konga
Konga is an admin tool to help controlling your Kong infrastructure configuration

    kubectl apply -f konga.yaml

Once installed, make sure to register first and login to use.
Need to portforward from konga service with 1337 port http://localhost:1337/register

# Install sample http-echo program to test Kong
Follow within http-echo folder

    kubectl apply -f http-echo/echo-service.yaml

Install used plugins (please replace http_endpoint in http-log.yaml)

    kubectl apply -f http-echo/http-log.yaml
    kubectl apply -f http-echo/rate-limit.yaml

Install Kong ingress route

    kubectl apply -f http-echo/kong-ingress.yaml

## Install Datadog Agent

    helm repo add datadog https://helm.datadoghq.com
    helm repo update

    kubectl create secret generic datadog-secret --from-literal api-key={api-key} --from-literal app-key={app-key}
    helm install datadog-agent datadog/datadog -f values.yaml

## Add annotation to Redis sentinal

    podAnnotations: 
        ad.datadoghq.com/redis.check_names: '["redisdb"]'
        ad.datadoghq.com/redis.init_configs: '[{}]'
        ad.datadoghq.com/redis.instances: |
        [
            {
                "host": "%%host%%",
                "port":"6379",
                "password":""
            }
        ]

    helm upgrade bitnami/redis -f values.yaml
   

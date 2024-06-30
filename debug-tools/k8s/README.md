# K8s debugging tools and tips
## cURL
Install a pod that able to run with cURL command

    kubectl exec -it curlpod -- curl -v {host}

## API request through Istio exceeds 4mb will truncated
By default envoy max request payload is 4096 bytes, we need to extend it.

    ---            
    apiVersion: networking.istio.io/v1alpha3
    kind: EnvoyFilter
    metadata:
      name: limit-request-size
      namespace: istio-system
    spec:
      workloadSelector:
        labels:
          istio: ingressgateway
      configPatches:
      - applyTo: HTTP_FILTER
        match:
          context: GATEWAY
          listener:
            filterChain:
              filter:
                name: envoy.filters.network.http_connection_manager
        patch:
          operation: INSERT_BEFORE
          value:
            name: envoy.filters.http.buffer
            typed_config:
              '@type': type.googleapis.com/envoy.extensions.filters.http.buffer.v3.Buffer
              max_request_bytes: 10485760

## Quick redis check

    kubectl run redis-client --rm -it --image=redis -- bash
    redis-cli -u redis://{service-name}.{namespace}.svc.cluster.local:6379

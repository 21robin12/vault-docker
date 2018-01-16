# Running Vault in Kubernetes

https://www.vaultproject.io/

## Quickstart - running Vault with storage in Google Cloud

### 1. Build Docker image and push to repository

 - `docker build -t docker.io/<ACCOUNT>/vault-gcloud .`
 - `docker push docker.io/<ACCOUNT>/vault-gcloud`

### 2. Configure Google Cloud

 - Create a service account (IAM & admin -> Service accounts) and download a key file as JSON
 - Create a bucket in Google Cloud (under Storage -> Browser)
 - Click the bucket, click ..., Edit Bucket Permissions and add the new service account as a Storage Object Admin 

### 3. Setup Vault configuration files

 - Save the service account JSON key file as `gcloud-sa-key.json`
 - Update the following config with any required parameters and save as `config.json`

TODO: look at authentication. Use tokens? https://www.vaultproject.io/docs/auth/token.html

```
{
    "listener": [{
		"tcp": {
			"address": "127.0.0.1:8200",
            "tls_disable": 1
		}
	}],
    "storage": {
        "gcs": {
            "bucket": "<GOOGLE_CLOUD_BUCKET_ID>",
            "credentials_file": "/install/secrets-volume/gcloud-sa-key.json"
        }
    } 
}
```

### 4. Push files to Kubernetes as secrets

```
kubectl create secret generic vault-config-secret
    --from-file=config.json=config.json 
    --from-file=gcloud-sa-key.json=gcloud-sa-key.json
```

### 5. Launch Vault and expose with a service in Kubernetes

Make sure to substitute `docker.io/<ACCOUNT>/vault-gcloud` with image built in step 1

```
apiVersion: v1
kind: Service
metadata:
  name: vault-service
spec:
  ports:
  - port: 8200
    targetPort: 8200
  type: ClusterIP
  selector:
    app: vault
---
apiVersion: v1
kind: Pod
metadata:
  name: vault-pod
  labels:
    app: vault
spec:
  volumes:
  - name: secrets-volume
    secret:
      secretName: vault-config-secret
  containers:
  - name: vault-container
    image: docker.io/<ACCOUNT>/vault-gcloud
    ports: 
     - containerPort: 8200
    volumeMounts:
    - name: secrets-volume
      readOnly: true
      mountPath: "/install/secrets-volume"
```
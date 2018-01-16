# Vault in Docker

## Quickstart - running Vault with storage in Google Cloud

### 1. Configure Google Cloud

 - Create a service account (IAM & admin -> Service accounts) and download a key file as JSON
 - Create a bucket in Google Cloud (under Storage -> Browser)
 - Click the bucket, click ..., Edit Bucket Permissions and add the new service account as a Storage Object Admin 

### 2. Setup Vault configuration files

 - Paste the service account JSON key file into `gcloud-service-account-key.json`
 - Update the following config with any required parameters and paste into `config.json`
 - **Do not commit these changes to source control**

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
            "credentials_file": "/install/gcloud-service-account-key.json"
        }
    } 
}
```

### 3. Build and run

 - `docker build -t vault-gcloud .`
 - `docker run vault-gcloud`
[1mdiff --git a/deployments/argowf-values.yaml b/deployments/argowf-values.yaml[m
[1mindex 9e96968..9427203 100644[m
[1m--- a/deployments/argowf-values.yaml[m
[1m+++ b/deployments/argowf-values.yaml[m
[36m@@ -765,102 +765,46 @@[m [mextraObjects: [][m
 useStaticCredentials: true[m
 artifactRepository:[m
   # -- Archive the main container logs as an artifact[m
[31m-  archiveLogs: false[m
[32m+[m[32m  archiveLogs: true[m
   # -- Store artifact in a S3-compliant object store[m
   # @default -- See [values.yaml][m
[31m-  s3: {}[m
[31m-    # # Note the `key` attribute is not the actual secret, it's the PATH to[m
[31m-    # # the contents in the associated secret, as defined by the `name` attribute.[m
[31m-    # accessKeySecret:[m
[31m-    #   name: "{{ .Release.Name }}-minio"[m
[31m-    #   key: accesskey[m
[31m-    # secretKeySecret:[m
[31m-    #   name: "{{ .Release.Name }}-minio"[m
[31m-    #   key: secretkey[m
[31m-    # # insecure will disable TLS. Primarily used for minio installs not configured with TLS[m
[31m-    # insecure: false[m
[31m-    # caSecret:[m
[31m-    #   name: ca-root[m
[31m-    #   key: cert.pem[m
[31m-    # bucket:[m
[31m-    # endpoint:[m
[31m-    # region:[m
[31m-    # roleARN:[m
[31m-    # useSDKCreds: true[m
[31m-    # encryptionOptions:[m
[31m-    #   enableEncryption: true[m
[31m-  # -- Store artifact in a GCS object store[m
[31m-  # @default -- `{}` (See [values.yaml])[m
[31m-  gcs: {}[m
[31m-    # bucket: <project>-argo[m
[31m-    # keyFormat: "{{ \"{{workflow.namespace}}/{{workflow.name}}/{{pod.name}}\" }}"[m
[31m-    # # serviceAccountKeySecret is a secret selector.[m
[31m-    # # It references the k8s secret named 'my-gcs-credentials'.[m
[31m-    # # This secret is expected to have have the key 'serviceAccountKey',[m
[31m-    # # containing the base64 encoded credentials[m
[31m-    # # to the bucket.[m
[31m-    # #[m
[31m-    # # If it's running on GKE and Workload Identity is used,[m
[31m-    # # serviceAccountKeySecret is not needed.[m
[31m-    # serviceAccountKeySecret:[m
[31m-    #   name: my-gcs-credentials[m
[31m-    #   key: serviceAccountKey[m
[31m-  # -- Store artifact in Azure Blob Storage[m
[31m-  # @default -- `{}` (See [values.yaml])[m
[31m-  azure: {}[m
[31m-    # endpoint: https://mystorageaccountname.blob.core.windows.net[m
[31m-    # container: my-container-name[m
[31m-    # blobNameFormat: path/in/container[m
[31m-    # # accountKeySecret is a secret selector.[m
[31m-    # # It references the k8s secret named 'my-azure-storage-credentials'.[m
[31m-    # # This secret is expected to have have the key 'account-access-key',[m
[31m-    # # containing the base64 encoded credentials to the storage account.[m
[31m-    # # If a managed identity has been assigned to the machines running the[m
[31m-    # # workflow (e.g., https://docs.microsoft.com/en-us/azure/aks/use-managed-identity)[m
[31m-    # # then accountKeySecret is not needed, and useSDKCreds should be[m
[31m-    # # set to true instead:[m
[31m-    # useSDKCreds: true[m
[31m-    # accountKeySecret:[m
[31m-    #   name: my-azure-storage-credentials[m
[31m-    #   key: account-access-key[m
[31m-[m
[31m-# -- The section of custom artifact repository.[m
[31m-# Utilize a custom artifact repository that is not one of the current base ones (s3, gcs, azure)[m
[31m-customArtifactRepository: {}[m
[31m-# artifactory:[m
[31m-#   repoUrl: https://artifactory.example.com/raw[m
[31m-#   usernameSecret:[m
[31m-#     name: artifactory-creds[m
[31m-#     key: username[m
[31m-#   passwordSecret:[m
[31m-#     name: artifactory-creds[m
[31m-#     key: password[m
[32m+[m[32m  s3:[m[41m [m
[32m+[m[32m    accessKeySecret:[m
[32m+[m[32m      name: "minio-api-key"[m
[32m+[m[32m      key: accesskey[m
[32m+[m[32m    secretKeySecret:[m
[32m+[m[32m      name: "minio-api-key"[m
[32m+[m[32m      key: secretkey[m
[32m+[m[32m    # insecure will disable TLS. Primarily used for minio installs not configured with TLS[m
[32m+[m[32m    insecure: true[m
[32m+[m[32m    bucket: argo[m
[32m+[m[32m    endpoint: minio:9000[m
 [m
 # -- The section of [artifact repository ref](https://argo-workflows.readthedocs.io/en/stable/artifact-repository-ref/).[m
 # Each map key is the name of configmap[m
 # @default -- `{}` (See [values.yaml])[m
[31m-artifactRepositoryRef: {}[m
[32m+[m[32martifactRepositoryRef:[m[41m [m
   # # -- 1st ConfigMap[m
   # # If you want to use this config map by default, name it "artifact-repositories".[m
   # # Otherwise, you can provide a reference to a[m
   # # different config map in `artifactRepositoryRef.configMap`.[m
[31m-  # artifact-repositories:[m
[31m-  #   # -- v3.0 and after - if you want to use a specific key, put that key into this annotation.[m
[31m-  #   annotations:[m
[31m-  #     workflows.argoproj.io/default-artifact-repository: default-v1-s3-artifact-repository[m
[31m-  #   # 1st data of configmap. See above artifactRepository or customArtifactRepository.[m
[31m-  #   default-v1-s3-artifact-repository:[m
[31m-  #     archiveLogs: false[m
[31m-  #     s3:[m
[31m-  #       bucket: my-bucket[m
[31m-  #       endpoint: minio:9000[m
[31m-  #       insecure: true[m
[31m-  #       accessKeySecret:[m
[31m-  #         name: my-minio-cred[m
[31m-  #         key: accesskey[m
[31m-  #       secretKeySecret:[m
[31m-  #         name: my-minio-cred[m
[31m-  #         key: secretkey[m
[32m+[m[32m  artifact-repositories:[m
[32m+[m[32m    # -- v3.0 and after - if you want to use a specific key, put that key into this annotation.[m
[32m+[m[32m    annotations:[m
[32m+[m[32m      workflows.argoproj.io/default-artifact-repository: default-v1-s3-artifact-repository[m
[32m+[m[32m    # 1st data of configmap. See above artifactRepository or customArtifactRepository.[m
[32m+[m[32m    default-v1-s3-artifact-repository:[m
[32m+[m[32m      archiveLogs: false[m
[32m+[m[32m      s3:[m
[32m+[m[32m        bucket: argo[m
[32m+[m[32m        endpoint: minio:9000[m
[32m+[m[32m        insecure: true[m
[32m+[m[32m        accessKeySecret:[m
[32m+[m[32m          name: "minio-api-key"[m
[32m+[m[32m          key: accesskey[m
[32m+[m[32m        secretKeySecret:[m
[32m+[m[32m          name: "minio-api-key"[m
[32m+[m[32m          key: secretkey[m
   #    # 2nd data[m
   #    oss-artifact-repository:[m
   #      archiveLogs: false[m
[1mdiff --git a/next/ratify-values.yaml b/next/ratify-values.yaml[m
[1mindex 539416e..3e9671c 100644[m
[1m--- a/next/ratify-values.yaml[m
[1m+++ b/next/ratify-values.yaml[m
[36m@@ -4,13 +4,18 @@[m [mcosign:[m
     MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEOYMk7g3WDKOOWsjyglpWGlb9qjGk[m
     jGoRWx4efs3P0d0qk4uyDHybCXhqEIifiRFuZXCHSzdUi5egWF9PKfZbvQ==[m
     -----END PUBLIC KEY-----[m
[32m+[m[32mfeatureFlags:[m
[32m+[m[32m  RATIFY_CERT_ROTATION: true[m
[32m+[m[32moras:[m
[32m+[m[32m  authProviders:[m
[32m+[m[32m    k8secretsEnabled: true[m
 sbom:[m
   enabled: true[m
   disallowedLicenses:[m
   - "MPL"[m
[31m-  #- "GPL-2.0-only"[m
[32m+[m[32m  - "GPL-2.0-only"[m
   disallowedPackages: [m
   - name: "busybox"[m
     version: "1.36.1-r0"[m
[31m-  #- name: "caffeine"[m
[31m-  #  version: "3.1.6"[m
\ No newline at end of file[m
[32m+[m[32m  - name: "caffeine"[m
[32m+[m[32m    version: "3.1.6"[m
\ No newline at end of file[m
[1mdiff --git a/workflow/myawesomegitopssecuresupplychain.yaml b/workflow/myawesomegitopssecuresupplychain.yaml[m
[1mindex e993c5f..7d24b1d 100644[m
[1m--- a/workflow/myawesomegitopssecuresupplychain.yaml[m
[1m+++ b/workflow/myawesomegitopssecuresupplychain.yaml[m
[36m@@ -30,6 +30,8 @@[m [mspec:[m
                 generateName: secure-supp-chain-[m
               spec:[m
                 entrypoint: my-awesome-supply-chain[m
[32m+[m[32m                imagePullSecrets:[m
[32m+[m[32m                - name: tutorial-registry-credentials[m
                 onExit: exit-handler     [m
                 serviceAccountName: argo-workflow-sa # Set ServiceAccount[m
                 arguments:[m
[36m@@ -49,6 +51,9 @@[m [mspec:[m
                 - name: my-registry-secret[m
                   secret:[m
                     secretName: tutorial-registry-credentials[m
[32m+[m[32m                - name: dependency-track-key[m
[32m+[m[32m                  secret:[m
[32m+[m[32m                    secretName: dependency-track-key[m
                 # This spec contains two templates: hello-hello-hello and whalesay[m
                 templates:[m
                 - name: my-awesome-supply-chain[m
[36m@@ -68,6 +73,12 @@[m [mspec:[m
                         # Pass the hello-param output from the generate-parameter step as the message input to print-message[m
                         - name: build-sha[m
                           value:  "{{steps.build-code.outputs.parameters.build-sha}}"[m
[32m+[m[32m                  - - name: dependency-track           # double dash => run after previous step[m
[32m+[m[32m                      template: dependency-track[m
[32m+[m[32m                      arguments:[m
[32m+[m[32m                        parameters:[m
[32m+[m[32m                        - name: depencendy-track-url[m
[32m+[m[32m                          value: "http://188.165.247.177:8086"[m
                   - - name: create-deployment           # double dash => run after previous step[m
                       template: create-deployment[m
                       arguments:[m
[36m@@ -221,6 +232,7 @@[m [mspec:[m
                     source: |[m
                       cosign sign --key k8s://argo/cosign {{workflow.parameters.container-repo}}/{{workflow.parameters.app-name}}@{{inputs.parameters.build-sha}} -y[m
                       syft scan {{workflow.parameters.container-repo}}/{{workflow.parameters.app-name}} -o spdx-json=spring-project-spdx-json.json[m
[32m+[m[32m                      syft scan {{workflow.parameters.container-repo}}/{{workflow.parameters.app-name}} -o cyclonedx-json=/tmp/spring-project-cycdx-json.json[m
                       cosign attest --predicate spring-project-spdx-json.json --type spdxjson --key k8s://argo/cosign  {{workflow.parameters.container-repo}}/{{workflow.parameters.app-name}}@{{inputs.parameters.build-sha}} -y[m
                       [m
                       # Ratify do not support yet sbom-attestation https://github.com/deislabs/ratify/issues/777[m
[36m@@ -234,6 +246,42 @@[m [mspec:[m
                     volumeMounts:[m
                     - name: my-registry-secret     # mount file containing secret at /secret/mountpath[m
                       mountPath: "/config"[m
[32m+[m[32m                  outputs:[m
[32m+[m[32m                    artifacts:[m
[32m+[m[32m                    - name: spring-project-cycdx-json[m
[32m+[m[32m                      path: /tmp/spring-project-cycdx-json.json[m
[32m+[m[32m                      s3:[m
[32m+[m[32m                        key: spring-project-cycdx-json.json[m
[32m+[m[32m                - name: dependency-track[m
[32m+[m[32m                  inputs:[m
[32m+[m[32m                    artifacts:[m
[32m+[m[32m                    - name: spring-project-cycdx-json[m
[32m+[m[32m                      path: /tmp/spring-project-cycdx-json.json[m
[32m+[m[32m                      s3:[m
[32m+[m[32m                        key: spring-project-cycdx-json.json[m
[32m+[m[32m                    parameters:[m
[32m+[m[32m                    - name: depencendy-track-url[m
[32m+[m[32m                  script:[m
[32m+[m[32m                    image: curlimages/curl[m
[32m+[m[32m                    command: [curl][m
[32m+[m[32m                    args:[m[41m [m
[32m+[m[32m                    - -X[m
[32m+[m[32m                    - "POST"[m
[32m+[m[32m                    - "{{inputs.parameters.depencendy-track-url}}/api/v1/bom"[m
[32m+[m[32m                    - -H[m[41m [m
[32m+[m[32m                    - 'Content-Type: multipart/form-data'[m
[32m+[m[32m                    - -H[m[41m [m
[32m+[m[32m                    - 'X-API-Key: $APIKEY'[m
[32m+[m[32m                    - -F[m
[32m+[m[32m                    - "project=2725b447-95a9-402f-8a4e-9908a2fe56e6"[m
[32m+[m[32m                    - -F[m[41m [m
[32m+[m[32m                    - 'bom=@/tmp/spring-project-cycdx-json.json'[m
[32m+[m[32m                    env:[m
[32m+[m[32m                    - name: APIKEY  # name of env var[m
[32m+[m[32m                      valueFrom:[m
[32m+[m[32m                        secretKeyRef:[m
[32m+[m[32m                          name: dependency-track-key     # name of an existing k8s secret[m
[32m+[m[32m                          key: api-key     # 'key' subcomponent of the secret[m
                 - name: create-deployment[m
                   inputs:[m
                     parameters:[m

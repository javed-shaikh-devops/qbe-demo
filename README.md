## QBE Demo

![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/arch.png)

## Problem Statement 

Provision a web server in any cloud provider. You may use any tools of your choosing, but ensure it has the following properties:

The machine may be a VM or a container
A firewall should be configured
Some demonstrated security hardening has been performed on the base image (don't go overboard, one or two things are fine)
The machine should be accessible over SSH
The machine should listen on 443:
The following HTTPS request: GET /hello/ HTTP/1.1
Should generate the following plain text response: world

## About 

The documentation helps understand the creation of resources on GCP with gcloud util and terraform, creating and deploying image onto the compute instance.

## Folder Structure:

 -main.tf
 -terraform.tfvars
 -variables.tf
 -Dockerfile
 -default.conf
 -index.html
 -imgs/

## Gcloud util - Creating Project and Service account 

1. Download Gcloud for Linux 
  https://cloud.google.com/sdk/docs/install-sdk#linux
2. Unzip to local 
   gunzip google-cloud-cli-432.0.0-linux-x86_64.tar.gz
   tar -xvf google-cloud-cli-432.0.0-linux-x86_64.tar
3. Add the gcloud bin folder to $PATH variable to discover gcloud anywhere on the machine
4. Activate the gcloud 
    
 ![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/create_project.png)
 ![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/create_project_1.png)
 ![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/create_project_2.png)
 
5. List accounts
   To list the accounts whose credentials are stored on the local system, 
   run gcloud auth list:
 
![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/auth_list.png)

6. Set to the newly created Project 
![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/set_project.png)

7. Create a new Service account for terraform to connect and create new resources 
![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/create_service_account.png)

8. Create google key JSON file for this service account and this would help in connecting the terraform with Google Cloud
   Save the key to credentials.json

## Terraform - Creating resources Firewall, Compute Instance

    
 1. Compute instance 
	- Image : debian-cloud/debian-10
	- machine_type : f1-micro
	- network : default 
	- tags : externalssh, webserver
	- provisioner : remote-exec
2. Firewall
	- protocal : tcp
	- ports : 22, 443
3. Static Address
    - Dependency - Firewall 
	
## Dockerfile

	- ALPINE_VERSION=3.17.3
	- NGINX_VERSION=1.23.4
	- OPENSSL - create and inject self signed certificate
	- COPY self-signed.key and self-signed.crt from alpine to nginx
    - Setting the default config for listen port 443

## Provisioner "remote-exec"	
	- Connect to the Compute instance over ssh (port 22) using static IP address
	- user to connect defined in vailables.tf as javedshaikh_gmail_com
 	- Service account to connect defined in vailables.tf as tf-gcp-sa@qbe-24052023-demo.iam.gserviceaccount.com
	- Local host user public and private key defined under privatekeypath and publickeypath vailables
	- Install Dependencies
	- Install Docker on newly procured compute engine VM
	- Git clone repo https://github.com/javed-shaikh-devops/qbe-demo.git
	- Build the docker image 
	- Run the Docker container in detach mode

## Output 
curl https://<IP>:<PORT> --insecure

![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/imgs/output.png)
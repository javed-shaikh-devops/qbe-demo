## QBE Demo

![image](https://github.com/javed-shaikh-devops/qbe-demo/blob/main/arch.png)

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

1. Compute instance 
	- Image : debian-cloud/debian-10
	- machine_type : f1-micro
	- network : default 
	- tags : externalssh, webserver
	- provisioner : remote-exec
2. Firewall
	- protocal : tcp
	- ports : 22, 443, 80

## Folder Structure:

- main.tf
- terraform.tfvars
- variables.tf
- Dockerfile
- default.conf
- index.html



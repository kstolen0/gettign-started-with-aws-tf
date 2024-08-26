#!/bin/bash

aws --profile kristian ecr get-login-password --region ap-southeast-2 | sudo docker login --username AWS --password-stdin 381492126744.dkr.ecr.ap-southeast-2.amazonaws.com/unicorn-api
sudo docker build -t unicorn-api .
sudo docker tag unicorn-api:latest 381492126744.dkr.ecr.ap-southeast-2.amazonaws.com/unicorn-api 
sudo docker push 381492126744.dkr.ecr.ap-southeast-2.amazonaws.com/unicorn-api:latest
aws --profile kristian ecr list-images --repository-name unicorn-api

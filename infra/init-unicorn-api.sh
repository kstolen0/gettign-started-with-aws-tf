#!/bin/bash

aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin 381492126744.dkr.ecr.ap-southeast-2.amazonaws.com/unicorn-api
docker run -p 80:8080 381492126744.dkr.ecr.ap-southeast-2.amazonaws.com/unicorn-api:latest

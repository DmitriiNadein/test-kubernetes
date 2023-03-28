#!/bin/bash
## Test your deployment
kubectl get pods -n myns

curl http://localhost:3000/hello

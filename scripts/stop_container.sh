#!/bin/bash

docker stop flask-app || true
docker rm flask-app || true

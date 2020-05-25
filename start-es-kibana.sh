#!/bin/bash

docker rm -f es01 kib01
VERSION=7.7.0 docker-compose up


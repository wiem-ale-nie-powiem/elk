#!/bin/bash

. env.sh

# Co robią poniższe polecenia? Patrz https://www.elastic.co/guide/en/beats/metricbeat/current/running-on-docker.html

# Create the index pattern and load visualizations and machine learning jobs
docker run \
  docker.elastic.co/beats/metricbeat:${VERSION} \
  setup -E setup.kibana.host=${KIBANA_HOST}:5601 \
  -E setup.ilm.overwrite=true \
  -E output.elasticsearch.hosts=["${ES_HOST}:9200"]

# Run beat
sudo docker run -d \
  --restart=unless-stopped \
  --name=metricbeat \
  --user=root \
  --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  docker.elastic.co/beats/metricbeat:${VERSION} metricbeat -e \
  -E output.elasticsearch.hosts=["${ES_HOST}:9200"]


#!/bin/bash

. env.sh

# Co robią poniższe polecenia? Patrz https://www.elastic.co/guide/en/beats/journalbeat/current/running-on-docker.html

# Create the index pattern and load visualizations and machine learning jobs
docker run --net=host docker.elastic.co/beats/journalbeat:${VERSION} setup -E setup.ilm.overwrite=true -E setup.kibana.host=${KIBANA_HOST}:5601 -E output.elasticsearch.hosts=["${ES_HOST}:9200"]

# Run beat
# Make sure you include the path to the host’s journal. The path might be /var/log/journal or /run/log/journal
sudo docker run -d \
  --net=host \
  --name=journalbeat \
  --restart=unless-stopped \
  --user=root \
  --volume="$(pwd)/journalbeat.docker.yml:/usr/share/journalbeat/journalbeat.yml:ro" \
  --volume="/var/log/journal:/var/log/journal" \
  --volume="/etc/machine-id:/etc/machine-id" \
  --volume="/run/systemd:/run/systemd" \
  --volume="/etc/hostname:/etc/hostname:ro" \
  docker.elastic.co/beats/journalbeat:${VERSION} journalbeat -e -strict.perms=false \
  -E output.elasticsearch.hosts=["${ES_HOST}:9200"]

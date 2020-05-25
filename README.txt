Wymagania wstępne
-----------------
  - Docker
  - Docker compose (instalacja opisana w https://docs.docker.com/compose/install/)

Uruchamianie
------------

# Konieczne żeby uruchomić ElasticStack
sudo sysctl -w vm.max_map_count=262144

# Stawia ElasticSearch i Kibanę na lokalnym hoście
./start-es-kibana.sh

# UWAGA: Przeedytuj zmienne definiowane w tym skrypcie!!!
cp env.sh.sample env.sh

# Na hoście, którego dzienniki systemowe chcemy logować do ElasticSearcha
# UWAGA: W katalogu bieżącym musi być plik journalbeat.docker.yml
./start-journalbeat.sh

# Na hoście, którego metryki systemowe chcemy logować do ElasticSearcha
# UWAGA: W katalogu bieżącym musi być plik metricbeat.docker.yml, którego właścicielem musi być ROOT
sudo chown root.root metricbeat.docker.yml
sudo chmod go-w metricbeat.docker.yml
./start-metricbeat.sh

Sprawdzenie danych w ElasticSearch
----------------------------------
Lista indeksów serwera Elasticsearch:
  curl 'localhost:9200/_cat/indices?v'
Zawartość indeksu (nazwa indeksu będzie pewnie u Ciebie inna):
  curl -XGET "localhost:9200/journalbeat-7.7.0-2020.05.19-000001/_search?pretty&q=response=200"

Sprzątanie po sobie
-------------------
Aby posprzątać po zabawie, oprócz samych kontenerów i ich obrazów trzeba jeszcze usunąć wolumeny:

$ docker volume ls
DRIVER              VOLUME NAME
local               elk_data01
local               elk_data02
local               elk_data03

$ docker volume rm elk_data01 elk_data02 elk_data03


#!/bin/bash
USERNAME=admin
PASSWORD=admin123
REPOS=($(ls | grep json | sed -e 's/\..*$//'))

until $(curl --output /dev/null --silent --head --fail http://localhost:8081/); do
  printf '.'
  sleep 5
done


for i in "${REPOS[@]}"
do
	echo "creating $i repository"
  curl -v -u $USERNAME:$PASSWORD --header "Content-Type: application/json" 'http://localhost:8081/service/siesta/rest/v1/script/' -d @$i.json
  curl -v -X POST -u $USERNAME:$PASSWORD --header "Content-Type: text/plain" "http://localhost:8081/service/siesta/rest/v1/script/$i/run"
done

#!/bin/sh

# disconnect
curl -X PUT \
  http://$1:10000/disconnect \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain'

# upload application description
curl -X POST \
  "http://$1:10000/upload?path=applications/$2/src/application.xml&temporary=false" \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain' \
  -d @src/application.xml
  
# upload application file
curl -X POST \
  "http://$1:10000/upload?path=applications/$2/src/main.js&temporary=false" \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain' \
  -d @src/main.js
  
# start the app
curl -X PUT \
  "http://$1:10000/launch?id=$2&file=main.js" \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: text/plain'

gedit /etc/hosts
127.0.0.1 api.dev.local

curl -H 'Accept: application/vnd.marketplace.v1' http://api.dev.local:3000/users/1.json


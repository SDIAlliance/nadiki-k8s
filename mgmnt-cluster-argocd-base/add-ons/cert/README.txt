

openssl genrsa -out server.key 2048
openssl req -new -out server.csr -key server.key -config cert.cnf
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt -extensions v3_req -extfile cert.cnf
kubectl create secret tls tantlinger-wildcard-cert --key server.key --cert server.crt
echo "host = \"$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}' --context=kind-kind --flatten)\""
echo "client_certificate = \"$(kubectl config view -o jsonpath='{.users[0].user.client-certificate-data}' --context=kind-kind --flatten)\""
echo "client_key = \"$(kubectl config view -o jsonpath='{.users[0].user.client-key-data}' --context=kind-kind --flatten)\""
echo "cluster_ca_certificate = \"$(kubectl config view -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' --context=kind-kind --flatten)\""

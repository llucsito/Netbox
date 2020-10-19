read -p "Introduce la red a Escanear (tipo 192.168.1.0/24): " NET
nmap -sP $NET | awk '/is up/ {print up}; {gsub (/\(|\)/,""); up = $NF}' > IP_AVAILABE.txt

new_net=${NET: -2}

while IFS= read -r line
do
  curl -k -X POST "http://"https://URL_YOUR_NETBOX/api/ipam/ip-addresses/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"address\": \"$line/$new_net\",  \"tenant\": 1,  \"status\": \"active\",  \"assigned_object_id\": 0,  \"nat_outside\": 0,  \"custom_fields\": {}}"
done < IP_AVAILABE.txt


rm -rf IP_AVAILABE.txt

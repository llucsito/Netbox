curl -k -X GET "https:/URLYOURNETBOX/api/tenancy/tenants/?name=$1" -H  "accept: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXX" > get_id.txt

GETID=`cut -d\: -f6 get_id.txt | sed 's/,"url"//'`

echo $GETID
rm -rf get_id.txt

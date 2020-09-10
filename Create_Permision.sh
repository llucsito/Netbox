####################################
########### GET ID GROUP ###########
####################################

curl -k -X GET "https://URLYOURNETBOX/api/users/groups/?name=$1" -H  "accept: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" > get_id.txt

GETID=`cut -d\: -f6 get_id.txt | sed 's/,"url"//'`

rm -rf get_id.txt

#######################################
########### CREAR VIEW SITE ###########
#######################################

curl -k -X POST "https://URLYOURNETBOX/api/users/permissions/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"name\": \"SITE-VIEW-$1\",  \"enabled\": true,  \"object_types\": [    \"dcim.site\"  ],  \"groups\": [    $GETID  ],  \"actions\": [    \"view\"  ],  \"constraints\": {\"tenant__group__name\": \"$1\"}}"


#########################################
########### CREAR VIEW PREFIX ###########
#########################################

curl -k -X POST "https://URLYOURNETBOX/api/users/permissions/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"name\": \"PREFIX-VIEW-$1\",  \"enabled\": true,  \"object_types\": [    \"ipam.ipaddress\",    \"ipam.prefix\",    \"ipam.vrf\"  ],  \"groups\": [    $GETID  ],  \"actions\": [    \"view\"  ],  \"constraints\": {\"tenant__group__name\": \"$1\"}}"

#########################################
########### CREAR VIEW TENANT ###########
#########################################

curl -k -X POST "https://URLYOURNETBOX/api/users/permissions/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"name\": \"TENANT-VIEW-$1\",  \"enabled\": true,  \"object_types\": [    \"tenancy.tenant\"  ],  \"groups\": [    $GETID  ],  \"actions\": [    \"view\"  ],  \"constraints\": {\"name\": \"$1\"}}"

##########################################
########### CREAR VIEW DEVICES ###########
##########################################

curl -k -X POST "https://URLYOURNETBOX/api/users/permissions/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"name\": \"DEVICES-VIEW-$1\",  \"enabled\": true,  \"object_types\": [    \"dcim.device\"  ],  \"groups\": [    $GETID  ],  \"actions\": [    \"view\"  ],  \"constraints\": {\"tenant__group__name\": \"$1\"}}"

#######################################
########### CREAR VIEW VLAN ###########
#######################################

curl -k -X POST "https://URLYOURNETBOX/api/users/permissions/" -H  "accept: application/json" -H  "Content-Type: application/json" -H  "Authorization: Token XXXXXXXXXXXXXXXXXXXXXXXXXXX" -d "{  \"name\": \"VLAN-VIEW-$1\",  \"enabled\": true,  \"object_types\": [    \"ipam.vlan\"  ],  \"groups\": [    $GETID  ],  \"actions\": [    \"view\"  ],  \"constraints\": {\"tenant__group__name\": \"$1\"}}"

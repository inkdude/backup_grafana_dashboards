#!/bin/bash -x

KEY="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
URL="https://grafana.contoso.com"
DASH_DIR="/root/dashboards"

FOLDERS=$(curl -sS -k -H "Authorization: Bearer $KEY" $URL/api/search\?query\=\& | jq '.[] | select( .type == "dash-folder") | .title' | tr -d \")

if [ ! -d "$DASH_DIR" ]; then
	 mkdir /root/dashboards
else
	 echo "| A $DASH_DIR directory is already exist! |";
fi

for f in $FOLDERS
do
    mkdir -p $DASH_DIR/$f
    for d in $(curl -sS -k -H "Authorization: Bearer $KEY" $URL/api/search\?query\=\& | jq --arg f "$f" '.[] | select(( .type == "dash-db")and .folderTitle == $f) | .uri ' | tr -d \")
    do
	normal_name=$(echo $d | sed 's/^...//')
        curl -sS -k -H "Authorization: Bearer $KEY" $URL/api/dashboards/$d | jq '.dashboard' > $DASH_DIR$f/$normal_name.json
    done
done

for wf in $(curl -sS -k -H "Authorization: Bearer $KEY" $URL/api/search\?query\=\& | jq --arg f "$f" '.[] | select(( .type == "dash-db")and .folderTitle == null) | .uri ' | tr -d \")
do
	normal_name=$(echo $wf | sed 's/^...//')
	curl -sS -k -H "Authorization: Bearer $KEY" $URL/api/dashboards/$wf | jq '.dashboard' > $DASH_DIR$normal_name.json
done

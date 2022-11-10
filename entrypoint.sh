#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

uuid1=ad806487-2d26-4636-98b6-ab85cc8521f7
uuid2=c5becbf7-b05d-476d-9e4c-de3206a221a9
uuid3=9c51d58a-3133-42e1-a2b1-13e6e6a72f5a
uuid4=320e5dff-dcc9-477c-b278-42edc1d80f06
uuid5=bf6800ed-59a6-4b1c-84b1-df5051a7860c
mypath=/mylove-fsd79sa
myport=8080


# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/myconfig.pb
{
	"inbounds": [
		{
			"listen": "0.0.0.0",
			"port": $myport,
			"protocol": "vless",
			"settings": {
				"clients": [
					{
						"id": "$uuid1"
					},{
						"id": "$uuid2"
					},{
						"id": "$uuid3"
					},{
						"id": "$uuid4"
					},{
						"id": "$uuid5"
					}
				],
			"decryption": "none"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
					"path": "$mypath"
				}
			}
		}
	],
	"outbounds": [
		{
			"protocol": "freedom"
		}
	]
}
EOF

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o ${DIR_TMP}/v2ray_dist.zip
unzip ${DIR_TMP}/v2ray_dist.zip -d ${DIR_TMP}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
mv -f ${DIR_TMP}/myconfig.pb ${DIR_CONFIG}/myconfig.json

# Install V2Ray
install -m 755 ${DIR_TMP}/v2ray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/v2ray run -config=${DIR_CONFIG}/myconfig.json

#!/bin/bash
set -euo pipefail
    
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: this script must be run as root (sudo)." >&2
    exit 1
fi

LOG="/var/log/provision_user.log"
exec >> "$LOG" 2>&1

echo "Creating folders..."

sudo mkdir -p /public
sudo mkdir -p /adm
sudo mkdir -p /sales
sudo mkdir -p /sec

echo "Creating user groups..."

groupadd GRP_ADM
groupadd GRP_SALES
groupadd GRP_SEC

echo "Creating users..."

read -r -s -p "Set the default password to all users: " PASSWORD
echo
HASHED_PASSWORD=$(openssl passwd -6 "$PASSWORD")
unset PASSWORD

useradd carl -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
useradd mary -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
useradd john -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM

useradd diana -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES
useradd sebastian -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES
useradd robert -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES

useradd joe -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
useradd amanda -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
useradd roger -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC

echo "Setting permissions..."

chmod 777 /public
chmod 770 /adm
chmod 770 /sales
chmod 770 /sec

chown root:GRP_ADM /adm
chown root:GRP_SALES /sales
chown root:GRP_SEC /sec

echo "Done."


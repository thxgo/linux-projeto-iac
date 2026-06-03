#!/bin/bash
set -euo pipefail
    
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: this script must be run as root (sudo)." >&2
    exit 1
fi

LOG="/var/log/provision_user.log"
exec >> "$LOG" 2>&1

echo "Creating folders..."

mkdir -p /public
mkdir -p /adm
mkdir -p /sales
mkdir -p /sec

echo "Creating user groups..."

groupadd GRP_ADM
groupadd GRP_SALES
groupadd GRP_SEC

echo "Creating users..."

read -r -s -p "Set the default password to all users: " PASSWORD
echo
HASHED_PASSWORD=$(openssl passwd -6 "$PASSWORD")
unset PASSWORD

# TODO: refactor useradd + chage into a function to reduce repetition

useradd carl -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
chage -d 0 carl
useradd mary -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
chage -d 0 mary
useradd john -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
chage -d 0 john

useradd diana -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES
chage -d 0 diana
useradd sebastian -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES
chage -d 0 sebastian
useradd robert -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SALES
chage -d 0 robert

useradd joe -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
chage -d 0 joe
useradd amanda -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
chage -d 0 amanda
useradd roger -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
chage -d 0 roger

echo "Setting permissions..."

chmod 1777 /public
chmod 770 /adm
chmod 770 /sales
chmod 770 /sec

chown root:GRP_ADM /adm
chown root:GRP_SALES /sales
chown root:GRP_SEC /sec

echo "Done."


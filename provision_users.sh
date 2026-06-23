#!/bin/bash
set -euo pipefail
    
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: this script must be run as root (sudo)." >&2
    exit 1
fi

LOG="/var/log/provision_user.log"
exec >> "$LOG" 2>&1

create_user() {
  local USERNAME=$1
  local GROUP=$2

  useradd "$USERNAME" -m -s /bin/bash -p "$HASHED_PASSWORD" -G "$GROUP"
  chage -d 0 "$USERNAME"
}

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

create_user carl GRP_ADM
create_user mary GRP_ADM
create_user john GRP_ADM

create_user diana GRP_SALES
create_user sebastian GRP_SALES
create_user robert GRP_SALES

create_user joe GRP_SEC
create_user amanda GRP_SEC
create_user roger GRP_SEC

echo "Setting permissions..."

chmod 1777 /public
chmod 770 /adm
chmod 770 /sales
chmod 770 /sec

chown root:GRP_ADM /adm
chown root:GRP_SALES /sales
chown root:GRP_SEC /sec

echo "Done."


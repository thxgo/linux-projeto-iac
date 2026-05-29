#!/bin/bash
set -euo pipefail
    
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: this script must be run as root (sudo)." >&2
    exit 1
fi

echo "Criando diretórios..."

sudo mkdir /publico
sudo mkdir /adm
sudo mkdir /ven
sudo mkdir /sec

echo "Criando grupos de usuários..."

groupadd GRP_ADM
groupadd GRP_VEN
groupadd GRP_SEC

echo "Criando usuários..."

read -r -s -p "Digite a senha padrão dos usuários: " PASSWORD
echo
HASHED_PASSWORD=$(openssl passwd -6 "$PASSWORD")
unset PASSWORD

useradd carlos -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
useradd maria -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM
useradd joao -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_ADM

useradd debora -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_VEN
useradd sebastiana -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_VEN
useradd roberto -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_VEN

useradd josefina -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
useradd amanda -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC
useradd rogerio -m -s /bin/bash -p "$HASHED_PASSWORD" -G GRP_SEC

echo "Específicando permissões dos diretórios..."

chmod 777 /publico
chmod 770 /adm
chmod 770 /ven
chmod 770 /sec

chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

echo "Fim."

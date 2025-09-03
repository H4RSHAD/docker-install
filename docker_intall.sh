#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Nombre de usuario local (ajusta si no es el tuyo)
USER_LOCAL="c4p1t4n4z0"

echo -e "\n=== Instalando dependencias necesarias... ===\n"
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    sudo

echo -e "\n=== Configurando repositorio oficial de Docker... ===\n"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo -e "\n=== Instalando Docker Engine + Plugin de Compose ===\n"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "\nDocker instalado correctamente ✅\n"
docker --version
docker compose version

echo -e "\n=== Agregando usuario al grupo docker... ===\n"
sudo usermod -aG docker "$USER_LOCAL"

echo -e "\n=== Habilitando Docker al inicio... ===\n"
sudo systemctl enable docker
sudo systemctl start docker

echo -e "\n=== Desplegando Portainer... ===\n"
docker run -d -p 9000:9000 --name=portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo -e "\n✅ Instalación completa. Reinicia tu sesión o sistema para aplicar los cambios al grupo docker.\n"
echo -e "Accede a Portainer en: http://localhost:9000\n"
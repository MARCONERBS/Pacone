#!/bin/bash
set -e

echo "==== 🚀 Instalação Automática Swarm + Infra Completa ===="

# Perguntas interativas
read -p "📧 Informe o email do admin (Let's Encrypt): " EMAIL_ADMIN
read -p "🌐 Informe o domínio do Portainer: " DOMAIN_PORTAINER
read -p "🌐 Informe o domínio do Chatwoot: " DOMAIN_CHATWOOT
read -p "🌐 Informe o domínio do Evolution API: " DOMAIN_EVOLUTION
read -p "🌐 Informe o domínio do n8n: " DOMAIN_N8N

# Gera senhas/chaves
POSTGRES_PASSWORD=$(openssl rand -hex 16)
N8N_ENCRYPTION_KEY=$(openssl rand -hex 16)
CHATWOOT_SECRET_KEY=$(openssl rand -hex 32)
EVOLUTION_API_KEY=$(openssl rand -hex 16)

# Gera .env
cat > .env <<EOF
EMAIL_ADMIN=$EMAIL_ADMIN
DOMAIN_PORTAINER=$DOMAIN_PORTAINER
DOMAIN_CHATWOOT=$DOMAIN_CHATWOOT
DOMAIN_EVOLUTION=$DOMAIN_EVOLUTION
DOMAIN_N8N=$DOMAIN_N8N
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY
CHATWOOT_SECRET_KEY=$CHATWOOT_SECRET_KEY
EVOLUTION_API_KEY=$EVOLUTION_API_KEY
EOF

echo "✅ Arquivo .env criado."

# Instala Docker
if ! command -v docker &> /dev/null; then
  echo "🐳 Instalando Docker..."
  curl -fsSL https://get.docker.com | bash
fi

# Inicia Swarm
docker swarm init || true
docker network create --driver=overlay --attachable network_public || true

# Cria volumes
for vol in volume_swarm_certificates portainer_data postgres_data redis_data chatwoot_data chatwoot_public evolution_instancesv2 n8n; do
  docker volume create $vol || true
done

# Deploy da stack
docker stack deploy -c stack.yaml infra

echo "⏳ Aguardando Postgres iniciar..."
sleep 25

# Cria bancos
docker exec -i $(docker ps -q -f name=postgres) psql -U postgres <<EOF
CREATE DATABASE chatwoot;
CREATE DATABASE evolution;
CREATE DATABASE n8ndb;
EOF

echo "🎉 Instalação concluída!"
echo "   - Portainer: https://${DOMAIN_PORTAINER}"
echo "   - Chatwoot:  https://${DOMAIN_CHATWOOT}"
echo "   - Evolution: https://${DOMAIN_EVOLUTION}"
echo "   - n8n:       https://${DOMAIN_N8N}"
echo ""
echo "⚠️ Senha Postgres: ${POSTGRES_PASSWORD}"

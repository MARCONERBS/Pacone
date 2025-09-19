# 🚀 Infraestrutura Completa com Docker Swarm

Este repositório sobe automaticamente:

- Traefik (proxy + SSL Let's Encrypt)
- Portainer (gerenciamento containers)
- Postgres + Redis
- Chatwoot (atendimento)
- Evolution API (WhatsApp API)
- n8n (automação)

---

## ⚙️ Instalação

1. Clone o repositório na sua VPS:
   ```bash
   git clone https://github.com/seuuser/infra.git
   cd infra
   ```

2. Dê permissão e execute o script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

3. Responda as perguntas (email e domínios).

---

## 🔑 Acessos

- Portainer → `https://SEU_DOMINIO_PORTAINER`
- Chatwoot → `https://SEU_DOMINIO_CHATWOOT`
- Evolution API → `https://SEU_DOMINIO_EVOLUTION`
- n8n → `https://SEU_DOMINIO_N8N`

As senhas e chaves são geradas automaticamente e salvas no arquivo `.env`.

---

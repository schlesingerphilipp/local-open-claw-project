# OpenClaw + LM Studio Local Setup

Run OpenClaw in a Docker container with a local LLM served by LM Studio.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) + Docker Compose
- [LM Studio](https://lmstudio.ai/) (runs on host machine)
- A local LLM model downloaded in LM Studio

## Hardware Requirements

| Tier | GPU | RAM | Model Support |
|------|-----|-----|---------------|
| Entry | 8GB VRAM (RTX 3060) | 16GB | 7B quantized |
| Sweet Spot | 16GB VRAM (RTX 4060 Ti) | 32GB | 13B quantized |
| Enthusiast | 24GB VRAM (RTX 4090) | 64GB | 30B+ quantized |

## Quick Start

### Step 1: Download a Model

1. Open LM Studio
2. Go to **Discover** in the left sidebar
3. Search for a model (recommended: **Qwen3-32B** or **MiniMax M2.5**)
4. Download the largest quantization your GPU supports:
   - 24GB VRAM: Q5_K_M or Q6_K
   - 16GB VRAM: Q4_K_M
   - 8GB VRAM: Q4_0

### Step 2: Start LM Studio Server

1. Go to **Local Server** in LM Studio
2. Select your downloaded model from the dropdown
3. Set **Context Length** to `32768` (or lower if VRAM limited)
4. Click **Start Server**

The server runs on `http://127.0.0.1:8000`

### Step 3: Start OpenClaw

```bash
# Or start manually:
docker compose up -d
```

### Step 4: Access OpenClaw

- **Dashboard**: http://127.0.0.1:18789
- **CLI**: `docker compose run --rm openclaw-cli <command>`

## Configuration

### Environment Variables (.env)

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENCLAW_GATEWAY_PORT` | 18789 | Dashboard port |
| `OPENCLAW_CONFIG_DIR` | ~/.openclaw | Config storage |
| `OPENCLAW_WORKSPACE_DIR` | ~/.openclaw/workspace | Agent workspace |

### Model Configuration (config/models.json)

Edit `config/models.json` to change:
- Model ID (must match your downloaded model name in LM Studio)
- Context window size
- Max output tokens

After editing, restart: `docker compose restart`

## Usage

### Check Status

```bash
docker compose ps
docker compose logs -f
```

### Open CLI

```bash
docker compose run --rm openclaw-cli gateway probe
docker compose run --rm openclaw-cli devices list
```

### Stop/Start

```bash
docker compose stop
docker compose start
```

### Update

```bash
docker compose pull
docker compose up -d
```

## Troubleshooting

### "Connection Refused" to LM Studio

1. Verify LM Studio server is running (check Local Server tab)
2. Verify the model is loaded
3. Test: `curl http://127.0.0.1:8000/v1/models`

### Port Already in Use

Edit `.env` and change `OPENCLAW_GATEWAY_PORT` to a different port (e.g., 18790)

### Slow Responses

- Reduce context window in LM Studio
- Use a smaller quantization (Q4 instead of Q5/Q6)
- Ensure GPU isn't thermal throttling

## Security

This setup uses basic hardening:
- Non-root user inside container
- `cap_drop` removes NET_RAW and NET_ADMIN capabilities
- `no-new-privileges` prevents privilege escalation

For production, consider:
- Using a reverse proxy with HTTPS
- Enabling firewall rules
- Setting a strong `OPENCLAW_GATEWAY_TOKEN`

## Files

```
.
├── docker-compose.yml     # OpenClaw services
├── .env                   # Environment config
├── config/
│   └── models.json        # LM Studio provider config
├── setup-lmstudio.sh      # Setup helper script
└── README.md             # This file
```

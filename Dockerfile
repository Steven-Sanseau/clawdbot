FROM node:22-bookworm

# Install Bun for build scripts
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

WORKDIR /app

COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build
RUN pnpm ui:install
RUN pnpm ui:build

ENV NODE_ENV=production
ENV HOME=/data

# Create data directory for persistent storage
RUN mkdir -p /data/.clawdbot /data/clawd

CMD ["node", "dist/index.js", "gateway-daemon", "--bind", "lan", "--port", "18789"]

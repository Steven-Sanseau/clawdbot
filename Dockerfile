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

# SETUP MODE: Container stays alive for initial setup
# After setup, change to: CMD ["node", "dist/index.js", "gateway-daemon", "--bind", "tailnet", "--port", "18789"]
CMD ["tail", "-f", "/dev/null"]

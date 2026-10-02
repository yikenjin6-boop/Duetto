FROM node:24-bookworm-slim

WORKDIR /app

ENV NODE_ENV=production \
    PORT=4183 \
    DUETTO_DATA_DIR=/data

COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund && npm cache clean --force

COPY server/ ./server/
COPY frontend/ ./frontend/
COPY deploy/healthcheck.mjs ./deploy/healthcheck.mjs

EXPOSE 4183

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD ["node", "deploy/healthcheck.mjs"]

CMD ["node", "server/index.mjs"]

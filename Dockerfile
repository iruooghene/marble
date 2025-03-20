# Build UI
FROM node:18 AS node-env
WORKDIR /app

# Copy only the UI code
COPY convoy/web/ui/dashboard .

# Install dependencies and build the UI
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/* \
    && git config --global url."https://".insteadOf git://

RUN npm install
RUN npm run build

# Serve UI with a lightweight web server
FROM nginx:latest
COPY --from=node-env /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

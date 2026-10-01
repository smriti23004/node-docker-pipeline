# 1. Use the tiny Alpine Linux version of Node
FROM node:20-alpine

# 2. Set the working directory
WORKDIR /app

# 3. Cache the dependencies layer
COPY package*.json ./
RUN npm install

# 4. Copy the application code
COPY . .

# 5. Secure the container by dropping root privileges
USER node

# 6. Expose the port and start the API
EXPOSE 3000
CMD ["npm", "start"]

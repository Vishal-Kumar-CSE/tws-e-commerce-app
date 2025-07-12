#Stage 1: Build
FROM node:18-alpine AS Build

WORKDIR /app

RUN apk add --no-cache python3 make g++

COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy all project files
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Production Stage
FROM node:18-alpine AS runner

# Set working directory
WORKDIR /app

# Copy necessary files from builder stage
COPY --from=Build /app/.next/standalone ./
COPY --from=Build /app/.next/static ./.next/static
COPY --from=Build /app/public ./public

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "server.js"]
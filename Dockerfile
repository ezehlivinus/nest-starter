# Development environemnt
FROM node:22-alpine AS development

WORKDIR /app

COPY yarn.lock package.json ./

RUN yarn install --only=development

COPY . .

RUN npm run build

EXPOSE $PORT

CMD ["npm", "run", "start:dev"]

# Production environment
FROM node:22-alpine AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

ARG PORT
ENV PORT=${PORT}

WORKDIR /app

COPY yarn.lock package.json ./

RUN yarn install --only=production

COPY --from=development /app/dist ./dist

EXPOSE $PORT

CMD ["node", "./dist/main"]

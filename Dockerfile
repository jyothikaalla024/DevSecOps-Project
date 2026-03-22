# ---------- BUILD STAGE ----------
FROM node:16.17.0-alpine as builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

# ✅ API KEY FROM JENKINS
ARG TMDB_API_KEY

# ✅ VITE ENV
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"

RUN yarn build


# ---------- PRODUCTION ----------
FROM nginx:stable-alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

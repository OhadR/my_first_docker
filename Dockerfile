FROM node:12.17-alpine


RUN npm config set proxy http://proxy-chain.intel.com:911
RUN npm config set https-proxy http://proxy-chain.intel.com:912

ENV http_proxy http://proxy-chain.intel.com:911
ENV https_proxy http://proxy-chain.intel.com:912

RUN apk update
RUN apk add --no-cache git

WORKDIR '/app'
COPY ./package.json ./

# COPY ./.npmrc ./  # ohads: do i need this ??
RUN npm install --verbose

COPY ./src ./src
COPY ./tsconfig.json ./
COPY ./tsconfig.build.json ./

# RUN npm run test:cov
RUN npm run


#CMD ["npm", "run", "start:prod"]
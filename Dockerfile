FROM node:20.11.1
RUN useradd -m nodeuser
USER nodeuser
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . . 
EXPOSE 8000
CMD [ "npm", "run", "start" ]

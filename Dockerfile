FROM node:boron-alpine


ENV BUILD_PACKAGES bash curl-dev ruby-dev build-base git libpng-dev
ENV RUBY_PACKAGES ruby-rdoc ruby ruby-io-console ruby-bundler

RUN apk update && apk upgrade && \
apk add $BUILD_PACKAGES && \
apk add $RUBY_PACKAGES && \
rm -rf /var/cache/apk/* && \
mkdir -p /home/meanshop && \
adduser -S meanshop && \
chown -R meanshop. /home/meanshop && \
echo 'gem is bitching but still successfully installs sass' && \
gem install sass 2>/dev/null; echo 0 && \
npm install -g bower grunt-cli

COPY . /meanshop
WORKDIR /meanshop
# Bundle app source
#ADD server /meanshop
#RUN chown -R meanshop. /meanshop

#COPY node/bootstrap.sh /home/meanshop/bootstrap.sh
COPY node/nostrap.sh /home/meanshop/nostrap.sh
#CMD ["/home/meanshop/bootstrap.sh"]
#USER meanshop
CMD ["/home/meanshop/nostrap.sh"]

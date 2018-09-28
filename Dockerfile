FROM alpine:3.8 AS alpine-jre

## Install tools
RUN apk update && apk upgrade \
## Install curl
    && apk add curl \
## Install pv
    && apk add pv \
## Install Xvfb
    && apk add xvfb \
## Install JRE
    && apk add openjdk8-jre

FROM alpine-jre

# environment variables

ARG KATALON_VERSION=5.7.0
ENV KATALON_DIRECTORY=$KATALON_VERSION
ENV KATALON_PACKAGE=Katalon_Studio_Linux_64-$KATALON_VERSION.tar.gz
ENV KATALON_VERSION_FILE=/katalon/version
ENV KATALON_INSTALL_DIR=opt/katalonstudio
ENV PATH=$PATH:$KATALON_INSTALL_DIR

# Install Katalon
RUN mkdir -p $KATALON_INSTALL_DIR && chmod -R 777 $KATALON_INSTALL_DIR
RUN curl -s http://download.katalon.com/$KATALON_DIRECTORY/$KATALON_PACKAGE | pv | tar xz -C $KATALON_INSTALL_DIR
RUN chmod u+x $KATALON_INSTALL_DIR/katalon \
    && chmod u+x $KATALON_INSTALL_DIR/configuration/resources/drivers/chromedriver_linux64/chromedriver \
    && echo "Katalon Studio $KATALON_VERSION" >> $KATALON_VERSION_FILE

WORKDIR $KATALON_INSTALL_DIR

ENTRYPOINT ["./katalon", "-runMode=console", "-browserType=Remote", "$KATALON_OPTS"]
# CMD ["-runMode=console"]
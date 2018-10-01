FROM alpine:3.8 AS alpine-jre

## Install tools
RUN apk update && apk upgrade \
## Install curl
    && apk add curl \
## Install pv
##    && apk add pv \
## Install Xvfb
    && apk add xvfb \
## Install JRE
    && apk add openjdk8-jre

FROM alpine-jre

# environment variables

ARG KATALON_VERSION=5.7.0
ENV KATALON_DIRECTORY=$KATALON_VERSION
ENV KATALON_PACKAGE=Katalon_Studio_Linux_64-$KATALON_VERSION
ENV KATALON_PACKAGE_ZIPPED=$KATALON_PACKAGE.tar.gz
ENV KATALON_VERSION_FILE=/katalon/version
ENV KATALON_INSTALL_DIR_PARENT=/opt
ENV KATALON_INSTALL_DIR=$KATALON_INSTALL_DIR_PARENT/katalonstudio
ENV PATH=$PATH:$KATALON_INSTALL_DIR

# Install Katalon
RUN mkdir -p $KATALON_INSTALL_DIR_PARENT && chmod -R 777 $KATALON_INSTALL_DIR_PARENT
RUN curl http://download.katalon.com/$KATALON_DIRECTORY/$KATALON_PACKAGE_ZIPPED | tar -xvz -C $KATALON_INSTALL_DIR_PARENT
RUN mv $KATALON_INSTALL_DIR_PARENT/$KATALON_PACKAGE $KATALON_INSTALL_DIR \
    && chmod u+x $KATALON_INSTALL_DIR/katalon \
    && chmod u+x $KATALON_INSTALL_DIR/configuration/resources/drivers/chromedriver_linux64/chromedriver

WORKDIR $KATALON_INSTALL_DIR

ENTRYPOINT ["./katalon", "-runMode=console", "-browserType=Remote", "$KATALON_OPTS"]
CMD ["-consoleLog", "-noExit"]
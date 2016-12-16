FROM tomcat:8-jre8

ENV CYCLOS_VERSION 3.7.3
ENV CYCLOS_HOME /usr/local/cyclos
ENV CYCLOS_LOGDIR /var/log/cyclos

# Remove all files under Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*
ADD cyclos_${CYCLOS_VERSION}.zip /tmp/cyclos.zip

# Download and extract the Cyclos package, and remove the temporary files
RUN set -x \
    && unzip /tmp/cyclos.zip -d /tmp \
    && mv /tmp/cyclos_${CYCLOS_VERSION} /tmp/cyclos \
    && mkdir -p ${CYCLOS_HOME} \
    && mkdir -p ${CYCLOS_LOGDIR} \
    && mv /tmp/cyclos/web/* /usr/local/cyclos \
    && rm -rf /tmp/cyclos*

# Change the workdir to CYCLOS_HOME and copy the docker properties to the regular properties
WORKDIR ${CYCLOS_HOME}
ADD cyclos.properties /tmp
RUN cp /tmp/cyclos.properties WEB-INF/classes/cyclos.properties \
    && rm /tmp/cyclos.properties

# Link the files on Tomcat
RUN ln -s ${CYCLOS_HOME} /usr/local/tomcat/webapps/ROOT

# Set the log dir as a persistent volume
VOLUME ${CYCLOS_LOGDIR}


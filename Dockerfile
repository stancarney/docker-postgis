FROM ubuntu:14.04.5

ENV DB_NAME dev
ENV DB_USER $DB_NAME
ENV DB_PASS dev
ENV PG_BIN /usr/lib/postgresql/9.3/bin
ENV PG_DATA /var/lib/postgresql/9.3/main
ENV PG_CONF /etc/postgresql/9.3/main/postgresql.conf

RUN apt-get update && \
 apt-get install -y -q \
   postgresql-9.3 \
   postgresql-server-dev-9.3 \
   postgresql-9.3-postgis-2.1 \
   postgresql-contrib-9.3 \
   postgresql-client-9.3 && \
 apt-get clean -y && \
 rm -rf /var/lib/apt/lists/*
 
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "CREATE USER ${DB_USER} WITH SUPERUSER PASSWORD '${DB_PASS}';" && \
    createdb -O ${DB_USER} ${DB_NAME}

RUN echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf
EXPOSE 5432

#ENTRYPOINT ["/bin/bash"]
CMD ${PG_BIN}/postgres -D ${PG_DATA} -c config_file=${PG_CONF}


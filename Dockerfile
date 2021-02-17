FROM python:3.8.7-buster

WORKDIR /app

ARG ENV=prod
ARG TIMEZONE='America/Sao_Paulo'

# Setting Timezone
ENV TIMEZONE=$TIMEZONE

RUN echo $TIMEZONE > /etc/timezone && \
    apt-get update && apt-get install -y tzdata netcat && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

# Install Requirements
COPY ./Pipfile* /tmp/

RUN pip install --upgrade pip && \
    pip install pipenv && \
    cd /tmp && \
    if [ "$ENV" = "prod" ]; \
    then pipenv install --system --deploy; \
    else pipenv install --dev --system --deploy; \
    fi 

# Not kill the container
CMD tail -f /dev/null

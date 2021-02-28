FROM python:3.8-alpine

ENV PATH="/scripts:${PATH}"

COPY ./req.txt /req.txt

RUN apk add --update postgresql-libs
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers postgresql-dev
RUN pip install -r /req.txt
RUN apk del .tmp

RUN mkdir /app
COPY ./app /app
WORKDIR /app
COPY ./scripts /scripts

RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
USER user

CMD [ "entrypoint.sh" ]

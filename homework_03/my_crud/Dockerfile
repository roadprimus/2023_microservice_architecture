FROM python:3.11.4-alpine3.18 AS builder

COPY ./requirements.txt /var/www/requirements.txt
COPY ./my_crud /var/www/my_crud

RUN pip install -r /var/www/requirements.txt && \
    chmod +x /var/www/my_crud/runserver.sh

EXPOSE 8000

CMD [ "/bin/sh", "./var/www/my_crud/runserver.sh" ]
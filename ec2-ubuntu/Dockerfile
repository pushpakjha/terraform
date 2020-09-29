FROM python:3.7-slim-buster

COPY requirements.txt /tmp/
COPY ./app /app
WORKDIR "/app"
RUN pip install -r /tmp/requirements.txt

EXPOSE 8050

CMD [ "python", "app.py" ]

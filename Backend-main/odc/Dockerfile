FROM python:3.10-slim 
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 8080
CMD [ "gunicorn", "--bind", "0.0.0.0:8000", "odc.wsgi:application" ]
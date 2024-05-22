FROM python:3.9

# RUN apt update; apt install -y libgl1

RUN apt-get update
RUN apt-get install -y python python-pip python-virtualenv gunicorn libgl1

# Install python dependencies
# ADD requirements.txt /app
# RUN pip3 install --upgrade pip
# RUN pip3 install -r requirements.txt

# Setup flask application
RUN mkdir -p /deploy/app
COPY . /deploy/app
RUN pip install -r /deploy/app/requirements.txt
WORKDIR /deploy/app

EXPOSE 8000
CMD ["/usr/bin/gunicorn"  , "--bind", "0.0.0.0:8000", "app:app"]
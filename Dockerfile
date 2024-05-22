FROM python:3.9


RUN apt update; apt install -y libgl1

# Install python dependencies
# ADD requirements.txt /app
# RUN pip3 install --upgrade pip
# RUN pip3 install -r requirements.txt

# Copy sources
# ADD . /app

RUN mkdir -p /deploy
COPY . /deploy
RUN pip install -r /deploy/requirements.txt
WORKDIR /deploy

EXPOSE 8000
CMD ["gunicorn"  , "--bind", "0.0.0.0:8000", "app:app"]
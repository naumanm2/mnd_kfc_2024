FROM python:3.9

WORKDIR /app

# Install python dependencies
ADD requirements.txt /app
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

RUN apt update; apt install -y libgl1

# Copy sources
# ADD . /app

COPY . /app

EXPOSE 8000
ENTRYPOINT ["python", "app.py"]
CMD ["gunicorn"  , "--bind", "0.0.0.0:8000", "app:app"]
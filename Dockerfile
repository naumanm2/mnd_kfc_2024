FROM python:3.9

WORKDIR /app

# Install python dependencies
ADD requirements.txt /app/
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

RUN apt update; apt install -y libgl1

# Copy sources
ADD . /app

# Run detection
CMD ["app.py" ]
ENTRYPOINT ["python3"]
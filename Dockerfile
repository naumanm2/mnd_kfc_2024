FROM python:3.9

WORKDIR /app

# Install python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

RUN apt update; apt install -y libgl1

# Copy sources
ADD . /app

COPY . .

EXPOSE 5000/tcp
EXPOSE 5000/udp

CMD [ "python", "-m" , "flask", "run", "--host=0.0.0.0"]
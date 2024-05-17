import base64
import numpy as np
import io
import cv2 
from PIL import Image

from cvzone.HandTrackingModule import HandDetector

from flask import Flask, render_template
from flask_socketio import SocketIO, emit

# Creating a flask app and using it to instantiate a socket object
app = Flask(__name__)
socketio = SocketIO(app)


detector = HandDetector(staticMode=False, maxHands=1, modelComplexity=1, detectionCon=0.5, minTrackCon=0.5)
cap = cv2.VideoCapture(1) 

# Handler for default flask route
# Using jinja template to render html along with slider value as input
@app.route('/')
def index():
    return render_template('index.html')

# Handler for a message recieved over 'connect' channel
@socketio.on('connect')
def test_connect():
    emit('after connect',  {'data':'Lets dance'})
    
@socketio.on('image')
def detect(data):
  
    def stringToRGB(base64_string):
        if "data:image" in base64_string:
             base64_string = base64_string.split(",")[1]
             
        imgdata = base64.b64decode(str(base64_string))
        img = Image.open(io.BytesIO(imgdata))
        opencv_img= cv2.cvtColor(np.array(img), cv2.COLOR_BGR2RGB)
        return opencv_img 


    RGBimage = stringToRGB(data)
    
    img = cv2.flip(RGBimage, 1) 
    
    hand, img = detector.findHands(img, draw=True, flipType=True) 
    if hand: 
        hand = hand[0] 
        lmList = hand["lmList"]  # List of 21 landmarks for the first hand
        if lmList: 
            fingers = detector.fingersUp(hand)
            print(f'H = {fingers.count(1)}', end=" ")  # Print the count of fingers that are up
            if fingers == [0,1,1,1,0]:
                print("Success")
                emit('positive', {'result': True})
    else:
      emit('negative', {'result': False}) 
    
    
    
    
          
# Notice how socketio.run takes care of app instantiation as well.
if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=5050)
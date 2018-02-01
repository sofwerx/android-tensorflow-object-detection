# Android Tensorflow Object Detection 

### Description

This Repostiory was created so people can put their own trained object detection tensorflow models on an android mobile device. The provided model file and text file was trained to identify AK47's. The object detection app was designed by Google.

### App
The App used for object detection is Tensorflows mobile app called TF Classify. The default model that came with this app is Mobilenet 

### Training
Training of a model can be done using Tensorlfow Object Detection API. The documentaion and turtorials to train models can be found in the following link. [Introduction and Use - Tensorflow Object Detection API Tutorial](https://pythonprogramming.net/introduction-use-tensorflow-object-detection-api-tutorial/) .


### Model
The TensorFlow Inception V2 Model was selected. The model was trained using Tensorflow's Object Detection API. If this app is implemented on an older phone or tablet, its operation will be slow. Object dection for this app can be faster if the model is quanitzed. Mobilenet and Inception worked ok but there were issues using Faster_CNN
 



### Assumptions
* docker installed
* docker-compose installed
* adb installed
* ubuntu 16.04 lts installed
* git installed
* have android phone

### Steps


Download project to Desktop

```
cd $HOME/Desktop
```

Download project repository

```
git clone https://github.com/sofwerx/android_tensorflow_object_detection.git

```

go to project directory
Note : Replace the files INCMODEL.pb and object-detection.pbtxt files if you are using your own model.

```
cd android_tensorflow_object_detection
```

Build docker image to run docker container

```
docker build -t android/tensorflow .
```

Run docker container and find andorid apk at home directory

```
docker run --rm -it -v /$HOME/Desktop:/outputs android/tensorflow
```




## Additional Resource Information

* [Introduction and Use - Tensorflow Object Detection API Tutorial](https://pythonprogramming.net/introduction-use-tensorflow-object-detection-api-tutorial/)
* [What is adb](https://developer.android.com/studio/command-line/adb.html#move)
* [Addin to download images for training](https://www.pcsteps.com/5170-mass-download-images-chrome/)

import numpy as np
import cv2
import matplotlib.pyplot as plt
import glob


hit = 0
Totalcount = 0

var = 0.2

#counter = np.zeros(256)

for image_path in glob.glob("segmentation/COVID/*.jpg"):
#for image_path in glob.glob("segmentation/non-COVID/*.png"):
    img_gray = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    count = 0
    Totalcount = Totalcount + 1
    colorcount = 0

    img = np.copy(img_gray)
    [x,y] = img_gray.shape

    total = x * y
    for i in range(x):
        for j in range(y):
            if img_gray[i, j] > 130 and img_gray[i, j] < 200 :
                count = count+1
            if img_gray[i, j] > 15 and img_gray[i, j] < 240:
                colorcount = colorcount +1

    print(Totalcount)
    if count/colorcount > var:
        hit = hit+1

print('rate')
print('Number of hited in COVID')
print(hit)
print('Rate of hited in COVID')
print(hit/Totalcount)





hit = 0
Totalcount = 0

for image_path in glob.glob("segmentation/non-COVID/*.jpg"):
#for image_path in glob.glob("segmentation/non-COVID/*.png"):
    img_gray = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    count = 0
    Totalcount = Totalcount + 1
    colorcount = 0

    img = np.copy(img_gray)
    [x,y] = img_gray.shape

    total = x * y
    for i in range(x):
        for j in range(y):
            if img_gray[i, j] > 130 and img_gray[i, j] < 200 :
                count = count+1
            if img_gray[i, j] > 15 and img_gray[i, j] < 240:
                colorcount = colorcount +1

    print(Totalcount)
    if count/colorcount > var:
        hit = hit+1




print('rate')
print('Number of hited in non-COVID')
print(hit)
print('Rate of hited in non-COVID')
print(hit/Totalcount)
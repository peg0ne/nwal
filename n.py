import nimporter
import nwal
import sys
from PIL import Image

def fetchpixels(path):
    im = Image.open(path)
    return list(im.getdata())

def getColors(path):
    px = fetchpixels(path)
    co = nwal.extract(px)
    return co

if __name__ == '__main__':
    co = getColors(sys.argv[1])
    base = nwal.getBase()
    im = Image.new(mode="RGB", size=(len(co),2))
    for i in range(len(co)):
        im.putpixel((i,0), (co[i][0],co[i][1],co[i][2]))
        im.putpixel((i,1), (base[i][0],base[i][1],base[i][2]))
    im.save("testing.png")

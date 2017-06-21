Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33071 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdFUVes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 17:34:48 -0400
MIME-Version: 1.0
From: Adam Ford <aford173@gmail.com>
Date: Wed, 21 Jun 2017 16:34:41 -0500
Message-ID: <CAHCN7xJVjDoVUUuCayJ9-oDix711GSqZR842U_V4_tH8_GZAUQ@mail.gmail.com>
Subject: OMAP3630 ISP V4L2 Camera Not Streaming to LCD
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a Leopard Imaging LI-5M03 camera attached in 8-bit mode, and I
am trying to capture an image on  camera and stream it to the LCD
(/dev/fb0) without using the DSP or proprietary codecs.

I was hoping to do it with either gstreamer (preferrably 1.0) or ffpeg.

My board has mainline device tree (logicpd-torpedo-37xx-devkit).
( have played wtih some of the settings, but nothing seems to make any
difference)


Using (https://github.com/Alaganraj/omap3isp/blob/master/0001-ARM-omap3-beagle-Add-.dtsi-for-the-LI-5M03-camera-se.patch)
as an example.

Using Linux 4.11.y stable branch, I setup the camera as follows:

media-ctl -v -r -l '"mt9p031 1-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3
ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer
output":0[1]'

media-ctl -v -V '"mt9p031 1-0048":0 [SGRBG8 1298x970
(664,541)/1298x970], "OMAP3 ISP CCDC":2 [SGRBG10 1298x970], "OMAP3 ISP
preview":1 [UYVY 1298x970], "OMAP3 ISP resizer":1 [UYVY 320x240]'


The media controller shows that this part appears to work correctly.
# media-ctl -p
Media controller API version 0.1.0

Media device information
------------------------
driver          omap3isp
model           TI OMAP3 ISP
serial
bus info
hw revision     0xf0
driver version  0.0.0

Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
        pad0: Sink
                [fmt:SGRBG10_1X10/4096x4096 field:none]
                <- "OMAP3 ISP CCP2 input":0 []
        pad1: Source
                [fmt:SGRBG10_1X10/4096x4096 field:none]
                -> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
        pad0: Source
                -> "OMAP3 ISP CCP2":0 []

- entity 8: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
        pad0: Sink
                [fmt:SGRBG10_1X10/4096x4096 field:none]
        pad1: Source
                [fmt:SGRBG10_1X10/4096x4096 field:none]
                -> "OMAP3 ISP CSI2a output":0 []
                -> "OMAP3 ISP CCDC":0 []

- entity 11: OMAP3 ISP CSI2a output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video1
        pad0: Sink
                <- "OMAP3 ISP CSI2a":1 []

- entity 15: OMAP3 ISP CCDC (3 pads, 9 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:SGRBG12_1X12/1298x970 field:none]
                <- "OMAP3 ISP CCP2":1 []
                <- "OMAP3 ISP CSI2a":1 []
                <- "mt9p031 1-0048":0 [ENABLED]
        pad1: Source
                [fmt:SGRBG12_1X12/1296x970 field:none
                 crop.bounds:(0,0)/1312x970
                 crop:(0,0)/1296x970]
                -> "OMAP3 ISP CCDC output":0 []
                -> "OMAP3 ISP resizer":0 []
        pad2: Source
                [fmt:SGRBG10_1X10/1298x969 field:none]
                -> "OMAP3 ISP preview":0 [ENABLED]
                -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
                -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
                -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 19: OMAP3 ISP CCDC output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video2
        pad0: Sink
                <- "OMAP3 ISP CCDC":1 []

- entity 23: OMAP3 ISP preview (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev3
        pad0: Sink
                [fmt:SGRBG10_1X10/1298x969 field:none
                 crop.bounds:(10,4)/1280x961
                 crop:(10,4)/1280x961]
                <- "OMAP3 ISP CCDC":2 [ENABLED]
                <- "OMAP3 ISP preview input":0 []
        pad1: Source
                [fmt:UYVY8_1X16/1280x961 field:none]
                -> "OMAP3 ISP preview output":0 []
                -> "OMAP3 ISP resizer":0 [ENABLED]

- entity 26: OMAP3 ISP preview input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video3
        pad0: Source
                -> "OMAP3 ISP preview":0 []

- entity 30: OMAP3 ISP preview output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video4
        pad0: Sink
                <- "OMAP3 ISP preview":1 []

- entity 34: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
        pad0: Sink
                [fmt:UYVY8_1X16/1280x961 field:none
                 crop.bounds:(0,0)/1280x961
                 crop:(0,0)/1280x961]
                <- "OMAP3 ISP CCDC":1 []
                <- "OMAP3 ISP preview":1 [ENABLED]
                <- "OMAP3 ISP resizer input":0 []
        pad1: Source
                [fmt:UYVY8_1X16/320x240 field:none]
                -> "OMAP3 ISP resizer output":0 [ENABLED]

- entity 37: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
        pad0: Source
                -> "OMAP3 ISP resizer":0 []

- entity 41: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 1
             device node name /dev/video6
        pad0: Sink
                <- "OMAP3 ISP resizer":1 [ENABLED]

- entity 45: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
        pad0: Sink
                <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 47: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
        pad0: Sink
                <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 49: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
        pad0: Sink
                <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 81: mt9p031 1-0048 (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
        pad0: Source
                [fmt:SGRBG12_1X12/1298x970 field:none
                 crop:(664,542)/1298x970]
                -> "OMAP3 ISP CCDC":0 [ENABLED]

#

Unfortunately, when I run ffmpeg, I get a nothing but white pixels but
the resolution matches the resolution I configured as  320x240.

export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
ffmpeg -an -re -i /dev/video6 -f v4l2  -vcodec rawvideo -pix_fmt
rgb565le -f fbdev /dev/fb0


I got a bunch of repeated messages that read:
  libv4l2: error dequeuing buf: Resource temporarily unavailable

Then it stabilizes and shows:

Input #0, video4linux2,v4l2, from '/dev/video6':
  Duration: N/A, start: 2744.553524, bitrate: N/A
    Stream #0:0: Video: rawvideo (UYVY / 0x59565955), uyvy422, 320x240, 23.08 tb
r, 1000k tbn, 1000k tbc
Stream mapping:
  Stream #0:0 -> #0:0 (rawvideo (native) -> rawvideo (native))
Press [q] to stop, [?] for help
Output #0, fbdev, to '/dev/fb0':
  Metadata:
    encoder         : Lavf57.71.100
    Stream #0:0: Video: rawvideo (RGB[16] / 0x10424752), rgb565le, 320x240, q=2-
31, 28364 kb/s, 23.08 fps, 23.08 tbn, 23.08 tbc
    Metadata:
      encoder         : Lavc57.89.100 rawvideo

It looks like it's appearing to stream, but it's just white pixels.


My omapfb is setup as 16 bit parallel LCD, but I wasn't sure if I need
to configure the omap_vout or not to stream using V4L2.

When omap_vout initializes, I get errors as well:

[    4.080017] omap_vout omap_vout: probed for an unknown device
[    4.086944] omap_vout:Could not register Video driver

If anyone has any suggestions, I thought it might help others who
still use the OMAP3630 and DM3730.

adam

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50388 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751402AbdFZQTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 12:19:36 -0400
Date: Mon, 26 Jun 2017 19:19:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Adam Ford <aford173@gmail.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: OMAP3630 ISP V4L2 Camera Not Streaming to LCD
Message-ID: <20170626161930.GP12407@valkosipuli.retiisi.org.uk>
References: <CAHCN7xJVjDoVUUuCayJ9-oDix711GSqZR842U_V4_tH8_GZAUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xJVjDoVUUuCayJ9-oDix711GSqZR842U_V4_tH8_GZAUQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Wed, Jun 21, 2017 at 04:34:41PM -0500, Adam Ford wrote:
> I have a Leopard Imaging LI-5M03 camera attached in 8-bit mode, and I
> am trying to capture an image on  camera and stream it to the LCD
> (/dev/fb0) without using the DSP or proprietary codecs.
> 
> I was hoping to do it with either gstreamer (preferrably 1.0) or ffpeg.
> 
> My board has mainline device tree (logicpd-torpedo-37xx-devkit).
> ( have played wtih some of the settings, but nothing seems to make any
> difference)
> 
> 
> Using (https://github.com/Alaganraj/omap3isp/blob/master/0001-ARM-omap3-beagle-Add-.dtsi-for-the-LI-5M03-camera-se.patch)
> as an example.
> 
> Using Linux 4.11.y stable branch, I setup the camera as follows:
> 
> media-ctl -v -r -l '"mt9p031 1-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3
> ISP resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer
> output":0[1]'
> 
> media-ctl -v -V '"mt9p031 1-0048":0 [SGRBG8 1298x970
> (664,541)/1298x970], "OMAP3 ISP CCDC":2 [SGRBG10 1298x970], "OMAP3 ISP
> preview":1 [UYVY 1298x970], "OMAP3 ISP resizer":1 [UYVY 320x240]'
> 
> 
> The media controller shows that this part appears to work correctly.
> # media-ctl -p
> Media controller API version 0.1.0
> 
> Media device information
> ------------------------
> driver          omap3isp
> model           TI OMAP3 ISP
> serial
> bus info
> hw revision     0xf0
> driver version  0.0.0
> 
> Device topology
> - entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
>             type V4L2 subdev subtype Unknown flags 0
>             device node name /dev/v4l-subdev0
>         pad0: Sink
>                 [fmt:SGRBG10_1X10/4096x4096 field:none]
>                 <- "OMAP3 ISP CCP2 input":0 []
>         pad1: Source
>                 [fmt:SGRBG10_1X10/4096x4096 field:none]
>                 -> "OMAP3 ISP CCDC":0 []
> 
> - entity 4: OMAP3 ISP CCP2 input (1 pad, 1 link)
>             type Node subtype V4L flags 0
>             device node name /dev/video0
>         pad0: Source
>                 -> "OMAP3 ISP CCP2":0 []
> 
> - entity 8: OMAP3 ISP CSI2a (2 pads, 2 links)
>             type V4L2 subdev subtype Unknown flags 0
>             device node name /dev/v4l-subdev1
>         pad0: Sink
>                 [fmt:SGRBG10_1X10/4096x4096 field:none]
>         pad1: Source
>                 [fmt:SGRBG10_1X10/4096x4096 field:none]
>                 -> "OMAP3 ISP CSI2a output":0 []
>                 -> "OMAP3 ISP CCDC":0 []
> 
> - entity 11: OMAP3 ISP CSI2a output (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video1
>         pad0: Sink
>                 <- "OMAP3 ISP CSI2a":1 []
> 
> - entity 15: OMAP3 ISP CCDC (3 pads, 9 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev2
>         pad0: Sink
>                 [fmt:SGRBG12_1X12/1298x970 field:none]
>                 <- "OMAP3 ISP CCP2":1 []
>                 <- "OMAP3 ISP CSI2a":1 []
>                 <- "mt9p031 1-0048":0 [ENABLED]
>         pad1: Source
>                 [fmt:SGRBG12_1X12/1296x970 field:none
>                  crop.bounds:(0,0)/1312x970
>                  crop:(0,0)/1296x970]
>                 -> "OMAP3 ISP CCDC output":0 []
>                 -> "OMAP3 ISP resizer":0 []
>         pad2: Source
>                 [fmt:SGRBG10_1X10/1298x969 field:none]
>                 -> "OMAP3 ISP preview":0 [ENABLED]
>                 -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
>                 -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
>                 -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]
> 
> - entity 19: OMAP3 ISP CCDC output (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video2
>         pad0: Sink
>                 <- "OMAP3 ISP CCDC":1 []
> 
> - entity 23: OMAP3 ISP preview (2 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev3
>         pad0: Sink
>                 [fmt:SGRBG10_1X10/1298x969 field:none
>                  crop.bounds:(10,4)/1280x961
>                  crop:(10,4)/1280x961]
>                 <- "OMAP3 ISP CCDC":2 [ENABLED]
>                 <- "OMAP3 ISP preview input":0 []
>         pad1: Source
>                 [fmt:UYVY8_1X16/1280x961 field:none]
>                 -> "OMAP3 ISP preview output":0 []
>                 -> "OMAP3 ISP resizer":0 [ENABLED]
> 
> - entity 26: OMAP3 ISP preview input (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video3
>         pad0: Source
>                 -> "OMAP3 ISP preview":0 []
> 
> - entity 30: OMAP3 ISP preview output (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video4
>         pad0: Sink
>                 <- "OMAP3 ISP preview":1 []
> 
> - entity 34: OMAP3 ISP resizer (2 pads, 4 links)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev4
>         pad0: Sink
>                 [fmt:UYVY8_1X16/1280x961 field:none
>                  crop.bounds:(0,0)/1280x961
>                  crop:(0,0)/1280x961]
>                 <- "OMAP3 ISP CCDC":1 []
>                 <- "OMAP3 ISP preview":1 [ENABLED]
>                 <- "OMAP3 ISP resizer input":0 []
>         pad1: Source
>                 [fmt:UYVY8_1X16/320x240 field:none]
>                 -> "OMAP3 ISP resizer output":0 [ENABLED]
> 
> - entity 37: OMAP3 ISP resizer input (1 pad, 1 link)
>              type Node subtype V4L flags 0
>              device node name /dev/video5
>         pad0: Source
>                 -> "OMAP3 ISP resizer":0 []
> 
> - entity 41: OMAP3 ISP resizer output (1 pad, 1 link)
>              type Node subtype V4L flags 1
>              device node name /dev/video6
>         pad0: Sink
>                 <- "OMAP3 ISP resizer":1 [ENABLED]
> 
> - entity 45: OMAP3 ISP AEWB (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev5
>         pad0: Sink
>                 <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 47: OMAP3 ISP AF (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev6
>         pad0: Sink
>                 <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 49: OMAP3 ISP histogram (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev7
>         pad0: Sink
>                 <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 81: mt9p031 1-0048 (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown flags 0
>              device node name /dev/v4l-subdev8
>         pad0: Source
>                 [fmt:SGRBG12_1X12/1298x970 field:none
>                  crop:(664,542)/1298x970]
>                 -> "OMAP3 ISP CCDC":0 [ENABLED]
> 
> #
> 
> Unfortunately, when I run ffmpeg, I get a nothing but white pixels but
> the resolution matches the resolution I configured as  320x240.
> 
> export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
> ffmpeg -an -re -i /dev/video6 -f v4l2  -vcodec rawvideo -pix_fmt
> rgb565le -f fbdev /dev/fb0
> 
> 
> I got a bunch of repeated messages that read:
>   libv4l2: error dequeuing buf: Resource temporarily unavailable

Could you see what does videobuf2 / V4L2 IOCTL handler tells? This should be
roughly be enabled by:

echo "file v4l2-ioctl.c +p" > /where/is/debugfs/dynamic_debug/control
echo 1 > /sys/module/videobuf2_v4l2/parameters/debug
echo 1 > /sys/module/videobuf2_core/parameters/debug

And finally use dmesg to view the logs.

I have to admit I haven't used GStreamer for a while, perhaps the kernel
logs could tell something.

Cc Laurent as well.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

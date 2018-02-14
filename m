Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hedonline.com ([12.133.124.242]:39615 "EHLO
        HED-Exchange.hed.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1031294AbeBNP0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 10:26:51 -0500
From: Matthew Starr <mstarr@hedonline.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: i.MX53 using imx-media to capture analog video through ADV7180
Date: Wed, 14 Feb 2018 15:21:42 +0000
Message-ID: <3C8219BAE02B894A9C69304A12E8AA0656AAF9AE@HED-Exchange.hed.local>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have successfully modified device tree files in the mainline 4.15.1 kernel to get a display product using the i.MX53 processor to initialize the imx-media drivers.  I think up to this point they have only been tested on i.MX6 processors.  I am using two ADV7180 analog capture chips, one per CSI port, on this display product.

I have everything initialize successfully at boot, but I am unable to get the media-ctl command to link the ADV7180 devices to the CSI ports.  I used the following website as guidance of how to setup the links between media devices:
https://linuxtv.org/downloads/v4l-dvb-apis/v4l-drivers/imx.html

When trying to link the ADV7180 chip to a CSI port, I use the following command and get the result below:

	media-ctl -v -l "'adv7180 1-0021':0->'ipu1_csi0':0[1]"
	
	No link between "adv7180 1-0021":0 and "ipu1_csi0":0
	media_parse_setup_link: Unable to parse link
	Unable to parse link: Invalid argument (22)

How do I get the ADV7180 and CSI port on the i.MX53 processor to link?

The difference for the i.MX53 compared to the i.MX6 processor is that there is only one IPU and no mipi support, so my device tree does not use any video-mux or mux devices.  Could this have something to do with why I can't link the ADV7180 to the CSI port?   

Here is the output of the "media-ctl -p -v" command:

Opening media device /dev/media0
Enumerating entities
looking up device: 81:10
looking up device: 81:11
looking up device: 81:12
looking up device: 81:4
looking up device: 81:13
looking up device: 81:5
looking up device: 81:14
looking up device: 81:15
looking up device: 81:16
looking up device: 81:17
looking up device: 81:6
looking up device: 81:18
looking up device: 81:7
looking up device: 81:19
looking up device: 81:20
looking up device: 81:8
looking up device: 81:21
looking up device: 81:9
Found 18 entities
Enumerating pads and links
Media controller API version 4.15.1

Media device information
------------------------
driver          imx-media
model           imx-media
serial          
bus info        
hw revision     0x0
driver version  4.15.1

Device topology
- entity 1: adv7180 1-0021 (1 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 20004
            device node name /dev/v4l-subdev0
        pad0: Source
                [fmt:UYVY8_2X8/720x480 field:interlaced]

- entity 3: adv7180 1-0020 (1 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 20004
            device node name /dev/v4l-subdev1
        pad0: Source
                [fmt:UYVY8_2X8/720x480 field:interlaced]

- entity 5: ipu1_csi1 (3 pads, 3 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
        pad0: Sink
                [fmt:UYVY8_2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/640x480
                 compose.bounds:(0,0)/640x480
                 compose:(0,0)/640x480]
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prp":0 []
                -> "ipu1_vdic":0 []
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_csi1 capture":0 []

- entity 9: ipu1_csi1 capture (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
        pad0: Sink
                <- "ipu1_csi1":2 []

- entity 15: ipu1_csi0 (3 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev3
        pad0: Sink
                [fmt:UYVY8_2X8/640x480 field:none
                 crop.bounds:(0,0)/640x480
                 crop:(0,0)/640x480
                 compose.bounds:(0,0)/640x480
                 compose:(0,0)/640x480]
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prp":0 []
                -> "ipu1_vdic":0 [ENABLED]
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_csi0 capture":0 []

- entity 19: ipu1_csi0 capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
        pad0: Sink
                <- "ipu1_csi0":2 []

- entity 25: ipu1_ic_prp (3 pads, 5 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu1_csi1":1 []
                <- "ipu1_csi0":1 []
                <- "ipu1_vdic":2 [ENABLED]
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prpenc":0 []
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prpvf":0 [ENABLED]

- entity 29: ipu1_vdic (3 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu1_csi1":1 []
                <- "ipu1_csi0":1 [ENABLED]
        pad1: Sink
                [fmt:UYVY8_2X8/640x480 field:none]
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prp":0 [ENABLED]

- entity 33: ipu2_vdic (3 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
        pad1: Sink
                [fmt:UYVY8_2X8/640x480 field:none]
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu2_ic_prp":0 []

- entity 37: ipu1_ic_prpenc (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu1_ic_prp":1 []
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prpenc capture":0 []

- entity 40: ipu1_ic_prpenc capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
        pad0: Sink
                <- "ipu1_ic_prpenc":1 []

- entity 46: ipu1_ic_prpvf (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu1_ic_prp":2 [ENABLED]
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu1_ic_prpvf capture":0 [ENABLED]

- entity 49: ipu1_ic_prpvf capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video7
        pad0: Sink
                <- "ipu1_ic_prpvf":1 [ENABLED]

- entity 55: ipu2_ic_prp (3 pads, 3 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev9
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu2_vdic":2 []
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu2_ic_prpenc":0 []
        pad2: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu2_ic_prpvf":0 []

- entity 59: ipu2_ic_prpenc (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev10
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu2_ic_prp":1 []
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu2_ic_prpenc capture":0 []

- entity 62: ipu2_ic_prpenc capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video8
        pad0: Sink
                <- "ipu2_ic_prpenc":1 []

- entity 68: ipu2_ic_prpvf (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev11
        pad0: Sink
                [fmt:AYUV8_1X32/640x480 field:none]
                <- "ipu2_ic_prp":2 []
        pad1: Source
                [fmt:AYUV8_1X32/640x480 field:none]
                -> "ipu2_ic_prpvf capture":0 []

- entity 71: ipu2_ic_prpvf capture (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video9
        pad0: Sink
                <- "ipu2_ic_prpvf":1 []


Best regards,
 
Matthew Starr

Return-path: <mchehab@pedra>
Received: from nm8-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.194]:32795 "HELO
	nm8-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754053Ab1EYDp3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 23:45:29 -0400
Message-ID: <551158.38796.qm@web112009.mail.gq1.yahoo.com>
Date: Tue, 24 May 2011 20:45:28 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [PATCH v2 1/2] MT9P031: Add support for Aptina mt9p031 sensor.
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Have upgraded the driver to Javier's latest RFC driver.
Still having problems viewing output.

Setting up with:
# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

# media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3 ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
Format set: SGRB
Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
Format set: SGRBG12 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
Format set: SGRBG8 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
Format set: SGRBG8 320x240

Then:
# yavta -f SGRBG8 -s 320x240 -n 4 --capture=100 -F /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: width: 320 height: 240 buffer size: 76800
Video format: GRBG (47425247) 320x240
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x4006c000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x40222000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x4025e000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x402f0000.

After this it hangs and will exit on 'ctrl c':
omap3isp omap3isp: CCDC stop timeout!

Any ideas what is causing this problem?




This may be useful also:
# media-ctl -p
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev0
        pad0: Input [SGRBG10 4096x4096]
                <- 'OMAP3 ISP CCP2 input':pad0 []
        pad1: Output [SGRBG10 4096x4096]
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video0
        pad0: Output 
                -> 'OMAP3 ISP CCP2':pad0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev1
        pad0: Input [SGRBG10 4096x4096]
        pad1: Output [SGRBG10 4096x4096]
                -> 'OMAP3 ISP CSI2a output':pad0 []
                -> 'OMAP3 ISP CCDC':pad0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video1
        pad0: Input 
                <- 'OMAP3 ISP CSI2a':pad1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev2
        pad0: Input [SGRBG8 320x240]
                <- 'OMAP3 ISP CCP2':pad1 []
                <- 'OMAP3 ISP CSI2a':pad1 []
                <- 'mt9p031 2-0048':pad0 [ACTIVE]
        pad1: Output [SGRBG8 320x240]
                -> 'OMAP3 ISP CCDC output':pad0 [ACTIVE]
                -> 'OMAP3 ISP resizer':pad0 []
        pad2: Output [SGRBG8 320x239]
                -> 'OMAP3 ISP preview':pad0 []
                -> 'OMAP3 ISP AEWB':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP AF':pad0 [IMMUTABLE,ACTIVE]
                -> 'OMAP3 ISP histogram':pad0 [IMMUTABLE,ACTIVE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video2
        pad0: Input 
                <- 'OMAP3 ISP CCDC':pad1 [ACTIVE]

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev3
        pad0: Input [SGRBG10 4096x4096]
                <- 'OMAP3 ISP CCDC':pad2 []
                <- 'OMAP3 ISP preview input':pad0 []
        pad1: Output [YUYV 2034x4088]
                -> 'OMAP3 ISP preview output':pad0 []
                -> 'OMAP3 ISP resizer':pad0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video3
        pad0: Output 
                -> 'OMAP3 ISP preview':pad0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video4
        pad0: Input 
                <- 'OMAP3 ISP preview':pad1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev4
        pad0: Input [YUYV 4095x4095 (0,6)/4094x4082]
                <- 'OMAP3 ISP CCDC':pad1 []
                <- 'OMAP3 ISP preview':pad1 []
                <- 'OMAP3 ISP resizer input':pad0 []
        pad1: Output [YUYV 3312x4095]
                -> 'OMAP3 ISP resizer output':pad0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video5
        pad0: Output 
                -> 'OMAP3 ISP resizer':pad0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
        pad0: Input 
                <- 'OMAP3 ISP resizer':pad1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev5
        pad0: Input 
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev6
        pad0: Input 
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev7
        pad0: Input 
                <- 'OMAP3 ISP CCDC':pad2 [IMMUTABLE,ACTIVE]

- entity 16: mt9p031 2-0048 (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev8
        pad0: Output [SGRBG12 2592x1944 (16,54)/2592x1944]
                -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]



Cheers,
Chris


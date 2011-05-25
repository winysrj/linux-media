Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45560 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab1EYNiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:38:24 -0400
Received: by wwa36 with SMTP id 36so8490763wwa.1
        for <linux-media@vger.kernel.org>; Wed, 25 May 2011 06:38:23 -0700 (PDT)
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Koen Kooi <koen@beagleboard.org>
In-Reply-To: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 25 May 2011 15:38:19 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, carlighting@yahoo.co.nz,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <F50AF7E4-DCBA-4FC9-971A-ADF01F342FEF@beagleboard.org>
References: <1306322212-26879-1-git-send-email-javier.martin@vista-silicon.com>
To: beagleboard@googlegroups.com
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Op 25 mei 2011, om 13:16 heeft Javier Martin het volgende geschreven:

> It includes several fixes pointed out by Laurent Pinchart. However,
> the BUG which shows artifacts in the image (horizontal lines) still
> persists. It won't happen if 1v8 regulator is not disabled (i.e.
> comment line where it is disabled in function "mt9p031_power_off").
> I know there can be some other details to fix but I would like someone
> could help in the power management issue.

I tried this + your beagle patch on 2.6.39 and both ISP and sensor being builtin to the kernel, I get the following:

root@beagleboardxMC:~# media-ctl -r -l '"mt9p031 2-0048":0->"OMAP3 ISP CCDC":0[1 ], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]

root@beagleboardxMC:~# media-ctl -f '"mt9p031 2-0048":0[SGRBG12 320x240], "OMAP3  ISP CCDC":0[SGRBG8 320x240], "OMAP3 ISP CCDC":1[SGRBG8 320x240]'
Setting up format SGRBG12 320x240 on pad mt9p031 2-0048/0
Format set: SGRBG12 320x240
Setting up format SGRBG12 320x240 on pad OMAP3 ISP CCDC/0
Format set: SGRBG12 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/0
Format set: SGRBG8 320x240
Setting up format SGRBG8 320x240 on pad OMAP3 ISP CCDC/1
Format set: SGRBG8 320x240

oot@beagleboardxMC:~# yavta -f SGRBG8 -s 320x240 -n 4 --capture=10 --skip 3 -F  `media-ctl -e "OMAP3 ISP CCDC output"`
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SGRBG8 (47425247) 320x240 buffer size 76800
Video format: SGRBG8 (47425247) 320x240 buffer size 76800
4 buffers requested.
length: 76800 offset: 0
Buffer 0 mapped at address 0x4030d000.
length: 76800 offset: 77824
Buffer 1 mapped at address 0x40330000.
length: 76800 offset: 155648
Buffer 2 mapped at address 0x4042d000.
length: 76800 offset: 233472
Buffer 3 mapped at address 0x40502000.
[ 4131.459930] omap3isp omap3isp: CCDC won't become idle!

[..]

^C[ 4134.919464] omap3isp omap3isp: CCDC won't become idle!
[ 4135.926116] omap3isp omap3isp: Unable to stop OMAP3 ISP CCDC

Do I need some extra ISP patches? Media-ctl -p output is listed below.

regards,

Koen


root@beagleboardxMC:~# media-ctl -p
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
	pad1: Output [YUYV 4082x4088]
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
	pad0: Input [YUYV 4095x4095 (4,6)/4086x4082]
		<- 'OMAP3 ISP CCDC':pad1 []
		<- 'OMAP3 ISP preview':pad1 []
		<- 'OMAP3 ISP resizer input':pad0 []
	pad1: Output [YUYV 4096x4095]
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


root@beagleboardxMC:~# 


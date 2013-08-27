Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58105 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3H0JvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Aug 2013 05:51:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1VEFvV-0007hJ-Tu
	for linux-media@vger.kernel.org; Tue, 27 Aug 2013 11:51:05 +0200
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 11:51:05 +0200
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Aug 2013 11:51:05 +0200
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: yavta tool -> Unable to start streaming: Invalid argument (22).
Date: Tue, 27 Aug 2013 09:50:46 +0000 (UTC)
Message-ID: <loom.20130827T114744-43@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I tried to capture an image from my ov3640 camera sensor with the media-ctl
and the yavta tool. But I got "UNable to start streaming:Invalid argument(22)."

Does anyone know what I did wrong?

What I did:

root@overo2:~/media_test/bin# sudo ./media-ctl -p -r -l '"ov3640
3-003c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC
output":0[1]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Media controller API version 0.0.0

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
		[fmt:SGRBG10/4096x4096]
		<- "OMAP3 ISP CCP2 input":0 []
	pad1: Source
		[fmt:SGRBG10/4096x4096]
		-> "OMAP3 ISP CCDC":0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
	pad0: Source
		-> "OMAP3 ISP CCP2":0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
	pad0: Sink
		[fmt:SGRBG10/4096x4096]
	pad1: Source
		[fmt:SGRBG10/4096x4096]
		-> "OMAP3 ISP CSI2a output":0 []
		-> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
	pad0: Sink
		<- "OMAP3 ISP CSI2a":1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
	pad0: Sink
		[fmt:SGRBG10/4096x4096]
		<- "OMAP3 ISP CCP2":1 []
		<- "OMAP3 ISP CSI2a":1 []
		<- "ov3640 3-003c":0 []
	pad1: Source
		[fmt:SGRBG10/4096x4096
		 crop.bounds:(0,0)/4096x4096
		 crop:(0,0)/4096x4096]
		-> "OMAP3 ISP CCDC output":0 []
		-> "OMAP3 ISP resizer":0 []
	pad2: Source
		[fmt:SGRBG10/4096x4095]
		-> "OMAP3 ISP preview":0 []
		-> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video2
	pad0: Sink
		<- "OMAP3 ISP CCDC":1 []

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
	pad0: Sink
		[fmt:SGRBG10/4096x4096
		 crop.bounds:(8,4)/4082x4088
		 crop:(8,4)/4082x4088]
		<- "OMAP3 ISP CCDC":2 []
		<- "OMAP3 ISP preview input":0 []
	pad1: Source
		[fmt:YUYV/4082x4088]
		-> "OMAP3 ISP preview output":0 []
		-> "OMAP3 ISP resizer":0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video3
	pad0: Source
		-> "OMAP3 ISP preview":0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
	pad0: Sink
		<- "OMAP3 ISP preview":1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
	pad0: Sink
		[fmt:YUYV/4095x4095
		 crop.bounds:(4,6)/4086x4082
		 crop:(4,6)/4086x4082]
		<- "OMAP3 ISP CCDC":1 []
		<- "OMAP3 ISP preview":1 []
		<- "OMAP3 ISP resizer input":0 []
	pad1: Source
		[fmt:YUYV/4096x4095]
		-> "OMAP3 ISP resizer output":0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Source
		-> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "OMAP3 ISP resizer":1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 16: ov3640 3-003c (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev8
	pad0: Source
		[fmt:YUYV2X8/2048x1536
		 crop:(12,18)/2048x1536]
		-> "OMAP3 ISP CCDC":0 []


Resetting all links to inactive
Setting up link 16:0 -> 5:0 [1]
Setting up link 5:1 -> 6:0 [1]
root@overo2:~/media_test/bin# sudo ./media-ctl -p -V '"ov3640 3-003c":0
[SBGGR10 2048x1536 (32,20)/2048x1536], "OMAP3 ISP CCDC":1 [SBGGR10 2048x1536]'
Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Media controller API version 0.0.0

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
		[fmt:SGRBG10/4096x4096]
		<- "OMAP3 ISP CCP2 input":0 []
	pad1: Source
		[fmt:SGRBG10/4096x4096]
		-> "OMAP3 ISP CCDC":0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video0
	pad0: Source
		-> "OMAP3 ISP CCP2":0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev1
	pad0: Sink
		[fmt:SGRBG10/4096x4096]
	pad1: Source
		[fmt:SGRBG10/4096x4096]
		-> "OMAP3 ISP CSI2a output":0 []
		-> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video1
	pad0: Sink
		<- "OMAP3 ISP CSI2a":1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev2
	pad0: Sink
		[fmt:SGRBG10/4096x4096]
		<- "OMAP3 ISP CCP2":1 []
		<- "OMAP3 ISP CSI2a":1 []
		<- "ov3640 3-003c":0 [ENABLED]
	pad1: Source
		[fmt:SGRBG10/4096x4096
		 crop.bounds:(0,0)/4096x4096
		 crop:(0,0)/4096x4096]
		-> "OMAP3 ISP CCDC output":0 [ENABLED]
		-> "OMAP3 ISP resizer":0 []
	pad2: Source
		[fmt:SGRBG10/4096x4095]
		-> "OMAP3 ISP preview":0 []
		-> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video2
	pad0: Sink
		<- "OMAP3 ISP CCDC":1 [ENABLED]

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
	pad0: Sink
		[fmt:SGRBG10/4096x4096
		 crop.bounds:(8,4)/4082x4088
		 crop:(8,4)/4082x4088]
		<- "OMAP3 ISP CCDC":2 []
		<- "OMAP3 ISP preview input":0 []
	pad1: Source
		[fmt:YUYV/4082x4088]
		-> "OMAP3 ISP preview output":0 []
		-> "OMAP3 ISP resizer":0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video3
	pad0: Source
		-> "OMAP3 ISP preview":0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L flags 0
            device node name /dev/video4
	pad0: Sink
		<- "OMAP3 ISP preview":1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
	pad0: Sink
		[fmt:YUYV/4095x4095
		 crop.bounds:(4,6)/4086x4082
		 crop:(4,6)/4086x4082]
		<- "OMAP3 ISP CCDC":1 []
		<- "OMAP3 ISP preview":1 []
		<- "OMAP3 ISP resizer input":0 []
	pad1: Source
		[fmt:YUYV/4096x4095]
		-> "OMAP3 ISP resizer output":0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Source
		-> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "OMAP3 ISP resizer":1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev6
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev7
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 16: ov3640 3-003c (1 pad, 1 link)
             type V4L2 subdev subtype Sensor flags 0
             device node name /dev/v4l-subdev8
	pad0: Source
		[fmt:YUYV2X8/2048x1536
		 crop:(12,18)/2048x1536]
		-> "OMAP3 ISP CCDC":0 [ENABLED]


Setting up selection target 0 rectangle (32,20)/2048x1536 on pad ov3640 3-003c/0
Selection rectangle set: (32,20)/2040x1536
Setting up format SBGGR10 2048x1536 on pad ov3640 3-003c/0
Format set: SBGGR10 2040x1536
Setting up format SBGGR10 2040x1536 on pad OMAP3 ISP CCDC/0
Format set: SBGGR10 2040x1536
Setting up format SBGGR10 2048x1536 on pad OMAP3 ISP CCDC/1
Format set: SBGGR10 2032x1536
root@overo2:~/media_test/bin# cd
root@overo2:~# cd yavta-HEAD-d9b7cfc/
root@overo2:~/yavta-HEAD-d9b7cfc# sudo ./yavta -f SBGGR10 -s 2048x1536
--capture=1 --file=/home/root/image  /dev/video2
Device /dev/video2 opened.
Device `OMAP3 ISP CCDC output' on `media' is a video capture device.
Video format set: SBGGR10 (30314742) 2048x1536 (stride 4096) buffer size 6291456
Video format: SBGGR10 (30314742) 2048x1536 (stride 4096) buffer size 6291456
8 buffers requested.
length: 6291456 offset: 0 timestamp type: unknown
Buffer 0 mapped at address 0xb681f000.
length: 6291456 offset: 6291456 timestamp type: unknown
Buffer 1 mapped at address 0xb621f000.
length: 6291456 offset: 12582912 timestamp type: unknown
Buffer 2 mapped at address 0xb5c1f000.
length: 6291456 offset: 18874368 timestamp type: unknown
Buffer 3 mapped at address 0xb561f000.
length: 6291456 offset: 25165824 timestamp type: unknown
Buffer 4 mapped at address 0xb501f000.
length: 6291456 offset: 31457280 timestamp type: unknown
Buffer 5 mapped at address 0xb4a1f000.
length: 6291456 offset: 37748736 timestamp type: unknown
Buffer 6 mapped at address 0xb441f000.
length: 6291456 offset: 44040192 timestamp type: unknown
Buffer 7 mapped at address 0xb3e1f000.
Unable to start streaming: Invalid argument (22).
8 buffers released.

Best Regards, Tom


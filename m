Return-path: <linux-media-owner@vger.kernel.org>
Received: from az25egs04.gdc4s.com ([63.226.32.83]:45890 "EHLO
	AZ25EGS04.gdc4s.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3HBUWM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 16:22:12 -0400
Received: from az25exf04.gddsi.com (az25exf04.gddsi.com [10.240.16.50])
	by az25egi02.gddsi.com (8.13.8/8.13.8) with ESMTP id r72KCiLX014744
	for <linux-media@vger.kernel.org>; Fri, 2 Aug 2013 13:12:44 -0700
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Help with omap3isp resizing from CCDC
Date: Fri, 2 Aug 2013 13:12:24 -0700
Message-ID: <CC189802FB3BE84AB783196665ED67810190F67F@AZ25EXM05.gddsi.com>
In-Reply-To: <20130802181203.76D4635E0045@alastor.dyndns.org>
References: <20130802181203.76D4635E0045@alastor.dyndns.org>
From: <Samuel.Rasmussen@gdc4s.com>
To: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been having problems getting the resizer to take its input from the
CCDC.  From the linux-media mail-archive, it looks like Paul Chiha ran
into a similar problem in Oct 2011 with his message "Help with omap3isp
resizing".  Paul had a patch at the end of the discussion, but even his
patch hasn't fixed my problem yet.  I might have made a mistake porting
the patch since I'm on a newer kernel, or perhaps it doesn't work with
my TVP5151 decoder.

My setup: DM 3730 board, 3.5 kernel, and TVP5151 decoder.

The video looks great with a 640x480 resolution, and the CCDC is
de-interlacing the video.  However, for my needs the video must be
resized to 320x240 or 160x120.  The video, coming from the resizer, is
split into a top and bottom half.  Both halves are identical where
everything in the video is too wide and too short.  The CCDC must not be
de-interlacing the video going to the resizer.  I tried setting up the
pipeline to send the CCDC to the resizer, but something must have gone
wrong.

Up until this point, I was using the UYVY2X8 format.  Then I saw the
discussion Paul Chiha created.  In that discussion Laurent said:

>But the original poster wants to use the sensor -> ccdc -> resizer ->
resizer 
>output pipeline.

>> Also several sensor drivers that i have checked, usually define its
>> output as 2X8 output. I think is more natural to add 2X8 support to
>> CCDC and Resizer engines instead to modifying exiting drivers.

>Sure, sensor drivers should not be modified. What I was talking about
was to 
>configure the pipeline as

>sensor:0 [YUYV8_2X8], CCDC:0 [YUYV8_2X8], CCDC:1 [YUYV8_1X16],
resizer:0 [YUYV8_1X16]

I wasn't sure if Laurent's advice would also apply to the TVP5151, but I
wanted to test it out.  I implemented Paul's patch so I could use the
YUYV8_2X8 and YUYV8_1X16 formats.  The 640x480 resolution looked good in
the YUYV8_2X8 format.  However, once again the video from the resizer
was not de-interlaced so it had a top and bottom half (using YUYV8_2X8
and YUYV8_1X16).  This time it was even worse because the video from the
resizer was very green.

Does anyone have suggestions for resizing video from the TVP5151?

Thanks for taking the time to read this,
Samuel

I'm adding some media-ctl details below.
media-ctl commands I'm using:

media-ctl -v -l '"tvp5150 3-005c":0->"OMAP3 ISP CCDC":0[1]'
media-ctl -v -l '"OMAP3 ISP CCDC":1->"OMAP3 ISP resizer":0[1]'
media-ctl -v -l '"OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
media-ctl -v -f '"tvp5150 3-005c":0 [YUYV2X8 640x480]'
media-ctl -v -f '"OMAP3 ISP CCDC":0 [YUYV2X8 640x480]'
media-ctl -v -f '"OMAP3 ISP CCDC":1 [YUYV 640x480]'
media-ctl -v -f '"OMAP3 ISP resizer":1 [YUYV 320x240]'
LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so mplayer tv:// -tv
driver=v4l2:device=/dev/video6

Output of medi-ctl -p:

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
		[fmt:YUYV2X8/640x480]
		<- "OMAP3 ISP CCP2":1 []
		<- "OMAP3 ISP CSI2a":1 []
		<- "tvp5150 3-005c":0 [ENABLED]
	pad1: Source
		[fmt:YUYV/640x480
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480]
		-> "OMAP3 ISP CCDC output":0 []
		-> "OMAP3 ISP resizer":0 [ENABLED]
	pad2: Source
		[fmt:unknown/640x479]
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
		[fmt:YUYV/640x480
		 crop.bounds:(0,0)/640x480
		 crop:(0,0)/640x480]
		<- "OMAP3 ISP CCDC":1 [ENABLED]
		<- "OMAP3 ISP preview":1 []
		<- "OMAP3 ISP resizer input":0 []
	pad1: Source
		[fmt:YUYV/320x240]
		-> "OMAP3 ISP resizer output":0 [ENABLED]

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Source
		-> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "OMAP3 ISP resizer":1 [ENABLED]

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

- entity 16: tvp5150 3-005c (1 pad, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev8
	pad0: Source
		[fmt:YUYV2X8/640x480]
		-> "OMAP3 ISP CCDC":0 [ENABLED]

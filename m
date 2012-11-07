Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:56341 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab2KGLWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Nov 2012 06:22:17 -0500
Message-ID: <509A4473.3080506@gmx.net>
Date: Wed, 07 Nov 2012 12:22:27 +0100
From: Andreas Nagel <andreasnagel@gmx.net>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: OMAP3 ISP: VIDIOC_STREAMON and VIDIOC_QBUF calls fail
References: <5097DF9F.6080603@gmx.net> <20121106215153.GE25623@valkosipuli.retiisi.org.uk>
In-Reply-To: <20121106215153.GE25623@valkosipuli.retiisi.org.uk>
Content-Type: multipart/mixed;
 boundary="------------040602080308000605060306"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040602080308000605060306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sakari,

thanks for helping.

> My code sets up the ISP pipeline, configures the format on all the
> subdevices pads and the actual video device. Works fine so far.
> Then I passed user pointers (aquired with malloc) to the device
> driver for the capture buffers. Before issuing VIDIOC_STREAMON, I
> enqueue my buffers with VIDIOC_QBUF, which fails with errno = EIO. I
> don't know, why this is happening or where to got from here.
>> One possibility could be that mapping the buffer to ISP MMU fails for 
>> a reason or another. Do you set the length field in the buffer? 

Yes, the length was set when using userptr.

>>
>> And am I missing something else?
> The formats on the pads at different ends of the links in the pipeline must
> match. In most cases, they have to be exactly the same.
>
> Have you used the media-ctl test program here?
>
> <URL:http://git.ideasonboard.org/media-ctl.git>
>
> media-ctl -p gives you (and us) lots of information that helps figuring out
> what could go wrong here.

All pads do indeed have the same format.
I ran media-ctl, as you suggested. You can see the topology in the 
attached textfile.



Kind regards,
Andreas

--------------040602080308000605060306
Content-Type: text/plain; charset=UTF-8;
 name="topology.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="topology.txt"

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
hw revision     0x0
driver version  0.0.0

Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev0
	pad0: Sink
		<- "OMAP3 ISP CCP2 input":0 []
	pad1: Source
		-> "OMAP3 ISP CCDC":0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video0
	pad0: Source
		-> "OMAP3 ISP CCP2":0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev1
	pad0: Sink
	pad1: Source
		-> "OMAP3 ISP CSI2a output":0 []
		-> "OMAP3 ISP CCDC":0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video1
	pad0: Sink
		<- "OMAP3 ISP CSI2a":1 []

- entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev2
	pad0: Sink
		<- "OMAP3 ISP CCP2":1 []
		<- "OMAP3 ISP CSI2a":1 []
		<- "tvp514x 2-005d":0 []
	pad1: Source
		-> "OMAP3 ISP CCDC output":0 []
		-> "OMAP3 ISP resizer":0 []
	pad2: Source
		-> "OMAP3 ISP preview":0 []
		-> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
		-> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]

- entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video2
	pad0: Sink
		<- "OMAP3 ISP CCDC":1 []

- entity 7: OMAP3 ISP preview (2 pads, 4 links)
            type V4L2 subdev subtype Unknown
            device node name /dev/v4l-subdev3
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 []
		<- "OMAP3 ISP preview input":0 []
	pad1: Source
		-> "OMAP3 ISP preview output":0 []
		-> "OMAP3 ISP resizer":0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video3
	pad0: Source
		-> "OMAP3 ISP preview":0 []

- entity 9: OMAP3 ISP preview output (1 pad, 1 link)
            type Node subtype V4L
            device node name /dev/video4
	pad0: Sink
		<- "OMAP3 ISP preview":1 []

- entity 10: OMAP3 ISP resizer (2 pads, 4 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev4
	pad0: Sink
		<- "OMAP3 ISP CCDC":1 []
		<- "OMAP3 ISP preview":1 []
		<- "OMAP3 ISP resizer input":0 []
	pad1: Source
		-> "OMAP3 ISP resizer output":0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video5
	pad0: Source
		-> "OMAP3 ISP resizer":0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video6
	pad0: Sink
		<- "OMAP3 ISP resizer":1 []

- entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev5
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 14: OMAP3 ISP AF (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev6
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 15: OMAP3 ISP histogram (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev7
	pad0: Sink
		<- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]

- entity 17: tvp514x 2-005d (1 pad, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev8
	pad0: Source
		-> "OMAP3 ISP CCDC":0 []



--------------040602080308000605060306--

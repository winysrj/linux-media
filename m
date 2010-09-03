Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60785 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab0ICNe2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 09:34:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Epinat <laurent.epinat@cioinfoindus.fr>
Subject: Re: media entities and other stuff
Date: Fri, 3 Sep 2010 15:33:56 +0200
Cc: Aguirre@smtp01.msg.oleane.net, Sergio <saaguirre@ti.com>,
	linux-media@vger.kernel.org
References: <4C7FA634.6060407@cioinfoindus.fr>
In-Reply-To: <4C7FA634.6060407@cioinfoindus.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009031533.57752.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Laurent,

On Thursday 02 September 2010 15:27:16 Laurent Epinat wrote:
> 
> I'm a new on media and camera things.
> 
> I try to use the isp cam port on omap3550 with media framework

Where did you get the driver from ? The omap3camera tree is deprecated, you 
should use the devel branch from

http://meego.gitorious.org/maemo-multimedia/omap3isp-rx51

> we had a tvp5150 connected on isp port through the parallele interface on
> own custom board. I had ported the tvp5150 driver on media framework like
> im046 and 8et8ek8, and I'm quiet lost
> 
> questions:
> The node /dev/media0 is used only the parameters ?

If I understand you correctly, that's right. The media controller device node 
is only used to configure the device, not to stream video date.

> if yes do i need to configure and how to do it (the media-ctl is not easy
> to used)

There's a brand new media controller API that you can use in your application 
(documentation is available at

http://git.linuxtv.org/pinchartl/media.git?a=blob;f=Documentation/media-
framework.txt;hb=refs/heads/media-0002-media

> and the video frame comes from /dev/video2
> (I try to capture the frame comes from CCDC output) ?

If you're using the latest driver, the CCDC output is indeed /dev/video2.

You can get the device name associated with a given entity with the media-ctl 
utility:

# ./media-ctl -e "OMAP3 ISP CCDC output"
/dev/video2

> Il try (tvp5150 -> CCDC in, and try to read CCDC out I not sure about my
> thinking)
> 
>   ./media-ctl -l 16:0'->'5:0[1]
> 
> and the  entity 16 changed
> 
> - entity 16: tvp5150 3-005d (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
>          pad0: Output v4l2_subdev_open: Failed to open subdev device node

This error is weird. Please start by making sure you have the latest media-ctl 
and driver.

>                  -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]

That's correct, but you also need to activate the CCDC to CCDC output link.

# ./media-ctl -r -l '"tvp5150 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP 
CCDC":1->"OMAP3 ISP CCDC output":0[1]'

> if I'm right
> I can't understand how it works exactly and what appended on the different
> symptom
> 
> The format.pix strcture is empty after called VIDIOC_G_FORMAT ?

You need to set the format explicitly (with VIDIOC_S_FMT) on the video device 
node. The format needs to match the format configured on the CCDC output.

> If I force the size in the code it's ok for that ioctl but I can't swith the
> stream on,
> 
> Unable to start streaming: 32
> 
> 
> in the isp_video_validate_pipeline() the
> isp_video_remote_subdev() return null ptr
> 
> of cause, in media_entity_remote_pad(), it check
> MEDIA_LINK_FLAG_ACTIVE and in my case, is not active,
> 
> because, in func isp_register_entities()
> the flag is set to 0 on case ISP_INTERFACE_PARALLEL:

isp_video_remote_subdev() will return a non-NULL value when the two links I've 
mentioned above will be active. You will then need to setup the format on all 
pads in the pipeline.

> here my media topologie
> 
> Opening media device /dev/media0
> Enumerating entities
> Found 16 entities
> Enumerating pads and links
> Device topology
> - entity 1: OMAP3 ISP CCP2 (2 pads, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/subdev0
> 	pad0: Input [unknown 0x0]
> 	pad1: Output [unknown 0x0]
> 		-> 'OMAP3 ISP CCDC':pad0 []
> 
> - entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video0
> 	pad0: Output
> 		-> 'OMAP3 ISP CCP2':pad0 []
> 
> - entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 	pad1: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP CSI2a output':pad0 []
> 		-> 'OMAP3 ISP CCDC':pad0 []
> 
> - entity 4: OMAP3 ISP CSI2a output (1 pad, 0 link)
>              type Node subtype V4L
>              device node name /dev/video1
> 	pad0: Input
> 
> - entity 5: OMAP3 ISP CCDC (3 pads, 6 links)
>              type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node

This is the first problem you will need to fix. Without being able to open the 
CCDC subdev device node, you won't be able to configure the formats.

> 	pad1: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP CCDC output':pad0 []
> 		-> 'OMAP3 ISP resizer':pad0 []
> 	pad2: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP preview':pad0 []
> 		-> 'OMAP3 ISP AEWB':pad0 []
> 		-> 'OMAP3 ISP AF':pad0 []
> 		-> 'OMAP3 ISP histogram':pad0 []
> 
> - entity 6: OMAP3 ISP CCDC output (1 pad, 0 link)
>              type Node subtype V4L
>              device node name /dev/video2
> 	pad0: Input
> 
> - entity 7: OMAP3 ISP preview (2 pads, 2 links)
>              type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 	pad1: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP preview output':pad0 []
> 		-> 'OMAP3 ISP resizer':pad0 []
> 
> - entity 8: OMAP3 ISP preview input (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video3
> 	pad0: Output
> 		-> 'OMAP3 ISP preview':pad0 []
> 
> - entity 9: OMAP3 ISP preview output (1 pad, 0 link)
>              type Node subtype V4L
>              device node name /dev/video4
> 	pad0: Input
> 
> - entity 10: OMAP3 ISP resizer (2 pads, 1 link)
>               type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 	pad1: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP resizer output':pad0 []
> 
> - entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
>               type Node subtype V4L
>               device node name /dev/video5
> 	pad0: Output
> 		-> 'OMAP3 ISP resizer':pad0 []
> 
> - entity 12: OMAP3 ISP resizer output (1 pad, 0 link)
>               type Node subtype V4L
>               device node name /dev/video6
> 	pad0: Input
> 
> - entity 13: OMAP3 ISP AEWB (1 pad, 0 link)
>               type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 
> - entity 14: OMAP3 ISP AF (1 pad, 0 link)
>               type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 
> - entity 15: OMAP3 ISP histogram (1 pad, 0 link)
>               type V4L2 subdev subtype Unknown
> 	pad0: Input v4l2_subdev_open: Failed to open subdev device node
> 
> 
> - entity 16: tvp5150 3-005d (1 pad, 1 link)
>               type V4L2 subdev subtype Unknown
> 	pad0: Output v4l2_subdev_open: Failed to open subdev device node
> 
> 		-> 'OMAP3 ISP CCDC':pad0 []

-- 
Regards,

Laurent Pinchart

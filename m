Return-path: <mchehab@localhost>
Received: from smtp02.msg.oleane.net ([62.161.4.2]:60297 "EHLO
	smtp02.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab0IBPwn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Sep 2010 11:52:43 -0400
Message-ID: <4C7FC7F9.5080007@cioinfoindus.fr>
Date: Thu, 02 Sep 2010 17:51:21 +0200
From: Laurent Epinat <laurent.epinat@cioinfoindus.fr>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Aguirre Sergio <saaguirre@ti.com>
CC: linux-media@vger.kernel.org
Subject: media entities and other stuff (2)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@localhost>

Hello All

I'm a new on media and camera things.

I try to use the isp cam port on omap3550 with media framework

we had a tvp5150 connected on isp port through the parallele interface on own custom board.
I had ported the tvp5150 driver on media framework like im046 and 8et8ek8,
and I'm quiet lost

questions:
The node /dev/media0 is used only the parameters ?
if yes do i need to configure and how to do it (the media-ctl is not easy to used)

and the video frame comes from /dev/video2
(I try to capture the frame comes from CCDC output) ?


Il try (tvp5150 -> CCDC in, and try to read CCDC out I not sure about my thinking)

  ./media-ctl -l 16:0'->'5:0[1]

and the  entity 16 changed

- entity 16: tvp5150 3-005d (1 pad, 1 link)
              type V4L2 subdev subtype Unknown
         pad0: Output v4l2_subdev_open: Failed to open subdev device node

                 -> 'OMAP3 ISP CCDC':pad0 [ACTIVE]


if I'm right
I can't understand how it works exactly and what appended on the different symptom

The format.pix strcture is empty after called VIDIOC_G_FORMAT ?

If I force the size in the code it's ok for that ioctl
but I can't swith the stream on,

Unable to start streaming: 32


in the isp_video_validate_pipeline() the
isp_video_remote_subdev() return null ptr

of cause, in media_entity_remote_pad(), it check
MEDIA_LINK_FLAG_ACTIVE and in my case, is not active,

because, in func isp_register_entities()
the flag is set to 0 on case ISP_INTERFACE_PARALLEL:


I missed something !
I don't know what can you help me



here my media topologie

Opening media device /dev/media0
Enumerating entities
Found 16 entities
Enumerating pads and links
Device topology
- entity 1: OMAP3 ISP CCP2 (2 pads, 1 link)
             type V4L2 subdev subtype Unknown
             device node name /dev/subdev0
	pad0: Input [unknown 0x0]
	pad1: Output [unknown 0x0]
		-> 'OMAP3 ISP CCDC':pad0 []

- entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video0
	pad0: Output
		-> 'OMAP3 ISP CCP2':pad0 []

- entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
             type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node

	pad1: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP CSI2a output':pad0 []
		-> 'OMAP3 ISP CCDC':pad0 []

- entity 4: OMAP3 ISP CSI2a output (1 pad, 0 link)
             type Node subtype V4L
             device node name /dev/video1
	pad0: Input

- entity 5: OMAP3 ISP CCDC (3 pads, 6 links)
             type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node

	pad1: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP CCDC output':pad0 []
		-> 'OMAP3 ISP resizer':pad0 []
	pad2: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP preview':pad0 []
		-> 'OMAP3 ISP AEWB':pad0 []
		-> 'OMAP3 ISP AF':pad0 []
		-> 'OMAP3 ISP histogram':pad0 []

- entity 6: OMAP3 ISP CCDC output (1 pad, 0 link)
             type Node subtype V4L
             device node name /dev/video2
	pad0: Input

- entity 7: OMAP3 ISP preview (2 pads, 2 links)
             type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node

	pad1: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP preview output':pad0 []
		-> 'OMAP3 ISP resizer':pad0 []

- entity 8: OMAP3 ISP preview input (1 pad, 1 link)
             type Node subtype V4L
             device node name /dev/video3
	pad0: Output
		-> 'OMAP3 ISP preview':pad0 []

- entity 9: OMAP3 ISP preview output (1 pad, 0 link)
             type Node subtype V4L
             device node name /dev/video4
	pad0: Input

- entity 10: OMAP3 ISP resizer (2 pads, 1 link)
              type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node

	pad1: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP resizer output':pad0 []

- entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
              type Node subtype V4L
              device node name /dev/video5
	pad0: Output
		-> 'OMAP3 ISP resizer':pad0 []

- entity 12: OMAP3 ISP resizer output (1 pad, 0 link)
              type Node subtype V4L
              device node name /dev/video6
	pad0: Input

- entity 13: OMAP3 ISP AEWB (1 pad, 0 link)
              type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node


- entity 14: OMAP3 ISP AF (1 pad, 0 link)
              type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node


- entity 15: OMAP3 ISP histogram (1 pad, 0 link)
              type V4L2 subdev subtype Unknown
	pad0: Input v4l2_subdev_open: Failed to open subdev device node


- entity 16: tvp5150 3-005d (1 pad, 1 link)
              type V4L2 subdev subtype Unknown
	pad0: Output v4l2_subdev_open: Failed to open subdev device node

		-> 'OMAP3 ISP CCDC':pad0 []


regards


-- 

Salutations
Laurent Epinat -> mailto:laurent.epinat@cioinfoindus.fr

CIO Informatique
Le millenium
1, rue de Presse - BP 710
42950 Saint-Etienne Cedex 9

Tel    33 (0) 477 93 34 32
Tcopie 33 (0) 477 79 75 55
WWW : http://www.cioinfoindus.fr/

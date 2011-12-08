Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40256 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1LHV1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 16:27:45 -0500
Date: Thu, 8 Dec 2011 23:27:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Adam Pledger <a.pledger@thermoteknix.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: Omap3 ISP + Gstreamer v4l2src
Message-ID: <20111208212738.GA1967@valkosipuli.localdomain>
References: <4EDF1DA2.5000106@thermoteknix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDF1DA2.5000106@thermoteknix.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Wed, Dec 07, 2011 at 08:02:42AM +0000, Adam Pledger wrote:
> Hi Laurent,
> 
> Firstly, please accept my apologies, for what is very probably a
> naive question. I'm new to V4L2 and am just getting to grips with
> how things work.
> 
> I'm using a tvp5151 in bt656 mode with the Omap3 ISP, as described
> in this thread (Your YUV support tree + some patches for bt656,
> based on 2.6.39):
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/39539
> 
> I am able to capture some frames using yavta, using the media-ctl
> configuration as follows:
> media-ctl -v -r -l '"tvp5150 3-005d":0->"OMAP3 ISP CCDC":0[1],
> "OMAP3 ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -v --set-format '"tvp5150 3-005d":0 [UYVY2X8 720x625]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x625]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x625]'
> 
> This yields this:
> Opening media device /dev/media0
> Enumerating entities
> Found 16 entities
> Enumerating pads and links
> Media controller API version 0.0.0
> 
> Media device information
> ------------------------
> driver          omap3isp
> model           TI OMAP3 ISP
> serial
> bus info
> hw revision     0x0
> driver version  0.0.0
> 
> Device topology
> - entity 1: OMAP3 ISP CCP2 (2 pads, 2 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev0
>         pad0: Sink [SGRBG10 4096x4096]
> <- "OMAP3 ISP CCP2 input":0 []
>         pad1: Source [SGRBG10 4096x4096]
>                 -> "OMAP3 ISP CCDC":0 []
> 
> - entity 2: OMAP3 ISP CCP2 input (1 pad, 1 link)
>             type Node subtype V4L
>             device node name /dev/video0
>         pad0: Source
>                 -> "OMAP3 ISP CCP2":0 []
> 
> - entity 3: OMAP3 ISP CSI2a (2 pads, 2 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev1
>         pad0: Sink [SGRBG10 4096x4096]
>         pad1: Source [SGRBG10 4096x4096]
>                 -> "OMAP3 ISP CSI2a output":0 []
>                 -> "OMAP3 ISP CCDC":0 []
> 
> - entity 4: OMAP3 ISP CSI2a output (1 pad, 1 link)
>             type Node subtype V4L
>             device node name /dev/video1
>         pad0: Sink
> <- "OMAP3 ISP CSI2a":1 []
> 
> - entity 5: OMAP3 ISP CCDC (3 pads, 9 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev2
>         pad0: Sink [UYVY2X8 720x625]
> <- "OMAP3 ISP CCP2":1 []
> <- "OMAP3 ISP CSI2a":1 []
> <- "tvp5150 3-005d":0 [ENABLED]
>         pad1: Source [UYVY2X8 720x625]
>                 -> "OMAP3 ISP CCDC output":0 [ENABLED]
>                 -> "OMAP3 ISP resizer":0 []
>         pad2: Source [UYVY2X8 720x624]
>                 -> "OMAP3 ISP preview":0 []
>                 -> "OMAP3 ISP AEWB":0 [ENABLED,IMMUTABLE]
>                 -> "OMAP3 ISP AF":0 [ENABLED,IMMUTABLE]
>                 -> "OMAP3 ISP histogram":0 [ENABLED,IMMUTABLE]
> 
> - entity 6: OMAP3 ISP CCDC output (1 pad, 1 link)
>             type Node subtype V4L
>             device node name /dev/video2
>         pad0: Sink
> <- "OMAP3 ISP CCDC":1 [ENABLED]
> 
> - entity 7: OMAP3 ISP preview (2 pads, 4 links)
>             type V4L2 subdev subtype Unknown
>             device node name /dev/v4l-subdev3
>         pad0: Sink [SGRBG10 4096x4096 (8,4)/4082x4088]
> <- "OMAP3 ISP CCDC":2 []
> <- "OMAP3 ISP preview input":0 []
>         pad1: Source [YUYV 4082x4088]
>                 -> "OMAP3 ISP preview output":0 []
>                 -> "OMAP3 ISP resizer":0 []
> 
> - entity 8: OMAP3 ISP preview input (1 pad, 1 link)
>             type Node subtype V4L
>             device node name /dev/video3
>         pad0: Source
>                 -> "OMAP3 ISP preview":0 []
> 
> - entity 9: OMAP3 ISP preview output (1 pad, 1 link)
>             type Node subtype V4L
>             device node name /dev/video4
>         pad0: Sink
> <- "OMAP3 ISP preview":1 []
> 
> - entity 10: OMAP3 ISP resizer (2 pads, 4 links)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev4
>         pad0: Sink [YUYV 4095x4095 (0,6)/4094x4082]
> <- "OMAP3 ISP CCDC":1 []
> <- "OMAP3 ISP preview":1 []
> <- "OMAP3 ISP resizer input":0 []
>         pad1: Source [YUYV 3312x4095]
>                 -> "OMAP3 ISP resizer output":0 []
> 
> - entity 11: OMAP3 ISP resizer input (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video5
>         pad0: Source
>                 -> "OMAP3 ISP resizer":0 []
> 
> - entity 12: OMAP3 ISP resizer output (1 pad, 1 link)
>              type Node subtype V4L
>              device node name /dev/video6
>         pad0: Sink
> <- "OMAP3 ISP resizer":1 []
> 
> - entity 13: OMAP3 ISP AEWB (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev5
>         pad0: Sink
> <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 14: OMAP3 ISP AF (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev6
>         pad0: Sink
> <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 15: OMAP3 ISP histogram (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev7
>         pad0: Sink
> <- "OMAP3 ISP CCDC":2 [ENABLED,IMMUTABLE]
> 
> - entity 16: tvp5150 3-005d (1 pad, 1 link)
>              type V4L2 subdev subtype Unknown
>              device node name /dev/v4l-subdev8
>         pad0: Source [UYVY2X8 720x625]
>                 -> "OMAP3 ISP CCDC":0 [ENABLED]
> 
> The following works nicely:
> yavta -f UYVY -s 720x625 -n 4 --capture=4 -F /dev/video2
> 
> The problem comes when I try to use gstreamer to capture from
> /dev/video2, using the following:
> gst-launch v4l2src device="/dev/video2" !
> 'video/x-raw-yuv,width=720,height=625' ! filesink
> location=sample.yuv
> 
> This fails with:
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> Failed getting controls attributes on device '/dev/video2'.
> Additional debug info:
> v4l2_calls.c(267): gst_v4l2_fill_lists ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> Failed querying control 9963776 on device '/dev/video2'. (25 -
> Inappropriate ioctl for device)
> 
> My question is, should this "just work"? It was my understanding
> that once the pipeline was configured with media-ctl then the CCDC
> output pad should behave like a standard V4L2 device node.
> 
> I realise that this might be something borked with my build
> dependencies (although I'm pretty certain that v4l2src is being
> built against the latest libv42) or gstreamer. Before I start
> digging through the code to work out what is going on with the ioctl
> handling, I thought I would check to see whether this should work,
> or whether I am doing something fundamentally silly.

An alternative to what Laurent and Michael already suggested, is to use
subdevsrc (or subdevsrc2). Subdevsrc should be usable without camerabin, and
if you like camerabin2, then subdevsrc2 is the way to go.

It takes the pipeline configuration from a configuration file.

I'd _think_ this is the latest subdevsrc branch:

<URL:http://meego.gitorious.org/maemo-multimedia/gst-nokia-videosrc/commits/gen1-pr12>

Subdevsrc2 is in the master branch.

In either one, use the mcsrc; it's got no unpleasant dependencies.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk

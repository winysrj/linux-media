Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35454 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab1LGKeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 05:34:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adam Pledger <a.pledger@thermoteknix.com>
Subject: Re: Omap3 ISP + Gstreamer v4l2src
Date: Wed, 7 Dec 2011 11:34:24 +0100
Cc: linux-media@vger.kernel.org
References: <4EDF1DA2.5000106@thermoteknix.com>
In-Reply-To: <4EDF1DA2.5000106@thermoteknix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112071134.24567.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adam,

On Wednesday 07 December 2011 09:02:42 Adam Pledger wrote:
> Hi Laurent,
> 
> Firstly, please accept my apologies, for what is very probably a naive
> question. I'm new to V4L2 and am just getting to grips with how things
> work.

No worries.

> I'm using a tvp5151 in bt656 mode with the Omap3 ISP,

Please note that BT.656 support is still experimental, so issues are not 
unexpected.

> as described in this thread (Your YUV support tree + some patches for bt656,
> based on 2.6.39):
> http://comments.gmane.org/gmane.linux.drivers.video-input-
infrastructure/39539
> 
> I am able to capture some frames using yavta, using the media-ctl
> configuration as follows:
> media-ctl -v -r -l '"tvp5150 3-005d":0->"OMAP3 ISP CCDC":0[1], "OMAP3
> ISP CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -v --set-format '"tvp5150 3-005d":0 [UYVY2X8 720x625]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":0 [UYVY2X8 720x625]'
> media-ctl -v --set-format '"OMAP3 ISP CCDC":1 [UYVY2X8 720x625]'
> 
> This yields this:

[snip]

Looks good.

> The following works nicely:
> yavta -f UYVY -s 720x625 -n 4 --capture=4 -F /dev/video2
> 
> The problem comes when I try to use gstreamer to capture from
> /dev/video2, using the following:
> gst-launch v4l2src device="/dev/video2" !
> 'video/x-raw-yuv,width=720,height=625' ! filesink location=sample.yuv
> 
> This fails with:
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Failed
> getting controls attributes on device '/dev/video2'.
> Additional debug info:
> v4l2_calls.c(267): gst_v4l2_fill_lists ():
> /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> Failed querying control 9963776 on device '/dev/video2'. (25 -
> Inappropriate ioctl for device)
> 
> My question is, should this "just work"? It was my understanding that
> once the pipeline was configured with media-ctl then the CCDC output pad
> should behave like a standard V4L2 device node.

That's more or less correct. There have been a passionate debate regarding 
what a "standard V4L2 device node" is. Not all V4L2 ioctls are mandatory, and 
no driver implements them all. The OMAP3 ISP driver implements a very small 
subset of the V4L2 API, and it wasn't clear whether that still qualified as 
V4L2. After discussions we decided that the V4L2 specification will document 
profiles, with a set of required ioctls for each of them. The OMAP3 ISP 
implements the future video streaming profile.

I'm not sure what ioctls v4l2src consider as mandatory. The above error 
related to a CTRL ioctl (possibly VIDIOC_QUERYCTRL), which isn't implemented 
by the OMAP3 ISP driver and will likely never be. I don't think that should be 
considered as mandatory.

I think that v4l2src requires the VIDIOC_ENUMFMT ioctl, which isn't 
implemented in the OMAP3 ISP driver. That might change in the future, but I'm 
not sure yet whether it will. In any case, you might have to modify v4l2src 
and/or the OMAP3 ISP driver for now. Some patches have been posted a while ago 
to this mailing list.

> I realise that this might be something borked with my build dependencies
> (although I'm pretty certain that v4l2src is being built against the
> latest libv42) or gstreamer. Before I start digging through the code to
> work out what is going on with the ioctl handling, I thought I would
> check to see whether this should work, or whether I am doing something
> fundamentally silly.

-- 
Regards,

Laurent Pinchart

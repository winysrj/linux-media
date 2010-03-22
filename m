Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46892 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754659Ab0CVL7Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 07:59:16 -0400
Date: Mon, 22 Mar 2010 12:59:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	rsc@pengutronix.de
Subject: Re: PXA camera and Planar YUV422 16 bit camera
In-Reply-To: <20100316230645.GA26770@enneenne.com>
Message-ID: <Pine.LNX.4.64.1003221251470.4361@axis700.grange>
References: <20100316230645.GA26770@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rodolfo

On Wed, 17 Mar 2010, Rodolfo Giometti wrote:

> Hello,
> 
> I'm puzzled to know if the pxa_camera driver can manage a data depth
> different from 8 bits.
> 
> I'm currently trying to add a camera interface support to my PXA270
> based board with an adv7180 as soc camera device.
> 
> For the adv7180 I defined:
> 
> static const struct soc_camera_data_format adv7180_colour_formats[] =
> {
>         {
>                 .name           = "Planar YUV422 16 bit",
>                 .depth          = 16,
>                 .fourcc         = V4L2_PIX_FMT_YUV422P,
>                 .colorspace     = V4L2_COLORSPACE_JPEG,
>         }
> };

first, you're working with an outdated kernel, don't think I'll be able to 
help you with that.

> but this is rejected by the pxa_camera driver buswidth_supported().
> 
> On the other hands if I set .depth = 8 in above struct I get the
> following:

Please, update your kernel to the current state. YUV422P is not supported 
by pxa natively, so, it can only be handled in the pass-through mode. 
Further, adv7180 is currently unsuitable for soc-camera, you have to 
modify it after updating to the current kernel. Then please show us your 
patch for adv7180, then we'll try to help you further.

> debian:~# gst-launch v4l2src ! video/x-raw-yuv,width=320,height=240 !
> filesink location=/tmp/video.raw
> Setting pipeline to PAUSED ...
> Pipeline is live and does not need PREROLL ...
> WARNING: from element /pipeline0/v4l2src0: Could not get parameters on
> device '/dev/video0'
> Additional debug info:
> v4l2src_calls.c(1172): gst_v4l2src_set_capture ():
> /pipeline0/v4l2src0:
> system error: Invalid argument
> Setting pipeline to PLAYING ...
> New clock: GstSystemClock
> WARNING: from element /pipeline0/v4l2src0: Got unexpected frame size
> of 76800 instead of 153600.
> Additional debug info:
> gstv4l2src.c(1077): gst_v4l2src_get_mmap (): /pipeline0/v4l2src0
> WARNING: from element /pipeline0/v4l2src0: Got unexpected frame size
> of 76800 instead of 153600.
> 
> That is the pax_camera device returns 8bits per pixel instead of 16...
> 
> Can you please help me in finding what's wrong? :'(

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

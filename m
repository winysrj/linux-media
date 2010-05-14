Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44591 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754341Ab0ENUiv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 May 2010 16:38:51 -0400
Date: Fri, 14 May 2010 22:38:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Charles D. Krebs" <ckrebs@therealtimegroup.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: CEU / Camera Driver Question
In-Reply-To: <B2B4F50ED9304C17B658F868445AB5DE@RSI45>
Message-ID: <Pine.LNX.4.64.1005142218060.6147@axis700.grange>
References: <C5F5A45C8EB6446BA837800AC37D53A2@RSI45>
 <h2laec7e5c31004071719m4a6551c7w8afdca6bdcf49eae@mail.gmail.com>
 <Pine.LNX.4.64.1004080814370.4621@axis700.grange> <7554DA9455F6445CB94B84859EEDCE57@RSI45>
 <Pine.LNX.4.64.1004140827550.6386@axis700.grange> <F528C77ECD244EC8ADEEE5DEF504EB88@RSI45>
 <Pine.LNX.4.64.1005040811010.4925@axis700.grange> <B2B4F50ED9304C17B658F868445AB5DE@RSI45>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Charles

On Fri, 14 May 2010, Charles D. Krebs wrote:

> Guennadi,
> 
> > No, subdevice drivers, using the mediabus API, know nothing about fourcc
> > codes, that belongs to the user side of the pixel format handling API. The
> > path, e.g., for the VIDIOC_S_FMT ioctl() is
> > 
> > soc_camera.c::soc_camera_s_fmt_vid_cap(V4L2_PIX_FMT_GREY)
> > sh_mobile_ceu_camera.c::sh_mobile_ceu_set_fmt(V4L2_PIX_FMT_GREY)
> > 
> > the latter will try to call the .s_mbus_fmt() method from
> > soc_camera_platform.c and will fail, because that got lost during the
> > v4l2-subdev conversion, which is a bug and has to be fixed, patch welcome.
> > 
> 
> In trying to figure out how to best patch the lacking .s_mbus_fmt() option, I
> setup:
> 
> static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
> 	.s_stream	= soc_camera_platform_s_stream,
> 	.try_mbus_fmt	= soc_camera_platform_try_fmt,
> 	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
> 	.g_mbus_fmt     = soc_camera_platform_try_fmt,
> 	.s_mbus_fmt     = soc_camera_platform_try_fmt,
> 
> };
> 
> Is there any reason I can't reuse a slightly modified "try_fmt" function to do
> the set?
> 
> Here's what I currently have:
> 
> static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
> 				       struct v4l2_mbus_framefmt *mf)
> {
> 	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> 
> 	mf->width	= p->format.width;
> 	mf->height	= p->format.height;
> 	mf->code	= p->format.code;
> 	mf->colorspace	= p->format.colorspace;
> 	mf->field	                = p->format.field;
> 
> 	return 0;
> }

How is this different from this patch from Morimoto-san:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/19191

> > > But regardless of how I set this structure up, I don't see any direct
> > > support
> > > for a Grayscale mode data capture in the ceu driver.  For example,
> > > "sh_mobile_ceu_set_bus_param" does not contain V4L2_PIX_FMT_GREY in its
> > > list
> > > of fourcc formats.  Yet based on the 7724 hardware manual, and from the
> > > information I have received from Renesas, I'm not seeing any reason why
> > > this
> > > format should not be supported.
> > > 
> > > Is grayscale somehow supported under the current CEU driver?
> > 
> > Sure, that's what the pass-through mode with a standard soc-mbus format
> > conversion is for (see soc_mbus_get_fmtdesc()).
> 
> 
> After thoroughly reviewing the register documentation for the CEU, there are
> several changes I'm implementing.  This camera doesn't put out any color
> sampling, so the registers in the CEU must be configured to use "image data
> fetch" mode.
> 
> Where I'm currently struggling is in "sh_mobile_ceu_set_fmt" where the call is
> made to "soc_camera_xlate_by_fourcc(icd, pixfmt)".
> 
> I'm still trying to figure out where the data needs to be defined that
> eventually becomes "pixfmt".  Should this be setup as an additional parameter
> from inside "soc_camera_platform_try_fmt"?
> 
> What's the relationship between "v4l2_format" and "v4l2_mbus_framefmt"?

Have you set up platform data similar to "struct soc_camera_link 
camera_link" in arch/sh/boards/mach-ap325rxa/setup.c. The 
soc_camera_platform.c driver should be getting pixel format information 
from the static struct soc_camera_platform_info, doesn't this work for 
you?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

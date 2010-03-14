Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36438 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932291Ab0CNLID (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 07:08:03 -0400
Date: Sun, 14 Mar 2010 12:08:02 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] V4L: SuperH Video Output Unit (VOU) driver
In-Reply-To: <201003141123.11963.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1003141143250.4425@axis700.grange>
References: <Pine.LNX.4.64.1003111121380.4385@axis700.grange>
 <201003141123.11963.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Sun, 14 Mar 2010, Hans Verkuil wrote:

> Hi Guennadi,
> 
> Here is a quick review. It looks good, just a few small points.

Thanks for the review! To most points - right, will update. The ones, that 
I have more questions about:

> On Thursday 11 March 2010 11:24:42 Guennadi Liakhovetski wrote:
> > A number of SuperH SoCs, including sh7724, include a Video Output Unit. This
> > patch adds a video (V4L2) output driver for it. The driver uses v4l2-subdev and
> > mediabus APIs to interface to TV encoders.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Tested on ms7724se
> > 
> >  drivers/media/video/Kconfig  |    7 +
> >  drivers/media/video/Makefile |    2 +
> >  drivers/media/video/sh_vou.c | 1437 ++++++++++++++++++++++++++++++++++++++++++
> >  include/media/sh_vou.h       |   35 +
> >  4 files changed, 1481 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/video/sh_vou.c
> >  create mode 100644 include/media/sh_vou.h
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 64682bf..be6d016 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig

[snip]

> > +static int sh_vou_g_fmt_vid_ovrl(struct file *file, void *priv,
> > +				 struct v4l2_format *fmt)
> > +{
> > +	/* This is needed for gstreamer, even if not used... */
> > +	return 0;
> > +}
> 
> Shouldn't this return -EINVAL if there is no overlay support?

In fact I would just drop this methos altogether, but gstreamer needs it 
_and_ it shouldn't return an error. In fact, I think, we can persuade 
gstreamer guys to drop this restriction, if we really think this is 
irrelevant. For some reason their v4l2sink is somewhat overlay-centric, 
but I think we can discuss this with them.

> > +enum sh_vou_bus_fmt {
> > +	SH_VOU_BUS_NTSC_16BIT = 0,
> > +	SH_VOU_BUS_NTSC_8BIT = 1,
> > +	SH_VOU_BUS_NTSC_8BIT_REC656 = 3,
> > +	SH_VOU_BUS_PAL_8BIT = 5,
> 
> Rather than NTSC and PAL it might be better to talk about 50 vs 60 Hz.

Don't know, this is how these modes are called in the datasheet, so... Do 
you think it's better to call them "correctly" or as in the datasheet?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

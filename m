Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:62351 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1F1GrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 02:47:08 -0400
Date: Tue, 28 Jun 2011 08:47:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] V4L: add media bus configuration subdev operations
In-Reply-To: <201106241257.19372.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1106241302280.6014@axis700.grange>
References: <Pine.LNX.4.64.1106232340360.5348@axis700.grange>
 <201106241257.19372.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Jun 2011, Hans Verkuil wrote:

> On Thursday, June 23, 2011 23:53:11 Guennadi Liakhovetski wrote:
> > Add media bus configuration types and two subdev operations to get
> > supported mediabus configurations and to set a specific configuration.
> > Subdevs can support several configurations, e.g., they can send video data
> > on 1 or several lanes, can be configured to use a specific CSI-2 channel,
> > in such cases subdevice drivers return bitmasks with all respective bits
> > set. When a set-configuration operation is called, it has to specify a
> > non-ambiguous configuration.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > v3: addressed comments by Hans - thanks!
> > 
> > 1. moved too big inline function into a new .c file
> > 
> > 2. changed flags types to int, local variables to bool, added "const"
> > 
> > 3. accepting BT.656 now too
> > 
> > v2:
> > 
> > 1. Removed parallel bus width flags. As Laurent correctly pointed out, bus 
> > width can be configured based on the mediabus format.
> > 
> > 2. Removed the clock parameter for now. Passing timing information between 
> > the subdevices and the host / bridge driver is indeed necessary, but it is 
> > not yet quite clear, what is the best way to do this. This requires more 
> > thinking and can be added as an extra field to struct v4l2_mbus_config 
> > later. The argument, that "struct clk" is still platform specific is 
> > correct, but I am too tempted by the possibilities, the clkdev offers us 
> > to give up this idea immediatrely. Maybe drivers, that need such a clock, 
> > could use a platform callback to create a clock instance for them, or get 
> > a clock object from the platform with platform data. However, there are 
> > also opinions, that the clkdev API is completely unsuitable for this 
> > purpose. I'd commit this without any timing first, and consider 
> > possibilities as a second step.
> > 
> >  drivers/media/video/Makefile        |    2 +-
> >  drivers/media/video/v4l2-mediabus.c |   45 ++++++++++++++++++++++++++
> >  include/media/v4l2-mediabus.h       |   59 +++++++++++++++++++++++++++++++++++
> >  include/media/v4l2-subdev.h         |    8 +++++
> >  4 files changed, 113 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/media/video/v4l2-mediabus.c
> > 
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index d9833f4..7adb683 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
> >  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
> >  
> >  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> > -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> > +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-mediabus.o
> >  
> >  # V4L2 core modules
> >  
> > diff --git a/drivers/media/video/v4l2-mediabus.c b/drivers/media/video/v4l2-mediabus.c
> > new file mode 100644
> > index 0000000..c181e02
> > --- /dev/null
> > +++ b/drivers/media/video/v4l2-mediabus.c
> > @@ -0,0 +1,45 @@
> > +/*
> > + * V4L2 mediabus
> > + *
> > + * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <media/v4l2-mediabus.h>
> > +
> > +unsigned int v4l2_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
> > +					 unsigned int flags)
> > +{
> > +	unsigned long common_flags;
> 
> unsigned int
> 
> > +	bool hsync = true, vsync = true, pclk, data, mode;
> > +	bool mipi_lanes, mipi_clock;
> > +
> > +	common_flags = cfg->flags & flags;
> > +
> > +	switch (cfg->type) {
> > +	case V4L2_MBUS_PARALLEL:
> > +		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> > +					V4L2_MBUS_HSYNC_ACTIVE_LOW);
> > +		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
> > +					V4L2_MBUS_VSYNC_ACTIVE_LOW);
> 
> Add a '/* fall through */' comment here.
> 
> > +	case V4L2_MBUS_BT656:
> > +		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
> > +				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
> > +		data = common_flags & (V4L2_MBUS_DATA_ACTIVE_HIGH |
> > +				       V4L2_MBUS_DATA_ACTIVE_LOW);
> > +		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
> > +		return (!hsync || !vsync || !pclk || !data || !mode) ?
> > +			0 : common_flags;
> > +	case V4L2_MBUS_CSI2:
> > +		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
> > +		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
> > +					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
> > +		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
> > +	}
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_mbus_config_compatible);
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > index 971c7fa..5fb5022 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -13,6 +13,65 @@
> >  
> >  #include <linux/v4l2-mediabus.h>
> >  
> > +/* Parallel flags */
> > +/* Can the client run in master or in slave mode */
> > +#define V4L2_MBUS_MASTER			(1 << 0)
> > +#define V4L2_MBUS_SLAVE				(1 << 1)
> 
> Needs some explanation as to what master and slave mean here.
> 
> > +/* Which signal polarities it supports */
> > +#define V4L2_MBUS_HSYNC_ACTIVE_HIGH		(1 << 2)
> > +#define V4L2_MBUS_HSYNC_ACTIVE_LOW		(1 << 3)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_HIGH		(1 << 4)
> > +#define V4L2_MBUS_VSYNC_ACTIVE_LOW		(1 << 5)
> 
> Add a comment that these HSYNC/VSYNC bits are ignored for BT656.
> 
> > +#define V4L2_MBUS_PCLK_SAMPLE_RISING		(1 << 6)
> > +#define V4L2_MBUS_PCLK_SAMPLE_FALLING		(1 << 7)
> > +#define V4L2_MBUS_DATA_ACTIVE_HIGH		(1 << 8)
> > +#define V4L2_MBUS_DATA_ACTIVE_LOW		(1 << 9)
> > +
> > +/* Serial flags */
> > +/* How many lanes the client can use */
> > +#define V4L2_MBUS_CSI2_1_LANE			(1 << 0)
> > +#define V4L2_MBUS_CSI2_2_LANE			(1 << 1)
> > +#define V4L2_MBUS_CSI2_3_LANE			(1 << 2)
> > +#define V4L2_MBUS_CSI2_4_LANE			(1 << 3)
> > +/* On which channels it can send video data */
> > +#define V4L2_MBUS_CSI2_CHANNEL_0		(1 << 4)
> > +#define V4L2_MBUS_CSI2_CHANNEL_1		(1 << 5)
> > +#define V4L2_MBUS_CSI2_CHANNEL_2		(1 << 6)
> > +#define V4L2_MBUS_CSI2_CHANNEL_3		(1 << 7)
> > +/* Does it support only continuous or also non-continuous clock mode */
> > +#define V4L2_MBUS_CSI2_CONTINUOUS_CLOCK		(1 << 8)
> > +#define V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK	(1 << 9)
> > +
> > +#define V4L2_MBUS_CSI2_LANES		(V4L2_MBUS_CSI2_1_LANE | V4L2_MBUS_CSI2_2_LANE | \
> > +					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
> > +#define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
> > +					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
> > +
> > +/**
> > + * v4l2_mbus_type - media bus type
> > + * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
> > + * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation
> 
> Add a comment that this is also valid for BT1120 (basically that's BT656 but
> updated for HDTV).
> 
> > + * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
> > + */
> > +enum v4l2_mbus_type {
> > +	V4L2_MBUS_PARALLEL,
> > +	V4L2_MBUS_BT656,
> > +	V4L2_MBUS_CSI2,
> > +};
> > +
> > +/**
> > + * v4l2_mbus_config - media bus configuration
> > + * @type:	in: interface type
> > + * @flags:	in / out: configuration flags, depending on @type
> > + */
> > +struct v4l2_mbus_config {
> > +	enum v4l2_mbus_type type;
> > +	unsigned int flags;
> > +};
> > +
> > +unsigned int v4l2_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
> > +					 unsigned int flags);
> > +
> >  static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
> >  				const struct v4l2_mbus_framefmt *mbus_fmt)
> >  {
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1562c4f..aa17713 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -255,6 +255,10 @@ struct v4l2_subdev_audio_ops {
> >     try_mbus_fmt: try to set a pixel format on a video data source
> >  
> >     s_mbus_fmt: set a pixel format on a video data source
> > +
> > +   g_mbus_config: get supported mediabus configurations
> > +
> > +   s_mbus_config: set a certain mediabus configuration
> >   */
> >  struct v4l2_subdev_video_ops {
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> > @@ -294,6 +298,10 @@ struct v4l2_subdev_video_ops {
> >  			    struct v4l2_mbus_framefmt *fmt);
> >  	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> >  			  struct v4l2_mbus_framefmt *fmt);
> > +	int (*g_mbus_config)(struct v4l2_subdev *sd,
> > +			     struct v4l2_mbus_config *cfg);
> > +	int (*s_mbus_config)(struct v4l2_subdev *sd,
> > +			     const struct v4l2_mbus_config *cfg);
> >  };
> >  
> >  /*
> > 
> 
> I am, like Laurent and Sakari, unhappy with s_mbus_config. As they say, this
> should be passed through platform data.
> 
> I also understand that you want to standardize this part of soc-camera.
> 
> What about this: when we convert the soc-camera sensors to this API, then it
> is a requirement that they also support setting the bus config through
> platform_data.

Of course, that is the plan. soc-camera hosts should be able to use 
generic sensor drivers - possibly without those operations, and soc-camera 
originated sensor drivers should be usable outside of soc-camera, in which 
case they shall take their configuration from the platform data.

> That shouldn't be hard. And the ops above should be marked in the
> comments as for soc-camera backwards compatibility only. I.e. OK to use for
> current soc-camera users, but not for new products.
> 
> This at least gives us a transition path, as I really hope that exising soc-camera
> platform files are converted to use the platform_data method.

But the present APIs are still ok to use also for new drivers and 
platforms until a standard way to represent such configuration in platform 
data appears in the mainline, right?

Other comments are no problem, of course.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

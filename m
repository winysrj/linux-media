Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60322 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754630AbZLDIfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 03:35:48 -0500
Date: Fri, 4 Dec 2009 09:35:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/2 v4] v4l: add a media-bus API for configuring v4l2
 subdev pixel and frame formats
In-Reply-To: <200912040946.24152.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0912040816390.3981@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
 <200912022257.33941.hverkuil@xs4all.nl> <Pine.LNX.4.64.0912031036510.4328@axis700.grange>
 <200912040946.24152.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 4 Dec 2009, Hans Verkuil wrote:

> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > new file mode 100644
> > index 0000000..5cf2a6d
> > --- /dev/null
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -0,0 +1,61 @@
> > +/*
> > + * Media Bus API header
> > + *
> > + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#ifndef V4L2_MEDIABUS_H
> > +#define V4L2_MEDIABUS_H
> > +
> > +/*
> > + * These pixel codes uniquely identify data formats on the media bus. Mostly
> > + * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
> > + * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
> > + * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> > + * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> > + * transferred over the bus: "LE" means that the least significant bits are
> > + * transferred first, "BE" means that the most significant bits are transferred
> > + * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> > + * incomplete high byte, are filled with padding bits.
> > + */
> > +enum v4l2_mbus_pixelcode {
> > +	V4L2_MBUS_FMT_FIXED = 1,
> > +	V4L2_MBUS_FMT_YUYV8_2X8,
> > +	V4L2_MBUS_FMT_YVYU8_2X8,
> > +	V4L2_MBUS_FMT_UYVY8_2X8,
> > +	V4L2_MBUS_FMT_VYUY8_2X8,
> 
> Darn, I was so hoping that I could sign off on it, but this makes no sense
> now.
> 
> Either it is:
> 
> 	V4L2_MBUS_FMT_YUYV8_1X8,
> 	V4L2_MBUS_FMT_YVYU8_1X8,
> 	V4L2_MBUS_FMT_UYVY8_1X8,
> 	V4L2_MBUS_FMT_VYUY8_1X8
> 
> where the 'YUYV' code tells you the order of the Y, U and V samples over the
> bus, or it is:
> 
> 	V4L2_MBUS_FMT_YUYV8_2X8_BE,
> 	V4L2_MBUS_FMT_YUYV8_2X8_LE,
> 	V4L2_MBUS_FMT_YVYU8_2X8_BE,
> 	V4L2_MBUS_FMT_YVYU8_2X8_LE,
> 
> Where the BE or LE suffix tells you the order in which the YU/YV pairs are
> arriving.

No. In nXk n is the number of k-bit wide _electrical_ samples of the bus 
to get (an equivalent of) one _pixel_. So, for 16-bit formats on 8-bit bus 
it's _definitely_ 2X8.

And no, BE and LE is the order of _samples_ within one _pixel_, not the 
order of pixels within one megapixel ("YU/YV pairs are arriving"), but 
that's also what you meant above, judging by the names.

So, I'll go with the 2X8_[LB]E variant, where

YUYV8_2X8_LE == YUYV with LE packing
YUYV8_2X8_BE == UYVY with LE packing
YVYU8_2X8_LE == YVYU with LE packing
YVYU8_2X8_BE == VYUY with LE packing

> Personally I prefer the first (1X8) representation.
> Just pick one of these two and you can send it again and add my signed-off-by:
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

I'll make it an "Acked-by." You can only put an Sob, if you forward a 
patch. Otherwise you can only add an Acked-by or a Reviewed-by.

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> > +	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > +	V4L2_MBUS_FMT_RGB565_2X8_BE,
> > +	V4L2_MBUS_FMT_SBGGR8_1X8,
> > +	V4L2_MBUS_FMT_SBGGR10_1X10,
> > +	V4L2_MBUS_FMT_GREY8_1X8,
> > +	V4L2_MBUS_FMT_Y10_1X10,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > +};
> > +
> > +/**
> > + * struct v4l2_mbus_framefmt - frame format on the media bus
> > + * @width:	frame width
> > + * @height:	frame height
> > + * @code:	data format code
> > + * @field:	used interlacing type
> > + * @colorspace:	colorspace of the data
> > + */
> > +struct v4l2_mbus_framefmt {
> > +	__u32				width;
> > +	__u32				height;
> > +	enum v4l2_mbus_pixelcode	code;
> > +	enum v4l2_field			field;
> > +	enum v4l2_colorspace		colorspace;
> > +};
> > +
> > +#endif
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 544ce87..c53d462 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -22,6 +22,7 @@
> >  #define _V4L2_SUBDEV_H
> >  
> >  #include <media/v4l2-common.h>
> > +#include <media/v4l2-mediabus.h>
> >  
> >  /* generic v4l2_device notify callback notification values */
> >  #define V4L2_SUBDEV_IR_RX_NOTIFY		_IOW('v', 0, u32)
> > @@ -207,7 +208,7 @@ struct v4l2_subdev_audio_ops {
> >     s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
> >  	video input devices.
> >  
> > -  s_crystal_freq: sets the frequency of the crystal used to generate the
> > +   s_crystal_freq: sets the frequency of the crystal used to generate the
> >  	clocks in Hz. An extra flags field allows device specific configuration
> >  	regarding clock frequency dividers, etc. If not used, then set flags
> >  	to 0. If the frequency is not supported, then -EINVAL is returned.
> > @@ -217,6 +218,14 @@ struct v4l2_subdev_audio_ops {
> >  
> >     s_routing: see s_routing in audio_ops, except this version is for video
> >  	devices.
> > +
> > +   enum_mbus_fmt: enumerate pixel formats, provided by a video data source
> > +
> > +   g_mbus_fmt: get the current pixel format, provided by a video data source
> > +
> > +   try_mbus_fmt: try to set a pixel format on a video data source
> > +
> > +   s_mbus_fmt: set a pixel format on a video data source
> >   */
> >  struct v4l2_subdev_video_ops {
> >  	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
> > @@ -240,6 +249,14 @@ struct v4l2_subdev_video_ops {
> >  	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
> >  	int (*enum_framesizes)(struct v4l2_subdev *sd, struct v4l2_frmsizeenum *fsize);
> >  	int (*enum_frameintervals)(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival);
> > +	int (*enum_mbus_fmt)(struct v4l2_subdev *sd, int index,
> > +			     enum v4l2_mbus_pixelcode *code);
> > +	int (*g_mbus_fmt)(struct v4l2_subdev *sd,
> > +			  struct v4l2_mbus_framefmt *fmt);
> > +	int (*try_mbus_fmt)(struct v4l2_subdev *sd,
> > +			    struct v4l2_mbus_framefmt *fmt);
> > +	int (*s_mbus_fmt)(struct v4l2_subdev *sd,
> > +			  struct v4l2_mbus_framefmt *fmt);
> >  };
> >  
> >  /**
> > -- 
> > 1.6.2.4
> > 
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

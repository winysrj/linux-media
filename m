Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4483 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0JEPfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 11:35:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC v3 01/11] v4l: Move the media/v4l2-mediabus.h header to include/linux
Date: Tue, 5 Oct 2010 17:34:46 +0200
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <4CAB39AB.2070806@maxwell.research.nokia.com> <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1010051728360.31708@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051734.46667.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, October 05, 2010 17:30:21 Guennadi Liakhovetski wrote:
> On Tue, 5 Oct 2010, Sakari Ailus wrote:
> 
> > Hi Laurent,
> > 
> > Thanks for the patch!
> > 
> > Laurent Pinchart wrote:
> > > The header defines the v4l2_mbus_framefmt structure which will be used
> > > by the V4L2 subdevs userspace API.
> > > 
> > > Change the type of the v4l2_mbus_framefmt::code field to __u32, as enum
> > > sizes can differ between different ABIs on the same architectures.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  include/linux/Kbuild          |    1 +
> > >  include/linux/v4l2-mediabus.h |   70 +++++++++++++++++++++++++++++++++++++++++
> > >  include/media/soc_mediabus.h  |    3 +-
> > >  include/media/v4l2-mediabus.h |   53 +------------------------------
> > >  4 files changed, 73 insertions(+), 54 deletions(-)
> > >  create mode 100644 include/linux/v4l2-mediabus.h
> > > 
> > > diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> > > index f836ee4..38127c2 100644
> > > --- a/include/linux/Kbuild
> > > +++ b/include/linux/Kbuild
> > > @@ -369,6 +369,7 @@ header-y += unistd.h
> > >  header-y += usbdevice_fs.h
> > >  header-y += utime.h
> > >  header-y += utsname.h
> > > +header-y += v4l2-mediabus.h
> > >  header-y += veth.h
> > >  header-y += vhost.h
> > >  header-y += videodev.h
> > > diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
> > > new file mode 100644
> > > index 0000000..127512a
> > > --- /dev/null
> > > +++ b/include/linux/v4l2-mediabus.h
> > > @@ -0,0 +1,70 @@
> > > +/*
> > > + * Media Bus API header
> > > + *
> > > + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#ifndef __LINUX_V4L2_MEDIABUS_H
> > > +#define __LINUX_V4L2_MEDIABUS_H
> > > +
> > > +#include <linux/types.h>
> > > +#include <linux/videodev2.h>
> > > +
> > > +/*
> > > + * These pixel codes uniquely identify data formats on the media bus. Mostly
> > > + * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0 is
> > > + * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs, where the
> > > + * data format is fixed. Additionally, "2X8" means that one pixel is transferred
> > > + * in two 8-bit samples, "BE" or "LE" specify in which order those samples are
> > > + * transferred over the bus: "LE" means that the least significant bits are
> > > + * transferred first, "BE" means that the most significant bits are transferred
> > > + * first, and "PADHI" and "PADLO" define which bits - low or high, in the
> > > + * incomplete high byte, are filled with padding bits.
> > > + */
> > > +enum v4l2_mbus_pixelcode {
> > > +	V4L2_MBUS_FMT_FIXED = 1,
> > > +	V4L2_MBUS_FMT_YUYV8_2X8,
> > > +	V4L2_MBUS_FMT_YVYU8_2X8,
> > > +	V4L2_MBUS_FMT_UYVY8_2X8,
> > > +	V4L2_MBUS_FMT_VYUY8_2X8,
> > > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> > > +	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > > +	V4L2_MBUS_FMT_RGB565_2X8_BE,
> > > +	V4L2_MBUS_FMT_SBGGR8_1X8,
> > > +	V4L2_MBUS_FMT_SBGGR10_1X10,
> > > +	V4L2_MBUS_FMT_GREY8_1X8,
> > > +	V4L2_MBUS_FMT_Y10_1X10,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > > +	V4L2_MBUS_FMT_SGRBG8_1X8,
> > > +	V4L2_MBUS_FMT_SBGGR12_1X12,
> > > +	V4L2_MBUS_FMT_YUYV8_1_5X8,
> > > +	V4L2_MBUS_FMT_YVYU8_1_5X8,
> > > +	V4L2_MBUS_FMT_UYVY8_1_5X8,
> > > +	V4L2_MBUS_FMT_VYUY8_1_5X8,
> > > +};
> > > +
> > > +/**
> > > + * struct v4l2_mbus_framefmt - frame format on the media bus
> > > + * @width:	frame width
> > > + * @height:	frame height
> > > + * @code:	data format code
> > > + * @field:	used interlacing type
> > > + * @colorspace:	colorspace of the data
> > > + */
> > > +struct v4l2_mbus_framefmt {
> > > +	__u32				width;
> > > +	__u32				height;
> > > +	__u32				code;
> > > +	enum v4l2_field			field;
> > > +	enum v4l2_colorspace		colorspace;
> > > +};
> > 
> > I think this struct would benefit from some reserved fields since it's
> > part of the user space interface.
> 
> IIUC, this struct is not going to be used in ioctl()s, that's what struct 
> v4l2_subdev_mbus_code_enum is for. But in this case - why don't we make 
> the "code" field above of type "enum v4l2_mbus_pixelcode"?

Hmm, if it is not part of the public API, then it doesn't belong here at all.

media/v4l2-mediabus.h should be split in a media header and a linux header in
that case.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > 
> > No other comments.
> > 
> > Cheers,
> > 
> 
> ---
> Guennadi Liakhovetski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

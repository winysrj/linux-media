Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3160 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZLAKZ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 05:25:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2 v3] v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
Date: Tue, 1 Dec 2009 15:54:19 +0530
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange> <alpine.LNX.2.01.0911300854060.3049@alastor> <Pine.LNX.4.64.0911301014570.12689@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0911301014570.12689@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912011554.19929.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 November 2009 14:49:07 Guennadi Liakhovetski wrote:
> On Mon, 30 Nov 2009, Hans Verkuil wrote:
> > On Thu, 26 Nov 2009, Guennadi Liakhovetski wrote:
> > > > From 8b24c617e1ac4d324538a3eec476d48b85c2091f Mon Sep 17 00:00:00
> > > > 2001
> > >
> > > From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Date: Thu, 26 Nov 2009 18:20:45 +0100
> > > Subject: [PATCH] v4l: add a media-bus API for configuring v4l2 subdev
> > > pixel and frame formats
> > >
> > > Video subdevices, like cameras, decoders, connect to video bridges over
> > > specialised busses. Data is being transferred over these busses in
> > > various formats, which only loosely correspond to fourcc codes,
> > > describing how video data is stored in RAM. This is not a one-to-one
> > > correspondence, therefore we cannot use fourcc codes to configure
> > > subdevice output data formats. This patch
> > > adds codes for several such on-the-bus formats and an API, similar to
> > > the familiar .s_fmt(), .g_fmt(), .try_fmt(), .enum_fmt() API for
> > > configuring those
> > > codes. After all users of the old API in struct v4l2_subdev_video_ops
> > > are converted, it will be removed. Also add helper routines to support
> > > generic pass-through mode for the soc-camera framework.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >
> > > v2 -> v3: more comments:
> > >
> > > 1. moved enum v4l2_mbus_packing, enum v4l2_mbus_order, and struct
> > > v4l2_mbus_pixelfmt to soc-camera specific header, renamed them into
> > > soc-namespace.
> > >
> > > 2. commented enum v4l2_mbus_pixelcode and removed unused values.
> > >
> > > v1 -> v2: addressed comments from Hans, namely:
> > >
> > > 1. renamed image bus to media bus, now using "mbus" as a shorthand in
> > > function and data type names.
> > >
> > > 2. made media-bus helper functions soc-camera local.
> > >
> > > 3. moved colorspace from struct v4l2_mbus_pixelfmt to struct
> > > v4l2_mbus_framefmt.
> > >
> > > 4. added documentation for data types and enums.
> > >
> > > 5. added
> > >
> > >      V4L2_MBUS_FMT_FIXED = 1,
> > >
> > > format as the first in enum.
> > >
> > > soc-camera driver port will follow tomorrow.
> > >
> > > Thanks
> > > Guennadi
> > >
> > >
> > > drivers/media/video/Makefile       |    2 +-
> > > drivers/media/video/soc_mediabus.c |  157
> > > ++++++++++++++++++++++++++++++++++++
> > > include/media/soc_mediabus.h       |   84 +++++++++++++++++++
> > > include/media/v4l2-mediabus.h      |   59 ++++++++++++++
> > > include/media/v4l2-subdev.h        |   19 ++++-
> >
> > <cut>
> >
> > > diff --git a/include/media/v4l2-mediabus.h
> > > b/include/media/v4l2-mediabus.h new file mode 100644
> > > index 0000000..359840c
> > > --- /dev/null
> > > +++ b/include/media/v4l2-mediabus.h
> > > @@ -0,0 +1,59 @@
> > > +/*
> > > + * Media Bus API header
> > > + *
> > > + * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > modify + * it under the terms of the GNU General Public License version
> > > 2 as + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#ifndef V4L2_MEDIABUS_H
> > > +#define V4L2_MEDIABUS_H
> > > +
> > > +/*
> > > + * These pixel codes uniquely identify data formats on the media bus.
> > > Mostly
> > > + * they correspond to similarly named V4L2_PIX_FMT_* formats, format 0
> > > is + * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client
> > > pairs, where the
> > > + * data format is fixed. Additionally, "2X8" means that one pixel is
> > > transferred
> > > + * in two 8-bit samples, "BE" or "LE" specify in which order those
> > > samples + * should be stored in RAM, and "PADHI" and "PADLO" define
> > > which bits - low or
> > > + * high, in the incomplete high byte, are filled with padding bits.
> > > + */
> >
> > Hi Guennadi,
> >
> > This still needs some improvement. There are two things that need to be
> > changed here:
> >
> > 1) add the width of the data bus to the format name: so
> > V4L2_MBUS_FMT_YUYV becomes _FMT_YUYV_8. This is required since I know
> > several video receivers that can be programmed to use one of several data
> > widths (8, 10, 12 bits per color component). Perhaps _1X8 is even better
> > since that is nicely consistent with the 2X8 suffix that you already use.
> > The PADHI and PADLO naming convention
> > is fine and should be used whereever it is neeeded. Ditto for BE and LE.
>
> Ok, my first thought was "no, there only very seldom will be a need for a
> different padding / order / bus-width," but the second thought was "but
> if there ever will be one, you'll have to rename the original code too..."
>
> > 2) Rephrase '"BE" or "LE" specify in which order those samples should be
> > stored
> > in RAM' to:
> >
> > '"BE" or "LE" specify in which order those samples are transferred over
> > the bus:
> > BE means that the most significant bits are transferred first, "LE" means
> > that the least significant bits are transferred first.'
> >
> > This also means that formats like RGB555 need to be renamed to
> > RGB555_2X8_PADHI_LE.
> >
> > I think that this would make this list of pixelcodes unambiguous and
> > understandable.
>
> Right, how about this:
>
> /*
>  * These pixel codes uniquely identify data formats on the media bus.
> Mostly * they correspond to similarly named V4L2_PIX_FMT_* formats, format
> 0 is * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs,
> where the * data format is fixed. Additionally, "2X8" means that one pixel
> is transferred * in two 8-bit samples, "BE" or "LE" specify in which order
> those samples are * transferred over the bus: "LE" means that the least
> significant bits are * transferred first, "BE" means that the most
> significant bits are transferred * first, and "PADHI" and "PADLO" define
> which bits - low or high, in the * incomplete high byte, are filled with
> padding bits.
>  */
> enum v4l2_mbus_pixelcode {
> 	V4L2_MBUS_FMT_FIXED = 1,
> 	V4L2_MBUS_FMT_YUYV_2X8_LE,
> 	V4L2_MBUS_FMT_YVYU_2X8_LE,
> 	V4L2_MBUS_FMT_UYVY_2X8_LE,
> 	V4L2_MBUS_FMT_VYUY_2X8_LE,

These possibly may need a comment saying that each Y/U/V sample is 8 bits 
wide. I'm not sure how far we want to go with systematic naming schemes here. 
Adding a short comment if there is a possible ambiguity is probably 
sufficient.

> 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> 	V4L2_MBUS_FMT_RGB555X_2X8_PADHI_LE,

Shouldn't this be: V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE? Since the 555X format is 
just the big-endian variant of the RGB555 if I am not mistaken.

> 	V4L2_MBUS_FMT_RGB565_2X8_LE,
> 	V4L2_MBUS_FMT_RGB565X_2X8_LE,

Ditto.

> 	V4L2_MBUS_FMT_SBGGR8_1X8,
> 	V4L2_MBUS_FMT_SBGGR10_1X10,
> 	V4L2_MBUS_FMT_GREY_1X8,

This is also 8 bits per sample, right? This might be renamed to GREY8_1X8.

Regards,

	Hans

> 	V4L2_MBUS_FMT_Y10_1X10,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> };
>
> > Regards,
> >
> > 	Hans
> >
> > > +enum v4l2_mbus_pixelcode {
> > > +	V4L2_MBUS_FMT_FIXED = 1,
> > > +	V4L2_MBUS_FMT_YUYV,
> > > +	V4L2_MBUS_FMT_YVYU,
> > > +	V4L2_MBUS_FMT_UYVY,
> > > +	V4L2_MBUS_FMT_VYUY,
> > > +	V4L2_MBUS_FMT_RGB555,
> > > +	V4L2_MBUS_FMT_RGB555X,
> > > +	V4L2_MBUS_FMT_RGB565,
> > > +	V4L2_MBUS_FMT_RGB565X,
> > > +	V4L2_MBUS_FMT_SBGGR8,
> > > +	V4L2_MBUS_FMT_SBGGR10,
> > > +	V4L2_MBUS_FMT_GREY,
> > > +	V4L2_MBUS_FMT_Y10,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> > > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> > > +};
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


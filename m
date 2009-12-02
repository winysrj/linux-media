Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1565 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZLBCm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 21:42:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/2 v3] v4l: add a media-bus API for configuring v4l2 subdev pixel and frame formats
Date: Wed, 2 Dec 2009 08:11:11 +0530
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange> <200912011554.19929.hverkuil@xs4all.nl> <Pine.LNX.4.64.0912011141590.4701@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0912011141590.4701@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912020811.12156.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 01 December 2009 16:22:55 Guennadi Liakhovetski wrote:
> On Tue, 1 Dec 2009, Hans Verkuil wrote:
> > On Monday 30 November 2009 14:49:07 Guennadi Liakhovetski wrote:
> > > Right, how about this:
> > >
> > > /*
> > >  * These pixel codes uniquely identify data formats on the media bus.
> > > Mostly * they correspond to similarly named V4L2_PIX_FMT_* formats,
> > > format 0 is * reserved, V4L2_MBUS_FMT_FIXED shall be used by
> > > host-client pairs, where the * data format is fixed. Additionally,
> > > "2X8" means that one pixel is transferred * in two 8-bit samples, "BE"
> > > or "LE" specify in which order those samples are * transferred over the
> > > bus: "LE" means that the least significant bits are * transferred
> > > first, "BE" means that the most significant bits are transferred *
> > > first, and "PADHI" and "PADLO" define which bits - low or high, in the
> > > * incomplete high byte, are filled with padding bits.
> > >  */
> > > enum v4l2_mbus_pixelcode {
> > > 	V4L2_MBUS_FMT_FIXED = 1,
> > > 	V4L2_MBUS_FMT_YUYV_2X8_LE,
> > > 	V4L2_MBUS_FMT_YVYU_2X8_LE,
> > > 	V4L2_MBUS_FMT_UYVY_2X8_LE,
> > > 	V4L2_MBUS_FMT_VYUY_2X8_LE,
> >
> > These possibly may need a comment saying that each Y/U/V sample is 8 bits
> > wide. I'm not sure how far we want to go with systematic naming schemes
> > here. Adding a short comment if there is a possible ambiguity is probably
> > sufficient.
>
> Is there an ambiguity? Aren't these formats standardised?

HDMI receivers/transmitters can do YUV with 8, 10 or 12 bits. So when you say
YUYV_2X8_LE do you mean that 10 bits are transported over two bytes, or that
a Y and a U (or V) are transferred one after another? From the absence of a 
PADHI or PADLO I can infer that it is the latter, but it is not exactly 
obvious.

Actually, why not name these formats YUYV8, etc. and the order of the bytes 
going over the bus is just the order of the text 'YUYV'. There is not really 
any big or little endian issues since you just need to know the sequence of 
Ys, Us and Vs.

> Do we then have
> to explain what rgb555 means etc?
>
> > > 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > > 	V4L2_MBUS_FMT_RGB555X_2X8_PADHI_LE,
> >
> > Shouldn't this be: V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE? Since the 555X
> > format is just the big-endian variant of the RGB555 if I am not mistaken.
>
> No, don't think so. As an RGB555X format it is sent in LE order, if you
> send RGB555X in BE order you get RGB555 (without an "X"). In fact, you'll
> never have a RGB555X_BE format, because, that's just the RGB555_LE. So,
> you may only have BE variants for formats, whoch byte-swapped variants do
> not have an own name.

RGB 5:5:5 consists of 16 bits arrrrrgg gggbbbbb ('a' is either padding or an 
alpha bit).

RGB 5:5:5 over an 8 bit data bus is either with the MSB byte first (big endian 
aka RGB555X aka RGB555_2X8_PADHI_BE) or with the LSB byte first (little endian 
aka RGB555 aka RGB555_2X8_PADHI_LE).

The use of RGB555X in the pixel formats is a really ugly accident of history. 
'RGB555' is the name of the format, and _LE or _BE should define what the 
order of the LSB and MSB over the data bus is.

>
> > > 	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > > 	V4L2_MBUS_FMT_RGB565X_2X8_LE,
> >
> > Ditto.
> >
> > > 	V4L2_MBUS_FMT_SBGGR8_1X8,
> > > 	V4L2_MBUS_FMT_SBGGR10_1X10,
> > > 	V4L2_MBUS_FMT_GREY_1X8,
> >
> > This is also 8 bits per sample, right? This might be renamed to
> > GREY8_1X8.
>
> I named it after V4L2_PIX_FMT_GREY. If we ever get GREY7 or similar, I
> think, we anyway will need a new fourcc code for it, then we'll call the
> MBUS_FMT similarly.

Why not do it right from the start? Frankly, the PIX_FMT names aren't that 
great. And since this will become a public API in the future I think it is 
reasonable to spend some time on it (and it is the reason why I'm so picky 
about it :-) ).

Regards,

	Hans

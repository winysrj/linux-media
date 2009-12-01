Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34328 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753070AbZLAKwo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 05:52:44 -0500
Date: Tue, 1 Dec 2009 11:52:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 1/2 v3] v4l: add a media-bus API for configuring v4l2
 subdev pixel and frame formats
In-Reply-To: <200912011554.19929.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0912011141590.4701@axis700.grange>
References: <Pine.LNX.4.64.0911261509100.5450@axis700.grange>
 <alpine.LNX.2.01.0911300854060.3049@alastor> <Pine.LNX.4.64.0911301014570.12689@axis700.grange>
 <200912011554.19929.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 1 Dec 2009, Hans Verkuil wrote:

> On Monday 30 November 2009 14:49:07 Guennadi Liakhovetski wrote:
> >
> > Right, how about this:
> >
> > /*
> >  * These pixel codes uniquely identify data formats on the media bus.
> > Mostly * they correspond to similarly named V4L2_PIX_FMT_* formats, format
> > 0 is * reserved, V4L2_MBUS_FMT_FIXED shall be used by host-client pairs,
> > where the * data format is fixed. Additionally, "2X8" means that one pixel
> > is transferred * in two 8-bit samples, "BE" or "LE" specify in which order
> > those samples are * transferred over the bus: "LE" means that the least
> > significant bits are * transferred first, "BE" means that the most
> > significant bits are transferred * first, and "PADHI" and "PADLO" define
> > which bits - low or high, in the * incomplete high byte, are filled with
> > padding bits.
> >  */
> > enum v4l2_mbus_pixelcode {
> > 	V4L2_MBUS_FMT_FIXED = 1,
> > 	V4L2_MBUS_FMT_YUYV_2X8_LE,
> > 	V4L2_MBUS_FMT_YVYU_2X8_LE,
> > 	V4L2_MBUS_FMT_UYVY_2X8_LE,
> > 	V4L2_MBUS_FMT_VYUY_2X8_LE,
> 
> These possibly may need a comment saying that each Y/U/V sample is 8 bits 
> wide. I'm not sure how far we want to go with systematic naming schemes here. 
> Adding a short comment if there is a possible ambiguity is probably 
> sufficient.

Is there an ambiguity? Aren't these formats standardised? Do we then have 
to explain what rgb555 means etc?

> > 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > 	V4L2_MBUS_FMT_RGB555X_2X8_PADHI_LE,
> 
> Shouldn't this be: V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE? Since the 555X format is 
> just the big-endian variant of the RGB555 if I am not mistaken.

No, don't think so. As an RGB555X format it is sent in LE order, if you 
send RGB555X in BE order you get RGB555 (without an "X"). In fact, you'll 
never have a RGB555X_BE format, because, that's just the RGB555_LE. So, 
you may only have BE variants for formats, whoch byte-swapped variants do 
not have an own name.

> > 	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > 	V4L2_MBUS_FMT_RGB565X_2X8_LE,
> 
> Ditto.
> 
> > 	V4L2_MBUS_FMT_SBGGR8_1X8,
> > 	V4L2_MBUS_FMT_SBGGR10_1X10,
> > 	V4L2_MBUS_FMT_GREY_1X8,
> 
> This is also 8 bits per sample, right? This might be renamed to GREY8_1X8.

I named it after V4L2_PIX_FMT_GREY. If we ever get GREY7 or similar, I 
think, we anyway will need a new fourcc code for it, then we'll call the 
MBUS_FMT similarly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42640 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755199Ab0GWJ0F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 05:26:05 -0400
Date: Fri, 23 Jul 2010 11:26:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
In-Reply-To: <201007231035.31462.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1007231040520.22677@axis700.grange>
References: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
 <201007231035.31462.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Jul 2010, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Friday 23 July 2010 10:13:37 Guennadi Liakhovetski wrote:
> > Add pixel format codes, defined in the MIPI CSI-2 specification.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > Even though it affects the same enum as my patch from yesterday, they are
> > independent, Hans and Laurent CCed just to avoid possible conflicts, when
> > further patching this file.
> > 
> >  include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
> >  1 files changed, 26 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> > index a870965..b0dcace 100644
> > --- a/include/media/v4l2-mediabus.h
> > +++ b/include/media/v4l2-mediabus.h
> > @@ -41,6 +41,32 @@ enum v4l2_mbus_pixelcode {
> >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> >  	V4L2_MBUS_FMT_SGRBG8_1X8,
> > +	/* MIPI CSI-2 codes */
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_L,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_CSPS,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10_CSPS,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_8,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_10,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB888,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB666,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB565,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB555,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB444,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW6,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW7,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW8,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW10,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW12,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW14,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_NULL,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_BLANKING,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_EMBEDDED8,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_1,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_2,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_3,
> > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_4,
> 
> I don't think I like this. Take the raw formats for instance, they're used for 
> Bayer RGB. V4L2_MBUS_FMT_MIPI_CSI2_RAW8 could map to any Bayer format (GRBG, 
> RGGB, ...). Why don't we just use "standard" pixel codes ?

Well, the idea was to keep them cleanly separated: CSI connections only 
deal with CSI codes, parallel connections with parallel codes. In 
principle, the above codes are supposed to specify the bus type, right? A 
"NX8" format is an 8-bit parallel bus, etc. CSI doesn't fit into any of 
those. So, from that PoV you do need separate codes, I think.

That said, using these new CSI codes is difficult...

Ok, how about this: looking at the spec, there is a layer chart of the 
MIPI CSI-2 data-flow. It shows some arbitrary data format at the 
application level, lane-based serial connection on the wire, but between 
them there is a fixed 8-bit data bus, say, at the lane-management layer. 
So, we just agree to take that as our CSI bus view. In fact, we _have_ to 
use a more generic pixel code scheme, than the CSI formats, because, say, 
with CSI codes there's no way to say, that it's actually Bayer data, that 
the sensor is sending, using the CSI RAW8 format.

So, Laurent, you're right, this is not going to work. Thanks for pointing 
this out!

cat mediabus-add-MIPI-CSI-2-pixel-format-codes.patch > /dev/null

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

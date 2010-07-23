Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36954 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755931Ab0GWKnR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 06:43:17 -0400
Date: Fri, 23 Jul 2010 12:43:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Subject: RE: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
In-Reply-To: <000001cb2a49$db5151f0$91f3f5d0$%nawrocki@samsung.com>
Message-ID: <Pine.LNX.4.64.1007231209410.22677@axis700.grange>
References: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
 <201007231035.31462.laurent.pinchart@ideasonboard.com>
 <000001cb2a49$db5151f0$91f3f5d0$%nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Fri, 23 Jul 2010, Sylwester Nawrocki wrote:

> Hi Laurent,
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> > Sent: Friday, July 23, 2010 10:35 AM
> > To: Guennadi Liakhovetski
> > Cc: Linux Media Mailing List; Hans Verkuil
> > Subject: Re: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
> > 
> > Hi Guennadi,
> > 
> > On Friday 23 July 2010 10:13:37 Guennadi Liakhovetski wrote:
> > > Add pixel format codes, defined in the MIPI CSI-2 specification.
> > >
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >
> > > Even though it affects the same enum as my patch from yesterday, they
> > are
> > > independent, Hans and Laurent CCed just to avoid possible conflicts,
> > when
> > > further patching this file.
> > >
> > >  include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
> > >  1 files changed, 26 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-
> > mediabus.h
> > > index a870965..b0dcace 100644
> > > --- a/include/media/v4l2-mediabus.h
> > > +++ b/include/media/v4l2-mediabus.h
> > > @@ -41,6 +41,32 @@ enum v4l2_mbus_pixelcode {
> > >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > >  	V4L2_MBUS_FMT_SGRBG8_1X8,
> > > +	/* MIPI CSI-2 codes */
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_L,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_CSPS,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10_CSPS,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_8,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_10,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB888,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB666,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB565,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB555,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB444,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW6,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW7,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW8,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW10,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW12,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW14,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_NULL,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_BLANKING,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_EMBEDDED8,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_1,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_2,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_3,
> > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_4,
> > 
> > I don't think I like this. Take the raw formats for instance, they're
> > used for
> > Bayer RGB. V4L2_MBUS_FMT_MIPI_CSI2_RAW8 could map to any Bayer format
> > (GRBG,
> > RGGB, ...). Why don't we just use "standard" pixel codes ?
> 
> As far as I understand on some media buses exact pixel formats are not
> defined,
> although we still need information to configure the bus.
> MIPI CSI-2 seem an example of such to me, e.g. we do configure MIPI
> interface
> to "*_USER_1" format but over the bus is transferred JPEG data.
> I guess we could try to use "standard" pixel codes but then we would
> probably have
> to map from "any" format to specific MIPI format code to configure the
> hardware.
> Moreover MIPI formats are quite specific, for instance for RAW12 in 32-bit
> sample 
> (from MSb to LSb) we have dummy 8-bits, then 12-bit of actual data and
> remaining
> 12 dummy bits.

I think, we have to approach this problem from the other side - from the 
user perspective. A "RAW8" format tells nothing to mplayer or gstreamer, 
whereas they shall understand 8-bit Bayer. Similarly, the sensor will 
know, that for sending of 8-bit Bayer data it'll use RAW8. So, on the 
receiver side, as you correctly point out, you will have to configure 
which data format to receive. If 8-bit Bayer is sent by the sensor, you 
will guess, that it should be RAW8. If RGB565 is expected you'll know what 
to set too. The problem arises with USER? formats. Only the sensor will 
know, that when requested JPEG, it will user USER1, for MPEG-4 it will use 
USER2. And there's currently no way to know this in the bridge / host 
driver... So, at latest, when we get such a sensor, we'll have to decide 
how to map those. Until then I would just propose to continue using the 
existing mediabus formats and hope, that their mapping to CSI formats is 
of a many-to-one nature...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43107 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab0HPK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Aug 2010 06:26:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L78002UBQBPW960@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Aug 2010 11:26:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L78007RCQBPFX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Aug 2010 11:26:13 +0100 (BST)
Date: Mon, 16 Aug 2010 12:24:22 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
In-reply-to: <Pine.LNX.4.64.1007231209410.22677@axis700.grange>
To: 'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <000001cb3d2d$31a1a190$94e4e4b0$%nawrocki@samsung.com>
Content-language: en-us
References: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
 <201007231035.31462.laurent.pinchart@ideasonboard.com>
 <000001cb2a49$db5151f0$91f3f5d0$%nawrocki@samsung.com>
 <Pine.LNX.4.64.1007231209410.22677@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Guennadi,

Just reviving an ancient thread.
While working on porting the camera sensor and the camera bridge 
drivers to Media Bus I ran into trouble while trying to translate
V4L2_PIX_FMT_JPEG user fourcc to appropriate v4l2_mbus_pixelcode.
I was going to change V4L2_PIX_FMT_JPEG in the old sensor driver to
some v4l2_mbus_pixelcode, but didn't find anything relevant.
When user requests JPEG format in the camera bridge driver I need 
to setup the bridge to DMA transparently data from the MIPI CSI 
interface, configure MIPI interface to RAW8 and setup the sensor 
driver to output JPEG data.

Would it be reasonable to add something like 
V4L2_MBUS_FMT_JPEG_1X8 to the list of Media Bus pixel codes?

Would anybody have some better ideas?

Regards,
Sylwester


--
Sylwester Nawrocki
Linux Platform Group
Samsung Poland R&D Center

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> Sent: Friday, July 23, 2010 12:43 PM
> To: Sylwester Nawrocki
> Cc: 'Laurent Pinchart'; 'Linux Media Mailing List'; 'Hans Verkuil'
> Subject: RE: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
> 
> Hi Sylwester
> 
> On Fri, 23 Jul 2010, Sylwester Nawrocki wrote:
> 
> > Hi Laurent,
> >
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> > > Sent: Friday, July 23, 2010 10:35 AM
> > > To: Guennadi Liakhovetski
> > > Cc: Linux Media Mailing List; Hans Verkuil
> > > Subject: Re: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
> > >
> > > Hi Guennadi,
> > >
> > > On Friday 23 July 2010 10:13:37 Guennadi Liakhovetski wrote:
> > > > Add pixel format codes, defined in the MIPI CSI-2 specification.
> > > >
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > ---
> > > >
> > > > Even though it affects the same enum as my patch from yesterday,
> they
> > > are
> > > > independent, Hans and Laurent CCed just to avoid possible
> conflicts,
> > > when
> > > > further patching this file.
> > > >
> > > >  include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
> > > >  1 files changed, 26 insertions(+), 0 deletions(-)
> > > >
> > > > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-
> > > mediabus.h
> > > > index a870965..b0dcace 100644
> > > > --- a/include/media/v4l2-mediabus.h
> > > > +++ b/include/media/v4l2-mediabus.h
> > > > @@ -41,6 +41,32 @@ enum v4l2_mbus_pixelcode {
> > > >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > > >  	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > > >  	V4L2_MBUS_FMT_SGRBG8_1X8,
> > > > +	/* MIPI CSI-2 codes */
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_L,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_8_CSPS,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV420_10_CSPS,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_8,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_YUV422_10,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB888,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB666,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB565,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB555,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RGB444,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW6,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW7,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW8,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW10,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW12,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_RAW14,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_NULL,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_BLANKING,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_GEN_EMBEDDED8,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_1,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_2,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_3,
> > > > +	V4L2_MBUS_FMT_MIPI_CSI2_USER_4,
> > >
> > > I don't think I like this. Take the raw formats for instance,
> they're
> > > used for
> > > Bayer RGB. V4L2_MBUS_FMT_MIPI_CSI2_RAW8 could map to any Bayer
> format
> > > (GRBG,
> > > RGGB, ...). Why don't we just use "standard" pixel codes ?
> >
> > As far as I understand on some media buses exact pixel formats are
> not
> > defined,
> > although we still need information to configure the bus.
> > MIPI CSI-2 seem an example of such to me, e.g. we do configure MIPI
> > interface
> > to "*_USER_1" format but over the bus is transferred JPEG data.
> > I guess we could try to use "standard" pixel codes but then we would
> > probably have
> > to map from "any" format to specific MIPI format code to configure
> the
> > hardware.
> > Moreover MIPI formats are quite specific, for instance for RAW12 in
> 32-bit
> > sample
> > (from MSb to LSb) we have dummy 8-bits, then 12-bit of actual data
> and
> > remaining
> > 12 dummy bits.
> 
> I think, we have to approach this problem from the other side - from
> the
> user perspective. A "RAW8" format tells nothing to mplayer or
> gstreamer,
> whereas they shall understand 8-bit Bayer. Similarly, the sensor will
> know, that for sending of 8-bit Bayer data it'll use RAW8. So, on the
> receiver side, as you correctly point out, you will have to configure
> which data format to receive. If 8-bit Bayer is sent by the sensor, you
> will guess, that it should be RAW8. If RGB565 is expected you'll know
> what
> to set too. The problem arises with USER? formats. Only the sensor will
> know, that when requested JPEG, it will user USER1, for MPEG-4 it will
> use
> USER2. And there's currently no way to know this in the bridge / host
> driver... So, at latest, when we get such a sensor, we'll have to
> decide
> how to map those. Until then I would just propose to continue using the
> existing mediabus formats and hope, that their mapping to CSI formats
> is
> of a many-to-one nature...
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



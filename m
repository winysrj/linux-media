Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60408 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab0GWJdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 05:33:10 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L6000II57V6RA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jul 2010 10:33:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L60003247V6LG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jul 2010 10:33:06 +0100 (BST)
Date: Fri, 23 Jul 2010 11:31:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
In-reply-to: <201007231035.31462.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>
Message-id: <000001cb2a49$db5151f0$91f3f5d0$%nawrocki@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.64.1007231010370.22677@axis700.grange>
 <201007231035.31462.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Friday, July 23, 2010 10:35 AM
> To: Guennadi Liakhovetski
> Cc: Linux Media Mailing List; Hans Verkuil
> Subject: Re: [PATCH] mediabus: add MIPI CSI-2 pixel format codes
> 
> Hi Guennadi,
> 
> On Friday 23 July 2010 10:13:37 Guennadi Liakhovetski wrote:
> > Add pixel format codes, defined in the MIPI CSI-2 specification.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> > Even though it affects the same enum as my patch from yesterday, they
> are
> > independent, Hans and Laurent CCed just to avoid possible conflicts,
> when
> > further patching this file.
> >
> >  include/media/v4l2-mediabus.h |   26 ++++++++++++++++++++++++++
> >  1 files changed, 26 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-
> mediabus.h
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
> I don't think I like this. Take the raw formats for instance, they're
> used for
> Bayer RGB. V4L2_MBUS_FMT_MIPI_CSI2_RAW8 could map to any Bayer format
> (GRBG,
> RGGB, ...). Why don't we just use "standard" pixel codes ?

As far as I understand on some media buses exact pixel formats are not
defined,
although we still need information to configure the bus.
MIPI CSI-2 seem an example of such to me, e.g. we do configure MIPI
interface
to "*_USER_1" format but over the bus is transferred JPEG data.
I guess we could try to use "standard" pixel codes but then we would
probably have
to map from "any" format to specific MIPI format code to configure the
hardware.
Moreover MIPI formats are quite specific, for instance for RAW12 in 32-bit
sample 
(from MSb to LSb) we have dummy 8-bits, then 12-bit of actual data and
remaining
12 dummy bits.


> >  };
> >
> >  /**
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center



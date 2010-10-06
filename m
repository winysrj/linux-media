Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43132 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab0JFKM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 06:12:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Subject: Re: [PATCH/RFC v3 03/11] v4l: Group media bus pixel codes by types and sort them alphabetically
Date: Wed, 6 Oct 2010 12:13:10 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
References: <1286288714-16506-1-git-send-email-laurent.pinchart@ideasonboard.com> <1286288714-16506-4-git-send-email-laurent.pinchart@ideasonboard.com> <19F8576C6E063C45BE387C64729E739404AA21CCB1@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CCB1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010061213.11331.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Vaibhav,

On Wednesday 06 October 2010 11:19:21 Hiremath, Vaibhav wrote:
> On Tuesday, October 05, 2010 7:55 PM Laurent Pinchart wrote:
> > 
> > Adding new pixel codes at the end of the enumeration will soon create a
> > mess, so group the pixel codes by type and sort them by bus_width, bits
> > per component, samples per pixel and order of subsamples.
> > 
> > As the codes are part of the kernel ABI their value can't change when a
> > new code is inserted in the enumeration, so they are given an explicit
> > numerical value. When inserting a new pixel code developers must use and
> > update the next free value.
> > 
[snip]

> > +	V4L2_MBUS_FMT_FIXED = 0x0001,
> > +
> > +	/* RGB - next is 0x1005 */
> 
> Don't you think adding "next is 0x" is not required?
> Also while adding to this list someone has to modify here too.
> 
> Same applies to all such places.

The idea is that formats will be ordered by name. When adding new formats, the 
numerical values will then become out of order. Keeping a comment with the 
next format value will avoid having to search through the enum for the last 
used value.

> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1001,
> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 0x1002,
> > +	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1003,
> > +	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1004,
> > +
> > +	/* YUV (including grey) - next is 0x200b */
> > +	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> > +	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> > +	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> > +	V4L2_MBUS_FMT_YUYV8_1_5X8 = 0x2004,
> > +	V4L2_MBUS_FMT_YVYU8_1_5X8 = 0x2005,
> > +	V4L2_MBUS_FMT_UYVY8_2X8 = 0x2006,
> > +	V4L2_MBUS_FMT_VYUY8_2X8 = 0x2007,
> > +	V4L2_MBUS_FMT_YUYV8_2X8 = 0x2008,
> > +	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
> > +	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
> > +
> > +	/* Bayer - next is 0x3009 */
> > +	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> > +	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
> > +	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
> > +	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,

-- 
Regards,

Laurent Pinchart

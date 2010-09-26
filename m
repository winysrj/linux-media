Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:45098 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab0IZReo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 13:34:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 2/9] v4l: Group media bus pixel codes by types and sort them alphabetically
Date: Sun, 26 Sep 2010 19:34:49 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-3-git-send-email-laurent.pinchart@ideasonboard.com> <201009261929.54066.hverkuil@xs4all.nl>
In-Reply-To: <201009261929.54066.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009261934.50895.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sunday 26 September 2010 19:29:53 Hans Verkuil wrote:
> On Sunday, September 26, 2010 18:13:25 Laurent Pinchart wrote:
> > Adding new pixel codes at the end of the enumeration will soon create a
> > mess, so sort the pixel codes by type and then sort them alphabetically.
> > 
> > As the codes are part of the kernel ABI their value can't change when a
> > new code is inserted in the enumeration, so they are given an explicit
> > numerical value. When inserting a new pixel code developers must use and
> > update the V4L2_MBUS_FMT_LAST value.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  include/linux/v4l2-mediabus.h |   54
> >  ++++++++++++++++++++++++---------------- 1 files changed, 32
> >  insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/linux/v4l2-mediabus.h
> > b/include/linux/v4l2-mediabus.h index 127512a..bc637a5 100644
> > --- a/include/linux/v4l2-mediabus.h
> > +++ b/include/linux/v4l2-mediabus.h
> > @@ -24,31 +24,41 @@
> > 
> >   * transferred first, "BE" means that the most significant bits are
> >   transferred * first, and "PADHI" and "PADLO" define which bits - low
> >   or high, in the * incomplete high byte, are filled with padding bits.
> > 
> > + *
> > + * The pixel codes are grouped by types and (mostly) sorted
> > alphabetically. As + * their value can't change when a new pixel code is
> > inserted in the + * enumeration, they are explicitly given a numerical
> > value. When inserting a + * new pixel code use and update the
> > V4L2_MBUS_FMT_LAST value.
> > 
> >   */
> >  
> >  enum v4l2_mbus_pixelcode {
> >  
> >  	V4L2_MBUS_FMT_FIXED = 1,
> > 
> > -	V4L2_MBUS_FMT_YUYV8_2X8,
> > -	V4L2_MBUS_FMT_YVYU8_2X8,
> > -	V4L2_MBUS_FMT_UYVY8_2X8,
> > -	V4L2_MBUS_FMT_VYUY8_2X8,
> > -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
> > -	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
> > -	V4L2_MBUS_FMT_RGB565_2X8_LE,
> > -	V4L2_MBUS_FMT_RGB565_2X8_BE,
> > -	V4L2_MBUS_FMT_SBGGR8_1X8,
> > -	V4L2_MBUS_FMT_SBGGR10_1X10,
> > -	V4L2_MBUS_FMT_GREY8_1X8,
> > -	V4L2_MBUS_FMT_Y10_1X10,
> > -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE,
> > -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE,
> > -	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
> > -	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
> > -	V4L2_MBUS_FMT_SGRBG8_1X8,
> > -	V4L2_MBUS_FMT_SBGGR12_1X12,
> > -	V4L2_MBUS_FMT_YUYV8_1_5X8,
> > -	V4L2_MBUS_FMT_YVYU8_1_5X8,
> > -	V4L2_MBUS_FMT_UYVY8_1_5X8,
> > -	V4L2_MBUS_FMT_VYUY8_1_5X8,
> > +	/* RGB */
> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 7,
> > +	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE = 6,
> > +	V4L2_MBUS_FMT_RGB565_2X8_BE = 9,
> > +	V4L2_MBUS_FMT_RGB565_2X8_LE = 8,
> > +	/* YUV (including grey) */
> > +	V4L2_MBUS_FMT_GREY8_1X8 = 12,
> > +	V4L2_MBUS_FMT_Y10_1X10 = 13,
> > +	V4L2_MBUS_FMT_YUYV8_1_5X8 = 20,
> > +	V4L2_MBUS_FMT_YVYU8_1_5X8 = 21,
> > +	V4L2_MBUS_FMT_UYVY8_1_5X8 = 22,
> > +	V4L2_MBUS_FMT_VYUY8_1_5X8 = 23,
> > +	V4L2_MBUS_FMT_YUYV8_2X8 = 2,
> > +	V4L2_MBUS_FMT_UYVY8_2X8 = 4,
> > +	V4L2_MBUS_FMT_YVYU8_2X8 = 3,
> > +	V4L2_MBUS_FMT_VYUY8_2X8 = 5,
> > +	/* Bayer */
> > +	V4L2_MBUS_FMT_SBGGR8_1X8 = 10,
> > +	V4L2_MBUS_FMT_SBGGR10_1X10 = 11,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 16,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 14,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 17,
> > +	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 15,
> > +	V4L2_MBUS_FMT_SBGGR12_1X12 = 19,
> > +	V4L2_MBUS_FMT_SGRBG8_1X8 = 18,
> 
> Why on earth would you want to keep the original values? It was internal
> only, so no need to stick to the old values.

Good point :-)

> Just let RGB start at 1000, YUV at 2000 and Bayer at 3000 or something like
> that.
> 
> > +	/* Last - Update this when adding a new pixel code */
> > +	V4L2_MBUS_FMT_LAST = 24,
> 
> Why would you need this?

We've discussed this in the past. Keeping holes won't help, as we will have to 
insert formats in places where we won't have holes sooner or later. We agreed 
that it was better to keep the list organized by format, as that's easier to 
read. V4L2_MBUS_FMT_LAST is thus a shortcut to avoid searching for the highest 
format when adding a new one. As the constant itself isn't really needed, we 
can keep the highest allocated format code in a comment instead.

-- 
Regards,

Laurent Pinchart

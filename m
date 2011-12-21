Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51730 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab1LUWSy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 17:18:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Subject: Re: [PATCH 1/2] media: add new mediabus format enums for dm365
Date: Wed, 21 Dec 2011 23:18:54 +0100
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com> <201112210058.33006.laurent.pinchart@ideasonboard.com> <E99FAA59F8D8D34D8A118DD37F7C8F75018904@DBDE01.ent.ti.com>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F75018904@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112212318.55517.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Wednesday 21 December 2011 14:54:18 Hadli, Manjunath wrote:
> On Wed, Dec 21, 2011 at 05:28:31, Laurent Pinchart wrote:
> > On Friday 16 December 2011 15:20:24 Hadli, Manjunath wrote:
> > > On Thu, Dec 15, 2011 at 18:32:44, Laurent Pinchart wrote:
> > > > On Thursday 15 December 2011 13:24:57 Manjunath Hadli wrote:
> > > > > add new enum entry V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 into
> > > > > mbus_pixel_code to represent A-LAW compressed Bayer format. This
> > > > > corresponds to pixel format - V4L2_PIX_FMT_SGRBG10ALAW8.
> > > > > add UV8 and NV12 ( Y and C separate with UV interleaved) which are
> > > > > supported on dm365.
> > > > > 
> > > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > ---
> > > > > 
> > > > >  include/linux/v4l2-mediabus.h |   10 ++++++++--
> > > > >  1 files changed, 8 insertions(+), 2 deletions(-)
> > > > 
> > > > Please also update the documentation in
> > > > Documentation/DocBook/media/v4l.
> > > > 
> > > > > diff --git a/include/linux/v4l2-mediabus.h
> > > > > b/include/linux/v4l2-mediabus.h index 5ea7f75..d408654 100644
> > > > > --- a/include/linux/v4l2-mediabus.h
> > > > > +++ b/include/linux/v4l2-mediabus.h
> > > > > @@ -47,7 +47,7 @@ enum v4l2_mbus_pixelcode {
> > > > > 
> > > > >  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
> > > > >  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> > > > > 
> > > > > -	/* YUV (including grey) - next is 0x2014 */
> > > > > +	/* YUV (including grey) - next is 0x2016 */
> > > > > 
> > > > >  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> > > > >  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> > > > >  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> > > > > 
> > > > > @@ -67,8 +67,10 @@ enum v4l2_mbus_pixelcode {
> > > > > 
> > > > >  	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> > > > >  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
> > > > >  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> > > > > 
> > > > > +	V4L2_MBUS_FMT_NV12_1X20 = 0x2014,
> > > > > +	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
> > > > 
> > > > NV12, on the bus ? How does that work ? (The documentation should
> > > > answer my question :-))
> > > 
> > > Well, this is on the internal bus not exposed outside, but
> > > nevertheless bus between two subdevs or two independent hardware
> > > blocks. For example Resizer supports NV12 on its pad. Is there any
> > > other way to treat this?
> > 
> > How is NV12 transferred on the bus in that case ? Are all luma samples
> > transferred first, followed by all chroma samples ?
> 
> It uses parallel bus of 16 bits, where Y and C are transmitted
> simultaneously on 8 bits each. NV12 uses a dummy C byte for every valid
> one.
> So I guess we call it V4L2_MBUS_FMT_YDYC_1X16 or V4L2_MBUS_FMT_YCYD_1X16?
> That way we will be able to document the format in the documentation also.

That sounds good (YDYC8_1X16 to be precise). Hans, Guennadi, Sakari, any 
opinion ?

-- 
Regards,

Laurent Pinchart

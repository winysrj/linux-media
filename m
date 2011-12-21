Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49208 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1LUNy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 08:54:27 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: RE: [PATCH 1/2] media: add new mediabus format enums for dm365
Date: Wed, 21 Dec 2011 13:54:18 +0000
Message-ID: <E99FAA59F8D8D34D8A118DD37F7C8F75018904@DBDE01.ent.ti.com>
References: <1323951898-16330-1-git-send-email-manjunath.hadli@ti.com>
 <201112151402.45100.laurent.pinchart@ideasonboard.com>
 <E99FAA59F8D8D34D8A118DD37F7C8F75016B8B@DBDE01.ent.ti.com>
 <201112210058.33006.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201112210058.33006.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,
On Wed, Dec 21, 2011 at 05:28:31, Laurent Pinchart wrote:
> Hi Manju,
> 
> On Friday 16 December 2011 15:20:24 Hadli, Manjunath wrote:
> > On Thu, Dec 15, 2011 at 18:32:44, Laurent Pinchart wrote:
> > > On Thursday 15 December 2011 13:24:57 Manjunath Hadli wrote:
> > > > add new enum entry V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 into 
> > > > mbus_pixel_code to represent A-LAW compressed Bayer format. This 
> > > > corresponds to pixel format - V4L2_PIX_FMT_SGRBG10ALAW8.
> > > > add UV8 and NV12 ( Y and C separate with UV interleaved) which are 
> > > > supported on dm365.
> > > > 
> > > > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > ---
> > > > 
> > > >  include/linux/v4l2-mediabus.h |   10 ++++++++--
> > > >  1 files changed, 8 insertions(+), 2 deletions(-)
> > > 
> > > Please also update the documentation in Documentation/DocBook/media/v4l.
> > > 
> > > > diff --git a/include/linux/v4l2-mediabus.h 
> > > > b/include/linux/v4l2-mediabus.h index 5ea7f75..d408654 100644
> > > > --- a/include/linux/v4l2-mediabus.h
> > > > +++ b/include/linux/v4l2-mediabus.h
> > > > @@ -47,7 +47,7 @@ enum v4l2_mbus_pixelcode {
> > > > 
> > > >  	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
> > > >  	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
> > > > 
> > > > -	/* YUV (including grey) - next is 0x2014 */
> > > > +	/* YUV (including grey) - next is 0x2016 */
> > > > 
> > > >  	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
> > > >  	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
> > > >  	V4L2_MBUS_FMT_VYUY8_1_5X8 = 0x2003,
> > > > 
> > > > @@ -67,8 +67,10 @@ enum v4l2_mbus_pixelcode {
> > > > 
> > > >  	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
> > > >  	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
> > > >  	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
> > > > 
> > > > +	V4L2_MBUS_FMT_NV12_1X20 = 0x2014,
> > > > +	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
> > > 
> > > NV12, on the bus ? How does that work ? (The documentation should 
> > > answer my question :-))
> > 
> > Well, this is on the internal bus not exposed outside, but 
> > nevertheless bus between two subdevs or two independent hardware 
> > blocks. For example Resizer supports NV12 on its pad. Is there any other way to treat this?
> 
> How is NV12 transferred on the bus in that case ? Are all luma samples transferred first, followed by all chroma samples ?
It uses parallel bus of 16 bits, where Y and C are transmitted simultaneously on 8 bits each. NV12 uses a dummy C byte for every
valid one.
So I guess we call it V4L2_MBUS_FMT_YDYC_1X16 or V4L2_MBUS_FMT_YCYD_1X16?
That way we will be able to document the format in the documentation also.

Thx,
-Manju
> 
> > > > -	/* Bayer - next is 0x3015 */
> > > > +	/* Bayer - next is 0x3019 */
> > > > 
> > > >  	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
> > > >  	V4L2_MBUS_FMT_SGBRG8_1X8 = 0x3013,
> > > >  	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
> > > > 
> > > > @@ -89,6 +91,10 @@ enum v4l2_mbus_pixelcode {
> > > > 
> > > >  	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
> > > >  	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
> > > >  	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
> > > > 
> > > > +	V4L2_MBUS_FMT_SBGGR10_ALAW8_1X8 = 0x3015,
> > > > +	V4L2_MBUS_FMT_SGBRG10_ALAW8_1X8 = 0x3016,
> > > > +	V4L2_MBUS_FMT_SGRBG10_ALAW8_1X8 = 0x3017,
> > > > +	V4L2_MBUS_FMT_SRGGB10_ALAW8_1X8 = 0x3018,
> > > 
> > > Please keep the names sorted as described in the comment at the 
> > > beginning of the file.
> > > 
> > > >  	/* JPEG compressed formats - next is 0x4002 */
> > > >  	V4L2_MBUS_FMT_JPEG_1X8 = 0x4001,
> 
> --
> Regards,
> 
> Laurent Pinchart
> 


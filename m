Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52569 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaH1QYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 12:24:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Thu, 28 Aug 2014 18:25:24 +0200
Message-ID: <2088388.O2EqQOIWv7@avalon>
In-Reply-To: <1409242175.2696.108.camel@paszta.hi.pengutronix.de>
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de> <2323863.aLBeKZnVsL@avalon> <1409242175.2696.108.camel@paszta.hi.pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Thursday 28 August 2014 18:09:35 Philipp Zabel wrote:
> Am Donnerstag, den 28.08.2014, 14:24 +0200 schrieb Laurent Pinchart:
> > > A driver could then do the following:
> > > 
> > > static struct v4l2_pixfmt_info driver_formats[] = {
> > > 
> > > 	{ .pixelformat = V4L2_PIX_FMT_YUYV },
> > > 	{ .pixelformat = V4L2_PIX_FMT_YUV420 },
> > > 
> > > };
> > > 
> > > int driver_probe(...)
> > > {
> > > 
> > > 	...
> > > 	v4l2_init_pixfmt_array(driver_formats,
> > > 	
> > > 			ARRAY_SIZE(driver_formats));
> > > 	
> > > 	...
> > > 
> > > }
> > 
> > Good question. This option consumes more memory, and prevents the driver-
> > specific format info arrays to be const, which bothers me a bit.
> 
> Also, this wouldn't help drivers that don't want to take these
> additional steps, which probably includes a lot of camera drivers with
> only a few formats.
> 
> > On the other hand it allows drivers to override some of the default
> > values for odd cases.
> 
> Hm, but those cases don't have to use the v4l2_pixfmt_info at all.
> 
> > I won't nack this approach, but I'm wondering whether a better
> > solution wouldn't be possible. Hans, Mauro, Guennadi, any opinion ?
> 
> We could keep the global v4l2_pixfmt_info array sorted by fourcc value
> and do a binary search (would have to be kept in mind when adding new
> formats)

I like that option, provided we can ensure that the array is sorted. This can 
get a bit tricky, and Hans might wear his "don't over-optimize" hat :-)

> or build a hash table (more complicated code, consumes memory).

-- 
Regards,

Laurent Pinchart


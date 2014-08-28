Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60856 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaH1QJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 12:09:45 -0400
Message-ID: <1409242175.2696.108.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper
 functions
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Thu, 28 Aug 2014 18:09:35 +0200
In-Reply-To: <2323863.aLBeKZnVsL@avalon>
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
	 <1684313.SfePcxMsjg@avalon>
	 <1409131814.3623.40.camel@paszta.hi.pengutronix.de>
	 <2323863.aLBeKZnVsL@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Am Donnerstag, den 28.08.2014, 14:24 +0200 schrieb Laurent Pinchart:
> > A driver could then do the following:
> > 
> > static struct v4l2_pixfmt_info driver_formats[] = {
> > 	{ .pixelformat = V4L2_PIX_FMT_YUYV },
> > 	{ .pixelformat = V4L2_PIX_FMT_YUV420 },
> > };
> > 
> > int driver_probe(...)
> > {
> > 	...
> > 	v4l2_init_pixfmt_array(driver_formats,
> > 			ARRAY_SIZE(driver_formats));
> > 	...
> > }
> 
> Good question. This option consumes more memory, and prevents the driver-
> specific format info arrays to be const, which bothers me a bit.

Also, this wouldn't help drivers that don't want to take these
additional steps, which probably includes a lot of camera drivers with
only a few formats.

> On the other hand it allows drivers to override some of the default
> values for odd cases.

Hm, but those cases don't have to use the v4l2_pixfmt_info at all.

> I won't nack this approach, but I'm wondering whether a better
> solution wouldn't be possible. Hans, Mauro, Guennadi, any opinion ?

We could keep the global v4l2_pixfmt_info array sorted by fourcc value
and do a binary search (would have to be kept in mind when adding new
formats) or build a hash table (more complicated code, consumes memory).

regards
Philipp


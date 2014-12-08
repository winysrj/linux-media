Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38405 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaLHAQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 19:16:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by get/set_selection
Date: Mon, 08 Dec 2014 02:17:11 +0200
Message-ID: <1777193.G4Ej6mIZTU@avalon>
In-Reply-To: <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl> <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 03 December 2014 13:06:00 Sakari Ailus wrote:
> On Tue, Dec 02, 2014 at 01:21:40PM +0100, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The crop and selection pad ops are duplicates. Replace all uses of
> > get/set_crop by get/set_selection. This will make it possible to drop
> > get/set_crop altogether.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> 
> For both:
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Another point I'd like to draw attention to are the reserved fields --- some
> drivers appear to zero them whereas some pay no attention. Shouldn't we
> check in the sub-device IOCTL handler that the user has zeroed them, or
> zero them for the user? I think this has probably been discussed before on
> V4L2. Both have their advantages, probably zeroing them in the framework
> would be the best option. What do you think?

I think we should at least be consistent across drivers. Duplicating checks 
across drivers being more error-prone it would likely be better to implement 
them in core code. The question that remains to be answered is whether we can 
consider that bridge drivers will correctly zero reserved fields when using 
the API internally. If not, we'll need wrapper functions around subdev 
operations to zero reserved fields, or possibly just to output a WARN_ON (as a 
bridge driver bug should be fixed instead of silently ignored).

> Definitely out of scope of this set.

-- 
Regards,

Laurent Pinchart


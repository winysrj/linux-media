Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44320 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaLHB17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Dec 2014 20:27:59 -0500
Date: Mon, 8 Dec 2014 03:27:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 1/2] v4l2 subdevs: replace get/set_crop by
 get/set_selection
Message-ID: <20141208012752.GG15559@valkosipuli.retiisi.org.uk>
References: <1417522901-43604-1-git-send-email-hverkuil@xs4all.nl>
 <20141203110559.GE14746@valkosipuli.retiisi.org.uk>
 <1777193.G4Ej6mIZTU@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1777193.G4Ej6mIZTU@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Dec 08, 2014 at 02:17:11AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wednesday 03 December 2014 13:06:00 Sakari Ailus wrote:
> > On Tue, Dec 02, 2014 at 01:21:40PM +0100, Hans Verkuil wrote:
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > The crop and selection pad ops are duplicates. Replace all uses of
> > > get/set_crop by get/set_selection. This will make it possible to drop
> > > get/set_crop altogether.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> > > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > 
> > For both:
> > 
> > Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Another point I'd like to draw attention to are the reserved fields --- some
> > drivers appear to zero them whereas some pay no attention. Shouldn't we
> > check in the sub-device IOCTL handler that the user has zeroed them, or
> > zero them for the user? I think this has probably been discussed before on
> > V4L2. Both have their advantages, probably zeroing them in the framework
> > would be the best option. What do you think?
> 
> I think we should at least be consistent across drivers. Duplicating checks 
> across drivers being more error-prone it would likely be better to implement 
> them in core code. The question that remains to be answered is whether we can 
> consider that bridge drivers will correctly zero reserved fields when using 
> the API internally. If not, we'll need wrapper functions around subdev 
> operations to zero reserved fields, or possibly just to output a WARN_ON (as a 
> bridge driver bug should be fixed instead of silently ignored).

I'd simply check these fields in v4l2-subdev.c ioctl wrappers.

There are over 300 instances of v4l2_subdev_call(). It's at least possible
to audit them. I'd favour that over adding a wrapper to each op, and then
paying attention to the topic in reviews. It's not only a matter of that
interface.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3DVMHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 08:07:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 05/24] V4L2: allow dummy file-handle initialisation by v4l2_fh_init()
Date: Mon, 22 Apr 2013 14:07:11 +0200
Message-ID: <11296863.GS8qmyLFH3@avalon>
In-Reply-To: <201304190922.50517.hverkuil@xs4all.nl>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de> <1366320945-21591-6-git-send-email-g.liakhovetski@gmx.de> <201304190922.50517.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 19 April 2013 09:22:50 Hans Verkuil wrote:
> On Thu April 18 2013 23:35:26 Guennadi Liakhovetski wrote:
> > v4l2_fh_init() can be used to initialise dummy file-handles with vdev ==
> > NULL.
> 
> Why would you want that?

The reason is that subdev pad operations require a file handle and use it as a 
context to store the try rectangles. The wrappers thus need to create a dummy 
file handle.

> Anyway, this would definitely have to be documented as well in v4l2-fh.h.
> 
> I'm still going through your patch series so there may be a good reason
> for allowing this, but it definitely doesn't make me happy.
> 
> Regards,
> 
> 	Hans
> 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-fh.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-fh.c
> > b/drivers/media/v4l2-core/v4l2-fh.c index e57c002..7ae608b 100644
> > --- a/drivers/media/v4l2-core/v4l2-fh.c
> > +++ b/drivers/media/v4l2-core/v4l2-fh.c
> > @@ -33,10 +33,12 @@
> > 
> >  void v4l2_fh_init(struct v4l2_fh *fh, struct video_device *vdev)
> >  {
> >  
> >  	fh->vdev = vdev;
> > 
> > -	/* Inherit from video_device. May be overridden by the driver. */
> > -	fh->ctrl_handler = vdev->ctrl_handler;
> > +	if (vdev) {
> > +		/* Inherit from video_device. May be overridden by the driver. */
> > +		fh->ctrl_handler = vdev->ctrl_handler;
> > +		set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
> > +	}
> > 
> >  	INIT_LIST_HEAD(&fh->list);
> > 
> > -	set_bit(V4L2_FL_USES_V4L2_FH, &fh->vdev->flags);
> > 
> >  	fh->prio = V4L2_PRIORITY_UNSET;
> >  	init_waitqueue_head(&fh->wait);
> >  	INIT_LIST_HEAD(&fh->available);
-- 
Regards,

Laurent Pinchart


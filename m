Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56861 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2KWM3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 07:29:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 6/6] uvcvideo: Add VIDIOC_[GS]_PRIORITY support
Date: Fri, 23 Nov 2012 13:30:55 +0100
Message-ID: <1571163.sdKFpUlEDA@avalon>
In-Reply-To: <201211161507.42201.hverkuil@xs4all.nl>
References: <1348758980-21683-1-git-send-email-laurent.pinchart@ideasonboard.com> <1348758980-21683-7-git-send-email-laurent.pinchart@ideasonboard.com> <201211161507.42201.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Friday 16 November 2012 15:07:42 Hans Verkuil wrote:
> On Thu September 27 2012 17:16:20 Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c |    3 ++
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   45 +++++++++++++++++++++++++++++++
> >  drivers/media/usb/uvc/uvcvideo.h   |    1 +
> >  3 files changed, 49 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index ae24f7d..22f14d2 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c

[snip]

> > @@ -1722,6 +1723,8 @@ static int uvc_register_video(struct uvc_device
> > *dev,
> >  	vdev->v4l2_dev = &dev->vdev;
> >  	vdev->fops = &uvc_fops;
> >  	vdev->release = uvc_release;
> > +	vdev->prio = &stream->chain->prio;
> > +	set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
> 
> This set_bit() doesn't do anything as long as you are not using
> video_ioctl2().

The bit also makes v4l2_fh_(add|del)() call v4l2_prio_(open|close)().

> And why aren't you using video_ioctl2()? This is the last driver to do it
> all manually. If you'd switch to video_ioctl2(), then setting this bit would
> be all you had to do.

I have a patch for that, I need to resurect it.

> >  	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> >  		vdev->vfl_dir = VFL_DIR_TX;
> >  	
> >  	strlcpy(vdev->name, dev->name, sizeof vdev->name);
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index bf9d073..d6aa402 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c

[snip]

> This patch is hard to read since I can't see for which ioctls you check the
> prio. Can you regenerate the patch with more context lines? The patch as it
> is will probably not apply reliably due to the same reason.

My bad. I'll resend it.

> In particular, make sure you also check for the UVC-specific ioctls
> (UVCIOC_CTRL_MAP might need this, but I'm not sure about that).

The UVC-specific ioctls are only control operations, they don't require 
priority handling.

-- 
Regards,

Laurent Pinchart


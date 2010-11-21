Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40781 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0KUVpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 16:45:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/5] uvcvideo: Lock controls mutex when querying menus
Date: Sun, 21 Nov 2010 22:45:48 +0100
Cc: linux-media@vger.kernel.org
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com> <1290371573-14907-2-git-send-email-laurent.pinchart@ideasonboard.com> <201011212218.41564.hverkuil@xs4all.nl>
In-Reply-To: <201011212218.41564.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011212245.49540.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

Thanks for the comment.

On Sunday 21 November 2010 22:18:41 Hans Verkuil wrote:
> On Sunday, November 21, 2010 21:32:49 Laurent Pinchart wrote:
> > uvc_find_control() must be called with the controls mutex locked. Fix
> > uvc_query_v4l2_menu() accordingly.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/uvc/uvc_ctrl.c |   48
> >  +++++++++++++++++++++++++++++++++++- drivers/media/video/uvc/uvc_v4l2.c
> >  |   36 +-------------------------- drivers/media/video/uvc/uvcvideo.h |
> >     4 +-
> >  3 files changed, 50 insertions(+), 38 deletions(-)
> > 
> > diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> > b/drivers/media/video/uvc/uvc_ctrl.c index f169f77..59f8a9a 100644
> > --- a/drivers/media/video/uvc/uvc_ctrl.c
> > +++ b/drivers/media/video/uvc/uvc_ctrl.c
> > @@ -785,7 +785,7 @@ static void __uvc_find_control(struct uvc_entity
> > *entity, __u32 v4l2_id,
> > 
> >  	}
> >  
> >  }
> > 
> > -struct uvc_control *uvc_find_control(struct uvc_video_chain *chain,
> > +static struct uvc_control *uvc_find_control(struct uvc_video_chain
> > *chain,
> > 
> >  	__u32 v4l2_id, struct uvc_control_mapping **mapping)
> >  
> >  {
> >  
> >  	struct uvc_control *ctrl = NULL;
> > 
> > @@ -944,6 +944,52 @@ done:
> >  	return ret;
> >  
> >  }
> > 
> > +/*
> > + * Mapping V4L2 controls to UVC controls can be straighforward if done
> > well. + * Most of the UVC controls exist in V4L2, and can be mapped
> > directly. Some + * must be grouped (for instance the Red Balance, Blue
> > Balance and Do White + * Balance V4L2 controls use the White Balance
> > Component UVC control) or + * otherwise translated. The approach we take
> > here is to use a translation + * table for the controls that can be
> > mapped directly, and handle the others + * manually.
> > + */
> > +int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
> > +	struct v4l2_querymenu *query_menu)
> > +{
> > +	struct uvc_menu_info *menu_info;
> > +	struct uvc_control_mapping *mapping;
> > +	struct uvc_control *ctrl;
> > +	u32 index = query_menu->index;
> > +	u32 id = query_menu->id;
> > +	int ret;
> > +
> > +	memset(query_menu, 0, sizeof(*query_menu));
> > +	query_menu->id = id;
> > +	query_menu->index = index;
> > +
> > +	ret = mutex_lock_interruptible(&chain->ctrl_mutex);
> > +	if (ret < 0)
> > +		return -ERESTARTSYS;
> 
> Just return 'ret' here (which is -EINTR).

Hmmm... The uvcvideo driver uses -ERESTARTSYS extensively. What's the 
rationale behind using -EINTR instead ? Allowing users to interrupt the ioctl 
with ctrl-C ? If so, I wonder if it's worth it in this case, as the controls 
mutex will not be locked by another thread for an extensive period of time 
anyway.

ERESTARTSYS is meant to be used to deliver signals to application right away 
and then restart the system call. With EINTR applications would see an error 
in response to a VIDIOC_QUERYMENU call if SIGALRM arrives at the same time. I 
don't think that's something we want.

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36507 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0GLLhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jul 2010 07:37:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC/PATCH v2 6/7] v4l: subdev: Events support
Date: Mon, 12 Jul 2010 13:37:24 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1278689512-30849-1-git-send-email-laurent.pinchart@ideasonboard.com> <4C387CDB.2030308@redhat.com> <4C3AF73A.5010207@maxwell.research.nokia.com>
In-Reply-To: <4C3AF73A.5010207@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121337.26689.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 12 July 2010 13:06:34 Sakari Ailus wrote:
> Mauro Carvalho Chehab wrote:
> > Em 09-07-2010 12:31, Laurent Pinchart escreveu:

[snip]

> >> diff --git a/drivers/media/video/v4l2-subdev.c
> >> b/drivers/media/video/v4l2-subdev.c index 0ebd760..31bec67 100644
> >> --- a/drivers/media/video/v4l2-subdev.c
> >> +++ b/drivers/media/video/v4l2-subdev.c
> >> @@ -18,26 +18,64 @@

[snip]

> >> 
> >>  static int subdev_open(struct file *file)
> >>  {
> >>  
> >>  	struct video_device *vdev = video_devdata(file);
> >>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> >> 
> >> +	struct v4l2_fh *vfh;
> >> +	int ret;
> >> 
> >>  	if (!sd->initialized)
> >>  	
> >>  		return -EAGAIN;
> >> 
> >> +	vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
> >> +	if (vfh == NULL)
> >> +		return -ENOMEM;
> >> +
> >> +	ret = v4l2_fh_init(vfh, vdev);
> >> +	if (ret)
> >> +		goto err;
> > 
> > Why to allocate/init the file handler for devices that don't need it?
> > I would just move the above logic to happen only if
> > V4L2_SUBDEV_FL_HAS_EVENTS.
> 
> This patch actually adds subdev support for V4L2 file handles AND
> events. v4l2_fh is also used to support probe formats on subdevs (not
> contained in this patchset).
> 
> That v4l2_fh_init() function just initialises a few fields, there is no
> allocation being done. The v4l2_fh structure will be part of
> v4l2_subdev_fh:
> 
> struct v4l2_subdev_fh {
>         struct v4l2_fh vfh;
>         struct v4l2_mbus_framefmt *probe_fmt;
>         struct v4l2_rect *probe_crop;
> };
> 
> (Again not yet in this patchset.) The probe formats are a new concept to
> allow trying formats across the whole pipeline for which the old try_fmt
> wasn't suitable for: memory vs. bus format and pads matter.

Mauro's point was that v4l2_fh isn't needed if the subdev doesn't support 
events. subdev_fh will likely be mandatory, but that's for a future patch, so 
I can make the v4l2_fh allocation optional for now.

[snip]

> >> @@ -68,6 +107,18 @@ static long subdev_do_ioctl(struct file *file,
> >> unsigned int cmd, void *arg)
> >> 
> >>  	case VIDIOC_TRY_EXT_CTRLS:
> >>  		return v4l2_subdev_call(sd, core, try_ext_ctrls, arg);
> >> 
> >> +	case VIDIOC_DQEVENT:
> >> +		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
> >> +			return -ENOIOCTLCMD;
> >> +
> >> +		return v4l2_event_dequeue(fh, arg, file->f_flags & O_NONBLOCK);
> >> +
> >> +	case VIDIOC_SUBSCRIBE_EVENT:
> >> +		return v4l2_subdev_call(sd, core, subscribe_event, fh, arg);
> >> +
> >> +	case VIDIOC_UNSUBSCRIBE_EVENT:
> >> +		return v4l2_subdev_call(sd, core, unsubscribe_event, fh, arg);
> > 
> > Hmm... shouldn't it test also for V4L2_SUBDEV_FL_HAS_EVENTS?
> > 
> > I would do, instead:
> > 	if (fh) {
> > 	
> > 		switch(cmd) {
> > 		
> > 			/* FH events logic */
> > 		
> > 		}
> > 	
> > 	}
> 
> No need to. If the subdev doesn't support events it likely should not
> define handlers for event specific calls, right? v4l2_subdev_call()
> behaves well if the handler is NULL.
> 
> Both would work equally well, I guess.

The check in v4l2_subdev_call is fine, I don't think we need another check.

-- 
Regards,

Laurent Pinchart

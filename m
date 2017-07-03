Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34112 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdGCSgf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 14:36:35 -0400
Received: by mail-qt0-f195.google.com with SMTP id m54so21935251qtb.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 11:36:35 -0700 (PDT)
Date: Mon, 3 Jul 2017 15:36:31 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 07/12] [media] v4l: add support to BUF_QUEUED event
Message-ID: <20170703183631.GB3337@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-8-gustavo@padovan.org>
 <20170630090450.1f390658@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630090450.1f390658@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

2017-06-30 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Fri, 16 Jun 2017 16:39:10 +0900
> Gustavo Padovan <gustavo@padovan.org> escreveu:
> 
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Implement the needed pieces to let userspace subscribe for
> > V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
> > DQEVENT ioctl.
> > 
> > Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
> >  drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++++
> >  2 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> > index 5aed7bd..f55b5da 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -3435,8 +3435,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
> >  int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
> >  				const struct v4l2_event_subscription *sub)
> >  {
> > -	if (sub->type == V4L2_EVENT_CTRL)
> > +	switch (sub->type) {
> > +	case V4L2_EVENT_CTRL:
> >  		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
> > +	case V4L2_EVENT_BUF_QUEUED:
> > +		return v4l2_event_subscribe(fh, sub, 0, NULL);
> > +	}
> >  	return -EINVAL;
> >  }
> >  EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > index 29aa9d4..00d9c35 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/kthread.h>
> >  
> >  #include <media/videobuf2-core.h>
> > +#include <media/v4l2-event.h>
> >  #include <media/v4l2-mc.h>
> >  
> >  #include <trace/events/vb2.h>
> > @@ -1221,6 +1222,18 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> >  	return ret;
> >  }
> >  
> > +static void vb2_buffer_queued_event(struct vb2_buffer *vb)
> > +{
> > +	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
> > +	struct v4l2_event event;
> > +
> > +	memset(&event, 0, sizeof(event));
> > +	event.type = V4L2_EVENT_BUF_QUEUED;
> > +	event.u.buf_queued.index = vb->index;
> > +
> > +	v4l2_event_queue(vdev, &event);
> > +}
> > +
> 
> It doesn't sound right to add a V4L2 event to VB2 core. The hole point
> of splitting the core from V4L2 specific stuff is to allow VB2 to be
> used by non-V4L2 APIs[1]. Please move this to videobuf2-v4l2.

Yes, that makes sense.  My lack of understanding of v4l2 core didn't me
allow realize that. I'll move it to videobuf2-v4l2.

Gustavo

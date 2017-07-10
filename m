Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35712 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbdGJTqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:46:11 -0400
Received: by mail-qk0-f196.google.com with SMTP id 16so14195771qkg.2
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 12:46:11 -0700 (PDT)
Date: Mon, 10 Jul 2017 16:45:36 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 07/12] [media] v4l: add support to BUF_QUEUED event
Message-ID: <20170710194536.GJ10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-8-gustavo@padovan.org>
 <20170630090450.1f390658@vento.lan>
 <491c5d13-e04a-5dc7-2e85-d25939d02190@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491c5d13-e04a-5dc7-2e85-d25939d02190@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-06 Hans Verkuil <hverkuil@xs4all.nl>:

> On 06/30/17 14:04, Mauro Carvalho Chehab wrote:
> > Em Fri, 16 Jun 2017 16:39:10 +0900
> > Gustavo Padovan <gustavo@padovan.org> escreveu:
> > 
> >> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> >>
> >> Implement the needed pieces to let userspace subscribe for
> >> V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
> >> DQEVENT ioctl.
> >>
> >> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
> >>  drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++++
> >>  2 files changed, 20 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> index 5aed7bd..f55b5da 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> >> @@ -3435,8 +3435,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
> >>  int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
> >>  				const struct v4l2_event_subscription *sub)
> >>  {
> >> -	if (sub->type == V4L2_EVENT_CTRL)
> >> +	switch (sub->type) {
> >> +	case V4L2_EVENT_CTRL:
> >>  		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
> >> +	case V4L2_EVENT_BUF_QUEUED:
> >> +		return v4l2_event_subscribe(fh, sub, 0, NULL);
> >> +	}
> >>  	return -EINVAL;
> >>  }
> >>  EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
> >> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> >> index 29aa9d4..00d9c35 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >> @@ -25,6 +25,7 @@
> >>  #include <linux/kthread.h>
> >>  
> >>  #include <media/videobuf2-core.h>
> >> +#include <media/v4l2-event.h>
> >>  #include <media/v4l2-mc.h>
> >>  
> >>  #include <trace/events/vb2.h>
> >> @@ -1221,6 +1222,18 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> >>  	return ret;
> >>  }
> >>  
> >> +static void vb2_buffer_queued_event(struct vb2_buffer *vb)
> >> +{
> >> +	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
> >> +	struct v4l2_event event;
> >> +
> >> +	memset(&event, 0, sizeof(event));
> >> +	event.type = V4L2_EVENT_BUF_QUEUED;
> >> +	event.u.buf_queued.index = vb->index;
> >> +
> >> +	v4l2_event_queue(vdev, &event);
> >> +}
> >> +
> > 
> > It doesn't sound right to add a V4L2 event to VB2 core. The hole point
> > of splitting the core from V4L2 specific stuff is to allow VB2 to be
> > used by non-V4L2 APIs[1]. Please move this to videobuf2-v4l2.
> 
> Good point. So this should be a callback to the higher level.
> 
> One thing I was wondering about: v4l2_event_queue sends the event to all
> open filehandles of the video node that subscribed to this event. Is that
> what we want? Or should we use v4l2_event_queue_fh to only send it to the
> vb2 queue owner? I don't know what is best. I think it is OK to send it
> to anyone that is interested. If nothing else it will help debugging.

I don't have any preference here, I'll keep it as is - sending events to
anyone - if no one objects.

	Gustavo

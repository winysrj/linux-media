Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58784
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751941AbdF3ME7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 08:04:59 -0400
Date: Fri, 30 Jun 2017 09:04:50 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 07/12] [media] v4l: add support to BUF_QUEUED event
Message-ID: <20170630090450.1f390658@vento.lan>
In-Reply-To: <20170616073915.5027-8-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
        <20170616073915.5027-8-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 16:39:10 +0900
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Implement the needed pieces to let userspace subscribe for
> V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
> DQEVENT ioctl.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
>  drivers/media/v4l2-core/videobuf2-core.c | 15 +++++++++++++++
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 5aed7bd..f55b5da 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3435,8 +3435,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
>  int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
>  				const struct v4l2_event_subscription *sub)
>  {
> -	if (sub->type == V4L2_EVENT_CTRL)
> +	switch (sub->type) {
> +	case V4L2_EVENT_CTRL:
>  		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
> +	case V4L2_EVENT_BUF_QUEUED:
> +		return v4l2_event_subscribe(fh, sub, 0, NULL);
> +	}
>  	return -EINVAL;
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 29aa9d4..00d9c35 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -25,6 +25,7 @@
>  #include <linux/kthread.h>
>  
>  #include <media/videobuf2-core.h>
> +#include <media/v4l2-event.h>
>  #include <media/v4l2-mc.h>
>  
>  #include <trace/events/vb2.h>
> @@ -1221,6 +1222,18 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>  	return ret;
>  }
>  
> +static void vb2_buffer_queued_event(struct vb2_buffer *vb)
> +{
> +	struct video_device *vdev = to_video_device(vb->vb2_queue->dev);
> +	struct v4l2_event event;
> +
> +	memset(&event, 0, sizeof(event));
> +	event.type = V4L2_EVENT_BUF_QUEUED;
> +	event.u.buf_queued.index = vb->index;
> +
> +	v4l2_event_queue(vdev, &event);
> +}
> +

It doesn't sound right to add a V4L2 event to VB2 core. The hole point
of splitting the core from V4L2 specific stuff is to allow VB2 to be
used by non-V4L2 APIs[1]. Please move this to videobuf2-v4l2.

[1] The split happened as part of a patchset meant to make the DVB
core to use VB2 and provide DMA APIs to it. Unfortunately, the
developer that worked on this project moved to some other project.
The final patch was not applied yet. I have it on my patchwork
queue. I intend to test and apply it sometime this year.



>  /**
>   * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>   */
> @@ -1234,6 +1247,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  	trace_vb2_buf_queue(q, vb);
>  
>  	call_void_vb_qop(vb, buf_queue, vb);
> +
> +	vb2_buffer_queued_event(vb);
>  }
>  
>  static int __buf_prepare(struct vb2_buffer *vb, const void *pb)


-- 
Thanks,
Mauro

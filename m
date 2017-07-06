Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38579 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751936AbdGFIrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 04:47:40 -0400
Subject: Re: [PATCH 07/12] [media] v4l: add support to BUF_QUEUED event
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-8-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0bda4b2f-dac7-88ae-1b03-dff106b87444@xs4all.nl>
Date: Thu, 6 Jul 2017 10:47:33 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-8-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
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

This is dangerous. The '0' argument will only allocate room for a single
BUF_QUEUED event. So if two such events are triggered without the application
reading the first event, then the first event will be lost.

I recommend VIDEO_MAX_FRAME instead. I.e. have room for up to the maximum number
of buffers.

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
> 

Regards,

	Hans

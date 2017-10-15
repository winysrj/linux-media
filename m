Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45044 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750896AbdJOVZo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 17:25:44 -0400
Date: Mon, 16 Oct 2017 00:25:41 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH v2 08/14] [media] v4l: add support to BUF_QUEUED event
Message-ID: <20171015212540.ddbnof2gy2mmqmmi@valkosipuli.retiisi.org.uk>
References: <20170901015041.7757-1-gustavo@padovan.org>
 <20170901015041.7757-9-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170901015041.7757-9-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

On Thu, Aug 31, 2017 at 10:50:35PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Implement the needed pieces to let userspace subscribe for
> V4L2_EVENT_BUF_QUEUED events. Videobuf2 will queue the event for the
> DQEVENT ioctl.
> 
> v3:	- Do not call v4l2 event API from vb2 (Mauro)
> 
> v2:	- Use VIDEO_MAX_FRAME to allocate room for events at
> 	v4l2_event_subscribe() (Hans)
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c     |  6 +++++-
>  drivers/media/v4l2-core/videobuf2-core.c |  2 ++
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 13 +++++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index dd1db678718c..17d4b9e3eec6 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -3438,8 +3438,12 @@ EXPORT_SYMBOL(v4l2_ctrl_log_status);
>  int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
>  				const struct v4l2_event_subscription *sub)
>  {
> -	if (sub->type == V4L2_EVENT_CTRL)
> +	switch (sub->type) {
> +	case V4L2_EVENT_CTRL:
>  		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
> +	case V4L2_EVENT_BUF_QUEUED:
> +		return v4l2_event_subscribe(fh, sub, VIDEO_MAX_FRAME, NULL);

While I think this is probably the correct place to add the event
subscription handling, the name of the function no longer corresponds what
it does, nor it belongs to v4l2-ctrls.c.

v4l2_ctrl_subscribe_event() is also used for subscribing control events on
sub-devices. BUF_QUEUED events will be available only on video nodes.

BUF_QUEUED events presumably should be availble on all video nodes that
support V4L2_CAP_STREAMING capability. Perhaps this could be handled by
moving v4l2_ctrl_subscribe_event() to v4l2-event.c and renaming it e.g.
v4l2_event_subscribe_v4l2(), for these events originate from specific
conditions the V4L2 framework is aware of.
v4l2_ctrl_subdev_subscribe_event() handling needs to be addressed as well.

A separate patch would be nice. 

> +	}
>  	return -EINVAL;
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_subscribe_event);
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b19c1bc4b083..bbbae0eed567 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1231,6 +1231,8 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  	trace_vb2_buf_queue(q, vb);
>  
>  	call_void_vb_qop(vb, buf_queue, vb);
> +
> +	call_void_bufop(q, buffer_queued, vb);
>  }
>  
>  static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 8c322cd1b346..1c93bfedaffc 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -138,6 +138,18 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
>  	}
>  };
>  
> +static void __buffer_queued(struct vb2_buffer *vb)
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
>  static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  {
>  	static bool check_once;
> @@ -455,6 +467,7 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>  	.fill_user_buffer	= __fill_v4l2_buffer,
>  	.fill_vb2_buffer	= __fill_vb2_buffer,
>  	.copy_timestamp		= __copy_timestamp,
> +	.buffer_queued		= __buffer_queued,
>  };
>  
>  /**

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

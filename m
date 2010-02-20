Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2893 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0BTJyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 04:54:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
Date: Sat, 20 Feb 2010 10:56:56 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <1266607320-9974-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1266607320-9974-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201056.56952.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More comments...

On Friday 19 February 2010 20:21:59 Sakari Ailus wrote:
> Add support for event handling to do_ioctl.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   58 ++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-ioctl.h       |    7 ++++
>  2 files changed, 65 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 34c7d6e..f7d6177 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -25,6 +25,8 @@
>  #endif
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
>  #include <media/v4l2-chip-ident.h>
>  
>  #define dbgarg(cmd, fmt, arg...) \
> @@ -1944,7 +1946,63 @@ static long __video_do_ioctl(struct file *file,
>  		}
>  		break;
>  	}
> +	case VIDIOC_DQEVENT:
> +	{
> +		struct v4l2_event *ev = arg;
> +		struct v4l2_fh *vfh = fh;
> +
> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)
> +		    || vfh->events == NULL)
> +			break;

Change this to:

		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
			break;
		if (vfh->events == NULL)
			return -ENOENT;

But see also the next comment.

> +
> +		ret = v4l2_event_dequeue(fh, ev);

There is a crucial piece of functionality missing here: if the filehandle is
in blocking mode, then it should wait until an event arrives. That also means
that if vfh->events == NULL, you should still call v4l2_event_dequeue, and
that function should initialize vfh->events and wait for an event if the fh
is in blocking mode.

So I would remove the events == NULL test here and just call v4l2_event_dequeue
and let that function handle it.

> +		if (ret < 0) {
> +			dbgarg(cmd, "no pending events?");
> +			break;
> +		}
> +		dbgarg(cmd,
> +		       "pending=%d, type=0x%8.8x, sequence=%d, "
> +		       "timestamp=%lu.%9.9lu ",
> +		       ev->pending, ev->type, ev->sequence,
> +		       ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
> +		break;
> +	}
> +	case VIDIOC_SUBSCRIBE_EVENT:
> +	{
> +		struct v4l2_event_subscription *sub = arg;
> +		struct v4l2_fh *vfh = fh;
>  
> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)

Testing for this bit is unnecessarily. Just test for ops->vidioc_subscribe_event.

> +		    || vfh->events == NULL

Remove this test. If you allocate the event queue only when you first
subscribe to an event (as ivtv will do), then you have to be able to
call vidioc_subscribe_event even if vfh->events == NULL.

> +		    || !ops->vidioc_subscribe_event)
> +			break;
> +
> +		ret = ops->vidioc_subscribe_event(fh, sub);
> +		if (ret < 0) {
> +			dbgarg(cmd, "failed, ret=%ld", ret);
> +			break;
> +		}
> +		dbgarg(cmd, "type=0x%8.8x", sub->type);
> +		break;
> +	}
> +	case VIDIOC_UNSUBSCRIBE_EVENT:
> +	{
> +		struct v4l2_event_subscription *sub = arg;
> +		struct v4l2_fh *vfh = fh;
> +
> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)
> +		    || vfh->events == NULL
> +		    || !ops->vidioc_unsubscribe_event)

No need for the test_bit. This is sufficient:

		if (!ops->vidioc_unsubscribe_event ||
		    vfh->events == NULL)

Note that I am not so keen on testing against vfh->events here. I consider
this a v4l2_fh-internal field that should not be used outside the v4l2_event_
and v4l2_fh_ functions.

> +			break;
> +
> +		ret = ops->vidioc_unsubscribe_event(fh, sub);
> +		if (ret < 0) {
> +			dbgarg(cmd, "failed, ret=%ld", ret);
> +			break;
> +		}
> +		dbgarg(cmd, "type=0x%8.8x", sub->type);
> +		break;
> +	}
>  	default:
>  	{
>  		if (!ops->vidioc_default)
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index e8ba0f2..06daa6e 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -21,6 +21,8 @@
>  #include <linux/videodev2.h>
>  #endif
>  
> +struct v4l2_fh;
> +
>  struct v4l2_ioctl_ops {
>  	/* ioctl callbacks */
>  
> @@ -254,6 +256,11 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_g_dv_timings) (struct file *file, void *fh,
>  				    struct v4l2_dv_timings *timings);
>  
> +	int (*vidioc_subscribe_event)  (struct v4l2_fh *fh,
> +					struct v4l2_event_subscription *sub);
> +	int (*vidioc_unsubscribe_event)(struct v4l2_fh *fh,
> +					struct v4l2_event_subscription *sub);
> +
>  	/* For other private ioctls */
>  	long (*vidioc_default)	       (struct file *file, void *fh,
>  					int cmd, void *arg);
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2982 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab0ARM6P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 07:58:15 -0500
Date: Mon, 18 Jan 2010 13:58:09 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 5/7] V4L: Events: Limit event queue length
In-Reply-To: <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Message-ID: <alpine.LNX.2.01.1001181348540.31857@alastor>
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

More comments:

On Tue, 22 Dec 2009, Sakari Ailus wrote:

> Limit event queue length to V4L2_MAX_EVENTS. If the queue is full any
> further events will be dropped.
>
> This patch also updates the count field properly, setting it to exactly to
> number of further available events.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
> drivers/media/video/v4l2-event.c |   10 +++++++++-
> include/media/v4l2-event.h       |    5 +++++
> 2 files changed, 14 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 9fc0c81..72fdf7f 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -56,6 +56,8 @@ void v4l2_event_init_fh(struct v4l2_fh *fh)
>
> 	INIT_LIST_HEAD(&events->available);
> 	INIT_LIST_HEAD(&events->subscribed);
> +
> +	atomic_set(&events->navailable, 0);
> }
> EXPORT_SYMBOL_GPL(v4l2_event_init_fh);
>
> @@ -103,7 +105,8 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
> 	ev = list_first_entry(&events->available, struct _v4l2_event, list);
> 	list_del(&ev->list);
>
> -	ev->event.count = !list_empty(&events->available);
> +	atomic_dec(&events->navailable);
> +	ev->event.count = atomic_read(&events->navailable);

Combine these two lines to atomic_dec_return().

>
> 	spin_unlock_irqrestore(&events->lock, flags);
>
> @@ -159,6 +162,9 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> 		if (!v4l2_event_subscribed(fh, ev->type))
> 			continue;
>
> +		if (atomic_read(&fh->events.navailable) >= V4L2_MAX_EVENTS)
> +			continue;
> +
> 		_ev = kmem_cache_alloc(event_kmem, GFP_ATOMIC);
> 		if (!_ev)
> 			continue;
> @@ -169,6 +175,8 @@ void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> 		list_add_tail(&_ev->list, &fh->events.available);
> 		spin_unlock(&fh->events.lock);
>
> +		atomic_inc(&fh->events.navailable);
> +
> 		wake_up_all(&fh->events.wait);
> 	}
>
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index b11de92..69305c6 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -28,6 +28,10 @@
> #include <linux/types.h>
> #include <linux/videodev2.h>
>
> +#include <asm/atomic.h>
> +
> +#define V4L2_MAX_EVENTS		1024 /* Ought to be enough for everyone. */

I think this should be programmable by the driver. Most drivers do not use
events at all, so by default it should be 0 or perhaps it can check whether
the ioctl callback structure contains the event ioctls and set it to 0 or
some initial default value.

And you want this to be controlled on a per-filehandle basis even. If I look
at ivtv, then most of the device nodes will not have events, only a few will
support events. And for one device node type I know that there will only be
a single event when stopping the streaming, while another device node type
will get an event each frame.

So being able to adjust the event queue dynamically will give more control
and prevent unnecessary waste of memory resources.

Regards,

 	Hans

> +
> struct v4l2_fh;
> struct video_device;
>
> @@ -39,6 +43,7 @@ struct _v4l2_event {
> struct v4l2_events {
> 	spinlock_t		lock; /* Protect everything here. */
> 	struct list_head	available;
> +	atomic_t		navailable;
> 	wait_queue_head_t	wait;
> 	struct list_head	subscribed; /* Subscribed events. */
> };
> -- 
> 1.5.6.5
>

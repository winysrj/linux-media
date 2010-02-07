Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1283 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab0BGMnT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 07:43:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 5/8] V4L: Events: Add backend
Date: Sun, 7 Feb 2010 13:45:16 +0100
Cc: linux-media@vger.kernel.org, hans.verkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com, iivanov@mm-sol.com
References: <4B6DAE5A.5090508@maxwell.research.nokia.com> <1265479331-20595-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1265479331-20595-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002071345.16968.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Once again, thanks for all the work you're doing on this! Very much appreciated!

As you requested, I've reviewed this code with special attention to refcounting
and locking.

In general, locking is hard, so the fewer locks there are, the easier it is
to get locking right and to maintain/understand the code. 

Currently you have a lock in v4l2_fhs (at the video_device level) and a lock and
a refcount in v4l2_fh.

In my opinion this causes more complexity than is needed. I think a single lock
in v4l2_fhs would suffice. This does mean that struct v4l2_fh needs a pointer
to video_device (which is a good idea anyway).

The only place where this locks more than is strictly necessary is the dequeue
function. On the other hand, the lock that is taken there is very short and
I prefer simplicity over unproven performance increases. I actually suspect
that all the complexity might introduce slower performance than slightly
sub-optimal locking. I have rewritten the queue and dequeue event functions
below to what I think should be done there. As you can see, they are now a lot
easier to understand and a lot shorter.

Regards,

	Hans

On Saturday 06 February 2010 19:02:08 Sakari Ailus wrote:
> Add event handling backend to V4L2. The backend handles event subscription
> and delivery to file handles. Event subscriptions are based on file handle.
> Events may be delivered to all subscribed file handles on a device
> independent of where they originate from.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/v4l2-event.c |  317 ++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/v4l2-fh.c    |    3 +
>  include/media/v4l2-event.h       |   64 ++++++++
>  include/media/v4l2-fh.h          |    1 +
>  4 files changed, 385 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-event.c
>  create mode 100644 include/media/v4l2-event.h
> 
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> new file mode 100644
> index 0000000..7ae763f
> --- /dev/null
> +++ b/drivers/media/video/v4l2-event.c
> @@ -0,0 +1,317 @@
> +/*
> + * drivers/media/video/v4l2-event.c
> + *
> + * V4L2 events.
> + *
> + * Copyright (C) 2009 Nokia Corporation.
> + *
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-event.h>
> +
> +#include <linux/sched.h>
> +
> +/* In error case, return number of events *not* allocated. */
> +int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n)
> +{
> +	struct v4l2_events *events = fh->events;
> +	unsigned long flags;
> +
> +	for (; n > 0; n--) {
> +		struct v4l2_kevent *kev;
> +
> +		kev = kzalloc(sizeof(*kev), GFP_KERNEL);
> +		if (kev == NULL)
> +			return n;
> +
> +		spin_lock_irqsave(&fh->lock, flags);
> +		list_add_tail(&kev->list, &events->free);
> +		spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	}
> +
> +	return n;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_alloc);
> +
> +void v4l2_event_exit(struct v4l2_fh *fh)
> +{
> +	struct v4l2_events *events = fh->events;
> +
> +	if (!events)
> +		return;
> +
> +	while (!list_empty(&events->free)) {
> +		struct v4l2_kevent *kev;
> +
> +		kev = list_first_entry(&events->free,
> +				       struct v4l2_kevent, list);
> +		list_del(&kev->list);
> +
> +		kfree(kev);
> +	}

This can be done cleaner via a static inline function to delete an event
list.

> +
> +	while (!list_empty(&events->available)) {
> +		struct v4l2_kevent *kev;
> +
> +		kev = list_first_entry(&events->available,
> +				       struct v4l2_kevent, list);
> +		list_del(&kev->list);
> +
> +		kfree(kev);
> +	}
> +
> +	while (!list_empty(&events->subscribed)) {
> +		struct v4l2_subscribed_event *sub;
> +
> +		sub = list_first_entry(&events->subscribed,
> +				       struct v4l2_subscribed_event, list);
> +
> +		list_del(&sub->list);
> +
> +		kfree(sub);
> +	}
> +
> +	kfree(events);
> +	fh->events = NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_exit);
> +
> +int v4l2_event_init(struct v4l2_fh *fh, unsigned int n)
> +{
> +	int ret;
> +
> +	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
> +	if (fh->events == NULL)
> +		return -ENOMEM;
> +
> +	init_waitqueue_head(&fh->events->wait);
> +
> +	INIT_LIST_HEAD(&fh->events->free);
> +	INIT_LIST_HEAD(&fh->events->available);
> +	INIT_LIST_HEAD(&fh->events->subscribed);
> +
> +	ret = v4l2_event_alloc(fh, n);
> +	if (ret < 0)
> +		v4l2_event_exit(fh);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_init);
> +
> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
> +{
> +	struct v4l2_events *events = fh->events;
> +	struct v4l2_kevent *kev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +
> +	if (list_empty(&events->available)) {
> +		spin_unlock_irqrestore(&fh->lock, flags);
> +		return -ENOENT;
> +	}
> +
> +	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
> +	list_del(&kev->list);
> +
> +	kev->event.count = !list_empty(&events->available);
> +
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	*event = kev->event;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +	list_add(&kev->list, &events->free);
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_dequeue);

int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
{
	struct v4l2_events *events = fh->events;
	struct v4l2_kevent *kev;
	unsigned long flags;

	spin_lock_irqsave(&fh->vdev->fhs.lock, flags);

	if (list_empty(&events->available)) {
		spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
		return -ENOENT;
	}

	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
	list_move(&kev->list, &events->free);

	kev->event.count = !list_empty(&events->available);

	*event = kev->event;

	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);

	return 0;
}

One possible optimization might be to do this (as you did in the original code):

	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
	list_del(&kev->list);
	kev->event.count = !list_empty(&events->available);
	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);

	*event = kev->event;

	spin_lock_irqsave(&fh->vdev->fhs.lock, flags);
	list_add(&kev->list, &events->free);
	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);

However, this would need some testing first to see what the performance
trade-off is between unlocking and locking vs. copying 120 bytes.

> +
> +static struct v4l2_subscribed_event *__v4l2_kevent_subscribed(
> +	struct v4l2_fh *fh, u32 type)
> +{
> +	struct v4l2_events *events = fh->events;
> +	struct v4l2_subscribed_event *sev;
> +
> +	list_for_each_entry(sev, &events->subscribed, list) {
> +		if (sev->type == type)
> +			return sev;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct v4l2_subscribed_event *v4l2_event_subscribed(
> +	struct v4l2_fh *fh, u32 type)
> +{
> +	struct v4l2_subscribed_event *sev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +
> +	sev = __v4l2_kevent_subscribed(fh, type);
> +
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	return sev;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_subscribed);
> +
> +void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> +{
> +	struct v4l2_fh *fh;
> +	unsigned long flags;
> +	struct v4l2_fh *put_me = NULL;
> +
> +	spin_lock_irqsave(&vdev->fhs.lock, flags);
> +
> +	list_for_each_entry(fh, &vdev->fhs.list, list) {
> +		struct v4l2_events *events = fh->events;
> +		struct v4l2_kevent *kev;
> +
> +		/* Is it subscribed? */
> +		if (!v4l2_event_subscribed(fh, ev->type))
> +			continue;
> +
> +		/* Can we get the file handle? */
> +		if (v4l2_fh_get(vdev, fh))
> +			continue;
> +
> +		/* List lock no longer required. */
> +		spin_unlock_irqrestore(&vdev->fhs.lock, flags);
> +
> +		/* Put earlier v4l2_fh. */
> +		if (put_me) {
> +			v4l2_fh_put(vdev, put_me);
> +			put_me = NULL;
> +		}
> +		put_me = fh;
> +
> +		/* Do we have any free events? */
> +		spin_lock_irqsave(&fh->lock, flags);
> +		if (list_empty(&events->free)) {
> +			spin_unlock_irqrestore(&fh->lock, flags);
> +			spin_lock_irqsave(&vdev->fhs.lock, flags);
> +			continue;
> +		}
> +
> +		/* Take one and fill it. */
> +		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
> +		list_del(&kev->list);
> +		spin_unlock_irqrestore(&fh->lock, flags);
> +
> +		kev->event = *ev;
> +
> +		/* And add to the available list. */
> +		spin_lock_irqsave(&fh->lock, flags);
> +		list_add_tail(&kev->list, &events->available);
> +		spin_unlock_irqrestore(&fh->lock, flags);
> +
> +		wake_up_all(&events->wait);
> +
> +		spin_lock_irqsave(&vdev->fhs.lock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
> +
> +	/* Put final v4l2_fh if exists. */
> +	if (put_me)
> +		v4l2_fh_put(vdev, put_me);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_queue);

void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
{
	struct v4l2_fh *fh;
	unsigned long flags;

	spin_lock_irqsave(&vdev->fhs.lock, flags);

	list_for_each_entry(fh, &vdev->fhs.list, list) {
		struct v4l2_events *events = fh->events;
		struct v4l2_kevent *kev;

		/* Do we have any free events and are we subscribed? */
		if (list_empty(&events->free) ||
		    !__v4l2_event_subscribed(fh, ev->type))
			continue;

		/* Take one and fill it. */
		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
		kev->event = *ev;
		list_move_tail(&kev->list, &events->available);

		wake_up_all(&events->wait);
	}

	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
}

> +
> +int v4l2_event_pending(struct v4l2_fh *fh)
> +{
> +	struct v4l2_events *events = fh->events;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +	ret = !list_empty(&events->available);
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_pending);
> +
> +int v4l2_event_subscribe(struct v4l2_fh *fh,
> +			 struct v4l2_event_subscription *sub)
> +{
> +	struct v4l2_events *events = fh->events;
> +	struct v4l2_subscribed_event *sev;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	/* Allow subscribing to valid events only. */
> +	if (sub->type < V4L2_EVENT_PRIVATE_START)
> +		switch (sub->type) {
> +		default:
> +			return -EINVAL;
> +		}
> +
> +	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
> +	if (!sev)
> +		return -ENOMEM;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +
> +	if (__v4l2_kevent_subscribed(fh, sub->type) != NULL) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	INIT_LIST_HEAD(&sev->list);
> +	sev->type = sub->type;
> +
> +	list_add(&sev->list, &events->subscribed);
> +
> +out:
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	if (ret)
> +		kfree(sev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
> +
> +int v4l2_event_unsubscribe(struct v4l2_fh *fh,
> +			   struct v4l2_event_subscription *sub)
> +{
> +	struct v4l2_subscribed_event *sev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fh->lock, flags);
> +
> +	sev = __v4l2_kevent_subscribed(fh, sub->type);
> +
> +	if (sev == NULL) {
> +		spin_unlock_irqrestore(&fh->lock, flags);
> +		return -EINVAL;
> +	}
> +
> +	list_del(&sev->list);
> +
> +	spin_unlock_irqrestore(&fh->lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> index 1728e1c..3bd40f8 100644
> --- a/drivers/media/video/v4l2-fh.c
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -24,6 +24,7 @@
>  
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
>  
>  void v4l2_fh_new(struct video_device *vdev, struct v4l2_fh *fh)
>  {
> @@ -54,6 +55,8 @@ void v4l2_fh_put(struct video_device *vdev, struct v4l2_fh *fh)
>  	spin_lock_irqsave(&vdev->fhs.lock, flags);
>  	list_del(&fh->list);
>  	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
> +
> +	v4l2_event_exit(fh);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fh_put);
>  
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> new file mode 100644
> index 0000000..580c9d4
> --- /dev/null
> +++ b/include/media/v4l2-event.h
> @@ -0,0 +1,64 @@
> +/*
> + * include/media/v4l2-event.h
> + *
> + * V4L2 events.
> + *
> + * Copyright (C) 2009 Nokia Corporation.
> + *
> + * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + */
> +
> +#ifndef V4L2_EVENT_H
> +#define V4L2_EVENT_H
> +
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +struct v4l2_fh;
> +struct video_device;
> +
> +struct v4l2_kevent {
> +	struct list_head	list;
> +	struct v4l2_event	event;
> +};
> +
> +struct v4l2_subscribed_event {
> +	struct list_head	list;
> +	u32			type;
> +};
> +
> +struct v4l2_events {
> +	wait_queue_head_t	wait;
> +	struct list_head	subscribed; /* Subscribed events */
> +	struct list_head	available; /* Dequeueable event */
> +	struct list_head	free; /* Events ready for use */
> +};
> +
> +int v4l2_event_alloc(struct v4l2_fh *fh, unsigned int n);
> +int v4l2_event_init(struct v4l2_fh *fh, unsigned int n);
> +void v4l2_event_exit(struct v4l2_fh *fh);
> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event);
> +struct v4l2_subscribed_event *v4l2_event_subscribed(
> +	struct v4l2_fh *fh, u32 type);
> +void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev);
> +int v4l2_event_pending(struct v4l2_fh *fh);
> +int v4l2_event_subscribe(struct v4l2_fh *fh,
> +			 struct v4l2_event_subscription *sub);
> +int v4l2_event_unsubscribe(struct v4l2_fh *fh,
> +			   struct v4l2_event_subscription *sub);
> +
> +#endif /* V4L2_EVENT_H */
> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
> index 51d6508..d9589c2 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -34,6 +34,7 @@ struct v4l2_fh {
>  	struct list_head	list;
>  	atomic_t		refcount;
>  	spinlock_t		lock;
> +	struct v4l2_events      *events; /* events, pending and subscribed */
>  };
>  
>  /* File handle related data for video_device. */
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

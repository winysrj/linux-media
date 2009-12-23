Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49040 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbZLWBCA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2009 20:02:00 -0500
Subject: Re: [RFC v2 4/7] V4L: Events: Add backend
From: Andy Walls <awalls@radix.net>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, hverkuil@xs4all.nl, gururaj.nagendra@intel.com
In-Reply-To: <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
References: <4B30F713.8070004@maxwell.research.nokia.com>
	 <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
	 <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
Content-Type: text/plain
Date: Tue, 22 Dec 2009 20:01:02 -0500
Message-Id: <1261530062.3161.29.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-22 at 18:43 +0200, Sakari Ailus wrote:
> Add event handling backend to V4L2. The backend handles event subscription
> and delivery to file handles. Event subscriptions are based on file handle.
> Events may be delivered to all subscribed file handles on a device
> independent of where they originate from.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  drivers/media/video/Makefile     |    3 +-
>  drivers/media/video/v4l2-dev.c   |   21 +++-
>  drivers/media/video/v4l2-event.c |  254 ++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/v4l2-fh.c    |    4 +
>  include/media/v4l2-event.h       |   65 ++++++++++
>  include/media/v4l2-fh.h          |    3 +
>  6 files changed, 346 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/video/v4l2-event.c
>  create mode 100644 include/media/v4l2-event.h
> 
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 1947146..dd6a853 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -10,7 +10,8 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>  
>  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>  
> -videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o
> +videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> +			v4l2-event.o
>  
>  # V4L2 core modules
>  
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 15b2ac8..6d25297 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -613,22 +613,36 @@ static int __init videodev_init(void)
>  	dev_t dev = MKDEV(VIDEO_MAJOR, 0);
>  	int ret;
>  
> +	ret = v4l2_event_init();
> +	if (ret < 0) {
> +		printk(KERN_WARNING "videodev: unable to initialise events\n");
> +		return ret;
> +	}
> +
>  	printk(KERN_INFO "Linux video capture interface: v2.00\n");
>  	ret = register_chrdev_region(dev, VIDEO_NUM_DEVICES, VIDEO_NAME);
>  	if (ret < 0) {
>  		printk(KERN_WARNING "videodev: unable to get major %d\n",
>  				VIDEO_MAJOR);
> -		return ret;
> +		goto out_register_chrdev_region;
>  	}
>  
>  	ret = class_register(&video_class);
>  	if (ret < 0) {
> -		unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
>  		printk(KERN_WARNING "video_dev: class_register failed\n");
> -		return -EIO;
> +		ret = -EIO;
> +		goto out_class_register;
>  	}
>  
>  	return 0;
> +
> +out_class_register:
> +	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
> +
> +out_register_chrdev_region:
> +	v4l2_event_exit();
> +
> +	return ret;
>  }
>  
>  static void __exit videodev_exit(void)
> @@ -637,6 +651,7 @@ static void __exit videodev_exit(void)
>  
>  	class_unregister(&video_class);
>  	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
> +	v4l2_event_exit();
>  }
>  
>  module_init(videodev_init)
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> new file mode 100644
> index 0000000..9fc0c81
> --- /dev/null
> +++ b/drivers/media/video/v4l2-event.c
> @@ -0,0 +1,254 @@
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
> +static struct kmem_cache *event_kmem;
> +
> +int v4l2_event_init(void)
> +{
> +	event_kmem = kmem_cache_create("event_kmem",
> +				       sizeof(struct _v4l2_event), 0,
> +				       SLAB_HWCACHE_ALIGN,
> +				       NULL);
> +
> +	if (!event_kmem)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void v4l2_event_exit(void)
> +{
> +	kmem_cache_destroy(event_kmem);
> +}
> +
> +void v4l2_event_init_fh(struct v4l2_fh *fh)
> +{
> +	struct v4l2_events *events = &fh->events;
> +
> +	init_waitqueue_head(&events->wait);
> +	spin_lock_init(&events->lock);
> +
> +	INIT_LIST_HEAD(&events->available);
> +	INIT_LIST_HEAD(&events->subscribed);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_init_fh);
> +
> +void v4l2_event_exit_fh(struct v4l2_fh *fh)
> +{
> +	struct v4l2_events *events = &fh->events;
> +
> +	while (!list_empty(&events->available)) {
> +		struct _v4l2_event *ev;
> +
> +		ev = list_entry(events->available.next,
> +				struct _v4l2_event, list);
> +
> +		list_del(&ev->list);
> +
> +		kmem_cache_free(event_kmem, ev);
> +	}
> +
> +	while (!list_empty(&events->subscribed)) {
> +		struct v4l2_subscribed_event *sub;
> +
> +		sub = list_entry(events->subscribed.next,
> +				struct v4l2_subscribed_event, list);
> +
> +		list_del(&sub->list);
> +
> +		kfree(sub);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_exit_fh);
> +
> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	struct _v4l2_event *ev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&events->lock, flags);
> +
> +	if (list_empty(&events->available)) {
> +		spin_unlock_irqrestore(&events->lock, flags);
> +		return -ENOENT;
> +	}
> +
> +	ev = list_first_entry(&events->available, struct _v4l2_event, list);
> +	list_del(&ev->list);
> +
> +	ev->event.count = !list_empty(&events->available);
> +
> +	spin_unlock_irqrestore(&events->lock, flags);
> +
> +	memcpy(event, &ev->event, sizeof(ev->event));
> +
> +	kmem_cache_free(event_kmem, ev);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
> +
> +static struct v4l2_subscribed_event *__v4l2_event_subscribed(
> +	struct v4l2_fh *fh, u32 type)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	struct v4l2_subscribed_event *ev;
> +
> +	list_for_each_entry(ev, &events->subscribed, list) {
> +		if (ev->type == type)
> +			return ev;
> +	}
> +
> +	return NULL;
> +}
> +
> +struct v4l2_subscribed_event *v4l2_event_subscribed(
> +	struct v4l2_fh *fh, u32 type)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	struct v4l2_subscribed_event *ev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&events->lock, flags);
> +
> +	ev = __v4l2_event_subscribed(fh, type);
> +
> +	spin_unlock_irqrestore(&events->lock, flags);
> +
> +	return ev;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_subscribed);
> +
> +void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> +{
> +	struct v4l2_fh *fh;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&vdev->fh_lock, flags);
> +
> +	list_for_each_entry(fh, &vdev->fh, list) {
> +		struct _v4l2_event *_ev;
> +
> +		if (!v4l2_event_subscribed(fh, ev->type))
> +			continue;
> +
> +		_ev = kmem_cache_alloc(event_kmem, GFP_ATOMIC);
> +		if (!_ev)
> +			continue;
> +
> +		_ev->event = *ev;
> +
> +		spin_lock(&fh->events.lock);
> +		list_add_tail(&_ev->list, &fh->events.available);
> +		spin_unlock(&fh->events.lock);
> +
> +		wake_up_all(&fh->events.wait);
> +	}
> +
> +	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_queue);
> +
> +int v4l2_event_pending(struct v4l2_fh *fh)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	unsigned long flags;
> +	int ret;
> +
> +	spin_lock_irqsave(&events->lock, flags);
> +	ret = !list_empty(&events->available);
> +	spin_unlock_irqrestore(&events->lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_pending);

Hi Sakari,

Disabling and restoring local interrupts to check if any events are
pending seems excessive.

Since you added an atomic_t with the number of events available in patch
5/7, why don't you just check that atomic_t here?


Regards,
Andy

> +
> +int v4l2_event_subscribe(struct v4l2_fh *fh,
> +			 struct v4l2_event_subscription *sub)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	struct v4l2_subscribed_event *ev;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	/* Allow subscribing to valid events only. */
> +	if (sub->type < V4L2_EVENT_PRIVATE_START)
> +		switch (sub->type) {
> +		case V4L2_EVENT_ALL:
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +	ev = kmalloc(sizeof(*ev), GFP_KERNEL);
> +	if (!ev)
> +		return -ENOMEM;
> +
> +	spin_lock_irqsave(&events->lock, flags);
> +
> +	if (__v4l2_event_subscribed(fh, sub->type) != NULL) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	INIT_LIST_HEAD(&ev->list);
> +	ev->type = sub->type;
> +
> +	list_add(&ev->list, &events->subscribed);
> +
> +out:
> +	spin_unlock_irqrestore(&events->lock, flags);
> +
> +	if (ret)
> +		kfree(ev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
> +
> +int v4l2_event_unsubscribe(struct v4l2_fh *fh,
> +			   struct v4l2_event_subscription *sub)
> +{
> +	struct v4l2_events *events = &fh->events;
> +	struct v4l2_subscribed_event *ev;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&events->lock, flags);
> +
> +	ev = __v4l2_event_subscribed(fh, sub->type);
> +
> +	if (ev != NULL)
> +		list_del(&ev->list);
> +
> +	spin_unlock_irqrestore(&events->lock, flags);
> +
> +	return ev == NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_unsubscribe);
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> index 406e4ac..2b25ec9 100644
> --- a/drivers/media/video/v4l2-fh.c
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -32,6 +32,8 @@ int v4l2_fh_add(struct video_device *vdev, struct v4l2_fh *fh)
>  {
>  	unsigned long flags;
>  
> +	v4l2_event_init_fh(fh);
> +
>  	spin_lock_irqsave(&vdev->fh_lock, flags);
>  	list_add(&fh->list, &vdev->fh);
>  	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> @@ -44,6 +46,8 @@ void v4l2_fh_del(struct video_device *vdev, struct v4l2_fh *fh)
>  {
>  	unsigned long flags;
>  
> +	v4l2_event_exit_fh(fh);
> +
>  	spin_lock_irqsave(&vdev->fh_lock, flags);
>  	list_del(&fh->list);
>  	spin_unlock_irqrestore(&vdev->fh_lock, flags);
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> new file mode 100644
> index 0000000..b11de92
> --- /dev/null
> +++ b/include/media/v4l2-event.h
> @@ -0,0 +1,65 @@
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
> +struct _v4l2_event {
> +	struct list_head	list;
> +	struct v4l2_event	event;
> +};
> +
> +struct v4l2_events {
> +	spinlock_t		lock; /* Protect everything here. */
> +	struct list_head	available;
> +	wait_queue_head_t	wait;
> +	struct list_head	subscribed; /* Subscribed events. */
> +};
> +
> +struct v4l2_subscribed_event {
> +	struct list_head	list;
> +	u32			type;
> +};
> +
> +int v4l2_event_init(void);
> +void v4l2_event_exit(void);
> +void v4l2_event_init_fh(struct v4l2_fh *fh);
> +void v4l2_event_exit_fh(struct v4l2_fh *fh);
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
> index 1efa916..c15bd13 100644
> --- a/include/media/v4l2-fh.h
> +++ b/include/media/v4l2-fh.h
> @@ -28,8 +28,11 @@
>  #include <linux/types.h>
>  #include <linux/list.h>
>  
> +#include <media/v4l2-event.h>
> +
>  struct v4l2_fh {
>  	struct list_head	list;
> +	struct v4l2_events      events; /* events, pending and subscribed */
>  };
>  
>  struct video_device;


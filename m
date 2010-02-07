Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40887 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0BGS2c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 13:28:32 -0500
Message-ID: <4B6F0682.2050707@maxwell.research.nokia.com>
Date: Sun, 07 Feb 2010 20:29:22 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, hans.verkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com, iivanov@mm-sol.com
Subject: Re: [PATCH 5/8] V4L: Events: Add backend
References: <4B6DAE5A.5090508@maxwell.research.nokia.com> <1265479331-20595-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201002071345.16968.hverkuil@xs4all.nl>
In-Reply-To: <201002071345.16968.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,
> 
> Once again, thanks for all the work you're doing on this! Very much appreciated!

You're welcome. I think I want to see this finished as much as you do.
:-) And many thanks for the review to you!

> As you requested, I've reviewed this code with special attention to refcounting
> and locking.
>
> In general, locking is hard, so the fewer locks there are, the easier it is
> to get locking right and to maintain/understand the code. 
> 
> Currently you have a lock in v4l2_fhs (at the video_device level) and a lock and
> a refcount in v4l2_fh.
> 
> In my opinion this causes more complexity than is needed. I think a single lock
> in v4l2_fhs would suffice. This does mean that struct v4l2_fh needs a pointer
> to video_device (which is a good idea anyway).
> 
> The only place where this locks more than is strictly necessary is the dequeue
> function. On the other hand, the lock that is taken there is very short and
> I prefer simplicity over unproven performance increases. I actually suspect
> that all the complexity might introduce slower performance than slightly
> sub-optimal locking. I have rewritten the queue and dequeue event functions
> below to what I think should be done there. As you can see, they are now a lot
> easier to understand and a lot shorter.

Could be true. Usually the number of file handles keeping a device open
is rather small, as is the number of subscriptions. My idea there was to
keep the time during which interrupts were disabled small.

> Regards,
> 
> 	Hans
> 
...
>> +void v4l2_event_exit(struct v4l2_fh *fh)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +
>> +	if (!events)
>> +		return;
>> +
>> +	while (!list_empty(&events->free)) {
>> +		struct v4l2_kevent *kev;
>> +
>> +		kev = list_first_entry(&events->free,
>> +				       struct v4l2_kevent, list);
>> +		list_del(&kev->list);
>> +
>> +		kfree(kev);
>> +	}
> 
> This can be done cleaner via a static inline function to delete an event
> list.

Made a macro out of that. All three can be freed that way.

...

>> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_kevent *kev;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&fh->lock, flags);
>> +
>> +	if (list_empty(&events->available)) {
>> +		spin_unlock_irqrestore(&fh->lock, flags);
>> +		return -ENOENT;
>> +	}
>> +
>> +	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
>> +	list_del(&kev->list);
>> +
>> +	kev->event.count = !list_empty(&events->available);
>> +
>> +	spin_unlock_irqrestore(&fh->lock, flags);
>> +
>> +	*event = kev->event;
>> +
>> +	spin_lock_irqsave(&fh->lock, flags);
>> +	list_add(&kev->list, &events->free);
>> +	spin_unlock_irqrestore(&fh->lock, flags);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
> 
> int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
> {
> 	struct v4l2_events *events = fh->events;
> 	struct v4l2_kevent *kev;
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&fh->vdev->fhs.lock, flags);
> 
> 	if (list_empty(&events->available)) {
> 		spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
> 		return -ENOENT;
> 	}
> 
> 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
> 	list_move(&kev->list, &events->free);
> 
> 	kev->event.count = !list_empty(&events->available);
> 
> 	*event = kev->event;
> 
> 	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
> 
> 	return 0;
> }
> 
> One possible optimization might be to do this (as you did in the original code):
> 
> 	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
> 	list_del(&kev->list);
> 	kev->event.count = !list_empty(&events->available);
> 	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
> 
> 	*event = kev->event;
> 
> 	spin_lock_irqsave(&fh->vdev->fhs.lock, flags);
> 	list_add(&kev->list, &events->free);
> 	spin_unlock_irqrestore(&fh->vdev->fhs.lock, flags);
> 
> However, this would need some testing first to see what the performance
> trade-off is between unlocking and locking vs. copying 120 bytes.

Probably makes no sense to drop the lock for that duration. I now keep
it all the time in the updated patch.

...

>> +void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
>> +{
>> +	struct v4l2_fh *fh;
>> +	unsigned long flags;
>> +	struct v4l2_fh *put_me = NULL;
>> +
>> +	spin_lock_irqsave(&vdev->fhs.lock, flags);
>> +
>> +	list_for_each_entry(fh, &vdev->fhs.list, list) {
>> +		struct v4l2_events *events = fh->events;
>> +		struct v4l2_kevent *kev;
>> +
>> +		/* Is it subscribed? */
>> +		if (!v4l2_event_subscribed(fh, ev->type))
>> +			continue;
>> +
>> +		/* Can we get the file handle? */
>> +		if (v4l2_fh_get(vdev, fh))
>> +			continue;
>> +
>> +		/* List lock no longer required. */
>> +		spin_unlock_irqrestore(&vdev->fhs.lock, flags);
>> +
>> +		/* Put earlier v4l2_fh. */
>> +		if (put_me) {
>> +			v4l2_fh_put(vdev, put_me);
>> +			put_me = NULL;
>> +		}
>> +		put_me = fh;
>> +
>> +		/* Do we have any free events? */
>> +		spin_lock_irqsave(&fh->lock, flags);
>> +		if (list_empty(&events->free)) {
>> +			spin_unlock_irqrestore(&fh->lock, flags);
>> +			spin_lock_irqsave(&vdev->fhs.lock, flags);
>> +			continue;
>> +		}
>> +
>> +		/* Take one and fill it. */
>> +		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
>> +		list_del(&kev->list);
>> +		spin_unlock_irqrestore(&fh->lock, flags);
>> +
>> +		kev->event = *ev;
>> +
>> +		/* And add to the available list. */
>> +		spin_lock_irqsave(&fh->lock, flags);
>> +		list_add_tail(&kev->list, &events->available);
>> +		spin_unlock_irqrestore(&fh->lock, flags);
>> +
>> +		wake_up_all(&events->wait);
>> +
>> +		spin_lock_irqsave(&vdev->fhs.lock, flags);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
>> +
>> +	/* Put final v4l2_fh if exists. */
>> +	if (put_me)
>> +		v4l2_fh_put(vdev, put_me);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_queue);
> 
> void v4l2_event_queue(struct video_device *vdev, struct v4l2_event *ev)
> {
> 	struct v4l2_fh *fh;
> 	unsigned long flags;
> 
> 	spin_lock_irqsave(&vdev->fhs.lock, flags);
> 
> 	list_for_each_entry(fh, &vdev->fhs.list, list) {
> 		struct v4l2_events *events = fh->events;
> 		struct v4l2_kevent *kev;
> 
> 		/* Do we have any free events and are we subscribed? */
> 		if (list_empty(&events->free) ||
> 		    !__v4l2_event_subscribed(fh, ev->type))
> 			continue;
> 
> 		/* Take one and fill it. */
> 		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
> 		kev->event = *ev;
> 		list_move_tail(&kev->list, &events->available);
> 
> 		wake_up_all(&events->wait);
> 	}
> 
> 	spin_unlock_irqrestore(&vdev->fhs.lock, flags);
> }

Fixed.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

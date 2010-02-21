Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46905 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab0BUU57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 15:57:59 -0500
Message-ID: <4B819E4B.5010804@maxwell.research.nokia.com>
Date: Sun, 21 Feb 2010 22:57:47 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
Subject: Re: [PATCH v5 4/6] V4L: Events: Add backend
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <1266607320-9974-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201002201045.03756.hverkuil@xs4all.nl>
In-Reply-To: <201002201045.03756.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,

Hi Hans,

And many thanks for the comments again!

> Here are some more comments.
> 
...
>> +int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_kevent *kev;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +
>> +	if (list_empty(&events->available)) {
>> +		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +		return -ENOENT;
>> +	}
>> +
>> +	WARN_ON(events->navailable == 0);
>> +
>> +	kev = list_first_entry(&events->available, struct v4l2_kevent, list);
>> +	list_move(&kev->list, &events->free);
>> +	events->navailable--;
>> +
>> +	kev->event.pending = events->navailable;
>> +	*event = kev->event;
>> +
>> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
>> +
>> +static struct v4l2_subscribed_event *v4l2_event_subscribed(
>> +	struct v4l2_fh *fh, u32 type)
> 
> Add a comment before this function that mentions that fh->vdev->fh_lock must
> be held before calling this.

Ack.

I'll add WARN_ON(!lock_acquired()) as well.

>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_subscribed_event *sev;
>> +
>> +	list_for_each_entry(sev, &events->subscribed, list) {
>> +		if (sev->type == type)
>> +			return sev;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
>> +{
>> +	struct v4l2_fh *fh;
>> +	unsigned long flags;
>> +	struct timespec timestamp;
>> +
>> +	ktime_get_ts(&timestamp);
>> +
>> +	spin_lock_irqsave(&vdev->fh_lock, flags);
>> +
>> +	list_for_each_entry(fh, &vdev->fh_list, list) {
>> +		struct v4l2_events *events = fh->events;
>> +		struct v4l2_kevent *kev;
>> +		u32 sequence;
>> +
>> +		/* Are we subscribed? */
>> +		if (!v4l2_event_subscribed(fh, ev->type))
>> +			continue;
>> +
>> +		/* Increase event sequence number on fh. */
>> +		events->sequence++;
>> +		sequence = events->sequence;
> 
> There is no need for a temp sequence variable...

Good point.

>> +
>> +		/* Do we have any free events? */
>> +		if (list_empty(&events->free))
>> +			continue;
>> +
>> +		/* Take one and fill it. */
>> +		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
>> +		kev->event.type = ev->type;
>> +		kev->event.u = ev->u;
>> +		kev->event.timestamp = timestamp;
>> +		kev->event.sequence = sequence;
> 
> ... you can just use events->sequence directly here.
> 
>> +		list_move_tail(&kev->list, &events->available);
>> +
>> +		events->navailable++;
>> +
>> +		wake_up_all(&events->wait);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&vdev->fh_lock, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_queue);
>> +
>> +int v4l2_event_pending(struct v4l2_fh *fh)
>> +{
>> +	return fh->events->navailable;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_pending);
>> +
>> +int v4l2_event_subscribe(struct v4l2_fh *fh,
>> +			 struct v4l2_event_subscription *sub)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_subscribed_event *sev;
>> +	unsigned long flags;
>> +
> 
> Add this:
> 
> 	if (events == NULL) {
> 		/* If we get here, then the driver forgot to allocate events. */
> 		WARN_ON(1);
> 		return -ENOMEM;
> 	}
> 
> If subscribe is called without the event queue being allocated, then the
> driver did something wrong.

Ok.

> See also my review for patch 5/6.
> 
>> +	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
>> +	if (!sev)
>> +		return -ENOMEM;
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +
>> +	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
>> +		INIT_LIST_HEAD(&sev->list);
>> +		sev->type = sub->type;
>> +
>> +		list_add(&sev->list, &events->subscribed);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 
> If the event was already subscribed, then you need to kfree the earlier
> allocated sev here. Otherwise you have a memory leak.

Thanks for catching this!

No matter how many times you read the code through yourself this kind of
bugs may still lie there.

>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
>> +
>> +/* subscribe a zero-terminated array of events */
>> +int v4l2_event_subscribe_many(struct v4l2_fh *fh, const u32 *all)
>> +{
>> +	int ret;
>> +
>> +	for (; *all; all++) {
>> +		struct v4l2_event_subscription sub;
>> +
>> +		sub.type = *all;
>> +
>> +		ret = v4l2_event_subscribe(fh, &sub);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_subscribe_many);
> 
> Supporting V4L2_EVENT_ALL is a bad idea when subscribing. It sounds nice initially,
> but the longer I think about it the more convinced I am we should not do this.
> The main argument is really that it can lead to unexpected behavior. Suppose a
> userspace application subscribes to all events. And in a later version of the
> driver new events are added. Suddenly those will also arrive in the userspace app.
> 
> This might cause it to crash if it was written badly and it didn't check against
> unknown events. Or this new event might be a high-volume event which might flood
> the application unexpectedly.

Many events are more or less related to the drivers. If an application
is unable to cope with events it has subscribed then it's an application
problem IMO.

I'm fine with dropping V4L2_EVENT_ALL in subscription. It can always be
added later if it's ever required.

>> +
>> +static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +
>> +	while (!list_empty(&events->subscribed)) {
>> +		struct v4l2_subscribed_event *sev;
>> +
>> +		sev = list_first_entry(&events->subscribed,
>> +				       struct v4l2_subscribed_event, list);
>> +
>> +		list_del(&sev->list);
>> +		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +		kfree(sev);
>> +		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +	}
>> +
>> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +}
> 
> What about this:
> 
> static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
> {
> 	struct v4l2_events *events = fh->events;
> 	struct v4l2_subscribed_event *sev;
> 	unsigned long flags;
> 
> 	do {
> 		sev = NULL;
> 
> 		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> 		if (!list_empty(&events->subscribed)) {
> 			sev = list_first_entry(&events->subscribed,
> 				       struct v4l2_subscribed_event, list);
> 			list_del(&sev->list);
> 		}
> 		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> 		kfree(sev);
> 	} while (sev);
> }
> 
> This avoids the 'interleaved' locking which I never like.

Can do. I don't see anything bad in that kind of locking, though. ;-)

>> +
>> +int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>> +			   struct v4l2_event_subscription *sub)
>> +{
>> +	struct v4l2_subscribed_event *sev;
>> +	unsigned long flags;
>> +
>> +	if (sub->type == V4L2_EVENT_ALL) {
>> +		v4l2_event_unsubscribe_all(fh);
>> +		return 0;
>> +	}
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +
>> +	sev = v4l2_event_subscribed(fh, sub->type);
>> +	if (sev != NULL)
>> +		list_del(&sev->list);
>> +
>> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +
>> +	if (sev != NULL)
>> +		kfree(sev);
> 
> No need for the NULL check. kfree(NULL) is allowed.

Done.

>> +struct v4l2_events {
>> +	wait_queue_head_t	wait;
>> +	struct list_head	subscribed; /* Subscribed events */
>> +	struct list_head	available; /* Dequeueable event */
>> +	unsigned int		navailable;
>> +	struct list_head	free; /* Events ready for use */
> 
> I would move this between the subscribed and available lists. Purely for
> grouping the lists together.

Done.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

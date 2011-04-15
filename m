Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4872 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1DOQZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2011 12:25:59 -0400
Message-ID: <7db9a20f6d656cee512dd4a9d3f53061.squirrel@webmail.xs4all.nl>
In-Reply-To: <4DA82325.1020800@maxwell.research.nokia.com>
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com>
    <54721c1be23beb8c885ef56cdf7f782205c9dfdb.1301916466.git.hans.verkuil@cisco.com>
    <4DA82325.1020800@maxwell.research.nokia.com>
Date: Fri, 15 Apr 2011 18:25:54 +0200
Subject: Re: [RFCv1 PATCH 4/9] v4l2-ctrls: add per-control events.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "Hans Verkuil" <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Hans,
>
> I have some more comments below. :-)
>
> Hans Verkuil wrote:
>> Whenever a control changes value an event is sent to anyone that
>> subscribed
>> to it.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/video/v4l2-ctrls.c |   59 ++++++++++++++++++
>>  drivers/media/video/v4l2-event.c |  126
>> +++++++++++++++++++++++++++-----------
>>  drivers/media/video/v4l2-fh.c    |    4 +-
>>  include/linux/videodev2.h        |   17 +++++-
>>  include/media/v4l2-ctrls.h       |    9 +++
>>  include/media/v4l2-event.h       |    2 +
>>  6 files changed, 177 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-ctrls.c
>> b/drivers/media/video/v4l2-ctrls.c
>> index f75a1d4..163f412 100644
>> --- a/drivers/media/video/v4l2-ctrls.c
>> +++ b/drivers/media/video/v4l2-ctrls.c
>> @@ -23,6 +23,7 @@
>>  #include <media/v4l2-ioctl.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>>  #include <media/v4l2-dev.h>
>>
>>  /* Internal temporary helper struct, one for each v4l2_ext_control */
>> @@ -537,6 +538,16 @@ static bool type_is_int(const struct v4l2_ctrl
>> *ctrl)
>>  	}
>>  }
>>
>> +static void send_event(struct v4l2_ctrl *ctrl, struct v4l2_event *ev)
>> +{
>> +	struct v4l2_ctrl_fh *pos;
>> +
>> +	ev->id = ctrl->id;
>> +	list_for_each_entry(pos, &ctrl->fhs, node) {
>> +		v4l2_event_queue_fh(pos->fh, ev);
>> +	}
>
> Shouldn't we do v4l2_ctrl_lock(ctrl) here? Or does something prevent
> changes to the file handle list while we loop over it?

This function is always called with the lock taken.

> v4l2_ctrl_lock() locks a mutex. Events often arrive from interrupt
> context, which would mean the drivers would need to create a work queue
> to tell about changes to control values.

I will have to check whether it is possible to make a function that can be
called from interrupt context. I have my doubts though whether it is 1)
possible and 2) desirable. At least in the area of HDMI
receivers/transmitters you will want to have a workqueue anyway.

>
>> +}
>> +
>>  /* Helper function: copy the current control value back to the caller
>> */
>>  static int cur_to_user(struct v4l2_ext_control *c,
>>  		       struct v4l2_ctrl *ctrl)
>> @@ -626,20 +637,38 @@ static int new_to_user(struct v4l2_ext_control *c,
>>  /* Copy the new value to the current value. */
>>  static void new_to_cur(struct v4l2_ctrl *ctrl)
>>  {
>> +	struct v4l2_event ev;
>> +	bool changed = false;
>> +
>>  	if (ctrl == NULL)
>>  		return;
>>  	switch (ctrl->type) {
>> +	case V4L2_CTRL_TYPE_BUTTON:
>> +		changed = true;
>> +		ev.u.ctrl_ch_value.value = 0;
>> +		break;
>>  	case V4L2_CTRL_TYPE_STRING:
>>  		/* strings are always 0-terminated */
>> +		changed = strcmp(ctrl->string, ctrl->cur.string);
>>  		strcpy(ctrl->cur.string, ctrl->string);
>> +		ev.u.ctrl_ch_value.value64 = 0;
>>  		break;
>>  	case V4L2_CTRL_TYPE_INTEGER64:
>> +		changed = ctrl->val64 != ctrl->cur.val64;
>>  		ctrl->cur.val64 = ctrl->val64;
>> +		ev.u.ctrl_ch_value.value64 = ctrl->val64;
>>  		break;
>>  	default:
>> +		changed = ctrl->val != ctrl->cur.val;
>>  		ctrl->cur.val = ctrl->val;
>> +		ev.u.ctrl_ch_value.value = ctrl->val;
>>  		break;
>>  	}
>> +	if (changed) {
>> +		ev.type = V4L2_EVENT_CTRL_CH_VALUE;
>> +		ev.u.ctrl_ch_value.type = ctrl->type;
>> +		send_event(ctrl, &ev);
>> +	}
>>  }
>>
>>  /* Copy the current value to the new value */
>> @@ -784,6 +813,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler
>> *hdl)
>>  {
>>  	struct v4l2_ctrl_ref *ref, *next_ref;
>>  	struct v4l2_ctrl *ctrl, *next_ctrl;
>> +	struct v4l2_ctrl_fh *ctrl_fh, *next_ctrl_fh;
>>
>>  	if (hdl == NULL || hdl->buckets == NULL)
>>  		return;
>> @@ -797,6 +827,10 @@ void v4l2_ctrl_handler_free(struct
>> v4l2_ctrl_handler *hdl)
>>  	/* Free all controls owned by the handler */
>>  	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
>>  		list_del(&ctrl->node);
>> +		list_for_each_entry_safe(ctrl_fh, next_ctrl_fh, &ctrl->fhs, node) {
>> +			list_del(&ctrl_fh->node);
>> +			kfree(ctrl_fh);
>> +		}
>
> Wouldn't this also require holding v4l2_ctrl_lock(ctrl), since otherwise
> the file handle list may change in the middle of doing this?
>
> Then we'd hold two mutexes at once. I'd guess it's fine as long as we're
> certain never do the locking of the two in a different order.

The lock is already taken. Note that the locking is done at the control
handler level. So there is no per-control lock. v4l2_ctrl_lock will
actually lock ctrl->handler->lock.

>
>>  		kfree(ctrl);
>>  	}
>>  	kfree(hdl->buckets);
>> @@ -1003,6 +1037,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
>> v4l2_ctrl_handler *hdl,
>>  	}
>>
>>  	INIT_LIST_HEAD(&ctrl->node);
>> +	INIT_LIST_HEAD(&ctrl->fhs);
>>  	ctrl->handler = hdl;
>>  	ctrl->ops = ops;
>>  	ctrl->id = id;
>> @@ -1888,3 +1923,27 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32
>> val)
>>  	return set_ctrl(ctrl, &val);
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
>> +
>> +void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh
>> *ctrl_fh)
>> +{
>> +	v4l2_ctrl_lock(ctrl);
>> +	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
>> +	v4l2_ctrl_unlock(ctrl);
>> +}
>> +EXPORT_SYMBOL(v4l2_ctrl_add_fh);
>> +
>> +void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
>> +{
>> +	struct v4l2_ctrl_fh *pos;
>> +
>> +	v4l2_ctrl_lock(ctrl);
>> +	list_for_each_entry(pos, &ctrl->fhs, node) {
>> +		if (pos->fh == fh) {
>> +			list_del(&pos->node);
>> +			kfree(pos);
>> +			break;
>> +		}
>> +	}
>> +	v4l2_ctrl_unlock(ctrl);
>> +}
>> +EXPORT_SYMBOL(v4l2_ctrl_del_fh);
>> diff --git a/drivers/media/video/v4l2-event.c
>> b/drivers/media/video/v4l2-event.c
>> index 69fd343..c9251a5 100644
>> --- a/drivers/media/video/v4l2-event.c
>> +++ b/drivers/media/video/v4l2-event.c
>> @@ -25,10 +25,13 @@
>>  #include <media/v4l2-dev.h>
>>  #include <media/v4l2-fh.h>
>>  #include <media/v4l2-event.h>
>> +#include <media/v4l2-ctrls.h>
>>
>>  #include <linux/sched.h>
>>  #include <linux/slab.h>
>>
>> +static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
>> +
>>  int v4l2_event_init(struct v4l2_fh *fh)
>>  {
>>  	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
>> @@ -91,7 +94,7 @@ void v4l2_event_free(struct v4l2_fh *fh)
>>
>>  	list_kfree(&events->free, struct v4l2_kevent, list);
>>  	list_kfree(&events->available, struct v4l2_kevent, list);
>> -	list_kfree(&events->subscribed, struct v4l2_subscribed_event, list);
>> +	v4l2_event_unsubscribe_all(fh);
>>
>>  	kfree(events);
>>  	fh->events = NULL;
>> @@ -154,9 +157,9 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct
>> v4l2_event *event,
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
>>
>> -/* Caller must hold fh->event->lock! */
>> +/* Caller must hold fh->vdev->fh_lock! */
>>  static struct v4l2_subscribed_event *v4l2_event_subscribed(
>> -	struct v4l2_fh *fh, u32 type)
>> +		struct v4l2_fh *fh, u32 type, u32 id)
>>  {
>>  	struct v4l2_events *events = fh->events;
>>  	struct v4l2_subscribed_event *sev;
>> @@ -164,13 +167,46 @@ static struct v4l2_subscribed_event
>> *v4l2_event_subscribed(
>>  	assert_spin_locked(&fh->vdev->fh_lock);
>>
>>  	list_for_each_entry(sev, &events->subscribed, list) {
>> -		if (sev->type == type)
>> +		if (sev->type == type && sev->id == id)
>>  			return sev;
>>  	}
>>
>>  	return NULL;
>>  }
>>
>> +static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct
>> v4l2_event *ev,
>> +		const struct timespec *ts)
>> +{
>> +	struct v4l2_events *events = fh->events;
>> +	struct v4l2_subscribed_event *sev;
>> +	struct v4l2_kevent *kev;
>> +
>> +	/* Are we subscribed? */
>> +	sev = v4l2_event_subscribed(fh, ev->type, ev->id);
>> +	if (sev == NULL)
>> +		return;
>> +
>> +	/* Increase event sequence number on fh. */
>> +	events->sequence++;
>> +
>> +	/* Do we have any free events? */
>> +	if (list_empty(&events->free))
>> +		return;
>> +
>> +	/* Take one and fill it. */
>> +	kev = list_first_entry(&events->free, struct v4l2_kevent, list);
>> +	kev->event.type = ev->type;
>> +	kev->event.u = ev->u;
>> +	kev->event.id = ev->id;
>> +	kev->event.timestamp = *ts;
>> +	kev->event.sequence = events->sequence;
>> +	list_move_tail(&kev->list, &events->available);
>> +
>> +	events->navailable++;
>> +
>> +	wake_up_all(&events->wait);
>> +}
>> +
>>  void v4l2_event_queue(struct video_device *vdev, const struct
>> v4l2_event *ev)
>>  {
>>  	struct v4l2_fh *fh;
>> @@ -182,37 +218,26 @@ void v4l2_event_queue(struct video_device *vdev,
>> const struct v4l2_event *ev)
>>  	spin_lock_irqsave(&vdev->fh_lock, flags);
>>
>>  	list_for_each_entry(fh, &vdev->fh_list, list) {
>> -		struct v4l2_events *events = fh->events;
>> -		struct v4l2_kevent *kev;
>> -
>> -		/* Are we subscribed? */
>> -		if (!v4l2_event_subscribed(fh, ev->type))
>> -			continue;
>> -
>> -		/* Increase event sequence number on fh. */
>> -		events->sequence++;
>> -
>> -		/* Do we have any free events? */
>> -		if (list_empty(&events->free))
>> -			continue;
>> -
>> -		/* Take one and fill it. */
>> -		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
>> -		kev->event.type = ev->type;
>> -		kev->event.u = ev->u;
>> -		kev->event.timestamp = timestamp;
>> -		kev->event.sequence = events->sequence;
>> -		list_move_tail(&kev->list, &events->available);
>> -
>> -		events->navailable++;
>> -
>> -		wake_up_all(&events->wait);
>> +		__v4l2_event_queue_fh(fh, ev, &timestamp);
>>  	}
>>
>>  	spin_unlock_irqrestore(&vdev->fh_lock, flags);
>>  }
>>  EXPORT_SYMBOL_GPL(v4l2_event_queue);
>>
>> +void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event
>> *ev)
>> +{
>> +	unsigned long flags;
>> +	struct timespec timestamp;
>> +
>> +	ktime_get_ts(&timestamp);
>> +
>> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>> +	__v4l2_event_queue_fh(fh, ev, &timestamp);
>> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
>> +
>>  int v4l2_event_pending(struct v4l2_fh *fh)
>>  {
>>  	return fh->events->navailable;
>> @@ -223,7 +248,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>>  			 struct v4l2_event_subscription *sub)
>>  {
>>  	struct v4l2_events *events = fh->events;
>> -	struct v4l2_subscribed_event *sev;
>> +	struct v4l2_subscribed_event *sev, *found_ev;
>> +	struct v4l2_ctrl *ctrl = NULL;
>> +	struct v4l2_ctrl_fh *ctrl_fh = NULL;
>>  	unsigned long flags;
>>
>>  	if (fh->events == NULL) {
>> @@ -231,15 +258,31 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>>  		return -ENOMEM;
>>  	}
>>
>> +	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE) {
>> +		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
>> +		if (ctrl == NULL)
>> +			return -EINVAL;
>> +	}
>> +
>>  	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
>>  	if (!sev)
>>  		return -ENOMEM;
>> +	if (ctrl) {
>> +		ctrl_fh = kzalloc(sizeof(*ctrl_fh), GFP_KERNEL);
>> +		if (!ctrl_fh) {
>> +			kfree(sev);
>> +			return -ENOMEM;
>> +		}
>> +		ctrl_fh->fh = fh;
>> +	}
>>
>>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>>
>> -	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
>> +	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
>> +	if (!found_ev) {
>>  		INIT_LIST_HEAD(&sev->list);
>>  		sev->type = sub->type;
>> +		sev->id = sub->id;
>>
>>  		list_add(&sev->list, &events->subscribed);
>>  		sev = NULL;
>> @@ -247,6 +290,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>>
>>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>>
>> +	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
>> +	if (!found_ev && ctrl)
>> +		v4l2_ctrl_add_fh(ctrl, ctrl_fh);
>
> Doesn't this allow adding two events for the same control id, if the
> v4l2_event_subscribed() call is performed when another is checking for
> the same control id before it has been added to the list in ctrl by
> v4l2_ctrl_add_fh()?

No, because only one of the two will get a found_ev == NULL result. The
check whether the event is already subscribed and adding the new event is
done with the spinlock held, so that is atomic.

Regards,

        Hans

>
> ...
>
> Regards,
>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



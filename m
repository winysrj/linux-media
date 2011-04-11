Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.48]:22026 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1DKH3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 03:29:46 -0400
Message-ID: <4DA2ADE6.2080704@maxwell.research.nokia.com>
Date: Mon, 11 Apr 2011 10:29:42 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv1 PATCH 4/9] v4l2-ctrls: add per-control events.
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <54721c1be23beb8c885ef56cdf7f782205c9dfdb.1301916466.git.hans.verkuil@cisco.com>
In-Reply-To: <54721c1be23beb8c885ef56cdf7f782205c9dfdb.1301916466.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

Thanks for the patchset! This looks really nice!

Hans Verkuil wrote:
> Whenever a control changes value an event is sent to anyone that subscribed
> to it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ctrls.c |   59 ++++++++++++++++++
>  drivers/media/video/v4l2-event.c |  126 +++++++++++++++++++++++++++-----------
>  drivers/media/video/v4l2-fh.c    |    4 +-
>  include/linux/videodev2.h        |   17 +++++-
>  include/media/v4l2-ctrls.h       |    9 +++
>  include/media/v4l2-event.h       |    2 +
>  6 files changed, 177 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index f75a1d4..163f412 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -23,6 +23,7 @@
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
>  #include <media/v4l2-dev.h>
>  
>  /* Internal temporary helper struct, one for each v4l2_ext_control */
> @@ -537,6 +538,16 @@ static bool type_is_int(const struct v4l2_ctrl *ctrl)
>  	}
>  }
>  
> +static void send_event(struct v4l2_ctrl *ctrl, struct v4l2_event *ev)
> +{
> +	struct v4l2_ctrl_fh *pos;
> +
> +	ev->id = ctrl->id;
> +	list_for_each_entry(pos, &ctrl->fhs, node) {
> +		v4l2_event_queue_fh(pos->fh, ev);
> +	}

No need for braces here.

> +}
> +
>  /* Helper function: copy the current control value back to the caller */
>  static int cur_to_user(struct v4l2_ext_control *c,
>  		       struct v4l2_ctrl *ctrl)
> @@ -626,20 +637,38 @@ static int new_to_user(struct v4l2_ext_control *c,
>  /* Copy the new value to the current value. */
>  static void new_to_cur(struct v4l2_ctrl *ctrl)
>  {
> +	struct v4l2_event ev;
> +	bool changed = false;
> +
>  	if (ctrl == NULL)
>  		return;
>  	switch (ctrl->type) {
> +	case V4L2_CTRL_TYPE_BUTTON:
> +		changed = true;
> +		ev.u.ctrl_ch_value.value = 0;
> +		break;
>  	case V4L2_CTRL_TYPE_STRING:
>  		/* strings are always 0-terminated */
> +		changed = strcmp(ctrl->string, ctrl->cur.string);
>  		strcpy(ctrl->cur.string, ctrl->string);
> +		ev.u.ctrl_ch_value.value64 = 0;
>  		break;
>  	case V4L2_CTRL_TYPE_INTEGER64:
> +		changed = ctrl->val64 != ctrl->cur.val64;
>  		ctrl->cur.val64 = ctrl->val64;
> +		ev.u.ctrl_ch_value.value64 = ctrl->val64;
>  		break;
>  	default:
> +		changed = ctrl->val != ctrl->cur.val;
>  		ctrl->cur.val = ctrl->val;
> +		ev.u.ctrl_ch_value.value = ctrl->val;
>  		break;
>  	}
> +	if (changed) {
> +		ev.type = V4L2_EVENT_CTRL_CH_VALUE;
> +		ev.u.ctrl_ch_value.type = ctrl->type;
> +		send_event(ctrl, &ev);
> +	}
>  }
>  
>  /* Copy the current value to the new value */
> @@ -784,6 +813,7 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  {
>  	struct v4l2_ctrl_ref *ref, *next_ref;
>  	struct v4l2_ctrl *ctrl, *next_ctrl;
> +	struct v4l2_ctrl_fh *ctrl_fh, *next_ctrl_fh;
>  
>  	if (hdl == NULL || hdl->buckets == NULL)
>  		return;
> @@ -797,6 +827,10 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  	/* Free all controls owned by the handler */
>  	list_for_each_entry_safe(ctrl, next_ctrl, &hdl->ctrls, node) {
>  		list_del(&ctrl->node);
> +		list_for_each_entry_safe(ctrl_fh, next_ctrl_fh, &ctrl->fhs, node) {
> +			list_del(&ctrl_fh->node);
> +			kfree(ctrl_fh);
> +		}
>  		kfree(ctrl);
>  	}
>  	kfree(hdl->buckets);
> @@ -1003,6 +1037,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>  	}
>  
>  	INIT_LIST_HEAD(&ctrl->node);
> +	INIT_LIST_HEAD(&ctrl->fhs);
>  	ctrl->handler = hdl;
>  	ctrl->ops = ops;
>  	ctrl->id = id;
> @@ -1888,3 +1923,27 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
>  	return set_ctrl(ctrl, &val);
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
> +
> +void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh)
> +{
> +	v4l2_ctrl_lock(ctrl);
> +	list_add_tail(&ctrl_fh->node, &ctrl->fhs);
> +	v4l2_ctrl_unlock(ctrl);
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_add_fh);
> +
> +void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh)
> +{
> +	struct v4l2_ctrl_fh *pos;
> +
> +	v4l2_ctrl_lock(ctrl);
> +	list_for_each_entry(pos, &ctrl->fhs, node) {
> +		if (pos->fh == fh) {
> +			list_del(&pos->node);
> +			kfree(pos);
> +			break;
> +		}
> +	}
> +	v4l2_ctrl_unlock(ctrl);
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_del_fh);
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 69fd343..c9251a5 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -25,10 +25,13 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
> +#include <media/v4l2-ctrls.h>
>  
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  
> +static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh);
> +
>  int v4l2_event_init(struct v4l2_fh *fh)
>  {
>  	fh->events = kzalloc(sizeof(*fh->events), GFP_KERNEL);
> @@ -91,7 +94,7 @@ void v4l2_event_free(struct v4l2_fh *fh)
>  
>  	list_kfree(&events->free, struct v4l2_kevent, list);
>  	list_kfree(&events->available, struct v4l2_kevent, list);
> -	list_kfree(&events->subscribed, struct v4l2_subscribed_event, list);
> +	v4l2_event_unsubscribe_all(fh);
>  
>  	kfree(events);
>  	fh->events = NULL;
> @@ -154,9 +157,9 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_dequeue);
>  
> -/* Caller must hold fh->event->lock! */
> +/* Caller must hold fh->vdev->fh_lock! */
>  static struct v4l2_subscribed_event *v4l2_event_subscribed(
> -	struct v4l2_fh *fh, u32 type)
> +		struct v4l2_fh *fh, u32 type, u32 id)
>  {
>  	struct v4l2_events *events = fh->events;
>  	struct v4l2_subscribed_event *sev;
> @@ -164,13 +167,46 @@ static struct v4l2_subscribed_event *v4l2_event_subscribed(
>  	assert_spin_locked(&fh->vdev->fh_lock);
>  
>  	list_for_each_entry(sev, &events->subscribed, list) {
> -		if (sev->type == type)
> +		if (sev->type == type && sev->id == id)
>  			return sev;
>  	}
>  
>  	return NULL;
>  }
>  
> +static void __v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev,
> +		const struct timespec *ts)
> +{
> +	struct v4l2_events *events = fh->events;
> +	struct v4l2_subscribed_event *sev;
> +	struct v4l2_kevent *kev;
> +
> +	/* Are we subscribed? */
> +	sev = v4l2_event_subscribed(fh, ev->type, ev->id);
> +	if (sev == NULL)
> +		return;
> +
> +	/* Increase event sequence number on fh. */
> +	events->sequence++;
> +
> +	/* Do we have any free events? */
> +	if (list_empty(&events->free))
> +		return;
> +
> +	/* Take one and fill it. */
> +	kev = list_first_entry(&events->free, struct v4l2_kevent, list);
> +	kev->event.type = ev->type;
> +	kev->event.u = ev->u;
> +	kev->event.id = ev->id;
> +	kev->event.timestamp = *ts;
> +	kev->event.sequence = events->sequence;
> +	list_move_tail(&kev->list, &events->available);
> +
> +	events->navailable++;
> +
> +	wake_up_all(&events->wait);
> +}
> +
>  void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
>  {
>  	struct v4l2_fh *fh;
> @@ -182,37 +218,26 @@ void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev)
>  	spin_lock_irqsave(&vdev->fh_lock, flags);
>  
>  	list_for_each_entry(fh, &vdev->fh_list, list) {
> -		struct v4l2_events *events = fh->events;
> -		struct v4l2_kevent *kev;
> -
> -		/* Are we subscribed? */
> -		if (!v4l2_event_subscribed(fh, ev->type))
> -			continue;
> -
> -		/* Increase event sequence number on fh. */
> -		events->sequence++;
> -
> -		/* Do we have any free events? */
> -		if (list_empty(&events->free))
> -			continue;
> -
> -		/* Take one and fill it. */
> -		kev = list_first_entry(&events->free, struct v4l2_kevent, list);
> -		kev->event.type = ev->type;
> -		kev->event.u = ev->u;
> -		kev->event.timestamp = timestamp;
> -		kev->event.sequence = events->sequence;
> -		list_move_tail(&kev->list, &events->available);
> -
> -		events->navailable++;
> -
> -		wake_up_all(&events->wait);
> +		__v4l2_event_queue_fh(fh, ev, &timestamp);
>  	}
>  
>  	spin_unlock_irqrestore(&vdev->fh_lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_queue);
>  
> +void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev)
> +{
> +	unsigned long flags;
> +	struct timespec timestamp;
> +
> +	ktime_get_ts(&timestamp);
> +
> +	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
> +	__v4l2_event_queue_fh(fh, ev, &timestamp);
> +	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_event_queue_fh);
> +
>  int v4l2_event_pending(struct v4l2_fh *fh)
>  {
>  	return fh->events->navailable;
> @@ -223,7 +248,9 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  			 struct v4l2_event_subscription *sub)
>  {
>  	struct v4l2_events *events = fh->events;
> -	struct v4l2_subscribed_event *sev;
> +	struct v4l2_subscribed_event *sev, *found_ev;
> +	struct v4l2_ctrl *ctrl = NULL;
> +	struct v4l2_ctrl_fh *ctrl_fh = NULL;
>  	unsigned long flags;
>  
>  	if (fh->events == NULL) {
> @@ -231,15 +258,31 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  		return -ENOMEM;
>  	}
>  
> +	if (sub->type == V4L2_EVENT_CTRL_CH_VALUE) {
> +		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
> +		if (ctrl == NULL)
> +			return -EINVAL;
> +	}
> +
>  	sev = kmalloc(sizeof(*sev), GFP_KERNEL);
>  	if (!sev)
>  		return -ENOMEM;
> +	if (ctrl) {
> +		ctrl_fh = kzalloc(sizeof(*ctrl_fh), GFP_KERNEL);
> +		if (!ctrl_fh) {
> +			kfree(sev);
> +			return -ENOMEM;
> +		}
> +		ctrl_fh->fh = fh;
> +	}
>  
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  
> -	if (v4l2_event_subscribed(fh, sub->type) == NULL) {
> +	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
> +	if (!found_ev) {
>  		INIT_LIST_HEAD(&sev->list);
>  		sev->type = sub->type;
> +		sev->id = sub->id;
>  
>  		list_add(&sev->list, &events->subscribed);
>  		sev = NULL;
> @@ -247,6 +290,10 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>  
> +	/* v4l2_ctrl_add_fh uses a mutex, so do this outside the spin lock */
> +	if (!found_ev && ctrl)
> +		v4l2_ctrl_add_fh(ctrl, ctrl_fh);
> +
>  	kfree(sev);
>  
>  	return 0;
> @@ -256,6 +303,7 @@ EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
>  static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
>  {
>  	struct v4l2_events *events = fh->events;
> +	struct v4l2_event_subscription sub;
>  	struct v4l2_subscribed_event *sev;
>  	unsigned long flags;
>  
> @@ -265,11 +313,13 @@ static void v4l2_event_unsubscribe_all(struct v4l2_fh *fh)
>  		spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  		if (!list_empty(&events->subscribed)) {
>  			sev = list_first_entry(&events->subscribed,
> -				       struct v4l2_subscribed_event, list);
> -			list_del(&sev->list);
> +					struct v4l2_subscribed_event, list);
> +			sub.type = sev->type;
> +			sub.id = sev->id;
>  		}
>  		spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> -		kfree(sev);
> +		if (sev)
> +			v4l2_event_unsubscribe(fh, &sub);
>  	} while (sev);
>  }
>  
> @@ -286,11 +336,17 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  
> -	sev = v4l2_event_subscribed(fh, sub->type);
> +	sev = v4l2_event_subscribed(fh, sub->type, sub->id);
>  	if (sev != NULL)
>  		list_del(&sev->list);
>  
>  	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
> +	if (sev->type == V4L2_EVENT_CTRL_CH_VALUE) {
> +		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
> +
> +		if (ctrl)
> +			v4l2_ctrl_del_fh(ctrl, fh);
> +	}
>  
>  	kfree(sev);
>  
> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
> index 8635011..c6aef84 100644
> --- a/drivers/media/video/v4l2-fh.c
> +++ b/drivers/media/video/v4l2-fh.c
> @@ -93,10 +93,8 @@ void v4l2_fh_exit(struct v4l2_fh *fh)
>  {
>  	if (fh->vdev == NULL)
>  		return;
> -
> -	fh->vdev = NULL;
> -
>  	v4l2_event_free(fh);
> +	fh->vdev = NULL;

This looks like a bugfix.

>  }
>  EXPORT_SYMBOL_GPL(v4l2_fh_exit);
>  
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 92d2fdd..f7238c1 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -1787,6 +1787,7 @@ struct v4l2_streamparm {
>  #define V4L2_EVENT_ALL				0
>  #define V4L2_EVENT_VSYNC			1
>  #define V4L2_EVENT_EOS				2
> +#define V4L2_EVENT_CTRL_CH_VALUE		3
>  #define V4L2_EVENT_PRIVATE_START		0x08000000
>  
>  /* Payload for V4L2_EVENT_VSYNC */
> @@ -1795,21 +1796,33 @@ struct v4l2_event_vsync {
>  	__u8 field;
>  } __attribute__ ((packed));
>  
> +/* Payload for V4L2_EVENT_CTRL_CH_VALUE */
> +struct v4l2_event_ctrl_ch_value {
> +	__u32 type;

type is enum v4l2_ctrl_type in struct v4l2_ctrl and struct v4l2_queryctrl.

> +	union {
> +		__s32 value;
> +		__s64 value64;
> +	};
> +} __attribute__ ((packed));
> +
>  struct v4l2_event {
>  	__u32				type;
>  	union {
>  		struct v4l2_event_vsync vsync;
> +		struct v4l2_event_ctrl_ch_value ctrl_ch_value;
>  		__u8			data[64];
>  	} u;
>  	__u32				pending;
>  	__u32				sequence;
>  	struct timespec			timestamp;
> -	__u32				reserved[9];
> +	__u32				id;

id is valid only for control related events. Shouldn't it be part of the
control related structures instead, or another union for control related
event types? E.g.

struct {
	enum v4l2_ctrl_type	id;
	union {
		struct v4l2_event_ctrl_ch_value ch_value;
	};
} ctrl;

> +	__u32				reserved[8];
>  };
>  
>  struct v4l2_event_subscription {
>  	__u32				type;
> -	__u32				reserved[7];
> +	__u32				id;
> +	__u32				reserved[6];
>  };

Similar situation here, but no existing union where id would fit in.

>  /*
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 97d0638..7ca45a5 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -30,6 +30,7 @@ struct v4l2_ctrl_handler;
>  struct v4l2_ctrl;
>  struct video_device;
>  struct v4l2_subdev;
> +struct v4l2_fh;
>  
>  /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
>    * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
> @@ -97,6 +98,7 @@ struct v4l2_ctrl_ops {
>  struct v4l2_ctrl {
>  	/* Administrative fields */
>  	struct list_head node;
> +	struct list_head fhs;
>  	struct v4l2_ctrl_handler *handler;
>  	struct v4l2_ctrl **cluster;
>  	unsigned ncontrols;
> @@ -168,6 +170,11 @@ struct v4l2_ctrl_handler {
>  	int error;
>  };
>  
> +struct v4l2_ctrl_fh {
> +	struct list_head node;
> +	struct v4l2_fh *fh;
> +};
> +
>  /** struct v4l2_ctrl_config - Control configuration structure.
>    * @ops:	The control ops.
>    * @id:	The control ID.
> @@ -440,6 +447,8 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
>    */
>  int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
>  
> +void v4l2_ctrl_add_fh(struct v4l2_ctrl *ctrl, struct v4l2_ctrl_fh *ctrl_fh);
> +void v4l2_ctrl_del_fh(struct v4l2_ctrl *ctrl, struct v4l2_fh *fh);
>  
>  /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
>  int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> index 3b86177..45e9c1e 100644
> --- a/include/media/v4l2-event.h
> +++ b/include/media/v4l2-event.h
> @@ -40,6 +40,7 @@ struct v4l2_kevent {
>  struct v4l2_subscribed_event {
>  	struct list_head	list;
>  	u32			type;
> +	u32			id;
>  };

And here.

>  struct v4l2_events {
> @@ -58,6 +59,7 @@ void v4l2_event_free(struct v4l2_fh *fh);
>  int v4l2_event_dequeue(struct v4l2_fh *fh, struct v4l2_event *event,
>  		       int nonblocking);
>  void v4l2_event_queue(struct video_device *vdev, const struct v4l2_event *ev);
> +void v4l2_event_queue_fh(struct v4l2_fh *fh, const struct v4l2_event *ev);
>  int v4l2_event_pending(struct v4l2_fh *fh);
>  int v4l2_event_subscribe(struct v4l2_fh *fh,
>  			 struct v4l2_event_subscription *sub);

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

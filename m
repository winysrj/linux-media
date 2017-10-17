Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35623 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936802AbdJQSQn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 14:16:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: Re: [PATCH 5/6 v5]  uvcvideo: send a control event when a Control Change interrupt arrives
Date: Tue, 17 Oct 2017 21:17:02 +0300
Message-ID: <2858114.hzeuBgAb7H@avalon>
In-Reply-To: <1501245205-15802-6-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de> <1501245205-15802-6-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

Hans, please read through, there's one question for you below.

On Friday, 28 July 2017 15:33:24 EEST Guennadi Liakhovetski wrote:
> UVC defines a method of handling asynchronous controls, which sends a
> USB packet over the interrupt pipe. This patch implements support for
> such packets by sending a control event to the user. Since this can
> involve USB traffic and, therefore, scheduling, this has to be done
> in a work queue.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
>  drivers/media/usb/uvc/uvc_ctrl.c   | 147 ++++++++++++++++++++++++++++++----
>  drivers/media/usb/uvc/uvc_status.c | 112 +++++++++++++++++++++++++---
>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
>  drivers/media/usb/uvc/uvcvideo.h   |  14 +++-
>  include/uapi/linux/uvcvideo.h      |   2 +
>  5 files changed, 251 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index 91ff2c7..be18707 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -20,6 +20,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
> +#include <linux/workqueue.h>
>  #include <linux/atomic.h>
>  #include <media/v4l2-ctrls.h>
> 
> @@ -1236,16 +1237,110 @@ static void uvc_ctrl_send_event(struct uvc_fh
> *handle, }
>  }
> 
> -static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> -	struct uvc_control *master, u32 slave_id,
> -	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> +static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> +				struct uvc_control *master, u32 slave_id)
>  {
>  	struct uvc_control_mapping *mapping = NULL;
>  	struct uvc_control *ctrl = NULL;
>  	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> -	unsigned int i;
>  	s32 val = 0;
> 
> +	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> +	if (ctrl == NULL)
> +		return;
> +
> +	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> +		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> +
> +	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> +}
> +
> +static void uvc_ctrl_status_event_work(struct work_struct *work)
> +{
> +	struct uvc_device *dev = container_of(work, struct uvc_device,
> +					      async_ctrl.work);
> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> +	struct uvc_control_mapping *mapping;
> +	struct uvc_control *ctrl;
> +	struct uvc_fh *handle;
> +	__u8 *data;

You can make this a const pointer, and you can use the u8 type directly inside 
the kernel.

> +	unsigned int i;
> +
> +	spin_lock_irq(&w->lock);
> +	data = w->data;
> +	w->data = NULL;
> +	ctrl = w->ctrl;
> +	handle = ctrl->handle;
> +	ctrl->handle = NULL;

ctrl->handle is set without taking w->lock. Could there be a race condition ?

> +	spin_unlock_irq(&w->lock);
> +
> +	if (mutex_lock_interruptible(&handle->chain->ctrl_mutex))
> +		goto free;

This will crash if the camera sends an asynchronous control change event 
without a previous SET_CUR. This should not happen with compliant devices, but 
let's make sure that buggy or even malicious devices won't cause a denial of 
service.

Shouldn't we have one workqueue per chain to avoid events for multiple chains 
blocking each other ?

I assume you've used the interruptible lock here to ensure that 
cancel_work_sync() can wake up the work queue ? If so, hav you double-checked 
that mutex_lock_interruptible() can be interrupted by cancel_work_sync() ?

> +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> +		s32 value = mapping->get(mapping, UVC_GET_CUR, data);
> +
> +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> +			if (!mapping->slave_ids[i])
> +				break;
> +
> +			__uvc_ctrl_send_slave_event(handle, ctrl,
> +						    mapping->slave_ids[i]);
> +		}
> +
> +		if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> +			struct uvc_menu_info *menu = mapping->menu_info;
> +			unsigned int i;
> +
> +			for (i = 0; i < mapping->menu_count; ++i, ++menu)
> +				if (menu->value == value) {
> +					value = i;
> +					break;
> +				}
> +		}
> +
> +		uvc_ctrl_send_event(handle, ctrl, mapping, value,
> +				    V4L2_EVENT_CTRL_CH_VALUE);
> +	}
> +
> +	mutex_unlock(&handle->chain->ctrl_mutex);
> +
> +free:
> +	kfree(data);
> +}
> +
> +void uvc_ctrl_status_event(struct uvc_device *dev, struct uvc_control
> *ctrl,
> +			   __u8 *data, size_t len)
> +{
> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> +
> +	if (list_empty(&ctrl->info.mappings))
> +		return;
> +
> +	if (!ctrl->handle)
> +		/* This is an auto-update, they are unsupported */

What is "they" here ?

> +		return;
> +
> +	spin_lock(&w->lock);
> +	if (w->data)
> +		/* A previous event work hasn't run yet, we lose 1 event */
> +		kfree(w->data);
> +
> +	w->data = kmalloc(len, GFP_ATOMIC);
> +	if (w->data) {
> +		memcpy(w->data, data, len);
> +		w->ctrl = ctrl;
> +		schedule_work(&w->work);
> +	}
> +	spin_unlock(&w->lock);

Could you move the allocation out of the spinlock-protected region ? I propose 
the following.

	data = kmalloc(len, GFP_ATOMIC);
	if (!data)
		return;

	memcpy(data, data, len);

	spin_lock(&w->lock);
	swap(w->data, data);
	w->ctrl = ctrl;
	schedule_work(&w->work);
	spin_unlock(&w->lock);

	if (data) {
		/* A previous event work hasn't run yet, we lose 1 event */
		kfree(data);
	}

What bothers me here is that only one event can be processed at a time. While 
I agree that we could drop all but the last event for a given control, events 
related to separate controls should all be processed. An implementation based 
on a linked-list might be better, but care should be taken not to deplete the 
atomic memory pool if the device sends a storm of control change events.

> +}
> +
> +static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> +	struct uvc_control *master, u32 slave_id,
> +	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> +{
> +	unsigned int i;
> +
>  	/*
>  	 * We can skip sending an event for the slave if the slave
>  	 * is being modified in the same transaction.
> @@ -1255,14 +1350,7 @@ static void uvc_ctrl_send_slave_event(struct uvc_fh
> *handle, return;
>  	}
> 
> -	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> -	if (ctrl == NULL)
> -		return;
> -
> -	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> -		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> -
> -	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> +	__uvc_ctrl_send_slave_event(handle, master, slave_id);
>  }
> 
>  static void uvc_ctrl_send_events(struct uvc_fh *handle,
> @@ -1277,6 +1365,10 @@ static void uvc_ctrl_send_events(struct uvc_fh
> *handle, for (i = 0; i < xctrls_count; ++i) {
>  		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
> 
> +		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
> +			/* Notification will be sent from an Interrupt event */
> +			continue;
> +
>  		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
>  			if (!mapping->slave_ids[j])
>  				break;
> @@ -1472,9 +1564,10 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
>  	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
>  }
> 
> -int uvc_ctrl_set(struct uvc_video_chain *chain,
> +int uvc_ctrl_set(struct uvc_fh *handle,
>  	struct v4l2_ext_control *xctrl)
>  {
> +	struct uvc_video_chain *chain = handle->chain;
>  	struct uvc_control *ctrl;
>  	struct uvc_control_mapping *mapping;
>  	s32 value;
> @@ -1488,6 +1581,18 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  		return -EINVAL;
>  	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
>  		return -EACCES;
> +	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
> +		if (ctrl->handle)
> +			/*
> +			 * Actually we could send the control and let the camera
> +			 * issue a STALL, but we have to check here anyway.
> +			 * Besides we cannot process a new instance of the same
> +			 * asynchronous control, while the previous one is still
> +			 * active.
> +			 */
> +			return -EBUSY;
> +		ctrl->handle = handle;

This is an interesting design decision. Instead of waiting for the control set 
to complete, the ioctl will return immediately, and a control value change 
event will be sent to userspace later. I wonder whether we shouldn't instead 
wait for the control change to complete before returning to userspace. Hans, 
what do you think ?

> +	}
> 
>  	/* Clamp out of range values. */
>  	switch (mapping->v4l2_type) {
> @@ -1676,7 +1781,9 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device
> *dev,
>  		    | (data[0] & UVC_CONTROL_CAP_SET ?
>  		       UVC_CTRL_FLAG_SET_CUR : 0)
>  		    | (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> -		       UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> +		       UVC_CTRL_FLAG_AUTO_UPDATE : 0)
> +		    | (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
> +		       UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
> 
>  	uvc_ctrl_fixup_xu_info(dev, ctrl, info);
> 
> @@ -2124,6 +2231,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device
> *dev, struct uvc_control *ctrl) if (!ctrl->initialized)
>  		return;
> 
> +	/* Temporarily abuse DATA_CURRENT buffer to avoid 1 byte allocation */
> +	if (!uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
> +			    dev->intfnum, info->selector,
> +			    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), 1) &&
> +	    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT)[0] & 0x10)
> +		ctrl->info.flags |= UVC_CTRL_FLAG_ASYNCHRONOUS;
> +

This change conflicts with "[PATCH] uvcvideo: Apply flags from device to 
actual properties" which I will probably merge first as it explains why 
getting info for non-XU controls is needed, while the change would be a side 
effect here without a clear explanation.

>  	for (; mapping < mend; ++mapping) {
>  		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
>  		    ctrl->info.selector == mapping->selector)
> @@ -2139,6 +2253,9 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
>  	struct uvc_entity *entity;
>  	unsigned int i;
> 
> +	spin_lock_init(&dev->async_ctrl.lock);
> +	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
> +
>  	/* Walk the entities list and instantiate controls */
>  	list_for_each_entry(entity, &dev->entities, list) {
>  		struct uvc_control *ctrl;
> @@ -2210,6 +2327,8 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
>  	struct uvc_entity *entity;
>  	unsigned int i;
> 
> +	cancel_work_sync(&dev->async_ctrl.work);
> +
>  	/* Free controls and control mappings for all entities. */
>  	list_for_each_entry(entity, &dev->entities, list) {
>  		for (i = 0; i < entity->ncontrols; ++i) {
> diff --git a/drivers/media/usb/uvc/uvc_status.c
> b/drivers/media/usb/uvc/uvc_status.c index f552ab9..e3538ff 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -78,7 +78,24 @@ static void uvc_input_report_key(struct uvc_device *dev,
> unsigned int code,
> /* -------------------------------------------------------------------------
>  * Status interrupt endpoint
>  */
> -static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int
> len)
> +struct uvc_streaming_status {
> +	__u8	bStatusType;
> +	__u8	bOriginator;
> +	__u8	bEvent;
> +	__u8	bValue[];
> +} __packed;
> +
> +struct uvc_control_status {
> +	__u8	bStatusType;
> +	__u8	bOriginator;
> +	__u8	bEvent;
> +	__u8	bSelector;
> +	__u8	bAttribute;
> +	__u8	bValue[];
> +} __packed;

How about defining the structures in include/uapi/linux/usb/video.h to make 
them usable by the UVC gadget driver too ?

> +static void uvc_event_streaming(struct uvc_device *dev,
> +				struct uvc_streaming_status *status, int len)

While at it, shouldn't status be a const pointer, and len a size_t (don't 
forget to update the format string in the uvc_trace calls below) ?

>  {
>  	if (len < 3) {
>  		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
> @@ -86,30 +103,101 @@ static void uvc_event_streaming(struct uvc_device
> *dev, __u8 *data, int len) return;
>  	}
> 
> -	if (data[2] == 0) {
> +	if (status->bEvent == 0) {

The driver parses data buffers directly in the rest of the code so this change 
feels a bit weird to me, but I think it makes sense. I'll just need to get 
used to it :-)

>  		if (len < 4)
>  			return;
>  		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
> -			data[1], data[3] ? "pressed" : "released", len);
> -		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
> +			  status->bOriginator,
> +			  status->bValue[0] ? "pressed" : "released", len);
> +		uvc_input_report_key(dev, KEY_CAMERA, status->bValue[0]);
>  	} else {
>  		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
> -			"len %d.\n", data[1], data[2], data[3], len);
> +			  "len %d.\n", status->bOriginator, status->bEvent,
> +			  status->bValue[0], len);

I think there was a bug here, according to the UVC specification stream error 
events carry no data. I've just sent a patch to fix it ("[PATCH] uvcvideo: 
Stream error events carry no data") and CC'ed you.

>  	}
>  }
> 
> -static void uvc_event_control(struct uvc_device *dev, __u8 *data, int len)
> +#define UVC_CTRL_VALUE_CHANGE	0
> +#define UVC_CTRL_INFO_CHANGE	1
> +#define UVC_CTRL_FAILURE_CHANGE	2
> +#define UVC_CTRL_MIN_CHANGE	3
> +#define UVC_CTRL_MAX_CHANGE	4

These macros should also be moved to the include/uapi/linux/usb/video.h 
header.

> +static struct uvc_control *uvc_event_entity_ctrl(struct uvc_entity *entity,
> +					       __u8 selector)
> +{
> +	struct uvc_control *ctrl;
> +	unsigned int i;
> +
> +	for (i = 0, ctrl = entity->controls; i < entity->ncontrols; i++, ctrl++)
> +		if (ctrl->info.selector == selector)
> +			return ctrl;

Even though not strictly mandatory in C, please use curly braces around the 
for loop statement to match the driver style (I personally find it more 
readable).

> +
> +	return NULL;
> +}
> +
> +static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
> +					struct uvc_control_status *status)
> +{
> +	struct uvc_video_chain *chain;
> +
> +	list_for_each_entry(chain, &dev->chains, list) {
> +		struct uvc_entity *entity;
> +		struct uvc_control *ctrl;
> +
> +		list_for_each_entry(entity, &chain->entities, chain) {
> +			if (entity->id == status->bOriginator) {

I'd write this

		if (entity->id != status->bOriginator)
			continue;

to decrease the indentation level below and avoid wrapping lines.

> +				ctrl = uvc_event_entity_ctrl(entity,
> +							     status->bSelector);
> +				/*
> +				 * Some buggy cameras send asynchronous Control
> +				 * Change events for control, other than the
> +				 * ones, that had been changed, even though the
> +				 * AutoUpdate flag isn't set for the control.

What do you mean by "other than the ones" here ?

Also, what cameras have you found that exhibit this problem ?

> +				 */
> +				if (ctrl && (!ctrl->handle ||
> +					     ctrl->handle->chain == chain))
> +					return ctrl;

You can then return NULL here, as there will be no other entity in the chain 
that will match the originator. Actually you could just break from the loop 
when the entity id matches, and move the uvc_event_entity_ctrl() call after 
the loop.

> +			}
> +		}
> +	}
> +
> +	return NULL;
> +}
> +
> +static void uvc_event_control(struct uvc_device *dev,
> +			      struct uvc_control_status *status, int len)
>  {
> -	char *attrs[3] = { "value", "info", "failure" };
> +	struct uvc_control *ctrl;
> +	char *attrs[] = { "value", "info", "failure", "min", "max" };

The control min and max change events are only supported by UVC 1.5. As the 
driver is limited to UVC 1.1 for now, I wouldn't implement them in this patch.

> -	if (len < 6 || data[2] != 0 || data[4] > 2) {
> +	if (len < 6 || status->bEvent != 0 ||
> +	    status->bAttribute >= ARRAY_SIZE(attrs)) {
>  		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
>  				"received.\n");
>  		return;
>  	}
> 
>  	uvc_trace(UVC_TRACE_STATUS, "Control %u/%u %s change len %d.\n",
> -		data[1], data[3], attrs[data[4]], len);
> +		  status->bOriginator, status->bSelector,
> +		  attrs[status->bAttribute], len);
> +
> +	/* Find the control. */
> +	ctrl = uvc_event_find_ctrl(dev, status);
> +	if (!ctrl)
> +		return;
> +
> +	switch (status->bAttribute) {
> +	case UVC_CTRL_VALUE_CHANGE:
> +		uvc_ctrl_status_event(dev, ctrl, status->bValue, len -
> +				      offsetof(struct uvc_control_status, bValue));
> +		break;
> +	case UVC_CTRL_INFO_CHANGE:
> +	case UVC_CTRL_FAILURE_CHANGE:
> +	case UVC_CTRL_MIN_CHANGE:
> +	case UVC_CTRL_MAX_CHANGE:
> +		break;
> +	}
>  }
> 
>  static void uvc_status_complete(struct urb *urb)
> @@ -138,11 +226,13 @@ static void uvc_status_complete(struct urb *urb)
>  	if (len > 0) {
>  		switch (dev->status[0] & 0x0f) {
>  		case UVC_STATUS_TYPE_CONTROL:
> -			uvc_event_control(dev, dev->status, len);
> +			uvc_event_control(dev,
> +				(struct uvc_control_status *)dev->status, len);
>  			break;
> 
>  		case UVC_STATUS_TYPE_STREAMING:
> -			uvc_event_streaming(dev, dev->status, len);
> +			uvc_event_streaming(dev,
> +				(struct uvc_streaming_status *)dev->status, len);
>  			break;
> 
>  		default:
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 3e7e283..06be5f6 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -970,7 +970,7 @@ static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
> if (ret < 0)
>  		return ret;
> 
> -	ret = uvc_ctrl_set(chain, &xctrl);
> +	ret = uvc_ctrl_set(handle, &xctrl);
>  	if (ret < 0) {
>  		uvc_ctrl_rollback(handle);
>  		return ret;
> @@ -1045,7 +1045,7 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh
> *handle, return ret;
> 
>  	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> -		ret = uvc_ctrl_set(chain, ctrl);
> +		ret = uvc_ctrl_set(handle, ctrl);
>  		if (ret < 0) {
>  			uvc_ctrl_rollback(handle);
>  			ctrls->error_idx = commit ? ctrls->count : i;
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index 4241f40..0fbd259 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -11,6 +11,7 @@
>  #include <linux/usb/video.h>
>  #include <linux/uvcvideo.h>
>  #include <linux/videodev2.h>
> +#include <linux/workqueue.h>
>  #include <media/media-device.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-event.h>
> @@ -251,6 +252,8 @@ struct uvc_control {
>  	     initialized:1;
> 
>  	__u8 *uvc_data;
> +
> +	struct uvc_fh *handle;	/* Used for asynchronous event delivery */
>  };
> 
>  struct uvc_format_desc {
> @@ -595,6 +598,13 @@ struct uvc_device {
>  	__u8 *status;
>  	struct input_dev *input;
>  	char input_phys[64];
> +
> +	struct uvc_ctrl_work {
> +		struct work_struct work;
> +		struct uvc_control *ctrl;
> +		spinlock_t lock;
> +		void *data;
> +	} async_ctrl;
>  };
> 
>  enum uvc_handle_state {
> @@ -742,6 +752,8 @@ extern int uvc_ctrl_add_mapping(struct uvc_video_chain
> *chain, extern int uvc_ctrl_init_device(struct uvc_device *dev);
>  extern void uvc_ctrl_cleanup_device(struct uvc_device *dev);
>  extern int uvc_ctrl_restore_values(struct uvc_device *dev);
> +extern void uvc_ctrl_status_event(struct uvc_device *dev,
> +		struct uvc_control *ctrl, __u8 *data, size_t len);
> 
>  extern int uvc_ctrl_begin(struct uvc_video_chain *chain);
>  extern int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
> @@ -760,7 +772,7 @@ static inline int uvc_ctrl_rollback(struct uvc_fh
> *handle)
> 
>  extern int uvc_ctrl_get(struct uvc_video_chain *chain,
>  		struct v4l2_ext_control *xctrl);
> -extern int uvc_ctrl_set(struct uvc_video_chain *chain,
> +extern int uvc_ctrl_set(struct uvc_fh *handle,
>  		struct v4l2_ext_control *xctrl);
> 
>  extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
> index ffe17ec..a1c82d5 100644
> --- a/include/uapi/linux/uvcvideo.h
> +++ b/include/uapi/linux/uvcvideo.h
> @@ -27,6 +27,8 @@
>  #define UVC_CTRL_FLAG_RESTORE		(1 << 6)
>  /* Control can be updated by the camera. */
>  #define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
> +/* Control supports asynchronous reporting */
> +#define UVC_CTRL_FLAG_ASYNCHRONOUS	(1 << 8)
> 
>  #define UVC_CTRL_FLAG_GET_RANGE \
>  	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50739 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751959AbeDJLbj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 07:31:39 -0400
Date: Tue, 10 Apr 2018 13:31:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/2] uvcvideo: send a control event when a Control
 Change interrupt arrives
In-Reply-To: <2079648.niC1Apbgeu@avalon>
Message-ID: <alpine.DEB.2.20.1804100848040.29394@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <20180323092401.12162-2-laurent.pinchart@ideasonboard.com> <2079648.niC1Apbgeu@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

First a couple of replies to your questions.

On Fri, 23 Mar 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Friday, 23 March 2018 11:24:00 EET Laurent Pinchart wrote:
> > From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > UVC defines a method of handling asynchronous controls, which sends a
> > USB packet over the interrupt pipe. This patch implements support for
> > such packets by sending a control event to the user. Since this can
> > involve USB traffic and, therefore, scheduling, this has to be done
> > in a work queue.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 166 ++++++++++++++++++++++++++++++----
> >  drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> >  include/uapi/linux/uvcvideo.h      |   2 +
> >  5 files changed, 269 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index 4042cbdb721b..f4773c56438c 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/vmalloc.h>
> >  #include <linux/wait.h>
> > +#include <linux/workqueue.h>
> >  #include <linux/atomic.h>
> >  #include <media/v4l2-ctrls.h>
> > 
> > @@ -1222,30 +1223,134 @@ static void uvc_ctrl_send_event(struct uvc_fh
> > *handle, {
> >  	struct v4l2_subscribed_event *sev;
> >  	struct v4l2_event ev;
> > +	bool autoupdate;
> > 
> >  	if (list_empty(&mapping->ev_subs))
> >  		return;
> > 
> > +	if (!handle) {
> 
> In which circumstances does this happen ? Is it when the device reports a 
> control change event without an prior control set ? Have you seen that 
> happening in practice ?

This happens with autoupdate controls. Yes, I've seen this happen.

> 
> > +		autoupdate = true;
> > +		sev = list_first_entry(&mapping->ev_subs,
> > +				       struct v4l2_subscribed_event, node);
> > +		handle = container_of(sev->fh, struct uvc_fh, vfh);
> 
> There's a check below that guards against sev->fh being NULL. Could sev->fh be 
> NULL here ?

I cannot see how that can happen, but if you see such a possibility, I can 
add a check.

> > +	} else {
> > +		autoupdate = false;
> > +	}
> > +
> >  	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
> > 
> >  	list_for_each_entry(sev, &mapping->ev_subs, node) {
> >  		if (sev->fh && (sev->fh != &handle->vfh ||
> >  		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> > -		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
> > +		    (changes & V4L2_EVENT_CTRL_CH_FLAGS) || autoupdate))
> >  			v4l2_event_queue_fh(sev->fh, &ev);
> >  	}
> >  }
> > 
> > -static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> > -	struct uvc_control *master, u32 slave_id,
> > -	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> > +static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> > +				struct uvc_control *master, u32 slave_id)
> >  {
> >  	struct uvc_control_mapping *mapping = NULL;
> >  	struct uvc_control *ctrl = NULL;
> >  	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> > -	unsigned int i;
> >  	s32 val = 0;
> > 
> > +	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> > +	if (ctrl == NULL)
> > +		return;
> > +
> > +	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> > +		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> > +
> > +	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> > +}
> > +
> > +static void uvc_ctrl_status_event_work(struct work_struct *work)
> > +{
> > +	struct uvc_device *dev = container_of(work, struct uvc_device,
> > +					      async_ctrl.work);
> > +	struct uvc_video_chain *chain;
> > +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +	struct uvc_control_mapping *mapping;
> > +	struct uvc_control *ctrl;
> > +	struct uvc_fh *handle;
> > +	unsigned int i;
> > +	u8 *data;
> > +
> > +	spin_lock_irq(&w->lock);
> > +	data = w->data;
> > +	w->data = NULL;
> > +	chain = w->chain;
> > +	ctrl = w->ctrl;
> > +	handle = ctrl->handle;
> > +	ctrl->handle = NULL;
> > +	spin_unlock_irq(&w->lock);
> > +
> > +	if (mutex_lock_interruptible(&chain->ctrl_mutex))
> > +		goto free;
> 
> This will result in the event being lost, which isn't very nice (see below for 
> additional comments on this topic). Can't we use mutex_lock() ?

This is in a scheduler work context, I don't think I've ever really seen 
that being interrupted, so, sure, don't think that would change anything.

> 
> > +
> > +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> > +		s32 value = mapping->get(mapping, UVC_GET_CUR, data);
> > +
> > +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> > +			if (!mapping->slave_ids[i])
> > +				break;
> > +
> > +			__uvc_ctrl_send_slave_event(handle, ctrl,
> > +						    mapping->slave_ids[i]);
> > +		}
> > +
> > +		if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> > +			struct uvc_menu_info *menu = mapping->menu_info;
> > +			unsigned int i;
> > +
> > +			for (i = 0; i < mapping->menu_count; ++i, ++menu)
> > +				if (menu->value == value) {
> > +					value = i;
> > +					break;
> > +				}
> > +		}
> 
> Would this be useful to move the mapping->get() and menu control handling code 
> out of __uvc_ctrl_get() into a __uvc_ctrl_get_value() function and call it 
> here ?

Should be possible, yes.

> 
> > +		uvc_ctrl_send_event(handle, ctrl, mapping, value,
> > +				    V4L2_EVENT_CTRL_CH_VALUE);
> > +	}
> > +
> > +	mutex_unlock(&chain->ctrl_mutex);
> > +
> > +free:
> > +	kfree(data);
> > +}
> > +
> > +void uvc_ctrl_status_event(struct uvc_video_chain *chain,
> > +			   struct uvc_control *ctrl, u8 *data, size_t len)
> > +{
> > +	struct uvc_device *dev = chain->dev;
> > +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +
> > +	if (list_empty(&ctrl->info.mappings))
> > +		return;
> > +
> > +	spin_lock(&w->lock);
> > +	if (w->data)
> > +		/* A previous event work hasn't run yet, we lose 1 event */
> > +		kfree(w->data);
> 
> I really don't like losing events :/ 

Well, I'm not sure whether having no available status URBs isn't 
equivalent to losing events, but if you prefer that - no problem.

> 
> > +	w->data = kmalloc(len, GFP_ATOMIC);
> 
> GFP_ATOMIC allocation isn't very nice either.
> 
> How about if we instead delayed resubmitting the status URB until the event is 
> fully processed by the work queue ? That way we wouldn't lose events, we 
> wouldn't need memory allocation in atomic context, and if the work queue 
> becomes a bottleneck we could even queue multiple status URBs and easily add 
> them to a list for processing by the work queue.

You mean only for control status events? Can do, sure.

> 
> > +	if (w->data) {
> > +		memcpy(w->data, data, len);
> > +		w->chain = chain;
> > +		w->ctrl = ctrl;
> > +		schedule_work(&w->work);
> > +	}
> > +	spin_unlock(&w->lock);
> > +}
> > +
> > +static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> > +	struct uvc_control *master, u32 slave_id,
> > +	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> > +{
> > +	unsigned int i;
> > +
> >  	/*
> >  	 * We can skip sending an event for the slave if the slave
> >  	 * is being modified in the same transaction.
> > @@ -1255,14 +1360,7 @@ static void uvc_ctrl_send_slave_event(struct uvc_fh
> > *handle, return;
> >  	}
> > 
> > -	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> > -	if (ctrl == NULL)
> > -		return;
> > -
> > -	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> > -		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> > -
> > -	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> > +	__uvc_ctrl_send_slave_event(handle, master, slave_id);
> >  }
> > 
> >  static void uvc_ctrl_send_events(struct uvc_fh *handle,
> > @@ -1277,6 +1375,10 @@ static void uvc_ctrl_send_events(struct uvc_fh
> > *handle, for (i = 0; i < xctrls_count; ++i) {
> >  		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
> > 
> > +		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
> > +			/* Notification will be sent from an Interrupt event */
> 
> Nitpicking, could you add a period at the end of sentences to match the 
> comment style in the driver ?
> 
> > +			continue;
> > +
> >  		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
> >  			if (!mapping->slave_ids[j])
> >  				break;
> > @@ -1472,9 +1574,10 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
> >  	return __uvc_ctrl_get(chain, ctrl, mapping, &xctrl->value);
> >  }
> > 
> > -int uvc_ctrl_set(struct uvc_video_chain *chain,
> > +int uvc_ctrl_set(struct uvc_fh *handle,
> >  	struct v4l2_ext_control *xctrl)
> >  {
> > +	struct uvc_video_chain *chain = handle->chain;
> >  	struct uvc_control *ctrl;
> >  	struct uvc_control_mapping *mapping;
> >  	s32 value;
> > @@ -1488,6 +1591,25 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
> >  		return -EINVAL;
> >  	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
> >  		return -EACCES;
> > +	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
> > +		if (ctrl->handle)
> > +			/*
> > +			 * We have already sent this control to the camera
> > +			 * recently and are currently waiting for a completion
> > +			 * notification. The camera might already have completed
> > +			 * its processing and is ready to accept a new control
> > +			 * or it's still busy processing. If we send a new
> > +			 * instance of this control now, in the former case the
> > +			 * camera will process this one too and we'll get
> > +			 * completions for both, but we will only deliver an
> > +			 * event for one of them back to the user. In the latter
> > +			 * case the camera will reply with a STALL. It's easier
> > +			 * and more reliable to return an error now and let the
> > +			 * user retry.
> > +			 */
> > +			return -EBUSY;
> > +		ctrl->handle = handle;
> 
> This part worries me. If the control change event isn't received for any 
> reason (such as a buggy device for instance, or uvc_ctrl_status_event() being 
> called with the previous event not processed yet), the control will stay busy 
> forever.
> 
> I see two approaches to fix this. One would be to forward all received control 
> change events to all file handles unconditionally and remove the handle field 
> from the uvc_control structure.

How is this a solution? A case of senging a repeated control to the camera 
and causing a STALL would still be possible. If you prefer STALLs, you 
could just remove this check here.

> Another one would be to add a timeout, storing 
> the time at which the control has been set in the uvc_control structure, and 
> checking whether the time difference exceeds a fixed timeout here. We could 
> also combine the two, replacing the handle field with a timestamp field.

Don't think you can remove the handle field, there are a couple of things, 
that need it, also you'll have to send events to all listeners, including 
the thread, that has sent the control, which contradicts the API? Assuming 
it hasn't set the V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK flag.

I can add a timeout, even though that doesn't seem to be very clean to me. 
According to the UVC standard some controls can take a while to complete, 
possibly seconds. How long would you propose that timeout to be?

> 
> Please keep in mind if trying this out that simply storing jiffies as a 
> timestamp might cause counter overflow issues if the control is set, no event 
> is ever received, and a second control set happens much later after one (or 
> multiple) jiffies wraparounds. We could end up returning -EBUSY incorrectly. 
> That might not be a real issue given the size of the jiffies counter though,  
> I'll let you double-check.
> 
> > +	}
> > 
> >  	/* Clamp out of range values. */
> >  	switch (mapping->v4l2_type) {
> > @@ -1612,7 +1734,9 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
> >  			    |  (data[0] & UVC_CONTROL_CAP_SET ?
> >  				UVC_CTRL_FLAG_SET_CUR : 0)
> >  			    |  (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> > -				UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> > +				UVC_CTRL_FLAG_AUTO_UPDATE : 0)
> > +			    |  (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
> > +				UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
> > 
> >  	kfree(data);
> >  	return ret;
> > @@ -2158,6 +2282,13 @@ static void uvc_ctrl_init_ctrl(struct uvc_device
> > *dev, struct uvc_control *ctrl) if (!ctrl->initialized)
> >  		return;
> > 
> > +	/* Temporarily abuse DATA_CURRENT buffer to avoid 1 byte allocation */
> > +	if (!uvc_query_ctrl(dev, UVC_GET_INFO, ctrl->entity->id,
> > +			    dev->intfnum, info->selector,
> > +			    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT), 1) &&
> > +	    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT)[0] & 0x10)
> > +		ctrl->info.flags |= UVC_CTRL_FLAG_ASYNCHRONOUS;
> 
> I think this isn't needed anymore as the uvc_ctrl_add_info() function now 
> calls uvc_ctrl_get_flags() to update the flags. Could you please confirm ?

seems correct

> 
> >  	for (; mapping < mend; ++mapping) {
> >  		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
> >  		    ctrl->info.selector == mapping->selector)
> > @@ -2173,6 +2304,9 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
> >  	struct uvc_entity *entity;
> >  	unsigned int i;
> > 
> > +	spin_lock_init(&dev->async_ctrl.lock);
> > +	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
> > +
> >  	/* Walk the entities list and instantiate controls */
> >  	list_for_each_entry(entity, &dev->entities, list) {
> >  		struct uvc_control *ctrl;
> > @@ -2241,6 +2375,8 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
> >  	struct uvc_entity *entity;
> >  	unsigned int i;
> > 
> > +	cancel_work_sync(&dev->async_ctrl.work);
> > +
> >  	/* Free controls and control mappings for all entities. */
> >  	list_for_each_entry(entity, &dev->entities, list) {
> >  		for (i = 0; i < entity->ncontrols; ++i) {
> > diff --git a/drivers/media/usb/uvc/uvc_status.c
> > b/drivers/media/usb/uvc/uvc_status.c index 7b710410584a..d1d83aed6a1d
> > 100644
> > --- a/drivers/media/usb/uvc/uvc_status.c
> > +++ b/drivers/media/usb/uvc/uvc_status.c
> > @@ -78,7 +78,24 @@ static void uvc_input_report_key(struct uvc_device *dev,
> > unsigned int code, /*
> > --------------------------------------------------------------------------
> > * Status interrupt endpoint
> >   */
> > -static void uvc_event_streaming(struct uvc_device *dev, u8 *data, int len)
> > +struct uvc_streaming_status {
> > +	u8	bStatusType;
> > +	u8	bOriginator;
> > +	u8	bEvent;
> > +	u8	bValue[];
> > +} __packed;
> > +
> > +struct uvc_control_status {
> > +	u8	bStatusType;
> > +	u8	bOriginator;
> > +	u8	bEvent;
> > +	u8	bSelector;
> > +	u8	bAttribute;
> > +	u8	bValue[];
> > +} __packed;
> > +
> > +static void uvc_event_streaming(struct uvc_device *dev,
> > +				struct uvc_streaming_status *status, int len)
> >  {
> >  	if (len < 3) {
> >  		uvc_trace(UVC_TRACE_STATUS, "Invalid streaming status event "
> > @@ -86,31 +103,101 @@ static void uvc_event_streaming(struct uvc_device
> > *dev, u8 *data, int len) return;
> >  	}
> > 
> > -	if (data[2] == 0) {
> > +	if (status->bEvent == 0) {
> >  		if (len < 4)
> >  			return;
> >  		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
> > -			data[1], data[3] ? "pressed" : "released", len);
> > -		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
> > +			  status->bOriginator,
> > +			  status->bValue[0] ? "pressed" : "released", len);
> > +		uvc_input_report_key(dev, KEY_CAMERA, status->bValue[0]);
> >  	} else {
> >  		uvc_trace(UVC_TRACE_STATUS,
> >  			  "Stream %u error event %02x len %d.\n",
> > -			  data[1], data[2], len);
> > +			  status->bOriginator, status->bEvent, len);
> >  	}
> >  }
> > 
> > -static void uvc_event_control(struct uvc_device *dev, u8 *data, int len)
> > +#define UVC_CTRL_VALUE_CHANGE	0
> > +#define UVC_CTRL_INFO_CHANGE	1
> > +#define UVC_CTRL_FAILURE_CHANGE	2
> > +#define UVC_CTRL_MIN_CHANGE	3
> > +#define UVC_CTRL_MAX_CHANGE	4
> > +
> > +static struct uvc_control *uvc_event_entity_ctrl(struct uvc_entity *entity,
> > +					       u8 selector)
> 
> Should this be named uvc_event_entity_find_ctrl() ?

it can be, sure

> 
> > +{
> > +	struct uvc_control *ctrl;
> > +	unsigned int i;
> > +
> > +	for (i = 0, ctrl = entity->controls; i < entity->ncontrols; i++, ctrl++)
> > +		if (ctrl->info.selector == selector)
> > +			return ctrl;
> > +
> > +	return NULL;
> > +}
> > +
> > +static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
> > +					struct uvc_control_status *status,
> > +					struct uvc_video_chain **chain)
> > +{
> > +	list_for_each_entry((*chain), &dev->chains, list) {
> 
> Do you need parentheses around *chain ?

I think I do, list_for_each_entry() doesn't enclose "pos" in parentheses 
and uses e.g.

&pos->member

which would resolve to

&*chain->list

which won't work.

> 
> > +		struct uvc_entity *entity;
> > +		struct uvc_control *ctrl;
> > +
> > +		list_for_each_entry(entity, &(*chain)->entities, chain) {
> > +			if (entity->id == status->bOriginator) {
> 
> If you invert the check here with
> 
> 			if (entity->id == status->bOriginator)
> 				continue;
> 
> you'll gain one level of indentation and you might be able to inline 
> uvc_event_entity_ctrl(). Up to you.

ok

> 
> > +				ctrl = uvc_event_entity_ctrl(entity,
> > +							     status->bSelector);
> > +				/*
> > +				 * Some buggy cameras send asynchronous Control
> > +				 * Change events for control, other than the
> > +				 * ones, that had been changed, even though the
> > +				 * AutoUpdate flag isn't set for the control.
> > +				 */
> 
> That's lots of commas, I'm not sure what you mean here. Are there cameras that 
> send event for controls that haven't changed ? Or cameras that send events for 
> controls that don't have the auto-update flag set ? Do you know what cameras 
> are affected ?

I meant a case like

set_control(x=X)
interrupt(x=X)
interrupt(y=Y)

where y is a different control and it doesn't have an auto-update flag 
set. I think those were some early versions of our cameras, but as far as 
I can see, we need the check anyway for autoupdate controls, so, I can 
just remove the comment.

> 
> > +				if (ctrl && (!ctrl->handle ||
> > +					     ctrl->handle->chain == *chain))
> > +					return ctrl;
> > +			}
> > +		}
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void uvc_event_control(struct uvc_device *dev,
> > +			      struct uvc_control_status *status, int len)
> 
> While at it you can make the status pointer const.
> 
> >  {
> > -	char *attrs[3] = { "value", "info", "failure" };
> > +	struct uvc_video_chain *chain;
> > +	struct uvc_control *ctrl;
> > +	char *attrs[] = { "value", "info", "failure", "min", "max" };
> 
> You can also make these static const (and while at it could you please move 
> them before the other two variables ?).
> 
> > 
> > -	if (len < 6 || data[2] != 0 || data[4] > 2) {
> > +	if (len < 6 || status->bEvent != 0 ||
> > +	    status->bAttribute >= ARRAY_SIZE(attrs)) {
> >  		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
> >  				"received.\n");
> >  		return;
> 
> The min and max events are only defined in UVC 1.5 but I suppose there's no 
> need to check for the UVC version here, it won't hurt to handle them on UVC 
> 1.1 as well as they should not occur.
> 
> >  	}
> > 
> >  	uvc_trace(UVC_TRACE_STATUS, "Control %u/%u %s change len %d.\n",
> > -		data[1], data[3], attrs[data[4]], len);
> > +		  status->bOriginator, status->bSelector,
> > +		  attrs[status->bAttribute], len);
> > +
> > +	/* Find the control. */
> > +	ctrl = uvc_event_find_ctrl(dev, status, &chain);
> > +	if (!ctrl)
> > +		return;
> > +
> > +	switch (status->bAttribute) {
> > +	case UVC_CTRL_VALUE_CHANGE:
> > +		uvc_ctrl_status_event(chain, ctrl, status->bValue, len -
> > +				      offsetof(struct uvc_control_status, bValue));
> > +		break;
> 
> How about a blank line here ?
> 
> > +	case UVC_CTRL_INFO_CHANGE:
> > +	case UVC_CTRL_FAILURE_CHANGE:
> > +	case UVC_CTRL_MIN_CHANGE:
> > +	case UVC_CTRL_MAX_CHANGE:
> > +		break;
> > +	}
> >  }
> > 
> >  static void uvc_status_complete(struct urb *urb)
> > @@ -139,11 +226,13 @@ static void uvc_status_complete(struct urb *urb)
> >  	if (len > 0) {
> >  		switch (dev->status[0] & 0x0f) {
> >  		case UVC_STATUS_TYPE_CONTROL:
> > -			uvc_event_control(dev, dev->status, len);
> > +			uvc_event_control(dev,
> > +				(struct uvc_control_status *)dev->status, len);
> 
> Is dev->status guaranteed to be aligned properly so that no unaligned access 
> fault can occur when dereferencing memory through the uvc_control_status and 
> uvc_streaming_status structures ? Unaligned access are the reason why UVC 
> descriptors are parsed manually instead of through a structure.

I don't think kzalloc() would return memory, that isn't even 64-bits 
aligned?

Thanks
Guennadi

> >  			break;
> > 
> >  		case UVC_STATUS_TYPE_STREAMING:
> > -			uvc_event_streaming(dev, dev->status, len);
> > +			uvc_event_streaming(dev,
> > +				(struct uvc_streaming_status *)dev->status, len);
> >  			break;
> > 
> >  		default:
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index 818a4369a51a..55f973eb16eb 100644
> > --- a/drivers/media/usb/uvc/uvc_v4l2.c
> > +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> > @@ -994,7 +994,7 @@ static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
> > if (ret < 0)
> >  		return ret;
> > 
> > -	ret = uvc_ctrl_set(chain, &xctrl);
> > +	ret = uvc_ctrl_set(handle, &xctrl);
> >  	if (ret < 0) {
> >  		uvc_ctrl_rollback(handle);
> >  		return ret;
> > @@ -1069,7 +1069,7 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh
> > *handle, return ret;
> > 
> >  	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> > -		ret = uvc_ctrl_set(chain, ctrl);
> > +		ret = uvc_ctrl_set(handle, ctrl);
> >  		if (ret < 0) {
> >  			uvc_ctrl_rollback(handle);
> >  			ctrls->error_idx = commit ? ctrls->count : i;
> > diff --git a/drivers/media/usb/uvc/uvcvideo.h
> > b/drivers/media/usb/uvc/uvcvideo.h index 6b955e0dd956..483182fe1b4d 100644
> > --- a/drivers/media/usb/uvc/uvcvideo.h
> > +++ b/drivers/media/usb/uvc/uvcvideo.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/usb/video.h>
> >  #include <linux/uvcvideo.h>
> >  #include <linux/videodev2.h>
> > +#include <linux/workqueue.h>
> >  #include <media/media-device.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-event.h>
> > @@ -259,6 +260,8 @@ struct uvc_control {
> >  	   initialized:1;
> > 
> >  	u8 *uvc_data;
> > +
> > +	struct uvc_fh *handle;	/* Used for asynchronous event delivery */
> >  };
> > 
> >  struct uvc_format_desc {
> > @@ -603,6 +606,14 @@ struct uvc_device {
> >  	u8 *status;
> >  	struct input_dev *input;
> >  	char input_phys[64];
> > +
> > +	struct uvc_ctrl_work {
> > +		struct work_struct work;
> > +		struct uvc_video_chain *chain;
> > +		struct uvc_control *ctrl;
> > +		spinlock_t lock;
> > +		void *data;
> > +	} async_ctrl;
> >  };
> > 
> >  enum uvc_handle_state {
> > @@ -756,6 +767,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
> >  int uvc_ctrl_init_device(struct uvc_device *dev);
> >  void uvc_ctrl_cleanup_device(struct uvc_device *dev);
> >  int uvc_ctrl_restore_values(struct uvc_device *dev);
> > +void uvc_ctrl_status_event(struct uvc_video_chain *chain,
> > +			   struct uvc_control *ctrl, u8 *data, size_t len);
> > 
> >  int uvc_ctrl_begin(struct uvc_video_chain *chain);
> >  int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
> > @@ -773,7 +786,7 @@ static inline int uvc_ctrl_rollback(struct uvc_fh
> > *handle) }
> > 
> >  int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control
> > *xctrl); -int uvc_ctrl_set(struct uvc_video_chain *chain, struct
> > v4l2_ext_control *xctrl); +int uvc_ctrl_set(struct uvc_fh *handle, struct
> > v4l2_ext_control *xctrl);
> > 
> >  int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
> >  		      struct uvc_xu_control_query *xqry);
> > diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
> > index 020714d2c5bd..f80f05b3c423 100644
> > --- a/include/uapi/linux/uvcvideo.h
> > +++ b/include/uapi/linux/uvcvideo.h
> > @@ -28,6 +28,8 @@
> >  #define UVC_CTRL_FLAG_RESTORE		(1 << 6)
> >  /* Control can be updated by the camera. */
> >  #define UVC_CTRL_FLAG_AUTO_UPDATE	(1 << 7)
> > +/* Control supports asynchronous reporting */
> > +#define UVC_CTRL_FLAG_ASYNCHRONOUS	(1 << 8)
> > 
> >  #define UVC_CTRL_FLAG_GET_RANGE \
> >  	(UVC_CTRL_FLAG_GET_CUR | UVC_CTRL_FLAG_GET_MIN | \
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

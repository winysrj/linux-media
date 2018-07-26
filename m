Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:33217 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbeGZN7T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 09:59:19 -0400
Date: Thu, 26 Jul 2018 14:42:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v9] uvcvideo: send a control event when a Control Change
 interrupt arrives
In-Reply-To: <3137502.zxYeBzrKFl@avalon>
Message-ID: <alpine.DEB.2.20.1807261441160.7546@axis700.grange>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <alpine.DEB.2.20.1807260859550.7546@axis700.grange> <alpine.DEB.2.20.1807261011420.7546@axis700.grange> <3137502.zxYeBzrKFl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks. Now we can get to the next one: 
https://patchwork.linuxtv.org/patch/46184/ - without that one nobody can 
get complete D4XX metadata. After I get your comments to it I'll address 
them together with Sakari's ones.

Thanks
Guennadi

On Thu, 26 Jul 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Thursday, 26 July 2018 11:17:53 EEST Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > 
> > UVC defines a method of handling asynchronous controls, which sends a
> > USB packet over the interrupt pipe. This patch implements support for
> > such packets by sending a control event to the user. Since this can
> > involve USB traffic and, therefore, scheduling, this has to be done
> > in a work queue.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> applied to my tree and pushed to the uvc/next branch.
> 
> > ---
> > 
> > v9:
> > - multiple optimisations and style improvements from Laurent - thanks
> > - avoid the handle rewriting race at least in cases, when the user only
> > sends a new control after receiving an event for the previous one
> > 
> > Laurent, you added a couple of comments, using DocBook markup like
> > "@param" but you didn't mark those comments for DocBook processing with
> > "/**" - I don't care that much, just wanted to check, that that was
> > intentional.
> 
> Yes, it's not worth compiling that as kerneldoc, I just wanted to mark 
> references to variable names for clarity.
> 
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 211
> > ++++++++++++++++++++++++++++--------- drivers/media/usb/uvc/uvc_status.c |
> > 121 ++++++++++++++++++---
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >  drivers/media/usb/uvc/uvcvideo.h   |  15 ++-
> >  include/uapi/linux/uvcvideo.h      |   2 +
> >  5 files changed, 286 insertions(+), 67 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index 2a213c8..ddd069b 100644
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
> > @@ -971,12 +972,30 @@ static int uvc_ctrl_populate_cache(struct
> > uvc_video_chain *chain, return 0;
> >  }
> > 
> > +static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
> > +				const u8 *data)
> > +{
> > +	s32 value = mapping->get(mapping, UVC_GET_CUR, data);
> > +
> > +	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> > +		struct uvc_menu_info *menu = mapping->menu_info;
> > +		unsigned int i;
> > +
> > +		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
> > +			if (menu->value == value) {
> > +				value = i;
> > +				break;
> > +			}
> > +		}
> > +	}
> > +
> > +	return value;
> > +}
> > +
> >  static int __uvc_ctrl_get(struct uvc_video_chain *chain,
> >  	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
> >  	s32 *value)
> >  {
> > -	struct uvc_menu_info *menu;
> > -	unsigned int i;
> >  	int ret;
> > 
> >  	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
> > @@ -993,18 +1012,8 @@ static int __uvc_ctrl_get(struct uvc_video_chain
> > *chain, ctrl->loaded = 1;
> >  	}
> > 
> > -	*value = mapping->get(mapping, UVC_GET_CUR,
> > -		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
> > -
> > -	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> > -		menu = mapping->menu_info;
> > -		for (i = 0; i < mapping->menu_count; ++i, ++menu) {
> > -			if (menu->value == *value) {
> > -				*value = i;
> > -				break;
> > -			}
> > -		}
> > -	}
> > +	*value = __uvc_ctrl_get_value(mapping,
> > +				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
> > 
> >  	return 0;
> >  }
> > @@ -1216,53 +1225,135 @@ static void uvc_ctrl_fill_event(struct
> > uvc_video_chain *chain, ev->u.ctrl.default_value = v4l2_ctrl.default_value;
> >  }
> > 
> > -static void uvc_ctrl_send_event(struct uvc_fh *handle,
> > -	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
> > -	s32 value, u32 changes)
> > +/*
> > + * Send control change events to all subscribers for the @ctrl control. By
> > + * default the subscriber that generated the event, as identified by
> > @handle, + * is not notified unless it has set the
> > V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK flag. + * @handle can be NULL for
> > asynchronous events related to auto-update controls, + * in which case all
> > subscribers are notified.
> > + */
> > +static void uvc_ctrl_send_event(struct uvc_video_chain *chain,
> > +	struct uvc_fh *handle, struct uvc_control *ctrl,
> > +	struct uvc_control_mapping *mapping, s32 value, u32 changes)
> >  {
> > +	struct v4l2_fh *originator = handle ? &handle->vfh : NULL;
> >  	struct v4l2_subscribed_event *sev;
> >  	struct v4l2_event ev;
> > 
> >  	if (list_empty(&mapping->ev_subs))
> >  		return;
> > 
> > -	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
> > +	uvc_ctrl_fill_event(chain, &ev, ctrl, mapping, value, changes);
> > 
> >  	list_for_each_entry(sev, &mapping->ev_subs, node) {
> > -		if (sev->fh != &handle->vfh ||
> > +		if (sev->fh != originator ||
> >  		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> >  		    (changes & V4L2_EVENT_CTRL_CH_FLAGS))
> >  			v4l2_event_queue_fh(sev->fh, &ev);
> >  	}
> >  }
> > 
> > -static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> > -	struct uvc_control *master, u32 slave_id,
> > -	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> > +/*
> > + * Send control change events for the slave of the @master control
> > identified + * by the V4L2 ID @slave_id. The @handle identifies the event
> > subscriber that + * generated the event and may be NULL for auto-update
> > events.
> > + */
> > +static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
> > +	struct uvc_fh *handle, struct uvc_control *master, u32 slave_id)
> >  {
> >  	struct uvc_control_mapping *mapping = NULL;
> >  	struct uvc_control *ctrl = NULL;
> >  	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> > -	unsigned int i;
> >  	s32 val = 0;
> > 
> > -	/*
> > -	 * We can skip sending an event for the slave if the slave
> > -	 * is being modified in the same transaction.
> > -	 */
> > -	for (i = 0; i < xctrls_count; i++) {
> > -		if (xctrls[i].id == slave_id)
> > -			return;
> > -	}
> > -
> >  	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> >  	if (ctrl == NULL)
> >  		return;
> > 
> > -	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> > +	if (__uvc_ctrl_get(chain, ctrl, mapping, &val) == 0)
> >  		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> > 
> > -	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> > +	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
> > +}
> > +
> > +static void uvc_ctrl_status_event_work(struct work_struct *work)
> > +{
> > +	struct uvc_device *dev = container_of(work, struct uvc_device,
> > +					      async_ctrl.work);
> > +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +	struct uvc_video_chain *chain = w->chain;
> > +	struct uvc_control_mapping *mapping;
> > +	struct uvc_control *ctrl = w->ctrl;
> > +	struct uvc_fh *handle;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	mutex_lock(&chain->ctrl_mutex);
> > +
> > +	handle = ctrl->handle;
> > +	ctrl->handle = NULL;
> > +
> > +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> > +		s32 value = __uvc_ctrl_get_value(mapping, w->data);
> > +
> > +		/*
> > +		 * handle may be NULL here if the device sends auto-update
> > +		 * events without a prior related control set from userspace.
> > +		 */
> > +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> > +			if (!mapping->slave_ids[i])
> > +				break;
> > +
> > +			uvc_ctrl_send_slave_event(chain, handle, ctrl,
> > +						  mapping->slave_ids[i]);
> > +		}
> > +
> > +		uvc_ctrl_send_event(chain, handle, ctrl, mapping, value,
> > +				    V4L2_EVENT_CTRL_CH_VALUE);
> > +	}
> > +
> > +	mutex_unlock(&chain->ctrl_mutex);
> > +
> > +	/* Resubmit the URB. */
> > +	w->urb->interval = dev->int_ep->desc.bInterval;
> > +	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > +	if (ret < 0)
> > +		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
> > +			   ret);
> > +}
> > +
> > +bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
> > +			   struct uvc_control *ctrl, const u8 *data)
> > +{
> > +	struct uvc_device *dev = chain->dev;
> > +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > +
> > +	if (list_empty(&ctrl->info.mappings)) {
> > +		ctrl->handle = NULL;
> > +		return false;
> > +	}
> > +
> > +	w->data = data;
> > +	w->urb = urb;
> > +	w->chain = chain;
> > +	w->ctrl = ctrl;
> > +
> > +	schedule_work(&w->work);
> > +
> > +	return true;
> > +}
> > +
> > +static bool uvc_ctrl_xctrls_has_control(const struct v4l2_ext_control
> > *xctrls, +					unsigned int xctrls_count, u32 id)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < xctrls_count; ++i) {
> > +		if (xctrls[i].id == id)
> > +			return true;
> > +	}
> > +
> > +	return false;
> >  }
> > 
> >  static void uvc_ctrl_send_events(struct uvc_fh *handle,
> > @@ -1277,29 +1368,39 @@ static void uvc_ctrl_send_events(struct uvc_fh
> > *handle, for (i = 0; i < xctrls_count; ++i) {
> >  		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
> > 
> > +		if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
> > +			/* Notification will be sent from an Interrupt event. */
> > +			continue;
> > +
> >  		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
> > -			if (!mapping->slave_ids[j])
> > +			u32 slave_id = mapping->slave_ids[j];
> > +
> > +			if (!slave_id)
> >  				break;
> > -			uvc_ctrl_send_slave_event(handle, ctrl,
> > -						  mapping->slave_ids[j],
> > -						  xctrls, xctrls_count);
> > +
> > +			/*
> > +			 * We can skip sending an event for the slave if the
> > +			 * slave is being modified in the same transaction.
> > +			 */
> > +			if (uvc_ctrl_xctrls_has_control(xctrls, xctrls_count,
> > +							slave_id))
> > +				continue;
> > +
> > +			uvc_ctrl_send_slave_event(handle->chain, handle, ctrl,
> > +						  slave_id);
> >  		}
> > 
> >  		/*
> >  		 * If the master is being modified in the same transaction
> >  		 * flags may change too.
> >  		 */
> > -		if (mapping->master_id) {
> > -			for (j = 0; j < xctrls_count; j++) {
> > -				if (xctrls[j].id == mapping->master_id) {
> > -					changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> > -					break;
> > -				}
> > -			}
> > -		}
> > +		if (mapping->master_id &&
> > +		    uvc_ctrl_xctrls_has_control(xctrls, xctrls_count,
> > +						mapping->master_id))
> > +			changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> > 
> > -		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> > -				    changes);
> > +		uvc_ctrl_send_event(handle->chain, handle, ctrl, mapping,
> > +				    xctrls[i].value, changes);
> >  	}
> >  }
> > 
> > @@ -1472,9 +1573,10 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
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
> > @@ -1581,6 +1683,9 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
> >  	mapping->set(mapping, value,
> >  		uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
> > 
> > +	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
> > +		ctrl->handle = handle;
> > +
> >  	ctrl->dirty = 1;
> >  	ctrl->modified = 1;
> >  	return 0;
> > @@ -1612,7 +1717,9 @@ static int uvc_ctrl_get_flags(struct uvc_device *dev,
> > 
> >  			    |  (data[0] & UVC_CONTROL_CAP_SET ?
> > 
> >  				UVC_CTRL_FLAG_SET_CUR : 0)
> > 
> >  			    |  (data[0] & UVC_CONTROL_CAP_AUTOUPDATE ?
> > 
> > -				UVC_CTRL_FLAG_AUTO_UPDATE : 0);
> > +				UVC_CTRL_FLAG_AUTO_UPDATE : 0)
> > +			    |  (data[0] & UVC_CONTROL_CAP_ASYNCHRONOUS ?
> > +				UVC_CTRL_FLAG_ASYNCHRONOUS : 0);
> > 
> >  	kfree(data);
> >  	return ret;
> > @@ -2173,6 +2280,8 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
> >  	struct uvc_entity *entity;
> >  	unsigned int i;
> > 
> > +	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
> > +
> >  	/* Walk the entities list and instantiate controls */
> >  	list_for_each_entry(entity, &dev->entities, list) {
> >  		struct uvc_control *ctrl;
> > @@ -2241,6 +2350,8 @@ void uvc_ctrl_cleanup_device(struct uvc_device *dev)
> >  	struct uvc_entity *entity;
> >  	unsigned int i;
> > 
> > +	cancel_work_sync(&dev->async_ctrl.work);
> > +
> >  	/* Free controls and control mappings for all entities. */
> >  	list_for_each_entry(entity, &dev->entities, list) {
> >  		for (i = 0; i < entity->ncontrols; ++i) {
> > diff --git a/drivers/media/usb/uvc/uvc_status.c
> > b/drivers/media/usb/uvc/uvc_status.c index 7b71041..0722dc6 100644
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
> > @@ -86,31 +103,97 @@ static void uvc_event_streaming(struct uvc_device *dev,
> > u8 *data, int len) return;
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
> > +static struct uvc_control *uvc_event_entity_find_ctrl(struct uvc_entity
> > *entity, +						      u8 selector)
> >  {
> > -	char *attrs[3] = { "value", "info", "failure" };
> > +	struct uvc_control *ctrl;
> > +	unsigned int i;
> > +
> > +	for (i = 0, ctrl = entity->controls; i < entity->ncontrols; i++, ctrl++)
> > +		if (ctrl->info.selector == selector)
> > +			return ctrl;
> > +
> > +	return NULL;
> > +}
> > 
> > -	if (len < 6 || data[2] != 0 || data[4] > 2) {
> > +static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
> > +					const struct uvc_control_status *status,
> > +					struct uvc_video_chain **chain)
> > +{
> > +	list_for_each_entry((*chain), &dev->chains, list) {
> > +		struct uvc_entity *entity;
> > +		struct uvc_control *ctrl;
> > +
> > +		list_for_each_entry(entity, &(*chain)->entities, chain) {
> > +			if (entity->id != status->bOriginator)
> > +				continue;
> > +
> > +			ctrl = uvc_event_entity_find_ctrl(entity,
> > +							  status->bSelector);
> > +			if (ctrl)
> > +				return ctrl;
> > +		}
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static bool uvc_event_control(struct urb *urb,
> > +			      const struct uvc_control_status *status, int len)
> > +{
> > +	static const char *attrs[] = { "value", "info", "failure", "min", "max" };
> > +	struct uvc_device *dev = urb->context;
> > +	struct uvc_video_chain *chain;
> > +	struct uvc_control *ctrl;
> > +
> > +	if (len < 6 || status->bEvent != 0 ||
> > +	    status->bAttribute >= ARRAY_SIZE(attrs)) {
> >  		uvc_trace(UVC_TRACE_STATUS, "Invalid control status event "
> >  				"received.\n");
> > -		return;
> > +		return false;
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
> > +		return false;
> > +
> > +	switch (status->bAttribute) {
> > +	case UVC_CTRL_VALUE_CHANGE:
> > +		return uvc_ctrl_status_event(urb, chain, ctrl, status->bValue);
> > +
> > +	case UVC_CTRL_INFO_CHANGE:
> > +	case UVC_CTRL_FAILURE_CHANGE:
> > +	case UVC_CTRL_MIN_CHANGE:
> > +	case UVC_CTRL_MAX_CHANGE:
> > +		break;
> > +	}
> > +
> > +	return false;
> >  }
> > 
> >  static void uvc_status_complete(struct urb *urb)
> > @@ -138,13 +221,23 @@ static void uvc_status_complete(struct urb *urb)
> >  	len = urb->actual_length;
> >  	if (len > 0) {
> >  		switch (dev->status[0] & 0x0f) {
> > -		case UVC_STATUS_TYPE_CONTROL:
> > -			uvc_event_control(dev, dev->status, len);
> > +		case UVC_STATUS_TYPE_CONTROL: {
> > +			struct uvc_control_status *status =
> > +				(struct uvc_control_status *)dev->status;
> > +
> > +			if (uvc_event_control(urb, status, len))
> > +				/* The URB will be resubmitted in work context. */
> > +				return;
> >  			break;
> > +		}
> > 
> > -		case UVC_STATUS_TYPE_STREAMING:
> > -			uvc_event_streaming(dev, dev->status, len);
> > +		case UVC_STATUS_TYPE_STREAMING: {
> > +			struct uvc_streaming_status *status =
> > +				(struct uvc_streaming_status *)dev->status;
> > +
> > +			uvc_event_streaming(dev, status, len);
> >  			break;
> > +		}
> > 
> >  		default:
> >  			uvc_trace(UVC_TRACE_STATUS, "Unknown status event "
> > diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> > b/drivers/media/usb/uvc/uvc_v4l2.c index bd32914..18a7384 100644
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
> > b/drivers/media/usb/uvc/uvcvideo.h index be5cf17..8ae03a4 100644
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
> > @@ -256,6 +257,8 @@ struct uvc_control {
> >  	   initialized:1;
> > 
> >  	u8 *uvc_data;
> > +
> > +	struct uvc_fh *handle;	/* File handle that last changed the control. */
> >  };
> > 
> >  struct uvc_format_desc {
> > @@ -600,6 +603,14 @@ struct uvc_device {
> >  	u8 *status;
> >  	struct input_dev *input;
> >  	char input_phys[64];
> > +
> > +	struct uvc_ctrl_work {
> > +		struct work_struct work;
> > +		struct urb *urb;
> > +		struct uvc_video_chain *chain;
> > +		struct uvc_control *ctrl;
> > +		const void *data;
> > +	} async_ctrl;
> >  };
> > 
> >  enum uvc_handle_state {
> > @@ -753,6 +764,8 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
> >  int uvc_ctrl_init_device(struct uvc_device *dev);
> >  void uvc_ctrl_cleanup_device(struct uvc_device *dev);
> >  int uvc_ctrl_restore_values(struct uvc_device *dev);
> > +bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
> > +			   struct uvc_control *ctrl, const u8 *data);
> > 
> >  int uvc_ctrl_begin(struct uvc_video_chain *chain);
> >  int __uvc_ctrl_commit(struct uvc_fh *handle, int rollback,
> > @@ -770,7 +783,7 @@ static inline int uvc_ctrl_rollback(struct uvc_fh
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
> > index 020714d..f80f05b 100644
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
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

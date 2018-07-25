Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:36822 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbeGYUSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 16:18:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v8 2/3] uvcvideo: send a control event when a Control Change interrupt arrives
Date: Wed, 25 Jul 2018 22:06:04 +0300
Message-ID: <2023305.2x0KqNxjjm@avalon>
In-Reply-To: <54761357.L2epZVyRJX@avalon>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <1525792064-30836-3-git-send-email-guennadi.liakhovetski@intel.com> <54761357.L2epZVyRJX@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday, 25 July 2018 20:25:16 EEST Laurent Pinchart wrote:
> On Tuesday, 8 May 2018 18:07:43 EEST Guennadi Liakhovetski wrote:
> > UVC defines a method of handling asynchronous controls, which sends a
> > USB packet over the interrupt pipe. This patch implements support for
> > such packets by sending a control event to the user. Since this can
> > involve USB traffic and, therefore, scheduling, this has to be done
> > in a work queue.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > ---
> > 
> > v8:
> > 
> > * avoid losing events by delaying the status URB resubmission until
> >   after completion of the current event
> > * extract control value calculation into __uvc_ctrl_get_value()
> > * do not proactively return EBUSY if the previous control hasn't
> >   completed yet, let the camera handle such cases
> > * multiple cosmetic changes
> > 
> >  drivers/media/usb/uvc/uvc_ctrl.c   | 166 ++++++++++++++++++++++++++------
> >  drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
> >  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> >  include/uapi/linux/uvcvideo.h      |   2 +
> >  5 files changed, 255 insertions(+), 44 deletions(-)
> 
> As mentioned in a previous e-mail, here's my review of small issues in the
> form of diff on top of this patch. I'll reply inline with comments.
> 
> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> b/drivers/media/usb/uvc/uvc_ctrl.c index d57a176a03d5..04d779e3f039 100644
> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> @@ -1225,38 +1225,41 @@ static void uvc_ctrl_fill_event(struct
> uvc_video_chain *chain, ev->u.ctrl.default_value = v4l2_ctrl.default_value;
>  }
> 
> -static void uvc_ctrl_send_event(struct uvc_fh *handle,
> -	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
> -	s32 value, u32 changes)
> +/*
> + * Send control change events to all subscribers for the @ctrl control. By
> + * default the subscriber that generated the event, as identified by
> @handle,
> + * is not notified unless it has set the
> V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK flag.
> + * @handle can be NULL for asynchronous events related to auto-update
> controls,
> + * in which case all subscribers are notified.
> + */

As the number of functions related to event handling grew larger, I felt that 
adding a bit of documentation became necessary to avoid getting lost.

> +static void uvc_ctrl_send_event(struct uvc_video_chain *chain,
> +	struct uvc_fh *handle, struct uvc_control *ctrl,
> +	struct uvc_control_mapping *mapping, s32 value, u32 changes)
>  {
> +	struct v4l2_fh *originator = handle ? &handle->vfh : NULL;
>  	struct v4l2_subscribed_event *sev;
>  	struct v4l2_event ev;
> -	bool autoupdate;
> 
>  	if (list_empty(&mapping->ev_subs))
>  		return;
> 
> -	if (!handle) {
> -		autoupdate = true;
> -		sev = list_first_entry(&mapping->ev_subs,
> -				       struct v4l2_subscribed_event, node);
> -		handle = container_of(sev->fh, struct uvc_fh, vfh);
> -	} else {
> -		autoupdate = false;
> -	}
> -

By adding the chain pointer as a function argument, which is always available 
to the caller, we can remove the small hack that looks up the chain in the 
first handle if the handle is NULL.

> -	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value, changes);
> +	uvc_ctrl_fill_event(chain, &ev, ctrl, mapping, value, changes);
> 
>  	list_for_each_entry(sev, &mapping->ev_subs, node) {
> -		if (sev->fh != &handle->vfh ||
> +		if (sev->fh != originator ||
>  		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> -		    (changes & V4L2_EVENT_CTRL_CH_FLAGS) || autoupdate)
> +		    (changes & V4L2_EVENT_CTRL_CH_FLAGS))
>  			v4l2_event_queue_fh(sev->fh, &ev);
>  	}
>  }
> 
> -static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> -	struct uvc_video_chain *chain, struct uvc_control *master, u32 slave_id)
> +/*
> + * Send control change events for the slave of the @master control
> identified
> + * by the V4L2 ID @slave_id. The @handle identifies the event subscriber
> that
> + * generated the event and may be NULL for auto-update
> events.
> + */
> +static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
> +	struct uvc_fh *handle, struct uvc_control *master, u32 slave_id)

Passing the chain as the first argument matches the rest of the functions in 
this file (more or less). I also removed the starting double underscore, by 
removing the uvc_ctrl_send_slave_event() function below.

>  {
>  	struct uvc_control_mapping *mapping = NULL;
>  	struct uvc_control *ctrl = NULL;
> @@ -1267,11 +1270,10 @@ static void __uvc_ctrl_send_slave_event(struct
> uvc_fh *handle, if (ctrl == NULL)
>  		return;
> 
> -	if (__uvc_ctrl_get(handle ? handle->chain : chain, ctrl, mapping,
> -			   &val) == 0)
> +	if (__uvc_ctrl_get(chain, ctrl, mapping, &val) == 0)

If handle isn't NULL, handle->chain == chain, so we can use chain directly.

>  		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> 
> -	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> +	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
>  }
> 
>  static void uvc_ctrl_status_event_work(struct work_struct *work)
> @@ -1279,38 +1281,37 @@ static void uvc_ctrl_status_event_work(struct
> work_struct *work) struct uvc_device *dev = container_of(work, struct
> uvc_device,
>  					      async_ctrl.work);
>  	struct uvc_ctrl_work *w = &dev->async_ctrl;
> +	struct uvc_video_chain *chain = w->chain;

Just to reduce line lengths below.

>  	struct uvc_control_mapping *mapping;
>  	struct uvc_control *ctrl = w->ctrl;
>  	unsigned int i;
>  	int ret;
> 
> -	mutex_lock(&w->chain->ctrl_mutex);
> +	mutex_lock(&chain->ctrl_mutex);
> 
>  	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
>  		s32 value = __uvc_ctrl_get_value(mapping, w->data);
> 
>  		/*
> -		 * So far none of the auto-update controls in the uvc_ctrls[]
> -		 * table is mapped to a V4L control with slaves in the
> -		 * uvc_ctrl_mappings[] list, so slave controls so far never have
> -		 * handle == NULL, but this can change in the future
> +		 * ctrl->handle may be NULL here if the device sends auto-update
> +		 * events without a prior related control set from userspace.

I don't see how having handle == NULL for a slave control would be a problem, 
so I've replaced the comment. Please let me know if that was a 
misunderstanding on my side.

>  		 */
>  		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
>  			if (!mapping->slave_ids[i])
>  				break;
> 
> -			__uvc_ctrl_send_slave_event(ctrl->handle, w->chain,
> -						ctrl, mapping->slave_ids[i]);
> +			uvc_ctrl_send_slave_event(chain, ctrl->handle, ctrl,
> +						  mapping->slave_ids[i]);
>  		}
> 
> -		uvc_ctrl_send_event(ctrl->handle, ctrl, mapping, value,
> +		uvc_ctrl_send_event(chain, ctrl->handle, ctrl, mapping, value,
>  				    V4L2_EVENT_CTRL_CH_VALUE);
>  	}
> 
> -	mutex_unlock(&w->chain->ctrl_mutex);
> -
>  	ctrl->handle = NULL;
> 
> +	mutex_unlock(&chain->ctrl_mutex);
> +

As per the locking and race condition discussion.

>  	/* Resubmit the URB. */
>  	w->urb->interval = dev->int_ep->desc.bInterval;
>  	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> @@ -1340,23 +1341,17 @@ bool uvc_ctrl_status_event(struct urb *urb, struct
> uvc_video_chain *chain, return true;
>  }
> 
> -static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> -	struct uvc_control *master, u32 slave_id,
> -	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> +static bool uvc_ctrl_xctrls_has_control(const struct v4l2_ext_control
> *xctrls,
> +					unsigned int xctrls_count, u32 id)
>  {
>  	unsigned int i;
> 
> -	/*
> -	 * We can skip sending an event for the slave if the slave
> -	 * is being modified in the same transaction.
> -	 */
> -	for (i = 0; i < xctrls_count; i++) {
> -		if (xctrls[i].id == slave_id)
> -			return;
> +	for (i = 0; i < xctrls_count; ++i) {
> +		if (xctrls[i].id == id)
> +			return true;
>  	}
> 
> -	/* handle != NULL */
> -	__uvc_ctrl_send_slave_event(handle, NULL, master, slave_id);
> +	return false;
>  }

We check twice below whether a control with a given ID is present in an xctrls 
list, so I've factored that out to a separate function. The 
uvc_ctrl_send_slave_event() function is now inlined in its single caller below 
with the help of the new uvc_ctrl_xctrls_has_control() function.

>  static void uvc_ctrl_send_events(struct uvc_fh *handle,
> @@ -1376,28 +1371,34 @@ static void uvc_ctrl_send_events(struct uvc_fh
> *handle, continue;
> 
>  		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
> -			if (!mapping->slave_ids[j])
> +			u32 slave_id = mapping->slave_ids[j];

To reduce line lengths.

> +
> +			if (!slave_id)
>  				break;
> -			uvc_ctrl_send_slave_event(handle, ctrl,
> -						  mapping->slave_ids[j],
> -						  xctrls, xctrls_count);
> +
> +			/*
> +			 * We can skip sending an event for the slave if the
> +			 * slave is being modified in the same transaction.
> +			 */
> +			if (uvc_ctrl_xctrls_has_control(xctrls, xctrls_count,
> +							slave_id))
> +				continue;
> +
> +			uvc_ctrl_send_slave_event(handle->chain, handle, ctrl,
> +						  slave_id);
>  		}
> 
>  		/*
>  		 * If the master is being modified in the same transaction
>  		 * flags may change too.
>  		 */
> -		if (mapping->master_id) {
> -			for (j = 0; j < xctrls_count; j++) {
> -				if (xctrls[j].id == mapping->master_id) {
> -					changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> -					break;
> -				}
> -			}
> -		}
> +		if (mapping->master_id &&
> +		    uvc_ctrl_xctrls_has_control(xctrls, xctrls_count,
> +						mapping->master_id))
> +			changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> 
> -		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> -				    changes);
> +		uvc_ctrl_send_event(handle->chain, handle, ctrl, mapping,
> +				    xctrls[i].value, changes);
>  	}
>  }
> 
> diff --git a/drivers/media/usb/uvc/uvc_status.c
> b/drivers/media/usb/uvc/uvc_status.c index a0f2feaee7c6..0722dc684378
> 100644
> --- a/drivers/media/usb/uvc/uvc_status.c
> +++ b/drivers/media/usb/uvc/uvc_status.c
> @@ -150,8 +150,7 @@ static struct uvc_control *uvc_event_find_ctrl(struct
> uvc_device *dev,
> 
>  			ctrl = uvc_event_entity_find_ctrl(entity,
>  							  status->bSelector);
> -			if (ctrl && (!ctrl->handle ||
> -				     ctrl->handle->chain == *chain))
> +			if (ctrl)

As per our discussion on this topic.

>  				return ctrl;
>  		}
>  	}
> @@ -222,17 +221,23 @@ static void uvc_status_complete(struct urb *urb)
>  	len = urb->actual_length;
>  	if (len > 0) {
>  		switch (dev->status[0] & 0x0f) {
> -		case UVC_STATUS_TYPE_CONTROL:
> -			if (uvc_event_control(urb,
> -				(struct uvc_control_status *)dev->status, len))
> -				/* The URB will be resubmitted in work context */
> +		case UVC_STATUS_TYPE_CONTROL: {
> +			struct uvc_control_status *status =
> +				(struct uvc_control_status *)dev->status;

To reduce line length in the function call. I find this a bit more readable, 
but I agree it is debatable.

> +
> +			if (uvc_event_control(urb, status, len))
> +				/* The URB will be resubmitted in work context. */
>  				return;
>  			break;
> +		}
> 
> -		case UVC_STATUS_TYPE_STREAMING:
> -			uvc_event_streaming(dev,
> -				(struct uvc_streaming_status *)dev->status, len);
> +		case UVC_STATUS_TYPE_STREAMING: {
> +			struct uvc_streaming_status *status =
> +				(struct uvc_streaming_status *)dev->status;
> +
> +			uvc_event_streaming(dev, status, len);
>  			break;
> +		}
> 
>  		default:
>  			uvc_trace(UVC_TRACE_STATUS, "Unknown status event "
> diff --git a/drivers/media/usb/uvc/uvcvideo.h
> b/drivers/media/usb/uvc/uvcvideo.h index b36ad9eb8c80..e5f5d84f1d1d 100644
> --- a/drivers/media/usb/uvc/uvcvideo.h
> +++ b/drivers/media/usb/uvc/uvcvideo.h
> @@ -261,7 +261,7 @@ struct uvc_control {
> 
>  	u8 *uvc_data;
> 
> -	struct uvc_fh *handle;	/* Used for asynchronous event delivery */
> +	struct uvc_fh *handle;	/* File handle that last changed the control. */

I thought it would be more useful to document what the field stores instead of 
where it is used.

>  };
> 
>  struct uvc_format_desc {

-- 
Regards,

Laurent Pinchart

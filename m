Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51576 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbeEGOvf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 10:51:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/2] uvcvideo: send a control event when a Control Change interrupt arrives
Date: Mon, 07 May 2018 17:51:49 +0300
Message-ID: <3321819.nzIFIPUmca@avalon>
In-Reply-To: <alpine.DEB.2.20.1804100848040.29394@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <2079648.niC1Apbgeu@avalon> <alpine.DEB.2.20.1804100848040.29394@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday, 10 April 2018 14:31:35 EEST Guennadi Liakhovetski wrote:
> On Fri, 23 Mar 2018, Laurent Pinchart wrote:
> > On Friday, 23 March 2018 11:24:00 EET Laurent Pinchart wrote:
> >> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> 
> >> UVC defines a method of handling asynchronous controls, which sends a
> >> USB packet over the interrupt pipe. This patch implements support for
> >> such packets by sending a control event to the user. Since this can
> >> involve USB traffic and, therefore, scheduling, this has to be done
> >> in a work queue.
> >> 
> >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++++---
> >>  drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
> >>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> >>  include/uapi/linux/uvcvideo.h      |   2 +
> >>  5 files changed, 269 insertions(+), 29 deletions(-)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> >> b/drivers/media/usb/uvc/uvc_ctrl.c index 4042cbdb721b..f4773c56438c
> >> 100644
> >> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> >> +++ b/drivers/media/usb/uvc/uvc_ctrl.c

[snip]

> >> @@ -1222,30 +1223,134 @@ static void uvc_ctrl_send_event(struct uvc_fh
> >> *handle,
> >>  {
> >>  	struct v4l2_subscribed_event *sev;
> >>  	struct v4l2_event ev;
> >> +	bool autoupdate;
> >> 
> >>  	if (list_empty(&mapping->ev_subs))
> >>  		return;
> >> 
> >> +	if (!handle) {
> > 
> > In which circumstances does this happen ? Is it when the device reports a
> > control change event without an prior control set ? Have you seen that
> > happening in practice ?
> 
> This happens with autoupdate controls. Yes, I've seen this happen.
> 
> >> +		autoupdate = true;
> >> +		sev = list_first_entry(&mapping->ev_subs,
> >> +				       struct v4l2_subscribed_event, node);
> >> +		handle = container_of(sev->fh, struct uvc_fh, vfh);
> > 
> > There's a check below that guards against sev->fh being NULL. Could
> > sev->fh be NULL here ?
> 
> I cannot see how that can happen, but if you see such a possibility, I can
> add a check.

My point is that both should be consistent. If sev->fh can't be NULL the check 
below should be removed (probably in a separate patch). Otherwise you'd need 
to guard against that here. And in the latter case I wonder where sev->fh 
could be NULL for some entries in the list only.

> >> +	} else {
> >> +		autoupdate = false;
> >> +	}
> >> +
> >>  	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, value,
> >>  	changes);
> >>  	
> >>  	list_for_each_entry(sev, &mapping->ev_subs, node) {
> >>  		if (sev->fh && (sev->fh != &handle->vfh ||
> >>  		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> >> -		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
> >> +		    (changes & V4L2_EVENT_CTRL_CH_FLAGS) || autoupdate))
> >> 
> >>  			v4l2_event_queue_fh(sev->fh, &ev);
> >>  	}
> >>  }
> >> 
> >> -static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> >> -	struct uvc_control *master, u32 slave_id,
> >> -	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> >> +static void __uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> >> +				struct uvc_control *master, u32 slave_id)
> >>  {
> >>  	struct uvc_control_mapping *mapping = NULL;
> >>  	struct uvc_control *ctrl = NULL;
> >>  	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> >> -	unsigned int i;
> >>  	s32 val = 0;
> >> 
> >> +	__uvc_find_control(master->entity, slave_id, &mapping, &ctrl, 0);
> >> +	if (ctrl == NULL)
> >> +		return;
> >> +
> >> +	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> >> +		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> >> +
> >> +	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> >> +}
> >> +
> >> +static void uvc_ctrl_status_event_work(struct work_struct *work)
> >> +{
> >> +	struct uvc_device *dev = container_of(work, struct uvc_device,
> >> +					      async_ctrl.work);
> >> +	struct uvc_video_chain *chain;
> >> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> >> +	struct uvc_control_mapping *mapping;
> >> +	struct uvc_control *ctrl;
> >> +	struct uvc_fh *handle;
> >> +	unsigned int i;
> >> +	u8 *data;
> >> +
> >> +	spin_lock_irq(&w->lock);
> >> +	data = w->data;
> >> +	w->data = NULL;
> >> +	chain = w->chain;
> >> +	ctrl = w->ctrl;
> >> +	handle = ctrl->handle;
> >> +	ctrl->handle = NULL;
> >> +	spin_unlock_irq(&w->lock);
> >> +
> >> +	if (mutex_lock_interruptible(&chain->ctrl_mutex))
> >> +		goto free;
> > 
> > This will result in the event being lost, which isn't very nice (see below
> > for additional comments on this topic). Can't we use mutex_lock() ?
> 
> This is in a scheduler work context, I don't think I've ever really seen
> that being interrupted, so, sure, don't think that would change anything.

Then if it never gets interrupted it's one more reason to use mutex_lock() :-)

> >> +
> >> +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> >> +		s32 value = mapping->get(mapping, UVC_GET_CUR, data);
> >> +
> >> +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> >> +			if (!mapping->slave_ids[i])
> >> +				break;
> >> +
> >> +			__uvc_ctrl_send_slave_event(handle, ctrl,
> >> +						    mapping->slave_ids[i]);
> >> +		}
> >> +
> >> +		if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
> >> +			struct uvc_menu_info *menu = mapping->menu_info;
> >> +			unsigned int i;
> >> +
> >> +			for (i = 0; i < mapping->menu_count; ++i, ++menu)
> >> +				if (menu->value == value) {
> >> +					value = i;
> >> +					break;
> >> +				}
> >> +		}
> > 
> > Would this be useful to move the mapping->get() and menu control handling
> > code out of __uvc_ctrl_get() into a __uvc_ctrl_get_value() function and
> > call it here ?
> 
> Should be possible, yes.
> 
> >> +		uvc_ctrl_send_event(handle, ctrl, mapping, value,
> >> +				    V4L2_EVENT_CTRL_CH_VALUE);
> >> +	}
> >> +
> >> +	mutex_unlock(&chain->ctrl_mutex);
> >> +
> >> +free:
> >> +	kfree(data);
> >> +}
> >> +
> >> +void uvc_ctrl_status_event(struct uvc_video_chain *chain,
> >> +			   struct uvc_control *ctrl, u8 *data, size_t len)
> >> +{
> >> +	struct uvc_device *dev = chain->dev;
> >> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> >> +
> >> +	if (list_empty(&ctrl->info.mappings))
> >> +		return;
> >> +
> >> +	spin_lock(&w->lock);
> >> +	if (w->data)
> >> +		/* A previous event work hasn't run yet, we lose 1 event */
> >> +		kfree(w->data);
> > 
> > I really don't like losing events :/
> 
> Well, I'm not sure whether having no available status URBs isn't
> equivalent to losing events, but if you prefer that - no problem.
> 
> >> +	w->data = kmalloc(len, GFP_ATOMIC);
> > 
> > GFP_ATOMIC allocation isn't very nice either.
> > 
> > How about if we instead delayed resubmitting the status URB until the
> > event is fully processed by the work queue ? That way we wouldn't lose
> > events, we wouldn't need memory allocation in atomic context, and if the
> > work queue becomes a bottleneck we could even queue multiple status URBs
> > and easily add them to a list for processing by the work queue.
> 
> You mean only for control status events? Can do, sure.

I mean the status endpoint URB in general, so this would affect both control 
events and button events.

> >> +	if (w->data) {
> >> +		memcpy(w->data, data, len);
> >> +		w->chain = chain;
> >> +		w->ctrl = ctrl;
> >> +		schedule_work(&w->work);
> >> +	}
> >> +	spin_unlock(&w->lock);
> >> +}

[snip]

> >> @@ -1488,6 +1591,25 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
> >>  		return -EINVAL;
> >>  	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
> >>  		return -EACCES;
> >> +	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
> >> +		if (ctrl->handle)
> >> +			/*
> >> +			 * We have already sent this control to the camera
> >> +			 * recently and are currently waiting for a completion
> >> +			 * notification. The camera might already have completed
> >> +			 * its processing and is ready to accept a new control
> >> +			 * or it's still busy processing. If we send a new
> >> +			 * instance of this control now, in the former case the
> >> +			 * camera will process this one too and we'll get
> >> +			 * completions for both, but we will only deliver an
> >> +			 * event for one of them back to the user. In the latter
> >> +			 * case the camera will reply with a STALL. It's easier
> >> +			 * and more reliable to return an error now and let the
> >> +			 * user retry.
> >> +			 */
> >> +			return -EBUSY;
> >> +		ctrl->handle = handle;
> > 
> > This part worries me. If the control change event isn't received for any
> > reason (such as a buggy device for instance, or uvc_ctrl_status_event()
> > being called with the previous event not processed yet), the control will
> > stay busy forever.
> > 
> > I see two approaches to fix this. One would be to forward all received
> > control change events to all file handles unconditionally and remove the
> > handle field from the uvc_control structure.
> 
> How is this a solution? A case of senging a repeated control to the camera
> and causing a STALL would still be possible. If you prefer STALLs, you
> could just remove this check here.

Yes, in that case a STALL would be possible. I think that making a STALL 
possible would be better than keeping the control busy forever if the control 
change event isn't received.

> > Another one would be to add a timeout, storing the time at which the
> > control has been set in the uvc_control structure, and checking whether
> > the time difference exceeds a fixed timeout here. We could also combine
> > the two, replacing the handle field with a timestamp field.
> 
> Don't think you can remove the handle field, there are a couple of things,
> that need it, also you'll have to send events to all listeners, including
> the thread, that has sent the control, which contradicts the API? Assuming
> it hasn't set the V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK flag.

You're right, to implement V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK we need the 
handle.

> I can add a timeout, even though that doesn't seem to be very clean to me.
> According to the UVC standard some controls can take a while to complete,
> possibly seconds. How long would you propose that timeout to be?

We could start with something like 5s for instance. The goal is really to 
protect against an event being lost and avoid making the control busy forever 
in that case, so the timeout can be large.

> > Please keep in mind if trying this out that simply storing jiffies as a
> > timestamp might cause counter overflow issues if the control is set, no
> > event is ever received, and a second control set happens much later after
> > one (or multiple) jiffies wraparounds. We could end up returning -EBUSY
> > incorrectly. That might not be a real issue given the size of the jiffies
> > counter though, I'll let you double-check.
> > 
> >> +	}
> >> 
> >>  	/* Clamp out of range values. */
> >>  	switch (mapping->v4l2_type) {
> >> 

[snip]

> >> diff --git a/drivers/media/usb/uvc/uvc_status.c
> >> b/drivers/media/usb/uvc/uvc_status.c index 7b710410584a..d1d83aed6a1d
> >> 100644
> >> --- a/drivers/media/usb/uvc/uvc_status.c
> >> +++ b/drivers/media/usb/uvc/uvc_status.c

[snip]

> >> +static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
> >> +					struct uvc_control_status *status,
> >> +					struct uvc_video_chain **chain)
> >> +{
> >> +	list_for_each_entry((*chain), &dev->chains, list) {
> > 
> > Do you need parentheses around *chain ?
> 
> I think I do, list_for_each_entry() doesn't enclose "pos" in parentheses
> and uses e.g.
> 
> &pos->member
> 
> which would resolve to
> 
> &*chain->list
> 
> which won't work.

OK, fair enough. I won't ask you to fix list_for_each_entry() as a 
prerequisite for this patch series :-) It would be nice to give it a shot 
though.

> >> +		struct uvc_entity *entity;
> >> +		struct uvc_control *ctrl;
> >> +
> >> +		list_for_each_entry(entity, &(*chain)->entities, chain) {
> >> +			if (entity->id == status->bOriginator) {
> > 
> > If you invert the check here with
> > 
> > 			if (entity->id == status->bOriginator)
> > 				continue;
> > 
> > you'll gain one level of indentation and you might be able to inline
> > uvc_event_entity_ctrl(). Up to you.
> 
> ok
> 
> >> +				ctrl = uvc_event_entity_ctrl(entity,
> >> +							     status->bSelector);
> >> +				/*
> >> +				 * Some buggy cameras send asynchronous Control
> >> +				 * Change events for control, other than the
> >> +				 * ones, that had been changed, even though the
> >> +				 * AutoUpdate flag isn't set for the control.
> >> +				 */
> > 
> > That's lots of commas, I'm not sure what you mean here. Are there cameras
> > that send event for controls that haven't changed ? Or cameras that send
> > events for controls that don't have the auto-update flag set ? Do you
> > know what cameras are affected ?
> 
> I meant a case like
> 
> set_control(x=X)
> interrupt(x=X)
> interrupt(y=Y)
> 
> where y is a different control and it doesn't have an auto-update flag
> set. I think those were some early versions of our cameras, but as far as
> I can see, we need the check anyway for autoupdate controls, so, I can
> just remove the comment.

OK. But now that I read the comment again, how is it related to the check ? 
Why do you need ctrl->handle->chain == *chain ? Isn't that only a partial 
guard for the case above, as both x and y could be part of the same chain ?

> >> +				if (ctrl && (!ctrl->handle ||
> >> +					     ctrl->handle->chain == *chain))
> >> +					return ctrl;
> >> +			}
> >> +		}
> >> +	}
> >> +
> >> +	return NULL;
> >> +}

[snip]

> > > @@ -139,11 +226,13 @@ static void uvc_status_complete(struct urb *urb)
> > >  	if (len > 0) {
> > >  		switch (dev->status[0] & 0x0f) {
> > >  		case UVC_STATUS_TYPE_CONTROL:
> > > -			uvc_event_control(dev, dev->status, len);
> > > +			uvc_event_control(dev,
> > > +				(struct uvc_control_status *)dev->status, len);
> > 
> > Is dev->status guaranteed to be aligned properly so that no unaligned
> > access fault can occur when dereferencing memory through the
> > uvc_control_status and uvc_streaming_status structures ? Unaligned access
> > are the reason why UVC descriptors are parsed manually instead of through
> > a structure.
> 
> I don't think kzalloc() would return memory, that isn't even 64-bits
> aligned?

That answers my question :-) Thanks.

> >>  			break;
> >>  		
> >>  		case UVC_STATUS_TYPE_STREAMING:
> >> -			uvc_event_streaming(dev, dev->status, len);
> >> +			uvc_event_streaming(dev,
> >> +				(struct uvc_streaming_status *)dev->status, len);
> >>  			break;
> >>  		
> >>  		default:

[snip]

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:53581 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbeGYSef (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 14:34:35 -0400
Date: Wed, 25 Jul 2018 19:21:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 2/3] uvcvideo: send a control event when a Control
 Change interrupt arrives
In-Reply-To: <1822344.XhrjdFXG7R@avalon>
Message-ID: <alpine.DEB.2.20.1807251916030.23630@axis700.grange>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <5107098.C36SyUDqOn@avalon> <alpine.DEB.2.20.1807180848240.21012@axis700.grange> <1822344.XhrjdFXG7R@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Jul 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday, 18 July 2018 09:55:27 EEST Guennadi Liakhovetski wrote:
> > On Wed, 18 Jul 2018, Laurent Pinchart wrote:
> > > On Wednesday, 18 July 2018 00:30:45 EEST Guennadi Liakhovetski wrote:
> > >> On Tue, 17 Jul 2018, Laurent Pinchart wrote:
> > >>> On Thursday, 12 July 2018 10:30:46 EEST Guennadi Liakhovetski wrote:
> > >>>> On Thu, 12 Jul 2018, Laurent Pinchart wrote:
> > >>>>> On Tuesday, 8 May 2018 18:07:43 EEST Guennadi Liakhovetski wrote:
> > >>>>>> UVC defines a method of handling asynchronous controls, which sends
> > >>>>>> a USB packet over the interrupt pipe. This patch implements support
> > >>>>>> for such packets by sending a control event to the user. Since this
> > >>>>>> can involve USB traffic and, therefore, scheduling, this has to be
> > >>>>>> done in a work queue.
> > >>>>>> 
> > >>>>>> Signed-off-by: Guennadi Liakhovetski
> > >>>>>> <guennadi.liakhovetski@intel.com>
> > >>>>>> ---
> > >>>>>> 
> > >>>>>> v8:
> > >>>>>> 
> > >>>>>> * avoid losing events by delaying the status URB resubmission until
> > >>>>>>   after completion of the current event
> > >>>>>> * extract control value calculation into __uvc_ctrl_get_value()
> > >>>>>> * do not proactively return EBUSY if the previous control hasn't
> > >>>>>>   completed yet, let the camera handle such cases
> > >>>>>> * multiple cosmetic changes
> > >>>>>> 
> > >>>>>>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 ++++++++++++++++++++------
> > >>>>>>  drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
> > >>>>>>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> > >>>>>>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> > >>>>>>  include/uapi/linux/uvcvideo.h      |   2 +
> > >>>>>>  5 files changed, 255 insertions(+), 44 deletions(-)
> > >>>>>> 
> > >>>>>> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > >>>>>> b/drivers/media/usb/uvc/uvc_ctrl.c index 2a213c8..796f86a 100644
> > >>>>>> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > >>>>>> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > >>>> 
> > >>>> [snip]
> > >>>> 
> > >>>>>> +static void uvc_ctrl_status_event_work(struct work_struct *work)
> > >>>>>> +{
> > >>>>>> +	struct uvc_device *dev = container_of(work, struct uvc_device,
> > >>>>>> +					      async_ctrl.work);
> > >>>>>> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > >>>>>> +	struct uvc_control_mapping *mapping;
> > >>>>>> +	struct uvc_control *ctrl = w->ctrl;
> > >>>>>> +	unsigned int i;
> > >>>>>> +	int ret;
> > >>>>>> +
> > >>>>>> +	mutex_lock(&w->chain->ctrl_mutex);
> > >>>>>> +
> > >>>>>> +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> > >>>>>> +		s32 value = __uvc_ctrl_get_value(mapping, w->data);
> > >>>>>> +
> > >>>>>> +		/*
> > >>>>>> +		 * So far none of the auto-update controls in the uvc_ctrls[]
> > >>>>>> +		 * table is mapped to a V4L control with slaves in the
> > >>>>>> +		 * uvc_ctrl_mappings[] list, so slave controls so far never have
> > >>>>>> +		 * handle == NULL, but this can change in the future
> > >>>>>> +		 */
> > >>>>>> +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> > >>>>>> +			if (!mapping->slave_ids[i])
> > >>>>>> +				break;
> > >>>>>> +
> > >>>>>> +			__uvc_ctrl_send_slave_event(ctrl->handle, w->chain,
> > >>>>>> +						ctrl, mapping->slave_ids[i]);
> > >>>>>> +		}
> > >>>>>> +
> > >>>>>> +		uvc_ctrl_send_event(ctrl->handle, ctrl, mapping, value,
> > >>>>>> +				    V4L2_EVENT_CTRL_CH_VALUE);
> > >>>>>> +	}
> > >>>>>> +
> > >>>>>> +	mutex_unlock(&w->chain->ctrl_mutex);
> > >>>>>> +
> > >>>>>> +	ctrl->handle = NULL;
> > >>>>> 
> > >>>>> Can't this race with a uvc_ctrl_set() call, resulting in
> > >>>>> ctrl->handle being NULL after the control gets set ?
> > >>>> 
> > >>>> Right, it's better to set .handle to NULL before sending events.
> > >>>> Something like
> > >>>> 
> > >>>> mutex_lock();
> > >>>> 
> > >>>> handle = ctrl->handle;
> > >>>> ctrl->handle = NULL;
> > >>>> 
> > >>>> list_for_each_entry() {
> > >>>> 	...
> > >>>> 	uvc_ctrl_send_event(handle,...);
> > >>>> }
> > >>>> 
> > >>>> mutex_unlock();
> > >>>> 
> > >>>> ?
> > >>> 
> > >>> I think you also have to take the same lock in the uvc_ctrl_set()
> > >>> function to fix the problem, otherwise the ctrl->handle = NULL line
> > >>> could still be executed after the ctrl->handle assignment in
> > >>> uvc_ctrl_set(), resulting in ctrl->handle being NULL while the control
> > >>> is being set.
> > >> 
> > >> Doesn't this mean, that you're attempting to send a new instance of the
> > >> same control before the previous has completed? In which case also
> > >> taking the lock in uvc_ctrl_set() wouldn't help either, because you can
> > >> anyway do that immediately after the first instance, before the
> > >> completion even has fired.
> > > 
> > > You're right that it won't solve the race completely, but wouldn't it at
> > > least prevent ctrl->handle from being NULL ? We can't guarantee which of
> > > the old and new handle will be used for events when multiple control set
> > > operations are invoked, but we should try to guarantee that the handle
> > > won't be NULL.
> > 
> > Sorry, I'm probably misunderstanding something. What exactly are you
> > proposing to lock and what and how is it supposed to protect? Wouldn't the
> > following flow still be possible, if you protect setting .handle = NULL in
> > uvc_set_ctrl():
> > 
> > CPU 1                                 CPU 2
> > 
> > control completion interrupt
> > (.handle = HANDLE_1)
> > work scheduled
> >                                       uvc_set_ctrl()
> >                                       .handle = HANDLE_2
> > uvc_ctrl_status_event_work()
> > .handle = NULL
> > usb_submit_urb()
> > 
> > control completion interrupt
> > (.handle = NULL)
> > 
> > ?
> 
> You're absolutely right, there's no easy way to guard against this with a mere 
> lock. I think we can ignore the issue for now and address it later if really 
> needed, as the only adverse effect would be a spurious control change event 
> sent to a file handle that hasn't set the V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK 
> flag.

Ok, but I still think the above change - setting .handle to NULL before 
sending the event - should be useful?

Thanks
Guennadi

> 
> > >>>>>> +	/* Resubmit the URB. */
> > >>>>>> +	w->urb->interval = dev->int_ep->desc.bInterval;
> > >>>>>> +	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > >>>>>> +	if (ret < 0)
> > >>>>>> +		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
> > >>>>>> +			   ret);
> > >>>>>> +}
> > > 
> > > [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 
> 
> 

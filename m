Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:38277 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbeGQWFX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 18:05:23 -0400
Date: Tue, 17 Jul 2018 23:30:45 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 2/3] uvcvideo: send a control event when a Control
 Change interrupt arrives
In-Reply-To: <3815510.uz0YmiiscJ@avalon>
Message-ID: <alpine.DEB.2.20.1807172328180.19083@axis700.grange>
References: <1525792064-30836-1-git-send-email-guennadi.liakhovetski@intel.com> <20995022.aCQirgtdj8@avalon> <alpine.DEB.2.20.1807120834060.24638@axis700.grange> <3815510.uz0YmiiscJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Jul 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Thursday, 12 July 2018 10:30:46 EEST Guennadi Liakhovetski wrote:
> > On Thu, 12 Jul 2018, Laurent Pinchart wrote:
> > > On Tuesday, 8 May 2018 18:07:43 EEST Guennadi Liakhovetski wrote:
> > >> UVC defines a method of handling asynchronous controls, which sends a
> > >> USB packet over the interrupt pipe. This patch implements support for
> > >> such packets by sending a control event to the user. Since this can
> > >> involve USB traffic and, therefore, scheduling, this has to be done
> > >> in a work queue.
> > >> 
> > >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > >> ---
> > >> 
> > >> v8:
> > >> 
> > >> * avoid losing events by delaying the status URB resubmission until
> > >>   after completion of the current event
> > >> * extract control value calculation into __uvc_ctrl_get_value()
> > >> * do not proactively return EBUSY if the previous control hasn't
> > >>   completed yet, let the camera handle such cases
> > >> * multiple cosmetic changes
> > >> 
> > >>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 ++++++++++++++++++++++++-------
> > >>  drivers/media/usb/uvc/uvc_status.c | 112 ++++++++++++++++++++++---
> > >>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> > >>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> > >>  include/uapi/linux/uvcvideo.h      |   2 +
> > >>  5 files changed, 255 insertions(+), 44 deletions(-)
> > >> 
> > >> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > >> b/drivers/media/usb/uvc/uvc_ctrl.c index 2a213c8..796f86a 100644
> > >> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > >> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > 
> > [snip]
> > 
> > >> +static void uvc_ctrl_status_event_work(struct work_struct *work)
> > >> +{
> > >> +	struct uvc_device *dev = container_of(work, struct uvc_device,
> > >> +					      async_ctrl.work);
> > >> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> > >> +	struct uvc_control_mapping *mapping;
> > >> +	struct uvc_control *ctrl = w->ctrl;
> > >> +	unsigned int i;
> > >> +	int ret;
> > >> +
> > >> +	mutex_lock(&w->chain->ctrl_mutex);
> > >> +
> > >> +	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
> > >> +		s32 value = __uvc_ctrl_get_value(mapping, w->data);
> > >> +
> > >> +		/*
> > >> +		 * So far none of the auto-update controls in the uvc_ctrls[]
> > >> +		 * table is mapped to a V4L control with slaves in the
> > >> +		 * uvc_ctrl_mappings[] list, so slave controls so far never have
> > >> +		 * handle == NULL, but this can change in the future
> > >> +		 */
> > >> +		for (i = 0; i < ARRAY_SIZE(mapping->slave_ids); ++i) {
> > >> +			if (!mapping->slave_ids[i])
> > >> +				break;
> > >> +
> > >> +			__uvc_ctrl_send_slave_event(ctrl->handle, w->chain,
> > >> +						ctrl, mapping->slave_ids[i]);
> > >> +		}
> > >> +
> > >> +		uvc_ctrl_send_event(ctrl->handle, ctrl, mapping, value,
> > >> +				    V4L2_EVENT_CTRL_CH_VALUE);
> > >> +	}
> > >> +
> > >> +	mutex_unlock(&w->chain->ctrl_mutex);
> > >> +
> > >> +	ctrl->handle = NULL;
> > > 
> > > Can't this race with a uvc_ctrl_set() call, resulting in ctrl->handle
> > > being NULL after the control gets set ?
> > 
> > Right, it's better to set .handle to NULL before sending events. Something
> > like
> > 
> > mutex_lock();
> > 
> > handle = ctrl->handle;
> > ctrl->handle = NULL;
> > 
> > list_for_each_entry() {
> > 	...
> > 	uvc_ctrl_send_event(handle,...);
> > }
> > 
> > mutex_unlock();
> > 
> > ?
> 
> I think you also have to take the same lock in the uvc_ctrl_set() function to 
> fix the problem, otherwise the ctrl->handle = NULL line could still be 
> executed after the ctrl->handle assignment in uvc_ctrl_set(), resulting in 
> ctrl->handle being NULL while the control is being set.

Doesn't this mean, that you're attempting to send a new instance of the 
same control before the previous has completed? In which case also taking 
the lock in uvc_ctrl_set() wouldn't help either, because you can anyway do 
that immediately after the first instance, before the completion even has 
fired.

> > >> +	/* Resubmit the URB. */
> > >> +	w->urb->interval = dev->int_ep->desc.bInterval;
> > >> +	ret = usb_submit_urb(w->urb, GFP_KERNEL);
> > >> +	if (ret < 0)
> > >> +		uvc_printk(KERN_ERR, "Failed to resubmit status URB (%d).\n",
> > >> +			   ret);
> > >> +}
> 
> [snip]
> 
> > >> diff --git a/drivers/media/usb/uvc/uvc_status.c
> > >> b/drivers/media/usb/uvc/uvc_status.c index 7b71041..a0f2fea 100644
> > >> --- a/drivers/media/usb/uvc/uvc_status.c
> > >> +++ b/drivers/media/usb/uvc/uvc_status.c
> 
> [snip]
> 
> > >> +static struct uvc_control *uvc_event_find_ctrl(struct uvc_device *dev,
> > >> +					const struct uvc_control_status *status,
> > >> +					struct uvc_video_chain **chain)
> > >> +{
> > >> +	list_for_each_entry((*chain), &dev->chains, list) {
> > >> +		struct uvc_entity *entity;
> > >> +		struct uvc_control *ctrl;
> > >> +
> > >> +		list_for_each_entry(entity, &(*chain)->entities, chain) {
> > >> +			if (entity->id != status->bOriginator)
> > >> +				continue;
> > >> +
> > >> +			ctrl = uvc_event_entity_find_ctrl(entity,
> > >> +							  status->bSelector);
> > >> +			if (ctrl && (!ctrl->handle ||
> > >> +				     ctrl->handle->chain == *chain))
> > > 
> > > I'm afraid I still don't understand why you need the chain check :-(
> > > Unless I'm mistaken, ctrl->handle is set in uvc_ctrl_set(), where the
> > > control is looked up from the chain corresponding to handle->chain. How
> > > can the check be false here ?
> > 
> > I think you're right, the bOriginator check should be enough.
> > 
> > > Those are my two major concerns. Apart from that I have other small
> > > concerns that I propose addressing myself to avoid further delays. I've
> > > been slow enough when it comes to reviewing this series, if we can clear
> > > the two issues above, I'll handle the rest.
> > 
> > Once I get your review of patch #3, I'll fix these two issues and
> > resubmit, so you can also tell me your "minor concerns," since I'll be
> > resubmitting anyway.
> 
> Do you mind if I send them as a diff on top of your patch ? I'll of course add 
> explanations where they are needed.

No, I don't mind.

Thanks
Guennadi

> > >> +				return ctrl;
> > >> +		}
> > >> +	}
> > >> +
> > >> +	return NULL;
> > >> +}
> 
> [snip]
> 
> -- 
> Regards,
> 
> Laurent Pinchart

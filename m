Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51756 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbeEGPTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:19:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/2] uvcvideo: send a control event when a Control Change interrupt arrives
Date: Mon, 07 May 2018 18:20:01 +0300
Message-ID: <2106593.OlhQZDqy0L@avalon>
In-Reply-To: <alpine.DEB.2.20.1805071708130.6924@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <3321819.nzIFIPUmca@avalon> <alpine.DEB.2.20.1805071708130.6924@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday, 7 May 2018 18:12:14 EEST Guennadi Liakhovetski wrote:
> On Mon, 7 May 2018, Laurent Pinchart wrote:
> > On Tuesday, 10 April 2018 14:31:35 EEST Guennadi Liakhovetski wrote:
> >> On Fri, 23 Mar 2018, Laurent Pinchart wrote:
> >>> On Friday, 23 March 2018 11:24:00 EET Laurent Pinchart wrote:
> >>>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >>>> 
> >>>> UVC defines a method of handling asynchronous controls, which sends a
> >>>> USB packet over the interrupt pipe. This patch implements support for
> >>>> such packets by sending a control event to the user. Since this can
> >>>> involve USB traffic and, therefore, scheduling, this has to be done
> >>>> in a work queue.
> >>>> 
> >>>> Signed-off-by: Guennadi Liakhovetski
> >>>> <guennadi.liakhovetski@intel.com>
> >>>> ---
> >>>> 
> >>>>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++---
> >>>>  drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
> >>>>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> >>>>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> >>>>  include/uapi/linux/uvcvideo.h      |   2 +
> >>>>  5 files changed, 269 insertions(+), 29 deletions(-)
> >>>> 
> >>>> diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> >>>> b/drivers/media/usb/uvc/uvc_ctrl.c index 4042cbdb721b..f4773c56438c
> >>>> 100644
> >>>> --- a/drivers/media/usb/uvc/uvc_ctrl.c
> >>>> +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> 
> [snip]
> 
> >>>> +void uvc_ctrl_status_event(struct uvc_video_chain *chain,
> >>>> +			   struct uvc_control *ctrl, u8 *data, size_t len)
> >>>> +{
> >>>> +	struct uvc_device *dev = chain->dev;
> >>>> +	struct uvc_ctrl_work *w = &dev->async_ctrl;
> >>>> +
> >>>> +	if (list_empty(&ctrl->info.mappings))
> >>>> +		return;
> >>>> +
> >>>> +	spin_lock(&w->lock);
> >>>> +	if (w->data)
> >>>> +		/* A previous event work hasn't run yet, we lose 1 event */
> >>>> +		kfree(w->data);
> >>> 
> >>> I really don't like losing events :/
> >> 
> >> Well, I'm not sure whether having no available status URBs isn't
> >> equivalent to losing events, but if you prefer that - no problem.
> >> 
> >>>> +	w->data = kmalloc(len, GFP_ATOMIC);
> >>> 
> >>> GFP_ATOMIC allocation isn't very nice either.
> >>> 
> >>> How about if we instead delayed resubmitting the status URB until the
> >>> event is fully processed by the work queue ? That way we wouldn't lose
> >>> events, we wouldn't need memory allocation in atomic context, and if
> >>> the work queue becomes a bottleneck we could even queue multiple
> >>> status URBs and easily add them to a list for processing by the work
> >>> queue.
> >> 
> >> You mean only for control status events? Can do, sure.
> > 
> > I mean the status endpoint URB in general, so this would affect both
> > control events and button events.
> 
> I don't think any of my UVC cameras have such a button, do you have any of
> those? I'd rather not change something, that I cannot test myself and
> cannot have tested. I could leave the button processing as is and only
> change the URB submission path for control change events?

I do have cameras with a button so I can test this. It should be OK not to 
touch the input event code, my point was that if you delay resubmission of the 
status URB in the control event code it will delay input events as well.

-- 
Regards,

Laurent Pinchart

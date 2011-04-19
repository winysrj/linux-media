Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41527 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1DSMTv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:19:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFCv1 PATCH 4/9] v4l2-ctrls: add per-control events.
Date: Tue, 19 Apr 2011 14:19:45 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1301917914-27437-1-git-send-email-hans.verkuil@cisco.com> <7db9a20f6d656cee512dd4a9d3f53061.squirrel@webmail.xs4all.nl> <4DA9588F.6030103@maxwell.research.nokia.com>
In-Reply-To: <4DA9588F.6030103@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191419.49423.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Saturday 16 April 2011 10:51:27 Sakari Ailus wrote:
> Hans Verkuil wrote:
> >> Hans Verkuil wrote:
> >>> Whenever a control changes value an event is sent to anyone that
> >>> subscribed
> >>> to it.
> >>> 
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> ---
> >>> 
> >>>  drivers/media/video/v4l2-ctrls.c |   59 ++++++++++++++++++
> >>>  drivers/media/video/v4l2-event.c |  126
> >>> 
> >>> +++++++++++++++++++++++++++-----------
> >>> 
> >>>  drivers/media/video/v4l2-fh.c    |    4 +-
> >>>  include/linux/videodev2.h        |   17 +++++-
> >>>  include/media/v4l2-ctrls.h       |    9 +++
> >>>  include/media/v4l2-event.h       |    2 +
> >>>  6 files changed, 177 insertions(+), 40 deletions(-)
> >>> 
> >>> diff --git a/drivers/media/video/v4l2-ctrls.c
> >>> b/drivers/media/video/v4l2-ctrls.c
> >>> index f75a1d4..163f412 100644
> >>> --- a/drivers/media/video/v4l2-ctrls.c
> >>> +++ b/drivers/media/video/v4l2-ctrls.c
> >>> @@ -23,6 +23,7 @@
> >>> 
> >>>  #include <media/v4l2-ioctl.h>
> >>>  #include <media/v4l2-device.h>
> >>>  #include <media/v4l2-ctrls.h>
> >>> 
> >>> +#include <media/v4l2-event.h>
> >>> 
> >>>  #include <media/v4l2-dev.h>
> >>>  
> >>>  /* Internal temporary helper struct, one for each v4l2_ext_control */
> >>> 
> >>> @@ -537,6 +538,16 @@ static bool type_is_int(const struct v4l2_ctrl
> >>> *ctrl)
> >>> 
> >>>  	}
> >>>  
> >>>  }
> >>> 
> >>> +static void send_event(struct v4l2_ctrl *ctrl, struct v4l2_event *ev)
> >>> +{
> >>> +	struct v4l2_ctrl_fh *pos;
> >>> +
> >>> +	ev->id = ctrl->id;
> >>> +	list_for_each_entry(pos, &ctrl->fhs, node) {
> >>> +		v4l2_event_queue_fh(pos->fh, ev);
> >>> +	}
> >> 
> >> Shouldn't we do v4l2_ctrl_lock(ctrl) here? Or does something prevent
> >> changes to the file handle list while we loop over it?
> > 
> > This function is always called with the lock taken.
> 
> Yes, you're right.
> 
> >> v4l2_ctrl_lock() locks a mutex. Events often arrive from interrupt
> >> context, which would mean the drivers would need to create a work queue
> >> to tell about changes to control values.
> > 
> > I will have to check whether it is possible to make a function that can
> > be called from interrupt context. I have my doubts though whether it is
> > 1) possible and 2) desirable. At least in the area of HDMI
> > receivers/transmitters you will want to have a workqueue anyway.
> 
> I wonder if there could be a more generic mechanism than to implement
> this in a driver itself. In some cases it may also be harmful that
> events are lost, and if there's just a single event for the workqueue,
> it happens too easily in my opinion.
> 
> What do you think; could/should there be a queue for control events that
> arrive from interrupt context, or should that be implemented in the
> drivers themselves?

I expect most drivers to generate control events from interrupt context, so 
pushing the workqueue down to individual drivers is probably not a good idea.

On a somehow related note, applications will often want to be informed of 
control changes initiated by the device, but won't need to receive events for 
control changes initiated by the application itself. Is that something we 
support ?

> Another issue with this is that workqueues require to be scheduled so
> sending the event to user space gets delayed by that. One of the
> important aspects of events is latency and it would be nice to be able
> to minimise that --- that's one reason why events use a spinlock rather
> than a mutex, the other being that they can be easily sent from
> interrupt context where they mostly arrive from.
> 
> It would be nice to have the same properties for control events.
> 
> There are use cases where a user space control process would run on a
> real time priority to avoid scheduling latencies caused by other
> processes, and such control process receiving control events would be
> affected by the low priority of the work queues.

I would also prefer a solution implemented in the control framework that would 
be interrupt context-friendly, without requiring a work queue.

> I agree with all your responses below on locking.
> 
> Thanks.
> 
> Regards,

-- 
Regards,

Laurent Pinchart

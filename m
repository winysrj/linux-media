Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3775 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1E1O6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 10:58:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Date: Sat, 28 May 2011 16:58:20 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com> <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com> <20110528103421.GA4991@valkosipuli.localdomain>
In-Reply-To: <20110528103421.GA4991@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281658.20086.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, May 28, 2011 12:34:21 Sakari Ailus wrote:
> Hi Hans,
> 
> On Wed, May 25, 2011 at 03:33:51PM +0200, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Whenever a control changes value or state an event is sent to anyone
> > that subscribed to it.
> > 
> > This functionality is useful for control panels but also for applications
> > that need to wait for (usually status) controls to change value.
> 
> Thanks for the patch!
> 
> I agree that it's good to pass more information of the control (min, max
> etc.) to the user space with the event. However, to support events arriving
> from interrupt context which we've discussed in the past, such information
> must be also accessible in those situations.
> 
> What do you think about more fine-grained locking of controls, say, spinlock
> for each control (cluster) as an idea?

It's on my TODO list, but I need to think carefully on how to do it.
One thing at a time :-)

> 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/v4l2-ctrls.c |  101 ++++++++++++++++++++++++++++++
> >  drivers/media/video/v4l2-event.c |  126 +++++++++++++++++++++++++++-----------
> >  drivers/media/video/v4l2-fh.c    |    4 +-
> >  include/linux/videodev2.h        |   29 ++++++++-
> >  include/media/v4l2-ctrls.h       |   16 +++++-
> >  include/media/v4l2-event.h       |    2 +
> >  6 files changed, 237 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> > index 3e0d8ab..e2a7ac7 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -23,6 +23,7 @@
> >  #include <media/v4l2-ioctl.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-event.h>
> >  #include <media/v4l2-dev.h>
> >  
> >  #define call_op(master, op) \
> > @@ -540,6 +541,44 @@ static bool type_is_int(const struct v4l2_ctrl *ctrl)
> >  	}
> >  }
> >  
> > +static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
> > +{
> > +	memset(ev->reserved, 0, sizeof(ev->reserved));
> > +	ev->type = V4L2_EVENT_CTRL;
> > +	ev->id = ctrl->id;
> > +	ev->u.ctrl.changes = changes;
> > +	ev->u.ctrl.type = ctrl->type;
> > +	ev->u.ctrl.flags = ctrl->flags;
> > +	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
> > +		ev->u.ctrl.value64 = 0;
> > +	else
> > +		ev->u.ctrl.value64 = ctrl->cur.val64;
> > +	ev->u.ctrl.minimum = ctrl->minimum;
> > +	ev->u.ctrl.maximum = ctrl->maximum;
> > +	if (ctrl->type == V4L2_CTRL_TYPE_MENU)
> > +		ev->u.ctrl.step = 1;
> > +	else
> > +		ev->u.ctrl.step = ctrl->step;
> > +	ev->u.ctrl.default_value = ctrl->default_value;
> > +}
> > +
> > +static void send_event(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 changes)
> > +{
> > +	struct v4l2_event ev;
> > +	struct v4l2_ctrl_fh *pos;
> > +
> > +	if (list_empty(&ctrl->fhs))
> > +			return;
> > +	fill_event(&ev, ctrl, changes);
> > +
> > +	list_for_each_entry(pos, &ctrl->fhs, node) {
> > +		if (pos->fh == fh)
> > +			continue;
> > +		ev.u.ctrl.flags = ctrl->flags;
> 
> What's the purpose of setting flags here as well? fill_event() above already
> does it.

Oops, that's a left-over from a previous version. I'll remove it.

Regards,

	Hans

> 
> > +		v4l2_event_queue_fh(pos->fh, &ev);
> > +	}
> > +}
> > +
> >  /* Helper function: copy the current control value back to the caller */
> >  static int cur_to_user(struct v4l2_ext_control *c,
> >  		       struct v4l2_ctrl *ctrl)
> 
> Regards,
> 
> 

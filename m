Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4753 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab0BVHve (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 02:51:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
Date: Mon, 22 Feb 2010 08:53:53 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <201002201056.56952.hverkuil@xs4all.nl> <4B81B44F.7080201@maxwell.research.nokia.com>
In-Reply-To: <4B81B44F.7080201@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220853.53921.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 21 February 2010 23:31:43 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > More comments...
> > 
> > On Friday 19 February 2010 20:21:59 Sakari Ailus wrote:
> >> Add support for event handling to do_ioctl.
> >>
> >> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> >> ---
> >>  drivers/media/video/v4l2-ioctl.c |   58 ++++++++++++++++++++++++++++++++++++++
> >>  include/media/v4l2-ioctl.h       |    7 ++++
> >>  2 files changed, 65 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> >> index 34c7d6e..f7d6177 100644
> >> --- a/drivers/media/video/v4l2-ioctl.c
> >> +++ b/drivers/media/video/v4l2-ioctl.c
> >> @@ -25,6 +25,8 @@
> >>  #endif
> >>  #include <media/v4l2-common.h>
> >>  #include <media/v4l2-ioctl.h>
> >> +#include <media/v4l2-fh.h>
> >> +#include <media/v4l2-event.h>
> >>  #include <media/v4l2-chip-ident.h>
> >>  
> >>  #define dbgarg(cmd, fmt, arg...) \
> >> @@ -1944,7 +1946,63 @@ static long __video_do_ioctl(struct file *file,
> >>  		}
> >>  		break;
> >>  	}
> >> +	case VIDIOC_DQEVENT:
> >> +	{
> >> +		struct v4l2_event *ev = arg;
> >> +		struct v4l2_fh *vfh = fh;
> >> +
> >> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)
> >> +		    || vfh->events == NULL)
> >> +			break;
> > 
> > Change this to:
> > 
> > 		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
> > 			break;
> > 		if (vfh->events == NULL)
> > 			return -ENOENT;
> > 
> > But see also the next comment.
> > 
> >> +
> >> +		ret = v4l2_event_dequeue(fh, ev);
> > 
> > There is a crucial piece of functionality missing here: if the filehandle is
> > in blocking mode, then it should wait until an event arrives. That also means
> > that if vfh->events == NULL, you should still call v4l2_event_dequeue, and
> > that function should initialize vfh->events and wait for an event if the fh
> > is in blocking mode.
> 
> I originally left this out intentionally. Most applications using events
> would use select / poll as well by default. For completeness it should
> be there, I agree.

It has to be there. This is important functionality. For e.g. ivtv I would use
this to wait until the MPEG decoder flushed all buffers and displayed the last
frame of the stream. That's something you would often do in blocking mode.

> This btw. suggests that we perhaps should put back the struct file
> argument for the event functions in video_ioctl_ops. The blocking flag
> is indeed part of the file structure. I'm open to better suggestions, too.

My long term goal is that the file struct is only used inside v4l2-ioctl.c
and not in drivers. Drivers should not need this struct at all. The easiest
way to ensure this is by not passing it to the drivers at all :-)
 
> >> +		if (ret < 0) {
> >> +			dbgarg(cmd, "no pending events?");
> >> +			break;
> >> +		}
> >> +		dbgarg(cmd,
> >> +		       "pending=%d, type=0x%8.8x, sequence=%d, "
> >> +		       "timestamp=%lu.%9.9lu ",
> >> +		       ev->pending, ev->type, ev->sequence,
> >> +		       ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
> >> +		break;
> >> +	}
> >> +	case VIDIOC_SUBSCRIBE_EVENT:
> >> +	{
> >> +		struct v4l2_event_subscription *sub = arg;
> >> +		struct v4l2_fh *vfh = fh;
> >>  
> >> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)
> > 
> > Testing for this bit is unnecessarily. Just test for ops->vidioc_subscribe_event.
> > 
> >> +		    || vfh->events == NULL
> > 
> > Remove this test. If you allocate the event queue only when you first
> > subscribe to an event (as ivtv will do), then you have to be able to
> > call vidioc_subscribe_event even if vfh->events == NULL.
> 
> How about calling v4l2_event_alloc() with zero events? That allocates
> and initialises the v4l2_events structure. That's easier to handle in
> drivers as well since they don't need to consider special cases like
> fh->events happens to be NULL even if events are supported by the
> driver. This is how I first thought it'd work.

Proposal: export a v4l2_event_init() call that sets up fh->events. Calling
v4l2_event_alloc(0) feels like a hack. So drivers that want to be able to
handle events should call v4l2_event_init after initializing the file handle.

Or (and that might even be nicer) test in v4l2_fh_init whether there is a
subscribe op in the ioctl_ops struct and let v4l2_fh_init set up fh->events
automatically.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:51647 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab0BUWyQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 17:54:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
Date: Sun, 21 Feb 2010 23:54:47 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com,
	david.cohen@nokia.com
References: <4B7EE4A4.3080202@maxwell.research.nokia.com> <201002201056.56952.hverkuil@xs4all.nl> <4B81B44F.7080201@maxwell.research.nokia.com>
In-Reply-To: <4B81B44F.7080201@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212354.51792.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 21 February 2010 23:31:43 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > More comments...
> > 
> > On Friday 19 February 2010 20:21:59 Sakari Ailus wrote:
> >> Add support for event handling to do_ioctl.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> >> ---
> >> 
> >>  drivers/media/video/v4l2-ioctl.c |   58
> >>  ++++++++++++++++++++++++++++++++++++++ include/media/v4l2-ioctl.h     
> >>   |    7 ++++
> >>  2 files changed, 65 insertions(+), 0 deletions(-)
> >> 
> >> diff --git a/drivers/media/video/v4l2-ioctl.c
> >> b/drivers/media/video/v4l2-ioctl.c index 34c7d6e..f7d6177 100644
> >> --- a/drivers/media/video/v4l2-ioctl.c
> >> +++ b/drivers/media/video/v4l2-ioctl.c
> >> @@ -25,6 +25,8 @@
> >> 
> >>  #endif
> >>  #include <media/v4l2-common.h>
> >>  #include <media/v4l2-ioctl.h>
> >> 
> >> +#include <media/v4l2-fh.h>
> >> +#include <media/v4l2-event.h>
> >> 
> >>  #include <media/v4l2-chip-ident.h>
> >>  
> >>  #define dbgarg(cmd, fmt, arg...) \
> >> 
> >> @@ -1944,7 +1946,63 @@ static long __video_do_ioctl(struct file *file,
> >> 
> >>  		}
> >>  		break;
> >>  	
> >>  	}
> >> 
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
> > 		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
> > 		
> > 			break;
> > 		
> > 		if (vfh->events == NULL)
> > 		
> > 			return -ENOENT;
> > 
> > But see also the next comment.
> > 
> >> +
> >> +		ret = v4l2_event_dequeue(fh, ev);
> > 
> > There is a crucial piece of functionality missing here: if the filehandle
> > is in blocking mode, then it should wait until an event arrives. That
> > also means that if vfh->events == NULL, you should still call
> > v4l2_event_dequeue, and that function should initialize vfh->events and
> > wait for an event if the fh is in blocking mode.
> 
> I originally left this out intentionally. Most applications using events
> would use select / poll as well by default. For completeness it should
> be there, I agree.
> 
> This btw. suggests that we perhaps should put back the struct file
> argument for the event functions in video_ioctl_ops. The blocking flag
> is indeed part of the file structure. I'm open to better suggestions, too.

If the only information we need from struct file is the flags, they could be 
copied to v4l2_fh in the open handler. We could also put a struct file * 
member in v4l2_fh.

-- 
Regards,

Laurent Pinchart

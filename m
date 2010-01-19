Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:42674 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab0ASILn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 03:11:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC v2 5/7] V4L: Events: Limit event queue length
Date: Tue, 19 Jan 2010 09:11:51 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <alpine.LNX.2.01.1001181348540.31857@alastor>
In-Reply-To: <alpine.LNX.2.01.1001181348540.31857@alastor>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001190911.51636.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 18 January 2010 13:58:09 Hans Verkuil wrote:
> On Tue, 22 Dec 2009, Sakari Ailus wrote:
> > Limit event queue length to V4L2_MAX_EVENTS. If the queue is full any
> > further events will be dropped.
> >
> > This patch also updates the count field properly, setting it to exactly
> > to number of further available events.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > ---
> > drivers/media/video/v4l2-event.c |   10 +++++++++-
> > include/media/v4l2-event.h       |    5 +++++
> > 2 files changed, 14 insertions(+), 1 deletions(-)

[snip]

> > diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
> > index b11de92..69305c6 100644
> > --- a/include/media/v4l2-event.h
> > +++ b/include/media/v4l2-event.h
> > @@ -28,6 +28,10 @@
> > #include <linux/types.h>
> > #include <linux/videodev2.h>
> >
> > +#include <asm/atomic.h>
> > +
> > +#define V4L2_MAX_EVENTS		1024 /* Ought to be enough for everyone. */
> 
> I think this should be programmable by the driver. Most drivers do not use
> events at all, so by default it should be 0 or perhaps it can check whether
> the ioctl callback structure contains the event ioctls and set it to 0 or
> some initial default value.
> 
> And you want this to be controlled on a per-filehandle basis even. If I
>  look at ivtv, then most of the device nodes will not have events, only a
>  few will support events. And for one device node type I know that there
>  will only be a single event when stopping the streaming, while another
>  device node type will get an event each frame.

Don't you mean per video node instead of per file handle ? In that case we 
could add a new field to video_device structure that must be initialized by 
drivers before registering the device.

> So being able to adjust the event queue dynamically will give more control
> and prevent unnecessary waste of memory resources.

-- 
Regards,

Laurent Pinchart

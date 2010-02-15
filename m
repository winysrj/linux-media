Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2350 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab0BOKiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 05:38:50 -0500
Message-ID: <998c8b9c6ee4b9f1638f9ace41fe623a.squirrel@webmail.xs4all.nl>
In-Reply-To: <201002151105.43721.laurent.pinchart@ideasonboard.com>
References: <4B72C965.7040204@maxwell.research.nokia.com>
    <1265813889-17847-4-git-send-email-sakari.ailus@maxwell.research.nokia.com>
    <201002131449.31949.hverkuil@xs4all.nl>
    <201002151105.43721.laurent.pinchart@ideasonboard.com>
Date: Mon, 15 Feb 2010 11:31:35 +0100
Subject: Re: [PATCH v4 4/7] V4L: Events: Support event handling in do_ioctl
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com, david.cohen@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Saturday 13 February 2010 14:49:31 Hans Verkuil wrote:
>> On Wednesday 10 February 2010 15:58:06 Sakari Ailus wrote:
>> > Add support for event handling to do_ioctl.
>> >
>> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> > ---
>> >
>> >  drivers/media/video/Makefile     |    2 +-
>> >  drivers/media/video/v4l2-ioctl.c |   49
>> >  ++++++++++++++++++++++++++++++++++++++ include/media/v4l2-ioctl.h
>> >  |    5 ++++
>> >  3 files changed, 55 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/media/video/Makefile
>> b/drivers/media/video/Makefile
>> > index b888ad1..68253d6 100644
>> > --- a/drivers/media/video/Makefile
>> > +++ b/drivers/media/video/Makefile
>> > @@ -11,7 +11,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
>> >
>> >  omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
>> >
>> >  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-subdev.o
>> \
>> >
>> > -			v4l2-fh.o
>> > +			v4l2-fh.o v4l2-event.o
>> >
>> >  # V4L2 core modules
>> >
>> > diff --git a/drivers/media/video/v4l2-ioctl.c
>> > b/drivers/media/video/v4l2-ioctl.c index bfc4696..e0b9401 100644
>> > --- a/drivers/media/video/v4l2-ioctl.c
>> > +++ b/drivers/media/video/v4l2-ioctl.c
>> > @@ -25,6 +25,7 @@
>> >
>> >  #endif
>> >  #include <media/v4l2-common.h>
>> >  #include <media/v4l2-ioctl.h>
>> >
>> > +#include <media/v4l2-event.h>
>> >
>> >  #include <media/v4l2-chip-ident.h>
>> >
>> >  #define dbgarg(cmd, fmt, arg...) \
>> >
>> > @@ -1797,7 +1798,55 @@ static long __video_do_ioctl(struct file *file,
>> >
>> >  		}
>> >  		break;
>> >
>> >  	}
>> >
>> > +	case VIDIOC_DQEVENT:
>> > +	{
>> > +		struct v4l2_event *ev = arg;
>> > +
>> > +		if (!ops->vidioc_subscribe_event)
>> > +			break;
>> > +
>> > +		ret = v4l2_event_dequeue(fh, ev);
>> > +		if (ret < 0) {
>> > +			dbgarg(cmd, "no pending events?");
>> > +			break;
>> > +		}
>> > +		dbgarg(cmd,
>> > +		       "count=%d, type=0x%8.8x, sequence=%d, "
>> > +		       "timestamp=%lu.%9.9lu ",
>> > +		       ev->count, ev->type, ev->sequence,
>> > +		       ev->timestamp.tv_sec, ev->timestamp.tv_nsec);
>> > +		break;
>> > +	}
>> > +	case VIDIOC_SUBSCRIBE_EVENT:
>> > +	{
>> > +		struct v4l2_event_subscription *sub = arg;
>> >
>> > +		if (!ops->vidioc_subscribe_event)
>> > +			break;
>>
>> I know I said that we could use this test to determine if fh is of type
>> v4l2_fh, but that only works in this specific case, but not in the
>> general
>> case. For example, I want to add support for the prio ioctls to v4l2_fh,
>> and then I probably have no vidioc_subscribe_event set since few drivers
>> will need that.
>>
>> Instead I suggest that we add a new flag to v4l2-dev.h:
>>
>> V4L2_FL_USES_V4L2_FH (1)
>>
>> The v4l2_fh_add() function can then set this flag.
>>
>> > +
>> > +		ret = ops->vidioc_subscribe_event(fh, sub);
>> > +		if (ret < 0) {
>> > +			dbgarg(cmd, "failed, ret=%ld", ret);
>> > +			break;
>> > +		}
>> > +		dbgarg(cmd, "type=0x%8.8x", sub->type);
>> > +		break;
>> > +	}
>> > +	case VIDIOC_UNSUBSCRIBE_EVENT:
>> > +	{
>> > +		struct v4l2_event_subscription *sub = arg;
>> > +
>> > +		if (!ops->vidioc_subscribe_event)
>> > +			break;
>> > +
>> > +		ret = v4l2_event_unsubscribe(fh, sub);
>>
>> We should add an unsubscribe op as well. One reason is to add EVENT_ALL
>> support (see my comments in patch 7/7), the other is that in some cases
>> drivers might need to take some special action in response to
>> subscribing
>> an event. And a driver needs a way to undo that when unsubscribing.
>
> Agreed. Should we allow drivers not to define the unsubscribe operation
> when
> they don't need it ? In that case v4l2_event_unsubscribe should be called
> in
> VIDIOC_UNSUBSCRIBE_EVENT, outside of the operation handler.

Drivers can just use v4l2_event_unsubscribe directly as the ioctl op.

>
> Similarly, shouldn't v4l2_event_subscribe be called in
> VIDIOC_SUBSCRIBE_EVENT,
> outside of the operation handler ?

It can be done, but I am no fan of hiding such things in the core. It's
just a single function, after all.

Regards,

       Hans

>
> --
> Regards,
>
> Laurent Pinchart
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


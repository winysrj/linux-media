Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3780 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab0BVJVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 04:21:55 -0500
Message-ID: <3b2a22bbd1fd71331d3407c3653391b4.squirrel@webmail.xs4all.nl>
In-Reply-To: <201002221010.21248.laurent.pinchart@ideasonboard.com>
References: <4B7EE4A4.3080202@maxwell.research.nokia.com>
    <4B81B44F.7080201@maxwell.research.nokia.com>
    <201002220853.53921.hverkuil@xs4all.nl>
    <201002221010.21248.laurent.pinchart@ideasonboard.com>
Date: Mon, 22 Feb 2010 10:21:19 +0100
Subject: Re: [PATCH v5 5/6] V4L: Events: Support event handling in do_ioctl
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


> Hi Hans,
>
> On Monday 22 February 2010 08:53:53 Hans Verkuil wrote:
>> On Sunday 21 February 2010 23:31:43 Sakari Ailus wrote:
>> > Hans Verkuil wrote:
>> > > More comments...
>> > >
>> > > On Friday 19 February 2010 20:21:59 Sakari Ailus wrote:
>> > >> Add support for event handling to do_ioctl.
>> > >>
>> > >> Signed-off-by: Sakari Ailus
>> <sakari.ailus@maxwell.research.nokia.com>
>> > >> ---
>> > >>
>> > >>  drivers/media/video/v4l2-ioctl.c |   58
>> > >>  ++++++++++++++++++++++++++++++++++++++ include/media/v4l2-ioctl.h
>> > >>     |    7 ++++
>> > >>  2 files changed, 65 insertions(+), 0 deletions(-)
>> > >>
>> > >> diff --git a/drivers/media/video/v4l2-ioctl.c
>> > >> b/drivers/media/video/v4l2-ioctl.c index 34c7d6e..f7d6177 100644
>> > >> --- a/drivers/media/video/v4l2-ioctl.c
>> > >> +++ b/drivers/media/video/v4l2-ioctl.c
>> > >> @@ -25,6 +25,8 @@
>> > >>
>> > >>  #endif
>> > >>  #include <media/v4l2-common.h>
>> > >>  #include <media/v4l2-ioctl.h>
>> > >>
>> > >> +#include <media/v4l2-fh.h>
>> > >> +#include <media/v4l2-event.h>
>> > >>
>> > >>  #include <media/v4l2-chip-ident.h>
>> > >>
>> > >>  #define dbgarg(cmd, fmt, arg...) \
>> > >>
>> > >> @@ -1944,7 +1946,63 @@ static long __video_do_ioctl(struct file
>> *file,
>> > >>
>> > >>  		}
>> > >>  		break;
>> > >>
>> > >>  	}
>> > >>
>> > >> +	case VIDIOC_DQEVENT:
>> > >> +	{
>> > >> +		struct v4l2_event *ev = arg;
>> > >> +		struct v4l2_fh *vfh = fh;
>> > >> +
>> > >> +		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)
>> > >> +		    || vfh->events == NULL)
>> > >> +			break;
>> > >
>> > > Change this to:
>> > > 		if (!test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
>> > >
>> > > 			break;
>> > >
>> > > 		if (vfh->events == NULL)
>> > >
>> > > 			return -ENOENT;
>> > >
>> > > But see also the next comment.
>> > >
>> > >> +
>> > >> +		ret = v4l2_event_dequeue(fh, ev);
>> > >
>> > > There is a crucial piece of functionality missing here: if the
>> > > filehandle is in blocking mode, then it should wait until an event
>> > > arrives. That also means that if vfh->events == NULL, you should
>> still
>> > > call v4l2_event_dequeue, and that function should initialize
>> > > vfh->events and wait for an event if the fh is in blocking mode.
>> >
>> > I originally left this out intentionally. Most applications using
>> events
>> > would use select / poll as well by default. For completeness it should
>> > be there, I agree.
>>
>> It has to be there. This is important functionality. For e.g. ivtv I
>> would
>> use this to wait until the MPEG decoder flushed all buffers and
>> displayed
>> the last frame of the stream. That's something you would often do in
>> blocking mode.
>
> Blocking mode can easily be emulated using select().
>
>> > This btw. suggests that we perhaps should put back the struct file
>> > argument for the event functions in video_ioctl_ops. The blocking flag
>> > is indeed part of the file structure. I'm open to better suggestions,
>> > too.
>>
>> My long term goal is that the file struct is only used inside
>> v4l2-ioctl.c
>> and not in drivers. Drivers should not need this struct at all. The
>> easiest
>> way to ensure this is by not passing it to the drivers at all :-)
>
> Drivers still need a way to access the blocking flag. The interim solution
> of
> adding a file * member to v4l2_fh would allow that, while still removing
> most
> usage of file * from drivers.

Why not just add a 'blocking' argument to the v4l2_event_dequeue? And let
v4l2-ioctl.c fill in that argument? That's how I would do it.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


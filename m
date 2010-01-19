Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4967 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab0ASJDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 04:03:54 -0500
Message-ID: <cb5326b5d01b4a8e1f4a71bc81803b64.squirrel@webmail.xs4all.nl>
In-Reply-To: <201001190911.51636.laurent.pinchart@ideasonboard.com>
References: <4B30F713.8070004@maxwell.research.nokia.com>
    <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
    <alpine.LNX.2.01.1001181348540.31857@alastor>
    <201001190911.51636.laurent.pinchart@ideasonboard.com>
Date: Tue, 19 Jan 2010 10:03:48 +0100
Subject: Re: [RFC v2 5/7] V4L: Events: Limit event queue length
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	linux-media@vger.kernel.org, iivanov@mm-sol.com,
	gururaj.nagendra@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Monday 18 January 2010 13:58:09 Hans Verkuil wrote:
>> On Tue, 22 Dec 2009, Sakari Ailus wrote:
>> > Limit event queue length to V4L2_MAX_EVENTS. If the queue is full any
>> > further events will be dropped.
>> >
>> > This patch also updates the count field properly, setting it to
>> exactly
>> > to number of further available events.
>> >
>> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
>> > ---
>> > drivers/media/video/v4l2-event.c |   10 +++++++++-
>> > include/media/v4l2-event.h       |    5 +++++
>> > 2 files changed, 14 insertions(+), 1 deletions(-)
>
> [snip]
>
>> > diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
>> > index b11de92..69305c6 100644
>> > --- a/include/media/v4l2-event.h
>> > +++ b/include/media/v4l2-event.h
>> > @@ -28,6 +28,10 @@
>> > #include <linux/types.h>
>> > #include <linux/videodev2.h>
>> >
>> > +#include <asm/atomic.h>
>> > +
>> > +#define V4L2_MAX_EVENTS		1024 /* Ought to be enough for everyone. */
>>
>> I think this should be programmable by the driver. Most drivers do not
>> use
>> events at all, so by default it should be 0 or perhaps it can check
>> whether
>> the ioctl callback structure contains the event ioctls and set it to 0
>> or
>> some initial default value.
>>
>> And you want this to be controlled on a per-filehandle basis even. If I
>>  look at ivtv, then most of the device nodes will not have events, only
>> a
>>  few will support events. And for one device node type I know that there
>>  will only be a single event when stopping the streaming, while another
>>  device node type will get an event each frame.
>
> Don't you mean per video node instead of per file handle ? In that case we
> could add a new field to video_device structure that must be initialized
> by
> drivers before registering the device.

Yes, that's what I meant (although you state it much more clearly :-) ).

Regards,

      Hans

>> So being able to adjust the event queue dynamically will give more
>> control
>> and prevent unnecessary waste of memory resources.
>
> --
> Regards,
>
> Laurent Pinchart
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


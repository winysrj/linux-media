Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40666 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0AXNJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 08:09:45 -0500
Message-ID: <4B5C45F3.6060203@maxwell.research.nokia.com>
Date: Sun, 24 Jan 2010 15:06:59 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	iivanov@mm-sol.com, gururaj.nagendra@intel.com
Subject: Re: [RFC v2 5/7] V4L: Events: Limit event queue length
References: <4B30F713.8070004@maxwell.research.nokia.com> <1261500191-9441-1-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-2-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-3-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-4-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1261500191-9441-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <alpine.LNX.2.01.1001181348540.31857@alastor>
In-Reply-To: <alpine.LNX.2.01.1001181348540.31857@alastor>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> Hi Sakari,

Hi Hans,

And thanks for the comments!

...
>> @@ -103,7 +105,8 @@ int v4l2_event_dequeue(struct v4l2_fh *fh, struct
>> v4l2_event *event)
>>     ev = list_first_entry(&events->available, struct _v4l2_event, list);
>>     list_del(&ev->list);
>>
>> -    ev->event.count = !list_empty(&events->available);
>> +    atomic_dec(&events->navailable);
>> +    ev->event.count = atomic_read(&events->navailable);
> 
> Combine these two lines to atomic_dec_return().

Will fix this.

>>
>>     spin_unlock_irqrestore(&events->lock, flags);
>>
>> @@ -159,6 +162,9 @@ void v4l2_event_queue(struct video_device *vdev,
>> struct v4l2_event *ev)
>>         if (!v4l2_event_subscribed(fh, ev->type))
>>             continue;
>>
>> +        if (atomic_read(&fh->events.navailable) >= V4L2_MAX_EVENTS)
>> +            continue;
>> +
>>         _ev = kmem_cache_alloc(event_kmem, GFP_ATOMIC);
>>         if (!_ev)
>>             continue;
>> @@ -169,6 +175,8 @@ void v4l2_event_queue(struct video_device *vdev,
>> struct v4l2_event *ev)
>>         list_add_tail(&_ev->list, &fh->events.available);
>>         spin_unlock(&fh->events.lock);
>>
>> +        atomic_inc(&fh->events.navailable);
>> +
>>         wake_up_all(&fh->events.wait);
>>     }
>>
>> diff --git a/include/media/v4l2-event.h b/include/media/v4l2-event.h
>> index b11de92..69305c6 100644
>> --- a/include/media/v4l2-event.h
>> +++ b/include/media/v4l2-event.h
>> @@ -28,6 +28,10 @@
>> #include <linux/types.h>
>> #include <linux/videodev2.h>
>>
>> +#include <asm/atomic.h>
>> +
>> +#define V4L2_MAX_EVENTS        1024 /* Ought to be enough for
>> everyone. */
> 
> I think this should be programmable by the driver. Most drivers do not use
> events at all, so by default it should be 0 or perhaps it can check whether
> the ioctl callback structure contains the event ioctls and set it to 0 or
> some initial default value.

Right. I'll make the event queue size to be defined by the driver.

I'm now planning to make a queue for free events common to file handles
in video device. A statically allocated queue for each file handle is
probably too much overkill. But a device global queue also means that a
process that doesn't dequeue its events will starve the others.

> And you want this to be controlled on a per-filehandle basis even. If I
> look
> at ivtv, then most of the device nodes will not have events, only a few
> will
> support events. And for one device node type I know that there will only be
> a single event when stopping the streaming, while another device node type
> will get an event each frame.

Instead of initialising the events by the V4L2, the driver could do this
and specify the queue size at the same time. The overhead for the
drivers not using events would be the event information in the
video_device structure. That could be made a pointer as well.

> So being able to adjust the event queue dynamically will give more control
> and prevent unnecessary waste of memory resources.

This sounds to me like trying to re-invent the kmem_cache now. :-)

If the event queue is allocated in some other means than kmem_cache I
think the size should be fixed. The driver probably knows the best
what's the reasonable maximum event queue size and that could be
allocated statically. If that overflows then so be it.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4435 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZJTVsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 17:48:09 -0400
Message-ID: <73ad253d9db484d1340667207402769d.squirrel@webmail.xs4all.nl>
In-Reply-To: <4ADCDE6F.6000502@maxwell.research.nokia.com>
References: <4AD877A0.3080004@maxwell.research.nokia.com>
    <200910162243.05921.hverkuil@xs4all.nl>
    <4ADCDE6F.6000502@maxwell.research.nokia.com>
Date: Tue, 20 Oct 2009 23:48:12 +0200
Subject: Re: [RFC] Video events, version 2.1
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh" <vimarsh.zutshi@nokia.com>,
	"Ivan Ivanov" <iivanov@mm-sol.com>,
	"Cohen David Abraham" <david.cohen@nokia.com>,
	"Guru Raj" <gururaj.nagendra@intel.com>,
	"Mike Krufky" <mkrufky@linuxtv.org>, dheitmueller@kernellabs.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
> [clip]
>>> #define V4L2_EVENT_ALL			0x07ffffff
>>
>> I suggest using 0 instead of 0x07ffffff. Yes, 0 is still a magic number,
>> but
>> somehow it feels a lot less magic :-)
>
> Okay.
>
>>> #define V4L2_EVENT_PRIVATE_START	0x08000000
>>> #define V4L2_EVENT_RESERVED		0x10000000
>>
>> Rather than calling this RESERVED turn this into a mask:
>>
>> #define V4L2_EVENT_MASK	0x0fffffff
>
> Ok.
>
>>> VIDIOC_DQEVENT is used to get events. count is number of pending events
>>> after the current one. sequence is the event type sequence number and
>>> the data is specific to event type.
>>>
>>> The user will get the information that there's an event through
>>> exception file descriptors by using select(2). When an event is
>>> available the poll handler sets POLLPRI which wakes up select. -EINVAL
>>> will be returned if there are no pending events.
>>>
>>> VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to
>>> subscribe and unsubscribe from events. The argument is struct
>>> v4l2_event_subscription which now only contains the type field for the
>>> event type. Every event can be subscribed or unsubscribed by one ioctl
>>> by using special type V4L2_EVENT_ALL.
>>>
>>>
>>> struct v4l2_event {
>>> 	__u32		count;
>>> 	__u32		type;
>>> 	__u32		sequence;
>>> 	struct timeval	timestamp;
>>> 	__u32		reserved[8];
>>> 	__u8		data[64];
>>> };
>>>
>>> struct v4l2_event_subscription {
>>> 	__u32		type;
>>> 	__u32		reserved[8];
>>> };
>>>
>>> #define VIDIOC_DQEVENT		_IOR('V', 84, struct v4l2_event)
>>> #define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, struct
>>> 				     v4l2_event_subscription)
>>> #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, struct
>>> 				      v4l2_event_subscription)
>>
>> Perhaps we should use just one ioctl and use a flag in the
>> event_subscription struct to tell whether to subscribe or unsubscribe?
>> Just
>> brainstorming here.
>
> Having two ioctls would be equivalent to STREAMON and STREAMOFF, that's
> why I originally picked that. I can't immediately figure a way it could
> be done nicely by using a flag.

OK.

>>> The size of the event queue is decided by the driver. Which events will
>>> be discarded on queue overflow depends on the implementation.
>>>
>>>
>>> Questions
>>> ---------
>>>
>>> One more question I have is that there can be situations that the
>>> application wants to know something has happened but does not want an
>>> explicit notification from that. So it gets an event from
>>> VIDIOC_DQEVENT
>>> but does not want to get woken up for that reason. I guess one flag in
>>> event subscription should do that. Perhaps that is something that
>>> should
>>> be implemented when needed, though.
>>
>> Yeah, lets implement this only when needed.
>>
>>> Are there enough reserved fields now?
>>
>> Personally I think 4 reserved fields for the event_subscription is
>> enough. 8
>> reserved fields for that seems overkill to me.
>
> struct v4l2_format is IMO a good example of having enough unused fields.
> ;)
>
> I see that 8 reserved fields might make sense at least for v4l2_event. I
> wouldn't mind if we had that many in v4l2_event_subscription as well.
> There is already proposed use for three of them:
>
> - flags (e.g. notification / no notification)
> - entity
>
> - number of pending events
>
> The two first ones might make sense in v4l2_event_subscription as well.
> That would leave just two reserved fields afterwards.
>
> The entity field would fit to v4l2_event_subscription for the same
> reasons than to v4l2_event; if there are several entities the event
> could be coming from we could limit it to just some. Perhaps a bit
> far-fetched but still...
>
> And I wouldn't be surprised if a need appeared to something like
> priority as Tomasz suggested. After all that we'd be left with just one
> reserved field if we decided to use all 32 bits for priority.
>
> The basic event delivery problem is IMO very well understood but there
> are just so many ideas on extensions (many of which sound quite
> reasonable) already at this point that I'm slightly worried about the
> future if we just have a few reserved fields. Unnecessary bloat still
> must be kept away, of course.

Good points. I agree with you.

>>> How about the event type high
>>> order bits split?
>>
>> Yes, what's the purpose of that? I don't see a good reason for that.
>
> Me neither. Although even if we don't see use for them now it doesn't
> mean there couldn't be any in future. We can always say that the
> reserved bits are no more reserved but not the other way around.
>
> I originally though those few bits could be used for flags that now are
> part of the structure.
>
> Or we could just drop the reserved bits, I'm not against that.

I propose to just drop it, but document that we shouldn't use the top
4-bits for now. We might use it in the future if we ever need an event
enum and want to do something like the NEXT_CTRL flag that QUERYCTRL
supports.

Regards,

      Hans

>
> --
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom


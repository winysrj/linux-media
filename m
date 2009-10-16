Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4786 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZJPUnG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 16:43:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Video events, version 2.1
Date: Fri, 16 Oct 2009 22:43:05 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>, dheitmueller@kernellabs.org
References: <4AD877A0.3080004@maxwell.research.nokia.com>
In-Reply-To: <4AD877A0.3080004@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910162243.05921.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 October 2009 15:39:44 Sakari Ailus wrote:
> Hi,
>
>
> Here's the version 2.1 of the video events RFC. It's based on Laurent
> Pinchart's original RFC and version 2 which I wrote some time ago. This
> time the changes are done based on discussion on the list. The old RFC
> is available here:
>
> <URL:http://www.spinics.net/lists/linux-media/msg10971.html>
>
> (Cc:d to Mike Krufky and Devin Heitmueller, too.)
>
> Changes to version 2
> --------------------
>
> #define V4L2_EVENT_ALL
>
> VIDIOC_G_EVENT -> VIDIOC_DQEVENT
>
> Event enumeration is gone.
>
> Reserved fields moved before data in v4l2_event and now there are 8 of
> them instead of 4.
>
> Event (un)subscription argument is now v4l2_event_subscription.
>
> Interface description
> ---------------------
>
> Event type is either a standard event or private event. Standard events
> will be defined in videodev2.h. Private event types begin from
> V4L2_EVENT_PRIVATE. Some high order bits will be reserved for future use.
>
> #define V4L2_EVENT_ALL			0x07ffffff

I suggest using 0 instead of 0x07ffffff. Yes, 0 is still a magic number, but 
somehow it feels a lot less magic :-)

> #define V4L2_EVENT_PRIVATE_START	0x08000000
> #define V4L2_EVENT_RESERVED		0x10000000

Rather than calling this RESERVED turn this into a mask:

#define V4L2_EVENT_MASK	0x0fffffff

>
> VIDIOC_DQEVENT is used to get events. count is number of pending events
> after the current one. sequence is the event type sequence number and
> the data is specific to event type.
>
> The user will get the information that there's an event through
> exception file descriptors by using select(2). When an event is
> available the poll handler sets POLLPRI which wakes up select. -EINVAL
> will be returned if there are no pending events.
>
> VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to
> subscribe and unsubscribe from events. The argument is struct
> v4l2_event_subscription which now only contains the type field for the
> event type. Every event can be subscribed or unsubscribed by one ioctl
> by using special type V4L2_EVENT_ALL.
>
>
> struct v4l2_event {
> 	__u32		count;
> 	__u32		type;
> 	__u32		sequence;
> 	struct timeval	timestamp;
> 	__u32		reserved[8];
> 	__u8		data[64];
> };
>
> struct v4l2_event_subscription {
> 	__u32		type;
> 	__u32		reserved[8];
> };
>
> #define VIDIOC_DQEVENT		_IOR('V', 84, struct v4l2_event)
> #define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, struct
> 				     v4l2_event_subscription)
> #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, struct
> 				      v4l2_event_subscription)

Perhaps we should use just one ioctl and use a flag in the 
event_subscription struct to tell whether to subscribe or unsubscribe? Just 
brainstorming here.

>
> The size of the event queue is decided by the driver. Which events will
> be discarded on queue overflow depends on the implementation.
>
>
> Questions
> ---------
>
> One more question I have is that there can be situations that the
> application wants to know something has happened but does not want an
> explicit notification from that. So it gets an event from VIDIOC_DQEVENT
> but does not want to get woken up for that reason. I guess one flag in
> event subscription should do that. Perhaps that is something that should
> be implemented when needed, though.

Yeah, lets implement this only when needed.

> Are there enough reserved fields now?

Personally I think 4 reserved fields for the event_subscription is enough. 8 
reserved fields for that seems overkill to me.

> How about the event type high 
> order bits split?

Yes, what's the purpose of that? I don't see a good reason for that.

> What should we really call v4l2_event_subscription? A better name for
> the structure would be perhaps favourable.
>
>
> Comments and questions are still very very welcome.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

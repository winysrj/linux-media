Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:2487 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZJPOc5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 10:32:57 -0400
Message-ID: <4AD8802E.8010608@linuxtv.org>
Date: Fri, 16 Oct 2009 10:16:14 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	dheitmueller@kernellabs.org, mkrufky@kernellabs.com
References: <4AD877A0.3080004@maxwell.research.nokia.com>
In-Reply-To: <4AD877A0.3080004@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC] Video events, version 2.1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's please just use either my @linuxtv.org or @kernellabs.com email 
account for this...

Thanks,

Mike

Sakari Ailus wrote:
>
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
> #define V4L2_EVENT_ALL                  0x07ffffff
> #define V4L2_EVENT_PRIVATE_START        0x08000000
> #define V4L2_EVENT_RESERVED             0x10000000
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
>         __u32           count;
>         __u32           type;
>         __u32           sequence;
>         struct timeval  timestamp;
>         __u32           reserved[8];
>         __u8            data[64];
> };
>
> struct v4l2_event_subscription {
>         __u32           type;
>         __u32           reserved[8];
> };
>
> #define VIDIOC_DQEVENT          _IOR('V', 84, struct v4l2_event)
> #define VIDIOC_SUBSCRIBE_EVENT  _IOW('V', 85, struct
>                                      v4l2_event_subscription)
> #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, struct
>                                       v4l2_event_subscription)
>
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
>
> Are there enough reserved fields now? How about the event type high
> order bits split?
>
> What should we really call v4l2_event_subscription? A better name for
> the structure would be perhaps favourable.
>
>
> Comments and questions are still very very welcome.
>
> -- 
> Sakari Ailus
> sakari.ailus@maxwell.research.nokia.com
>


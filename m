Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2584 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZJNRtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 13:49:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Video events, version 2
Date: Wed, 14 Oct 2009 19:48:33 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
References: <4AD5CBD6.4030800@maxwell.research.nokia.com>
In-Reply-To: <4AD5CBD6.4030800@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910141948.33666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 14 October 2009 15:02:14 Sakari Ailus wrote:
> Hi,
> 
> 
> Here's the second version of the video events RFC. It's based on Laurent 
> Pinchart's original RFC. My aim is to address the issues found in the 
> old RFC during the V4L-DVB mini-summit in the Linux plumbers conference 
> 2009. To get a good grasp of the problem at hand it's probably a good 
> idea read the original RFC as well:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg10217.html>
> 
> 
> Changes to version 1
> ----------------------------------
> 
> struct video_event has been renamed to v4l2_event. The struct is used in 
> userspace and V4L related structures appear to have v4l2 prefix so that 
> should be better than video.
> 
> The "entity" field has been removed from the struct v4l2_event since the 
> subdevices will have their own device nodes --- the events should come 
> from them instead of the media controller. Video nodes could be used for 
> events, too.
> 
> A few reserved fields have been added. There are new ioctls as well for 
> enumeration and (un)subscribing.
> 
> 
> Interface description
> ---------------------
> 
> Event type is either a standard event or private event. Standard events 
> will be defined in videodev2.h. Private event types begin from 
> V4L2_EVENT_PRIVATE. Some high order bits could be reserved for future use.
> 
> #define V4L2_EVENT_PRIVATE_START	0x08000000
> #define V4L2_EVENT_RESERVED		0x10000000

Suggestion: use the V4L2_EV_ prefix perhaps instead of the longer V4L2_EVENT?

> 
> VIDIOC_ENUM_EVENT is used to enumerate the available event types. It 
> works a bit the same way than VIDIOC_ENUM_FMT i.e. you get the next 
> event type by calling it with the last type in the type field. The 
> difference is that the range is not continuous like in querying controls.

Question: why do we need an ENUM_EVENT? I don't really see a use-case for this.

Also note that there are three methods in use for enumerating within V4L:

1) there is an index field in the struct that starts at 0 and that the
application increases by 1 until the ioctl returns an error.

2) old-style controls where just enumerated from CID_BASE to CID_LASTP1,
which is very, very ugly.

3) controls new-style allow one to set bit 31 on the control ID and in that
case the ioctl will give you the first control with an ID that is higher than
the specified ID.

1 or 3 are both valid options IMHO.

But again, I don't see why we need it in the first place.

> VIDIOC_G_EVENT is used to get events. sequence is the event sequence 
> number and the data is specific to driver or event type.
> 
> The user will get the information that there's an event through 
> exception file descriptors by using select(2). When an event is 
> available the poll handler sets POLLPRI which wakes up select. -EINVAL 
> will be returned if there are no pending events.
> 
> VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to 
> subscribe and unsubscribe from events. The argument is event type.
> 

Two event types can be defined already (used by ivtv):

#define V4L2_EVENT_DECODER_STOPPED   1
#define V4L2_EVENT_OUTPUT_VSYNC      2

> 
> struct v4l2_eventdesc {
> 	__u32		type;
> 	__u8		description[64];
> 	__u32		reserved[4];
> };
> 
> struct v4l2_event {
> 	__u32		type;
> 	__u32		sequence;
> 	struct timeval	timestamp;
> 	__u8		data[64];

This should be a union:


union {
	enum v4l2_field ev_output_vsync;
	__u8 data[64];
};

> 	__u32		reserved[4];
> };
> 
> #define VIDIOC_ENUM_EVENT	_IORW('V', 83, struct v4l2_eventdesc)
> #define VIDIOC_G_EVENT		_IOR('V', 84, struct v4l2_event)
> #define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, __u32)
> #define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, __u32)

For (un)subscribe I suggest that we also use a struct with the event type
and a few reserved fields.

> 
> 
> As it was discussed in the LPC, event subscriptions should be bound to 
> file handle. The implementation, however, is not visible to userspace. 
> This is why I'm not specifying it in this RFC.
> 
> While the number of possible standard (and probably private) events 
> would be quite small and the implementation could be a bit field, I do 
> see that the interface must be using types passed as numbers instead of 
> bit fields.
> 
> Is it necessary to buffer events of same type or will an event replace 
> an older event of the same type? It probably depends on event type which 
> is better. This is also a matter of implementation.
> 
> 
> Comments and questions are more than welcome.

Here's a mixed bag of idea/comments:

We need to define what to do when you unsubscribe an event and there are still
events of that type pending. Do we remove those pending events as well?
I think we should just keep them, but I'm open for other opinions.

I was wondering if a 'count' field in v4l2_event might be useful: e.g. if you
get multiple identical events, and that event is already registered, then you
can just increase the count rather than adding the same event again. This
might be overengineering, though. And to be honest, I can't think of a
use-case, but it's something to keep in mind perhaps.

Would we ever need a VIDIOC_S_EVENT to let the application set an event?
('software events').

Rather than naming the ioctl VIDIOC_G_EVENT, perhaps VIDIOC_DQEVENT might be
more appropriate.

How do we prevent the event queue from overflowing? Just hardcode a watermark?
Alternatively, when subscribing an event we can also pass the maximum number
of allowed events as an argument.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

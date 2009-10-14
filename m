Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27814 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760272AbZJNNEY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 09:04:24 -0400
Message-ID: <4AD5CBD6.4030800@maxwell.research.nokia.com>
Date: Wed, 14 Oct 2009 16:02:14 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: [RFC] Video events, version 2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


Here's the second version of the video events RFC. It's based on Laurent 
Pinchart's original RFC. My aim is to address the issues found in the 
old RFC during the V4L-DVB mini-summit in the Linux plumbers conference 
2009. To get a good grasp of the problem at hand it's probably a good 
idea read the original RFC as well:

<URL:http://www.spinics.net/lists/linux-media/msg10217.html>


Changes to version 1
----------------------------------

struct video_event has been renamed to v4l2_event. The struct is used in 
userspace and V4L related structures appear to have v4l2 prefix so that 
should be better than video.

The "entity" field has been removed from the struct v4l2_event since the 
subdevices will have their own device nodes --- the events should come 
from them instead of the media controller. Video nodes could be used for 
events, too.

A few reserved fields have been added. There are new ioctls as well for 
enumeration and (un)subscribing.


Interface description
---------------------

Event type is either a standard event or private event. Standard events 
will be defined in videodev2.h. Private event types begin from 
V4L2_EVENT_PRIVATE. Some high order bits could be reserved for future use.

#define V4L2_EVENT_PRIVATE_START	0x08000000
#define V4L2_EVENT_RESERVED		0x10000000

VIDIOC_ENUM_EVENT is used to enumerate the available event types. It 
works a bit the same way than VIDIOC_ENUM_FMT i.e. you get the next 
event type by calling it with the last type in the type field. The 
difference is that the range is not continuous like in querying controls.

VIDIOC_G_EVENT is used to get events. sequence is the event sequence 
number and the data is specific to driver or event type.

The user will get the information that there's an event through 
exception file descriptors by using select(2). When an event is 
available the poll handler sets POLLPRI which wakes up select. -EINVAL 
will be returned if there are no pending events.

VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to 
subscribe and unsubscribe from events. The argument is event type.


struct v4l2_eventdesc {
	__u32		type;
	__u8		description[64];
	__u32		reserved[4];
};

struct v4l2_event {
	__u32		type;
	__u32		sequence;
	struct timeval	timestamp;
	__u8		data[64];
	__u32		reserved[4];
};

#define VIDIOC_ENUM_EVENT	_IORW('V', 83, struct v4l2_eventdesc)
#define VIDIOC_G_EVENT		_IOR('V', 84, struct v4l2_event)
#define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, __u32)
#define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, __u32)


As it was discussed in the LPC, event subscriptions should be bound to 
file handle. The implementation, however, is not visible to userspace. 
This is why I'm not specifying it in this RFC.

While the number of possible standard (and probably private) events 
would be quite small and the implementation could be a bit field, I do 
see that the interface must be using types passed as numbers instead of 
bit fields.

Is it necessary to buffer events of same type or will an event replace 
an older event of the same type? It probably depends on event type which 
is better. This is also a matter of implementation.


Comments and questions are more than welcome.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

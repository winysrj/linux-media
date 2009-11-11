Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:59386 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZKKVbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 16:31:18 -0500
Message-ID: <4AFB2D14.1010305@maxwell.research.nokia.com>
Date: Wed, 11 Nov 2009 23:31:00 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC] Video events, version 2.3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,


Here's the version 2.3 of the video events RFC which hopefully will be 
the final one. It's based on Laurent Pinchart's original RFC and 
versions 2, 2.1 and 2.2 which I wrote. The old RFC is available here:

<URL:http://www.spinics.net/lists/linux-media/msg11254.html>

Changes to version 2.2
--------------------

- The timestamp has changed from struct timeval (do_gettimeofday()) to 
struct timespec (clock_getres(CLOCK_MONOTONIC)).

Interface description
---------------------

Event type is either a standard event or private event. Standard events
will be defined in videodev2.h. Private event types begin from
V4L2_EVENT_PRIVATE_START. The four topmost bits of the type should not
be used for the moment.

#define V4L2_EVENT_ALL			0
#define V4L2_EVENT_PRIVATE_START	0x08000000

VIDIOC_DQEVENT is used to get events. count is number of pending events
after the current one. sequence is the event type sequence number and
the data is specific to event type.

The user will get the information that there's an event through
exception file descriptors by using select(2). When an event is
available the poll handler sets POLLPRI which wakes up select. -EINVAL
will be returned if there are no pending events.

VIDIOC_SUBSCRIBE_EVENT and VIDIOC_UNSUBSCRIBE_EVENT are used to
subscribe and unsubscribe from events. The argument is struct
v4l2_event_subscription which now only contains the type field for the
event type. Every event can be subscribed or unsubscribed by one ioctl
by using special type V4L2_EVENT_ALL.


struct v4l2_event {
	__u32		count;
	__u32		type;
	__u32		sequence;
	struct timespec	timestamp;
	__u32		reserved[8];
	__u8		data[64];
};

struct v4l2_event_subscription {
	__u32		type;
	__u32		reserved[8];
};

#define VIDIOC_DQEVENT		_IOR('V', 84, struct v4l2_event)
#define VIDIOC_SUBSCRIBE_EVENT	_IOW('V', 85, struct
				     v4l2_event_subscription)
#define VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 86, struct
				      v4l2_event_subscription)


The size of the event queue is decided by the driver. Which events will
be discarded on queue overflow depends on the implementation.


Questions
---------

None on my side.

Comments and questions are still very very welcome.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com



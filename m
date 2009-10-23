Return-path: <linux-media-owner@vger.kernel.org>
Received: from unknown.interbgc.com ([213.240.235.226]:44158 "EHLO
	extserv.mm-sol.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbZJWM7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 08:59:50 -0400
Subject: Re: [RFC] Video events, version 2.2
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <4AE182DD.6060103@maxwell.research.nokia.com>
References: <4AE182DD.6060103@maxwell.research.nokia.com>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 15:59:39 +0300
Message-Id: <1256302779.10472.45.camel@iivanov.int.mm-sol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Sakari, 

On Fri, 2009-10-23 at 13:18 +0300, Sakari Ailus wrote:
> Hi,
> 
> 
> Here's the version 2.2 of the video events RFC. It's based on Laurent
> Pinchart's original RFC and versions 2 and 2.1 which I wrote. The old 
> RFC is available here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg11056.html>
> 
> Added Mauro to Cc.
> 
> Changes to version 2.1
> --------------------
> 
> V4L2_EVENT_ALL is now 0 instead 0x07ffffff.
> 
> V4L2_EVENT_RESERVED is gone. A note will be added not to use four 
> topmost bits.
> 
> It's V4L2_EVENT_PRIVATE_START, not V4L2_EVENT_PRIVATE.
> 
> Interface description
> ---------------------
> 
> Event type is either a standard event or private event. Standard events
> will be defined in videodev2.h. Private event types begin from
> V4L2_EVENT_PRIVATE_START. The four topmost bits of the type should not 
> be used for the moment.
> 
> #define V4L2_EVENT_ALL			0
> #define V4L2_EVENT_PRIVATE_START	0x08000000
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

Can we use 'struct timespec' here. This will force actual 
implementation to use high-resolution source if possible, 
and remove hundreds gettimeofday() in user space, which 
should be used for event synchronization, with more 
power friendly clock_getres(CLOCK_MONOTONIC).

Thank you.

iivanov


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
> 
> 
> The size of the event queue is decided by the driver. Which events will
> be discarded on queue overflow depends on the implementation.
> 
> 
> Questions
> ---------
> 
> None on my side.
> 
> Comments and questions are still very very welcome.
> 


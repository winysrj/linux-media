Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1825 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947AbZKKR7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 12:59:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] Video events, version 2.2
Date: Wed, 11 Nov 2009 18:59:09 +0100
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <4AE182DD.6060103@maxwell.research.nokia.com> <200911110819.59521.hverkuil@xs4all.nl> <4AFAF490.6090507@maxwell.research.nokia.com>
In-Reply-To: <4AFAF490.6090507@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911111859.09500.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 11 November 2009 18:29:52 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Saturday 24 October 2009 23:56:24 Sakari Ailus wrote:
> >> Ivan T. Ivanov wrote:
> >>> Hi Sakari, 
> >> Hi,
> >>
> >>> On Fri, 2009-10-23 at 13:18 +0300, Sakari Ailus wrote:
> >> [clip]
> >>>> struct v4l2_event {
> >>>> 	__u32		count;
> >>>> 	__u32		type;
> >>>> 	__u32		sequence;
> >>>> 	struct timeval	timestamp;
> >>> Can we use 'struct timespec' here. This will force actual 
> >>> implementation to use high-resolution source if possible, 
> >>> and remove hundreds gettimeofday() in user space, which 
> >>> should be used for event synchronization, with more 
> >>> power friendly clock_getres(CLOCK_MONOTONIC).
> >> Good point. I originally picked timeval since it was used in 
> >> v4l2_buffer. The spec tells to use gettimeofday() for system time but 
> >> clock skewing is causes problems in video encoding. 
> >> clock_getres(CLOCK_MONOTONIC) is free of clock skewing and thus should 
> >> be more suitable for this kind of use.
> >>
> >> I also propose to use timespec instead of timeval.
> >>
> > 
> > Hi Sakari,
> > 
> > What is that status of the event API? It is my impression that it is pretty
> > much finished. Sakari, can you make a final 2.3 RFC? Then Guru can take over
> > and start the implementation.
> 
> Ah.
> 
> One thing that I was still wondering was that are there use cases where 
> other kind of time stamps might be useful? I guess that when the V4L2 
> was designed no-one though of the need for time stamps of different 
> type. So are there use cases where gettimeofday() style stamps would 
> still be better?

If you ever need to relate an event to a specific captured frame, then that
might well be useful. But I can't think of an actual use case, though.

> In that case we might choose to leave it driver's decision to decide 
> what kind of timestamps to use and in that case application would just 
> have to know. The alternative would be to use union and a flag telling 
> what's in there.
> 

Let's go with timespec. If we need to add an event that has to relate to
a specific captured frame then it is always possible to add a struct timeval
as part of the event data for that particular event.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

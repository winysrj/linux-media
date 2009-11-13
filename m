Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbZKMPaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 10:30:24 -0500
Date: Fri, 13 Nov 2009 13:29:47 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC] Video events, version 2.2
Message-ID: <20091113132947.0d307bfd@pedra.chehab.org>
In-Reply-To: <200911111859.09500.hverkuil@xs4all.nl>
References: <4AE182DD.6060103@maxwell.research.nokia.com>
	<200911110819.59521.hverkuil@xs4all.nl>
	<4AFAF490.6090507@maxwell.research.nokia.com>
	<200911111859.09500.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Nov 2009 18:59:09 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Wednesday 11 November 2009 18:29:52 Sakari Ailus wrote:
> > Hans Verkuil wrote:
> > > On Saturday 24 October 2009 23:56:24 Sakari Ailus wrote:
> > >> Ivan T. Ivanov wrote:
> > >>> Hi Sakari, 
> > >> Hi,
> > >>
> > >>> On Fri, 2009-10-23 at 13:18 +0300, Sakari Ailus wrote:
> > >> [clip]
> > >>>> struct v4l2_event {
> > >>>> 	__u32		count;
> > >>>> 	__u32		type;
> > >>>> 	__u32		sequence;
> > >>>> 	struct timeval	timestamp;
> > >>> Can we use 'struct timespec' here. This will force actual 
> > >>> implementation to use high-resolution source if possible, 
> > >>> and remove hundreds gettimeofday() in user space, which 
> > >>> should be used for event synchronization, with more 
> > >>> power friendly clock_getres(CLOCK_MONOTONIC).
> > >> Good point. I originally picked timeval since it was used in 
> > >> v4l2_buffer. The spec tells to use gettimeofday() for system time but 
> > >> clock skewing is causes problems in video encoding. 
> > >> clock_getres(CLOCK_MONOTONIC) is free of clock skewing and thus should 
> > >> be more suitable for this kind of use.
> > >>
> > >> I also propose to use timespec instead of timeval.
> > >>
> > > 
> > > Hi Sakari,
> > > 
> > > What is that status of the event API? It is my impression that it is pretty
> > > much finished. Sakari, can you make a final 2.3 RFC? Then Guru can take over
> > > and start the implementation.
> > 
> > Ah.
> > 
> > One thing that I was still wondering was that are there use cases where 
> > other kind of time stamps might be useful? I guess that when the V4L2 
> > was designed no-one though of the need for time stamps of different 
> > type. So are there use cases where gettimeofday() style stamps would 
> > still be better?
> 
> If you ever need to relate an event to a specific captured frame, then that
> might well be useful. But I can't think of an actual use case, though.
> 
> > In that case we might choose to leave it driver's decision to decide 
> > what kind of timestamps to use and in that case application would just 
> > have to know. The alternative would be to use union and a flag telling 
> > what's in there.
> > 
> 
> Let's go with timespec. If we need to add an event that has to relate to
> a specific captured frame then it is always possible to add a struct timeval
> as part of the event data for that particular event.

I don't agree. It is better to use the same timestamp type used by the streaming
interface. Having two different ways to represent it for the same devices is
confusing, and changing it later doesn't make sense. I foresee some cases where
correlating the two timestamps would be a need.
> Regards,
> 
> 	Hans
> 

Cheers,
Mauro

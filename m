Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:19336 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab3LKKo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 05:44:58 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXN00AES1UXG380@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Dec 2013 05:44:57 -0500 (EST)
Date: Wed, 11 Dec 2013 08:44:51 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Wade Farnsworth <wade_farnsworth@mentor.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
Message-id: <20131211084451.0e90044a@samsung.com>
In-reply-to: <52A81476.6020207@xs4all.nl>
References: <52614DB9.8090908@mentor.com> <528FB50C.6060909@mentor.com>
 <529090A9.7030505@xs4all.nl> <5290D826.5080308@gmail.com>
 <5290DDD8.7070305@xs4all.nl> <20131210185359.49f3f020@samsung.com>
 <52A81476.6020207@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Em Wed, 11 Dec 2013 08:29:58 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/10/2013 09:53 PM, Mauro Carvalho Chehab wrote:
> > Em Sat, 23 Nov 2013 17:54:48 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 11/23/2013 05:30 PM, Sylwester Nawrocki wrote:
> >>> Hi,
> >>>
> >>> On 11/23/2013 12:25 PM, Hans Verkuil wrote:
> >>>> Hi Wade,
> >>>>
> >>>> On 11/22/2013 08:48 PM, Wade Farnsworth wrote:
> >>>>> Add tracepoints to the QBUF and DQBUF ioctls to enable rudimentary
> >>>>> performance measurements using standard kernel tracers.
> >>>>>
> >>>>> Signed-off-by: Wade Farnsworth<wade_farnsworth@mentor.com>
> >>>>> ---
> >>>>>
> >>>>> This is the update to the RFC patch I posted a few weeks back.  I've added
> >>>>> several bits of metadata to the tracepoint output per Mauro's suggestion.
> >>>>
> >>>> I don't like this. All v4l2 ioctls can already be traced by doing e.g.
> >>>> echo 1 (or echo 2)>/sys/class/video4linux/video0/debug.
> >>>>
> >>>> So this code basically duplicates that functionality. It would be nice to be able
> >>>> to tie in the existing tracing code (v4l2-ioctl.c) into tracepoints.
> >>>
> >>> I think it would be really nice to have this kind of support for standard
> >>> traces at the v4l2 subsystem. Presumably it could even gradually replace
> >>> the v4l2 custom debug infrastructure.
> >>>
> >>> If I understand things correctly, the current tracing/profiling 
> >>> infrastructure
> >>> is much less invasive than inserting printks all over, which may cause 
> >>> changes
> >>> in control flow. I doubt the system could be reliably profiled by 
> >>> enabling all
> >>> those debug prints.
> >>>
> >>> So my vote would be to add support for standard tracers, like in other
> >>> subsystems in the kernel.
> >>
> >> The reason for the current system is to trace which ioctls are called in
> >> what order by a misbehaving application. It's very useful for that,
> >> especially when trying to debug user problems.
> >>
> >> I don't mind switching to tracepoints as long as this functionality is
> >> kept one way or another.
> > 
> > I agree with Sylwester: we should move to tracepoints, and this is a good
> > start.
> 
> As I mentioned, I don't mind switching to tracepoints, but not in the way the
> current patch does it. I certainly don't agree with you merging this patch
> as-is without further discussion.

Let's not mix the subjects here. There are two different demands that can be
either fulfilled by the same solution or by different ones:
	1) To have a way to enable debugging all parameters passed from/to
userspace;
	2) To be able to measure the driver (and core) performance while
streaming.

This patch's scope is to solve (2), by allowing userspace to hook the two
ioctls that queues/dequeues streaming buffers.

With that regards, what's wrong on this patch? I couldn't see anything bad
there. It is not meant to solve (1).

Before this patch, all we have is (1), as a non-dynamic printk is too
intrusive to be used for performance measurement. So, there's no way to
measure how much time a buffer takes to be filled.

In a matter of fact, in the case you didn't noticed, we are already somewhat
moving to traces, as several drivers are now using dynamic_printk for debug 
messages, Yet, lots of drivers still use either their own normal
printk-based debug macros.

Now, you're proposing to use the same solution for (1) too. 

Ok, we can go on that direction, but this is a separate issue. Converting
the v4l2-ioctl to use tracepoints is the easiest part. However, there are
several things to consider, if we decide to use it for debug purposes:

a) It will likely require to convert all printks to dynamic ones, as we
want to have all debug messages serialized.

Let me explain it better: if some debug messages come via the standard 
printk mechanism while others come via traces, we loose the capability
of receiving the messages at the same order that they were produced, and
it could be harder if not impossible to synchronize them into the right
order.

b) It may make sense to write an userspace tool similar to the rasdaemon
[1] to allow controlling the debug output. That tool directly reads the
events from the raw tracing queues, formatting the data on userspace and
hooking only the events that are needed. 

Currently, the rasdaemon has inside part of the code used by a perf
tool copied on it (as this code is not inside any library yet). However,
that code is being prepared to be used as a library. So, it should be
even easier to write such tool in a near future.

[1] https://git.fedorahosted.org/cgit/rasdaemon.git/

c) I don't think that tracepoints are the right mechanism for a post-mortem
analysis[2]. E. g. if the Kernel crashes, a printk-based mechanism will 
output something, but I'm not sure if doing the same is possible with traces
(e. g. forcing the trace messages to go to to tty).

You should notice that, with the dynamic_printk macros, it is possible to
compile the Kernel to use normal printk macros for debug macros.

However, if we convert the ioctl printk's to tracepoints, we may still
need to have a fallback printk mechanism for ioctl debug messages.

[2] There are actually some discussions at the RAS mailing lists about
how to store the tracing data and printk messages on newer hardware that
offer a non-volatile memory mechanism for that. So, we might actually
have a post-mortem mechanism for tracepoints in the future, depending on
the hardware. Yet, not all types of hardware will have such NVRAM.

Btw, it is possible to use strace to trace all ioctl's. So, the existing
mechanism is actually a duplicated feature, as userspace already covers it.
However, in practice, we opted to explicitly duplicate that feature at
Kernel level, for debugging purposes, because strace doesn't solve (a)
and (c).

What I'm saying is that a project to convert the debug facility into
tracepoints is something that:
	- it is independent of adding some facility for performance 
	  measurement (although it may share the same infrastructure);

	- it will require lots of effort to change every single driver
	  to use dynamic printk's;

	- it may require writing a helper tool to enable just the v4l2
	  traces and eventually collect them;

	- it may require a fallback printk mechanism in order to debug
	  kernel panic.

> To make it official:
> 
> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If we do tracepoints, then we do it right and for all ioctls, not in this
> half-baked manner.
> 
> Please revert.

Let's not mix things. If this patch is correct and solves for performance
measurement, I don't see any reason to revert.

Using tracepoints for debug is a separate and independent project.

Such project require lots of tests to proof that it is a viable solution,
several discussions and a huge time frame to convert all drivers to use
tracepoints too, plus some post-mortem debug logic.

Regards,
Mauro

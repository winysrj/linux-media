Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1150 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3LKLz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 06:55:56 -0500
Message-ID: <52A85253.5090101@xs4all.nl>
Date: Wed, 11 Dec 2013 12:53:55 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Wade Farnsworth <wade_farnsworth@mentor.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
References: <52614DB9.8090908@mentor.com> <528FB50C.6060909@mentor.com> <529090A9.7030505@xs4all.nl> <5290D826.5080308@gmail.com> <5290DDD8.7070305@xs4all.nl> <20131210185359.49f3f020@samsung.com> <52A81476.6020207@xs4all.nl> <20131211084451.0e90044a@samsung.com>
In-Reply-To: <20131211084451.0e90044a@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 12/11/13 11:44, Mauro Carvalho Chehab wrote:
> Hans,
> 
> Em Wed, 11 Dec 2013 08:29:58 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 12/10/2013 09:53 PM, Mauro Carvalho Chehab wrote:
>>> Em Sat, 23 Nov 2013 17:54:48 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 11/23/2013 05:30 PM, Sylwester Nawrocki wrote:
>>>>> Hi,
>>>>>
>>>>> On 11/23/2013 12:25 PM, Hans Verkuil wrote:
>>>>>> Hi Wade,
>>>>>>
>>>>>> On 11/22/2013 08:48 PM, Wade Farnsworth wrote:
>>>>>>> Add tracepoints to the QBUF and DQBUF ioctls to enable rudimentary
>>>>>>> performance measurements using standard kernel tracers.
>>>>>>>
>>>>>>> Signed-off-by: Wade Farnsworth<wade_farnsworth@mentor.com>
>>>>>>> ---
>>>>>>>
>>>>>>> This is the update to the RFC patch I posted a few weeks back.  I've added
>>>>>>> several bits of metadata to the tracepoint output per Mauro's suggestion.
>>>>>>
>>>>>> I don't like this. All v4l2 ioctls can already be traced by doing e.g.
>>>>>> echo 1 (or echo 2)>/sys/class/video4linux/video0/debug.
>>>>>>
>>>>>> So this code basically duplicates that functionality. It would be nice to be able
>>>>>> to tie in the existing tracing code (v4l2-ioctl.c) into tracepoints.
>>>>>
>>>>> I think it would be really nice to have this kind of support for standard
>>>>> traces at the v4l2 subsystem. Presumably it could even gradually replace
>>>>> the v4l2 custom debug infrastructure.
>>>>>
>>>>> If I understand things correctly, the current tracing/profiling 
>>>>> infrastructure
>>>>> is much less invasive than inserting printks all over, which may cause 
>>>>> changes
>>>>> in control flow. I doubt the system could be reliably profiled by 
>>>>> enabling all
>>>>> those debug prints.
>>>>>
>>>>> So my vote would be to add support for standard tracers, like in other
>>>>> subsystems in the kernel.
>>>>
>>>> The reason for the current system is to trace which ioctls are called in
>>>> what order by a misbehaving application. It's very useful for that,
>>>> especially when trying to debug user problems.
>>>>
>>>> I don't mind switching to tracepoints as long as this functionality is
>>>> kept one way or another.
>>>
>>> I agree with Sylwester: we should move to tracepoints, and this is a good
>>> start.
>>
>> As I mentioned, I don't mind switching to tracepoints, but not in the way the
>> current patch does it. I certainly don't agree with you merging this patch
>> as-is without further discussion.
> 
> Let's not mix the subjects here. There are two different demands that can be
> either fulfilled by the same solution or by different ones:
> 	1) To have a way to enable debugging all parameters passed from/to
> userspace;
> 	2) To be able to measure the driver (and core) performance while
> streaming.
> 
> This patch's scope is to solve (2), by allowing userspace to hook the two
> ioctls that queues/dequeues streaming buffers.
> 
> With that regards, what's wrong on this patch? I couldn't see anything bad
> there. It is not meant to solve (1).

I have two problems with it: 

1) Right now it is just checking for two ioctls, but as soon as we add more
tracepoints you get another switch on the ioctl command, something I've tried
to avoid by creating the table. So a table-oriented implementation would be
much preferred.

2) It duplicates the already existing code to dump the v4l2_buffer struct.
Is there a way to have just one copy of that? I was hoping Wade could look
into that, and if not, then it is something I can explore (although finding
time is an issue).

Bottom line as far as I am concerned: it was merged while I have outstanding
questions.

If there are good technical reasons why the two problems stated above can't
be easily resolved, then I will reconsider, but for now I think it is too early
to merge. For the record, I don't think I mentioned the first problem in my
original reply, it's something I noticed yesterday while looking at the patch
again.

> 
> Before this patch, all we have is (1), as a non-dynamic printk is too
> intrusive to be used for performance measurement. So, there's no way to
> measure how much time a buffer takes to be filled.

Having tracepoints here doesn't tell you anything about that. At best it gives
you information about the jitter.

How are these tracepoints supposed to be used? What information will they
provide? Are tracepoints expected to be limited to QBUF/DQBUF? Or other
ioctls/fops as well? If so, which ones?

I just have too many questions and I'd like to see some answers before something
like this is merged in the v4l2 core.

Rereading my older replies I see that I wasn't particularly clear about what
my objections to the patch were, for which I apologies.

Nevertheless, I stand by my opinion that this patch needs more discussion.

Wade, I appreciate it if you can give some more insights into how you are
using this and what it gives you.

> In a matter of fact, in the case you didn't noticed, we are already somewhat
> moving to traces, as several drivers are now using dynamic_printk for debug 
> messages, Yet, lots of drivers still use either their own normal
> printk-based debug macros.
> 
> Now, you're proposing to use the same solution for (1) too. 
> 
> Ok, we can go on that direction, but this is a separate issue. Converting
> the v4l2-ioctl to use tracepoints is the easiest part. However, there are
> several things to consider, if we decide to use it for debug purposes:
> 
> a) It will likely require to convert all printks to dynamic ones, as we
> want to have all debug messages serialized.
> 
> Let me explain it better: if some debug messages come via the standard 
> printk mechanism while others come via traces, we loose the capability
> of receiving the messages at the same order that they were produced, and
> it could be harder if not impossible to synchronize them into the right
> order.
> 
> b) It may make sense to write an userspace tool similar to the rasdaemon
> [1] to allow controlling the debug output. That tool directly reads the
> events from the raw tracing queues, formatting the data on userspace and
> hooking only the events that are needed. 
> 
> Currently, the rasdaemon has inside part of the code used by a perf
> tool copied on it (as this code is not inside any library yet). However,
> that code is being prepared to be used as a library. So, it should be
> even easier to write such tool in a near future.
> 
> [1] https://git.fedorahosted.org/cgit/rasdaemon.git/
> 
> c) I don't think that tracepoints are the right mechanism for a post-mortem
> analysis[2]. E. g. if the Kernel crashes, a printk-based mechanism will 
> output something, but I'm not sure if doing the same is possible with traces
> (e. g. forcing the trace messages to go to to tty).
> 
> You should notice that, with the dynamic_printk macros, it is possible to
> compile the Kernel to use normal printk macros for debug macros.
> 
> However, if we convert the ioctl printk's to tracepoints, we may still
> need to have a fallback printk mechanism for ioctl debug messages.
> 
> [2] There are actually some discussions at the RAS mailing lists about
> how to store the tracing data and printk messages on newer hardware that
> offer a non-volatile memory mechanism for that. So, we might actually
> have a post-mortem mechanism for tracepoints in the future, depending on
> the hardware. Yet, not all types of hardware will have such NVRAM.
> 
> Btw, it is possible to use strace to trace all ioctl's. So, the existing
> mechanism is actually a duplicated feature, as userspace already covers it.
> However, in practice, we opted to explicitly duplicate that feature at
> Kernel level, for debugging purposes, because strace doesn't solve (a)
> and (c).
> 
> What I'm saying is that a project to convert the debug facility into
> tracepoints is something that:

That's not what I want to do. What I would like to avoid is duplicating
the code to dump ioctl arguments. Perhaps tracepoints can call a specified
function to dump the arguments? I tried to understand the tracepoint
implementation but I got lost in a maze of macros...

> 	- it is independent of adding some facility for performance 
> 	  measurement (although it may share the same infrastructure);
> 
> 	- it will require lots of effort to change every single driver
> 	  to use dynamic printk's;
> 
> 	- it may require writing a helper tool to enable just the v4l2
> 	  traces and eventually collect them;
> 
> 	- it may require a fallback printk mechanism in order to debug
> 	  kernel panic.
> 
>> To make it official:
>>
>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> If we do tracepoints, then we do it right and for all ioctls, not in this
>> half-baked manner.
>>
>> Please revert.
> 
> Let's not mix things. If this patch is correct and solves for performance
> measurement, I don't see any reason to revert.

It duplicates code for dumping ioctl arguments, I would prefer a table-based
solution if possible and I am not convinced of the usefulness of tracepoints
here for performance measurements (at the very least I'd like to know more
about the use-case and for which ioctls and file operations tracepoints might
be useful).

In other words: this patch needs more discussion. I wouldn't care if this
was in a driver, but for the v4l2 core it's too early to merge.

> Using tracepoints for debug is a separate and independent project.

I agree, but that's not what my concerns are about (and I am not sure
whether a project like that would be desirable/necessary at all).

> Such project require lots of tests to proof that it is a viable solution,
> several discussions and a huge time frame to convert all drivers to use
> tracepoints too, plus some post-mortem debug logic.

Regards,

	Hans


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:22790 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3LKNrC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 08:47:02 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXN00A4BAADFRA0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Dec 2013 08:47:01 -0500 (EST)
Date: Wed, 11 Dec 2013 11:46:54 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Wade Farnsworth <wade_farnsworth@mentor.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l2-dev: Add tracepoints for QBUF and DQBUF
Message-id: <20131211114654.47b62ab3@samsung.com>
In-reply-to: <52A8656B.9030100@xs4all.nl>
References: <52614DB9.8090908@mentor.com> <528FB50C.6060909@mentor.com>
 <529090A9.7030505@xs4all.nl> <5290D826.5080308@gmail.com>
 <5290DDD8.7070305@xs4all.nl> <20131210185359.49f3f020@samsung.com>
 <52A81476.6020207@xs4all.nl> <20131211084451.0e90044a@samsung.com>
 <52A85253.5090101@xs4all.nl> <20131211104455.3f55b19d@samsung.com>
 <52A8656B.9030100@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 11 Dec 2013 14:15:23 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/11/13 13:44, Mauro Carvalho Chehab wrote:
> > Em Wed, 11 Dec 2013 12:53:55 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> Hi Mauro,
> >>
> >> On 12/11/13 11:44, Mauro Carvalho Chehab wrote:
> >>> Hans,
> >>>
> >>> Em Wed, 11 Dec 2013 08:29:58 +0100
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>
> >>>> On 12/10/2013 09:53 PM, Mauro Carvalho Chehab wrote:
> >>>>> Em Sat, 23 Nov 2013 17:54:48 +0100
> >>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>>
> >>>>>> On 11/23/2013 05:30 PM, Sylwester Nawrocki wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> On 11/23/2013 12:25 PM, Hans Verkuil wrote:
> >>>>>>>> Hi Wade,
> >>>>>>>>
> >>>>>>>> On 11/22/2013 08:48 PM, Wade Farnsworth wrote:
> >>>>>>>>> Add tracepoints to the QBUF and DQBUF ioctls to enable rudimentary
> >>>>>>>>> performance measurements using standard kernel tracers.
> >>>>>>>>>
> >>>>>>>>> Signed-off-by: Wade Farnsworth<wade_farnsworth@mentor.com>
> >>>>>>>>> ---
> >>>>>>>>>
> >>>>>>>>> This is the update to the RFC patch I posted a few weeks back.  I've added
> >>>>>>>>> several bits of metadata to the tracepoint output per Mauro's suggestion.
> >>>>>>>>
> >>>>>>>> I don't like this. All v4l2 ioctls can already be traced by doing e.g.
> >>>>>>>> echo 1 (or echo 2)>/sys/class/video4linux/video0/debug.
> >>>>>>>>
> >>>>>>>> So this code basically duplicates that functionality. It would be nice to be able
> >>>>>>>> to tie in the existing tracing code (v4l2-ioctl.c) into tracepoints.
> >>>>>>>
> >>>>>>> I think it would be really nice to have this kind of support for standard
> >>>>>>> traces at the v4l2 subsystem. Presumably it could even gradually replace
> >>>>>>> the v4l2 custom debug infrastructure.
> >>>>>>>
> >>>>>>> If I understand things correctly, the current tracing/profiling 
> >>>>>>> infrastructure
> >>>>>>> is much less invasive than inserting printks all over, which may cause 
> >>>>>>> changes
> >>>>>>> in control flow. I doubt the system could be reliably profiled by 
> >>>>>>> enabling all
> >>>>>>> those debug prints.
> >>>>>>>
> >>>>>>> So my vote would be to add support for standard tracers, like in other
> >>>>>>> subsystems in the kernel.
> >>>>>>
> >>>>>> The reason for the current system is to trace which ioctls are called in
> >>>>>> what order by a misbehaving application. It's very useful for that,
> >>>>>> especially when trying to debug user problems.
> >>>>>>
> >>>>>> I don't mind switching to tracepoints as long as this functionality is
> >>>>>> kept one way or another.
> >>>>>
> >>>>> I agree with Sylwester: we should move to tracepoints, and this is a good
> >>>>> start.
> >>>>
> >>>> As I mentioned, I don't mind switching to tracepoints, but not in the way the
> >>>> current patch does it. I certainly don't agree with you merging this patch
> >>>> as-is without further discussion.
> >>>
> >>> Let's not mix the subjects here. There are two different demands that can be
> >>> either fulfilled by the same solution or by different ones:
> >>> 	1) To have a way to enable debugging all parameters passed from/to
> >>> userspace;
> >>> 	2) To be able to measure the driver (and core) performance while
> >>> streaming.
> >>>
> >>> This patch's scope is to solve (2), by allowing userspace to hook the two
> >>> ioctls that queues/dequeues streaming buffers.
> >>>
> >>> With that regards, what's wrong on this patch? I couldn't see anything bad
> >>> there. It is not meant to solve (1).
> >>
> >> I have two problems with it: 
> >>
> >> 1) Right now it is just checking for two ioctls, but as soon as we add more
> >> tracepoints you get another switch on the ioctl command, something I've tried
> >> to avoid by creating the table. So a table-oriented implementation would be
> >> much preferred.
> > 
> > From performance measurement PoV, I don't see any reason to add it to any
> > other ioctl.
> 
> But perhaps this makes sense as well for read() and write()? Possibly poll()?

Could be, but, in this case, it won't be at the ioctl table.

> > Of course if we revisit it and other traces become needed,
> > then we should use a table approach instead.
> > 
> >>
> >> 2) It duplicates the already existing code to dump the v4l2_buffer struct.
> >> Is there a way to have just one copy of that? I was hoping Wade could look
> >> into that, and if not, then it is something I can explore (although finding
> >> time is an issue).
> > 
> > Having implemented tracepoints myself, I'd say that the answer is no.
> > 
> > Let me give you an example.
> > 
> > The ras:aer_event trace is a simple tracepoint that also uses the 
> > __print_flags() macro. It is implemented at include/trace/events/ras.h
> > as:
> > 
> > #define aer_correctable_errors		\
> > 	{BIT(0),	"Receiver Error"},		\
> > 	{BIT(6),	"Bad TLP"},			\
> > 	{BIT(7),	"Bad DLLP"},			\
> > 	{BIT(8),	"RELAY_NUM Rollover"},		\
> > 	{BIT(12),	"Replay Timer Timeout"},	\
> > 	{BIT(13),	"Advisory Non-Fatal"}
> > 
> > #define aer_uncorrectable_errors		\
> > 	{BIT(4),	"Data Link Protocol"},		\
> > 	{BIT(12),	"Poisoned TLP"},		\
> > 	{BIT(13),	"Flow Control Protocol"},	\
> > 	{BIT(14),	"Completion Timeout"},		\
> > 	{BIT(15),	"Completer Abort"},		\
> > 	{BIT(16),	"Unexpected Completion"},	\
> > 	{BIT(17),	"Receiver Overflow"},		\
> > 	{BIT(18),	"Malformed TLP"},		\
> > 	{BIT(19),	"ECRC"},			\
> > 	{BIT(20),	"Unsupported Request"}
> > 
> > TRACE_EVENT(aer_event,
> > 	TP_PROTO(const char *dev_name,
> > 		 const u32 status,
> > 		 const u8 severity),
> > 
> > 	TP_ARGS(dev_name, status, severity),
> > 
> > 	TP_STRUCT__entry(
> > 		__string(	dev_name,	dev_name	)
> > 		__field(	u32,		status		)
> > 		__field(	u8,		severity	)
> > 	),
> > 
> > 	TP_fast_assign(
> > 		__assign_str(dev_name, dev_name);
> > 		__entry->status		= status;
> > 		__entry->severity	= severity;
> > 	),
> > 
> > 	TP_printk("%s PCIe Bus Error: severity=%s, %s\n",
> > 		__get_str(dev_name),
> > 		__entry->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" :
> > 			__entry->severity == HW_EVENT_ERR_FATAL ?
> > 			"Fatal" : "Uncorrected",
> > 		__entry->severity == HW_EVENT_ERR_CORRECTED ?
> > 		__print_flags(__entry->status, "|", aer_correctable_errors) :
> > 		__print_flags(__entry->status, "|", aer_uncorrectable_errors))
> > 
> > 
> > Tracepoints work by having a binary ringbuffer where the data at TP_STRUCT
> > is passed. In this case, it passes a string, an u32 and an u8.
> > 
> > The TP_printk() macro actually produces a format filenode, describing
> > each field that would be filled in the ringbuffer and how to convert the
> > data structure from binary to text:
> > 
> > # cat /sys/kernel/debug/tracing/events/ras/aer_event/format 
> > name: aer_event
> > ID: 877
> > format:
> > 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> > 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> > 	field:unsigned char common_preempt_count;	offset:3;	size:1;signed:0;
> > 	field:int common_pid;	offset:4;	size:4;	signed:1;
> > 
> > 	field:__data_loc char[] dev_name;	offset:8;	size:4;	signed:1;
> > 	field:u32 status;	offset:12;	size:4;	signed:0;
> > 	field:u8 severity;	offset:16;	size:1;	signed:0;
> > 
> > print fmt: "%s PCIe Bus Error: severity=%s, %s
> > ", __get_str(dev_name), REC->severity == HW_EVENT_ERR_CORRECTED ? "Corrected" : REC->severity == HW_EVENT_ERR_FATAL ? "Fatal" : "Uncorrected", REC->severity == HW_EVENT_ERR_CORRECTED ? __print_flags(REC->status, "|", {(1UL << (0)), "Receiver Error"}, {(1UL << (6)), "Bad TLP"}, {(1UL << (7)), "Bad DLLP"}, {(1UL << (8)), "RELAY_NUM Rollover"}, {(1UL << (12)), "Replay Timer Timeout"}, {(1UL << (13)), "Advisory Non-Fatal"}) : __print_flags(REC->status, "|", {(1UL << (4)), "Data Link Protocol"}, {(1UL << (12)), "Poisoned TLP"}, {(1UL << (13)), "Flow Control Protocol"}, {(1UL << (14)), "Completion Timeout"}, {(1UL << (15)), "Completer Abort"}, {(1UL << (16)), "Unexpected Completion"}, {(1UL << (17)), "Receiver Overflow"}, {(1UL << (18)), "Malformed TLP"}, {(1UL << (19)), "ECRC"}, {(1UL << (20)), "Unsupported Request"})
> > 
> > You can see that _print_flags() actually produced a lot of code inside "print fmt".
> > 
> > When someone reads from /sys/kernel/debug/tracing/trace, the print fmt is
> > handled by the Kernel.
> > 
> > However, when someone uses a performance tool like perf, the binary blobs
> > are read from the per-CPU raw trace filenodes:
> > 	/sys/kernel/debug/tracing/per_cpu/cpu*/trace_pipe_raw
> > 
> > And the "print fmt" line at the format file is actually used as a hint
> > for tracing userspace tool to handle it that can be used or not.
> > For example, at the rasdaemon, I'm overriding all default handlers,
> > using my own handler, as I want to store all events on a sqlite database:
> > 
> > 	https://git.fedorahosted.org/cgit/rasdaemon.git/tree/ras-aer-handler.c
> 
> OK, fair enough. So that code can't be shared. Good to know.
> 
> > 
> >>
> >> Bottom line as far as I am concerned: it was merged while I have outstanding
> >> questions.
> > 
> > Well, only on this email you're letting clear what are your concerns.
> > 
> >> If there are good technical reasons why the two problems stated above can't
> >> be easily resolved, then I will reconsider, but for now I think it is too early
> >> to merge. For the record, I don't think I mentioned the first problem in my
> >> original reply, it's something I noticed yesterday while looking at the patch
> >> again.
> >>
> >>>
> >>> Before this patch, all we have is (1), as a non-dynamic printk is too
> >>> intrusive to be used for performance measurement. So, there's no way to
> >>> measure how much time a buffer takes to be filled.
> >>
> >> Having tracepoints here doesn't tell you anything about that. At best it gives
> >> you information about the jitter.
> >>
> >> How are these tracepoints supposed to be used? What information will they
> >> provide? Are tracepoints expected to be limited to QBUF/DQBUF? Or other
> >> ioctls/fops as well? If so, which ones?
> > 
> > As shown above, a performance tool can add handlers for tracepoint data,
> > allowing to discover, for example, if dequeue occurred on a different order
> > than queue, associating each dequeued buffer to the corresponding queued
> > one, and to measure the time between each queue/dequeue pairs.
> 
> I'm not really convinced about it. Which is why I would like to know a bit more
> how Wade uses it.

I agree that it is good to know where this is used. I think he already
explained it at the version 1 of this patch:
	https://linuxtv.org/patch/20455/

> Also: the tracepoint is placed outside the lock which will make any time
> measurements even less reliable than they already are. Also, putting it
> inside the lock will ensure that the traces are generated in the order
> that they are serialized by the lock. In addition, the error code of the
> ioctl isn't traced either. Perhaps the traces should only be done if
> ret == 0 anyway?

Yeah, we can play with changing its position or eventually calling it twice,
one at the beginning of the handler, and another one after handling it, in
order to allow measuring how much time is spent inside the qbuf/dqbuf
handling.

> Again, please revert, let's wait for some more background information
> from Wade, think about it a bit more over the weekend and revisit it.

As you didn't comment the first patch, sent in Oct, 18, and your comment
for the second one were not clear, I understood that there were no strong
reason for not merging it.

Now I see that I was too quick on merging this patch.

Now that this was already applied, we don't need to rush reverting it,
as we are not close to submit it upstream, and it shouldn't cause any
issue for the ones not using those tracepoints.

If we don't reach any consensus, we can always drop it just before the
merge window.

Yet, having it applied allows a broader range of users to do some tests, 
helping to improve it or eventually to come to the conclusion that it
is useless.

So, I'm opting to keep it for now. I'll review this decision before
the start of the next merge window.

Regards,
Mauro

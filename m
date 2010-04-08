Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46622 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab0DHLXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 07:23:10 -0400
Date: Thu, 8 Apr 2010 13:23:05 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC2] Teach drivers/media/IR/ir-raw-event.c to use durations
Message-ID: <20100408112305.GA2803@hardeman.nu>
References: <20100407201835.GA8438@hardeman.nu>
 <4BBD6550.6030000@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BBD6550.6030000@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 08, 2010 at 02:10:40AM -0300, Mauro Carvalho Chehab wrote:
> David Härdeman wrote:
> > 
> > o The RX decoding is now handled via a workqueue (I can break that up into a
> >   separate patch later, but I think it helps the discussion to have it in for
> >   now), with inspiration from Andy's code.
> 
> I'm in doubt about that. the workqueue is called just after an event. this means
> that, just after every IRQ trigger (assuming the worse case), the workqueue will 
> be called.

No

> On the previous code, it is drivers responsibility to call the function that 
> de-queue. On saa7134, I've scheduled it to wake after 15 ms. So, instead of
> 32 wakeups, just one is done, and the additional delay introduced by it is not
> enough to disturb the user.

It's still the case with my patch, the ir_raw_event_handle() function is 
still there and it will call schedule_work().

>> o int's are still used to represent pulse/space durations in ms.
>>   Mauro and I seem to disagree on this one but I'm right :)
> 
> :)
> 
> We both have different opinions on that. I didn't hear a good argument from you
> why your're right and I am wrong ;)
> 
> Maybe we can try to make a deal on it.
> 
> What you're really doing is:
> 
> struct rc_event {
> 	u32	mark : 1;
> 	u32	duration :31;	/* in microsseconds */
> };
> 
> Please, correct me if I'm wrong, but I suspect that the technical reasons behind your
> proposal are:
> 	1) to save space at kfifo and argument exchange with the functions;
> 	2) nanoseconds is too short for a carrier at the order of 10^4 
> 	Hz;
> 
> My proposal is to do something like:
> 
> struct rc_event {
> 	enum rc_event_type type;
> 	u64 duration		/* in nanoseconds */
> 
> My rationale are:
> 	1) To make the decoder code less obfuscated;

Subjective

> 	2) To use the same time measurement as used on kernel timers, avoiding an uneeded division
> for IRQ and polling-based devices.

Are you sure you don't want to rewrite ir_raw_event_store_edge() and 
ir_raw_event_store() in assembly?
> 
> It might have some other non-technical issues, like foo/bar uses this/that, this means less changes
> on some code, etc, but we shouldn't consider those non-technical issues when discussing
> the architecture.
> 
> So, here's the deal:
>
> 
> Let's do something in-between. While I still think that using a different measure for
> duration will add an unnecessary runtime conversion from kernel ktime into
> microsseconds, for me, the most important point is to avoid obfuscating the code.
> 
> So, we can define a opaque type:
> 
> typedef u32 mark_duration_t;
> 
> To represent the rc_event struct (this isn't a number anymore - it is a struct with one
> bit for mark/space and 31 bits for unsigned duration). The use of an opaque type may
> avoid people to do common mistakes.

I've seldom seen a case where a "typedef gobbledygook" is considered 
clearer than a native data type.

> And use some macros to convert from this type, like:
> 		
> #define DURATION(mark_duration)	abs(mark_duration)
> #define MARK(duration)	(abs(duration))
> #define SPACE(duration)	(-abs(duration))
> #define IS_MARK(mark_duration)	((duration > 0) ? 1 : 0)
> #define IS_SPACE(mark_duration)	((duration < 0) ? 1 : 0)
> #define DURATION(mark_duration)	abs(mark_duration)
> #define TO_UNITS(mark_duration, unit)	\
> 	do { \
> 		a = DIV_ROUND_CLOSEST(DURATION(mark_duration), unit); \
> 		a = (mark_duration < 0) ? -a: a; \
> 	} while (0)
> 
> And use it along the decoders:

If you think a couple of defines would make it that much clearer, I can 
add some defines. If the division in ktime_us_delta() worries you that 
much, I can avoid it as well.

So how about:

s64 duration; /* signed to represent pulse/space, in ns */

This is the return value from ktime subtraction, so no conversion 
necessary. Then I'll also add defines along your lines.

New patch coming up...

-- 
David Härdeman

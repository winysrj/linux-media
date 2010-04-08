Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DHLuw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 07:50:52 -0400
Message-ID: <4BBDC318.4040709@infradead.org>
Date: Thu, 08 Apr 2010 08:50:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC2] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100407201835.GA8438@hardeman.nu> <4BBD6550.6030000@infradead.org> <20100408112305.GA2803@hardeman.nu>
In-Reply-To: <20100408112305.GA2803@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

David Härdeman wrote:
> On Thu, Apr 08, 2010 at 02:10:40AM -0300, Mauro Carvalho Chehab wrote:
>> David Härdeman wrote:
>>> o The RX decoding is now handled via a workqueue (I can break that up into a
>>>   separate patch later, but I think it helps the discussion to have it in for
>>>   now), with inspiration from Andy's code.
>> I'm in doubt about that. the workqueue is called just after an event. this means
>> that, just after every IRQ trigger (assuming the worse case), the workqueue will 
>> be called.
> 
> No
> 
>> On the previous code, it is drivers responsibility to call the function that 
>> de-queue. On saa7134, I've scheduled it to wake after 15 ms. So, instead of
>> 32 wakeups, just one is done, and the additional delay introduced by it is not
>> enough to disturb the user.
> 
> It's still the case with my patch, the ir_raw_event_handle() function is 
> still there and it will call schedule_work().

OK!

>>> o int's are still used to represent pulse/space durations in ms.
>>>   Mauro and I seem to disagree on this one but I'm right :)
>> :)
>>
>> We both have different opinions on that. I didn't hear a good argument from you
>> why your're right and I am wrong ;)
>>
>> Maybe we can try to make a deal on it.
>>
>> What you're really doing is:
>>
>> struct rc_event {
>> 	u32	mark : 1;
>> 	u32	duration :31;	/* in microsseconds */
>> };
>>
>> Please, correct me if I'm wrong, but I suspect that the technical reasons behind your
>> proposal are:
>> 	1) to save space at kfifo and argument exchange with the functions;
>> 	2) nanoseconds is too short for a carrier at the order of 10^4 
>> 	Hz;
>>
>> My proposal is to do something like:
>>
>> struct rc_event {
>> 	enum rc_event_type type;
>> 	u64 duration		/* in nanoseconds */
>>
>> My rationale are:
>> 	1) To make the decoder code less obfuscated;
> 
> Subjective
> 
>> 	2) To use the same time measurement as used on kernel timers, avoiding an uneeded division
>> for IRQ and polling-based devices.
> 
> Are you sure you don't want to rewrite ir_raw_event_store_edge() and 
> ir_raw_event_store() in assembly?

I want to take just the opposite direction ;) By reading the decoders on the first patch
you submitted me in priv, I remembered the time I used to program in assembler, back on
eigties. On that time, there programming magazines used to put a challenge requesting for
the smallest/fastest (and trickiest) code to solve a problem ;) Of course, nobody, author
included, were capable of understanding those codes after a few weeks, without spending
a few hours to get the tricks.

What I'm trying to say is that those protocol demods are tricky enough 
to require a lot of time to understand what the code is really doing. 
As understanding the code is a requirement for reviewers and for bug fixes, 
we should make life easier, by find the better way to implement the logic that
will help the decoder understanding.

>> It might have some other non-technical issues, like foo/bar uses this/that, this means less changes
>> on some code, etc, but we shouldn't consider those non-technical issues when discussing
>> the architecture.
>>
>> So, here's the deal:
>>
>>
>> Let's do something in-between. While I still think that using a different measure for
>> duration will add an unnecessary runtime conversion from kernel ktime into
>> microsseconds, for me, the most important point is to avoid obfuscating the code.
>>
>> So, we can define a opaque type:
>>
>> typedef u32 mark_duration_t;
>>
>> To represent the rc_event struct (this isn't a number anymore - it is a struct with one
>> bit for mark/space and 31 bits for unsigned duration). The use of an opaque type may
>> avoid people to do common mistakes.
> 
> I've seldom seen a case where a "typedef gobbledygook" is considered 
> clearer than a native data type.
> 
>> And use some macros to convert from this type, like:
>> 		
>> #define DURATION(mark_duration)	abs(mark_duration)
>> #define MARK(duration)	(abs(duration))
>> #define SPACE(duration)	(-abs(duration))
>> #define IS_MARK(mark_duration)	((duration > 0) ? 1 : 0)
>> #define IS_SPACE(mark_duration)	((duration < 0) ? 1 : 0)
>> #define DURATION(mark_duration)	abs(mark_duration)
>> #define TO_UNITS(mark_duration, unit)	\
>> 	do { \
>> 		a = DIV_ROUND_CLOSEST(DURATION(mark_duration), unit); \
>> 		a = (mark_duration < 0) ? -a: a; \
>> 	} while (0)
>>
>> And use it along the decoders:
> 
> If you think a couple of defines would make it that much clearer, I can 
> add some defines. If the division in ktime_us_delta() worries you that 
> much, I can avoid it as well.
> 
> So how about:
> 
> s64 duration; /* signed to represent pulse/space, in ns */
> 
> This is the return value from ktime subtraction, so no conversion 
> necessary. Then I'll also add defines along your lines.

Ok.
> 
> New patch coming up...

Ah, I just forgot to comment those lines (sorry, too tired yesterday):

>-	size = sizeof(struct ir_raw_event) * MAX_IR_EVENT_SIZE * 2;
>-	size = roundup_pow_of_two(size);
>+	ir->raw->input_dev = input_dev;
>+	INIT_WORK(&ir->raw->rx_work, ir_raw_event_work);
> 
>-	rc = kfifo_alloc(&ir->raw->kfifo, size, GFP_KERNEL);
>+	rc = kfifo_alloc(&ir->raw->kfifo, sizeof(int) * MAX_IR_EVENT_SIZE,
>+			 GFP_KERNEL);

kfifo logic requires a power of two buffer to work, so, please keep the
original roundup_pow_of_two() logic, or add a comment before MAX_IR_EVENT_SIZE.

-- 

Cheers,
Mauro

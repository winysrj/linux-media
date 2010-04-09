Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:46956 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab0DIPOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 11:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <4BBF3309.6020909@infradead.org>
References: <20100408113910.GA17104@hardeman.nu>
	 <1270812351.3764.66.camel@palomino.walls.org>
	 <s2o9e4733911004090531we8ff39b4r570e32fdafa04204@mail.gmail.com>
	 <4BBF3309.6020909@infradead.org>
Date: Fri, 9 Apr 2010 11:14:03 -0400
Message-ID: <p2o9e4733911004090814gd4869e27g5f154babf26a403b@mail.gmail.com>
Subject: Re: [RFC3] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andy Walls <awalls@md.metrocast.net>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 9, 2010 at 10:00 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Jon Smirl wrote:
>>>>
>>>> +/* macros for ir decoders */
>>>> +#define PULSE(units)                         ((units))
>>>> +#define SPACE(units)                         (-(units))
>>> Encoding pulse vs space with a negative sign, even if now hidden with
>>> macros, is still just using a sign instead of a boolean.  Memory in
>>> modern computers (and now microcontrollers) is cheap and only getting
>>> cheaper.  Don't give up readability, flexibility, or mainatainability,
>>> for the sake of saving memory.
>
> That was my point since the beginning: the amount of saved memory doesn't
> justify the lack of readability. I understand such constraints when using
> a hardware implementation on a microcontroller chip that offers just a very
> few limited registers and a very small or no RAM. Also, if you define it with
> something like:
>
> struct {
>        unsigned mark : 1;
>        unsigned duration :31;
> }
>
> There's no memory spend at all: it will use just one unsigned int and it is
> clearly indicated what's mark and what's duration.
>
>> I agree with this. I did it with signed ints in my first version, then
>> ripped it out and switched to duration + boolean. The duration/boolean
>> pair was much easier to understand. This is a matter of style, both
>> schemes work.
>
> Yes. It shouldn't be hard to convert the code to better represent the type/duration
> vector in the future. Actually, that's one of the things i took into consideration
> when accepting the patch: the code readability were not seriously compromised with
> the usage of the macros, and, if needed, a patch converting it to a structured type
> wouldn't be hard.
>
>>>>  #endif /* _IR_CORE */
>>>> Index: ir/drivers/media/IR/ir-nec-decoder.c
>>>> ===================================================================
>>>> --- ir.orig/drivers/media/IR/ir-nec-decoder.c 2010-04-08 12:30:28.000000000 +0200
>>>> +++ ir/drivers/media/IR/ir-nec-decoder.c      2010-04-08 12:35:02.276484204 +0200
>>>> @@ -13,15 +13,16 @@
>>>>   */
>>>>
>>>>  #include <media/ir-core.h>
>>>> +#include <linux/bitrev.h>
>>>>
>>>>  #define NEC_NBITS            32
>>>> -#define NEC_UNIT             559979 /* ns */
>>>> -#define NEC_HEADER_MARK              (16 * NEC_UNIT)
>>>> -#define NEC_HEADER_SPACE     (8 * NEC_UNIT)
>>>> -#define NEC_REPEAT_SPACE     (4 * NEC_UNIT)
>>>> -#define NEC_MARK             (NEC_UNIT)
>>>> -#define NEC_0_SPACE          (NEC_UNIT)
>>>> -#define NEC_1_SPACE          (3 * NEC_UNIT)
>>>> +#define NEC_UNIT             562500  /* ns */
>>> Have you got a spec on the NEC protocol that justifies 562.5 usec?
>>>
>>> >From the best I can tell from the sources I have read and some deductive
>>> reasoning, 560 usec is the actual number.  Here's one:
>>>
>>>        http://www.audiodevelopers.com/temp/Remote_Controls.ppt
>>>
>>> Note:
>>>        560 usec * 38 kHz ~= 4192/197
>>
>> In the PPT you reference there are three numbers...
>> http://www.sbprojects.com/knowledge/ir/nec.htm
>>
>> 560us
>> 1.12ms
>> 2.25ms
>>
>> I think those are rounding errors.
>>
>> 562.5 * 2 = 1.125ms * 2 = 2.25ms
>>
>> Most IR protocols are related in a power of two pattern for their
>> timings to make them easy to decode.
>>
>> The protocol doesn't appear to be based on an even number of 38Khz cycles.
>> These are easy things to change as we get better data on the protocols.
>
> I don't think that the actual number really matters much. The decoders are
> reliable enough to work with such small differences. I suspect that, in

I found that the ratios between the numbers are the critical item, not
the numbers themselves.

The absolute numbers are used to differentiate the protocol families.
The total length of the messages is also important in differentiating
the families.

The protocol decoders should reconcile the total message length as
another check to make sure they aren't triggering on a message in the
wrong protocol. Add up the durations of everything seen and see if it
is within 5-10% of the expected message length.


> practice, hardware developers just use a close frequency that can be divided
> by some existing XTAL clock already available at the machines. In the case of
> video devices, most of them use a 27 MHz clock. If divided by 711, this gives
> a clock of 37.974 kHz, and the closest timings are 579 us and 605 us.
>
> So, in practical, I think we'll see much more devices using 579 us than
> 560 us or 562 us.
>
>>> and that the three numbers that yield ~560 usec don't evenly divide each
>>> other:
>>>
>>>        $ factor 4192 197 38000
>>>        4192: 2 2 2 2 2 131
>>>        197: 197
>>>        38000: 2 2 2 2 5 5 5 19
>>>
>>> which strikes me as being done on purpose (maybe only by me?).
>>>
>>> Also note that:
>>>
>>>        4192 / 38 kHz = 110.32 usec
>>>
>>> and public sources list 110 usec as the NEC repeat period.
>>>
>>>
>>>> +#define NEC_HEADER_PULSE     PULSE(16)
>>>> +#define NEC_HEADER_SPACE     SPACE(8)
>>>> +#define NEC_REPEAT_SPACE     SPACE(4)
>>>> +#define NEC_BIT_PULSE                PULSE(1)
>>>> +#define NEC_BIT_0_SPACE              SPACE(1)
>>>> +#define NEC_BIT_1_SPACE              SPACE(3)
>>> This is slightly better than your previous patch, but the original
>>> #defines were still clearer.  A maintainer coming through has to spend
>>> time and energy on asking "16 what?" for example.
>
> The units can be expressed as a comment:
>
> #define NEC_BIT_PULSE                PULSE(1)   /* nec units */
>
> A patch like that is welcome.
>
> --
>
> Cheers,
> Mauro
>



-- 
Jon Smirl
jonsmirl@gmail.com

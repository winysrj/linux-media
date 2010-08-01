Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54284 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab0HAOAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 10:00:06 -0400
MIME-Version: 1.0
In-Reply-To: <BU0Ob6WojFB@christoph>
References: <AANLkTikRBupAsSSk5QmudHrpEccMSOjmK2bT+xg8CocK@mail.gmail.com>
	<BU0Ob6WojFB@christoph>
Date: Sun, 1 Aug 2010 10:00:05 -0400
Message-ID: <AANLkTi=c4pNtjPQ9OYL-uxXFFnPUJStUjU26TgpzpL+a@mail.gmail.com>
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable
	it.
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@md.metrocast.net, jarod@wilsonet.com,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, maximlevitsky@gmail.com,
	mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 1, 2010 at 5:50 AM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Hi Jon,
>
> on 31 Jul 10 at 14:14, Jon Smirl wrote:
>> On Sat, Jul 31, 2010 at 1:47 PM, Christoph Bartelmus <lirc@bartelmus.de>
>> wrote:
>>> Hi Jon,
>>>
>>> on 31 Jul 10 at 12:25, Jon Smirl wrote:
>>>> On Sat, Jul 31, 2010 at 11:12 AM, Andy Walls <awalls@md.metrocast.net>
>>>> wrote:
>>>>> I think you won't be able to fix the problem conclusively either way.  A
>>>>> lot of how the chip's clocks should be programmed depends on how the
>>>>> GPIOs are used and what crystal is used.
>>>>>
>>>>> I suspect many designers will use some reference design layout from ENE,
>>>>> but it won't be good in every case.  The wire-up of the ENE of various
>>>>> motherboards is likely something you'll have to live with as unknowns.
>>>>>
>>>>> This is a case where looser tolerances in the in kernel decoders could
>>>>> reduce this driver's complexity and/or get rid of arbitrary fudge
>>>>> factors in the driver.
>>>
>>>> The tolerances are as loose as they can be. The NEC protocol uses
>>>> pulses that are 4% longer than JVC. The decoders allow errors up to 2%
>>>> (50% of 4%).  The crystals used in electronics are accurate to
>>>> 0.0001%+.
>>>
>>> But the standard IR receivers are far from being accurate enough to allow
>>> tolerance windows of only 2%.
>>> I'm surprised that this works for you. LIRC uses a standard tolerance of
>>> 30% / 100 us and even this is not enough sometimes.
>>>
>>> For the NEC protocol one signal consists of 22 individual pulses at 38kHz..
>>> If the receiver just misses one pulse, you already have an error of 1/22
>>>> 4%.
>
>> There are different types of errors. The decoders can take large
>> variations in bit times. The problem is with cumulative errors. In
>> this case the error had accumulated up to 450us in the lead pulse.
>> That's just too big of an error and caused the JVC code to be
>> misclassified as NEC.
>>
>> I think he said lirc was misclassifying it too. So we both did the same
>> thing.
>
> No way. JVC is a 16 bit code. NEC uses 32 bits. How can you ever confuse
> JVC with NEC signals?
>
> LIRC will work if there is a 4% or 40% or 400% error. Because irrecord
> generates the config file using your receiver it will compensate for any

At the end of the process we can build a record and match raw mode if
we have to.

> timing error. It will work with pulses cut down to 50 us like IrDA
> hardware does and it will work when half of the bits are swallowed like
> the IgorPlug USB receiver does.

The code for fixing IrDA and IgorPLug should live inside their low
level device drivers.  The characteristics of the errors produced by
this hardware are known so a fix can be written to compensate.  The
IgorPlug people might find it easier to fix their firmware. You don't
have to get the timing exactly right for the protocol engines to work,
you just need to get the big systematic errors out.

Before doing raw the low level IR drivers should be fixed to provide
the most accurate data possible. I don't think it is good design for a
low level driver to be injecting systematic errors and then have the
next layer of code remove them.  The source of the systematic errors
should be characterized and fixed in the low level driver. That also
allows the fixed to be constrained to fixing data from only a single
receiver type.

I have been burnt twice in the past from fixing errors in a low level
driver higher in the stack. I have learned the hard way that it is a
bad thing to do. As the fixes accumulate in the higher layers you will
reach a point where they conflict and no solution is possible. Bugs in
the low level drivers need to be fixed in that driver.

Show me a case that can't be fixed in the low level driver and we can
explore the options.

>
> But of course the driver should try to generate timings as accurate as
> possible.
>
> Christoph
>



-- 
Jon Smirl
jonsmirl@gmail.com

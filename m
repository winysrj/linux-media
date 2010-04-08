Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40223 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab0DHNG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 09:06:59 -0400
Message-ID: <4BBDD4ED.5040007@infradead.org>
Date: Thu, 08 Apr 2010 10:06:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC2] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100407201835.GA8438@hardeman.nu>	 <4BBD6550.6030000@infradead.org> <r2l9e4733911004080541s58fd4e70o215800426290a09a@mail.gmail.com>
In-Reply-To: <r2l9e4733911004080541s58fd4e70o215800426290a09a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
> On Thu, Apr 8, 2010 at 1:10 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> David Härdeman wrote:
>>> drivers/media/IR/ir-raw-event.c is currently written with the assumption
>>> that all "raw" hardware will generate events only on state change (i.e.
>>> when a pulse or space starts).
>>>
>>> However, some hardware (like mceusb, probably the most popular IR receiver
>>> out there) only generates duration data (and that data is buffered so using
>>> any kind of timing on the data is futile).
>>>
>>> Furthermore, using signed int's to represent pulse/space durations in ms
>>> is a well-known approach to anyone with experience in writing ir decoders.
>>>
>>> This patch (which has been tested this time) is still a RFC on my proposed
>>> interface changes.
>>>
>>> Changes since last version:
>>>
>>> o RC5x and NECx support no longer added in patch (separate patches to follow)
>>>
>>> o The use of a kfifo has been left given feedback from Jon, Andy, Mauro
>> Ok.
>>
>>> o The RX decoding is now handled via a workqueue (I can break that up into a
>>>   separate patch later, but I think it helps the discussion to have it in for
>>>   now), with inspiration from Andy's code.
>> I'm in doubt about that. the workqueue is called just after an event. this means
>> that, just after every IRQ trigger (assuming the worse case), the workqueue will
>> be called.
>>
>> On the previous code, it is drivers responsibility to call the function that
>> de-queue. On saa7134, I've scheduled it to wake after 15 ms. So, instead of
>> 32 wakeups, just one is done, and the additional delay introduced by it is not
>> enough to disturb the user.
> 
> The wakeup is variable when the default thread is used. My quad core
> desktop wakes up on every pulse. My embedded system wakes up about
> every 15 pulses. The embedded system called schedule_work() fifteen
> times from the IRQ, but the kernel collapsed them into a single
> wakeup. I'd stick with the default thread and let the kernel get
> around to processing IR whenever it has some time.

Makes sense.

> A workqueue has to be used at some point in the system. The input
> subsystem calls that send messages to user space can't be called from
> interrupt context.  I believe in handing off to the workqueue as soon
> as possible for IR signals.

I'm ok on using a workqueue for it.
> 
> Keep this code in the core to simplify writing the drivers. My GPIO
> timer driver example is very simple.
> 
> If you're worried about performance, none of this code matters. What
> is more important is localizing memory accesses to avoid processor
> cache misses. A cache miss can equal 1000 divides.

Agreed.


-- 

Cheers,
Mauro

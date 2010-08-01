Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:56687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0HAJvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 05:51:39 -0400
Date: 01 Aug 2010 11:50:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@md.metrocast.net
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: maximlevitsky@gmail.com
Cc: mchehab@redhat.com
Message-ID: <BU0Ob6WojFB@christoph>
In-Reply-To: <AANLkTikRBupAsSSk5QmudHrpEccMSOjmK2bT+xg8CocK@mail.gmail.com>
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable  it.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

on 31 Jul 10 at 14:14, Jon Smirl wrote:
> On Sat, Jul 31, 2010 at 1:47 PM, Christoph Bartelmus <lirc@bartelmus.de>
> wrote:
>> Hi Jon,
>>
>> on 31 Jul 10 at 12:25, Jon Smirl wrote:
>>> On Sat, Jul 31, 2010 at 11:12 AM, Andy Walls <awalls@md.metrocast.net>
>>> wrote:
>>>> I think you won't be able to fix the problem conclusively either way.  A
>>>> lot of how the chip's clocks should be programmed depends on how the
>>>> GPIOs are used and what crystal is used.
>>>>
>>>> I suspect many designers will use some reference design layout from ENE,
>>>> but it won't be good in every case.  The wire-up of the ENE of various
>>>> motherboards is likely something you'll have to live with as unknowns.
>>>>
>>>> This is a case where looser tolerances in the in kernel decoders could
>>>> reduce this driver's complexity and/or get rid of arbitrary fudge
>>>> factors in the driver.
>>
>>> The tolerances are as loose as they can be. The NEC protocol uses
>>> pulses that are 4% longer than JVC. The decoders allow errors up to 2%
>>> (50% of 4%).  The crystals used in electronics are accurate to
>>> 0.0001%+.
>>
>> But the standard IR receivers are far from being accurate enough to allow
>> tolerance windows of only 2%.
>> I'm surprised that this works for you. LIRC uses a standard tolerance of
>> 30% / 100 us and even this is not enough sometimes.
>>
>> For the NEC protocol one signal consists of 22 individual pulses at 38kHz..
>> If the receiver just misses one pulse, you already have an error of 1/22
>>> 4%.

> There are different types of errors. The decoders can take large
> variations in bit times. The problem is with cumulative errors. In
> this case the error had accumulated up to 450us in the lead pulse.
> That's just too big of an error and caused the JVC code to be
> misclassified as NEC.
>
> I think he said lirc was misclassifying it too. So we both did the same
> thing.

No way. JVC is a 16 bit code. NEC uses 32 bits. How can you ever confuse  
JVC with NEC signals?

LIRC will work if there is a 4% or 40% or 400% error. Because irrecord  
generates the config file using your receiver it will compensate for any  
timing error. It will work with pulses cut down to 50 us like IrDA  
hardware does and it will work when half of the bits are swollowed like  
the IgorPlug USB receiver does.

But of course the driver should try to generate timings as accurate as  
possible.

Christoph

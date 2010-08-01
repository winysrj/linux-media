Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0HAJv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 05:51:27 -0400
Date: 01 Aug 2010 11:43:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@md.metrocast.net
Cc: jarod@wilsonet.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: maximlevitsky@gmail.com
Cc: mchehab@redhat.com
Message-ID: <BU0OY67ZjFB@christoph>
In-Reply-To: <AANLkTi=tZaSGp3V8+4FHupzegmVrgM4-dzJb-y8YazOh@mail.gmail.com>
Subject: Re: [PATCH 13/13] IR: Port ene driver to new IR subsystem and enable  it.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

on 31 Jul 10 at 17:53, Jon Smirl wrote:
> On Sat, Jul 31, 2010 at 2:51 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Sat, 2010-07-31 at 14:14 -0400, Jon Smirl wrote:
>>> On Sat, Jul 31, 2010 at 1:47 PM, Christoph Bartelmus <lirc@bartelmus.de>
>>> wrote:
>>>> Hi Jon,
>>>>
>>>> on 31 Jul 10 at 12:25, Jon Smirl wrote:
>>>>> On Sat, Jul 31, 2010 at 11:12 AM, Andy Walls <awalls@md.metrocast.net>
>>>>> wrote:
>>>>>> I think you won't be able to fix the problem conclusively either way..
>>>>>>  A lot of how the chip's clocks should be programmed depends on how the
>>>>>> GPIOs are used and what crystal is used.
>>>>>>
>>>>>> I suspect many designers will use some reference design layout from
>>>>>> ENE, but it won't be good in every case.  The wire-up of the ENE of
>>>>>> various motherboards is likely something you'll have to live with as
>>>>>> unknowns.
>>>>>>
>>>>>> This is a case where looser tolerances in the in kernel decoders could
>>>>>> reduce this driver's complexity and/or get rid of arbitrary fudge
>>>>>> factors in the driver.
>>>>
>>>>> The tolerances are as loose as they can be. The NEC protocol uses
>>>>> pulses that are 4% longer than JVC. The decoders allow errors up to 2%
>>>>> (50% of 4%).  The crystals used in electronics are accurate to
>>>>> 0.0001%+.
>>>>
>>>> But the standard IR receivers are far from being accurate enough to allow
>>>> tolerance windows of only 2%.
>>>> I'm surprised that this works for you. LIRC uses a standard tolerance of
>>>> 30% / 100 us and even this is not enough sometimes.
>>>>
>>>> For the NEC protocol one signal consists of 22 individual pulses at
>>>> 38kHz. If the receiver just misses one pulse, you already have an error
>>>> of 1/22
>>>>> 4%.
>>>
>>> There are different types of errors. The decoders can take large
>>> variations in bit times. The problem is with cumulative errors. In
>>> this case the error had accumulated up to 450us in the lead pulse.
>>> That's just too big of an error
>>
>> Hi Jon,
>>
>> Hmmm.  Leader marks are, by protocol design, there to give time for the
>> receiver's AGC to settle.  We should make it OK to miss somewhat large
>> portions of leader marks.  I'm not sure what the harm is in accepting
>> too long of a leader mark, but I'm pretty sure a leader mark that is too
>> long will always be due to systematic error and not noise errors.
>>
>> However, if we know we have systematic errors caused by unknowns, we
>> should be designing and implementing a decoding system that reasonably
>> deals with those systematic errors.  Again the part of the system almost
>> completely out of our control is the remote controls, and we *have no
>> control* over systematic errors introduced by remotes.

> We haven't encountered remotes with systematic errors. If remotes had
> large errors in them they wouldn't be able to reliably control their
> target devices. Find a remote that won't work with the protocol
> engines and a reasonably accurate receiver.

>>
>> Obviously we want to reduce or eliminate systematic errors by
>> determining the unknowns and undoing their effects or by compensating
>> for their overall effect.  But in the case of the ENE receiver driver,
>> you didn't seem to like the Maxim's software compensation for the
>> systematic receiver errors.

> I would be happier if we could track down the source of the error
> instead of sticking a bandaid on at the end of the process.

>>> and caused the JVC code to be
>>> misclassified as NEC.
>>
>> I still have not heard why we need protocol discrimination/classifcation
>> in the kernel.  Doing discrimination between two protocols with such
>> close timings is whose requirement again?

> If we don't do protocol engines we have to revert back to raw
> recording and having everyone train the system with their remotes. The
> goal is to eliminate the training step. We would also have to have
> large files (LIRC configs) for building the keymaps and a new API to
> deal with them. With the engines the key presses are identified by
> short strings.

Only 437 of 3486 config files on lirc.org use raw mode (probably what you  
mean with large files). Many of them are recorded with an very old  
irrecord version. Current versions of irrecord wouldn't create a raw mode  
config file for these remotes.

> A use case: install mythtv, add an IR receiver. Myth UI says to set
> your universal remote to a Motorola DVR profile. Remote works - no
> training step needed.

+ Myth UI reconfigures lircd with an existing Motorola DVR config file.
Where's the difference?

> LIRC has protocol engines too. irrecord first tries to fit the remote
> into a protocol engine.

With the sublte difference to your approach that LIRC does not make any  
assumptions on any timings in contrast to hardcoded values in the kernel.

> If it can't it reverts to raw mode. Let's
> analyze those cases where lirc ends up in raw mode and see if we can
> figure out what's going wrong.
>
> For example I know of two things that will trip up irrecord that are
> fixed in the kernel system
> 1) the ene driver. we know now it had a 4% error in the reported periods

Wrong.

> 2) Sony remotes - they mix protocols on a single remote.

This is a long known issue. I didn't care to fix it because in practice it  
does not matter.

>> Since these two protocols have such close timings that systematic errors
>> can cause misclassification when using simple mark or space measurements
>> against fixed thresholds, it indicates that a more sophisticated
>> discrimination mechanism would be needed.  Perhaps one that takes multiple
>> successive measurements into account?

> If we get to the point where we need more sophisticated
> classifications we can build it. But are we at that point yet? I'd
> prefer to initially leave everything pretty strict as a way of
> flushing out driver implementation bugs.
>
> Find some remotes and receivers that break the current system.

>>
>> Regards,
>> Andy
>>
>>


Christoph

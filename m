Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:48675 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZBQEMi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 23:12:38 -0500
Message-ID: <499A36CD.4070209@linuxtv.org>
Date: Tue, 17 Feb 2009 05:02:21 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Trent Piepho <xyzzy@speakeasy.org>, e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
Subject: Re: [BUG] changeset 9029 (http://linuxtv.org/hg/v4l-dvb/rev/aa3e5cc1d833)
References: <4986507C.1050609@googlemail.com> <200902151336.17202@orion.escape-edv.de> <Pine.LNX.4.58.0902160811340.24268@shell2.speakeasy.net> <200902170140.53617@orion.escape-edv.de>
In-Reply-To: <200902170140.53617@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss wrote:
> Trent Piepho wrote:
>> On Sun, 15 Feb 2009, Oliver Endriss wrote:
>>> e9hack wrote:
>>>> this change set is wrong. The affected functions cannot be called from an interrupt
>>>> context, because they may process large buffers. In this case, interrupts are disabled for
>>>> a long time. Functions, like dvb_dmx_swfilter_packets(), could be called only from a
>>>> tasklet. This change set does hide some strong design bugs in dm1105.c and au0828-dvb.c.
>>>>
>>>> Please revert this change set and do fix the bugs in dm1105.c and au0828-dvb.c (and other
>>>> files).
>>> @Mauro:
>>>
>>> This changeset _must_ be reverted! It breaks all kernels since 2.6.27
>>> for applications which use DVB and require a low interrupt latency.
>>>
>>> It is a very bad idea to call the demuxer to process data buffers with
>>> interrupts disabled!
>> I agree, this is bad.  The demuxer is far too much work to be done with
>> IRQs off.  IMHO, even doing it under a spin-lock is excessive.  It should
>> be a mutex.  Drivers should use a work-queue to feed the demuxer.
> 
> Agreed, this would be the best solution.
> 
> On the other hand, a workqueue handler would be scheduled later, so you
> need larger buffers in the driver. Some chipsets have very small
> buffers...
> 
> Anway, this would be a major change. All drivers must be carefully
> modified and tested for an extended period.
> 
> Meanwhile I had a look at the changeset, and I do not understand why
> spin_lock_irq... should be required everywhere.
> 
> Afaics a driver may safely call dvb_dmx_swfilter_packets,
> dvb_dmx_swfilter_204 or dvb_dmx_swfilter from process context, tasklet
> or interrupt handler 'as is'.
> 
> @Andreas:
> Could you please explain in more detail what bad things might happen?

To quote myself from the changelog: This fixes a deadlock discovered
by lockdep.

The lock is used in process context (e.g. DMX_START) and might also be
used from interrupt context (e.g. dvb_dmx_swfilter).

>From http://osdir.com/ml/kernel.janitors/2002-08/msg00022.html:

"spin_lock_irq disables local interrupts and then takes the spin_lock.
If you know you're in process context and other users may be in
interrupt context, this is the correct call to make.

spin_lock_irqsave saves local interrupt state into the flags variable,
disables interrupts, then takes the spin_lock.  spin_unlock_irqrestore
restores the local state saved in the flags.  Use this variant if you
don't know whether you're in interrupt or process context."

So, if the assumtions above are correct, then spin_lock_irq must be
used by all functions called from process context and
spin_lock_irqsave must be used by all functions called from an unknown
context.

Regards,
Andreas

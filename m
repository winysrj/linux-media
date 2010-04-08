Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:56633 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab0DHKFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Apr 2010 06:05:32 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] V4L/DVB: saa7146: IRQF_DISABLED causes only trouble
References: <1269202135-340-1-git-send-email-bjorn@mork.no>
	<1269206641.6135.68.camel@palomino.walls.org>
	<87ocigwvrf.fsf@nemi.mork.no>
	<1270634174.3021.176.camel@palomino.walls.org>
Date: Thu, 08 Apr 2010 12:05:15 +0200
In-Reply-To: <1270634174.3021.176.camel@palomino.walls.org> (Andy Walls's
	message of "Wed, 07 Apr 2010 05:56:14 -0400")
Message-ID: <877hoifeec.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ehh...., this is very embarrassing, but please disregard all my
statements about a hanging system related to IRQF_DISABLED.

It turns out that I've had a faulty SATA hard drive which probably have
caused all these problems.  I do not understand the inner workings of
the SATA hardware and software, but it appears that this drive has been
able to block interrupts for a considerable time without SMART detecting
any error at all.  I wrongly suspected saa7146 to be the cause because
these problems appeared after adding the saa7146 hardware.  But that was
probably just a coincidence (or maybe not really, only unrelated: I
suspect that the problem was triggered by the powercycle when adding
this card)

The drive has now been replaced, and I will start verifying that use of
saa7146 with IRQF_DISABLED does not in fact pose any real problems at
all.

I still find the discussion about it's usefulness interesting though...


Andy Walls <awalls@md.metrocast.net> writes:

> Given your /proc/interrupts output, the first handler registered would
> be the pata_jmicron module's irq handler.  So interrupts will be enabled
> when the saa7146 module's irq handler runs.
>
> So this is puzzling to me as to why IRQF_DISABLED for the saa7146 module
> matters at all for your situation.  It should be ignored.

Yes, it probably was ignored.  Sorry for not being able to sort that out
earlier.

>> The discussion about which is correct, always disabled or always
>> enabled, is way out of my league.  But I believe that current drivers
>> have to adapt to the current kernel default, and that is always enabled.
>
> Why do you believe that?

Because any other driver sharing the interrupt otherwise will cause
unpredictable results.  

But your suggestions that one should be able to detect the current state
and make system level policy decision would make that argument void, and
are generally much better solutions.

> For hardware devices which, after a short period of time, overwrite
> their information about what caused the interrupt (i.e. CX23418),
> yielding to another IRQ handler increases the potential for losing
> information (i.e. losing tack of video buffers). 

Sure, I can see that problem.  But you can't avoid it unless you find
some way to ensure that IRQF_DISABLED is enforced.  And today, that
would mean not sharing at all, would it not?

> Really the kernel needs to be smarter about identifying these cases:
>
> 1. an IRQ line where all the drivers request IRQF_DISABLED
> 2. an IRQ line where all the drivers request IRQs remain enabled
> 3. an IRQ line where the drivers have mixed requests
>
> Case 3 is the only case that requires resolution.  It's a system level
> decision that the user should be able to set as to whether he wants one
> type of behavior or the other on that interrupt line.  The kernel can
> never know absolutely what's right for the user in case 3.

Sounds like a solution to me.

And the current warning should be disabled in case 1, as the behaviour
is predictable.  But this means that the kernel also need to be smart
enough to notice both when the case changes from 1 to 3 and from 2 to 3.

>> No, maybe it's not.  But doesn't the fact that you can't predict the
>> actual effect of the IRQF_DISABLED flag tell you that using it is wrong? 
>
> No.  Not being able to reliably predict an outcome, doesn't really speak
> to the correctness of settings that appear to affect the outcome
> (correlation is not causation).

OK.

> I do know that on any particular machine, one should be able to know
> whether IRQF_DISABLED will be ignored or enforced on all IRQ handlers on
> an interrupt line.

Yes, that would be useful.  Like it is now, you have to inspect the
source code and the current driver load order to know the actual state. 



Bjørn

Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:39353 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963Ab0CVJoa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 05:44:30 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] V4L/DVB: saa7146: IRQF_DISABLED causes only trouble
References: <1269202135-340-1-git-send-email-bjorn@mork.no>
	<1269206641.6135.68.camel@palomino.walls.org>
Date: Mon, 22 Mar 2010 10:28:20 +0100
In-Reply-To: <1269206641.6135.68.camel@palomino.walls.org> (Andy Walls's
	message of "Sun, 21 Mar 2010 17:24:01 -0400")
Message-ID: <87ocigwvrf.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls <awalls@radix.net> writes:
> On Sun, 2010-03-21 at 21:08 +0100, Bjørn Mork wrote:
>> As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
>> mixing IRQF_DISABLED with IRQF_SHARED just doesn't make sense.
>> 
>> Remove IRQF_DISABLED to avoid random unexpected behaviour.
>> 
>> Ever since I started using the saa7146 driver, I've had occasional
>> soft lockups.  I do not have any real evidence that the saa7146
>> driver is the cause, but the lockups are gone after removing the
>> IRQF_DISABLED flag from this driver.
>> 
>> On my system, this driver shares an irq17 with the pata_jmicron
>> driver:
>> 
>>  17:       2115      10605    9422844    8193902   IO-APIC-fasteoi   pata_jmicron, saa7146 (0)
>> 
>> This may be a mitigating factor.
>> 
>> Signed-off-by: Bjørn Mork <bjorn@mork.no>
>> Cc: stable@kernel.org
>
> And here are some more recent discussions:
>
> http://lkml.org/lkml/2009/11/30/215
> http://lkml.org/lkml/2009/3/2/33
> http://lkml.org/lkml/2009/3/2/225
> http://www.mail-archive.com/ivtv-devel@ivtvdriver.org/msg06319.html
> http://www.mail-archive.com/ivtv-devel@ivtvdriver.org/msg06362.html
>
> And the ones on the LKML seem prettry inconclusive to me.

OK, I don't really feel up to arguing against any of those.

But the argument seems to be more along the lines of whether the
requirement should be always disabled or always enabled.  Most people
seem to agree that it should be one or the other, and *not* a mix, and
hence that the IRQF_DISABLED should go away (but possibly be replaced by
disabled as default behaviour).

The discussion about which is correct, always disabled or always
enabled, is way out of my league.  But I believe that current drivers
have to adapt to the current kernel default, and that is always enabled.

The patch in http://lkml.org/lkml/2009/3/2/33 might be the correct
solution eventually, but attempting to implement this in a handful
drivers is not going to work.  By using IRQF_DISABLED you are only
triggering the bugs which makes Linus hesitate to take that patch,
in a very random and rather undebuggable way.  That's not good.

To quote one of Linus' followups to http://lkml.org/lkml/2009/3/2/33
(in http://lkml.org/lkml/2009/3/2/186):

"The whole - and only - point is that there are drivers that are _known_ to 
 require non-IRQF_DISABLED semantics. IDE is one such one."



*This* is what makes using IRQF_SHARED || IRQF_DISABLED risky, IMHO.
You can't currently guarantee that you don't share the line with one of
those drivers.


> If the saa7146 driver was registered second, then this change should
> have no effect on your system.
>
> If the saa7146 driver was registered first, then this can cause the
> saa7146 driver's interrupt handler to be interrupted.  I doubt the
> saa7146 driver is prepared for this contingency.
>
> I doubt that this is the "proper" fix for your problem.

No, maybe it's not.  But doesn't the fact that you can't predict the
actual effect of the IRQF_DISABLED flag tell you that using it is wrong? 
Removing it will at least provide a predictable outcome.

The problem you miss above is how the other drivers sharing this
interrupt will deal with the, to them, unexpected occasional disabled
interrupts.  How the heck do you ensure that they can handle it?

I assume the real fix would be to ensure that the saa7146 interrupt
handler can be interrupted.  I have no idea how to to that.  Do you know
why it can't be interrupted?  It doesn't look particularily
uninterruptable to me.  And as you say: It will be interrupted even with
the IRQF_DISABLED flag.

The alternative to making ensure that the saa7146 interrupt handler can
be interrupted is really not keeping IRQF_DISABLED, but
 - making sure that *every* interrupt handler in the kernel can run with
   interrupts disabled, and
 - change the default to running with interrupts disabled

I believe it's easier to modify the saa7146 driver...

> Does the "soft lockup" put an Oops or BUG message in dmesg
> or /var/log/messages? 
>
> What precisely do you mean by "soft lockup"?

I mean CPU cores getting stuck, like:

Mar 20 01:02:56 canardo kernel: [96555.159999] BUG: soft lockup - CPU#0 stuck for 61s! [lmcoretemp:7424]
Mar 20 01:02:56 canardo kernel: [96603.480497] BUG: soft lockup - CPU#1 stuck for 61s! [kswapd0:47]
Mar 20 01:02:56 canardo kernel: [96603.480999] BUG: soft lockup - CPU#2 stuck for 61s! [rndc:9119]
Mar 20 01:02:56 canardo kernel: [96620.659996] BUG: soft lockup - CPU#0 stuck for 61s! [lmcoretemp:7424]
Mar 20 01:02:56 canardo kernel: [96668.976496] BUG: soft lockup - CPU#1 stuck for 61s! [kswapd0:47]
Mar 20 01:02:56 canardo kernel: [96668.976995] BUG: soft lockup - CPU#2 stuck for 61s! [rndc:9119]
Mar 20 01:02:56 canardo kernel: [96686.159997] BUG: soft lockup - CPU#0 stuck for 61s! [lmcoretemp:7424]


As the syslogging is local, you can't really trust syslog's timestamp.
But the kernel timestamps should be accurate.

The incident above started with

Mar 20 01:02:56 canardo kernel: [96513.561007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.577006] DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x0d, val == 0x86, ret == -5)
Mar 20 01:02:56 canardo kernel: [96513.589006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.617006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.645006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.673005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.689006] DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x3d, val == 0x00, ret == -5)
Mar 20 01:02:56 canardo kernel: [96513.701006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.729006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.757006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.785006] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.801005] DVB: TDA10023(0): tda10023_writereg, writereg error (reg == 0x05, val == 0x26, ret == -5)
Mar 20 01:02:56 canardo kernel: [96513.813005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.841007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.869005] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
Mar 20 01:02:56 canardo kernel: [96513.897007] saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer

and a few thousand more of those before:

Mar 20 01:02:56 canardo kernel: [96712.636963] Clocksource tsc unstable (delta = 1700735019709 ns)

Which I believe is pretty weird...

Mar 20 01:02:58 canardo kernel: [96714.968443] Switching to clocksource hpet

OK, consequence of the above.

Mar 20 01:02:58 canardo kernel: [96714.973077] saa7146: unregister extension 'budget_av'.
Mar 20 01:02:58 canardo kernel: [96714.973536] budget_av 0000:05:01.0: PCI INT A disabled

And this seems to be what "solved" the problem.  I don't know why
budget_av was unloaded here.  It was not manual intervention.  Does it
unload itself due to the extensive timeouts?  

Anyway, disabling the IRQ allowed the machine to continue. Unfortunately 
with rather ugly side effects like libata giving up on a few of the
disks and disabling them, but still better than just crashing...

I assume you can argue that this is caused by a bug in some other
driver's interrupt handler.  And you are of course right.  But that bug
is in practice allowed today, due to the fact that the default is
running with interrupts enabled.

Allowing saa7146 to run with interrupts enabled hides that bug for me.



Bjørn

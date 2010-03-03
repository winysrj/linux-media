Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64819 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab0CCBGP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Mar 2010 20:06:15 -0500
Subject: Re: cx18: Unable to find blank work order form to schedule
 incoming mailbox ...
From: Andy Walls <awalls@radix.net>
To: Mark Lord <kernel@teksavvy.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <4B8D2805.4030808@teksavvy.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org>
	 <4B8D2805.4030808@teksavvy.com>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 20:05:43 -0500
Message-Id: <1267578343.3070.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-03-02 at 10:00 -0500, Mark Lord wrote:
> On 03/02/10 07:40, Andy Walls wrote:
> ..
> >>> 3. The work handler kernel thread, cx18-0-in, got killed, if that's
> >>> possible, or the processor it was running on got really bogged down.
> >> ..
> ..
> 
> One thing from the /var/log/messages output:
> 
>     12:55:59 duke kernel: IRQ 18/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
> 
> Which is a result of the code doing this:
> 
>              retval = request_irq(cx->pci_dev->irq, cx18_irq_handler,
>                               IRQF_SHARED | IRQF_DISABLED,
>                               cx->v4l2_dev.name, (void *)cx);

Please read this thread and the LKML threads to which it points:
http://ivtvdriver.org/pipermail/ivtv-devel/2010-January/006416.html


> I'm not at the MythTV box right now, but it is likely that this IRQ
> really is shared with other devices.

That's very common for PCI.  Make sure the linux kernel module's hard
IRQ handler for the other device doesn't do something stupid - like wait
for a really long time, perform linear searches on large data
structures,.etc.


> Does the driver *really* rely upon IRQF_DISABLED (to avoid races in the handler)?

Races aren't the issue here.

And no, the cx18 driver does not *rely* on IRQF_DISABLED.  However, it
makes no sense to yield the processor in the cx18 hard IRQ handling,
during the small time window between the hardware IRQ from the CX23418
and the time CX23418 firmware decides to overwrite the buffer
notification with a new one and we lose the original notification data.
The cx18 driver would end up dropping video buffers for the sake of an
interrupt from a mouse, serial port, disk controller, USB host
controller, etc.  that could have likely waited.  If one's disk
controller or network card's interrupt is more important than one's
CX23418 interrupt, then one can nuke the IRQF_DISABLED flag. But that's
generally not what most people want.

The only place it would make sense for the cx18 IRQ handler to run with
interrupts enabled is on an interrupt bound, uniprocessor system, when
you conciously decide you have device interrupts more improtant than the
video capture card.  That's usually not the setup of people performing
video capture with a CX23418 based card.

> If so, then this could be a good clue.
> If not, then that IRQF_DISABLED should get nuked.

Nope - the cx18 hard IRQ handler is as fast as I could make it. With
multiple streams running, the CX23418 firmware gives us only a very
short time to pick up buffer notifications.  If we don't have
IRQF_DISABLED set, some other interrupt handler, for some other
interrupt line, will cut into the cx18 hard IRQ handler timeline.

A real problem is some other poorly written linux interrupt handler
taking too long for interuupt service of a device sharing the same IRQ
line with the CX23418.  Such an other "slow" interrupt handler can cut
into the short time window in which the cx18 driver must pick up a
buffer notiifcation from the CX23418.


My understanmding is the whole IRQF_SHARED | IRQF_DISABLED problem not
being handled properly by the kernel IRQ handling is labeld as "do not
fix".  So instead we're left with the arguments for particular
situations with no compromise solution:

1. "always run hard IRQ handlers with local interrupts disabled;
handlers shouldn't be slow"

and

2. "I have limited hardware that requires immediate care and feeding or
I'll drop characters or miss packets.  Driver's with lots of hard IRQ
handling delay or low priority should run with interrupts enabled"

and 

3. "I have a brain dead piece of hardware that existed before SMP or
multithreaded processing.  It has to run its handler with local
interrupts (dis-?)enabled."


Regards,
Andy



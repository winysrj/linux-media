Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61066 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZDYBpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 21:45:31 -0400
Subject: Re: Problems with Hauppauge HVR 1600 and cx18 driver
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Cc: Corey Taylor <johnfivealive@yahoo.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	ivtv-users@ivtvdriver.org
In-Reply-To: <de8cad4d0904240528h1a96de0bs16a292673753822f@mail.gmail.com>
References: <164695.77575.qm@web56903.mail.re3.yahoo.com>
	 <1237251478.3303.37.camel@palomino.walls.org>
	 <954486.20343.qm@web56908.mail.re3.yahoo.com>
	 <1237425168.3303.94.camel@palomino.walls.org>
	 <de8cad4d0903220853v4b871e91x7de6efebfb376034@mail.gmail.com>
	 <871136.15243.qm@web56908.mail.re3.yahoo.com>
	 <1238297237.3235.42.camel@palomino.walls.org>
	 <de8cad4d0903290725t2e7764a8pe2c0d1b7d67ea8c4@mail.gmail.com>
	 <de8cad4d0903310302s2df38ba8re605fc0cc3a4f266@mail.gmail.com>
	 <1239679567.3163.85.camel@palomino.walls.org>
	 <de8cad4d0904240528h1a96de0bs16a292673753822f@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 24 Apr 2009 21:42:02 -0400
Message-Id: <1240623722.3230.132.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-04-24 at 08:28 -0400, Brandon Jenkins wrote:
> On Mon, Apr 13, 2009 at 11:26 PM, Andy Walls <awalls@radix.net> wrote:
> > On Tue, 2009-03-31 at 06:02 -0400, Brandon Jenkins wrote:

> > Brandon and Corey,
> >
> > I have a series of changes to improve performance of the cx18 driver in
> > delivering incoming buffers to applications.  Please test the code here
> > if you'd like:
> >
> > http://linuxtv.org/hg/~awalls/cx18-perf/
> >
> > These patches remove all the sleeps from incoming buffer handling
> > (unless your system starts getting very far behind, in which case a
> > fallback strategy starts letting sleeps happen again).


> > The trade-off I had to make with all these patches was to have the
> > cx18-driver prefer to "spin" rather than "sleep" when waiting for a
> > resource (i.e. the capture stream buffer queues), while handling
> > incoming buffers.  This makes the live playback much nicer, but at the
> > expense of CPU cycles and perhaps total system throughput for other
> > things.  I'd be interested in how a multicard multistream capture fares.


> Andy,
> 
> have been running your updated drivers for a couple of days with
> marked improvement.

Good to hear.


>  I am seeing some messages in dmesg (normal?) and I
> have attached it along with lspci, lsusb, and lsmod. The majority of
> our recordings have been making use of the digital connection with OTA
> ATSC.

The messages indicate that the cx18 driver's interrupt handler is not
being called in time to service a CX23418 interrupt for an incoming
capture buffer.  This indicates a latency prbolem in the system.

I also will note that the missed buffers are happening at inervals that
are somewhat far apart: ~1000 seconds, ~400 seconds, ~200 seconds, ~1600
seconds, etc...


1. Since you have a 4 core system that looks to be pretty high-end, I'll
assert the fundamental trade-off I mention above, about the cx18 driver
spinning vs. sleeping when handling incoming buffers in the work
handler, is likely not the cause.

2. Since the cx18_irq_handler() only seems to be called late in the case
of interrupts from cx18-1 and not cx18-0 nor cx18-2, I'll assert that a
driver servicing hardware that shares the interrupt line with cx18-1 is
likely involved.

IRQ 20 is shared by
	cx18-0 at PCI 0000:05:00.0

IRQ 18 is shared by
	cx18-2 at PCI 0000:05:02.0
	usb hub 5 at PCI 0000:00:1a.7 (no usb devices connected) 
	usb hub 8 at PCI 0000:00:1d.2 (no usb devices connected)

IRQ 19 is shared by
	cx18-1 at PCI 
	usb hub 7 at PCI 0000:00:1d.2
		a usb device, Cygnal Systems (microcontroller?), is connected (commandIR?)
	ahci disk controller at PCI 0000:03:00.0 (1? disk connected)
	ahci disk controller at PCI 0000:00:1f.2 (a few disks connected)
		(looks to be using Message Signalled Interrupts at IRQ 2299 though)
	

My hypothesis is that the ahci_interrupt() handler routine in
linux/drivers/ata/achi.c is not acknowledging IRQ 19 in a timely manner
and not finishing up interrupt service rapidly under certain conditions.
And looking at that routine, it does *all* its work first, before
clearing the interrupt line from the AHCI controller.  The
achi_interrupt() routine acquires a spinlock of its own and then some of
the routines it calls can also try to acquire spinlocks.  One can
hypothesize that the achi_interrupt() routine might occasionally take a
long time to complete.

While the ahci_interrupt() handler is doing its work and not clearing
the disk controller interrupt line on IRQ 19 and returning, any CX23418
interrupts on IRQ 19 will go unserviced during that time.  This is how
the cx18 driver could miss an incoming buffer, as the CX23418 won't wait
long for the cx18 driver to pick up the buffer id from the mailbox.



Things you could try:

1. Setting the priority of cx18-1 lower than cx18-0 and cx18-2 when
SageTV has a choice of which card to use for video captures.  Also note
if you ever see the message for cx18-0 or cx18-2 and how often.

2. Record TV programs to a disk other then the one hanging off of that
disk controller at PCI 3:00.0.  That would include temp storage used
during the recording process (e.g. /tmp/... /var/... ).  The goal is to
keep that disk quiescent during captures from cx18-1.

3. Move the disk controller in question to another PCI slot.  See if the
problem leaves the CX23418 on IRQ 19, cx18-1, (and maybe begins to
affect another CX23418 if the disk controller gets IRQ 18 or IRQ 20 as
its new IRQ).

4. Move that one disk to a different disk controller that isn't using
IRQ 18, 19, or 20.

5. Try increasing the PCI latency timer larger than 64 PCI bus clocks on
the PCI bridge which the CX23418 and AHCI disk controller are behind.
That *might* help the ahci_interrupt() handler to finish it's work a
little earlier, and *maybe* mitigate things.  

6. Contact the AHCI driver maintainer and ask him to help you confirm or
refute my hypothesis -- I don't know the most efficient and safest way
to verify my hypothesis by twiddling in the ahci driver.  The ahci.c
file has this info:
 
 *  Maintained by:  Jeff Garzik jgarzik * pobox.com
 *                  Please ALWAYS copy linux-ide@vger.kernel.org
 *                  on emails.




> The system is running Ubuntu Jaunty RC1 9.04 fully patched and kernel
> - Linux sagetv-server 2.6.28-11-server #42-Ubuntu SMP Fri Apr 17
> 02:45:36 UTC 2009 x86_64 GNU/Linux
> 
> I use SageTV for PVR which uses the drivers in 32-bit compatible mode.

This probably doesn't matter.  This is a latency issue from:

   the time the CX23418 asserts its PCI bus interrupt line

to

   the time the cx18 driver's irq handler can read the buffer id
   information from the CX23418 mailbox.

I have thoroughly tweaked the cx18_irq_handler()'s timeline in previous
changesets.  There are literally no improvements to be made in it.

You either have all your CPU's busy (doubtful), or a shared interrupt
line that isn't being serivced quickly by all the device drivers
handling that line.  I can't think of anything else.

Regards,
Andy

> Brandon


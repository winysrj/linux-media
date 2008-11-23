Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mANJ5tTE009380
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 14:05:55 -0500
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mANJ5er7001586
	for <video4linux-list@redhat.com>; Sun, 23 Nov 2008 14:05:41 -0500
From: Andy Walls <awalls@radix.net>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <4BB0779B-E72E-4611-B35E-40977F0FC4CF@tvwhere.com>
References: <1227071437.3117.42.camel@palomino.walls.org>
	<C76A9A84-CC2C-4384-8B4D-5435DD2D3F57@tvwhere.com>
	<1227454285.3105.63.camel@palomino.walls.org>
	<4BB0779B-E72E-4611-B35E-40977F0FC4CF@tvwhere.com>
Content-Type: text/plain
Date: Sun, 23 Nov 2008 14:02:44 -0500
Message-Id: <1227466964.3110.62.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: linux-dvb@linuxtv.org, video4linux-list@redhat.com,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
Subject: Re: [linux-dvb] cx18: Extensive interrupt and buffer handling
	changes need test
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Sun, 2008-11-23 at 10:49 -0500, Brandon Jenkins wrote:
> On Nov 23, 2008, at 10:31 AM, Andy Walls wrote:

> > All in all you're in good shape.  Your system appears to have low  
> > enough
> > interrupt service latency to meet the demands of the firmware.  (At
> > least one ivtv-users list user has a system that is having real  
> > trouble
> > meeting the interrupt service latency timeline of the firmware.  I may
> > have to add a polled mailbox IO mode to the driver for these systems  
> > to
> > use.)
> >
> >
> > Again a lot of this was going on previously, it's just that the cx18
> > driver never bothered to look for it on incoming DMA done  
> > notifications,
> > report the precise condition in the logs, or correct for it very well.
> >
> > Thanks for the testing and providing data!
> >
> > Regards,
> > Andy
> >
> >> Brandon
> >
> >
> Andy,
> 
> A couple of points to note:
> 1)  cx18-2 was the only board making use of analog and hd recordings.  
> The other devices were only performing HD OTA captures.

Brandon,

With simlutaneous streams and that *few* warnings about the firmware
self-acking mailboxes it sends, you really do have a responsive system.

I should emphasize that the driver reading the firmware's self-acked
mailbox can lead to dropped buffers because that the firmware may be in
the process of modifying the mailbox.  In practice, it's rare that the
firmware has actually modified the mailbox by the time the IRQ handler
gets to it - at least in multi-core or lightly loaded machines.  That's
why the cx18 driver has been working acceptably for most users since
it's initial release.

Simultaneous captures makes sense as to why the firmware would be found
more frequently self-acking the mailboxes it sends.  I do not know the
firmware's real, minimum latency requirement for the host driver sending
an ack response to a mailbox.  I do know that having two streams going
at once is going to have the firmware require the minimum latency of the
host driver more frequently.

I got the cx18 top half IRQ handler (cx18_irq_handler() and it's
supporting routines in cx18-mailbox.c) down to around 46-50 usec
execution time from start to finish on my dual core AMD64 machine.
There's not much room for improvement, as most of that 46-50 usec is PCI
MMIO accesses that can't be avoided or sped up.

The kernel will necessarily serialize servicing of the interrupts from a
particular CX23418.  It is conceivable, that the two interrupts from the
CX23418 may be coming in very close together, but that the needed
serialization is putting some delay (e.g. ~ 46-50 usec under some
scenarios) in the timeline of servicing the second one.


> 2)  cx18-2 shares irqs with: ls /proc/irq/18/ cx18-2 ehci_hcd:usb4   
> smp_affinity  spurious  uhci_hcd:usb3  uhci_hcd:usb7. Can I use irq17?  
> nothing seems to be on this.

If those particular USB host adapters aren't busy, then there is not
much point in trying to avoid the sharing AFAIK.  A USB IR dongle would
not be a big deal; a USB disk or USB video capture device that is active
would be a concern.

The only *easy* ways I know to get a PCI card to use a different IRQ
are 

a) move it to a different slot or 
b) try and configure it explicitly in the BIOS.

I've only had success with moving to a physically different slot.


> 3) This is actually a quad core cpu.

Which is probably why you don't need to worry.

The way to get determinism out of any shared resource, like capacity for
processing interrupts, is to use

a) over-provisioning (having more processors to process interrupts from
various devices)

b) QoS (some interrupts have priority over others with a deterministic
priority scheme)

Regards,
Andy


> Thanks,
> 
> Brandon


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

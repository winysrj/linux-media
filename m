Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:55196 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0APUAE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 15:00:04 -0500
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
In-Reply-To: <201001161600.37915.liplianin@me.by>
References: <1263614561.6084.15.camel@palomino.walls.org>
	 <201001161600.37915.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 14:55:52 -0500
Message-Id: <1263671752.3062.19.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-01-16 at 16:00 +0200, Igor M. Liplianin wrote:
> On 16 января 2010 06:02:41 Andy Walls wrote:
> > Hi,
> >
> > I've got reworked changes for the IR for the TeVii S470 and the HVR-1250
> > at
> >
> > 	http://linuxtv.org/hg/~awalls/cx23885-ir2
> >
> > Thanks to loaner HVR-1250 hardware from Devin Heitmueller,
> > I've solved the infinite interrupt problem with the CX23885 AV core and
> > have reworked the change set against the latest v4l-dvb.
> >
> > Please test.
> >
> > Note
> >
> > 1. the parameters for the IR controller setup in
> > linux/drivers/video/cx23885-input.c may need to be tweaked to set the
> > proper "params.modulation" and "params.invert_level" before you get
> > keypresses decoded.
> 
> It works properly with settings
> 
> 	params.modulation = false;
> 	params.invert_level = true;

Thanks.  I have checked in a change the code for this.


> But after couple seconds :(
> 
> cx25840 3-0044: IRQ Status:  tsr rsr rto            
> cx25840 3-0044: IRQ Enables:     rse rte roe
> cx25840 3-0044: rx read:    9046778 ns  mark
> cx25840 3-0044: rx read:    2206333 ns  space
> cx25840 3-0044: rx read:     606926 ns  mark
> cx25840 3-0044: rx read: end of rx
> cx25840 3-0044: IRQ Status:  tsr rsr rto            
> cx25840 3-0044: IRQ Enables:     rse rte roe
> cx25840 3-0044: rx read:    9055815 ns  mark
> cx25840 3-0044: rx read:    2203519 ns  space
> cx25840 3-0044: rx read:     582481 ns  mark
> cx25840 3-0044: rx read: end of rx

This is still good. :)

Those are NEC repeat sequences, but you probably know that already.


> irq 16: nobody cared (try booting with the "irqpoll" option)
> Pid: 2971, comm: X Not tainted 2.6.33-rc4 #3
> Call Trace:
>  [<c1054700>] ? __report_bad_irq+0x24/0x69
[...]
>  [<c1425105>] ? syscall_call+0x7/0xb
> handlers:
> [<c1332132>] (usb_hcd_irq+0x0/0x59)
> [<f8aafd88>] (cx23885_irq+0x0/0x4e0 [cx23885])


I have checked in more changes to 

	http://linuxtv.org/hg/~awalls/cx23885-ir2

Please test again using these module parameters:

	modprobe cx25840 ir_debug=2 debug=2
	modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7


I am looking for logging of the interrupt statuses and enables.  They
should look something like this:


 kernel: cx23885[0]/0: pci_status: 0x08000000  pci_mask: 0x08000001
 [...]
 kernel: cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
 kernel: cx25840 6-0044: AV Core IRQ status (entry): ir        
 kernel: cx25840 6-0044: AV Core ir IRQ status: 0x31 disables: 0x20
 kernel: cx25840 6-0044: IR IRQ Status:  tsr rsr rto            
 kernel: cx25840 6-0044: IR IRQ Enables:     rse rte roe
 kernel: cx25840 6-0044: AV Core audio IRQ status: 0x80 disables: 0xff
 kernel: cx25840 6-0044: AV Core audio MC IRQ status: 0x2000 enables: 0x0000
 kernel: cx25840 6-0044: AV Core video IRQ status: 0x01a7 disables: 0xffff
 kernel: cx25840 6-0044: AV Core IRQ status (exit):           


But I was able to reproduce something like this when changing enable the
TSR interrupt enables using v4l2-dbg to change the register manually:

 kernel: cx23885[0]/0: pci_status: 0x08300000  pci_mask: 0x08000001
 [...]
 kernel: cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
 kernel: cx25840 6-0044: AV Core IRQ status (entry):                           <---- no irq flags (all 0's)
 kernel: cx25840 6-0044: AV Core ir IRQ status: 0x00 disables: 0x00            <---- all 0's
 kernel: cx25840 6-0044: AV Core audio IRQ status: 0x00 disables: 0x00         <---- all 0's
 kernel: cx25840 6-0044: AV Core audio MC IRQ status: 0x0000 enables: 0x0000   <---- all 0's
 kernel: cx25840 6-0044: AV Core video IRQ status: 0x0000 disables: 0x0000     <---- all 0's
 kernel: cx25840 6-0044: AV Core IRQ status (exit):           

So there are some conditions where the AV Core can signal an interrupt,
but not be ready to be read over the I2C bus.

I have added code to count when these happen and handle them as spurious
interrupts.  However, if the code gets too many (20) consecutive
spurious interrupts without at least one real one, it disables the AV
Core interrupt.


Regards,
Andy



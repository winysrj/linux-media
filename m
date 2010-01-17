Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59683 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0AQB2K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 20:28:10 -0500
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
In-Reply-To: <201001162356.07798.liplianin@me.by>
References: <1263614561.6084.15.camel@palomino.walls.org>
	 <201001161600.37915.liplianin@me.by>
	 <1263671752.3062.19.camel@palomino.walls.org>
	 <201001162356.07798.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 20:26:35 -0500
Message-Id: <1263691595.3062.124.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-01-16 at 23:56 +0200, Igor M. Liplianin wrote:
> On 16 января 2010 21:55:52 Andy Walls wrote:
> > > cx25840 3-0044: IRQ Status:  tsr rsr rto
> > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > cx25840 3-0044: rx read:    9046778 ns  mark
> > > cx25840 3-0044: rx read:    2206333 ns  space
> > > cx25840 3-0044: rx read:     606926 ns  mark
> > > cx25840 3-0044: rx read: end of rx
> > > cx25840 3-0044: IRQ Status:  tsr rsr rto
> > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > cx25840 3-0044: rx read:    9055815 ns  mark
> > > cx25840 3-0044: rx read:    2203519 ns  space
> > > cx25840 3-0044: rx read:     582481 ns  mark
> > > cx25840 3-0044: rx read: end of rx
> >
> > This is still good. :)
> >
> > Those are NEC repeat sequences, but you probably know that already.
> Remote works until that point
> 
> >
> > > irq 16: nobody cared (try booting with the "irqpoll" option)
> > > Pid: 2971, comm: X Not tainted 2.6.33-rc4 #3
> > > Call Trace:
> > >  [<c1054700>] ? __report_bad_irq+0x24/0x69
> >
> > [...]
> >
> > >  [<c1425105>] ? syscall_call+0x7/0xb
> > > handlers:
> > > [<c1332132>] (usb_hcd_irq+0x0/0x59)
> > > [<f8aafd88>] (cx23885_irq+0x0/0x4e0 [cx23885])
> >
> > I have checked in more changes to
> >
> > 	http://linuxtv.org/hg/~awalls/cx23885-ir2
> >
> > Please test again using these module parameters:
> >
> > 	modprobe cx25840 ir_debug=2 debug=2
> > 	modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7
> >
> >
> > I am looking for logging of the interrupt statuses and enables.  They
> > should look something like this:
> >
> >
> >  kernel: cx23885[0]/0: pci_status: 0x08000000  pci_mask: 0x08000001
> >  [...]
> >  kernel: cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> >  kernel: cx25840 6-0044: AV Core IRQ status (entry): ir
> >  kernel: cx25840 6-0044: AV Core ir IRQ status: 0x31 disables: 0x20
> >  kernel: cx25840 6-0044: IR IRQ Status:  tsr rsr rto
> >  kernel: cx25840 6-0044: IR IRQ Enables:     rse rte roe
> >  kernel: cx25840 6-0044: AV Core audio IRQ status: 0x80 disables: 0xff
> >  kernel: cx25840 6-0044: AV Core audio MC IRQ status: 0x2000 enables:
> > 0x0000 kernel: cx25840 6-0044: AV Core video IRQ status: 0x01a7 disables:
> > 0xffff kernel: cx25840 6-0044: AV Core IRQ status (exit):
> >
> >
> > But I was able to reproduce something like this when changing enable the
> > TSR interrupt enables using v4l2-dbg to change the register manually:
> >
> >  kernel: cx23885[0]/0: pci_status: 0x08300000  pci_mask: 0x08000001
> >  [...]
> >  kernel: cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> >  kernel: cx25840 6-0044: AV Core IRQ status (entry):                       
> >    <---- no irq flags (all 0's) kernel: cx25840 6-0044: AV Core ir IRQ
> > status: 0x00 disables: 0x00            <---- all 0's kernel: cx25840
> > 6-0044: AV Core audio IRQ status: 0x00 disables: 0x00         <---- all 0's
> > kernel: cx25840 6-0044: AV Core audio MC IRQ status: 0x0000 enables: 0x0000
> >   <---- all 0's kernel: cx25840 6-0044: AV Core video IRQ status: 0x0000
> > disables: 0x0000     <---- all 0's kernel: cx25840 6-0044: AV Core IRQ
> > status (exit):
> >
> > So there are some conditions where the AV Core can signal an interrupt,
> > but not be ready to be read over the I2C bus.
> >
> > I have added code to count when these happen and handle them as spurious
> > interrupts.  However, if the code gets too many (20) consecutive
> > spurious interrupts without at least one real one, it disables the AV
> > Core interrupt.
> >
> >
> > Regards,
> > Andy
> Spurious interrupts counter reaches #20 almost immediately after modprobe.
> There is no time to press a key.
> 
> DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
> cx23885_dev_checkrevision() Hardware revision = 0xb0
> cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfe800000
> cx23885 0000:01:00.0: setting latency timer to 64
> IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> cx23885[0]/0: pci_status: 0x083f4000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> cx25840 3-0044: AV Core IRQ status (entry):           
> cx25840 3-0044: AV Core ir IRQ status: 0x00 disables: 0x00
> cx25840 3-0044: AV Core audio IRQ status: 0x00 disables: 0x00
> cx25840 3-0044: AV Core audio MC IRQ status: 0x0000 enables: 0x0000
> cx25840 3-0044: AV Core video IRQ status: 0x0000 disables: 0x0000
> cx25840 3-0044: AV Core IRQ status (exit):           
> cx23885[0]/0:  consecutive spurious AV Core interrupt #1
> [...]
> cx23885[0]/0: pci_status: 0x08004000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> cx25840 3-0044: AV Core IRQ status (entry):           
> cx25840 3-0044: AV Core ir IRQ status: 0x00 disables: 0x00
> cx25840 3-0044: AV Core audio IRQ status: 0x00 disables: 0x00
> cx25840 3-0044: AV Core audio MC IRQ status: 0x0000 enables: 0x0000
> cx25840 3-0044: AV Core video IRQ status: 0x0000 disables: 0x0000
> cx25840 3-0044: AV Core IRQ status (exit):           
> cx23885[0]/0:  consecutive spurious AV Core interrupt #20
> cx23885[0]: disabling AV Core/IR interrupt: too many spurious interrupts
> input: cx23885 IR (TeVii S470) as /class/input/input24
> Creating IR device irrcv0

OK.  I think I finally have guessed what is going on:

1. The cx23885_irq_handler is called for the AV_CORE when something else
in the cx23885 or cx25840 module is accessing that I2C bus.

2. The I2C bus adapter mutex in the i2c_subsystem stays locked so the
cx23885_irq_handler() and cx25840_irq_handler() cannot read the AV core
registers since the I2C subsystem returns -EINVAL and 0 for the data.

3. The interrupt handler keeps getting called because it never clears
the interrupt condition in the AV Core.

I think I have to do some work in the cx25840 module and the cx23885
module to handle locking of the AV Core I2C client and I2C bus 3.


> I commented out interrupt disabling line in order to get some debug to you. 
> But it occupied gigabytes on hard disk quickly.
> 
> [...]
> cx23885[0]/0:  consecutive spurious AV Core interrupt #95
> cx23885[0]: disabling AV Core/IR interrupt: too many spurious interrupts
> cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> cx25840 3-0044: AV Core IRQ status (entry): ir        
> cx25840 3-0044: AV Core ir IRQ status: 0x31 disables: 0x20
> cx25840 3-0044: IR IRQ Status:  tsr rsr rto            
> cx25840 3-0044: IR IRQ Enables:     rse rte roe
> cx25840 3-0044: AV Core audio IRQ status: 0x80 disables: 0xff
> cx25840 3-0044: AV Core audio MC IRQ status: 0x2000 enables: 0x0000
> cx25840 3-0044: AV Core video IRQ status: 0x01a7 disables: 0xffff
> cx25840 3-0044: AV Core IRQ status (exit):           
> cx23885[0]/0: pci_status: 0x08004000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> cx25840 3-0044: AV Core IRQ status (entry):           
> cx25840 3-0044: AV Core ir IRQ status: 0x20 disables: 0x20
> cx25840 3-0044: AV Core audio IRQ status: 0x80 disables: 0xff
> cx25840 3-0044: AV Core audio MC IRQ status: 0x2000 enables: 0x0000
> cx25840 3-0044: AV Core video IRQ status: 0x01a7 disables: 0xffff
> cx25840 3-0044: AV Core IRQ status (exit):           
> cx23885[0]/0:  consecutive spurious AV Core interrupt #1
> cx25840 3-0044: rx read:    9061000 ns  mark
> cx25840 3-0044: rx read:    2207667 ns  space
> cx25840 3-0044: rx read:     586333 ns  mark
> cx25840 3-0044: rx read: end of rx
> cx23885 0000:01:00.0: NEC IR auto repeat detected
> cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> cx25840 3-0044: AV Core IRQ status (entry):           
> cx25840 3-0044: AV Core ir IRQ status: 0x20 disables: 0x20
> cx25840 3-0044: AV Core audio IRQ status: 0x80 disables: 0xff
> cx25840 3-0044: AV Core audio MC IRQ status: 0x2000 enables: 0x0000
> cx25840 3-0044: AV Core video IRQ status: 0x01a7 disables: 0xffff
> cx25840 3-0044: AV Core IRQ status (exit):           
> cx23885[0]/0:  consecutive spurious AV Core interrupt #2
> cx23885[0]/0: pci_status: 0x08004000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)
> [...]

I'll have to think aboput these....


I'll fix the I2C bus problem first and then come back to this.

Thanks for testing.

Regards,
Andy


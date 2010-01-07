Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:60015 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071Ab0AGApI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2010 19:45:08 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: Andreas Tschirpke <andreas.tschirpke@gmail.com>
Cc: linux-media@vger.kernel.org, "Igor M. Liplianin" <liplianin@me.by>,
	Matthias Fechner <idefix@fechner.net>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
In-Reply-To: <loom.20100106T222113-720@post.gmane.org>
References: <200912120230.36902.liplianin@me.by>
	 <1260579637.1826.4.camel@localhost>
	 <loom.20100106T222113-720@post.gmane.org>
Content-Type: text/plain
Date: Wed, 06 Jan 2010 19:44:11 -0500
Message-Id: <1262825051.3065.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-01-06 at 21:21 +0000, Andreas Tschirpke wrote:
> Andy Walls <awalls <at> radix.net> writes:
> 
> > > > please try again when you have time.
> > > >
> > > > 	# modprobe cx25840 debug=2 ir_debug=2
> > > > 	# modprobe cx23885 debug=7
> I tried to activate my remote using the driver in
> http://linuxtv.org/hg/~awalls/cx23885-ir.
> According to the following dmesg output everything is loaded correctly and the
> ir interface is registered as /dev/input/event5:
> 
> [    9.220413] Linux video capture interface: v2.00
> [    9.432581] cx23885 driver version 0.0.2 loaded
> [    9.433560] ACPI: PCI Interrupt Link [LN0A] enabled at IRQ 19
> [    9.433572]   alloc irq_desc for 19 on node -1
> [    9.433577]   alloc kstat_irqs on node -1
> [    9.433594] cx23885 0000:02:00.0: PCI INT A -> Link[LN0A] -> GSI 19 (level,
> low) -> IRQ 19
> [    9.433746] CORE cx23885[0]: subsystem: d470:9022, board: TeVii S470
> [card=15,autodetected]
> [    9.720071] cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
> [    9.728397] cx25840 3-0044: firmware: requesting v4l-cx23885-avcore-01.fw
> [    9.994115] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
> [    9.995038] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 22
> [    9.995055] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 22 (level,
> low) -> IRQ 22
> [    9.995139] HDA Intel 0000:00:08.0: setting latency timer to 64
> [   10.579145] cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382
> bytes)
> [   10.586817] cx23885_dvb_register() allocating 1 frontend(s)
> [   10.586830] cx23885[0]: cx23885 based dvb card
> [   10.593034] hda_codec: Unknown model for ALC662 rev1, trying auto-probe from
> BIOS...
> [   10.790592] DS3000 chip version: 0.192 attached.
> [   10.790604] DVB: registering new adapter (cx23885[0])
> [   10.790613] DVB: registering adapter 0 frontend 0 (Montage Technology
> DS3000/TS2020)...
> [   10.791219] cx23885_dev_checkrevision() Hardware revision = 0xb0
> [   10.791236] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, latency: 0,
> mmio: 0xfac00000
> [   10.791249] cx23885 0000:02:00.0: setting latency timer to 64
> [   10.791258] IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   10.795358] input: cx23885 IR (TeVii S470) as
> /devices/pci0000:00/0000:00:0c.0/0000:02:00.0/input/input5
> 
> But there is no signal comming from input/event5, regardless of the tools trying
> to access it (lircd, irw, mode2, inputlircd, plain cat, etc.). What else is
> needed to activate the remote with this driver?

I admire your initiaive, however, that code is not working yet.  The
problem is getting AV core IR interrupts from the CX23885 without
getting a constant stream of AV core interrupts that are not realted to
IR.

I just received a loaner HVR-1250 with a CX23885 from Devin a few days
ago.  It doesn't have the external IR hardware, but it has enough
on-chip for me to debug my interrupt problem using the IR loopback.
Once I have the interrupt problem solved, I'll ask Igor, you, and
whomever else to test.

Life is busy right now.  I might not get to looking at it until Sunday.

Regards,
Andy

>  If I enable debug messages by 
> > modprobe cx25840 debug=2 ir_debug=2
> > modprobe cx23885 debug=7
> 
> the dmesg/syslog is flooded with:
> [   75.932848] cx23885[0]/0: [f47e4840/9] wakeup reg=9514 buf=9514
> [   75.937811] cx23885[0]/0: pci_status: 0x00008002  pci_mask: 0x08001f02
> [   75.937839] cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000
> count: 0x0
> [   75.937847] cx23885[0]/0: ts1_status: 0x00000001  ts1_mask: 0x00001111 count:
> 0x252b
> [   75.937856] cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count:
> 0x2ca4d364
> [   75.937881] cx23885[0]/0:  (PCI_MSK_VID_B     0x00000002)
> [   75.937902] cx23885[0]/0:  (RISCI1            0x00000001)
> [   75.937918] cx23885[0]/0: [f47e4000/10] wakeup reg=9515 buf=9515
> [   75.937942] cx23885[0]/0: queue is not empty - append to active
> [   75.937964] cx23885[0]/0: [f47e4840/9] cx23885_buf_queue - append to active
> [   75.938064] cx23885[0]/0: queue is not empty - append to active
> [   75.938087] cx23885[0]/0: [f47e4000/10] cx23885_buf_queue - append to active
> [   75.942878] cx23885[0]/0: pci_status: 0x00008002  pci_mask: 0x08001f02
> [   75.942901] cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000
> count: 0x0
> [   75.942908] cx23885[0]/0: ts1_status: 0x00000001  ts1_mask: 0x00001111 count:
> 0x252c
> [   75.942917] cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count:
> 0x2ca4d364
> [   75.942943] cx23885[0]/0:  (PCI_MSK_VID_B     0x00000002)
> [   75.942949] cx23885[0]/0:  (RISCI1            0x00000001)
> [   75.942961] cx23885[0]/0: [f47e4480/11] wakeup reg=9516 buf=9516
> [   75.943101] cx23885[0]/0: queue is not empty - append to active
> [   75.943112] cx23885[0]/0: [f47e4480/11] cx23885_buf_queue - append to active
> ...
> 
> Any advice where to go from here, what to try?
> Thank you.
> 
> Andreas
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


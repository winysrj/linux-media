Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35467 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872Ab1DJXHa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 19:07:30 -0400
Subject: HVR-1250/CX23885 IR Rx (Re: [PATCH] Fix cx88 remote control input)
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Lawrence Rust <lawrence@softsystem.co.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com>
References: <1302267045.1749.38.camel@gagarin>
	 <AFEB19DA-4FD6-4472-9825-F13A112B0E2A@wilsonet.com>
	 <1302276147.1749.46.camel@gagarin>
	 <B9A35B3D-DC47-4D95-88F5-5453DD3F506C@wilsonet.com>
	 <BANLkTimyT98dabuYsrwLrcm2wQFv2uQB9g@mail.gmail.com>
	 <44DC1ED9-2697-4F92-A81A-CD024C913CCB@wilsonet.com>
	 <BANLkTi=3Gq+8kXm40O55y55O6A6Q4-3g-g@mail.gmail.com>
	 <CDB2A354-8564-447E-99A3-66502E83E4CB@wilsonet.com>
	 <8f1c0f8a-e4cd-4e3b-8ad4-f58212dfd9d4@email.android.com>
	 <099D978B-BC30-4527-870E-85ECEE74501D@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Apr 2011 19:08:15 -0400
Message-ID: <1302476895.2282.12.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-04-09 at 21:39 -0400, Jarod Wilson wrote:

> > Jarod,
> > 
> > The HVR-1850 uses a raw IR receiver in the CX23888 and older
> HVR-1250s use the raw IR receiver in the CX23885.  They both work for
> Rx (I need to tweak the Cx23885 rx watermark though), but I never
> found time to finish Tx (lack of kernel interface when I had time).
> > 
> > If you obtain one of these I can answer any driver questions.
> 
> Quite some time back, I bought an HVR-1800 and an HVR-1250. I know one of
> them came with an mceusb transceiver and remote, as was pretty sure it was
> the 1800. For some reason, I didn't recall the 1250 coming with anything at
> all, but looking at dmesg output for it:
> 
> cx23885 driver version 0.0.2 loaded
> cx23885 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]
> tveeprom 0-0050: Hauppauge model 79001, rev E3D9, serial# 4904656
> tveeprom 0-0050: MAC address is 00:0d:fe:4a:d6:d0
> tveeprom 0-0050: tuner model is Microtune MT2131 (idx 139, type 4)
> tveeprom 0-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
> tveeprom 0-0050: audio processor is CX23885 (idx 39)
> tveeprom 0-0050: decoder processor is CX23885 (idx 33)
> tveeprom 0-0050: has no radio, has IR receiver, has no IR transmitter
> 
> So it seems I do have hardware. However, its one of the two tuner cards in
> my "production" mythtv backend right now, making it a bit hard to do any
> experimenting with. If I can get it out of there, it looks like I just add
> an enable_885_ir=1, and I should be able to poke at it...

Yeah.  Igor's TeVii S470 CX23885 based card had interrupt storms when
enabled, so IR for '885 chips is disabled by default.  To investigate, I
tried to by an HVR-1250 with a CX23885, but instead got an HVR-1275 with
a CX23888.  dandel, on IRC, did a pretty decent job in testing HVR-1250
operation and finding it works, despite climbing kernel
build/development learning curve at the time.


You may also want to set ir_debug=2 for the *cx25840* module, if you
want to see the raw pulse/space measurements in the logs.  The cx25840
module handles the CX23885 IR controller.


When testing, you may want to add pci=nomsi to your kernel comandline.
Unless Igor has submitted his fix to reset some CX23885 hardware on
module unload or reload, CX23885 interrupts won't work right after
unloading and reloading the cx23885 module with MSI enabled. :(


In the cx25840 module you may also want to change the call in
drivers/media/video/cx25840/cx25840-ir.c:

	control_rx_irq_watermark(c, RX_FIFO_HALF_FULL);

to 

	control_rx_irq_watermark(c, RX_FIFO_NOT_EMPTY);

That's a design bug on my part.  The CX23885 IR controller is I2C
connected.  Waiting unitl the RX FIFO is half full risks losing some
pulse measurements.


Regards,
Andy


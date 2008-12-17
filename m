Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1LD4qQ-0007oe-Sj
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 23:26:20 +0100
From: Andy Walls <awalls@radix.net>
To: John Sager <john@sager.me.uk>
In-Reply-To: <494913C4.9060704@sager.me.uk>
References: <494913C4.9060704@sager.me.uk>
Date: Wed, 17 Dec 2008 17:28:20 -0500
Message-Id: <1229552900.3109.24.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: LinuxTV-DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] pci_abort messages from cx88 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Wed, 2008-12-17 at 14:59 +0000, John Sager wrote:
> This seems to have cropped up sporadically on mailing lists and fora,
> with no real resolution indicated. I have just bought a Hauppauge
> WinTV-NOVA-HD-S2 card (recognised as HVR4000(Lite)) which exhibits
> this problem in my system. I'm running Mythbuntu 8.10 on a quad core
> Intel-based system - P35/ICH9 chipset - with the v4l-dvb drivers
> cloned on 16th December. I don't get the problem on first start-up,
> but if I change channels it starts to appear. However it does seem to
> stop sometimes on channel change. I suspect the problem is either some
> kind of race condition between the Intel & Conexant PCI controllers, or
> some kind of missed or wrong step in chip reconfiguration after a channel
> change.
> 
> When this error occurs, the standard behaviour of the code in cx88-mpeg.c
> is to stop the DMA current transfer & then restart the queue. This drops
> data, leading to blocky visuals & sound glitches. As an experiment, I
> changed the test for general errors in cx8802_mpeg_irq() to ignore the
> pci_abort error (change 0x1f0100 to 0x170100), and this completely
> eliminates the dropped data problem. This suggests that the pci transfers
> complete properly and the pci_abort status is a spurious indication.

You've logically leaped too far.  You can only say that the aborted PCI
transfers, if any actually happened, didn't matter to apparent proper
operation of the device in it's current mode of operation.

That said, maybe the best course of action is to ignore PCI aborts when
a capture is ongoing.  It however, may not be the best idea to ignore
such errors when setting up for a capture or controlling I2C device
through the chip.


> I also fixed the mask in the test for cx88_print_irqbits() to stop these
> messages filling up the log (change ~0xff to ~0x800ff).
> 
> It may be worth fixing this in the main code to hide the problem for
> unfortunate users of this & related cards until the real problem is
> found. Unfortunately I doubt I can help there as a detailed knowledge
> of the Conexant PCI interface device is probably required to pursue it.

Maybe not.  Look at the cx18 driver where a similar issue was
confronted.

1) All the PCI MMIO accesses were wrapper-ed  into functions defined in
cx18-io.[ch]

2) All PCI writes were double checked for a proper readback & retried;
PCI reads were checked for being 0xffffffff and retried; and statistics
were collected on how often this happened and what actions
mattered/helped.

3) The read retires were eliminated - they never helped fix anything.
Some of the write retries were modified slightly: some registers will
never readback what you just wrote to them, by the very nature of their
operation (e.g. clearing interrupt masks)

4) The statistics gathering was removed.


A lot of work that toughed almost every file in the driver and was a
real pain to implement.  It was needed for reliable operation of the
device, especially in older systems.

So much for a "software transparent IO bus" that PCI was supposed to be.

Regards,
Andy

> regards,
> 
> John



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from winston.telenet-ops.be ([195.130.137.75])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jo@requestfocus.be>) id 1KXDRR-0003yv-UP
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 13:07:31 +0200
From: Jo Heremans <jo@requestfocus.be>
To: Roger James <roger@beardandsandals.co.uk>
In-Reply-To: <48B06FD3.5050500@beardandsandals.co.uk>
References: <48B06FD3.5050500@beardandsandals.co.uk>
Date: Sun, 24 Aug 2008 13:07:26 +0200
Message-Id: <1219576046.11317.2.camel@pvr>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Has anyone got the CI on a TT 3200 past the	initial
	reset state
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

On Sat, 2008-08-23 at 21:15 +0100, Roger James wrote:
> I asked a similar question this a little whiile ago and got no answer. 
> So I am trying again with a bit more detail and hoping someone somewhere 
> can tell me whether I am wasting my time. I need to find out whether the 
> CI daughter board is broken or this combination has never worked in the 
> budget-ci driver.
> 
> The TT-3200 works fine for DVB scan and capture, but I cannot get the CI 
> to initialise fully. It always times out on the initial reset and gives 
> a "PC card did not respond" message in the kernel log.
> 
> I peppered the driver with extra diagnostics and as far as I can see the 
> initial CI reset process is started. The firmware version is reported as 
> 0xa0 (is this correct?) so an interrupt is expected from the card. This 
> interrupt never occurs. If I poll the card status 
> (ciintf_poll_slot_status) when the reset times out then flags come back 
> as 9 (CAMDETECT|RESET) but it looks like the read_attribute_mem does not 
> give the correct value and returns 0x00 which I assume means that the 
> CAM has not initialised. I have appended the dmesg output to the end of 
> this message.
> 
> If anyone has got this working can you please let me know, so I can swap 
> the CI daughter board for a working one and stop wasting my time debugging.
> 
> Help!
> 
> Roger
> 
> saa7146: register extension 'budget_ci dvb'.
> ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKD] -> GSI 12 (level, 
> low) -> IRQ 12
> saa7146: found saa7146 @ mem e1a28000 (revision 1, irq 12) (0x13c2,0x1019).
> saa7146 (0): dma buffer size 192512
> DVB: registering new adapter (TT-Budget S2-3200 PCI)
> adapter has MAC addr = 00:d0:5c:68:34:04
> input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
> budget_ci: Slot status cf451000 set to NONE 3 fw vers a0
> budget_ci: Slot status cf451000 set to PRESENT
> dvb_ca_en50221_init
> budget_ci: CI interface initialised
> CAMCHANGE IRQ slot:0 change_type:1
> dvb_ca_en50221_thread_wakeup
> dvb_ca_en50221_thread
> budget_ci: Slot status cf451000 set to RESET
> stb0899_attach: Attaching STB0899
> stb6100_attach: Attaching STB6100
> DVB: registering frontend 0 (STB0899 Multistandard)...
> budget_ci: poll status budget_ci cf451000 flags 9 slot_status 4
> budget_ci: read_attribute 0
> dvb_ca adaptor 0: PC card did not respond :( 0x1
> 
> 
> 
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

Roger,

I have the CI adaptor working on the TT S-3200.
I have ubuntu 8.04 with kernel Linux pvr 2.6.24-16-generic
I use the latest multiproto drivers.

Greetz,
Jo



Aug 23 14:20:52 pvr kernel: [   37.779037] saa7146: register extension
'budget_ci dvb'.
Aug 23 14:20:52 pvr kernel: [   37.779088] ACPI: PCI Interrupt
0000:05:01.0[A] -> GSI 19 (level, low) -> IRQ 19
Aug 23 14:20:52 pvr kernel: [   37.779106] saa7146: found saa7146 @ mem
ffffc200008b2000 (revision 1, irq 19) (0x13c2,0x1019).
Aug 23 14:20:52 pvr kernel: [   37.779111] saa7146 (0): dma buffer size
192512
Aug 23 14:20:52 pvr kernel: [   37.779113] DVB: registering new adapter
(TT-Budget S2-3200 PCI)
Aug 23 14:20:52 pvr kernel: [   37.815982] adapter has MAC addr =
00:d0:5c:64:9b:c2
Aug 23 14:20:52 pvr kernel: [   37.816245] input: Budget-CI dvb ir
receiver saa7146 (0)
as /devices/pci0000:00/0000:00:1e.0/0000:05:01.0/input/input6
Aug 23 14:20:52 pvr kernel: [   37.864809] budget_ci: CI interface
initialised
Aug 23 14:20:52 pvr kernel: [   38.212946] stb0899_attach: Attaching
STB0899
Aug 23 14:20:52 pvr kernel: [   38.234440] stb6100_attach: Attaching
STB6100
Aug 23 14:20:52 pvr kernel: [   38.249442] DVB: registering frontend 0
(STB0899 Multistandard)...



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

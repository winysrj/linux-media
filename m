Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1JsQAs-0000wq-Ia
	for linux-dvb@linuxtv.org; Sun, 04 May 2008 00:25:49 +0200
From: Andy Walls <awalls@radix.net>
To: Wayne and Holly <wayneandholly@woosh.co.nz>
In-Reply-To: <000001c8aaac$0a0efb70$fd01a8c0@speedy>
References: <000001c8aaac$0a0efb70$fd01a8c0@speedy>
Date: Sat, 03 May 2008 18:25:37 -0400
Message-Id: <1209853537.9347.45.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Geniatech DVB-S Digistar
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

On Wed, 2008-04-30 at 22:22 +1200, Wayne and Holly wrote:
> Hi there, I was hoping someone could help me with some trouble I am
> having with the subject TV card.  
> The card seems to be  automagically detected fine and kind of works with
> MythTV (it gets good lock and all of the channels are present) but when
> watching live TV on the frontend it struggles.  I will get perfect
> playback for the first couple of seconds before it begins to skip and
> pixelate such that it is completely unwatchable.  It has the appearance
> of the CPU not being fast enough, or perhaps insufficient RAM but I'm
> sure that is not the case (specs at end of email).  If I record using
> the card without watching live TV it copes far better (only a handfull
> of small skips during a half hour recording) which again suggests the
> system isn't powerful enough.
> I also have a Twinhan 1020a installed and it works with no problems
> whatsoever (no skips at all), is there any chance that having the two
> cards installed could be part of the problem?

Maybe, if they now have to share the same PCI bus segments to the CPU
and RAM.


> Below are the lspci and dmesg outputs relevant to the Geniatech:
> 
> 
> >From lspci -vnn
> 
> 01:06.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI
> Video and Audio Decoder [14f1:8800] (rev 05)
>         Subsystem: Conexant Unknown device [14f1:0084]
>         Flags: bus master, medium devsel, latency 20, IRQ 18
>         Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
>         Capabilities: [44] Vital Product Data
>         Capabilities: [4c] Power Management version 2

A latency timer of 20 cycles is pretty low, especially when you consider
the case when this card becomes a bus master, a target is initially
allowed to hold-off for up to 16 cycles if it is not ready.

A latency timer of 20 means this card can only be bus master for 20 PCI
cycles before it must give up the bus.  That allows it to transfer about
(20-2)*4 = 72 bytes at a time.  If no other device is using the bus, it
can immediately grab the bus back, but that won't always be the case.

Use the setpci command line tool to bump this device's latency timer up
to 64 or 80 or 160 (or some other multiple of 8) and see if things
improve.

Also, you could reduce the timer value for cards that have large timer
values (nVidia cards are often set at the maximum of 248).

BTW a PCI bus cycle is 1/33 MHz = 30.3 ns long.  20 cycles is 0.61 usec.
248 cycles is 7.52 usec.

And looking at you second e-mail you sent on this matter I see:

"Latency: 20 (5000ns min, 13750ns max)"

MIN_GRANT is 5000ns, and for the purposes of MIN_GRANT, 8 PCI cycles are
approximated as 250 ns.  5000 ns / 250 ns/8 PCI cycles = 160 PCI cycles
is the minimum grant specified by the vendor for the latency timer for
this device, not 20 PCI cycles.


Regards,
Andy



> 01:06.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video
> and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
>         Subsystem: Conexant Unknown device [14f1:0084]
>         Flags: bus master, medium devsel, latency 64, IRQ 18
>         Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
>         Capabilities: [4c] Power Management version 2
> 
> dmesg
> 
> [   23.416140] cx2388x v4l2 driver version 0.0.6 loaded
> [   23.416597] CORE cx88[0]: subsystem: 14f1:0084, board: Geniatech
> DVB-S [card=52,autodetected]
> [   23.416560] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI
> 18 (level, low) -> IRQ 18
> [   23.565010] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 18,
> latency: 20, mmio: 0xfa000000
> [   23.565063] cx88[0]/0: registered device video0 [v4l2]
> [   23.565082] cx88[0]/0: registered device vbi0
> [   24.076749] cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded
> [   24.904094] cx88[0]/2: cx2388x 8802 Driver Manager
> [   24.904119] ACPI: PCI Interrupt 0000:01:06.2[A] -> Link [APC3] -> GSI
> 18 (level, low) -> IRQ 18
> [   24.904125] PCI: Setting latency timer of device 0000:01:06.2 to 64
> [   24.904131] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 18,
> latency: 64, mmio: 0xf9000000
> [   25.729842] cx2388x dvb driver version 0.0.6 loaded
> [   25.729847] cx8802_register_driver() ->registering driver type=dvb
> access=shared
> [   25.729851] CORE cx88[0]: subsystem: 14f1:0084, board: Geniatech
> DVB-S [card=52]
> [   25.729854] cx88[0]/2: cx2388x based dvb card
> [   25.921210] DVB: registering new adapter (cx88[0]).
> [   25.921216] DVB: registering frontend 1 (Conexant CX24123/CX24109)...
> 
> System specs are:
> 
> Biostar TF7050-M2 motherboard
> AMD BE-2350 CPU
> 4GB DDR2 800 RAM
> 320GB Seagate SATAII HDD (160GB partition)
> Abit Airpace PCIe Wifi (using ndiswrapper)
> Matsushita CW-8123-C Slot DVD (from Apple G4)
> PicoPSU-120-WI-25 DC-DC supply
> IguanaIR USB transceiver
> Twinhan 1020a DVB-S pci card
> Geniatech DVB-S Digistar pci card
> Nvidia proprietry driver using TV-out (not HDMI) on 576i
> Mythbuntu 7.10 (64bit kernel 2.6.22-14-generic)
> Fully updated (not upgraded though)
> Latest LinuxTV drivers
> 
> Anyone have any ideas?  All and any help greatly appreciated.
> 
> Cheers
> Wayne
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

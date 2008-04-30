Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail.woosh.co.nz ([202.74.207.2] helo=mail2.woosh.co.nz)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wayneandholly@woosh.co.nz>) id 1Jr9R7-0007Wb-AB
	for linux-dvb@linuxtv.org; Wed, 30 Apr 2008 12:21:19 +0200
Received: from speedy (203-211-106-230.ue.woosh.co.nz [203.211.106.230]) by
	woosh.co.nz
	(Rockliffe SMTPRA 6.1.22) with ESMTP id <B0116164480@mail2.woosh.co.nz>
	for <linux-dvb@linuxtv.org>; Wed, 30 Apr 2008 22:20:35 +1200
From: "Wayne and Holly" <wayneandholly@woosh.co.nz>
To: <linux-dvb@linuxtv.org>
Date: Wed, 30 Apr 2008 22:22:05 +1200
Message-ID: <000001c8aaac$0a0efb70$fd01a8c0@speedy>
MIME-Version: 1.0
Subject: [linux-dvb] Geniatech DVB-S Digistar
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

Hi there, I was hoping someone could help me with some trouble I am
having with the subject TV card.  
The card seems to be  automagically detected fine and kind of works with
MythTV (it gets good lock and all of the channels are present) but when
watching live TV on the frontend it struggles.  I will get perfect
playback for the first couple of seconds before it begins to skip and
pixelate such that it is completely unwatchable.  It has the appearance
of the CPU not being fast enough, or perhaps insufficient RAM but I'm
sure that is not the case (specs at end of email).  If I record using
the card without watching live TV it copes far better (only a handfull
of small skips during a half hour recording) which again suggests the
system isn't powerful enough.
I also have a Twinhan 1020a installed and it works with no problems
whatsoever (no skips at all), is there any chance that having the two
cards installed could be part of the problem?

Below are the lspci and dmesg outputs relevant to the Geniatech:


>From lspci -vnn

01:06.0 Multimedia video controller [0400]: Conexant CX23880/1/2/3 PCI
Video and Audio Decoder [14f1:8800] (rev 05)
        Subsystem: Conexant Unknown device [14f1:0084]
        Flags: bus master, medium devsel, latency 20, IRQ 18
        Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:06.2 Multimedia controller [0480]: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder [MPEG Port] [14f1:8802] (rev 05)
        Subsystem: Conexant Unknown device [14f1:0084]
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2

dmesg

[   23.416140] cx2388x v4l2 driver version 0.0.6 loaded
[   23.416597] CORE cx88[0]: subsystem: 14f1:0084, board: Geniatech
DVB-S [card=52,autodetected]
[   23.416560] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI
18 (level, low) -> IRQ 18
[   23.565010] cx88[0]/0: found at 0000:01:06.0, rev: 5, irq: 18,
latency: 20, mmio: 0xfa000000
[   23.565063] cx88[0]/0: registered device video0 [v4l2]
[   23.565082] cx88[0]/0: registered device vbi0
[   24.076749] cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded
[   24.904094] cx88[0]/2: cx2388x 8802 Driver Manager
[   24.904119] ACPI: PCI Interrupt 0000:01:06.2[A] -> Link [APC3] -> GSI
18 (level, low) -> IRQ 18
[   24.904125] PCI: Setting latency timer of device 0000:01:06.2 to 64
[   24.904131] cx88[0]/2: found at 0000:01:06.2, rev: 5, irq: 18,
latency: 64, mmio: 0xf9000000
[   25.729842] cx2388x dvb driver version 0.0.6 loaded
[   25.729847] cx8802_register_driver() ->registering driver type=dvb
access=shared
[   25.729851] CORE cx88[0]: subsystem: 14f1:0084, board: Geniatech
DVB-S [card=52]
[   25.729854] cx88[0]/2: cx2388x based dvb card
[   25.921210] DVB: registering new adapter (cx88[0]).
[   25.921216] DVB: registering frontend 1 (Conexant CX24123/CX24109)...

System specs are:

Biostar TF7050-M2 motherboard
AMD BE-2350 CPU
4GB DDR2 800 RAM
320GB Seagate SATAII HDD (160GB partition)
Abit Airpace PCIe Wifi (using ndiswrapper)
Matsushita CW-8123-C Slot DVD (from Apple G4)
PicoPSU-120-WI-25 DC-DC supply
IguanaIR USB transceiver
Twinhan 1020a DVB-S pci card
Geniatech DVB-S Digistar pci card
Nvidia proprietry driver using TV-out (not HDMI) on 576i
Mythbuntu 7.10 (64bit kernel 2.6.22-14-generic)
Fully updated (not upgraded though)
Latest LinuxTV drivers

Anyone have any ideas?  All and any help greatly appreciated.

Cheers
Wayne


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

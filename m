Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57691 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1BOOvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 09:51:05 -0500
Received: by bwz15 with SMTP id 15so507432bwz.19
        for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 06:51:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297735794.2394.88.camel@localhost>
References: <AANLkTik_PcJdKSE1+konisckfb-j05+yaUFuiG+CsRTQ@mail.gmail.com>
	<1297735794.2394.88.camel@localhost>
Date: Tue, 15 Feb 2011 16:23:41 +0200
Message-ID: <AANLkTikcQw8+Xb1zFr75zxuG9P4p14egw=9HeN7kswAN@mail.gmail.com>
Subject: Re: No data from tuner over PCI bridge adapter (Cablestar HD 2 /
 mantis / PEX 8112)
From: Dennis Kurten <dennis.kurten@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Andy, I've tried some of your suggestions, but no luck so far.


On Tue, Feb 15, 2011 at 4:09 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Mon, 2011-02-14 at 13:35 +0200, Dennis Kurten wrote:
>> Hello,
>>
>> This card (technisat cablestar hd 2 dvb-c) works fine when plugged
>> into a native PCI slot.
>> When I try it with a PCI-adapter I intend to use in mITX-builds there
>> doesn't seem
>> to be any data coming in through the tuner. The adapter is a
>> transparent bridge (with a
>> PEX 8112 chip) that goes into a 1xPCIe-slot and gets power through a
>> 4-pin molex.
>>
>> My guess is some kind of dma mapping incompatibility with the mantis
>> driver (s2-liplianin).
>> The card seems to  initialize correctly, but doesn't work when the
>> tuner is put into action
>> (scandvb timeouts, dvbtraffic yields nothing). For the record, I've
>> tested the bridge with a
>> firewire card and that works fine.
>>
>> Kernel is 2.6.32 (+the compiled drivers)
>>
>> lspci for the bridge and the card:
>> --------------------------------------
>> 03:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
>> Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])
>>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0, Cache Line Size: 32 bytes
>          ^^^^^^^^^^
> I can't remember the exact meaning of setting the latency to 0.  IIRC it
> is not actually 0, but allows at least to one data phase (but that may
> not be enough for correct operation):
>                http://www.sierrasales.com/pdfs/PCI-PCI_Bridges_When_Designing.pdf
>
> I would recommend you use setpci to bump this number up to 32, 64, or
> 128 for troubleshooting/testing to ensure the bridge gets a decent
> number of PCI bus clocks on the bus.  The worst thing that could happen
> is the PLX bridge hogs a PCI bus segment while you are testing - no big
> deal.
>


I don't get to change that latency with setpci. Also, since the bridge
is basically
a PCIE card in itself I wonder if it is this or other "sec-latency=32"
that is the
relevant figure. I remember reading somewhere that the latency for a PCIE card
cannot be set with setpci for some MBs.

The second latency can be tweaked, but does not yield anything for 32, 64 or
128. I've also upped the tv card's latency. I'll investigate fine
tuning of the bridge
still (registered at PLX and received an SDK and some diagnostic apps)


>
>>         Bus: primary=03, secondary=04, subordinate=04, sec-latency=32
>>         I/O behind bridge: 0000e000-0000efff
>>         Memory behind bridge: fdd00000-fddfffff
>>         Prefetchable memory behind bridge: fdc00000-fdcfffff
>>         Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>         BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                 PriDiscTmr- SecDiscTmr- DiscTmrStat+ DiscTmrSERREn-
>>         Capabilities: <access denied>
>>         Kernel modules: shpchp
>>
>> 04:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
>> PCI Bridge Controller [Ver 1.0] (rev 01)
>>         Subsystem: Device 1ae4:0002
>>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>> >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
>           ^^^^^^^^
> Well the Twinhan/Mantis device terminated at least one PCI transaction
> it was mastering with a "target abort".  Maybe that is related to the
> bridge latency being set to 0.
>


Unfortunately that flag is also up when the card is working correctly  in a
native PCI slot.


>
>>         Latency: 32 (2000ns min, 63750ns max)
>>         Interrupt: pin A routed to IRQ 16
>>         Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
>                                                ^^^^^^^^^^^^
>
> Heh, I always find it curious when I/O peripherials claim their register
> space is prefetchable (the CX23416 does this as well).  If the chip is
> designed right, it is valid though AFAICT.
>
> You may want to run a separate test with the cache-line size on the
> bridge set to something smaller than 32 using setpci.  I believe powers
> of 2 and the value 0 are allowed.  Transfers will become more
> inefficient with smaller cache-line size, but it may eliminate any
> problems related to conditions required for prefetching.  Worth a try.
>


Tried as far down as zero, no luck I'm afraid.


>
>
> You may also want to look for some BIOS/EFI settings related to
> interrupt routing and emulation.
>


I don't recall much more options than "P'n'P or not" (which I've done
both ways), but I'll have a look in the manual.

The interrupt watch you mentioned in your other post was interesting
since apparently that one is shared.

from /cat/interrupts:
-----------------------
 16:       9751          0   IO-APIC-fasteoi   ahci, nvidia, Mantis

Without doing any dvb stuff they come in at about one per second but
starting a scan increases this number more than ten-fold so something
is definitely going on. Adding "pci-nomsi" to the kernel boot made no
apparent change to interrupt assigning. I'll switch the card to a PCI port
at some point and compare the readings.

Just to be on the safe side I'll also try to measure the electricity being
fed though the molex connector.


Regards,
Dennis


> Regards,
> Andy
>
>
>>         Kernel driver in use: Mantis
>>         Kernel modules: mantis
>>
>> dmesg output with modules loaded:
>> -----------------------------------------
>> Mantis 0000:04:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
>> irq: 16, latency: 32
>>  memory: 0xfdcff000, mmio: 0xffffc900031a0000
>> found a VP-2040 PCI DVB-C device on (04:00.0),
>>     Mantis Rev 1 [1ae4:0002], irq: 16, latency: 32
>>     memory: 0xfdcff000, mmio: 0xffffc900031a0000
>>     MAC Address=[00:08:c9:d0:46:b4]
>> mantis_alloc_buffers (0): DMA=0x1bb90000 cpu=0xffff88001bb90000 size=65536
>> mantis_alloc_buffers (0): RISC=0x1bbec000 cpu=0xffff88001bbec000 size=1000
>> DVB: registering new adapter (Mantis dvb adapter)
>> mantis_frontend_init (0): Probing for CU1216 (DVB-C)
>> TDA10023: i2c-addr = 0x0c, id = 0x7d
>> mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
>> mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
>> DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
>> mantis_ca_init (0): Registering EN50221 device
>> mantis_ca_init (0): Registered EN50221 device
>> mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
>> Registered IR keymap rc-vp2040
>> input: Mantis VP-2040 IR Receiver as /devices/virtual/rc/rc4/input11
>> rc4: Mantis VP-2040 IR Receiver as /devices/virtual/rc/rc4
>> b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded
>> successfully
>>
>>
>> I hear sometimes these bridges are not as transparent as they claim,
>> any pointers on what to look for?
>>
>> Regards,
>> Dennis
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

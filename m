Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1BOIVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 03:21:00 -0500
Received: by fxm20 with SMTP id 20so6106431fxm.19
        for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 00:20:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikbHmbtjEN3Lh3PjnoRioK6=+Nvcgu6E0g0VPUK@mail.gmail.com>
References: <AANLkTik_PcJdKSE1+konisckfb-j05+yaUFuiG+CsRTQ@mail.gmail.com>
	<AANLkTikbHmbtjEN3Lh3PjnoRioK6=+Nvcgu6E0g0VPUK@mail.gmail.com>
Date: Tue, 15 Feb 2011 10:20:58 +0200
Message-ID: <AANLkTi=AmrSNHg_U4=gFbe7Yk5q4s8VY8QB8SVf-9=mN@mail.gmail.com>
Subject: Re: No data from tuner over PCI bridge adapter (Cablestar HD 2 /
 mantis / PEX 8112)
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Dennis Kurten <dennis.kurten@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

oh, i have just noticed your DVB card is for Cable and not for
Satellite, but still it may use 12V PCI interface pins for something
else and not exactly for LNB power as i thought assuming it's DVB-S/S2
DVB card.

On Tue, Feb 15, 2011 at 10:18 AM, Konstantin Dimitrov
<kosio.dimitrov@gmail.com> wrote:
> hi, does your DVB card can get signal lock when it's inserted into the
>  PCI-to-PCIE adapter, because as far as i know most PCI-to-PCIE
> adapters based on PEX 8111/8112 don't provide power to 12V pins of the
> PCI interface, which probably all PCI DVB card use for LNB power. so,
> what i would check if i'm at your position is the LNB power of the
> card as well as if there is no some extensive amount of noise in the
> LNB power when the DVB card is inside PEX 8111/8112 PCI-to-PCIE
> adapter. also, i can give you example from my own experience with an
> "Audiotrak Prodigy HD2" PCI audio card and PEX 8111/8112 based
> PCI-to-PCIE adapters - with one such adapter that don't provide power
> to 12V pins of the PCI interface there is no sound coming out, because
> the amplifier on the card uses power from 12V pins of the PCI
> interface, with another PEX 8111/8112 PCI-to-PCIE adapter that seems
> to provide power to 12V pins there is extensive noise in the sound
> that is coming out, because PCI-to-PCIE adapter doesn't provide good
> power on 12V pins of the PCI interface and thus the noise in the
> audio. also, on some motherboards (with nVidia chipset on my tests)
> there was some problem with how the memory was mapped preventing the
> work of the PCI card when it's inserted into PEX 8111/8112 based
> PCI-to-PCIE adapter. so, it's also helpful to test motherboards with
> different chipset. in any case it's always better to find and use
> native PCI-Express card instead of PEX 8111/8112 PCI-to-PCIE adapter
> and PCI card. anyway, maybe, someone with more hardware engineering
> knowledge then i have, especially if the problem is 12V can find some
> way to fix those cheap PEX 8111/8112 PCI-to-PCIE adapters that are
> floating around, because i'm sure they just sacrifice 12V power to
> lower the BOM cost of the adapter. BTW, i'm sure your firewire card is
> working, because it doesn't use 12V PCI interface pins - it's the same
> with many PCI cards, but all that needs 12V are no-go based on my
> experience.
>
> --konstantin
>
> On Mon, Feb 14, 2011 at 1:35 PM, Dennis Kurten <dennis.kurten@gmail.com> wrote:
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
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 32 bytes
>>        Bus: primary=03, secondary=04, subordinate=04, sec-latency=32
>>        I/O behind bridge: 0000e000-0000efff
>>        Memory behind bridge: fdd00000-fddfffff
>>        Prefetchable memory behind bridge: fdc00000-fdcfffff
>>        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>>>TAbort- <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat+ DiscTmrSERREn-
>>        Capabilities: <access denied>
>>        Kernel modules: shpchp
>>
>> 04:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
>> PCI Bridge Controller [Ver 1.0] (rev 01)
>>        Subsystem: Device 1ae4:0002
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>>>TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
>>        Latency: 32 (2000ns min, 63750ns max)
>>        Interrupt: pin A routed to IRQ 16
>>        Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
>>        Kernel driver in use: Mantis
>>        Kernel modules: mantis
>>
>> dmesg output with modules loaded:
>> -----------------------------------------
>> Mantis 0000:04:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
>> irq: 16, latency: 32
>>  memory: 0xfdcff000, mmio: 0xffffc900031a0000
>> found a VP-2040 PCI DVB-C device on (04:00.0),
>>    Mantis Rev 1 [1ae4:0002], irq: 16, latency: 32
>>    memory: 0xfdcff000, mmio: 0xffffc900031a0000
>>    MAC Address=[00:08:c9:d0:46:b4]
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
>>
>

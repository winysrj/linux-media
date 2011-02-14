Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34257 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1BNLfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 06:35:10 -0500
Received: by bwz15 with SMTP id 15so5360941bwz.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 03:35:09 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Feb 2011 13:35:09 +0200
Message-ID: <AANLkTik_PcJdKSE1+konisckfb-j05+yaUFuiG+CsRTQ@mail.gmail.com>
Subject: No data from tuner over PCI bridge adapter (Cablestar HD 2 / mantis /
 PEX 8112)
From: Dennis Kurten <dennis.kurten@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

This card (technisat cablestar hd 2 dvb-c) works fine when plugged
into a native PCI slot.
When I try it with a PCI-adapter I intend to use in mITX-builds there
doesn't seem
to be any data coming in through the tuner. The adapter is a
transparent bridge (with a
PEX 8112 chip) that goes into a 1xPCIe-slot and gets power through a
4-pin molex.

My guess is some kind of dma mapping incompatibility with the mantis
driver (s2-liplianin).
The card seems to  initialize correctly, but doesn't work when the
tuner is put into action
(scandvb timeouts, dvbtraffic yields nothing). For the record, I've
tested the bridge with a
firewire card and that works fine.

Kernel is 2.6.32 (+the compiled drivers)

lspci for the bridge and the card:
--------------------------------------
03:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI
Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=03, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fdd00000-fddfffff
        Prefetchable memory behind bridge: fdc00000-fdcfffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat+ DiscTmrSERREn-
        Capabilities: <access denied>
        Kernel modules: shpchp

04:00.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0002
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdcff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

dmesg output with modules loaded:
-----------------------------------------
Mantis 0000:04:00.0: PCI INT A -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
irq: 16, latency: 32
 memory: 0xfdcff000, mmio: 0xffffc900031a0000
found a VP-2040 PCI DVB-C device on (04:00.0),
    Mantis Rev 1 [1ae4:0002], irq: 16, latency: 32
    memory: 0xfdcff000, mmio: 0xffffc900031a0000
    MAC Address=[00:08:c9:d0:46:b4]
mantis_alloc_buffers (0): DMA=0x1bb90000 cpu=0xffff88001bb90000 size=65536
mantis_alloc_buffers (0): RISC=0x1bbec000 cpu=0xffff88001bbec000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
TDA10023: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach success
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
Registered IR keymap rc-vp2040
input: Mantis VP-2040 IR Receiver as /devices/virtual/rc/rc4/input11
rc4: Mantis VP-2040 IR Receiver as /devices/virtual/rc/rc4
b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded
successfully


I hear sometimes these bridges are not as transparent as they claim,
any pointers on what to look for?

Regards,
Dennis

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0FXA0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jun 2010 20:26:14 -0400
Received: by fxm10 with SMTP id 10so3529896fxm.19
        for <linux-media@vger.kernel.org>; Wed, 23 Jun 2010 17:26:13 -0700 (PDT)
MIME-Version: 1.0
From: Pascal Hahn <derpassi@gmail.com>
Date: Thu, 24 Jun 2010 02:25:53 +0200
Message-ID: <AANLkTinz5Wvd7XuFIxsMMOV2XUTEXAafRUgXiBMLpEQn@mail.gmail.com>
Subject: CI-Module not working on Technisat Cablestar HD2
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to get the CI module of a Technisat Cablestar HD2 to work
since about a week now. I tried multiple x64 kernelbuilds
(s2-liplianin, straight 2.6.35-rc3 kernel, 2.6.32-22 ubuntu kernel,
2.6.34, .....) and could not get the cam module on the mantis-based
card to work.

After looking into it in detail, it seems that my card is not using
the tda10021 frontend (as outlined in
http://www.linuxtv.org/wiki/index.php/Technisat_CableStar_HD2) but the
tda10023 frontend.

I had a brief look through the code and also tried to use the tda10021
frontend manually but the detection will fail.

My dmesg looks like this:

[   19.821945] IR NEC protocol handler initialized
[   19.832912] IR RC5(x) protocol handler initialized
[   19.835154] IR RC6 protocol handler initialized
[   19.838766] IR JVC protocol handler initialized
[   19.843647] found a VP-2040 PCI DVB-C device on (04:01.0),
[   19.843657] Mantis 0000:04:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   19.843698]     Mantis Rev 1 [1ae4:0002], irq: 16, latency: 64
[   19.843700]     memory: 0x0, mmio: 0xffffc900057ca000
[   19.843917] IR Sony protocol handler initialized
[   19.844666]     MAC Address=[00:08:c9:d0:37:37]
[   19.844677] mantis_alloc_buffers (0): DMA=0x379e0000
cpu=0xffff8800379e0000 size=65536
[   19.844681] mantis_alloc_buffers (0): RISC=0x3799e000
cpu=0xffff88003799e000 size=1000
[   19.844683] DVB: registering new adapter (Mantis DVB adapter)
[   19.873668] r8169 0000:02:00.0: eth0: link up
[   19.873704] r8169 0000:02:00.0: eth0: link up
[   20.213418]   alloc irq_desc for 22 on node -1
[   20.213421]   alloc kstat_irqs on node -1
[   20.213427] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   20.213519]   alloc irq_desc for 45 on node -1
[   20.213521]   alloc kstat_irqs on node -1
[   20.213529] HDA Intel 0000:00:1b.0: irq 45 for MSI/MSI-X
[   20.213553] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   20.393010] hda_codec: ALC887: BIOS auto-probing.
[   20.394885] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input3
[   20.768259] vp2040_frontend_init (0): Probing for CU1216 (DVB-C)
[   20.770271] vp2040_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10023) @ 0x0c
[   20.770273] vp2040_frontend_init (0): Mantis DVB-C Philips CU1216
frontend attach success
[   20.770276] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...


I can't see any of the expected mantis_ca_init but couldn't figure out
in the code where that gets called.


Here's some pci information for the card:
04:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)

lspci -vv -s 04:01.0
04:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0002
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f6fff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

lspci -n -s 04:01.0
04:01.0 0480: 1822:4e35 (rev 01)


I tried the card out in a windows machine and it worked fine
(including the ci / cam module).

Is this a known issue already or is this so far not known?


Let me know if you need more information for this or if I can help
with anything,


Pascal

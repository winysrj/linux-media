Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:35214 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbZCFWif (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 17:38:35 -0500
Received: by bwz26 with SMTP id 26so551587bwz.37
        for <linux-media@vger.kernel.org>; Fri, 06 Mar 2009 14:38:32 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 23:38:30 +0100
Message-ID: <b36f333c0903061438r5b31e790x6a1619d96a89b09d@mail.gmail.com>
Subject: CAM support for Terratec Cinergy C PCI HD CI
From: Marc Schmitt <marc.schmitt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I just bought a
http://www.terratec.net/en/products/Cinergy_C_PCI_HD_CI_1612.html
which reports as follows under Linux:

00:0f.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: TERRATEC Electronic GmbH Device 1178
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at eb408000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
	Kernel modules: mantis

[   16.741186] Mantis 0000:00:0f.0: PCI INT A -> Link[LNKB] -> GSI 5
(level, low) -> IRQ 5
[   16.741228] irq: 5, latency: 32
[   16.741230]  memory: 0xeb408000, mmio: 0xe0852000
[   16.741237] found a VP-2040 PCI DVB-C device on (00:0f.0),
[   16.741241]     Mantis Rev 1 [153b:1178], irq: 5, latency: 32
[   16.741247]     memory: 0xeb408000, mmio: 0xe0852000
[   16.744411]     MAC Address=[00:08:ca:1d:bc:ae]
[   16.744535] mantis_alloc_buffers (0): DMA=0x1eab0000 cpu=0xdeab0000
size=65536
[   16.744551] mantis_alloc_buffers (0): RISC=0x1eb86000
cpu=0xdeb86000 size=1000
[   16.744559] DVB: registering new adapter (Mantis dvb adapter)
[   17.264189] mantis_frontend_init (0): Probing for CU1216 (DVB-C)
[   17.267687] TDA10023: i2c-addr = 0x0c, id = 0x7d
[   17.267695] mantis_frontend_init (0): found Philips CU1216 DVB-C
frontend (TDA10023) @ 0x0c
[   17.267702] mantis_frontend_init (0): Mantis DVB-C Philips CU1216
frontend attach success
[   17.267712] DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
[   17.268183] mantis_ca_init (0): Registering EN50221 device
[   17.319032] mantis_ca_init (0): Registered EN50221 device
[   17.319055] mantis_hif_init (0): Adapter(0) Initializing Mantis
Host Interface

I could not find any posts indicating that CAM support for this card
has been implemented yet and a `gnutv -cammenu` just hangs forever.
The CAM is a Conax 4.00e, btw.

I'm wondering if there is someone working on implementing this and if
I could help somehow by donating such a card to a developer? Would
that help? Please let me know.

Thanks,
    Marc

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33004 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0AEPn1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 10:43:27 -0500
Received: by ewy19 with SMTP id 19so8573100ewy.21
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 07:43:25 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 5 Jan 2010 16:43:25 +0100
Message-ID: <d5cd75471001050743n761e82d9ub5d59689dd4ccd28@mail.gmail.com>
Subject: Terratec Cinergy C PCI HD - different subsystems
From: Hemmelig Konto <minforumkonto@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there

I'm the owner of two Terratec Cinergy C PCI HD cards.

I'm running on vanilla kernel 2.6.32.0 x64 and is using the s2-liblianin driver.

My problem is that the driver only see 1 of my 2 cards.
When I investigate the cards, I see that they have a different
subsystem identifiers : 153b:1178 which works, and 153b.01788 which
doesn't work. There are no visible difference between the card, as far
as I can see.

How do I get the driver to "attach" to both the cards so I can get
both "adapter0" and "adapter1" - today it is only "adapter0" ?

Please help !!!

/Ole W

lspci -vnn output :

06:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:0178]
        Flags: bus master, medium devsel, latency 64, IRQ 16
        Memory at edfff000 (32-bit, prefetchable) [size=4K]
        Kernel modules: mantis

06:01.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd
Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
        Flags: bus master, medium devsel, latency 64, IRQ 17
        Memory at fdffe000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis

dmesg output :

Mantis 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mantis 0000:06:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
irq: 17, latency: 64
 memory: 0xfdffe000, mmio: 0xffffc9001178e000
found a VP-2040 PCI DVB-C device on (06:01.0),
    Mantis Rev 1 [153b:1178], irq: 17, latency: 64
    memory: 0xfdffe000, mmio: 0xffffc9001178e000
    MAC Address=[00:08:ca:1e:88:83]
mantis_alloc_buffers (1): DMA=0x37c60000 cpu=0xffff880037c60000 size=65536
mantis_alloc_buffers (1): RISC=0x37c06000 cpu=0xffff880037c06000 size=1000
DVB: registering new adapter (Mantis dvb adapter)
input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input4
HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:01:00.1: setting latency timer to 64
mantis_frontend_init (1): Probing for CU1216 (DVB-C)
TDA10023: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (1): found Philips CU1216 DVB-C frontend (TDA10023) @ 0x0c
mantis_frontend_init (1): Mantis DVB-C Philips CU1216 frontend attach success
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (1): Registering EN50221 device
mantis_ca_init (1): Registered EN50221 device
mantis_hif_init (1): Adapter(1) Initializing Mantis Host Interface
input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input5
Mantis VP-2040 IR Receiver: unknown key for scancode 0x0000
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=1
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=0

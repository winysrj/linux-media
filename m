Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:50133 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZH3Ka1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2009 06:30:27 -0400
Received: by ewy2 with SMTP id 2so3257975ewy.17
        for <linux-media@vger.kernel.org>; Sun, 30 Aug 2009 03:30:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 30 Aug 2009 12:30:28 +0200
Message-ID: <d39d602e0908300330w248bab70g68379eac7560fe1f@mail.gmail.com>
Subject: hvr1300 problems resuming from hibernation
From: Michael Melchert <michael.melchert@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

starting from linux kernel 2.6.29 kaffeine had trouble
locking on to different DVB channels on a hvr1300.
On 29/08/09 I pulled the mercurial repository and built modules
from those sources. Things are basically OK running under
2.6.30 and 2.6.31-rc7, that's what I tested.
Only problem that I encountered is that the resume from
hibernation doesnt work anymore, though it worked with
the code base included with the kernel 2.6.28.
Here are a couple of lines that the kernel spat out during the
resume:
...
[  173.110290] ACPI: Waking up from system sleep state S4
[  173.111144] pata_amd 0000:00:07.1: restoring config space at offset
0x1 (was 0x2000001, writing 0x2000005)
[  173.111505] sata_sil 0000:01:0b.0: restoring config space at offset
0x1 (was 0x2b00103, writing 0x2b00107)
[  173.122040] ohci1394 0000:01:0c.0: restoring config space at offset
0xf (was 0x4020100, writing 0x4020105)
[  173.122066] ohci1394 0000:01:0c.0: restoring config space at offset
0x3 (was 0x0, writing 0x4010)
[  173.122076] ohci1394 0000:01:0c.0: restoring config space at offset
0x1 (was 0x2100000, writing 0x2100116)
[  173.122145] cx88_audio 0000:02:07.1: restoring config space at
offset 0x1 (was 0x2900116, writing 0x2900112)
[  173.122179] cx88-mpeg driver manager 0000:02:07.2: restoring config
space at offset 0x1 (was 0x2900116, writing 0x2900112)
[  173.122523] boot interrupts on PCI device 0x1022:0x746b already disabled
[  173.122564] Intel ICH 0000:00:07.5: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[  173.124704] ohci_hcd 0000:01:00.0: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  173.145054] ohci_hcd 0000:01:00.1: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[  173.166060] sata_sil 0000:01:0b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[  173.217073] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[f87ff000-f87ff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[  173.281312] ata5.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[  173.281318] ata5.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  173.281424] ata5.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
[  173.282464] ata6.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
[  173.282470] ata6.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  173.288397] ata6.00: configured for UDMA/33
[  173.329029] cx88_audio 0000:02:07.1: PME# disabled
[  173.329037] cx88_audio 0000:02:07.1: PCI INT A -> GSI 26 (level,
low) -> IRQ 26
[  173.329046] cx88-mpeg driver manager 0000:02:07.2: PME# disabled
[  173.329053] cx88-mpeg driver manager 0000:02:07.2: PCI INT A -> GSI
26 (level, low) -> IRQ 26
[  173.329103] tg3 0000:02:09.0: wake-up capability disabled by ACPI
[  173.329108] tg3 0000:02:09.0: PME# disabled
[  173.331312] tg3: eth0: Link is down.
[  173.398520] pci 0000:05:00.0: PME# disabled
[  173.398533] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  173.398543] pci 0000:05:00.1: PME# disabled
[  173.400869] serial 00:07: activated
[  173.401918] ata5.00: configured for UDMA/100
[  173.403320] serial 00:08: activated
[  173.406418] parport_pc 00:0a: activated
[  173.407020] sd 3:0:0:0: [sda] Starting disk
[  173.471058] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[  173.471139] ata2: SATA link down (SStatus 0 SControl 310)
[  173.471168] ata3: SATA link down (SStatus 0 SControl 310)
[  173.471195] ata1: SATA link down (SStatus 0 SControl 310)
[  173.496628] ata4.00: configured for UDMA/100
[  173.510046] sd 4:0:0:0: [sdb] Starting disk
[  173.543276] ata5.00: configured for UDMA/100
[  173.543280] ata5: EH complete
[  173.591968] tda9887 1-0043: i2c i/o error: rc == -6 (should be 4)  <<=== !!
[  173.592537] tuner-simple 1-0061: i2c i/o error: rc == -6 (should be
4) <<=== !!
[  173.592767] PM: Image restored successfully.
...

there seems to be a problem resuming communication on the i2c bus
playing with kaffeine after the resume leads to:
...
[ 2059.937211] cx22702_writereg: error (reg == 0x00, val == 0x02, ret == -6)
[ 2059.948571] cx22702_writereg: error (reg == 0x00, val == 0x00, ret == -6)
[ 2059.949135] cx22702_writereg: error (reg == 0x0b, val == 0x06, ret == -6)
[ 2059.949870] cx22702_writereg: error (reg == 0x09, val == 0x01, ret == -6)
[ 2059.950540] cx22702_writereg: error (reg == 0x0d, val == 0x41, ret == -6)
[ 2059.951104] cx22702_writereg: error (reg == 0x16, val == 0x32, ret == -6)
[ 2059.951827] cx22702_writereg: error (reg == 0x20, val == 0x0a, ret == -6)
[ 2059.952501] cx22702_writereg: error (reg == 0x21, val == 0x17, ret == -6)
[ 2059.953066] cx22702_writereg: error (reg == 0x24, val == 0x3e, ret == -6)
[ 2059.953781] cx22702_writereg: error (reg == 0x26, val == 0xff, ret == -6)
[ 2059.954454] cx22702_writereg: error (reg == 0x27, val == 0x10, ret == -6)
[ 2059.955020] cx22702_writereg: error (reg == 0x28, val == 0x00, ret == -6)
[ 2059.955824] cx22702_writereg: error (reg == 0x29, val == 0x00, ret == -6)
[ 2059.956509] cx22702_writereg: error (reg == 0x2a, val == 0x10, ret == -6)
[ 2059.957077] cx22702_writereg: error (reg == 0x2b, val == 0x00, ret == -6)
[ 2059.957787] cx22702_writereg: error (reg == 0x2c, val == 0x10, ret == -6)
[ 2059.958460] cx22702_writereg: error (reg == 0x2d, val == 0x00, ret == -6)
[ 2059.959025] cx22702_writereg: error (reg == 0x48, val == 0xd4, ret == -6)
[ 2059.959736] cx22702_writereg: error (reg == 0x49, val == 0x56, ret == -6)
[ 2059.960408] cx22702_writereg: error (reg == 0x6b, val == 0x1e, ret == -6)
[ 2059.960960] cx22702_writereg: error (reg == 0xc8, val == 0x02, ret == -6)
[ 2059.961725] cx22702_writereg: error (reg == 0xf9, val == 0x00, ret == -6)
[ 2059.962399] cx22702_writereg: error (reg == 0xfa, val == 0x00, ret == -6)
[ 2059.962951] cx22702_writereg: error (reg == 0xfb, val == 0x00, ret == -6)
[ 2059.963680] cx22702_writereg: error (reg == 0xfc, val == 0x00, ret == -6)
[ 2059.964350] cx22702_writereg: error (reg == 0xfd, val == 0x00, ret == -6)
[ 2059.964980] cx22702_writereg: error (reg == 0xf8, val == 0x02, ret == -6)
[ 2059.965675] cx22702_readreg: readreg error (ret == -6)
[ 2059.966285] cx22702_writereg: error (reg == 0x0d, val == 0x01, ret == -6)
[ 2059.966771] cx22702_readreg: readreg error (ret == -6)
...
tried to figure out what goes on on the cx22702 and it seems to be
re-initialisation
that fails b/c i2c bus craps out.

can somebody comment on that?

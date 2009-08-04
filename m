Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:51815 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbZHDRbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2009 13:31:55 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3])
	by smtpfb1-g21.free.fr (Postfix) with ESMTP id CDCDB2E020
	for <linux-media@vger.kernel.org>; Tue,  4 Aug 2009 19:31:51 +0200 (CEST)
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 6BFC2818083
	for <linux-media@vger.kernel.org>; Tue,  4 Aug 2009 19:30:40 +0200 (CEST)
Received: from localhost (gam14-2-82-230-24-42.fbx.proxad.net [82.230.24.42])
	by smtp3-g21.free.fr (Postfix) with ESMTP id 7F985818057
	for <linux-media@vger.kernel.org>; Tue,  4 Aug 2009 19:30:38 +0200 (CEST)
Date: Tue, 4 Aug 2009 19:30:38 +0200
From: Fabrice DELENTE <fdelente@mail.cpod.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: saa7134 module doesn't load under 64 bit slackware
Message-ID: <20090804173038.GA3167@smtp.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I'm trying the saa7134 module to load on my laptop, but when I modprobe it,
I get this message:

$ modprobe saa7134 i2c_scan=1
Killed

and dmesg gives

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 17
saa7134 0000:05:02.0: PCI INT A -> Link[LNKD] -> GSI 17 (level, low) -> IRQ 17
saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 17, latency: 64, mmio:
0xdfffd800
saa7133[0]: subsystem: 1461:a836, board: Avermedia M115
[card=138,autodetected]
saa7133[0]: board init: gpio is a400000
saa7133[0]: i2c eeprom 00: 61 14 36 a8 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 c0 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: i2c scan: found device @ 0xc2  [???]
tuner' 3-0061: chip found @ 0xc2 (saa7133[0])
xc2028 3-0061: creating new instance
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<0000000000000000>] 0x0
PGD 7a329067 PUD 7786e067 PMD 0 
Oops: 0010 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/it87.656/temp2_input
CPU 0 
Modules linked in: tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887
tuner_simple tuner_types mt20xx tea5761 saa7134(+) ir_common compat_ioctl32
videodev v4l1_compat v4l2_common videobuf_dma_sg videobuf_core tveeprom
nvidia(P) vboxnetflt vboxdrv it87 hwmon_vid snd_usb_audio snd_usb_lib
snd_rawmidi snd_seq_device snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm snd_timer snd snd_page_alloc rfcomm l2cap bluetooth
Pid: 3070, comm: modprobe Tainted: P           2.6.28.4 #6
RIP: 0010:[<0000000000000000>]  [<0000000000000000>] 0x0
RSP: 0018:ffff880077b33bd8  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
RBP: ffff880077b64000 R08: ffff880077b64170 R09: ffffffff806135e0
R10: 0000000000000000 R11: ffffffffa0d10732 R12: ffffffffa0ceeea0
R13: ffff88007f8ec800 R14: ffff880077b64170 R15: 0000000000000000
FS:  00007fd1691fe6f0(0000) GS:ffffffff8067a040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000778f2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3070, threadinfo ffff880077b32000, task
ffff88007ec16750)
Stack:
 ffff880077b64000 ffffffffa0cd4288 ffff880077b64170 ffffffff80424fe2
 ffff00000001007f ffff880077b33c2f 000000000000007f ffffffffa0ccbb92
 000000010011fd7c ffffffff80239814 00ff88007ec16750 0000000000000000
Call Trace:
 [<ffffffff80424fe2>] ? i2c_master_recv+0x3a/0x46
 [<ffffffffa0ccbb92>] ? saa7134_i2c_register+0x171/0x1b3 [saa7134]
 [<ffffffff80239814>] ? process_timeout+0x0/0x5
 [<ffffffffa0cd2dad>] ? saa7134_initdev+0x5e1/0x918 [saa7134]
 [<ffffffff802c63f1>] ? sysfs_do_create_link+0xd0/0x11b
 [<ffffffff80356cf6>] ? pci_device_probe+0x4c/0x73
 [<ffffffff803a9f3d>] ? driver_probe_device+0xb5/0x159
 [<ffffffff803aa03a>] ? __driver_attach+0x59/0x80
 [<ffffffff803a9fe1>] ? __driver_attach+0x0/0x80
 [<ffffffff803a9849>] ? bus_for_each_dev+0x44/0x78
 [<ffffffff803a91cf>] ? bus_add_driver+0xac/0x1f2
 [<ffffffff803aa200>] ? driver_register+0xa2/0x11f
 [<ffffffffa0ccae39>] ? saa7134_init+0x0/0x4e [saa7134]
 [<ffffffff80356f7e>] ? __pci_register_driver+0x5d/0x8f
 [<ffffffffa0ccae39>] ? saa7134_init+0x0/0x4e [saa7134]
 [<ffffffff80209056>] ? _stext+0x56/0x14f
 [<ffffffff8025266f>] ? sys_init_module+0xa0/0x1a9
 [<ffffffff8020b35b>] ? system_call_fastpath+0x16/0x1b
Code:  Bad RIP value.
RIP  [<0000000000000000>] 0x0
 RSP <ffff880077b33bd8>
CR2: 0000000000000000
---[ end trace 6572bfa70bfdf67a ]---

I'm using a self-compiled 2.6.28.4 kernel, on a 64-bit system:

$ uname -a                                                               
Linux swift 2.6.28.4 #6 SMP PREEMPT Wed Feb 18 11:25:30 CET 2009 x86_64 x86_64 x86_64 GNU/Linux

Any hint on hwo to solve that?

Thanks!

-- 
Fabrice DELENTE

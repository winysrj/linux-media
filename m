Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42234 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbZA2VKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 16:10:25 -0500
Received: from jdelvare.pck.nerim.net ([62.212.121.182] helo=hyperion.delvare)
	by services.gcu-squad.org (GCU Mailer Daemon) with esmtpsa id 1LSfCd-0000SX-Ma
	(TLSv1:AES256-SHA:256)
	(envelope-from <khali@linux-fr.org>)
	for linux-media@vger.kernel.org; Thu, 29 Jan 2009 23:17:39 +0100
Date: Thu, 29 Jan 2009 22:10:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: linux-media@vger.kernel.org
Subject: cx88-dvb broken since 2.6.29-rc1
Message-ID: <20090129221012.685c239e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi folks,

I have a CX88-based DVB-T adapter which worked fine up to 2.6.28 but is
broken since 2.6.29-rc1 (and not fixed as off 2.6.29-rc3). The problem
is that /dev/dvb isn't created. Presumably the root cause is the
following in the kernel logs as the driver is loaded:

cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:02:04.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
cx88[0]: subsystem: 107d:665f, board: WinFast DTV1000-T [card=35,autodetected], frontend(s): 1
cx88[0]: TV tuner type 4, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
intel8x0_measure_ac97_clock: measured 50862 usecs
intel8x0: clocking to 48000
i2c-adapter i2c-1: adapter [cx88[0]] registered
i2c-adapter i2c-1: master_xfer[0] W, addr=0x50, len=1
i2c-adapter i2c-1: master_xfer[0] R, addr=0x50, len=256
input: cx88 IR (WinFast DTV1000-T) as /devices/pci0000:00/0000:00:1e.0/0000:02:04.0/input/input5
cx88[0]/0: found at 0000:02:04.0, rev: 5, irq: 21, latency: 32, mmio: 0xfc000000
IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:02:04.2: PCI INT A -> GSI 21 (level, low) -> IRQ 21
cx88[0]/2: found at 0000:02:04.2, rev: 5, irq: 21, latency: 32, mmio: 0xfd000000
IRQ 21/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 107d:665f, board: WinFast DTV1000-T [card=35]
cx88[0]/2: cx2388x based DVB/ATSC card
------------[ cut here ]------------
WARNING: at kernel/mutex.c:135 mutex_lock_nested+0x268/0x2b2()
Hardware name:         
Modules linked in: cx88_dvb(+) cx88_vp3054_i2c videobuf_dvb dvb_core cx8802 cx8800 cx88xx snd_intel8x0 ir_common snd_ac97_codec snd_pcsp v4l2_common i2c_algo_bit videodev ac97_bus thermal tveeprom v4l1_compat v4l2_compat_ioctl32 snd_pcm btcx_risc processor snd_timer thermal_sys videobuf_dma_sg parport_pc 8139too snd videobuf_core parport sr_mod hwmon mii soundcore i2c_i801 cdrom button snd_page_alloc intel_agp iTCO_wdt sg sd_mod ehci_hcd uhci_hcd usbcore ext3 mbcache jbd ata_piix libata
Pid: 1713, comm: modprobe Not tainted 2.6.29-rc3 #60
Call Trace:
 [<ffffffff80234508>] warn_slowpath+0xcd/0x11e
 [<ffffffff8020c23c>] ? restore_args+0x0/0x30
 [<ffffffff802581df>] ? trace_hardirqs_on_caller+0x12e/0x17d
 [<ffffffff8043c065>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c23c>] ? restore_args+0x0/0x30
 [<ffffffff8043c4b0>] ? _spin_unlock_irqrestore+0x45/0x4a
 [<ffffffff802350c4>] ? vprintk+0x16a/0x3f5
 [<ffffffff8043c4b0>] ? _spin_unlock_irqrestore+0x45/0x4a
 [<ffffffff802350c4>] ? vprintk+0x16a/0x3f5
 [<ffffffffa0072172>] ? videobuf_dvb_get_frontend+0x21/0x73 [videobuf_dvb]
 [<ffffffff8043acc1>] mutex_lock_nested+0x268/0x2b2
 [<ffffffffa0072172>] videobuf_dvb_get_frontend+0x21/0x73 [videobuf_dvb]
 [<ffffffffa022bd58>] cx8802_dvb_probe+0x113/0x1d61 [cx88_dvb]
 [<ffffffff802957b0>] ? kmem_cache_alloc+0x66/0x90
 [<ffffffff8025823b>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa020b26e>] cx8802_register_driver+0x1b0/0x229 [cx8802]
 [<ffffffffa022da40>] ? dvb_init+0x0/0x2c [cx88_dvb]
 [<ffffffffa022da67>] dvb_init+0x27/0x2c [cx88_dvb]
 [<ffffffff80209033>] _stext+0x33/0x151
 [<ffffffff8025823b>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80262d7b>] sys_init_module+0xa0/0x1de
 [<ffffffff8020b7db>] system_call_fastpath+0x16/0x1b
---[ end trace c6ad9ed793b52080 ]---
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff8031f9a7>] __list_add+0x1f/0x98
PGD 37b79067 PUD 3795d067 PMD 0 
Oops: 0000 [#1] 
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/modalias
CPU 0 
Modules linked in: cx88_dvb(+) cx88_vp3054_i2c videobuf_dvb dvb_core cx8802 cx8800 cx88xx snd_intel8x0 ir_common snd_ac97_codec snd_pcsp v4l2_common i2c_algo_bit videodev ac97_bus thermal tveeprom v4l1_compat v4l2_compat_ioctl32 snd_pcm btcx_risc processor snd_timer thermal_sys videobuf_dma_sg parport_pc 8139too snd videobuf_core parport sr_mod hwmon mii soundcore i2c_i801 cdrom button snd_page_alloc intel_agp iTCO_wdt sg sd_mod ehci_hcd uhci_hcd usbcore ext3 mbcache jbd ata_piix libata
Pid: 1713, comm: modprobe Tainted: G        W  2.6.29-rc3 #60
RIP: 0010:[<ffffffff8031f9a7>]  [<ffffffff8031f9a7>] __list_add+0x1f/0x98
RSP: 0018:ffff88003e4d5d38  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8800378f75e8 RCX: 0000000000000000
RDX: ffff8800378f75e8 RSI: 0000000000000000 RDI: ffff88003e4d5d88
RBP: ffff88003e4d5d58 R08: 0000000000000002 R09: 0000000000000001
R10: ffff88003ed670c0 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88003e4d5d88 R14: ffffffffa0072172 R15: ffff88003e4d5d88
FS:  00007f9c626046f0(0000) GS:ffffffff80604020(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000378e2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 1713, threadinfo ffff88003e4d4000, task ffff88003ed670c0)
Stack:
 0000000000000000 ffff8800378f75b0 0000000000000246 ffff88003ed670c0
 ffff88003e4d5de8 ffffffff8043ab28 ffffffffa0072172 ffff88003e473018
 0000000000000000 ffff8800378f75e8 ffff88003e4d5d88 ffff88003e4d5d88
Call Trace:
 [<ffffffff8043ab28>] mutex_lock_nested+0xcf/0x2b2
 [<ffffffffa0072172>] ? videobuf_dvb_get_frontend+0x21/0x73 [videobuf_dvb]
 [<ffffffffa0072172>] videobuf_dvb_get_frontend+0x21/0x73 [videobuf_dvb]
 [<ffffffffa022bd58>] cx8802_dvb_probe+0x113/0x1d61 [cx88_dvb]
 [<ffffffff802957b0>] ? kmem_cache_alloc+0x66/0x90
 [<ffffffff8025823b>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa020b26e>] cx8802_register_driver+0x1b0/0x229 [cx8802]
 [<ffffffffa022da40>] ? dvb_init+0x0/0x2c [cx88_dvb]
 [<ffffffffa022da67>] dvb_init+0x27/0x2c [cx88_dvb]
 [<ffffffff80209033>] _stext+0x33/0x151
 [<ffffffff8025823b>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80262d7b>] sys_init_module+0xa0/0x1de
 [<ffffffff8020b7db>] system_call_fastpath+0x16/0x1b
Code: 31 c0 e8 b8 4a f1 ff 48 8b 13 eb 98 55 48 89 e5 41 55 41 54 53 48 83 ec 08 49 89 fd 49 89 f4 48 89 d3 48 8b 42 08 48 39 f0 75 24 <49> 8b 04 24 48 39 d8 75 40 4c 89 6b 08 49 89 5d 00 4d 89 65 08 
RIP  [<ffffffff8031f9a7>] __list_add+0x1f/0x98
 RSP <ffff88003e4d5d38>
CR2: 0000000000000000
---[ end trace c6ad9ed793b52081 ]---

This is on x86-64. Any additional information available on request.

Thanks,
-- 
Jean Delvare

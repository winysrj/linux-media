Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49477 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0EIQM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 12:12:26 -0400
Received: by wyf19 with SMTP id 19so345580wyf.19
        for <linux-media@vger.kernel.org>; Sun, 09 May 2010 09:12:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <u2p696f7f5e1004301326i6ea431d3n240c4f90c483558d@mail.gmail.com>
References: <696f7f5e0912180141n23658a18l428157b0ea1d8f47@mail.gmail.com>
	 <696f7f5e0912180144j27a6fd7cj2492b57259314871@mail.gmail.com>
	 <1a297b360912180157m24da5eb2q2df4508e7280e521@mail.gmail.com>
	 <696f7f5e0912180203g1617dec3u2db38ffb063d0372@mail.gmail.com>
	 <696f7f5e0912180226v2bc11ca0j4d597f4725602ba@mail.gmail.com>
	 <696f7f5e0912180547o65b01dd6na1d74478f4b7c71c@mail.gmail.com>
	 <696f7f5e0912181113m32ac21fes56f10ec51fccf522@mail.gmail.com>
	 <1a297b360912181240v2c53f446kd1e86447ddb24c74@mail.gmail.com>
	 <u2p696f7f5e1004301326i6ea431d3n240c4f90c483558d@mail.gmail.com>
Date: Sun, 9 May 2010 19:12:24 +0300
Message-ID: <AANLkTilpSx4HBps6Y9v2Wns3hk6vtXg6L9mrjN_AEARH@mail.gmail.com>
Subject: Fwd: Technotrend S2-1600 - initialization bug
From: Andrey Gangan <a.gangan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
The bug is still exist in a Ubuntu 10.04 LTS with kernel 2.6.32
[   58.540239] saa7146: register extension 'budget dvb'.
[   58.540263] budget dvb 0000:07:02.0: PCI INT A -> GSI 17 (level,
low) -> IRQ 17
[   58.540303] IRQ 17/: IRQF_DISABLED is not guaranteed on shared IRQs
[   58.540323] saa7146: found saa7146 @ mem ffffc900006be000 (revision
1, irq 17) (0x13c2,0x101c).
[   58.540327] saa7146 (0): dma buffer size 192512
[   58.540329] DVB: registering new adapter (TT-Budget S2-1600 PCI)
[   58.598137] adapter has MAC addr = 00:d0:5c:cc:a2:f6
[   59.079969] cfg80211: World regulatory domain updated:
[   59.079972] (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   59.079974] (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   59.079977] (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   59.079978] (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   59.079981] (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   59.079983] (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   59.179903] DVB: Unable to find symbol stv090x_attach()
[   59.179911] BUG: unable to handle kernel NULL pointer dereference
at 00000000000000b0
[   59.179913] IP: [<ffffffffa01f7e6c>] dvb_frontend_detach+0xc/0x90 [dvb_core]
[   59.179921] PGD 1370c7067 PUD 133e09067 PMD 0
[   59.179924] Oops: 0000 [#1] SMP
[   59.179925] last sysfs file: /sys/module/snd_seq_device/initstate
[   59.179928] CPU 0
[   59.179929] Modules linked in: snd_seq_midi_event snd_seq ath5k(+)
budget(+) budget_core mac80211 ath saa7146 snd_timer uvcvideo
snd_seq_device ttpci_eeprom cfg80211 videodev snd asus_atk0110
led_class v4l1_compat dvb_core v4l2_compat_ioctl32 soundcore
snd_page_alloc squashfs aufs nls_cp437 isofs dm_raid45 xor fbcon
tileblit font bitblit softcursor vga16fb vgastate usbhid hid nouveau
ttm drm_kms_helper ohci1394 intel_agp ieee1394 drm i2c_algo_bit r8169
mii ahci
[   59.179948] Pid: 1616, comm: modprobe Not tainted 2.6.32-21-generic
#32-Ubuntu System Product Name
[   59.179949] RIP: 0010:[<ffffffffa01f7e6c>]  [<ffffffffa01f7e6c>]
dvb_frontend_detach+0xc/0x90 [dvb_core]
[   59.179953] RSP: 0018:ffff880138a5bba8  EFLAGS: 00010246
[   59.179955] RAX: 0000000000000041 RBX: ffff880139823000 RCX: 000000000000001e
[   59.179956] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000000
[   59.179957] RBP: ffff880138a5bbb8 R08: 00000000ffffffff R09: 0000000000000000
[   59.179958] R10: 0000000000000005 R11: 0000000000000000 R12: ffff88013ad5a200
[   59.179960] R13: ffffffffa0312cc0 R14: 0000000000000000 R15: ffff88013ad5a294
[   59.179961] FS:  00007f95687d6700(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[   59.179963] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   59.179964] CR2: 00000000000000b0 CR3: 0000000133e0b000 CR4: 00000000000006f0
[   59.179965] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   59.179966] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   59.179968] Process modprobe (pid: 1616, threadinfo
ffff880138a5a000, task ffff8801376496f0)
[   59.179969] Stack:
[   59.179970]  ffff880139823000 ffff88013ad5a200 ffff880138a5bc28
ffffffffa0310bbe
[   59.179972] <0> ffffffffa0312d60 ffff880139823810 ffff880138a5bc28
ffffffffa0307d50
[   59.179974] <0> ffff8801398233a8 ffff8801398230f8 0000000000000000
ffff880139823000
[   59.179977] Call Trace:
[   59.179980]  [<ffffffffa0310bbe>] frontend_init+0x91e/0xd90 [budget]
[   59.179983]  [<ffffffffa0307d50>] ? ttpci_budget_init+0x2f0/0x470
[budget_core]
[   59.179986]  [<ffffffffa0311aae>] budget_attach+0x9e/0x150 [budget]
[   59.179989]  [<ffffffffa02aa296>] saa7146_init_one+0x8c6/0x9b0 [saa7146]
[   59.179994]  [<ffffffff812ce6f7>] local_pci_probe+0x17/0x20
[   59.179996]  [<ffffffff812cea19>] __pci_device_probe+0xe9/0xf0
[   59.179999]  [<ffffffff812b358a>] ? kobject_get+0x1a/0x30
[   59.180002]  [<ffffffff81364ea9>] ? get_device+0x19/0x20
[   59.180004]  [<ffffffff812cf847>] pci_device_probe+0x37/0x60
[   59.180006]  [<ffffffff81368f85>] really_probe+0x65/0x170
[   59.180008]  [<ffffffff813690d5>] driver_probe_device+0x45/0x70
[   59.180010]  [<ffffffff81369100>] ? __driver_attach+0x0/0xa0
[   59.180011]  [<ffffffff8136919b>] __driver_attach+0x9b/0xa0
[   59.180013]  [<ffffffff81369100>] ? __driver_attach+0x0/0xa0
[   59.180015]  [<ffffffff813683e8>] bus_for_each_dev+0x68/0x90
[   59.180016]  [<ffffffff81368dfe>] driver_attach+0x1e/0x20
[   59.180018]  [<ffffffff813686be>] bus_add_driver+0xde/0x280
[   59.180020]  [<ffffffff813694d0>] driver_register+0x80/0x150
[   59.180022]  [<ffffffff8153e0e0>] ? printk+0x41/0x49
[   59.180024]  [<ffffffff812cfad6>] __pci_register_driver+0x56/0xd0
[   59.180027]  [<ffffffffa0316000>] ? budget_init+0x0/0x12 [budget]
[   59.180029]  [<ffffffffa02a8f91>]
saa7146_register_extension+0x61/0xa0 [saa7146]
[   59.180032]  [<ffffffffa0316010>] budget_init+0x10/0x12 [budget]
[   59.180035]  [<ffffffff8100a04c>] do_one_initcall+0x3c/0x1a0
[   59.180040]  [<ffffffff810a17ef>] sys_init_module+0xdf/0x260
[   59.180043]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
[   59.180044] Code: 0e 89 c8 c9 29 f0 c3 0f 1f 84 00 00 00 00 00 8d
81 40 42 0f 00 c9 29 f0 c3 66 0f 1f 44 00 00 55 48 89 e5 41 54 53 0f
1f 44 00 00 <48> 8b 87 b0 00 00 00 48 89 fb 48 85 c0 74 0e ff d0 48 8b
bb b0
[   59.180061] RIP  [<ffffffffa01f7e6c>] dvb_frontend_detach+0xc/0x90 [dvb_core]
[   59.180064]  RSP <ffff880138a5bba8>
[   59.180065] CR2: 00000000000000b0
[   59.180067] ---[ end trace be546a77b329611b ]---

Andrey Gangan

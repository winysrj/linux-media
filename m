Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbaG1KfR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jul 2014 06:35:17 -0400
Message-ID: <53D62763.6050600@redhat.com>
Date: Mon, 28 Jul 2014 12:35:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: lockdep warning with 3.16.0-rc6+ + bttv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've upgraded my machine to 3.16.o-rc6+ with lockdep enabled and now
I get the following bttv related lockdep warning:

[    4.797234] media: Linux media interface: v0.10
[    4.810984] snd_bt87x 0000:04:07.1: bt87x0: Using board 1, analog, digital (rate 32000 Hz)
[    4.836178] Linux video capture interface: v2.00
[    4.997442] bttv: driver version 0.9.19 loaded
[    4.997446] bttv: using 8 buffers with 2080k (520 pages) each for capture
[    5.001339] bttv: Bt8xx card found (0)
[    5.001482] bttv: 0: Bt878 (rev 2) at 0000:04:07.0, irq: 20, latency: 32, mmio: 0xd0001000
[    5.001499] bttv: 0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
[    5.001501] bttv: 0: using: Hauppauge (bt878) [card=10,autodetected]
[    5.004174] bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
[    5.039038] tveeprom 9-0050: Hauppauge model 61334, rev B2  , serial# 3211125
[    5.039040] tveeprom 9-0050: tuner model is Philips FM1216 (idx 21, type 5)
[    5.039042] tveeprom 9-0050: TV standards PAL(B/G) (eeprom 0x04)
[    5.039043] tveeprom 9-0050: audio processor is MSP3415 (idx 6)
[    5.039044] tveeprom 9-0050: has radio
[    5.039045] bttv: 0: Hauppauge eeprom indicates model#61334
[    5.039046] bttv: 0: tuner type=5
[    5.073212] msp3400 9-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
[    5.073217] msp3400 9-0040: msp3400 supports nicam, mode is autodetect
[    5.114390] tuner 9-0061: Tuner -1 found with type(s) Radio TV.
[    5.144779] tuner-simple 9-0061: creating new instance
[    5.144782] tuner-simple 9-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))

[    5.148047] ======================================================
[    5.148048] [ INFO: possible circular locking dependency detected ]
[    5.148050] 3.16.0-rc6+ #109 Tainted: G           OE
[    5.148051] -------------------------------------------------------
[    5.148052] systemd-udevd/545 is trying to acquire lock:
[    5.148053]  (msp3400_driver:799:(hdl)->_lock){+.+.+.}, at: [<ffffffffa0282295>] find_ref_lock+0x25/0x60 [videodev]
[    5.148062]
but task is already holding lock:
[    5.148063]  (bttv_driver:4066:(hdl)->_lock){+.+...}, at: [<ffffffffa028323d>] v4l2_ctrl_handler_setup+0x3d/0x130 [videodev]
[    5.148069]
which lock already depends on the new lock.

[    5.148070]
the existing dependency chain (in reverse order) is:
[    5.148071]
-> #1 (bttv_driver:4066:(hdl)->_lock){+.+...}:
[    5.148074]        [<ffffffff81102054>] lock_acquire+0xa4/0x1d0
[    5.148077]        [<ffffffff8180b425>] mutex_lock_nested+0x85/0x440
[    5.148080]        [<ffffffffa0282295>] find_ref_lock+0x25/0x60 [videodev]
[    5.148083]        [<ffffffffa0284b36>] handler_new_ref+0x46/0x1d0 [videodev]
[    5.148087]        [<ffffffffa02857af>] v4l2_ctrl_add_handler+0x9f/0xe0 [videodev]
[    5.148091]        [<ffffffffa027ebf6>] v4l2_device_register_subdev+0xe6/0x1e0 [videodev]
[    5.148094]        [<ffffffffa029f743>] v4l2_i2c_new_subdev_board+0x93/0x110 [v4l2_common]
[    5.148097]        [<ffffffffa029f82a>] v4l2_i2c_new_subdev+0x6a/0x90 [v4l2_common]
[    5.148099]        [<ffffffffa032a8c6>] bttv_init_card2+0x1486/0x1990 [bttv]
[    5.148106]        [<ffffffffa032781d>] bttv_probe+0x78d/0xd20 [bttv]
[    5.148110]        [<ffffffff8142e515>] local_pci_probe+0x45/0xa0
[    5.148113]        [<ffffffff8142f959>] pci_device_probe+0xf9/0x150
[    5.148115]        [<ffffffff8151e003>] driver_probe_device+0xa3/0x400
[    5.148119]        [<ffffffff8151e42b>] __driver_attach+0x8b/0x90
[    5.148121]        [<ffffffff8151bc83>] bus_for_each_dev+0x73/0xc0
[    5.148123]        [<ffffffff8151da5e>] driver_attach+0x1e/0x20
[    5.148125]        [<ffffffff8151d628>] bus_add_driver+0x188/0x260
[    5.148128]        [<ffffffff8151ef04>] driver_register+0x64/0xf0
[    5.148130]        [<ffffffff8142ddc0>] __pci_register_driver+0x60/0x70
[    5.148132]        [<ffffffffa03470cf>] bttv_init_module+0xcf/0xe9 [bttv]
[    5.148136]        [<ffffffff81002148>] do_one_initcall+0xd8/0x210
[    5.148139]        [<ffffffff8113a600>] load_module+0x2110/0x2740
[    5.148142]        [<ffffffff8113ae16>] SyS_finit_module+0xa6/0xe0
[    5.148143]        [<ffffffff81810069>] system_call_fastpath+0x16/0x1b
[    5.148146]
-> #0 (msp3400_driver:799:(hdl)->_lock){+.+.+.}:
[    5.148148]        [<ffffffff8110158b>] __lock_acquire+0x1abb/0x1ca0
[    5.148150]        [<ffffffff81102054>] lock_acquire+0xa4/0x1d0
[    5.148152]        [<ffffffff8180b425>] mutex_lock_nested+0x85/0x440
[    5.148153]        [<ffffffffa0282295>] find_ref_lock+0x25/0x60 [videodev]
[    5.148157]        [<ffffffffa02822de>] v4l2_ctrl_find+0xe/0x30 [videodev]
[    5.148161]        [<ffffffffa032649d>] audio_mute+0x3d/0xb0 [bttv]
[    5.148165]        [<ffffffffa03266a6>] bttv_s_ctrl+0x196/0x440 [bttv]
[    5.148168]        [<ffffffffa02832ee>] v4l2_ctrl_handler_setup+0xee/0x130 [videodev]
[    5.148172]        [<ffffffffa0327874>] bttv_probe+0x7e4/0xd20 [bttv]
[    5.148176]        [<ffffffff8142e515>] local_pci_probe+0x45/0xa0
[    5.148178]        [<ffffffff8142f959>] pci_device_probe+0xf9/0x150
[    5.148180]        [<ffffffff8151e003>] driver_probe_device+0xa3/0x400
[    5.148182]        [<ffffffff8151e42b>] __driver_attach+0x8b/0x90
[    5.148184]        [<ffffffff8151bc83>] bus_for_each_dev+0x73/0xc0
[    5.148186]        [<ffffffff8151da5e>] driver_attach+0x1e/0x20
[    5.148188]        [<ffffffff8151d628>] bus_add_driver+0x188/0x260
[    5.148190]        [<ffffffff8151ef04>] driver_register+0x64/0xf0
[    5.148192]        [<ffffffff8142ddc0>] __pci_register_driver+0x60/0x70
[    5.148194]        [<ffffffffa03470cf>] bttv_init_module+0xcf/0xe9 [bttv]
[    5.148198]        [<ffffffff81002148>] do_one_initcall+0xd8/0x210
[    5.148200]        [<ffffffff8113a600>] load_module+0x2110/0x2740
[    5.148201]        [<ffffffff8113ae16>] SyS_finit_module+0xa6/0xe0
[    5.148203]        [<ffffffff81810069>] system_call_fastpath+0x16/0x1b
[    5.148205]
other info that might help us debug this:

[    5.148206]  Possible unsafe locking scenario:

[    5.148207]        CPU0                    CPU1
[    5.148208]        ----                    ----
[    5.148209]   lock(bttv_driver:4066:(hdl)->_lock);
[    5.148211]                                lock(msp3400_driver:799:(hdl)->_lock);
[    5.148213]                                lock(bttv_driver:4066:(hdl)->_lock);
[    5.148214]   lock(msp3400_driver:799:(hdl)->_lock);
[    5.148216]
 *** DEADLOCK ***

[    5.148218] 3 locks held by systemd-udevd/545:
[    5.148218]  #0:  (&dev->mutex){......}, at: [<ffffffff8151e3e3>] __driver_attach+0x43/0x90
[    5.148222]  #1:  (&dev->mutex){......}, at: [<ffffffff8151e3f1>] __driver_attach+0x51/0x90
[    5.148226]  #2:  (bttv_driver:4066:(hdl)->_lock){+.+...}, at: [<ffffffffa028323d>] v4l2_ctrl_handler_setup+0x3d/0x130 [videodev]
[    5.148231]
stack backtrace:
[    5.148233] CPU: 3 PID: 545 Comm: systemd-udevd Tainted: G           OE 3.16.0-rc6+ #109
[    5.148235] Hardware name: FUJITSU D3071-S1/D3071-S1, BIOS V4.6.4.0 R1.12.0.SR.4 for D3071-S1x 05/03/2013
[    5.148236]  0000000000000000 0000000032f7aef8 ffff880230c57800 ffffffff818064c7
[    5.148238]  ffffffff82ba8b00 ffff880230c57840 ffffffff818037fc ffff880230c578a0
[    5.148241]  ffff88003513b448 ffff88003513b3a0 0000000000000003 ffff88003513bfb0
[    5.148243] Call Trace:
[    5.148246]  [<ffffffff818064c7>] dump_stack+0x4d/0x66
[    5.148249]  [<ffffffff818037fc>] print_circular_bug+0x201/0x20f
[    5.148251]  [<ffffffff8110158b>] __lock_acquire+0x1abb/0x1ca0
[    5.148253]  [<ffffffff810ff67d>] ? trace_hardirqs_on_caller+0x15d/0x200
[    5.148255]  [<ffffffff8180f2ac>] ? _raw_spin_unlock_irq+0x2c/0x40
[    5.148258]  [<ffffffff810d3b4d>] ? finish_task_switch+0x3d/0x120
[    5.148260]  [<ffffffff81102054>] lock_acquire+0xa4/0x1d0
[    5.148263]  [<ffffffffa0282295>] ? find_ref_lock+0x25/0x60 [videodev]
[    5.148265]  [<ffffffff8180b425>] mutex_lock_nested+0x85/0x440
[    5.148269]  [<ffffffffa0282295>] ? find_ref_lock+0x25/0x60 [videodev]
[    5.148272]  [<ffffffffa0282295>] ? find_ref_lock+0x25/0x60 [videodev]
[    5.148274]  [<ffffffff810ff72d>] ? trace_hardirqs_on+0xd/0x10
[    5.148277]  [<ffffffffa0282295>] find_ref_lock+0x25/0x60 [videodev]
[    5.148281]  [<ffffffffa02822de>] v4l2_ctrl_find+0xe/0x30 [videodev]
[    5.148284]  [<ffffffffa032649d>] audio_mute+0x3d/0xb0 [bttv]
[    5.148288]  [<ffffffffa03266a6>] bttv_s_ctrl+0x196/0x440 [bttv]
[    5.148292]  [<ffffffffa02832ee>] v4l2_ctrl_handler_setup+0xee/0x130 [videodev]
[    5.148296]  [<ffffffffa0327874>] bttv_probe+0x7e4/0xd20 [bttv]
[    5.148298]  [<ffffffff8142e515>] local_pci_probe+0x45/0xa0
[    5.148300]  [<ffffffff8142f7f5>] ? pci_match_device+0xe5/0x110
[    5.148302]  [<ffffffff8142f959>] pci_device_probe+0xf9/0x150
[    5.148305]  [<ffffffff8151e003>] driver_probe_device+0xa3/0x400
[    5.148307]  [<ffffffff8151e42b>] __driver_attach+0x8b/0x90
[    5.148310]  [<ffffffff8151e3a0>] ? __device_attach+0x40/0x40
[    5.148312]  [<ffffffff8151bc83>] bus_for_each_dev+0x73/0xc0
[    5.148314]  [<ffffffff8151da5e>] driver_attach+0x1e/0x20
[    5.148316]  [<ffffffff8151d628>] bus_add_driver+0x188/0x260
[    5.148319]  [<ffffffffa0347000>] ? 0xffffffffa0346fff
[    5.148322]  [<ffffffff8151ef04>] driver_register+0x64/0xf0
[    5.148324]  [<ffffffff8142ddc0>] __pci_register_driver+0x60/0x70
[    5.148328]  [<ffffffffa03470cf>] bttv_init_module+0xcf/0xe9 [bttv]
[    5.148330]  [<ffffffff81002148>] do_one_initcall+0xd8/0x210
[    5.148332]  [<ffffffff812067ca>] ? __vunmap+0xba/0x120
[    5.148334]  [<ffffffff8113a600>] load_module+0x2110/0x2740
[    5.148337]  [<ffffffff81135870>] ? store_uevent+0x70/0x70
[    5.148340]  [<ffffffff812515d7>] ? kernel_read+0x57/0x90
[    5.148342]  [<ffffffff8113ae16>] SyS_finit_module+0xa6/0xe0
[    5.148344]  [<ffffffff81810069>] system_call_fastpath+0x16/0x1b
[    5.154573] bttv: 0: Setting PLL: 28636363 => 35468950 (needs up to 100ms)
[    5.176880] bttv: PLL set ok
[    5.178240] bttv: 0: registered device video0
[    5.178984] bttv: 0: registered device vbi0
[    5.179106] bttv: 0: registered device radio0

Regards,

Hans

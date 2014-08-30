Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57446 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaH3NRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Aug 2014 09:17:40 -0400
Received: by mail-lb0-f171.google.com with SMTP id n15so3841155lbi.2
        for <linux-media@vger.kernel.org>; Sat, 30 Aug 2014 06:17:38 -0700 (PDT)
Message-ID: <5401CEEE.6090101@iki.fi>
Date: Sat, 30 Aug 2014 16:17:34 +0300
From: Tomas Melin <tomas.melin@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, m.chehab@samsung.com,
	a.seppala@gmail.com, david@hardeman.nu, james.hogan@imgtec.com,
	jarod@redhat.com
Subject: regression nuvoton-cir: possible circular locking dependency
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I get a lockdep splat with kernels 3.17-rc1 and newer for the 
nuvoton-cir driver on my Intel NUC D54250. The driver was working 
correctly with Linux 3.16, after upgrading it does not react to any 
input anymore although loading seems to be succesful.

If you have any ideas on this issue I can help out with debugging/testing.

Tomas


[    4.962509] Registered IR keymap rc-rc6-mce
[    4.963166] input: Nuvoton w836x7hg Infrared Remote Transceiver as 
/devices/pnp0/00:05/rc/rc0/input6
[    4.963656] rc0: Nuvoton w836x7hg Infrared Remote Transceiver as 
/devices/pnp0/00:05/rc/rc0
[    4.965433] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.966211] input: MCE IR Keyboard/Mouse (nuvoton-cir) as 
/devices/virtual/input/input7
[    4.966222]
[    4.966266] ======================================================
[    4.966317] [ INFO: possible circular locking dependency detected ]
[    4.966371] 3.17.0-rc2 #12 Not tainted
[    4.966417] -------------------------------------------------------
[    4.966469] modprobe/642 is trying to acquire lock:
[    4.966518]  (input_mutex){+.+.+.}, at: [<ffffffff812ef338>] 
input_register_device+0x2ba/0x381
[    4.966729]
[    4.966729] but task is already holding lock:
[    4.966779]  (ir_raw_handler_lock){+.+.+.}, at: [<ffffffff8131a249>] 
ir_raw_event_register+0x102/0x190
[    4.966990]
[    4.966990] which lock already depends on the new lock.
[    4.966990]
[    4.967060]
[    4.967060] the existing dependency chain (in reverse order) is:
[    4.967144]
[    4.967144] -> #3 (ir_raw_handler_lock){+.+.+.}:
[    4.967386]        [<ffffffff81075c29>] lock_acquire+0xd9/0x111
[    4.967501]        [<ffffffff8148fb86>] mutex_lock_nested+0x57/0x37a
[    4.967616]        [<ffffffff8131a249>] ir_raw_event_register+0x102/0x190
[    4.967731]        [<ffffffff8131999c>] rc_register_device+0x39e/0x58a
[    4.967846]        [<ffffffffa02cc2e3>] nvt_probe+0x5ad/0xd52 
[nuvoton_cir]
[    4.967963]        [<ffffffff81297b4f>] pnp_device_probe+0x8c/0xa9
[    4.968079]        [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.968195]        [<ffffffff812d3ce6>] __driver_attach+0x4e/0x6f
[    4.968309]        [<ffffffff812d2277>] bus_for_each_dev+0x5a/0x8c
[    4.968425]        [<ffffffff812d3640>] driver_attach+0x19/0x1b
[    4.968529]        [<ffffffff812d3395>] bus_add_driver+0xf1/0x1d6
[    4.968633]        [<ffffffff812d4333>] driver_register+0x87/0xbe
[    4.968737]        [<ffffffff812978f0>] pnp_register_driver+0x1c/0x1e
[    4.968842]        [<ffffffffa02d1010>] nvt_init+0x10/0x1000 
[nuvoton_cir]
[    4.968948]        [<ffffffff8100030e>] do_one_initcall+0xea/0x18c
[    4.969054]        [<ffffffff810a4cad>] load_module+0x1c21/0x1f2c
[    4.969159]        [<ffffffff810a505a>] SyS_init_module+0xa2/0xb1
[    4.969263]        [<ffffffff81492752>] system_call_fastpath+0x16/0x1b
[    4.969384]
[    4.969384] -> #2 (&dev->lock){+.+.+.}:
[    4.969625]        [<ffffffff81075c29>] lock_acquire+0xd9/0x111
[    4.969739]        [<ffffffff8148fb86>] mutex_lock_nested+0x57/0x37a
[    4.969853]        [<ffffffff8131841d>] rc_open+0x24/0x70
[    4.969966]        [<ffffffff81318479>] ir_open+0x10/0x12
[    4.970078]        [<ffffffff812edc20>] input_open_device+0x64/0x91
[    4.970193]        [<ffffffff812b0032>] kbd_connect+0x55/0x87
[    4.970307]        [<ffffffff812eefae>] input_attach_handler+0x1aa/0x1dc
[    4.970425]        [<ffffffff812ef37d>] input_register_device+0x2ff/0x381
[    4.970530]        [<ffffffff81319b4e>] rc_register_device+0x550/0x58a
[    4.970635]        [<ffffffffa02cc2e3>] nvt_probe+0x5ad/0xd52 
[nuvoton_cir]
[    4.970742]        [<ffffffff81297b4f>] pnp_device_probe+0x8c/0xa9
[    4.970846]        [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.970951]        [<ffffffff812d3ce6>] __driver_attach+0x4e/0x6f
[    4.971055]        [<ffffffff812d2277>] bus_for_each_dev+0x5a/0x8c
[    4.971159]        [<ffffffff812d3640>] driver_attach+0x19/0x1b
[    4.971263]        [<ffffffff812d3395>] bus_add_driver+0xf1/0x1d6
[    4.971378]        [<ffffffff812d4333>] driver_register+0x87/0xbe
[    4.971491]        [<ffffffff812978f0>] pnp_register_driver+0x1c/0x1e
[    4.971606]        [<ffffffffa02d1010>] nvt_init+0x10/0x1000 
[nuvoton_cir]
[    4.971722]        [<ffffffff8100030e>] do_one_initcall+0xea/0x18c
[    4.971837]        [<ffffffff810a4cad>] load_module+0x1c21/0x1f2c
[    4.971950]        [<ffffffff810a505a>] SyS_init_module+0xa2/0xb1
[    4.972063]        [<ffffffff81492752>] system_call_fastpath+0x16/0x1b
[    4.972178]
[    4.972178] -> #1 (&dev->mutex#2){+.+...}:
[    4.972462]        [<ffffffff81075c29>] lock_acquire+0xd9/0x111
[    4.972566]        [<ffffffff8148ff00>] 
mutex_lock_interruptible_nested+0x57/0x381
[    4.972688]        [<ffffffff812ed778>] input_register_handle+0x2c/0xbf
[    4.972794]        [<ffffffff812f2466>] mousedev_create+0x244/0x2c7
[    4.972898]        [<ffffffff812f25e1>] mousedev_connect+0x1b/0xd2
[    4.973003]        [<ffffffff812eefae>] input_attach_handler+0x1aa/0x1dc
[    4.973107]        [<ffffffff812ef37d>] input_register_device+0x2ff/0x381
[    4.973213]        [<ffffffff8132e535>] hidinput_connect+0x30ec/0x316c
[    4.973319]        [<ffffffff8132a924>] hid_connect+0x6e/0x26f
[    4.973440]        [<ffffffff8132abfa>] hid_device_probe+0xd5/0x14b
[    4.973554]        [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.973669]        [<ffffffff812d3d2c>] __device_attach+0x25/0x38
[    4.973782]        [<ffffffff812d21e1>] bus_for_each_drv+0x52/0x8e
[    4.973896]        [<ffffffff812d3a78>] device_attach+0x69/0x8a
[    4.974009]        [<ffffffff812d30fe>] bus_probe_device+0x33/0xb5
[    4.974123]        [<ffffffff812d1658>] device_add+0x38a/0x532
[    4.974235]        [<ffffffff8132a87a>] hid_add_device+0x1c2/0x1fe
[    4.974349]        [<ffffffffa00fd1c2>] usbhid_probe+0x374/0x3bd [usbhid]
[    4.974468]        [<ffffffffa003a426>] 
usb_probe_interface+0x143/0x1da [usbcore]
[    4.974598]        [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.974703]        [<ffffffff812d3ce6>] __driver_attach+0x4e/0x6f
[    4.974807]        [<ffffffff812d2277>] bus_for_each_dev+0x5a/0x8c
[    4.974912]        [<ffffffff812d3640>] driver_attach+0x19/0x1b
[    4.975016]        [<ffffffff812d3395>] bus_add_driver+0xf1/0x1d6
[    4.975120]        [<ffffffff812d4333>] driver_register+0x87/0xbe
[    4.975225]        [<ffffffffa003911c>] 
usb_register_driver+0x9f/0x14b [usbcore]
[    4.975353]        [<ffffffffa001d032>] 
crc_t10dif_generic+0x32/0x1000 [crct10dif_common]
[    4.975478]        [<ffffffff8100030e>] do_one_initcall+0xea/0x18c
[    4.975584]        [<ffffffff810a4cad>] load_module+0x1c21/0x1f2c
[    4.975688]        [<ffffffff810a505a>] SyS_init_module+0xa2/0xb1
[    4.975793]        [<ffffffff81492752>] system_call_fastpath+0x16/0x1b
[    4.975901]
[    4.975901] -> #0 (input_mutex){+.+.+.}:
[    4.976139]        [<ffffffff8107537b>] __lock_acquire+0xb54/0xeda
[    4.976271]        [<ffffffff81075c29>] lock_acquire+0xd9/0x111
[    4.976383]        [<ffffffff8148ff00>] 
mutex_lock_interruptible_nested+0x57/0x381
[    4.976512]        [<ffffffff812ef338>] input_register_device+0x2ba/0x381
[    4.976624]        [<ffffffff8131c093>] ir_mce_kbd_register+0x109/0x139
[    4.976737]        [<ffffffff8131a284>] ir_raw_event_register+0x13d/0x190
[    4.976847]        [<ffffffff8131999c>] rc_register_device+0x39e/0x58a
[    4.976957]        [<ffffffffa02cc2e3>] nvt_probe+0x5ad/0xd52 
[nuvoton_cir]
[    4.977064]        [<ffffffff81297b4f>] pnp_device_probe+0x8c/0xa9
[    4.977170]        [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.977276]        [<ffffffff812d3ce6>] __driver_attach+0x4e/0x6f
[    4.977381]        [<ffffffff812d2277>] bus_for_each_dev+0x5a/0x8c
[    4.977485]        [<ffffffff812d3640>] driver_attach+0x19/0x1b
[    4.977590]        [<ffffffff812d3395>] bus_add_driver+0xf1/0x1d6
[    4.977694]        [<ffffffff812d4333>] driver_register+0x87/0xbe
[    4.977799]        [<ffffffff812978f0>] pnp_register_driver+0x1c/0x1e
[    4.977905]        [<ffffffffa02d1010>] nvt_init+0x10/0x1000 
[nuvoton_cir]
[    4.978012]        [<ffffffff8100030e>] do_one_initcall+0xea/0x18c
[    4.978118]        [<ffffffff810a4cad>] load_module+0x1c21/0x1f2c
[    4.978224]        [<ffffffff810a505a>] SyS_init_module+0xa2/0xb1
[    4.978335]        [<ffffffff81492752>] system_call_fastpath+0x16/0x1b
[    4.978448]
[    4.978448] other info that might help us debug this:
[    4.978448]
[    4.978552] Chain exists of:
[    4.978552]   input_mutex --> &dev->lock --> ir_raw_handler_lock
[    4.978552]
[    4.978875]  Possible unsafe locking scenario:
[    4.978875]
[    4.978955]        CPU0                    CPU1
[    4.979018]        ----                    ----
[    4.979080]   lock(ir_raw_handler_lock);
[    4.979215]                                lock(&dev->lock);
[    4.979355]                                lock(ir_raw_handler_lock);
[    4.979496]   lock(input_mutex);
[    4.979629]
[    4.979629]  *** DEADLOCK ***
[    4.979629]
[    4.979725] 4 locks held by modprobe/642:
[    4.979786]  #0:  (&dev->mutex){......}, at: [<ffffffff812d350f>] 
device_lock+0xf/0x11
[    4.980060]  #1:  (&dev->mutex){......}, at: [<ffffffff812d350f>] 
device_lock+0xf/0x11
[    4.980332]  #2:  (&dev->lock){+.+.+.}, at: [<ffffffff81319b5b>] 
rc_register_device+0x55d/0x58a
[    4.980635]  #3:  (ir_raw_handler_lock){+.+.+.}, at: 
[<ffffffff8131a249>] ir_raw_event_register+0x102/0x190
[    4.980932]
[    4.980932] stack backtrace:
[    4.981019] CPU: 0 PID: 642 Comm: modprobe Not tainted 3.17.0-rc2 #12
[    4.981093] Hardware name:                  /D54250WYK, BIOS 
WYLPT10H.86A.0027.2014.0710.1904 07/10/2014
[    4.981192]  ffffffff820708b0 ffff880215f27838 ffffffff8148b61a 
0000000000001d64
[    4.981448]  ffffffff8203a2c0 ffff880215f27888 ffffffff81488f49 
0000000000000004
[    4.981681]  ffff88003686e890 ffff880215f27888 ffff88003686e890 
ffff88003686f0b8
[    4.981913] Call Trace:
[    4.981975]  [<ffffffff8148b61a>] dump_stack+0x46/0x58
[    4.982041]  [<ffffffff81488f49>] print_circular_bug+0x1f8/0x209
[    4.982109]  [<ffffffff8107537b>] __lock_acquire+0xb54/0xeda
[    4.982175]  [<ffffffff81081f6f>] ? console_unlock+0x34d/0x399
[    4.982243]  [<ffffffff81075c29>] lock_acquire+0xd9/0x111
[    4.982309]  [<ffffffff812ef338>] ? input_register_device+0x2ba/0x381
[    4.982389]  [<ffffffff8148ff00>] 
mutex_lock_interruptible_nested+0x57/0x381
[    4.982466]  [<ffffffff812ef338>] ? input_register_device+0x2ba/0x381
[    4.982543]  [<ffffffff811268d7>] ? kfree+0x7c/0x96
[    4.982614]  [<ffffffff812ef338>] ? input_register_device+0x2ba/0x381
[    4.982691]  [<ffffffff81073559>] ? trace_hardirqs_on+0xd/0xf
[    4.982764]  [<ffffffff812ef338>] input_register_device+0x2ba/0x381
[    4.982840]  [<ffffffff8131c093>] ir_mce_kbd_register+0x109/0x139
[    4.982914]  [<ffffffff8131a284>] ir_raw_event_register+0x13d/0x190
[    4.982989]  [<ffffffff8131999c>] rc_register_device+0x39e/0x58a
[    4.983065]  [<ffffffff81073559>] ? trace_hardirqs_on+0xd/0xf
[    4.983141]  [<ffffffffa02cc2e3>] nvt_probe+0x5ad/0xd52 [nuvoton_cir]
[    4.983219]  [<ffffffffa02cbd36>] ? nvt_resume+0x80/0x80 [nuvoton_cir]
[    4.983296]  [<ffffffff81297b4f>] pnp_device_probe+0x8c/0xa9
[    4.983379]  [<ffffffff812d36b0>] ? driver_sysfs_add+0x6e/0x93
[    4.983446]  [<ffffffff812d3b56>] driver_probe_device+0xa1/0x1e3
[    4.983513]  [<ffffffff812d3c98>] ? driver_probe_device+0x1e3/0x1e3
[    4.983581]  [<ffffffff812d3ce6>] __driver_attach+0x4e/0x6f
[    4.983647]  [<ffffffff812d2277>] bus_for_each_dev+0x5a/0x8c
[    4.983713]  [<ffffffff812d3640>] driver_attach+0x19/0x1b
[    4.983779]  [<ffffffff812d3395>] bus_add_driver+0xf1/0x1d6
[    4.983845]  [<ffffffff812d4333>] driver_register+0x87/0xbe
[    4.983913]  [<ffffffffa02d1000>] ? 0xffffffffa02d1000
[    4.983979]  [<ffffffff812978f0>] pnp_register_driver+0x1c/0x1e
[    4.984046]  [<ffffffffa02d1010>] nvt_init+0x10/0x1000 [nuvoton_cir]
[    4.984115]  [<ffffffff8100030e>] do_one_initcall+0xea/0x18c
[    4.984183]  [<ffffffff81116837>] ? __vunmap+0x9d/0xc7
[    4.984248]  [<ffffffff810a4cad>] load_module+0x1c21/0x1f2c
[    4.986190]  [<ffffffff810a1bda>] ? show_initstate+0x44/0x44
[    4.986257]  [<ffffffff810a505a>] SyS_init_module+0xa2/0xb1
[    4.986323]  [<ffffffff81492752>] system_call_fastpath+0x16/0x1b
[    4.986802] nuvoton_cir: driver has been successfully loaded
[    5.092836] lirc_dev: IR Remote Control driver registered, major 250

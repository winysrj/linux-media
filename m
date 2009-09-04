Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f182.google.com ([209.85.210.182]:35367 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934366AbZIDWjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 18:39:31 -0400
Message-ID: <4AA19719.9010104@lwfinger.net>
Date: Fri, 04 Sep 2009 17:39:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Regression between 2.6.29 and 2.6.30.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When I plug in a TV tuner that uses the em28xx driver, I get the oops
listed below for x86_64. Note: 2.6.31-rc8 works OK, but I want a fix
for this one so that I can bisect another regression that occurs
between 2.6.29 and 2.6.31. If the device is plugged in when booting,
the system hangs.

==================================================================
BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffffa02c7ac6>] tda9887_set_params+0xb/0x26 [tda9887]
PGD 11ed14067 PUD 11ed13067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:04.1/usb4/4-1/4-1:1.1/bInterfaceClass
CPU 0
Modules linked in: tvp5150 em28xx(+) ir_common videobuf_vmalloc
videobuf_core binfmt_misc snd_pcm_oss snd_mixer_oss snd_seq nfs lockd
nfs_acl auth_rpcgss sunrpc cpufreq_conservative cpufreq_userspace
cpufreq_powersave powernow_k8 fuse xfs exportfs loop dm_mod ide_cd_mod
cdrom ide_gd_mod ata_generic pata_amd ide_pci_generic tuner_simple
tuner_types snd_cmipci tda9887 tda8290 gameport tuner snd_pcm msp3400
snd_page_alloc snd_opl3_lib snd_timer snd_hwdep usbhid snd_mpu401_uart
saa7115 hid snd_rawmidi snd_seq_device ivtv i2c_algo_bit cx2341x
v4l2_common videodev snd v4l1_compat v4l2_compat_ioctl32 tveeprom
i2c_nforce2 shpchp soundcore rtc_cmos usblp pci_hotplug forcedeth wmi
rtc_core amd74xx floppy button serio_raw pcspkr rtc_lib i2c_core
ide_core k8temp sg sd_mod crc_t10dif ehci_hcd ohci_hcd usbcore edd
ahci libata scsi_mod ext3 mbcache jbd fan thermal processor
thermal_sys hwmon
Pid: 3426, comm: modprobe Not tainted 2.6.30.5 #3 System Product Name
RIP: 0010:[<ffffffffa02c7ac6>]  [<ffffffffa02c7ac6>]
tda9887_set_params+0xb/0x26 [tda9887]
RSP: 0018:ffff88011edc9978  EFLAGS: 00010283
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88011edc9998 RDI: ffff8801206f7800
RBP: ffff88011edc99e8 R08: ffff88011edc9998 R09: 0000000000000001
R10: 0000000000000006 R11: 0000000000018600 R12: ffff8801206f7b80
R13: ffff8801206f7800 R14: 0000000000000000 R15: ffff8801206f7800
FS:  00007f073eb5c6f0(0000) GS:ffff880028022000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 000000011f869000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 3426, threadinfo ffff88011edc8000, task
ffff8801159e4500)
Stack:
 ffff88011edc99e8 ffffffffa02b3404 ffffffffa02b65fb 43ff88011edc0101
 00000002000002c0 0000000000000001 0000000000000000 0effffff8026336f
 ffffffffa0495cf2 ffffffffa0495cf2 ffff8801206f7800 ffff8801206f7b80
Call Trace:
 [<ffffffffa02b3404>] ? set_freq+0x23e/0x287 [tuner]
 [<ffffffffa0495cf2>] ? em28xx_tuner_callback+0x0/0x23 [em28xx]
 [<ffffffffa0495cf2>] ? em28xx_tuner_callback+0x0/0x23 [em28xx]
 [<ffffffffa02b501f>] set_type+0x684/0x96a [tuner]
 [<ffffffffa0219db0>] ? v4l2_i2c_new_probed_subdev+0xd0/0xf8 [v4l2_common]
 [<ffffffffa02b58df>] tuner_s_type_addr+0xa5/0xf6 [tuner]
 [<ffffffffa0495af6>] em28xx_card_setup+0x65f/0x85b [em28xx]
 [<ffffffffa04951c8>] ? em28xx_i2c_register+0x3c4/0x410 [em28xx]
 [<ffffffffa0495cf2>] ? em28xx_tuner_callback+0x0/0x23 [em28xx]
 [<ffffffffa0496878>] em28xx_usb_probe+0x581/0x741 [em28xx]
 [<ffffffffa00ed3be>] usb_probe_interface+0x114/0x16d [usbcore]
 [<ffffffff803e7483>] driver_probe_device+0x97/0x13c
 [<ffffffff803e7580>] __driver_attach+0x58/0x7b
 [<ffffffff803e7528>] ? __driver_attach+0x0/0x7b
 [<ffffffff803e6d56>] bus_for_each_dev+0x4e/0x84
 [<ffffffff803e72ff>] driver_attach+0x1c/0x1e
 [<ffffffff803e66ba>] bus_add_driver+0xf2/0x23b
 [<ffffffff803e785a>] driver_register+0xb3/0x121
 [<ffffffffa00ed159>] usb_register_driver+0x80/0xe4 [usbcore]
 [<ffffffffa0164000>] ? em28xx_module_init+0x0/0x4d [em28xx]
 [<ffffffffa0164023>] em28xx_module_init+0x23/0x4d [em28xx]
 [<ffffffff8020905c>] do_one_initcall+0x56/0x12b
 [<ffffffff80255baf>] ? __blocking_notifier_call_chain+0x58/0x6a
 [<ffffffff80264fd6>] sys_init_module+0xa9/0x1cd
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
Code: f5 ff ff 31 c0 c9 c3 48 8b 87 18 03 00 00 55 48 89 e5 c7 40 38
00 00 00 80 e8 9a f5 ff ff c9 c3 8b 46 04 48 8b 97 18 03 00 00 55 <89>
42 38 8b 46 08 48 89 e5 89 42 3c 48 8b 46 10 48 89 42 40 e8
RIP  [<ffffffffa02c7ac6>] tda9887_set_params+0xb/0x26 [tda9887]
 RSP <ffff88011edc9978>
CR2: 0000000000000038
---[ end trace 0976a22e013b4dfa ]---


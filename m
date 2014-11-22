Return-path: <linux-media-owner@vger.kernel.org>
Received: from wblv-ip-smtp-10-1.saix.net ([196.25.240.106]:37479 "EHLO
	wblv-ip-smtp-10-1.saix.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbaKVKXF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Nov 2014 05:23:05 -0500
Received: from [192.168.0.6] (ti-224-220-120.telkomadsl.co.za [105.224.220.120])
	by wblv-ip-smtp-10-1.saix.net (Postfix) with ESMTP id A65071E26
	for <linux-media@vger.kernel.org>; Sat, 22 Nov 2014 11:44:50 +0200 (SAST)
Message-ID: <54705B11.1030602@telkomsa.net>
Date: Sat, 22 Nov 2014 11:44:49 +0200
From: Martin Colley <qsolutions@telkomsa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Missdetected USB device
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I believe my USB card is being miss-detected. I am hoping the invite in 
my system logs to report this
via the V4L Mailing list is still open? I have searched forums for a 
solution, but have not found anything useful.

I am running Ubuntu 14.04.1

uname -a reports:
Linux james 3.13.0-39-generic #66-Ubuntu SMP Tue Oct 28 13:30:27 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux

The device is a Chronos USB Movie Grabber:
http://www.chronos.com.tw/Product/E/2/USB%20Movie%20Editor/USB%20Movie%20Editor.htm

Testing of the device with cheese and vlc is unsuccessful (cheese hangs, 
vlc shows no video but remains responsive).
Testing of these apps with a USB webcam is successful.
Testing of the device under windows on a different machine is successful.

syslog entries when the USB device is plugged in:

Nov 21 19:14:09 james kernel: [952932.084433] usb 2-1.6: new high-speed 
USB device number 10 using ehci-pci
Nov 21 19:14:09 james kernel: [952932.176773] usb 2-1.6: New USB device 
found, idVendor=eb1a, idProduct=2863
Nov 21 19:14:09 james kernel: [952932.176779] usb 2-1.6: New USB device 
strings: Mfr=0, Product=0, SerialNumber=0
Nov 21 19:14:09 james kernel: [952932.177168] em28xx: New device   @ 480 
Mbps (eb1a:2863, interface 0, class 0)
Nov 21 19:14:09 james kernel: [952932.177172] em28xx: Audio interface 0 
found (Vendor Class)
Nov 21 19:14:09 james kernel: [952932.177174] em28xx: Video interface 0 
found: isoc
Nov 21 19:14:09 james kernel: [952932.177260] em28xx: chip ID is em2860
Nov 21 19:14:09 james kernel: [952932.268734] em2860 #0: board has no eeprom
Nov 21 19:14:09 james kernel: [952932.340462] em2860 #0: No sensor detected
Nov 21 19:14:09 james kernel: [952932.374916] em2860 #0: found i2c 
device @ 0xb8 on bus 0 [tvp5150a]
Nov 21 19:14:09 james kernel: [952932.387785] em2860 #0: Your board has 
no unique USB ID.
Nov 21 19:14:09 james kernel: [952932.387788] em2860 #0: A hint were 
successfully done, based on i2c devicelist hash.
Nov 21 19:14:09 james kernel: [952932.387790] em2860 #0: This method is 
not 100% failproof.
Nov 21 19:14:09 james kernel: [952932.387791] em2860 #0: If the board 
were missdetected, please email this log to:
Nov 21 19:14:09 james kernel: [952932.387792] em2860 #0:     V4L Mailing 
List  <linux-media@vger.kernel.org>
Nov 21 19:14:09 james kernel: [952932.387794] em2860 #0: Board detected 
as EM2860/TVP5150 Reference Design
Nov 21 19:14:09 james kernel: [952932.464223] em2860 #0: Identified as 
EM2860/TVP5150 Reference Design (card=29)
Nov 21 19:14:10 james kernel: [952932.708718] tvp5150 6-005c: chip found 
@ 0xb8 (em2860 #0)
Nov 21 19:14:10 james kernel: [952932.708723] tvp5150 6-005c: tvp5150am1 
detected.
Nov 21 19:14:10 james kernel: [952932.796687] em2860 #0: Config register 
raw data: 0x10
Nov 21 19:14:10 james kernel: [952932.820306] em2860 #0: AC97 vendor ID 
= 0x83847650
Nov 21 19:14:10 james kernel: [952932.832150] em2860 #0: AC97 features = 
0x6a90
Nov 21 19:14:10 james kernel: [952932.832154] em2860 #0: Empia 202 AC97 
audio processor detected
Nov 21 19:14:12 james kernel: [952935.447452] em2860 #0: v4l2 driver 
version 0.2.0
Nov 21 19:14:14 james kernel: [952937.358984] em2860 #0: V4L2 video 
device registered as video0
Nov 21 19:14:14 james kernel: [952937.358989] em2860 #0: V4L2 VBI device 
registered as vbi0
Nov 21 19:14:14 james kernel: [952937.358993] em2860 #0: analog set to 
isoc mode.
Nov 21 19:14:14 james kernel: [952937.359084] em28xx-audio.c: probing 
for em28xx Audio Vendor Class
Nov 21 19:14:14 james kernel: [952937.359086] em28xx-audio.c: Copyright 
(C) 2006 Markus Rechberger
Nov 21 19:14:14 james kernel: [952937.359087] em28xx-audio.c: Copyright 
(C) 2007-2011 Mauro Carvalho Chehab
Nov 21 19:14:15 james mtp-probe: checking bus 2, device 10: 
"/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6"
Nov 21 19:14:15 james mtp-probe: bus: 2, device: 10 was not an MTP device

This is followed by multiple coppies of the following, which I believe 
is related:

Nov 21 19:14:23 james kernel: [952945.856318] ------------[ cut here 
]------------
Nov 21 19:14:23 james kernel: [952945.856329] WARNING: CPU: 2 PID: 23518 
at /build/buildd/linux-3.13.0/fs/sysfs/dir.c:486 sysfs_warn_dup+0x86/0xa0()
Nov 21 19:14:23 james kernel: [952945.856331] sysfs: cannot create 
duplicate filename 
'/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/ep_81'
Nov 21 19:14:23 james kernel: [952945.856332] Modules linked in: 
em28xx_alsa tvp5150 em28xx tveeprom v4l2_common videobuf2_vmalloc 
videobuf2_memops videobuf2_core videodev rfcomm bnep bluetooth joydev 
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm 
snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi parport_pc 
snd_seq ppdev snd_seq_device snd_timer lp snd parport intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm 
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 
lrw gf128mul glue_helper ablk_helper cryptd serio_raw i915 lpc_ich 
mei_me drm_kms_helper drm video i2c_algo_bit mei mac_hid soundcore 
intel_smartconnect hid_generic usbhid hid ahci libahci psmouse r8169 mii
Nov 21 19:14:23 james kernel: [952945.856383] CPU: 2 PID: 23518 Comm: 
pulseaudio Not tainted 3.13.0-39-generic #66-Ubuntu
Nov 21 19:14:23 james kernel: [952945.856385] Hardware name: To Be 
Filled By O.E.M. To Be Filled By O.E.M./H61M-VS3, BIOS P1.50 01/07/2013
Nov 21 19:14:23 james kernel: [952945.856388]  0000000000000009 
ffff88007a06d7d0 ffffffff8171ece7 ffff88007a06d818
Nov 21 19:14:23 james kernel: [952945.856392]  ffff88007a06d808 
ffffffff8106773d ffff8801f7f09000 ffff8801f7f09000
Nov 21 19:14:23 james kernel: [952945.856395]  ffff880100c86700 
ffff88007a06d910 0000000000000000 ffff88007a06d868
Nov 21 19:14:23 james kernel: [952945.856399] Call Trace:
Nov 21 19:14:23 james kernel: [952945.856405] [<ffffffff8171ece7>] 
dump_stack+0x45/0x56
Nov 21 19:14:23 james kernel: [952945.856409] [<ffffffff8106773d>] 
warn_slowpath_common+0x7d/0xa0
Nov 21 19:14:23 james kernel: [952945.856412] [<ffffffff810677ac>] 
warn_slowpath_fmt+0x4c/0x50
Nov 21 19:14:23 james kernel: [952945.856416] [<ffffffff81234976>] 
sysfs_warn_dup+0x86/0xa0
Nov 21 19:14:23 james kernel: [952945.856419] [<ffffffff812349d0>] 
sysfs_add_one+0x40/0x50
Nov 21 19:14:23 james kernel: [952945.856422] [<ffffffff81234b11>] 
create_dir+0x71/0xf0
Nov 21 19:14:23 james kernel: [952945.856425] [<ffffffff81234e43>] 
sysfs_create_dir_ns+0x73/0xc0
Nov 21 19:14:23 james kernel: [952945.856430] [<ffffffff81364c80>] 
kobject_add_internal+0xd0/0x330
Nov 21 19:14:23 james kernel: [952945.856435] [<ffffffff8101bb19>] ? 
sched_clock+0x9/0x10
Nov 21 19:14:23 james kernel: [952945.856439] [<ffffffff81365305>] 
kobject_add+0x65/0xb0
Nov 21 19:14:23 james kernel: [952945.856445] [<ffffffff81492b53>] ? 
device_private_init+0x23/0x80
Nov 21 19:14:23 james kernel: [952945.856449] [<ffffffff81492cd5>] 
device_add+0x125/0x640
Nov 21 19:14:23 james kernel: [952945.856453] [<ffffffff8149320a>] 
device_register+0x1a/0x20
Nov 21 19:14:23 james kernel: [952945.856458] [<ffffffff8154ddc1>] 
usb_create_ep_devs+0x81/0xd0
Nov 21 19:14:23 james kernel: [952945.856461] [<ffffffff815473d5>] ? 
usb_enable_endpoint+0x85/0x90
Nov 21 19:14:23 james kernel: [952945.856464] [<ffffffff81546739>] 
create_intf_ep_devs+0x59/0x80
Nov 21 19:14:23 james kernel: [952945.856467] [<ffffffff8154766a>] 
usb_set_interface+0x22a/0x360
Nov 21 19:14:23 james kernel: [952945.856473] [<ffffffffa02e9930>] 
snd_em28xx_capture_open+0x120/0x230 [em28xx_alsa]
Nov 21 19:14:23 james kernel: [952945.856481] [<ffffffffa036cb59>] 
snd_pcm_open_substream+0x59/0x110 [snd_pcm]
Nov 21 19:14:23 james kernel: [952945.856488] [<ffffffffa036ccc2>] 
snd_pcm_open+0xb2/0x250 [snd_pcm]
Nov 21 19:14:23 james kernel: [952945.856493] [<ffffffff8109a8d0>] ? 
wake_up_state+0x20/0x20
Nov 21 19:14:23 james kernel: [952945.856499] [<ffffffffa036cea3>] 
snd_pcm_capture_open+0x43/0x60 [snd_pcm]
Nov 21 19:14:23 james kernel: [952945.856505] [<ffffffffa030c5a4>] 
snd_open+0xb4/0x190 [snd]
Nov 21 19:14:23 james kernel: [952945.856510] [<ffffffff811c1b9f>] 
chrdev_open+0x9f/0x1d0
Nov 21 19:14:23 james kernel: [952945.856514] [<ffffffff811ba6e3>] 
do_dentry_open+0x233/0x2e0
Nov 21 19:14:23 james kernel: [952945.856516] [<ffffffff811c1b00>] ? 
cdev_put+0x30/0x30
Nov 21 19:14:23 james kernel: [952945.856519] [<ffffffff811baa19>] 
vfs_open+0x49/0x50
Nov 21 19:14:23 james kernel: [952945.856523] [<ffffffff811c95b4>] 
do_last+0x554/0x1200
Nov 21 19:14:23 james kernel: [952945.856529] [<ffffffff81312ecb>] ? 
apparmor_file_alloc_security+0x5b/0x180
Nov 21 19:14:23 james kernel: [952945.856532] [<ffffffff811cca3b>] 
path_openat+0xbb/0x640
Nov 21 19:14:23 james kernel: [952945.856536] [<ffffffff811cd1e9>] ? 
putname+0x29/0x40
Nov 21 19:14:23 james kernel: [952945.856540] [<ffffffff811cdd2f>] ? 
user_path_at_empty+0x5f/0x90
Nov 21 19:14:23 james kernel: [952945.856545] [<ffffffff811a25b6>] ? 
kmem_cache_alloc_trace+0x1c6/0x1f0
Nov 21 19:14:23 james kernel: [952945.856549] [<ffffffff811cde1a>] 
do_filp_open+0x3a/0x90
Nov 21 19:14:23 james kernel: [952945.856554] [<ffffffff811daca7>] ? 
__alloc_fd+0xa7/0x130
Nov 21 19:14:23 james kernel: [952945.856558] [<ffffffff811bc539>] 
do_sys_open+0x129/0x280
Nov 21 19:14:23 james kernel: [952945.856561] [<ffffffff811bc6ae>] 
SyS_open+0x1e/0x20
Nov 21 19:14:23 james kernel: [952945.856565] [<ffffffff8172f7ed>] 
system_call_fastpath+0x1a/0x1f
Nov 21 19:14:23 james kernel: [952945.856567] ---[ end trace 
407e8b9250899a01 ]---
Nov 21 19:14:23 james kernel: [952945.856570] ------------[ cut here 
]------------

Any assistance would be appreciated.

Thanks
Martin


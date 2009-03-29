Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail45.e.nsc.no ([193.213.115.45]:50707 "EHLO mail45.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbZC2StR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 14:49:17 -0400
Subject: gpsca kernel BUG when disconnecting camera while streaming with
 mmap (2.6.29-rc8)
From: Stian Skjelstad <stian@nixia.no>
To: moinejf@free.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 29 Mar 2009 19:25:03 +0200
Message-Id: <1238347504.5232.17.camel@laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb 2-2: new full speed USB device using uhci_hcd and address 47
usb 2-2: New USB device found, idVendor=041e, idProduct=4034
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: WebCam Instant 
usb 2-2: Manufacturer: Creative Labs  
usb 2-2: configuration #1 chosen from 1 choice
gspca: probing 041e:4034
zc3xx: probe sif 0x0007
zc3xx: probe sensor -> 0f
zc3xx: Find Sensor PAS106
gspca: probe ok
usb 2-2: USB disconnect, address 47
gspca: urb status: -108
gspca: urb status: -108
gspca: disconnect complete
BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<c02bc98e>] usb_set_interface+0x1e/0x1e0
*pde = 00000000 
Oops: 0000 [#1] PREEMPT 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Modules linked in: sd_mod usb_storage ipv6 cpufreq_ondemand acpi_cpufreq
ohci_hcd fuse gspca_zc3xx gspca_main videodev snd_intel8x0m snd_intel8x0
v4l1_compat snd_ac97_codec i915 ac97_bus snd_pcm intelfb snd_timer snd
ide_cd_mod cfbcopyarea yenta_socket rtc cfbimgblt uhci_hcd
snd_page_alloc rsrc_nonstatic e100 i2c_i801 cdrom rng_core cfbfillrect
pcmcia_core evdev

Pid: 8383, comm: gtkv4ltest Not tainted (2.6.29-rc8 #1) TravelMate 620  
EIP: 0060:[<c02bc98e>] EFLAGS: 00210282 CPU: 0
EIP is at usb_set_interface+0x1e/0x1e0
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: ffffff8f
ESI: 00000000 EDI: 00000000 EBP: ed9b26e0 ESP: cd68fd20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process gtkv4ltest (pid: 8383, ti=cd68e000 task=c2722ac0
task.ti=cd68e000)
Stack:
 c036e720 c04986e0 ed964b40 c2722ac0 c011dcdb c04987a0 c036e720 ed9b2000
 ed9b2000 ed9b26c8 ed9b26e0 f04981b8 ed9b2000 ed9b26c8 ed9b2000 f04989e5
 c86f96fc fffffe00 f0498aa1 f0498a20 f049a420 00000001 e6973880 f0484c75
Call Trace:
 [<c011dcdb>] check_preempt_wakeup+0xbb/0x150
 [<f04981b8>] gspca_set_alt0+0x18/0x50 [gspca_main]
 [<f04989e5>] gspca_stream_off+0x35/0x70 [gspca_main]
 [<f0498aa1>] vidioc_streamoff+0x81/0xe0 [gspca_main]
 [<f0498a20>] vidioc_streamoff+0x0/0xe0 [gspca_main]
 [<f0484c75>] __video_do_ioctl+0x1a25/0x3e40 [videodev]
 [<c01550cb>] find_lock_page+0x1b/0x70
 [<c0155717>] filemap_fault+0x137/0x4a0
 [<c01555e0>] filemap_fault+0x0/0x4a0
 [<c0167eda>] __do_fault+0x1aa/0x410
 [<c01555e0>] filemap_fault+0x0/0x4a0
 [<c0169bc2>] handle_mm_fault+0x162/0x630
 [<f04871c8>] video_ioctl2+0x138/0x330 [videodev]
 [<c017ea8d>] do_sync_read+0xcd/0x110
 [<f0487090>] video_ioctl2+0x0/0x330 [videodev]
 [<f04821f3>] v4l2_unlocked_ioctl+0x33/0x40 [videodev]
 [<f04821c0>] v4l2_unlocked_ioctl+0x0/0x40 [videodev]
 [<c018b95b>] vfs_ioctl+0x2b/0x90
 [<c018bb7b>] do_vfs_ioctl+0x7b/0x5d0
 [<c024bcf3>] tty_write+0x1a3/0x1e0
 [<c013e821>] getnstimeofday+0x51/0x120
 [<c013e821>] getnstimeofday+0x51/0x120
 [<c018c10d>] sys_ioctl+0x3d/0x70
 [<c0103371>] sysenter_do_call+0x12/0x25
 [<c0360000>] quirk_nopcipci+0x1a/0x3f
Code: 24 c3 8d 74 26 00 8d bc 27 00 00 00 00 83 ec 2c 89 5c 24 1c 89 c3
89 74 24 20 89 ce 89 7c 24 24 89 d7 ba 8f ff ff ff 89 6c 24 28 <83> 78
14 08 75 1c 89 d0 8b 5c 24 1c 8b 74 24 20 8b 7c 24 24 8b 
EIP: [<c02bc98e>] usb_set_interface+0x1e/0x1e0 SS:ESP 0068:cd68fd20
---[ end trace 082baebd8c6b9cd1 ]---

Stian Skjelstad



Return-path: <linux-media-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:39271 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbbFPGzB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 02:55:01 -0400
Received: from odpn1.odpn.net [212.40.96.53]
	by odpn1.odpn.net for linux-media@vger.kernel.org
	id 1Z4klu-00057z-JC; Tue, 16 Jun 2015 08:54:58 +0200
From: "Gabor Z. Papp" <gzpapp.lists@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: em28xx problem with 3.10-4.0
References: <x6d212hdgj@gzp>
Date: Tue, 16 Jun 2015 08:54:58 +0200
Message-ID: <x6d20wi1ml@gzp>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* "Gabor Z. Papp" <gzpapp.lists@gmail.com>:

| I would like to use my Pinnacle Dazzle DVC usb encoder with kernels
| 3.10-4.0, but I'm getting the same error all the time.

| Latest working kernel is the 3.4 line.

| What happend with the driver?

Should I provide more details than the dmesg output?

Linux video capture interface: v2.00
em28xx: New device Pinnacle Systems GmbH DVC100 @ 480 Mbps (2304:021a, interface 0, class 0)
em28xx: Video interface 0 found: bulk isoc
em28xx: chip ID is em2710/2820
em2710/2820 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0xe2ac7680
em2710/2820 #0: EEPROM info:
em2710/2820 #0:         AC97 audio (5 sample rates)
em2710/2820 #0:         300mA max power
em2710/2820 #0:         Table at offset 0x06, strings=0x1098, 0x2e6a, 0x0000
em2710/2820 #0: Identified as Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker / Kworld DVD Maker 2 / Plextor ConvertX PX-AV100U (card=9)
em2710/2820 #0: analog set to isoc mode.
em28xx audio device (2304:021a): interface 1, class 1
em28xx audio device (2304:021a): interface 2, class 1
usbcore: registered new interface driver em28xx
em2710/2820 #0: Registering V4L2 extension
saa7115 1-0025: saa7113 found @ 0x4a (em2710/2820 #0)
em2710/2820 #0: Config register raw data: 0x12
em2710/2820 #0: AC97 vendor ID = 0x83847650
em2710/2820 #0: AC97 features = 0x6a90
em2710/2820 #0: Empia 202 AC97 audio processor detected
em2710/2820 #0: V4L2 video device registered as video0
em2710/2820 #0: V4L2 extension successfully initialized
em28xx: Registered (Em28xx v4l2 Extension) extension
Linux agpgart interface v0.103
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ffmpeg: page allocation failure: order:6, mode:0xd0
CPU: 0 PID: 3721 Comm: ffmpeg 4.0.5-gzp1 #1
Hardware name: System manufacturer System Product Name/P5W64 WS Pro, BIOS 1201    10/01/2008
 00000000 c12e214e 00000001 c109221f c137382c f51ff478 00000006 000000d0
 00000001 000000d0 00000040 000000d0 c109419f 000000d0 00000006 00000000
 00000028 00000040 00000010 00000028 00000040 00000000 00000050 f51ff1c0
Call Trace:
 [<c12e214e>] ? dump_stack+0x3e/0x4e
 [<c109221f>] ? warn_alloc_failed+0xaf/0xf0
 [<c109419f>] ? __alloc_pages_nodemask+0x39f/0x5a0
 [<c10065ff>] ? dma_generic_alloc_coherent+0x8f/0xd0
 [<c1006570>] ? via_no_dac+0x40/0x40
 [<f8149a2b>] ? hcd_buffer_alloc+0xbb/0x140 [usbcore]
 [<f861f4e1>] ? em28xx_alloc_urbs+0x191/0x410 [em28xx]
 [<f8676ce6>] ? saa711x_writeregs+0x36/0x90 [saa7115]
 [<f861f842>] ? em28xx_init_usb_xfer+0x52/0x160 [em28xx]
 [<f86664f0>] ? em28xx_start_analog_streaming+0x230/0x410 [em28xx_v4l]
 [<f86640c0>] ? em28xx_wake_i2c+0xc0/0xc0 [em28xx_v4l]
 [<f8666123>] ? buffer_queue+0x53/0xb0 [em28xx_v4l]
 [<f864ee3e>] ? __buf_prepare+0x28e/0x300 [videobuf2_core]
 [<f864d1b2>] ? vb2_start_streaming+0x52/0x130 [videobuf2_core]
 [<f864f9fd>] ? vb2_internal_qbuf+0xcd/0x200 [videobuf2_core]
 [<f864f72f>] ? vb2_internal_streamon+0x10f/0x150 [videobuf2_core]
 [<f864f7cc>] ? vb2_ioctl_streamon+0xc/0x40 [videobuf2_core]
 [<f85e16e3>] ? v4l_streamon+0x13/0x20 [videodev]
 [<f85e3ea0>] ? __video_do_ioctl+0x230/0x2d0 [videodev]
 [<c10a748e>] ? __pte_alloc+0x1e/0x80
 [<f85e3a1f>] ? video_usercopy+0x19f/0x3d0 [videodev]
 [<c10de6f2>] ? inode_to_bdi+0x12/0x40
 [<c10ac4da>] ? vma_wants_writenotify+0x6a/0x80
 [<c10ac515>] ? vma_set_page_prot+0x25/0x50
 [<c10ad4c8>] ? mmap_region+0x138/0x4f0
 [<f85e3c5f>] ? video_ioctl2+0xf/0x20 [videodev]
 [<f85e3c70>] ? video_ioctl2+0x20/0x20 [videodev]
 [<f85e068d>] ? v4l2_ioctl+0xdd/0x120 [videodev]
 [<f85e05b0>] ? v4l2_open+0xe0/0xe0 [videodev]
 [<c10cdd3f>] ? do_vfs_ioctl+0x31f/0x540
 [<c10adb26>] ? do_mmap_pgoff+0x2a6/0x330
 [<c10a0766>] ? vm_mmap_pgoff+0x56/0x80
 [<c10cdf9c>] ? SyS_ioctl+0x3c/0x70
 [<c12e5ecc>] ? sysenter_do_call+0x12/0x12
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
CPU    2: hi:    0, btch:   1 usd:   0
CPU    3: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd: 167
CPU    3: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
CPU    2: hi:  186, btch:  31 usd:   0
CPU    3: hi:  186, btch:  31 usd:   0
active_anon:86766 inactive_anon:53673 isolated_anon:0
 active_file:67864 inactive_file:145211 isolated_file:0
 unevictable:0 dirty:3 writeback:0 unstable:0
 free:109849 slab_reclaimable:37567 slab_unreclaimable:4346
 mapped:20327 shmem:256 pagetables:748 bounce:0
 free_cma:0
DMA free:3504kB min:64kB low:80kB high:96kB active_anon:1448kB inactive_anon:1596kB active_file:5600kB inactive_file:2296kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15916kB mlocked:0kB dirty:0kB writeback:0kB mapped:824kB shmem:0kB slab_reclaimable:816kB slab_unreclaimable:164kB kernel_stack:0kB pagetables:24kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:20 all_unreclaimable? no
lowmem_reserve[]: 0 849 2009 2009
Normal free:44592kB min:3696kB low:4620kB high:5544kB active_anon:93048kB inactive_anon:98172kB active_file:209520kB inactive_file:227252kB unevictable:0kB isolated(anon):0kB isolated(file):128kB present:892920kB managed:870660kB mlocked:0kB dirty:12kB writeback:0kB mapped:31516kB shmem:640kB slab_reclaimable:149452kB slab_unreclaimable:17220kB kernel_stack:1832kB pagetables:1084kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:128 all_unreclaimable? no
lowmem_reserve[]: 0 0 9274 9274
HighMem free:391300kB min:512kB low:1772kB high:3032kB active_anon:252568kB inactive_anon:114924kB active_file:56336kB inactive_file:351168kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1187080kB managed:1187080kB mlocked:0kB dirty:0kB writeback:0kB mapped:48968kB shmem:384kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:1884kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 10*4kB (UEM) 3*8kB (EM) 1*16kB (R) 1*32kB (R) 1*64kB (R) 0*128kB 1*256kB (R) 0*512kB 1*1024kB (R) 1*2048kB (R) 0*4096kB = 3504kB
Normal: 1287*4kB (UEM) 1479*8kB (UEM) 800*16kB (EMR) 217*32kB (UEMR) 62*64kB (UEMR) 31*128kB (UER) 1*256kB (R) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 44916kB
HighMem: 5196*4kB (UMR) 7056*8kB (UMR) 4135*16kB (MR) 3278*32kB (MR) 1420*64kB (UMR) 300*128kB (UMR) 50*256kB (UMR) 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB = 391392kB
213287 total pagecache pages
11 pages in swap cache
Swap cache stats: add 323, delete 312, find 2/4
Free swap  = 1002812kB
Total swap = 1004056kB
523998 pages RAM
296770 pages HighMem/MovableOnly
5584 pages reserved
unable to allocate 165120 bytes for transfer buffer 3
------------[ cut here ]------------
WARNING: CPU: 0 PID: 3721 at drivers/media/v4l2-core/videobuf2-core.c:1765 vb2_start_streaming+0xbb/0x130 [videobuf2_core]()
Modules linked in: tun agpgart saa7115 em28xx_v4l videobuf2_core videobuf2_vmalloc videobuf2_memops em28xx v4l2_common videodev tveeprom coretemp w83627ehf hwmon_vid hwmon i2c_i801 i2c_core nfsd exportfs nfs lockd sunrpc grace snd_hda_codec_analog snd_hda_codec_generic e1000e ptp pps_core snd_hda_intel snd_hda_controller snd_hda_codec snd_pcm_oss snd_pcm snd_timer snd_mixer_oss snd soundcore usb_storage uhci_hcd ehci_pci ehci_hcd psmouse hid_generic usbhid hid usbcore usb_common
CPU: 0 PID: 3721 Comm: ffmpeg 4.0.5-gzp1 #1
Hardware name: System manufacturer System Product Name/P5W64 WS Pro, BIOS 1201    10/01/2008
 f86519c0 c12e214e 00000000 c1033f92 c136fbdc 00000000 00000e89 f86519c0
 000006e5 f864d21b f864d21b fffffff4 f59fed98 f59fecc8 f8668a80 c103405b
 00000009 00000000 f864d21b df046800 f864f9fd f59fecc8 40045612 f85f3308
Call Trace:
 [<c12e214e>] ? dump_stack+0x3e/0x4e
 [<c1033f92>] ? warn_slowpath_common+0x82/0xb0
 [<f864d21b>] ? vb2_start_streaming+0xbb/0x130 [videobuf2_core]
 [<f864d21b>] ? vb2_start_streaming+0xbb/0x130 [videobuf2_core]
 [<c103405b>] ? warn_slowpath_null+0x1b/0x20
 [<f864d21b>] ? vb2_start_streaming+0xbb/0x130 [videobuf2_core]
 [<f864f9fd>] ? vb2_internal_qbuf+0xcd/0x200 [videobuf2_core]
 [<f864f72f>] ? vb2_internal_streamon+0x10f/0x150 [videobuf2_core]
 [<f864f7cc>] ? vb2_ioctl_streamon+0xc/0x40 [videobuf2_core]
 [<f85e16e3>] ? v4l_streamon+0x13/0x20 [videodev]
 [<f85e3ea0>] ? __video_do_ioctl+0x230/0x2d0 [videodev]
 [<c10a748e>] ? __pte_alloc+0x1e/0x80
 [<f85e3a1f>] ? video_usercopy+0x19f/0x3d0 [videodev]
 [<c10de6f2>] ? inode_to_bdi+0x12/0x40
 [<c10ac4da>] ? vma_wants_writenotify+0x6a/0x80
 [<c10ac515>] ? vma_set_page_prot+0x25/0x50
 [<c10ad4c8>] ? mmap_region+0x138/0x4f0
 [<f85e3c5f>] ? video_ioctl2+0xf/0x20 [videodev]
 [<f85e3c70>] ? video_ioctl2+0x20/0x20 [videodev]
 [<f85e068d>] ? v4l2_ioctl+0xdd/0x120 [videodev]
 [<f85e05b0>] ? v4l2_open+0xe0/0xe0 [videodev]
 [<c10cdd3f>] ? do_vfs_ioctl+0x31f/0x540
 [<c10adb26>] ? do_mmap_pgoff+0x2a6/0x330
 [<c10a0766>] ? vm_mmap_pgoff+0x56/0x80
 [<c10cdf9c>] ? SyS_ioctl+0x3c/0x70
 [<c12e5ecc>] ? sysenter_do_call+0x12/0x12
---[ end trace ca7a232bb5d1ea90 ]---
------------[ cut here ]------------

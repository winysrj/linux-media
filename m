Return-path: <linux-media-owner@vger.kernel.org>
Received: from stonecot.demon.co.uk ([80.176.134.6]:58582 "EHLO
	ajax.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933550Ab2EXRIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 13:08:44 -0400
Received: from localhost (localhost [127.0.0.1])
	by ajax.localdomain (Postfix) with ESMTP id E1ECC32760B6
	for <linux-media@vger.kernel.org>; Thu, 24 May 2012 17:47:01 +0100 (BST)
Received: from ajax.localdomain ([127.0.0.1])
	by localhost (ajax.robnet [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MdyEx0nWd5r7 for <linux-media@vger.kernel.org>;
	Thu, 24 May 2012 17:47:00 +0100 (BST)
Received: from quatro.robnet (quatro [10.0.0.12])
	by ajax.localdomain (Postfix) with ESMTP id 204B232760B4
	for <linux-media@vger.kernel.org>; Thu, 24 May 2012 17:46:59 +0100 (BST)
From: Rob Murgatroyd <rob99@stonecot.co.uk>
To: linux-media@vger.kernel.org
Subject: Help requested, frame grabber stops working on Debian upgrade (Lenny to Squeeze)
Date: Thu, 24 May 2012 17:46:59 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201205241746.59559.rob99@stonecot.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Please could anyone try to assist with this problem with video capture after a 
system upgrade?

I have a frame grabber that has 8 BT878 (or very similar) chips on one card, 
also a V4L2 application that reads single frames from attached video cameras. 
I was using this set-up successfully under Debian 'Lenny' on a modest AMD 
system. As Lenny seems to be no longer supported I upgraded to 'Squeeze' 
using the aptitude manager which seemed to go fairly smoothly. 

Unfortunately post the upgrade I no longer see the 8 /dev/video[0-7] devices 
that were previously in the /dev directory. I was expecting them to appear 
automatically when the card was initialised but I also tried creating one 
manually which created the file but that was not readable by my app. 
(mknod /dev/video0 c 81 0)

I've Googled extensively but can't find anything that looks like this problem. 
I'd be very grateful if anyone was able to assist.

Rob Murgatroyd


This is the modprobe option list it needs to be able to see the card:
options i2c-algo-bit bit_test=1
options bttv gbuffers=32 card=102,102,102,102,102,102,102,102 tuner=0 coring=1 
full_luma_range=1 chroma_agc=1 pll=1 combfilter=1 triton1=0


Extract from the 'messages' log after it broke:
[   10.797179] Linux video capture interface: v2.00
[   11.259971] bttv: driver version 0.9.18 loaded
[   11.259976] bttv: using 32 buffers with 2080k (520 pages) each for capture
[   11.260426] bttv: Bt8xx card found (0).
[   11.260901] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   11.260917] bttv 0000:04:08.0: PCI INT A -> Link[APC3] -> GSI 18 (level, 
low) -> IRQ 18
[   11.260934] bttv0: Bt878 (rev 17) at 0000:04:08.0, irq: 18, latency: 32, 
mmio: 0xfdcff000
[   11.260984] bttv0: using: IVC-200 [card=102,insmod option]
[   11.260987] IRQ 18/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[   11.261059] bt878 #0 [sw]: bus seems to be busy
[   11.264545] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 23
[   11.264551] Intel ICH 0000:00:10.2: PCI INT C -> Link[APCJ] -> GSI 23 
(level, low) -> IRQ 23
[   11.596024] intel8x0_measure_ac97_clock: measured 54870 usecs (2696 
samples)
[   11.596028] intel8x0: clocking to 46892
[   12.064864] bttv0: tuner type=0
[   12.127363] *pde = 00000000
[   12.127404] Modules linked in: msp3400 snd_intel8x0 bttv(+) snd_ac97_codec 
ac97_bus v4l2_common snd_pcm videodev v4l1_compat snd_seq ir_
common videobuf_dma_sg videobuf_core btcx_risc tveeprom snd_timer 
snd_seq_device shpchp snd nouveau soundcore snd_page_alloc k8temp ttm 
drm_kms_helper pcspkr pci_hotplug serio_raw evdev parport_pc drm i2c_nforce2 
i2c_algo_bit i2c_core parport processor button ext3 jbd mbcache sg sr_mod 
cdrom usbhid hid sd_mod crc_t10dif ata_generic usb_storage pata_amd ohci_hcd 
fan sata_nv forcedeth thermal ehci_hcd libata floppy scsi_mod usbcore nls_base 
thermal_sys [last unloaded: scsi_wait_scan]
[   12.127660]
[   12.127670] Pid: 726, comm: modprobe Not tainted (2.6.32-5-686 #1)
[   12.127683] EIP: 0060:[<dcb84374>] EFLAGS: 00010246 CPU: 0
[   12.127700] EIP is at i2c_new_probed_device+0x22/0x133 [i2c_core]
[   12.127713] EAX: d48e383c EBX: d4931eac ECX: d4931eac EDX: 00000000
[   12.127725] ESI: d4931eac EDI: d48e383c EBP: d4931eac ESP: d4931d7c
[   12.127738]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   12.127770]  2b6ce215 d4931dfc ffffffff 00000092 00000000 00000001 00000092 
c1393118
[   12.127803] <0> 0000afab c1047882 b46116fa d48e383c b46116fa d48e383c 
d4931eac dee0eeeb
[   12.127839] <0> 00000009 ded43ed0 d48e3800 00000000 d4931dfc d4931e20 
00000009 ded44048
[   12.127893]  [<c1047882>] ? up+0x9/0x2a
[   12.128259]  [<ded43ed0>] ? v4l2_i2c_new_subdev_board+0x40/0x133 
[v4l2_common]
[   12.128866]  [<dee0b6cb>] ? bttv_init_card2+0x13fc/0x149a [bttv]
[   12.128866]  [<c126e107>] ? _cond_resched+0x25/0x3c
[   12.128866]  [<dcb9c0bb>] ? sclhi+0x3c/0x4d [i2c_algo_bit]
[   12.128866]  [<dcb9c313>] ? test_bus+0x126/0x140 [i2c_algo_bit]
[   12.128866]  [<dcb9c763>] ? i2c_bit_add_bus+0x1a/0x3b [i2c_algo_bit]
[   12.128866]  [<dee0bee7>] ? init_bttv_i2c+0x16f/0x1e3 [bttv]
[   12.128866]  [<dee09bd3>] ? bttv_probe+0x4d6/0x8e4 [bttv]
[   12.128866]  [<c11470e5>] ? local_pci_probe+0xb/0xc
[   12.128866]  [<c1147a2f>] ? pci_device_probe+0x41/0x63
[   12.128866]  [<c11b3c96>] ? driver_probe_device+0x8a/0x11e
[   12.128866]  [<c11b3d6a>] ? __driver_attach+0x40/0x5b
[   12.128866]  [<c11b36d9>] ? bus_for_each_dev+0x37/0x5f
[   12.128866]  [<c11b3b69>] ? driver_attach+0x11/0x13
[   12.128866]  [<c11b3d2a>] ? __driver_attach+0x0/0x5b
[   12.128866]  [<c11b31a1>] ? bus_add_driver+0x99/0x1c5
[   12.128866]  [<c11b3f9b>] ? driver_register+0x87/0xe0
[   12.128866]  [<c11b3803>] ? bus_create_file+0x33/0x39
[   12.128866]  [<c1147c00>] ? __pci_register_driver+0x33/0x89
[   12.128866]  [<dee19000>] ? bttv_init_module+0x0/0xcf [bttv]
[   12.128866]  [<dee190bb>] ? bttv_init_module+0xbb/0xcf [bttv]
[   12.128866]  [<c100113e>] ? do_one_initcall+0x55/0x155
[   12.128866]  [<c1057c4d>] ? sys_init_module+0xa7/0x1d7
[   12.128866]  [<c10030fb>] ? sysenter_do_call+0x12/0x28
[   12.176321] ---[ end trace bf8ca0abb9c14c4a ]---


Edited from lsmod after it broke:
Module                  Size  Used by
btcx_risc               2499  1 bttv 
bttv                  111899  1
i2c_algo_bit            3493  2 bttv,nouveau
i2c_core               12787  10 
msp3400,bttv,v4l2_common,videodev,tveeprom,nouveau,drm_kms_helper,drm,i2c_nforce2,i2c_algo_bit
ir_common              22187  1 bttv
tveeprom                9393  1 bttv
v4l1_compat            10250  1 videodev
v4l2_common             9820  2 msp3400,bttv
videobuf_core          10476  2 bttv,videobuf_dma_sg
videobuf_dma_sg         7203  1 bttv
videodev               25637  3 msp3400,bttv,v4l2_common


lspci after it broke:
04:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0a.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0b.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0b.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)
04:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture 
(rev 11)
04:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 
11)


>From the 'messages' log when it was working before the upgrade:
[   20.609930] Linux video capture interface: v2.00
[   20.658831] bttv: driver version 0.9.17 loaded
[   20.658836] bttv: using 32 buffers with 2080k (520 pages) each for capture
[   20.658892] bttv: Bt8xx card found (0).
[   20.659354] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   20.659366] ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [APC3] -> GSI 18 
(level, low) -> IRQ 18
[   20.659382] bttv0: Bt878 (rev 17) at 0000:04:08.0, irq: 18, latency: 32, 
mmio: 0xfdcff000
[   20.666228] bttv0: using: IVC-200 [card=102,insmod option]
[   20.666294] bt878 #0 [sw]: bus seems to be busy
[   21.464033] bttv0: tuner absent
[   21.464088] bttv0: registered device video0
[   21.464110] bttv0: registered device vbi0
[   21.464138] bttv0: PLL: 28636363 => 35468950 .. ok
[   21.496057] bttv: Bt8xx card found (1).
[   21.496511] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   21.496522] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [APC4] -> GSI 19 
(level, low) -> IRQ 19
[   21.496539] bttv1: Bt878 (rev 17) at 0000:04:09.0, irq: 19, latency: 32, 
mmio: 0xfdcfd000
[   21.496561] bttv1: using: IVC-200 [card=102,insmod option]
[   21.496625] bt878 #1 [sw]: bus seems to be busy
[   22.296039] bttv1: tuner absent
[   22.296105] bttv1: registered device video1
[   22.296128] bttv1: registered device vbi1
[   22.296156] bttv1: PLL: 28636363 => 35468950 .. ok
[   22.328043] bttv: Bt8xx card found (2).
[   22.328497] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
[   22.328507] ACPI: PCI Interrupt 0000:04:0a.0[A] -> Link [APC1] -> GSI 16 
(level, low) -> IRQ 16
[   22.328524] bttv2: Bt878 (rev 17) at 0000:04:0a.0, irq: 16, latency: 32, 
mmio: 0xfdcfb000
[   22.328543] bttv2: using: IVC-200 [card=102,insmod option]
[   22.328605] bt878 #2 [sw]: bus seems to be busy
etc. for the other chips.
-- 
Rob Murgatroyd
CDG Web Manager

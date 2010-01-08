Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0AHTPB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 14:15:01 -0500
Date: Fri, 8 Jan 2010 14:14:59 -0500
From: Ralph Siemsen <ralphs@netwinder.org>
To: linux-media@vger.kernel.org
Subject: cx23885 oops during loading, WinTV-HVR-1850 card
Message-ID: <20100108191459.GJ2257@harvey.netwinder.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I picked up an HVR-1800 but the box contained an 1850.  Encouraged by
other reports of success on this list, I plunged ahead and tried it.
However, the driver oopses during loading, and oddly, after that point
my terminal loses job control (can't ^C or ^Z anymore... weird.)

System is running Fedora 12 with kernel 2.6.31.9-174.fc12.i686.PAE.
Stock driver in fedora works, but does not reckognize the 1850.
Motherboard is an Intel DG45FC with a Core 2 Duo.

So I compiled v4l-dvb from HG against the fedora headers and loaded the
new modules, that's when the opps happens.  Details below.

I tried replacing only the cx23885.ko driver, as well as installing all
of the v4l-dvb drivers -- behaviour seemed to be the same.  With all
drivers installed, system bootup does not complete, udev hangs, but I
see the same kernel oops from cx23885.

Question: should I be trying this against vanilla kernel?  Or should I
try investigating the oops to see if I can figure out what's wrong?
Any other debug/diagnostics I can provide?

Thanks!
-Ralph


cx23885 driver version 0.0.2 loaded
cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
CORE cx23885[0]: subsystem: 0070:8541, board: Hauppauge WinTV-HVR1850 [card=24,autodetected]
tveeprom 6-0050: Hauppauge model 85021, rev C5F5, serial# 6396039
tveeprom 6-0050: MAC address is 00-0D-FE-61-98-87
tveeprom 6-0050: tuner model is NXP 18271C2 (idx 155, type 54)
tveeprom 6-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 6-0050: audio processor is CX23888 (idx 40)
tveeprom 6-0050: decoder processor is CX23888 (idx 34)
tveeprom 6-0050: has radio, has IR receiver, has no IR transmitter
cx23885[0]: hauppauge eeprom: model=85021
cx25840 8-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx25840 8-0044: firmware: requesting v4l-cx23885-avcore-01.fw
cx25840 8-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885[0]: registered device video0 [mpeg]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
tda18271 6-0060: creating new instance
TDA18271HD/C2 detected @ 6-0060
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xd0
cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 19, latency: 0, mmio: 0xff400000
cx23885 0000:02:00.0: setting latency timer to 64
IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
input: cx23885 IR (Hauppauge WinTV-HVR as /devices/pci0000:00/0000:00:1c.3/0000:02:00.0/input/input13
Creating IR device irrcv0
BUG: unable to handle kernel paging request at 72727563
IP: [<c05a4fd4>] strcmp+0xf/0x22
*pdpt = 0000000033195001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/module/i2c_core/initstate
Modules linked in: tda18271 s5h1411 cx25840 cx23885(+) ir_common ir_core fuse nfs lockd fscache nfs_acl auth_rpcgss coretemp sunrpc ipv6 cpufreq_ondemand acpi_cpufreq dm_multipath uinput snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer cx2341x videobuf_dma_sg v4l2_common snd videodev v4l1_compat soundcore videobuf_dvb i2c_i801 iTCO_wdt iTCO_vendor_support dvb_core videobuf_core btcx_risc tveeprom e1000e snd_page_alloc serio_raw i915 drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: cx23885]
Pid: 1778, comm: insmod Not tainted (2.6.31.9-174.fc12.i686.PAE #1)         
EIP: 0060:[<c05a4fd4>] EFLAGS: 00010286 CPU: 1
EIP is at strcmp+0xf/0x22
EAX: c08db475 EBX: f312c030 ECX: c050a5e0 EDX: 72727563
ESI: c08db4d3 EDI: 72727563 EBP: f39f3d34 ESP: f39f3d2c
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process insmod (pid: 1778, ti=f39f2000 task=f31472c0 task.ti=f39f2000)
Stack:
 72727563 f312c150 f39f3d44 c050a80f f312c150 f39f3d80 f39f3d54 c050a8f1
<0> f39f3d80 f312c150 f39f3d74 c050af25 f39f3d74 f39f3d80 f312c000 f39f3d80
<0> f312c150 fffffff4 f39f3d9c c050a48c f312c000 f312c000 00000000 00000000
Call Trace:
 [<c050a80f>] ? sysfs_find_dirent+0x1b/0x2c
 [<c050a8f1>] ? __sysfs_add_one+0x18/0x72
 [<c050af25>] ? sysfs_add_one+0x18/0xc2
 [<c050a48c>] ? sysfs_add_file_mode+0x4a/0x68
 [<c050c097>] ? internal_create_group+0xbd/0x122
 [<c050c123>] ? sysfs_create_group+0x11/0x16
 [<f883d79b>] ? ir_register_class+0x70/0xa2 [ir_core]
 [<f883d2a5>] ? ir_input_register+0x1ca/0x217 [ir_core]
 [<fd0f1916>] ? cx23888_ir_rx_s_parameters+0x283/0x28d [cx23885]
 [<c077a173>] ? mutex_lock+0x22/0x3c
 [<fd0f0fdd>] ? cx23885_input_init+0x241/0x27c [cx23885]
 [<fd0f3f0c>] ? cx23885_initdev+0xa40/0xa8c [cx23885]
 [<fd10f2fe>] ? cx25840_s_frequency+0x0/0x1c [cx25840]
 [<c05b1120>] ? local_pci_probe+0x13/0x15
 [<c05b1bbd>] ? pci_device_probe+0x48/0x6b
 [<c063cae2>] ? driver_probe_device+0xbc/0x1b8
 [<c063cc26>] ? __driver_attach+0x48/0x64
 [<c063c16b>] ? bus_for_each_dev+0x42/0x6c
 [<c063c8e0>] ? driver_attach+0x19/0x1b
 [<c063cbde>] ? __driver_attach+0x0/0x64
 [<c063c62f>] ? bus_add_driver+0xd0/0x211
 [<c059feb0>] ? kset_find_obj+0x23/0x4f
 [<c063ce7b>] ? driver_register+0x7e/0xe5
 [<c05b1d7f>] ? __pci_register_driver+0x3d/0x9a
 [<f887e000>] ? cx23885_init+0x0/0x29 [cx23885]
 [<f887e027>] ? cx23885_init+0x27/0x29 [cx23885]
 [<c040305b>] ? do_one_initcall+0x51/0x13f
 [<c0462f2a>] ? sys_init_module+0xac/0x1be
 [<c0408fbb>] ? sysenter_do_call+0x12/0x28
Code: c0 83 c9 ff f2 ae 4f 89 d1 49 78 06 ac aa 84 c0 75 f7 31 c0 aa 89 d8 5b 5e 5f 5d c3 55 89 e5 57 56 0f 1f 44 00 00 89 c6 89 d7 ac <ae> 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 5e 5f 5d c3 55 89 
EIP: [<c05a4fd4>] strcmp+0xf/0x22 SS:ESP 0068:f39f3d2c
CR2: 0000000072727563
---[ end trace bf0dbdfaa1a0eaec ]---



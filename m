Return-path: <linux-media-owner@vger.kernel.org>
Received: from emearegistrations.com ([209.190.30.226]:41600 "EHLO
	mx.emearegistrations.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0AUHww (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 02:52:52 -0500
Received: from HasBox.COM ([10.10.10.100])
	by mx.emearegistrations.com (8.14.3/8.13.7) with ESMTP id o0L7lPCj031157
	for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 02:47:26 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(authenticated bits=0)
	by HasBox.COM (8.14.2/8.13.8) with ESMTP id o0L7lG6u028548
	for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 11:47:16 +0400
Message-ID: <4B580684.8070004@0bits.com>
Date: Thu, 21 Jan 2010 11:47:16 +0400
From: dm66@0bits.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TT-Budget/S-1500 PCI crashes with current hg  (v4l-dvb-cdcf089168df)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My Technotrend S-1500 crashes everytime i load the drivers. This is on 
2.6.30.10 kernel with a 2 day old tip from mercurial repo on linuxtv.

Reverting back to an older build seems to succeed but i have other 
tuning problems. Looks like a prob in the infrared driver registration. 
Is there any way to disable the IR totally as this is a backend server 
in a mythtv config. Here's the panic/crash:

Thanks
D

Jan 21 10:33:54 home kernel: saa7146: unregister extension 'budget_ci dvb'.
Jan 21 10:33:54 home kernel: budget_ci dvb 0000:01:06.0: PCI INT A disabled
Jan 21 10:33:54 home kernel: saa7146: register extension 'budget_ci dvb'.
Jan 21 10:33:54 home kernel: budget_ci dvb 0000:01:06.0: PCI INT A -> 
Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jan 21 10:33:54 home kernel: IRQ 11/: IRQF_DISABLED is not guaranteed on 
shared IRQs
Jan 21 10:33:54 home kernel: saa7146: found saa7146 @ mem fb6b6c00 
(revision 1, irq 11) (0x13c2,0x1017).
Jan 21 10:33:54 home kernel: saa7146 (0): dma buffer size 192512
Jan 21 10:33:54 home kernel: DVB: registering new adapter 
(TT-Budget/S-1500 PCI)
Jan 21 10:33:54 home kernel: adapter has MAC addr = 00:d0:5c:07:98:02
Jan 21 10:33:54 home kernel: input: Budget-CI dvb ir receiver saa7146 
(0) as /devices/pci0000:00/0000:00:04.0/0000:01:06.0/
input/input6
Jan 21 10:33:54 home kernel: ------------[ cut here ]------------
Jan 21 10:33:54 home kernel: WARNING: at fs/sysfs/dir.c:487 
sysfs_add_one+0x92/0xb0()
Jan 21 10:33:54 home kernel: Hardware name: System Product Name
Jan 21 10:33:54 home kernel: sysfs: cannot create duplicate filename 
'/devices/virtual/irrcv/irrcv1'
Jan 21 10:33:54 home kernel: Modules linked in: budget_ci(+) budget_core 
saa7146 mac80211 cfg80211 btusb bluetooth tun snd_
pcm_oss snd_mixer_oss usb_storage uhci_hcd it87 hwmon_vid i2c_dev 
cx22702 isl6421 cx24116 cx88_dvb cx88_vp3054_i2c wm8775 v
ideobuf_dvb lnbp21 stv0299 tuner_simple tuner_types snd_hda_codec_analog 
tda9887 tda8290 tuner usblp cx8800 cx8802 cx88_als
a dvb_core cx88xx v4l2_common ir_common i2c_algo_bit snd_hda_intel 
ttpci_eeprom nvidia(P) videodev v4l1_compat tveeprom snd_hda_codec 
i2c_nforce2 ohci_hcd ehci_hcd floppy ir_core videobuf_dma_sg btcx_risc 
videobuf_core forcedeth i2c_core snd_pcm snd_timer snd snd_page_alloc 
[last unloaded: saa7146]
Jan 21 10:33:54 home kernel: Pid: 1350, comm: modprobe Tainted: P 
     2.6.30.10 #12
Jan 21 10:33:54 home kernel: Call Trace:
Jan 21 10:33:54 home kernel:  [<c01c8112>] ? sysfs_add_one+0x92/0xb0
Jan 21 10:33:54 home kernel:  [<c01c8112>] ? sysfs_add_one+0x92/0xb0
Jan 21 10:33:54 home kernel:  [<c012f0ef>] ? warn_slowpath_common+0x6f/0xd0
Jan 21 10:33:54 home kernel:  [<c01c8112>] ? sysfs_add_one+0x92/0xb0
Jan 21 10:33:54 home kernel:  [<c012f19b>] ? warn_slowpath_fmt+0x2b/0x30
Jan 21 10:33:54 home kernel:  [<c01c8112>] ? sysfs_add_one+0x92/0xb0
Jan 21 10:33:54 home kernel:  [<c01c8688>] ? create_dir+0x48/0x90
Jan 21 10:33:54 home kernel:  [<c01c86f9>] ? sysfs_create_dir+0x29/0x50
Jan 21 10:33:54 home kernel:  [<c0214262>] ? kobject_add_internal+0xc2/0x1b0
Jan 21 10:33:54 home kernel:  [<c02144dd>] ? kobject_add+0x2d/0x60
Jan 21 10:33:54 home kernel:  [<c0288cc7>] ? device_add+0xd7/0x550
Jan 21 10:33:54 home kernel:  [<c021c2a5>] ? kvasprintf+0x45/0x60
Jan 21 10:33:54 home kernel:  [<c0213f0a>] ? kobject_init+0x2a/0xa0
Jan 21 10:33:54 home kernel:  [<c02891f9>] ? device_create_vargs+0xa9/0xc0
Jan 21 10:33:54 home kernel:  [<c028923b>] ? device_create+0x2b/0x30
Jan 21 10:33:54 home kernel:  [<f891e9d6>] ? ir_register_class+0x66/0xd0 
[ir_core]
Jan 21 10:33:54 home kernel:  [<f891e265>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Jan 21 10:33:54 home kernel:  [<fb6ab252>] ? 
budget_ci_attach+0x1b2/0xce0 [budget_ci]
Jan 21 10:33:54 home kernel:  [<fb691ae7>] ? 
saa7146_init_one+0x807/0x8d0 [saa7146]
Jan 21 10:33:54 home kernel:  [<c0197d7d>] ? iput+0x1d/0x50
Jan 21 10:33:54 home kernel:  [<c01c83ca>] ? sysfs_addrm_finish+0x3a/0x1f0
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01c8eb2>] ? sysfs_do_create_link+0x92/0x110
Jan 21 10:33:54 home kernel:  [<c022964b>] ? local_pci_probe+0xb/0x10
Jan 21 10:33:54 home kernel:  [<c0229861>] ? pci_device_probe+0x61/0x80
Jan 21 10:33:54 home kernel:  [<c028ade5>] ? driver_probe_device+0x75/0x180
Jan 21 10:33:54 home kernel:  [<c02296c6>] ? pci_match_device+0x16/0xb0
Jan 21 10:33:54 home kernel:  [<c028af69>] ? __driver_attach+0x79/0x80
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028a789>] ? bus_for_each_dev+0x49/0x70
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028ac86>] ? driver_attach+0x16/0x20
Jan 21 10:33:54 home kernel:  [<c028aef0>] ? __driver_attach+0x0/0x80
Jan 21 10:33:54 home kernel:  [<c028a0cf>] ? bus_add_driver+0xaf/0x220
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028b1d7>] ? driver_register+0x67/0x150
Jan 21 10:33:54 home kernel:  [<c0229bed>] ? __pci_register_driver+0x3d/0xb0
Jan 21 10:33:54 home kernel:  [<fb6b2000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Jan 21 10:33:54 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Jan 21 10:33:54 home kernel:  [<c01565cb>] ? sys_init_module+0x8b/0x1c0
Jan 21 10:33:54 home kernel:  [<c0102d88>] ? sysenter_do_call+0x12/0x26
Jan 21 10:33:54 home kernel: ---[ end trace 83b91320ea1e2f27 ]---
Jan 21 10:33:54 home kernel: kobject_add_internal failed for irrcv1 with 
-EEXIST, don't try to register things with the same name in the same 
directory.
Jan 21 10:33:54 home kernel: Pid: 1350, comm: modprobe Tainted: P 
  W  2.6.30.10 #12
Jan 21 10:33:54 home kernel: Call Trace:
Jan 21 10:33:54 home kernel:  [<c02142a7>] ? 
kobject_add_internal+0x107/0x1b0
Jan 21 10:33:54 home kernel:  [<c02144dd>] ? kobject_add+0x2d/0x60
Jan 21 10:33:54 home kernel:  [<c0288cc7>] ? device_add+0xd7/0x550
Jan 21 10:33:54 home kernel:  [<c021c2a5>] ? kvasprintf+0x45/0x60
Jan 21 10:33:54 home kernel:  [<c0213f0a>] ? kobject_init+0x2a/0xa0
Jan 21 10:33:54 home kernel:  [<c02891f9>] ? device_create_vargs+0xa9/0xc0
Jan 21 10:33:54 home kernel:  [<c028923b>] ? device_create+0x2b/0x30
Jan 21 10:33:54 home kernel:  [<f891e9d6>] ? ir_register_class+0x66/0xd0 
[ir_core]
Jan 21 10:33:54 home kernel:  [<f891e265>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Jan 21 10:33:54 home kernel:  [<fb6ab252>] ? 
budget_ci_attach+0x1b2/0xce0 [budget_ci]
Jan 21 10:33:54 home kernel:  [<fb691ae7>] ? 
saa7146_init_one+0x807/0x8d0 [saa7146]
Jan 21 10:33:54 home kernel:  [<c0197d7d>] ? iput+0x1d/0x50
Jan 21 10:33:54 home kernel:  [<c01c83ca>] ? sysfs_addrm_finish+0x3a/0x1f0
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01c8eb2>] ? sysfs_do_create_link+0x92/0x110
Jan 21 10:33:54 home kernel:  [<c022964b>] ? local_pci_probe+0xb/0x10
Jan 21 10:33:54 home kernel:  [<c0229861>] ? pci_device_probe+0x61/0x80
Jan 21 10:33:54 home kernel:  [<c028ade5>] ? driver_probe_device+0x75/0x180
Jan 21 10:33:54 home kernel:  [<c02296c6>] ? pci_match_device+0x16/0xb0
Jan 21 10:33:54 home kernel:  [<c028af69>] ? __driver_attach+0x79/0x80
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028a789>] ? bus_for_each_dev+0x49/0x70
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028ac86>] ? driver_attach+0x16/0x20
Jan 21 10:33:54 home kernel:  [<c028aef0>] ? __driver_attach+0x0/0x80
Jan 21 10:33:54 home kernel:  [<c028a0cf>] ? bus_add_driver+0xaf/0x220
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028b1d7>] ? driver_register+0x67/0x150
Jan 21 10:33:54 home kernel:  [<c0229bed>] ? __pci_register_driver+0x3d/0xb0
Jan 21 10:33:54 home kernel:  [<fb6b2000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Jan 21 10:33:54 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Jan 21 10:33:54 home kernel:  [<c01565cb>] ? sys_init_module+0x8b/0x1c0
Jan 21 10:33:54 home kernel:  [<c0102d88>] ? sysenter_do_call+0x12/0x26
Jan 21 10:33:54 home kernel: BUG: unable to handle kernel paging request 
at fffffff7
Jan 21 10:33:54 home kernel: IP: [<f891e9db>] 
ir_register_class+0x6b/0xd0 [ir_core]
Jan 21 10:33:54 home kernel: *pdpt = 0000000000544001 *pde = 
0000000000547067 *pte = 0000000000000000
Jan 21 10:33:54 home kernel: Oops: 0000 [#1] SMP
Jan 21 10:33:54 home kernel: last sysfs file: 
/sys/devices/virtual/dmi/id/sys_vendor
Jan 21 10:33:54 home kernel: Modules linked in: budget_ci(+) budget_core 
saa7146 mac80211 cfg80211 btusb bluetooth tun snd_pcm_oss snd_mixer_oss 
usb_storage uhci_hcd it87 hwmon_vid i2c_dev cx22702 isl6421 cx24116 
cx88_dvb cx88_vp3054_i2c wm8775 videobuf_dvb lnbp21 stv0299 tuner_simple 
tuner_types snd_hda_codec_analog tda9887 tda8290 tuner usblp cx8800 
cx8802 cx88_alsa dvb_core cx88xx v4l2_common ir_common i2c_algo_bit 
snd_hda_intel ttpci_eeprom nvidia(P) videodev v4l1_compat tveeprom 
snd_hda_codec i2c_nforce2 ohci_hcd ehci_hcd floppy ir_core 
videobuf_dma_sg btcx_risc videobuf_core forcedeth i2c_core snd_pcm 
snd_timer snd snd_page_alloc [last unloaded: saa7146]
Jan 21 10:33:54 home kernel:
Jan 21 10:33:54 home kernel: Pid: 1350, comm: modprobe Tainted: P 
  W  (2.6.30.10 #12) System Product Name
Jan 21 10:33:54 home kernel: EIP: 0060:[<f891e9db>] EFLAGS: 00010292 CPU: 0
Jan 21 10:33:54 home kernel: EIP is at ir_register_class+0x6b/0xd0 [ir_core]
Jan 21 10:33:54 home kernel: EAX: ffffffef EBX: ffffffef ECX: c3812588 
EDX: 00000001
Jan 21 10:33:54 home kernel: ESI: 00000001 EDI: f7694980 EBP: f6946800 
ESP: f6f05d74
Jan 21 10:33:54 home kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Jan 21 10:33:54 home kernel: Process modprobe (pid: 1350, ti=f6f04000 
task=f6dd6d80 task.ti=f6f04000)
Jan 21 10:33:54 home kernel: Stack:
Jan 21 10:33:54 home kernel:  f7492240 00000000 00000000 f7694980 
f891ed46 00000001 00000000 f9e3eda0
Jan 21 10:33:54 home kernel:  f6946800 f9e41f78 f891e265 f6f05de8 
00000004 00000000 ffffffff f6946818
Jan 21 10:33:54 home kernel:  00000000 f7694980 00000027 f9e41e40 
f9e3eda0 f6c47100 f6946800 f6945000
Jan 21 10:33:54 home kernel: Call Trace:
Jan 21 10:33:54 home kernel:  [<f891e265>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Jan 21 10:33:54 home kernel:  [<fb6ab252>] ? 
budget_ci_attach+0x1b2/0xce0 [budget_ci]
Jan 21 10:33:54 home kernel:  [<fb691ae7>] ? 
saa7146_init_one+0x807/0x8d0 [saa7146]
Jan 21 10:33:54 home kernel:  [<c0197d7d>] ? iput+0x1d/0x50
Jan 21 10:33:54 home kernel:  [<c01c83ca>] ? sysfs_addrm_finish+0x3a/0x1f0
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01073f0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Jan 21 10:33:54 home kernel:  [<c01c8eb2>] ? sysfs_do_create_link+0x92/0x110
Jan 21 10:33:54 home kernel:  [<c022964b>] ? local_pci_probe+0xb/0x10
Jan 21 10:33:54 home kernel:  [<c0229861>] ? pci_device_probe+0x61/0x80
Jan 21 10:33:54 home kernel:  [<c028ade5>] ? driver_probe_device+0x75/0x180
Jan 21 10:33:54 home kernel:  [<c02296c6>] ? pci_match_device+0x16/0xb0
Jan 21 10:33:54 home kernel:  [<c028af69>] ? __driver_attach+0x79/0x80
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028a789>] ? bus_for_each_dev+0x49/0x70
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028ac86>] ? driver_attach+0x16/0x20
Jan 21 10:33:54 home kernel:  [<c028aef0>] ? __driver_attach+0x0/0x80
Jan 21 10:33:54 home kernel:  [<c028a0cf>] ? bus_add_driver+0xaf/0x220
Jan 21 10:33:54 home kernel:  [<c02297a0>] ? pci_device_remove+0x0/0x40
Jan 21 10:33:54 home kernel:  [<c028b1d7>] ? driver_register+0x67/0x150
Jan 21 10:33:54 home kernel:  [<c0229bed>] ? __pci_register_driver+0x3d/0xb0
Jan 21 10:33:54 home kernel:  [<fb6b2000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Jan 21 10:33:54 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Jan 21 10:33:54 home kernel:  [<c01565cb>] ? sys_init_module+0x8b/0x1c0
Jan 21 10:33:54 home kernel:  [<c0102d88>] ? sysenter_do_call+0x12/0x26
Jan 21 10:33:54 home kernel: Code: ed 91 f8 89 7c 24 0c 8b 85 04 07 00 
00 c7 44 24 04 00 00 00 00 89 44 24 08 a1 7c fb 91 f8 89 04 24 e8 3a a8 
96 c7 89 47 28 89 c3 <8b> 40 08 83 c3 08 c7 04 24 4e ed 91 f8 89 44 24 
04 e8 f4 c5 aa
Jan 21 10:33:54 home kernel: EIP: [<f891e9db>] 
ir_register_class+0x6b/0xd0 [ir_core] SS:ESP 0068:f6f05d74
Jan 21 10:33:54 home kernel: CR2: 00000000fffffff7
Jan 21 10:33:54 home kernel: ---[ end trace 83b91320ea1e2f28 ]---
Jan 21 10:33:54 home kernel:  [<fb6b2000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Jan 21 10:33:54 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Jan 21 10:33:54 home kernel:  [<c01565cb>] ? sys_init_module+0x8b/0x1c0
Jan 21 10:33:54 home kernel:  [<c0102d88>] ? sysenter_do_call+0x12/0x26
Jan 21 10:33:54 home kernel: Code: ed 91 f8 89 7c 24 0c 8b 85 04 07 00 
00 c7 44 24 04 00 00 00 00 89 44 24 08 a1 7c fb 91 f8 89 04 24 e8 3a a8 
96 c7 89 47 28 89 c3 <8b> 40 08 83 c3 08 c7 04 24 4e ed 91 f8 89 44 24 
04 e8 f4 c5 aa
Jan 21 10:33:54 home kernel: EIP: [<f891e9db>] 
ir_register_class+0x6b/0xd0 [ir_core] SS:ESP 0068:f6f05d74
Jan 21 10:33:54 home kernel: CR2: 00000000fffffff7
Jan 21 10:33:54 home kernel: ---[ end trace 83b91320ea1e2f28 ]---


Return-path: <linux-media-owner@vger.kernel.org>
Received: from emearegistrations.com ([209.190.30.226]:58285 "EHLO
	mx.emearegistrations.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab0BDIbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 03:31:13 -0500
Received: from HasBox.COM ([10.10.10.100])
	by mx.emearegistrations.com (8.14.3/8.13.7) with ESMTP id o148V67C029935
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 03:31:08 -0500
Received: from [12.0.0.2] ([12.0.0.2])
	(authenticated bits=0)
	by HasBox.COM (8.14.2/8.13.8) with ESMTP id o148Uu4H020393
	for <linux-media@vger.kernel.org>; Thu, 4 Feb 2010 12:30:59 +0400
Message-ID: <4B6A85BB.9050602@0bits.com>
Date: Thu, 04 Feb 2010 12:30:51 +0400
From: dm66@0bits.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Reloading DVB drivers causes 100% reproducible crash  
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've posted previously with this subject line [TT-Budget/S-1500 PCI 
crashes with current hg (v4l-dvb-cdcf089168df)] and have finally figured 
out what is happening.

If you remove your DVB drivers, and reload them, you will get a 100% 
reproducible crash with todays HG repository (i.e the bug is still in as 
of Feb 4th 2010).  Anyone with a budget_ci card with a ir will see this.

Dave
----

Feb  3 20:49:07 home kernel: cx8802_start_dma() Failed. Unsupported 
value in .mpeg (0x00000001)
Feb  3 20:49:38 home last message repeated 61 times
Feb  3 20:49:48 home last message repeated 21 times
Feb  3 20:49:52 home kernel: 
/usr/src/mythtv/vdr-sc/contrib/sasc-ng/dvbloopback/module/dvb_loopback.c: 
Unregistering ca loopback devices
Feb  3 20:49:52 home kernel: removing dvblb proc adapter
Feb  3 20:49:52 home kernel: dvblb init = 100
Feb  3 20:49:52 home kernel: removing dvblb proc adapter
Feb  3 20:49:52 home kernel: dvblb init = 100
Feb  3 20:50:08 home kernel: saa7146: unregister extension 'budget_ci dvb'.
Feb  3 20:50:08 home kernel: budget_ci dvb 0000:04:00.0: PCI INT A disabled
Feb  3 20:50:09 home kernel: cx8800 0000:04:02.0: PCI INT A disabled
Feb  3 20:50:09 home kernel: cx88/2: unregistering cx8802 driver, type: 
dvb access: shared
Feb  3 20:50:09 home kernel: cx88[0]/2: subsystem: 0070:6902, board: 
Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hybrid [card=68]
Feb  3 20:50:09 home kernel: cx88-mpeg driver manager 0000:04:02.2: PCI 
INT A disabled
Feb  3 20:50:14 home kernel: saa7146: register extension 'budget_ci dvb'.
Feb  3 20:50:14 home kernel: budget_ci dvb 0000:04:00.0: PCI INT A -> 
GSI 20 (level, low) -> IRQ 20
Feb  3 20:50:14 home kernel: IRQ 20/: IRQF_DISABLED is not guaranteed on 
shared IRQs
Feb  3 20:50:14 home kernel: saa7146: found saa7146 @ mem f9c1c000 
(revision 1, irq 20) (0x13c2,0x1017).
Feb  3 20:50:14 home kernel: saa7146 (0): dma buffer size 192512
Feb  3 20:50:14 home kernel: DVB: registering new adapter 
(TT-Budget/S-1500 PCI)
Feb  3 20:50:14 home kernel: adapter has MAC addr = 00:d0:5c:07:98:02
Feb  3 20:50:14 home kernel: input: Budget-CI dvb ir receiver saa7146 
(0) as /devices/pci0000:00/0000:00:1e.0/0000:04:00.0/input/input6
Feb  3 20:50:14 home kernel: ------------[ cut here ]------------
Feb  3 20:50:14 home kernel: WARNING: at fs/sysfs/dir.c:487 
sysfs_add_one+0x92/0xb0()
Feb  3 20:50:14 home kernel: Hardware name: EP41-UD3L
Feb  3 20:50:14 home kernel: sysfs: cannot create duplicate filename 
'/devices/virtual/irrcv/irrcv1'
Feb  3 20:50:14 home kernel: Modules linked in: budget_ci(+) budget_core 
ttpci_eeprom saa7146 stv0299 dvb_core lnbp21 rfcomm sco bridge stp bnep 
l2cap iptable_filter ip_tables x_tables appletalk psnap llc autofs4 nfsd 
lockd sunrpc exportfs mac80211 cfg80211 btusb bluetooth forcedeth tun 
snd_pcm_oss snd_mixer_oss usb_storage ohci_hcd it87 hwmon_vid i2c_dev 
wm8775 tuner_simple tuner_types tda9887 tuner cx88_alsa 
snd_hda_codec_realtek cx88xx usblp v4l2_common videodev v4l1_compat 
ir_common i2c_algo_bit snd_hda_intel snd_hda_codec tveeprom nvidia(P) 
videobuf_dma_sg videobuf_core btcx_risc ir_core snd_pcm snd_timer snd 
snd_page_alloc ehci_hcd i2c_i801 uhci_hcd i2c_core [last unloaded: dvb_core]
Feb  3 20:50:14 home kernel: Pid: 27084, comm: modprobe Tainted: P 
      2.6.30.10 #17
Feb  3 20:50:14 home kernel: Call Trace:
Feb  3 20:50:14 home kernel:  [<c01c8fe2>] ? sysfs_add_one+0x92/0xb0
Feb  3 20:50:14 home kernel:  [<c01c8fe2>] ? sysfs_add_one+0x92/0xb0
Feb  3 20:50:14 home kernel:  [<c012f2ef>] ? warn_slowpath_common+0x6f/0xd0
Feb  3 20:50:15 home kernel:  [<c01c8fe2>] ? sysfs_add_one+0x92/0xb0
Feb  3 20:50:15 home kernel:  [<c012f39b>] ? warn_slowpath_fmt+0x2b/0x30
Feb  3 20:50:15 home kernel:  [<c01c8fe2>] ? sysfs_add_one+0x92/0xb0
Feb  3 20:50:15 home kernel:  [<c01c9588>] ? create_dir+0x48/0x90
Feb  3 20:50:15 home kernel:  [<c01c95f9>] ? sysfs_create_dir+0x29/0x50
Feb  3 20:50:15 home kernel:  [<c0215282>] ? kobject_add_internal+0xc2/0x1b0
Feb  3 20:50:15 home kernel:  [<c02154fd>] ? kobject_add+0x2d/0x60
Feb  3 20:50:15 home kernel:  [<c0289c07>] ? device_add+0xd7/0x570
Feb  3 20:50:15 home kernel:  [<c0214f0a>] ? kobject_init+0x2a/0xa0
Feb  3 20:50:15 home kernel:  [<c021cdf5>] ? kvasprintf+0x45/0x60
Feb  3 20:50:15 home kernel:  [<c028a159>] ? device_create_vargs+0xa9/0xc0
Feb  3 20:50:15 home kernel:  [<c028a19b>] ? device_create+0x2b/0x30
Feb  3 20:50:15 home kernel:  [<f8933976>] ? ir_register_class+0x66/0xd0 
[ir_core]
Feb  3 20:50:15 home kernel:  [<f8933275>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Feb  3 20:50:15 home kernel:  [<f9c39292>] ? 
budget_ci_attach+0x1b2/0xcf0 [budget_ci]
Feb  3 20:50:15 home kernel:  [<f9beeb41>] ? 
saa7146_init_one+0x811/0x8e0 [saa7146]
Feb  3 20:50:15 home kernel:  [<c019895d>] ? iput+0x1d/0x50
Feb  3 20:50:15 home kernel:  [<c01c92aa>] ? sysfs_addrm_finish+0x3a/0x200
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01c9dd2>] ? sysfs_do_create_link+0x92/0x110
Feb  3 20:50:15 home kernel:  [<c022a20b>] ? local_pci_probe+0xb/0x10
Feb  3 20:50:15 home kernel:  [<c022a439>] ? pci_device_probe+0x69/0x90
Feb  3 20:50:15 home kernel:  [<c028bdad>] ? driver_probe_device+0x7d/0x180
Feb  3 20:50:15 home kernel:  [<c022a286>] ? pci_match_device+0x16/0xc0
Feb  3 20:50:15 home kernel:  [<c028bf29>] ? __driver_attach+0x79/0x80
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028b739>] ? bus_for_each_dev+0x49/0x70
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028bc46>] ? driver_attach+0x16/0x20
Feb  3 20:50:15 home kernel:  [<c028beb0>] ? __driver_attach+0x0/0x80
Feb  3 20:50:15 home kernel:  [<c028b04f>] ? bus_add_driver+0xaf/0x220
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028c1a7>] ? driver_register+0x67/0x150
Feb  3 20:50:15 home kernel:  [<c022a7ed>] ? __pci_register_driver+0x3d/0xb0
Feb  3 20:50:15 home kernel:  [<f9bd7000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Feb  3 20:50:15 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Feb  3 20:50:15 home kernel:  [<c0156d0b>] ? sys_init_module+0x8b/0x1c0
Feb  3 20:50:15 home kernel:  [<c0102dc8>] ? sysenter_do_call+0x12/0x26
Feb  3 20:50:15 home kernel: ---[ end trace efc2c91158d3f543 ]---
Feb  3 20:50:15 home kernel: kobject_add_internal failed for irrcv1 with 
-EEXIST, don't try to register things with the same name in the same 
directory.
Feb  3 20:50:15 home kernel: Pid: 27084, comm: modprobe Tainted: P 
   W  2.6.30.10 #17
Feb  3 20:50:15 home kernel: Call Trace:
Feb  3 20:50:15 home kernel:  [<c02152c7>] ? 
kobject_add_internal+0x107/0x1b0
Feb  3 20:50:15 home kernel:  [<c02154fd>] ? kobject_add+0x2d/0x60
Feb  3 20:50:15 home kernel:  [<c0289c07>] ? device_add+0xd7/0x570
Feb  3 20:50:15 home kernel:  [<c0214f0a>] ? kobject_init+0x2a/0xa0
Feb  3 20:50:15 home kernel:  [<c021cdf5>] ? kvasprintf+0x45/0x60
Feb  3 20:50:15 home kernel:  [<c028a159>] ? device_create_vargs+0xa9/0xc0
Feb  3 20:50:15 home kernel:  [<c028a19b>] ? device_create+0x2b/0x30
Feb  3 20:50:15 home kernel:  [<f8933976>] ? ir_register_class+0x66/0xd0 
[ir_core]
Feb  3 20:50:15 home kernel:  [<f8933275>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Feb  3 20:50:15 home kernel:  [<f9c39292>] ? 
budget_ci_attach+0x1b2/0xcf0 [budget_ci]
Feb  3 20:50:15 home kernel:  [<f9beeb41>] ? 
saa7146_init_one+0x811/0x8e0 [saa7146]
Feb  3 20:50:15 home kernel:  [<c019895d>] ? iput+0x1d/0x50
Feb  3 20:50:15 home kernel:  [<c01c92aa>] ? sysfs_addrm_finish+0x3a/0x200
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01c9dd2>] ? sysfs_do_create_link+0x92/0x110
Feb  3 20:50:15 home kernel:  [<c022a20b>] ? local_pci_probe+0xb/0x10
Feb  3 20:50:15 home kernel:  [<c022a439>] ? pci_device_probe+0x69/0x90
Feb  3 20:50:15 home kernel:  [<c028bdad>] ? driver_probe_device+0x7d/0x180
Feb  3 20:50:15 home kernel:  [<c022a286>] ? pci_match_device+0x16/0xc0
Feb  3 20:50:15 home kernel:  [<c028bf29>] ? __driver_attach+0x79/0x80
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028b739>] ? bus_for_each_dev+0x49/0x70
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028bc46>] ? driver_attach+0x16/0x20
Feb  3 20:50:15 home kernel:  [<c028beb0>] ? __driver_attach+0x0/0x80
Feb  3 20:50:15 home kernel:  [<c028b04f>] ? bus_add_driver+0xaf/0x220
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028c1a7>] ? driver_register+0x67/0x150
Feb  3 20:50:15 home kernel:  [<c022a7ed>] ? __pci_register_driver+0x3d/0xb0
Feb  3 20:50:15 home kernel:  [<f9bd7000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Feb  3 20:50:15 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Feb  3 20:50:15 home kernel:  [<c0156d0b>] ? sys_init_module+0x8b/0x1c0
Feb  3 20:50:15 home kernel:  [<c0102dc8>] ? sysenter_do_call+0x12/0x26
Feb  3 20:50:15 home kernel: BUG: unable to handle kernel paging request 
at fffffff7
Feb  3 20:50:15 home kernel: IP: [<f893397b>] 
ir_register_class+0x6b/0xd0 [ir_core]
Feb  3 20:50:15 home kernel: *pdpt = 000000000054c001 *pde = 
000000000054f067 *pte = 0000000000000000
Feb  3 20:50:15 home kernel: Oops: 0000 [#1] SMP
Feb  3 20:50:15 home kernel: last sysfs file: 
/sys/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/i2c-adapter/i2c-2/i2c-2/dev
Feb  3 20:50:15 home kernel: Modules linked in: budget_ci(+) budget_core 
ttpci_eeprom saa7146 stv0299 dvb_core lnbp21 rfcomm sco bridge stp bnep 
l2cap iptable_filter ip_tables x_tables appletalk psnap llc autofs4 nfsd 
lockd sunrpc exportfs mac80211 cfg80211 btusb bluetooth forcedeth tun 
snd_pcm_oss snd_mixer_oss usb_storage ohci_hcd it87 hwmon_vid i2c_dev 
wm8775 tuner_simple tuner_types tda9887 tuner cx88_alsa 
snd_hda_codec_realtek cx88xx usblp v4l2_common videodev v4l1_compat 
ir_common i2c_algo_bit snd_hda_intel snd_hda_codec tveeprom nvidia(P) 
videobuf_dma_sg videobuf_core btcx_risc ir_core snd_pcm snd_timer snd 
snd_page_alloc ehci_hcd i2c_i801 uhci_hcd i2c_core [last unloaded: dvb_core]
Feb  3 20:50:15 home kernel:
Feb  3 20:50:15 home kernel: Pid: 27084, comm: modprobe Tainted: P 
   W  (2.6.30.10 #17) EP41-UD3L
Feb  3 20:50:15 home kernel: EIP: 0060:[<f893397b>] EFLAGS: 00010292 CPU: 0
Feb  3 20:50:15 home kernel: EIP is at ir_register_class+0x6b/0xd0 [ir_core]
Feb  3 20:50:15 home kernel: EAX: ffffffef EBX: ffffffef ECX: c200c588 
EDX: 00000001
Feb  3 20:50:15 home kernel: ESI: 00000001 EDI: e76bf600 EBP: f6d66800 
ESP: c5d29d74
Feb  3 20:50:15 home kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb  3 20:50:15 home kernel: Process modprobe (pid: 27084, ti=c5d28000 
task=d4f61f80 task.ti=c5d28000)
Feb  3 20:50:15 home kernel: Stack:
Feb  3 20:50:15 home kernel:  f6e084c0 00000000 00000000 e76bf600 
f8933ce6 00000001 00000000 f9c2ade0
Feb  3 20:50:15 home kernel:  f6d66800 f9c2dfb8 f8933275 c5d29de8 
00000004 00000000 ffffffff f6d66818
Feb  3 20:50:15 home kernel:  00000000 e76bf600 00000027 f9c2de80 
f9c2ade0 f4663b00 f6d66800 f6daa000
Feb  3 20:50:15 home kernel: Call Trace:
Feb  3 20:50:15 home kernel:  [<f8933275>] ? 
ir_input_register+0x1b5/0x290 [ir_core]
Feb  3 20:50:15 home kernel:  [<f9c39292>] ? 
budget_ci_attach+0x1b2/0xcf0 [budget_ci]
Feb  3 20:50:15 home kernel:  [<f9beeb41>] ? 
saa7146_init_one+0x811/0x8e0 [saa7146]
Feb  3 20:50:15 home kernel:  [<c019895d>] ? iput+0x1d/0x50
Feb  3 20:50:15 home kernel:  [<c01c92aa>] ? sysfs_addrm_finish+0x3a/0x200
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01074b0>] ? 
dma_generic_alloc_coherent+0x0/0x110
Feb  3 20:50:15 home kernel:  [<c01c9dd2>] ? sysfs_do_create_link+0x92/0x110
Feb  3 20:50:15 home kernel:  [<c022a20b>] ? local_pci_probe+0xb/0x10
Feb  3 20:50:15 home kernel:  [<c022a439>] ? pci_device_probe+0x69/0x90
Feb  3 20:50:15 home kernel:  [<c028bdad>] ? driver_probe_device+0x7d/0x180
Feb  3 20:50:15 home kernel:  [<c022a286>] ? pci_match_device+0x16/0xc0
Feb  3 20:50:15 home kernel:  [<c028bf29>] ? __driver_attach+0x79/0x80
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028b739>] ? bus_for_each_dev+0x49/0x70
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028bc46>] ? driver_attach+0x16/0x20
Feb  3 20:50:15 home kernel:  [<c028beb0>] ? __driver_attach+0x0/0x80
Feb  3 20:50:15 home kernel:  [<c028b04f>] ? bus_add_driver+0xaf/0x220
Feb  3 20:50:15 home kernel:  [<c022a370>] ? pci_device_remove+0x0/0x40
Feb  3 20:50:15 home kernel:  [<c028c1a7>] ? driver_register+0x67/0x150
Feb  3 20:50:15 home kernel:  [<c022a7ed>] ? __pci_register_driver+0x3d/0xb0
Feb  3 20:50:15 home kernel:  [<f9bd7000>] ? budget_ci_init+0x0/0xa 
[budget_ci]
Feb  3 20:50:15 home kernel:  [<c010103e>] ? do_one_initcall+0x2e/0x190
Feb  3 20:50:15 home kernel:  [<c0156d0b>] ? sys_init_module+0x8b/0x1c0
Feb  3 20:50:15 home kernel:  [<c0102dc8>] ? sysenter_do_call+0x12/0x26
Feb  3 20:50:15 home kernel: Code: 3c 93 f8 89 7c 24 0c 8b 85 04 07 00 
00 c7 44 24 04 00 00 00 00 89 44 24 08 a1 fc 4a 93 f8 89 04 24 e8 fa 67 
95 c7 89 47 28 89 c3 <8b> 40 08 83 c3 08 89 44 24 04 c7 04 24 ee 3c 93 
f8 e8 24 b0 a9
Feb  3 20:50:15 home kernel: EIP: [<f893397b>] 
ir_register_class+0x6b/0xd0 [ir_core] SS:ESP 0068:c5d29d74
Feb  3 20:50:15 home kernel: CR2: 00000000fffffff7
Feb  3 20:50:15 home kernel: ---[ end trace efc2c91158d3f544 ]---
Feb  3 20:50:15 home kernel: cx88/2: cx2388x MPEG-TS Driver Manager 
version 0.0.7 loaded

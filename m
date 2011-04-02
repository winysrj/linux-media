Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50503 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab1DBTfB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 15:35:01 -0400
Received: by fxm17 with SMTP id 17so3230181fxm.19
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 12:35:00 -0700 (PDT)
Date: Sat, 2 Apr 2011 21:30:53 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: linux-media@vger.kernel.org
Subject: Skystar 2 2.6 broken in kernel 2.6.38
Message-ID: <20110402213053.716d0de7@grobi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi 

I just installed natty and found that one of the drivers i use is
broken. Is this a known issue ?


[    6.115925] ------------[ cut here ]------------
[    6.115931] WARNING: at /build/buildd/linux-2.6.38/fs/proc/generic.c:323 __xlate_proc_name+0xbb/0xd0()
[    6.115933] Hardware name: EP45T-UD3LR
[    6.115934] name 'Technisat/B2C2 FlexCop II/IIb/III Digital TV PCI Driver'
[    6.115935] Modules linked in: videobuf_dvb(+) b2c2_flexcop_pci(+) videobuf_core joydev v4l2_common b2c2_flexcop snd(+) dvb_core cx24123 cx24113 videodev btcx_risc soundcore s5h1420 tveeprom snd_page_alloc serio_raw sunrpc(+) lp parport hid_gyration usbhid hid r8169 pata_jmicron
[    6.115953] Pid: 518, comm: modprobe Tainted: P            2.6.38-7-generic #39-Ubuntu
[    6.115955] Call Trace:
[    6.115959]  [<c104f912>] ? warn_slowpath_common+0x72/0xa0
[    6.115962]  [<c1174a5b>] ? __xlate_proc_name+0xbb/0xd0
[    6.115964]  [<c1174a5b>] ? __xlate_proc_name+0xbb/0xd0
[    6.115967]  [<c104f9e3>] ? warn_slowpath_fmt+0x33/0x40
[    6.115970]  [<c1174a5b>] ? __xlate_proc_name+0xbb/0xd0
[    6.115973]  [<c1175101>] ? __proc_create+0x61/0x110
[    6.115975]  [<c11754b6>] ? proc_mkdir_mode+0x26/0x60
[    6.115978]  [<c1175504>] ? proc_mkdir+0x14/0x20
[    6.115981]  [<c10b2fbb>] ? register_handler_proc+0xeb/0x110
[    6.115984]  [<c10b0e37>] ? __setup_irq+0x1a7/0x2f0
[    6.115987]  [<c111a7ad>] ? kmem_cache_alloc_trace+0xdd/0x100
[    6.115989]  [<c10b0ff9>] ? request_threaded_irq+0x79/0x120
[    6.115992]  [<c10b0ff9>] ? request_threaded_irq+0x79/0x120
[    6.116012]  [<f18d6270>] ? flexcop_pci_isr+0x0/0x140 [b2c2_flexcop_pci]
[    6.116015]  [<c10b103c>] ? request_threaded_irq+0xbc/0x120
[    6.116018]  [<c127f5ce>] ? pci_iomap+0x9e/0xb0
[    6.116021]  [<f18d6214>] ? flexcop_pci_init+0xc4/0x120 [b2c2_flexcop_pci]
[    6.116025]  [<f18d6455>] ? flexcop_pci_probe+0xa5/0x1d0 [b2c2_flexcop_pci]
[    6.116028]  [<c1291d37>] ? local_pci_probe+0x47/0xb0
[    6.116030]  [<c12931b8>] ? pci_device_probe+0x68/0x90
[    6.116034]  [<c1333b0d>] ? really_probe+0x4d/0x150
[    6.116036]  [<c133bd7b>] ? pm_runtime_barrier+0x4b/0xb0
[    6.116039]  [<c1333dac>] ? driver_probe_device+0x3c/0x60
[    6.116041]  [<c1333e51>] ? __driver_attach+0x81/0x90
[    6.116043]  [<c1333dd0>] ? __driver_attach+0x0/0x90
[    6.116046]  [<c1332f08>] ? bus_for_each_dev+0x48/0x70
[    6.116048]  [<c1292bc0>] ? pci_device_remove+0x0/0xf0
[    6.116050]  [<c13339be>] ? driver_attach+0x1e/0x20
[    6.116052]  [<c1333dd0>] ? __driver_attach+0x0/0x90
[    6.116054]  [<c13335d8>] ? bus_add_driver+0xb8/0x250
[    6.116057]  [<c1292bc0>] ? pci_device_remove+0x0/0xf0
[    6.116059]  [<c1334096>] ? driver_register+0x66/0x110
[    6.116062]  [<c12922d5>] ? __pci_register_driver+0x45/0xb0
[    6.116065]  [<ef8aa017>] ? flexcop_pci_module_init+0x17/0x1000 [b2c2_flexcop_pci]
[    6.116068]  [<c1001255>] ? do_one_initcall+0x35/0x170
[    6.116070]  [<ef8aa000>] ? flexcop_pci_module_init+0x0/0x1000 [b2c2_flexcop_pci]
[    6.116074]  [<c108888b>] ? sys_init_module+0xdb/0x230
[    6.116077]  [<c1509904>] ? syscall_call+0x7/0xb
[    6.116079] ---[ end trace ea1b091448ed01ea ]---

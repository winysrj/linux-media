Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35804 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbcBAURG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2016 15:17:06 -0500
Received: by mail-wm0-f65.google.com with SMTP id l66so10712523wml.2
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2016 12:17:04 -0800 (PST)
Subject: Re: [PATCH 00/16] media: rc: nuvoton-cir: series with improvements
 and fixes
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <568408B0.5030507@gmail.com> <20160201090958.08577b5d@recife.lan>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <56AFBD32.2040205@gmail.com>
Date: Mon, 1 Feb 2016 21:16:50 +0100
MIME-Version: 1.0
In-Reply-To: <20160201090958.08577b5d@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.02.2016 um 12:09 schrieb Mauro Carvalho Chehab:
> Em Wed, 30 Dec 2015 17:39:12 +0100
> Heiner Kallweit <hkallweit1@gmail.com> escreveu:
> 
>> Heiner Kallweit (16):
>>   media: rc: nuvoton-cir: use request_muxed_region for accessing EFM registers
>>   media: rc: nuvoton-cir: simplify nvt_select_logical_ dev
>>   media: rc: nuvoton-cir: simplify nvt_cir_tx_inactive
>>   media: rc: nuvoton-cir: factor out logical device disabling
>>   media: rc: nuvoton-cir: factor out logical device enabling
>>   media: rc: nuvoton-cir: fix clearing wake fifo
>>   media: rc: nuvoton-cir: fix setting ioport base address
>>   media: rc: nuvoton-cir: remove unneeded EFM operation in nvt_cir_isr
>>   media: rc: nuvoton-cir: use IR_DEFAULT_TIMEOUT and consider SAMPLE_PERIOD
>>   media: rc: nuvoton-cir: improve nvt_hw_detect
>>   media: rc: nuvoton-cir: improve logical device handling
>>   media: rc: nuvoton-cir: remove unneeded call to nvt_set_cir_iren
>>   media: rc: nuvoton-cir: add locking to calls of nvt_enable_wake
>>   media: rc: nuvoton-cir: fix wakeup interrupt bits
>>   media: rc: nuvoton-cir: fix interrupt handling
>>   media: rc: nuvoton-cir: improve locking in both interrupt handlers
> 
> Not sure if this was caused by this patch series, but I'm getting those
> lockdep warnings from Kernel lockdep checks, during driver probe:
> 
> 
> [   23.698178] ------------[ cut here ]------------
> [   23.698675] WARNING: CPU: 3 PID: 385 at kernel/locking/lockdep.c:2755 lockdep_trace_alloc+0x24e/0x2a0()
> [   23.699264] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [   23.699546] Modules linked in:
> [   23.699897]  nuvoton_cir(+) rc_core dw_dmac video i2c_designware_platform dw_dmac_core i2c_designware_core acpi_pad button tpm_tis tpm ext4 crc16 mbcache jbd2 dm_mod sd_mod hid_generic usbhid ahci libahci libata e1000e ehci_pci scsi_mod xhci_pci ehci_hcd ptp pps_core xhci_hcd fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid
> [   23.701485] CPU: 3 PID: 385 Comm: systemd-udevd Not tainted 4.5.0-rc1+ #43
> [   23.701556] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [   23.701646]  ffffffff82468e20 ffff8803b94a7218 ffffffff81932007 ffff8803b94a7288
> [   23.701890]  ffff8803b94a7258 ffffffff8114e6c6 ffffffff8124962e ffffed0077294e4d
> [   23.702131]  0000000000000080 ffff8803c0701800 ffff8803c6407840 ffffffffa03dd180
> [   23.702371] Call Trace:
> [   23.702436]  [<ffffffff81932007>] dump_stack+0x4b/0x64
> [   23.702505]  [<ffffffff8114e6c6>] warn_slowpath_common+0xc6/0x120
> [   23.702577]  [<ffffffff8124962e>] ? lockdep_trace_alloc+0x24e/0x2a0
> [   23.702649]  [<ffffffff8114e7b4>] warn_slowpath_fmt+0x94/0xb0
> [   23.702720]  [<ffffffff8114e720>] ? warn_slowpath_common+0x120/0x120
> [   23.702793]  [<ffffffff8124962e>] lockdep_trace_alloc+0x24e/0x2a0
> [   23.702865]  [<ffffffff81559b96>] kmem_cache_alloc_trace+0x36/0x300
> [   23.702936]  [<ffffffff8115f8c6>] ? alloc_resource+0xc6/0x110
> [   23.703007]  [<ffffffff8115f8c6>] alloc_resource+0xc6/0x110
> [   23.703076]  [<ffffffff8115fb61>] __request_region+0xd1/0x440
> [   23.703145]  [<ffffffff8123fee8>] ? mark_held_locks+0xc8/0x120
> [   23.703216]  [<ffffffff8115fa90>] ? free_resource+0x180/0x180
> [   23.703286]  [<ffffffff8124034a>] ? trace_hardirqs_on_caller+0x40a/0x590
> [   23.703359]  [<ffffffff811d38f0>] ? wake_up_q+0xe0/0xe0
> [   23.703431]  [<ffffffffa03d8a58>] nvt_open+0xc8/0x230 [nuvoton_cir]
> [   23.703504]  [<ffffffffa07687e0>] rc_open+0xa0/0x120 [rc_core]
> [   23.703575]  [<ffffffffa0768897>] ir_open+0x37/0x50 [rc_core]
> [   23.703646]  [<ffffffff81df7ed2>] input_open_device+0x152/0x240
> [   23.703717]  [<ffffffff81c02a66>] kbd_connect+0xe6/0x130
> [   23.703787]  [<ffffffff81df9b9e>] input_attach_handler+0x4fe/0x780
> [   23.703857]  [<ffffffff81dfa969>] ? input_register_device+0x8b9/0xca0
> [   23.703929]  [<ffffffff81dfaa2b>] input_register_device+0x97b/0xca0
> [   23.704002]  [<ffffffffa076cdde>] rc_register_device+0xb1e/0x1450 [rc_core]
> [   23.704074]  [<ffffffff8115f9dc>] ? free_resource+0xcc/0x180
> [   23.704146]  [<ffffffffa076c2c0>] ? ir_setkeycode+0x300/0x300 [rc_core]
> [   23.704218]  [<ffffffff8116016e>] ? __release_region+0x16e/0x210
> [   23.704290]  [<ffffffffa03daec0>] nvt_probe+0xe90/0x26a0 [nuvoton_cir]
> [   23.704361]  [<ffffffff81b8fa70>] ? compare_pnp_id+0x90/0x210
> [   23.704433]  [<ffffffffa03da030>] ? nvt_tx_ir+0x3f0/0x3f0 [nuvoton_cir]
> [   23.704505]  [<ffffffff81b8fe05>] pnp_device_probe+0x125/0x1f0
> [   23.704575]  [<ffffffff81ce645a>] driver_probe_device+0x21a/0xc30
> [   23.704646]  [<ffffffff81ce6e70>] ? driver_probe_device+0xc30/0xc30
> [   23.704717]  [<ffffffff81ce6f91>] __driver_attach+0x121/0x160
> [   23.704786]  [<ffffffff81ce079f>] bus_for_each_dev+0x11f/0x1a0
> [   23.704856]  [<ffffffff81ce0680>] ? subsys_dev_iter_exit+0x10/0x10
> [   23.704930]  [<ffffffff822e5ed7>] ? _raw_spin_unlock+0x27/0x40
> [   23.705002]  [<ffffffff81ce52bd>] driver_attach+0x3d/0x50
> [   23.705071]  [<ffffffff81ce43d9>] bus_add_driver+0x4c9/0x770
> [   23.705141]  [<ffffffffa0078000>] ? 0xffffffffa0078000
> [   23.705209]  [<ffffffffa0078000>] ? 0xffffffffa0078000
> [   23.705278]  [<ffffffff81ce897c>] driver_register+0x18c/0x3b0
> [   23.705349]  [<ffffffff81b8f995>] pnp_register_driver+0x75/0xa0
> [   23.705421]  [<ffffffffa0078010>] nvt_driver_init+0x10/0x1000 [nuvoton_cir]
> [   23.705494]  [<ffffffff810021b1>] do_one_initcall+0x141/0x300
> [   23.705564]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [   23.705636]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
> [   23.705707]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
> [   23.705778]  [<ffffffff8155ea37>] ? __asan_register_globals+0x87/0xa0
> [   23.705851]  [<ffffffff8144da7b>] do_init_module+0x1d0/0x5ad
> [   23.705921]  [<ffffffff812f2626>] load_module+0x6666/0x9ba0
> [   23.705991]  [<ffffffff812e9c90>] ? symbol_put_addr+0x50/0x50
> [   23.706065]  [<ffffffff812ebfc0>] ? module_frob_arch_sections+0x20/0x20
> [   23.706136]  [<ffffffff815bc940>] ? open_exec+0x50/0x50
> [   23.706207]  [<ffffffff811671bb>] ? ns_capable+0x5b/0xd0
> [   23.706276]  [<ffffffff812f5e58>] SyS_finit_module+0x108/0x130
> [   23.706345]  [<ffffffff812f5d50>] ? SyS_init_module+0x1f0/0x1f0
> [   23.706416]  [<ffffffff81004044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [   23.706488]  [<ffffffff822e6936>] entry_SYSCALL_64_fastpath+0x16/0x76
> [   23.706559] ---[ end trace 896b438721a1342c ]---
> [   23.706626] BUG: sleeping function called from invalid context at mm/slub.c:1289
> [   23.706711] in_atomic(): 1, irqs_disabled(): 1, pid: 385, name: systemd-udevd
> [   23.706783] INFO: lockdep is turned off.
> [   23.706848] irq event stamp: 30062
> [   23.706911] hardirqs last  enabled at (30061): [<ffffffff822dd131>] mutex_lock_nested+0x581/0x860
> [   23.707041] hardirqs last disabled at (30062): [<ffffffff822e5d99>] _raw_spin_lock_irqsave+0x29/0x70
> [   23.707171] softirqs last  enabled at (29658): [<ffffffff8115c6a7>] __do_softirq+0x637/0x880
> [   23.707301] softirqs last disabled at (29569): [<ffffffff8115cbc2>] irq_exit+0x162/0x190
> [   23.707430] CPU: 3 PID: 385 Comm: systemd-udevd Tainted: G        W       4.5.0-rc1+ #43
> [   23.707517] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [   23.707607]  0000000000000000 ffff8803b94a72c0 ffffffff81932007 ffff8803c0701800
> [   23.707847]  ffff8803b94a72e8 ffffffff811c6a65 ffff8803c0701800 ffffffff8285d193
> [   23.708089]  0000000000000509 ffff8803b94a7328 ffffffff811c6c55 0000000000000046
> [   23.708328] Call Trace:
> [   23.708392]  [<ffffffff81932007>] dump_stack+0x4b/0x64
> [   23.708462]  [<ffffffff811c6a65>] ___might_sleep+0x245/0x3a0
> [   23.708533]  [<ffffffff811c6c55>] __might_sleep+0x95/0x1a0
> [   23.708603]  [<ffffffff81559d6e>] kmem_cache_alloc_trace+0x20e/0x300
> [   23.708675]  [<ffffffff8115f8c6>] ? alloc_resource+0xc6/0x110
> [   23.708746]  [<ffffffff8115f8c6>] alloc_resource+0xc6/0x110
> [   23.708816]  [<ffffffff8115fb61>] __request_region+0xd1/0x440
> [   23.708887]  [<ffffffff8123fee8>] ? mark_held_locks+0xc8/0x120
> [   23.708958]  [<ffffffff8115fa90>] ? free_resource+0x180/0x180
> [   23.709028]  [<ffffffff8124034a>] ? trace_hardirqs_on_caller+0x40a/0x590
> [   23.709101]  [<ffffffff811d38f0>] ? wake_up_q+0xe0/0xe0
> [   23.709173]  [<ffffffffa03d8a58>] nvt_open+0xc8/0x230 [nuvoton_cir]
> [   23.709246]  [<ffffffffa07687e0>] rc_open+0xa0/0x120 [rc_core]
> [   23.709317]  [<ffffffffa0768897>] ir_open+0x37/0x50 [rc_core]
> [   23.709388]  [<ffffffff81df7ed2>] input_open_device+0x152/0x240
> [   23.709460]  [<ffffffff81c02a66>] kbd_connect+0xe6/0x130
> [   23.709529]  [<ffffffff81df9b9e>] input_attach_handler+0x4fe/0x780
> [   23.709600]  [<ffffffff81dfa969>] ? input_register_device+0x8b9/0xca0
> [   23.709673]  [<ffffffff81dfaa2b>] input_register_device+0x97b/0xca0
> [   23.709745]  [<ffffffffa076cdde>] rc_register_device+0xb1e/0x1450 [rc_core]
> [   23.709818]  [<ffffffff8115f9dc>] ? free_resource+0xcc/0x180
> [   23.709890]  [<ffffffffa076c2c0>] ? ir_setkeycode+0x300/0x300 [rc_core]
> [   23.709962]  [<ffffffff8116016e>] ? __release_region+0x16e/0x210
> [   23.710034]  [<ffffffffa03daec0>] nvt_probe+0xe90/0x26a0 [nuvoton_cir]
> [   23.710107]  [<ffffffff81b8fa70>] ? compare_pnp_id+0x90/0x210
> [   23.710179]  [<ffffffffa03da030>] ? nvt_tx_ir+0x3f0/0x3f0 [nuvoton_cir]
> [   23.710251]  [<ffffffff81b8fe05>] pnp_device_probe+0x125/0x1f0
> [   23.710322]  [<ffffffff81ce645a>] driver_probe_device+0x21a/0xc30
> [   23.710394]  [<ffffffff81ce6e70>] ? driver_probe_device+0xc30/0xc30
> [   23.710465]  [<ffffffff81ce6f91>] __driver_attach+0x121/0x160
> [   23.710535]  [<ffffffff81ce079f>] bus_for_each_dev+0x11f/0x1a0
> [   23.710605]  [<ffffffff81ce0680>] ? subsys_dev_iter_exit+0x10/0x10
> [   23.710677]  [<ffffffff822e5ed7>] ? _raw_spin_unlock+0x27/0x40
> [   23.710748]  [<ffffffff81ce52bd>] driver_attach+0x3d/0x50
> [   23.710817]  [<ffffffff81ce43d9>] bus_add_driver+0x4c9/0x770
> [   23.710888]  [<ffffffffa0078000>] ? 0xffffffffa0078000
> [   23.710957]  [<ffffffffa0078000>] ? 0xffffffffa0078000
> [   23.711025]  [<ffffffff81ce897c>] driver_register+0x18c/0x3b0
> [   23.711096]  [<ffffffff81b8f995>] pnp_register_driver+0x75/0xa0
> [   23.711168]  [<ffffffffa0078010>] nvt_driver_init+0x10/0x1000 [nuvoton_cir]
> [   23.711241]  [<ffffffff810021b1>] do_one_initcall+0x141/0x300
> [   23.711312]  [<ffffffff81002070>] ? try_to_run_init_process+0x40/0x40
> [   23.711383]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
> [   23.711452]  [<ffffffff8155e926>] ? kasan_unpoison_shadow+0x36/0x50
> [   23.711523]  [<ffffffff8155ea37>] ? __asan_register_globals+0x87/0xa0
> [   23.711596]  [<ffffffff8144da7b>] do_init_module+0x1d0/0x5ad
> [   23.711667]  [<ffffffff812f2626>] load_module+0x6666/0x9ba0
> [   23.711738]  [<ffffffff812e9c90>] ? symbol_put_addr+0x50/0x50
> [   23.711812]  [<ffffffff812ebfc0>] ? module_frob_arch_sections+0x20/0x20
> [   23.711884]  [<ffffffff815bc940>] ? open_exec+0x50/0x50
> [   23.711954]  [<ffffffff811671bb>] ? ns_capable+0x5b/0xd0
> [   23.712024]  [<ffffffff812f5e58>] SyS_finit_module+0x108/0x130
> [   23.712094]  [<ffffffff812f5d50>] ? SyS_init_module+0x1f0/0x1f0
> [   23.712165]  [<ffffffff81004044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [   23.712236]  [<ffffffff822e6936>] entry_SYSCALL_64_fastpath+0x16/0x76
> [   23.714473] rc rc0: Nuvoton w836x7hg Infrared Remote Transceiver as /devices/pnp0/00:01/rc/rc0
> [   23.721465] nuvoton-cir 00:01: driver has been successfully loaded
> 
> Could you please check?
> 
Good catch. Reason is commit "use request_muxed_region for accessing EFM registers".
Using request_muxed_region is needed but we have to consider that it may sleep.
And currently it's partially called while holding a spinlock.

I'll provide patches to fix this.

Regards, Heiner

> Thanks!
> Mauro
> 


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52993 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbbKKPtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 10:49:18 -0500
Subject: Re: Slow path and cpu lock warnings - MC Next Gen
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <5640C0F2.9070000@osg.samsung.com>
 <5640C1DA.7040100@osg.samsung.com> <20151111103053.448ac440@recife.lan>
 <56434F37.9070007@osg.samsung.com> <20151111133610.0d2f0923@recife.lan>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5643637C.3010205@osg.samsung.com>
Date: Wed, 11 Nov 2015 08:49:16 -0700
MIME-Version: 1.0
In-Reply-To: <20151111133610.0d2f0923@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2015 08:36 AM, Mauro Carvalho Chehab wrote:
> Em Wed, 11 Nov 2015 07:22:47 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 11/11/2015 05:30 AM, Mauro Carvalho Chehab wrote:
>>> Em Mon, 09 Nov 2015 08:55:06 -0700
>>> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
>>>
>>>> On 11/09/2015 08:51 AM, Shuah Khan wrote:
>>>>> As I mentioned on the IRC, here is the log for the problems I am seeing.
>>>>> I have to do eject HVR 950Q TV stick to see the problem.
>>>>>
>>>>> mc_next_gen.v8.4 branch with no changes.
>>>>>
>>>>> I can test and debug this week.
>>>>>
>>>>> thanks,
>>>>> -- Shuah
>>>>>   
>>>>
>>>> Forgot to cc linux-media, just in case others are interested
>>>> and have ideas on debugging.
>>>>
>>>> thanks,
>>>> -- Shuah
>>>
>>>> [    8.558049] ======================================================
>>>> [    8.558056] [ INFO: possible circular locking dependency detected ]
>>>> [    8.558063] 4.2.0-rc2+ #21 Not tainted
>>>> [    8.558070] -------------------------------------------------------
>>>> [    8.558077] systemd-udevd/143 is trying to acquire lock:
>>>> [    8.558084]  (init_mutex){+.+.+.}, at: [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>>>> [    8.558104] 
>>>>                but task is already holding lock:
>>>> [    8.558114]  (&(&backlight_notifier)->rwsem){++++..}, at: [<ffffffff8107fc49>] __blocking_notifier_call_chain+0x39/0x70
>>>> [    8.558133] 
>>>>                which lock already depends on the new lock.
>>>>
>>>> [    8.558147] 
>>>>                the existing dependency chain (in reverse order) is:
>>>> [    8.558158] 
>>>>                -> #1 (&(&backlight_notifier)->rwsem){++++..}:  
>>>> [    8.558170]        [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>>>> [    8.558180]        [<ffffffff817fb006>] down_write+0x36/0x70
>>>> [    8.558189]        [<ffffffff8107fdc1>] blocking_notifier_chain_register+0x21/0xb0
>>>> [    8.558202]        [<ffffffff81424c98>] backlight_register_notifier+0x18/0x20
>>>> [    8.558212]        [<ffffffffa0002019>] acpi_video_get_backlight_type+0xfa/0x163 [video]
>>>> [    8.558225]        [<ffffffffa000167e>] acpi_video_bus_add+0x686/0xdfa [video]
>>>> [    8.558237]        [<ffffffff814371b0>] acpi_device_probe+0x50/0xf7
>>>> [    8.558247]        [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>>>> [    8.558257]        [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>>>> [    8.558266]        [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>>>> [    8.558275]        [<ffffffff814daece>] driver_attach+0x1e/0x20
>>>> [    8.558287]        [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>>>> [    8.558296]        [<ffffffff814dc280>] driver_register+0x60/0xe0
>>>> [    8.558304]        [<ffffffff81437936>] acpi_bus_register_driver+0x3b/0x43
>>>> [    8.558313]        [<ffffffffa0000328>] acpi_video_register+0x6e/0x90 [video]
>>>> [    8.558322]        [<ffffffffa000b087>] hid_generic_exit+0x87/0x1000 [hid_generic]
>>>> [    8.558334]        [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>>>> [    8.558344]        [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>>>> [    8.558353]        [<ffffffff810f1900>] load_module+0x2170/0x2780
>>>> [    8.558363]        [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>>>> [    8.558372]        [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>>>> [    8.558381] 
>>>>                -> #0 (init_mutex){+.+.+.}:  
>>>> [    8.558392]        [<ffffffff810aff59>] __lock_acquire+0x1f29/0x1f90
>>>> [    8.558401]        [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>>>> [    8.558409]        [<ffffffff817f9ceb>] mutex_lock_nested+0x4b/0x340
>>>> [    8.558417]        [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>>>> [    8.558430]        [<ffffffffa00020ba>] acpi_video_backlight_notify+0x19/0x2f [video]
>>>> [    8.558442]        [<ffffffff8107faad>] notifier_call_chain+0x5d/0x80
>>>> [    8.558451]        [<ffffffff8107fc61>] __blocking_notifier_call_chain+0x51/0x70
>>>> [    8.558462]        [<ffffffff8107fc96>] blocking_notifier_call_chain+0x16/0x20
>>>> [    8.558474]        [<ffffffff81424ff2>] backlight_device_register+0x1a2/0x260
>>>> [    8.558483]        [<ffffffffa02af70a>] radeon_atom_backlight_init+0xda/0x1d0 [radeon]
>>>> [    8.558543]        [<ffffffffa0254713>] radeon_link_encoder_connector+0xc3/0x130 [radeon]
>>>> [    8.558585]        [<ffffffffa0232b06>] radeon_get_atom_connector_info_from_object_table+0x3a6/0x950 [radeon]
>>>> [    8.558625]        [<ffffffffa0257e4c>] radeon_modeset_init+0x5dc/0xa40 [radeon]
>>>> [    8.558667]        [<ffffffffa0230b0b>] radeon_driver_load_kms+0x12b/0x220 [radeon]
>>>> [    8.558706]        [<ffffffffa0033281>] drm_dev_register+0xb1/0x100 [drm]
>>>> [    8.558728]        [<ffffffffa003605d>] drm_get_pci_dev+0x8d/0x1e0 [drm]
>>>> [    8.558747]        [<ffffffffa022c404>] radeon_pci_probe+0xa4/0xc0 [radeon]
>>>> [    8.558783]        [<ffffffff813f3715>] local_pci_probe+0x45/0xa0
>>>> [    8.558792]        [<ffffffff813f4911>] pci_device_probe+0xd1/0x120
>>>> [    8.558800]        [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>>>> [    8.558809]        [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>>>> [    8.558818]        [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>>>> [    8.558827]        [<ffffffff814daece>] driver_attach+0x1e/0x20
>>>> [    8.558835]        [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>>>> [    8.558844]        [<ffffffff814dc280>] driver_register+0x60/0xe0
>>>> [    8.558852]        [<ffffffff813f2fd4>] __pci_register_driver+0x64/0x70
>>>> [    8.558860]        [<ffffffffa0036290>] drm_pci_init+0xe0/0x110 [drm]
>>>> [    8.558879]        [<ffffffffa039d09d>] radeon_init+0x9d/0xb2 [radeon]
>>>> [    8.558911]        [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>>>> [    8.558920]        [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>>>> [    8.558928]        [<ffffffff810f1900>] load_module+0x2170/0x2780
>>>> [    8.558937]        [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>>>> [    8.558945]        [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>>>> [    8.558954] 
>>>>                other info that might help us debug this:
>>>>
>>>> [    8.558968]  Possible unsafe locking scenario:
>>>>
>>>> [    8.558978]        CPU0                    CPU1
>>>> [    8.558984]        ----                    ----
>>>> [    8.558989]   lock(&(&backlight_notifier)->rwsem);
>>>> [    8.558997]                                lock(init_mutex);
>>>> [    8.559004]                                lock(&(&backlight_notifier)->rwsem);
>>>> [    8.559015]   lock(init_mutex);
>>>> [    8.559021] 
>>>>                 *** DEADLOCK ***
>>>>
>>>> [    8.559035] 4 locks held by systemd-udevd/143:
>>>> [    8.559041]  #0:  (&dev->mutex){......}, at: [<ffffffff814db99b>] __driver_attach+0x4b/0xa0
>>>> [    8.559056]  #1:  (&dev->mutex){......}, at: [<ffffffff814db9a9>] __driver_attach+0x59/0xa0
>>>> [    8.559072]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffffa00331f6>] drm_dev_register+0x26/0x100 [drm]
>>>> [    8.559097]  #3:  (&(&backlight_notifier)->rwsem){++++..}, at: [<ffffffff8107fc49>] __blocking_notifier_call_chain+0x39/0x70
>>>> [    8.559113] 
>>>>                stack backtrace:
>>>> [    8.559124] CPU: 2 PID: 143 Comm: systemd-udevd Not tainted 4.2.0-rc2+ #21
>>>> [    8.559132] Hardware name: Hewlett-Packard HP ProBook 6475b/180F, BIOS 68TTU Ver. F.04 08/03/2012
>>>> [    8.559143]  ffffffff8285ace0 ffff88002b09f378 ffffffff817f4254 ffffffff810c155a
>>>> [    8.559156]  ffffffff8285ace0 ffff88002b09f3c8 ffffffff810ac6a3 0000000000000003
>>>> [    8.559169]  ffff88002b09f438 ffff88002b09f3c8 ffff88002b06b398 ffff88002b06a600
>>>> [    8.559181] Call Trace:
>>>> [    8.559190]  [<ffffffff817f4254>] dump_stack+0x45/0x57
>>>> [    8.559208]  [<ffffffff810c155a>] ? console_unlock+0x1da/0x580
>>>> [    8.559216]  [<ffffffff810ac6a3>] print_circular_bug+0x1e3/0x250
>>>> [    8.559225]  [<ffffffff810aff59>] __lock_acquire+0x1f29/0x1f90
>>>> [    8.559234]  [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>>>> [    8.559243]  [<ffffffffa0001f36>] ? acpi_video_get_backlight_type+0x17/0x163 [video]
>>>> [    8.559255]  [<ffffffff817f9ceb>] mutex_lock_nested+0x4b/0x340
>>>> [    8.559264]  [<ffffffffa0001f36>] ? acpi_video_get_backlight_type+0x17/0x163 [video]
>>>> [    8.559277]  [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>>>> [    8.559289]  [<ffffffffa00020ba>] acpi_video_backlight_notify+0x19/0x2f [video]
>>>> [    8.559301]  [<ffffffff8107faad>] notifier_call_chain+0x5d/0x80
>>>> [    8.559310]  [<ffffffff8107fc61>] __blocking_notifier_call_chain+0x51/0x70
>>>> [    8.559319]  [<ffffffff8107fc96>] blocking_notifier_call_chain+0x16/0x20
>>>> [    8.559327]  [<ffffffff81424ff2>] backlight_device_register+0x1a2/0x260
>>>> [    8.559374]  [<ffffffffa02af70a>] radeon_atom_backlight_init+0xda/0x1d0 [radeon]
>>>> [    8.559416]  [<ffffffffa0254713>] radeon_link_encoder_connector+0xc3/0x130 [radeon]
>>>> [    8.559455]  [<ffffffffa0232b06>] radeon_get_atom_connector_info_from_object_table+0x3a6/0x950 [radeon]
>>>> [    8.559481]  [<ffffffffa0038c1b>] ? drm_mode_crtc_set_gamma_size+0x5b/0x70 [drm]
>>>> [    8.559523]  [<ffffffffa0257e4c>] radeon_modeset_init+0x5dc/0xa40 [radeon]
>>>> [    8.559566]  [<ffffffffa03071d8>] ? radeon_ib_ring_tests+0x58/0xc0 [radeon]
>>>> [    8.559601]  [<ffffffffa0230b0b>] radeon_driver_load_kms+0x12b/0x220 [radeon]
>>>> [    8.559620]  [<ffffffffa0033281>] drm_dev_register+0xb1/0x100 [drm]
>>>> [    8.559639]  [<ffffffffa003605d>] drm_get_pci_dev+0x8d/0x1e0 [drm]
>>>> [    8.559674]  [<ffffffffa022c404>] radeon_pci_probe+0xa4/0xc0 [radeon]
>>>> [    8.559683]  [<ffffffff813f3715>] local_pci_probe+0x45/0xa0
>>>> [    8.559691]  [<ffffffff813f47d0>] ? pci_match_device+0xe0/0x110
>>>> [    8.559699]  [<ffffffff813f4911>] pci_device_probe+0xd1/0x120
>>>> [    8.559708]  [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>>>> [    8.559717]  [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>>>> [    8.559726]  [<ffffffff814db950>] ? driver_probe_device+0x470/0x470
>>>> [    8.559734]  [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>>>> [    8.559743]  [<ffffffff814daece>] driver_attach+0x1e/0x20
>>>> [    8.559752]  [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>>>> [    8.559760]  [<ffffffff814dc280>] driver_register+0x60/0xe0
>>>> [    8.559767]  [<ffffffff813f2fd4>] __pci_register_driver+0x64/0x70
>>>> [    8.559786]  [<ffffffffa0036290>] drm_pci_init+0xe0/0x110 [drm]
>>>> [    8.559794]  [<ffffffffa039d000>] ? 0xffffffffa039d000
>>>> [    8.559825]  [<ffffffffa039d09d>] radeon_init+0x9d/0xb2 [radeon]
>>>> [    8.559834]  [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>>>> [    8.559843]  [<ffffffff817f3146>] ? do_init_module+0x28/0x1e9
>>>> [    8.559852]  [<ffffffff811c5c3b>] ? kmem_cache_alloc_trace+0xbb/0x160
>>>> [    8.559862]  [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>>>> [    8.559870]  [<ffffffff810f1900>] load_module+0x2170/0x2780
>>>> [    8.559878]  [<ffffffff810edd30>] ? __symbol_put+0x40/0x40
>>>> [    8.559888]  [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>>>> [    8.559897]  [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>>>
>>> Sorry, but I fail to see how this is related to the V4L2 subsystem.
>>>
>>> At least on my eyes, it seems that the bug is somewhere at the Radeon
>>> driver.
>>>
>>
>> Mauro,
>>
>> I think you didn't look down the dmesg far enough. The following is the
>> problem I am talking about and you will see media_device_unregister()
>> on the stack. This occurs as soon as the device is removed.
> 
> Shuah,
> 
> I saw that, but it is clear, from the above log, that the Radeon
> driver is broken and it has some bad lock dependencies with the
> driver_attach locks. Any other bad lock report related to the
> Radeon driver or driver binding/unbiding code are very likely
> related to the above bug.
> 
> You should either fix the bad lock at the Radeon driver or not
> load it at all, in order to be able to get any reliable results
> about possible locking troubles with the MC drivers with the Kernel
> lock tests.
> 

Yeah Radeon driver bug could be making things worse. Did you see
any problems with device removal during your testing?

ok found the following commit that fixes the problem:
7231ed1a813e0a9d249bbbe58e66ca058aee83e1

This went into 4.2-rc4 or rc5. I will test applying just this
one patch to mc_next_gen.v8.4 branch and see if device removal
problem also goes away.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

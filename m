Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52893 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbbKKOWz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 09:22:55 -0500
Subject: Re: Slow path and cpu lock warnings - MC Next Gen
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <5640C0F2.9070000@osg.samsung.com>
 <5640C1DA.7040100@osg.samsung.com> <20151111103053.448ac440@recife.lan>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56434F37.9070007@osg.samsung.com>
Date: Wed, 11 Nov 2015 07:22:47 -0700
MIME-Version: 1.0
In-Reply-To: <20151111103053.448ac440@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/2015 05:30 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 09 Nov 2015 08:55:06 -0700
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> On 11/09/2015 08:51 AM, Shuah Khan wrote:
>>> As I mentioned on the IRC, here is the log for the problems I am seeing.
>>> I have to do eject HVR 950Q TV stick to see the problem.
>>>
>>> mc_next_gen.v8.4 branch with no changes.
>>>
>>> I can test and debug this week.
>>>
>>> thanks,
>>> -- Shuah
>>>   
>>
>> Forgot to cc linux-media, just in case others are interested
>> and have ideas on debugging.
>>
>> thanks,
>> -- Shuah
> 
>> [    8.558049] ======================================================
>> [    8.558056] [ INFO: possible circular locking dependency detected ]
>> [    8.558063] 4.2.0-rc2+ #21 Not tainted
>> [    8.558070] -------------------------------------------------------
>> [    8.558077] systemd-udevd/143 is trying to acquire lock:
>> [    8.558084]  (init_mutex){+.+.+.}, at: [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>> [    8.558104] 
>>                but task is already holding lock:
>> [    8.558114]  (&(&backlight_notifier)->rwsem){++++..}, at: [<ffffffff8107fc49>] __blocking_notifier_call_chain+0x39/0x70
>> [    8.558133] 
>>                which lock already depends on the new lock.
>>
>> [    8.558147] 
>>                the existing dependency chain (in reverse order) is:
>> [    8.558158] 
>>                -> #1 (&(&backlight_notifier)->rwsem){++++..}:  
>> [    8.558170]        [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>> [    8.558180]        [<ffffffff817fb006>] down_write+0x36/0x70
>> [    8.558189]        [<ffffffff8107fdc1>] blocking_notifier_chain_register+0x21/0xb0
>> [    8.558202]        [<ffffffff81424c98>] backlight_register_notifier+0x18/0x20
>> [    8.558212]        [<ffffffffa0002019>] acpi_video_get_backlight_type+0xfa/0x163 [video]
>> [    8.558225]        [<ffffffffa000167e>] acpi_video_bus_add+0x686/0xdfa [video]
>> [    8.558237]        [<ffffffff814371b0>] acpi_device_probe+0x50/0xf7
>> [    8.558247]        [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>> [    8.558257]        [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>> [    8.558266]        [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>> [    8.558275]        [<ffffffff814daece>] driver_attach+0x1e/0x20
>> [    8.558287]        [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>> [    8.558296]        [<ffffffff814dc280>] driver_register+0x60/0xe0
>> [    8.558304]        [<ffffffff81437936>] acpi_bus_register_driver+0x3b/0x43
>> [    8.558313]        [<ffffffffa0000328>] acpi_video_register+0x6e/0x90 [video]
>> [    8.558322]        [<ffffffffa000b087>] hid_generic_exit+0x87/0x1000 [hid_generic]
>> [    8.558334]        [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>> [    8.558344]        [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>> [    8.558353]        [<ffffffff810f1900>] load_module+0x2170/0x2780
>> [    8.558363]        [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>> [    8.558372]        [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>> [    8.558381] 
>>                -> #0 (init_mutex){+.+.+.}:  
>> [    8.558392]        [<ffffffff810aff59>] __lock_acquire+0x1f29/0x1f90
>> [    8.558401]        [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>> [    8.558409]        [<ffffffff817f9ceb>] mutex_lock_nested+0x4b/0x340
>> [    8.558417]        [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>> [    8.558430]        [<ffffffffa00020ba>] acpi_video_backlight_notify+0x19/0x2f [video]
>> [    8.558442]        [<ffffffff8107faad>] notifier_call_chain+0x5d/0x80
>> [    8.558451]        [<ffffffff8107fc61>] __blocking_notifier_call_chain+0x51/0x70
>> [    8.558462]        [<ffffffff8107fc96>] blocking_notifier_call_chain+0x16/0x20
>> [    8.558474]        [<ffffffff81424ff2>] backlight_device_register+0x1a2/0x260
>> [    8.558483]        [<ffffffffa02af70a>] radeon_atom_backlight_init+0xda/0x1d0 [radeon]
>> [    8.558543]        [<ffffffffa0254713>] radeon_link_encoder_connector+0xc3/0x130 [radeon]
>> [    8.558585]        [<ffffffffa0232b06>] radeon_get_atom_connector_info_from_object_table+0x3a6/0x950 [radeon]
>> [    8.558625]        [<ffffffffa0257e4c>] radeon_modeset_init+0x5dc/0xa40 [radeon]
>> [    8.558667]        [<ffffffffa0230b0b>] radeon_driver_load_kms+0x12b/0x220 [radeon]
>> [    8.558706]        [<ffffffffa0033281>] drm_dev_register+0xb1/0x100 [drm]
>> [    8.558728]        [<ffffffffa003605d>] drm_get_pci_dev+0x8d/0x1e0 [drm]
>> [    8.558747]        [<ffffffffa022c404>] radeon_pci_probe+0xa4/0xc0 [radeon]
>> [    8.558783]        [<ffffffff813f3715>] local_pci_probe+0x45/0xa0
>> [    8.558792]        [<ffffffff813f4911>] pci_device_probe+0xd1/0x120
>> [    8.558800]        [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>> [    8.558809]        [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>> [    8.558818]        [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>> [    8.558827]        [<ffffffff814daece>] driver_attach+0x1e/0x20
>> [    8.558835]        [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>> [    8.558844]        [<ffffffff814dc280>] driver_register+0x60/0xe0
>> [    8.558852]        [<ffffffff813f2fd4>] __pci_register_driver+0x64/0x70
>> [    8.558860]        [<ffffffffa0036290>] drm_pci_init+0xe0/0x110 [drm]
>> [    8.558879]        [<ffffffffa039d09d>] radeon_init+0x9d/0xb2 [radeon]
>> [    8.558911]        [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>> [    8.558920]        [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>> [    8.558928]        [<ffffffff810f1900>] load_module+0x2170/0x2780
>> [    8.558937]        [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>> [    8.558945]        [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>> [    8.558954] 
>>                other info that might help us debug this:
>>
>> [    8.558968]  Possible unsafe locking scenario:
>>
>> [    8.558978]        CPU0                    CPU1
>> [    8.558984]        ----                    ----
>> [    8.558989]   lock(&(&backlight_notifier)->rwsem);
>> [    8.558997]                                lock(init_mutex);
>> [    8.559004]                                lock(&(&backlight_notifier)->rwsem);
>> [    8.559015]   lock(init_mutex);
>> [    8.559021] 
>>                 *** DEADLOCK ***
>>
>> [    8.559035] 4 locks held by systemd-udevd/143:
>> [    8.559041]  #0:  (&dev->mutex){......}, at: [<ffffffff814db99b>] __driver_attach+0x4b/0xa0
>> [    8.559056]  #1:  (&dev->mutex){......}, at: [<ffffffff814db9a9>] __driver_attach+0x59/0xa0
>> [    8.559072]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffffa00331f6>] drm_dev_register+0x26/0x100 [drm]
>> [    8.559097]  #3:  (&(&backlight_notifier)->rwsem){++++..}, at: [<ffffffff8107fc49>] __blocking_notifier_call_chain+0x39/0x70
>> [    8.559113] 
>>                stack backtrace:
>> [    8.559124] CPU: 2 PID: 143 Comm: systemd-udevd Not tainted 4.2.0-rc2+ #21
>> [    8.559132] Hardware name: Hewlett-Packard HP ProBook 6475b/180F, BIOS 68TTU Ver. F.04 08/03/2012
>> [    8.559143]  ffffffff8285ace0 ffff88002b09f378 ffffffff817f4254 ffffffff810c155a
>> [    8.559156]  ffffffff8285ace0 ffff88002b09f3c8 ffffffff810ac6a3 0000000000000003
>> [    8.559169]  ffff88002b09f438 ffff88002b09f3c8 ffff88002b06b398 ffff88002b06a600
>> [    8.559181] Call Trace:
>> [    8.559190]  [<ffffffff817f4254>] dump_stack+0x45/0x57
>> [    8.559208]  [<ffffffff810c155a>] ? console_unlock+0x1da/0x580
>> [    8.559216]  [<ffffffff810ac6a3>] print_circular_bug+0x1e3/0x250
>> [    8.559225]  [<ffffffff810aff59>] __lock_acquire+0x1f29/0x1f90
>> [    8.559234]  [<ffffffff810b0c61>] lock_acquire+0xb1/0x130
>> [    8.559243]  [<ffffffffa0001f36>] ? acpi_video_get_backlight_type+0x17/0x163 [video]
>> [    8.559255]  [<ffffffff817f9ceb>] mutex_lock_nested+0x4b/0x340
>> [    8.559264]  [<ffffffffa0001f36>] ? acpi_video_get_backlight_type+0x17/0x163 [video]
>> [    8.559277]  [<ffffffffa0001f36>] acpi_video_get_backlight_type+0x17/0x163 [video]
>> [    8.559289]  [<ffffffffa00020ba>] acpi_video_backlight_notify+0x19/0x2f [video]
>> [    8.559301]  [<ffffffff8107faad>] notifier_call_chain+0x5d/0x80
>> [    8.559310]  [<ffffffff8107fc61>] __blocking_notifier_call_chain+0x51/0x70
>> [    8.559319]  [<ffffffff8107fc96>] blocking_notifier_call_chain+0x16/0x20
>> [    8.559327]  [<ffffffff81424ff2>] backlight_device_register+0x1a2/0x260
>> [    8.559374]  [<ffffffffa02af70a>] radeon_atom_backlight_init+0xda/0x1d0 [radeon]
>> [    8.559416]  [<ffffffffa0254713>] radeon_link_encoder_connector+0xc3/0x130 [radeon]
>> [    8.559455]  [<ffffffffa0232b06>] radeon_get_atom_connector_info_from_object_table+0x3a6/0x950 [radeon]
>> [    8.559481]  [<ffffffffa0038c1b>] ? drm_mode_crtc_set_gamma_size+0x5b/0x70 [drm]
>> [    8.559523]  [<ffffffffa0257e4c>] radeon_modeset_init+0x5dc/0xa40 [radeon]
>> [    8.559566]  [<ffffffffa03071d8>] ? radeon_ib_ring_tests+0x58/0xc0 [radeon]
>> [    8.559601]  [<ffffffffa0230b0b>] radeon_driver_load_kms+0x12b/0x220 [radeon]
>> [    8.559620]  [<ffffffffa0033281>] drm_dev_register+0xb1/0x100 [drm]
>> [    8.559639]  [<ffffffffa003605d>] drm_get_pci_dev+0x8d/0x1e0 [drm]
>> [    8.559674]  [<ffffffffa022c404>] radeon_pci_probe+0xa4/0xc0 [radeon]
>> [    8.559683]  [<ffffffff813f3715>] local_pci_probe+0x45/0xa0
>> [    8.559691]  [<ffffffff813f47d0>] ? pci_match_device+0xe0/0x110
>> [    8.559699]  [<ffffffff813f4911>] pci_device_probe+0xd1/0x120
>> [    8.559708]  [<ffffffff814db62d>] driver_probe_device+0x14d/0x470
>> [    8.559717]  [<ffffffff814db9e4>] __driver_attach+0x94/0xa0
>> [    8.559726]  [<ffffffff814db950>] ? driver_probe_device+0x470/0x470
>> [    8.559734]  [<ffffffff814d9366>] bus_for_each_dev+0x66/0xa0
>> [    8.559743]  [<ffffffff814daece>] driver_attach+0x1e/0x20
>> [    8.559752]  [<ffffffff814daa4e>] bus_add_driver+0x1ee/0x280
>> [    8.559760]  [<ffffffff814dc280>] driver_register+0x60/0xe0
>> [    8.559767]  [<ffffffff813f2fd4>] __pci_register_driver+0x64/0x70
>> [    8.559786]  [<ffffffffa0036290>] drm_pci_init+0xe0/0x110 [drm]
>> [    8.559794]  [<ffffffffa039d000>] ? 0xffffffffa039d000
>> [    8.559825]  [<ffffffffa039d09d>] radeon_init+0x9d/0xb2 [radeon]
>> [    8.559834]  [<ffffffff810002eb>] do_one_initcall+0xab/0x1d0
>> [    8.559843]  [<ffffffff817f3146>] ? do_init_module+0x28/0x1e9
>> [    8.559852]  [<ffffffff811c5c3b>] ? kmem_cache_alloc_trace+0xbb/0x160
>> [    8.559862]  [<ffffffff817f317e>] do_init_module+0x60/0x1e9
>> [    8.559870]  [<ffffffff810f1900>] load_module+0x2170/0x2780
>> [    8.559878]  [<ffffffff810edd30>] ? __symbol_put+0x40/0x40
>> [    8.559888]  [<ffffffff810f212a>] SyS_finit_module+0x9a/0xc0
>> [    8.559897]  [<ffffffff817fd5d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
> 
> Sorry, but I fail to see how this is related to the V4L2 subsystem.
> 
> At least on my eyes, it seems that the bug is somewhere at the Radeon
> driver.
> 

Mauro,

I think you didn't look down the dmesg far enough. The following is the
problem I am talking about and you will see media_device_unregister()
on the stack. This occurs as soon as the device is removed.

thanks,
-- Shuah

[  304.245575] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s!
[kworker/2:1:56]
[  304.245587] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec
lirc_dev ir_sony_decoder ir_xmp_decoder ir_sharp_decoder
ir_sanyo_decoder ir_mce_kbd_decoder snd_seq_device ir_jvc_decoder
ir_rc5_decoder ir_rc6_decoder ir_nec_decoder au8522_dig tuner
au8522_decoder au8522_common au0828 tveeprom nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables binfmt_misc nls_iso8859_1
kvm_amd kvm uvcvideo videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel videobuf2_core aesni_intel aes_x86_64 ablk_helper
cryptd lrw hp_wmi gf128mul sparse_keymap snd_hda_codec_idt glue_helper
snd_hda_codec_generic snd_hda_codec_hdmi
[  304.245661]  snd_hda_intel microcode snd_hda_codec hp_accel
tpm_infineon snd_hda_core joydev k10temp serio_raw lis3lv02d snd_hwdep
input_polldev snd_pcm tpm_tis snd_timer i2c_piix4 shpchp mac_hid
parport_pc ppdev lp parport autofs4 pl2303 usbserial hid_generic radeon
usbhid psmouse i2c_algo_bit hid firewire_ohci ttm firewire_core
drm_kms_helper sdhci_pci crc_itu_t r8169 sdhci mii drm wmi video
[  304.245709] irq event stamp: 1850
[  304.245712] hardirqs last  enabled at (1849): [<ffffffff817fce50>]
_raw_spin_unlock_irq+0x30/0x40
[  304.245722] hardirqs last disabled at (1850): [<ffffffff817fcbe7>]
_raw_spin_lock_irq+0x17/0x50
[  304.245727] softirqs last  enabled at (512): [<ffffffff81799f7d>]
addrconf_verify_rtnl+0x23d/0x500
[  304.245735] softirqs last disabled at (506): [<ffffffff81799d63>]
addrconf_verify_rtnl+0x23/0x500
[  304.245744] CPU: 2 PID: 56 Comm: kworker/2:1 Not tainted 4.2.0-rc2+ #21
[  304.245747] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  304.245754] Workqueue: usb_hub_wq hub_event
[  304.245758] task: ffff88021e222600 ti: ffff880218dec000 task.ti:
ffff880218dec000
[  304.245761] RIP: 0010:[<ffffffff813bf2ea>]  [<ffffffff813bf2ea>]
delay_tsc+0x1a/0x50
[  304.245769] RSP: 0018:ffff880218def938  EFLAGS: 00000206
[  304.245772] RAX: 000000001d95bc8c RBX: 0000000180100008 RCX:
000000001d95bc8c
[  304.245775] RDX: 00000000000000ad RSI: 0000000000000002 RDI:
0000000000000001
[  304.245777] RBP: ffff880218def938 R08: 0000000000000001 R09:
0000000000000000
[  304.245780] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff817fe161
[  304.245783] R13: ffffffff810d021e R14: ffffffff817fe161 R15:
ffffffff810d021e
[  304.245786] FS:  00007fde9af5e940(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[  304.245789] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  304.245792] CR2: 00007f21c0f55000 CR3: 0000000001e0b000 CR4:
00000000000407e0
[  304.245794] Stack:
[  304.245796]  ffff880218def948 ffffffff813bf20f ffff880218def978
ffffffff810b428c
[  304.245802]  ffff88008ced0d70 ffff88008ced0d70 ffff880231f1f800
ffff880231f1fd40
[  304.245807]  ffff880218def9a8 ffffffff817fca99 ffffffff8160f70b
ffffffff8160f844
[  304.245812] Call Trace:
[  304.245819]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  304.245826]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  304.245830]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  304.245837]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  304.245841]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  304.245846]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  304.245851]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  304.245859]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  304.245868]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  304.245874]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  304.245878]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  304.245883]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  304.245888]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  304.245893]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  304.245900]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  304.245904]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  304.245910]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  304.245914]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  304.245919]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  304.245923]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  304.245927]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  304.245931]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  304.245937]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  304.245943]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  304.245947]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  304.245952]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  304.245957]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  304.245961]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  304.245965]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  304.245971]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  304.245975]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  304.245980]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  304.245982] Code: 00 5d c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 55 48 89 e5 65 8b 35 90 ae c4 7e 0f ae f0 0f 31 89 c1 0f
ae f0 <0f> 31 48 c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39 d7 76 1c f3 90
[  332.243453] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s!
[kworker/2:1:56]
[  332.243464] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec
lirc_dev ir_sony_decoder ir_xmp_decoder ir_sharp_decoder
ir_sanyo_decoder ir_mce_kbd_decoder snd_seq_device ir_jvc_decoder
ir_rc5_decoder ir_rc6_decoder ir_nec_decoder au8522_dig tuner
au8522_decoder au8522_common au0828 tveeprom nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables binfmt_misc nls_iso8859_1
kvm_amd kvm uvcvideo videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel videobuf2_core aesni_intel aes_x86_64 ablk_helper
cryptd lrw hp_wmi gf128mul sparse_keymap snd_hda_codec_idt glue_helper
snd_hda_codec_generic snd_hda_codec_hdmi
[  332.243542]  snd_hda_intel microcode snd_hda_codec hp_accel
tpm_infineon snd_hda_core joydev k10temp serio_raw lis3lv02d snd_hwdep
input_polldev snd_pcm tpm_tis snd_timer i2c_piix4 shpchp mac_hid
parport_pc ppdev lp parport autofs4 pl2303 usbserial hid_generic radeon
usbhid psmouse i2c_algo_bit hid firewire_ohci ttm firewire_core
drm_kms_helper sdhci_pci crc_itu_t r8169 sdhci mii drm wmi video
[  332.243592] irq event stamp: 1850
[  332.243595] hardirqs last  enabled at (1849): [<ffffffff817fce50>]
_raw_spin_unlock_irq+0x30/0x40
[  332.243605] hardirqs last disabled at (1850): [<ffffffff817fcbe7>]
_raw_spin_lock_irq+0x17/0x50
[  332.243612] softirqs last  enabled at (512): [<ffffffff81799f7d>]
addrconf_verify_rtnl+0x23d/0x500
[  332.243619] softirqs last disabled at (506): [<ffffffff81799d63>]
addrconf_verify_rtnl+0x23/0x500
[  332.243628] CPU: 2 PID: 56 Comm: kworker/2:1 Tainted: G             L
 4.2.0-rc2+ #21
[  332.243632] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  332.243638] Workqueue: usb_hub_wq hub_event
[  332.243642] task: ffff88021e222600 ti: ffff880218dec000 task.ti:
ffff880218dec000
[  332.243645] RIP: 0010:[<ffffffff813bf2e5>]  [<ffffffff813bf2e5>]
delay_tsc+0x15/0x50
[  332.243653] RSP: 0018:ffff880218def938  EFLAGS: 00000202
[  332.243656] RAX: 0000000015191edb RBX: 0000000180100008 RCX:
0000000015191d34
[  332.243659] RDX: 00000000000000bc RSI: 0000000000000002 RDI:
0000000000000001
[  332.243662] RBP: ffff880218def938 R08: 0000000000000001 R09:
0000000000000000
[  332.243665] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff817fe161
[  332.243667] R13: ffffffff810d021e R14: ffffffff817fe161 R15:
ffffffff810d021e
[  332.243671] FS:  00007fde9af5e940(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[  332.243674] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  332.243677] CR2: 00007f21c0f55000 CR3: 0000000001e0b000 CR4:
00000000000407e0
[  332.243679] Stack:
[  332.243681]  ffff880218def948 ffffffff813bf20f ffff880218def978
ffffffff810b428c
[  332.243687]  ffff88008ced0d70 ffff88008ced0d70 ffff880231f1f800
ffff880231f1fd40
[  332.243692]  ffff880218def9a8 ffffffff817fca99 ffffffff8160f70b
ffffffff8160f844
[  332.243697] Call Trace:
[  332.243704]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  332.243711]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  332.243715]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  332.243721]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  332.243726]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  332.243730]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  332.243734]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  332.243743]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  332.243749]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  332.243754]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  332.243758]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  332.243763]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  332.243768]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  332.243773]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  332.243780]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  332.243784]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  332.243790]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  332.243794]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  332.243799]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  332.243804]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  332.243808]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  332.243812]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  332.243817]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  332.243823]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  332.243827]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  332.243832]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  332.243837]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  332.243841]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  332.243846]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  332.243851]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  332.243855]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  332.243860]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  332.243862] Code: ff 15 68 bb ae 00 5d c3 0f 1f 40 00 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 65 8b 35 90 ae c4 7e 0f ae f0
0f 31 <89> c1 0f ae f0 0f 31 48 c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39
[  344.082652] INFO: rcu_sched self-detected stall on CPU { 2}  (t=16250
jiffies g=16088 c=16087 q=6192)
[  344.082671] Task dump for CPU 2:
[  344.082675] kworker/2:1     R  running task        0    56      2
0x00000008
[  344.082686] Workqueue: usb_hub_wq hub_event
[  344.082689]  0000000000000002 ffff88023ed03d58 ffffffff8108d999
ffffffff8108d8d1
[  344.082695]  0000000000000000 0000000000000002 ffffffff81e4ffc0
ffff88023ed03d78
[  344.082701]  ffffffff8109089b ffff88023ed16840 0000000000000003
ffff88023ed03da8
[  344.082706] Call Trace:
[  344.082709]  <IRQ>  [<ffffffff8108d999>] sched_show_task+0x129/0x230
[  344.082721]  [<ffffffff8108d8d1>] ? sched_show_task+0x61/0x230
[  344.082727]  [<ffffffff8109089b>] dump_cpu_task+0x3b/0x50
[  344.082733]  [<ffffffff810cd58e>] rcu_dump_cpu_stacks+0x8e/0xe0
[  344.082738]  [<ffffffff810d0906>] rcu_check_callbacks+0x486/0x770
[  344.082743]  [<ffffffff810a9580>] ? cpuacct_account_field+0xd0/0x1a0
[  344.082747]  [<ffffffff810a94b5>] ? cpuacct_account_field+0x5/0x1a0
[  344.082753]  [<ffffffff810e6212>] ? tick_sched_timer+0x22/0x80
[  344.082758]  [<ffffffff810e61f0>] ? tick_sched_do_timer+0x30/0x30
[  344.082762]  [<ffffffff810d5c89>] update_process_times+0x39/0x60
[  344.082767]  [<ffffffff810e5b25>] tick_sched_handle.isra.16+0x25/0x60
[  344.082772]  [<ffffffff810e6234>] tick_sched_timer+0x44/0x80
[  344.082776]  [<ffffffff810d653e>] __hrtimer_run_queues+0xce/0x270
[  344.082781]  [<ffffffff810d6ceb>] hrtimer_interrupt+0xab/0x1b0
[  344.082787]  [<ffffffff8103807c>] local_apic_timer_interrupt+0x3c/0x70
[  344.082792]  [<ffffffff81800031>] smp_apic_timer_interrupt+0x41/0x60
[  344.082796]  [<ffffffff817fe40d>] apic_timer_interrupt+0x6d/0x80
[  344.082799]  <EOI>  [<ffffffff813bf2e3>] ? delay_tsc+0x13/0x50
[  344.082808]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  344.082812]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  344.082816]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  344.082821]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  344.082825]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  344.082829]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  344.082833]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  344.082841]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  344.082846]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  344.082851]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  344.082854]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  344.082860]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  344.082865]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  344.082869]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  344.082875]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  344.082880]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  344.082885]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  344.082889]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  344.082894]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  344.082898]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  344.082902]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  344.082906]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  344.082911]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  344.082917]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  344.082921]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  344.082926]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  344.082931]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  344.082935]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  344.082939]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  344.082944]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  344.082949]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  344.082953]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  368.241164] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s!
[kworker/2:1:56]
[  368.241173] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec
lirc_dev ir_sony_decoder ir_xmp_decoder ir_sharp_decoder
ir_sanyo_decoder ir_mce_kbd_decoder snd_seq_device ir_jvc_decoder
ir_rc5_decoder ir_rc6_decoder ir_nec_decoder au8522_dig tuner
au8522_decoder au8522_common au0828 tveeprom nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables binfmt_misc nls_iso8859_1
kvm_amd kvm uvcvideo videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel videobuf2_core aesni_intel aes_x86_64 ablk_helper
cryptd lrw hp_wmi gf128mul sparse_keymap snd_hda_codec_idt glue_helper
snd_hda_codec_generic snd_hda_codec_hdmi
[  368.241251]  snd_hda_intel microcode snd_hda_codec hp_accel
tpm_infineon snd_hda_core joydev k10temp serio_raw lis3lv02d snd_hwdep
input_polldev snd_pcm tpm_tis snd_timer i2c_piix4 shpchp mac_hid
parport_pc ppdev lp parport autofs4 pl2303 usbserial hid_generic radeon
usbhid psmouse i2c_algo_bit hid firewire_ohci ttm firewire_core
drm_kms_helper sdhci_pci crc_itu_t r8169 sdhci mii drm wmi video
[  368.241300] irq event stamp: 1850
[  368.241303] hardirqs last  enabled at (1849): [<ffffffff817fce50>]
_raw_spin_unlock_irq+0x30/0x40
[  368.241313] hardirqs last disabled at (1850): [<ffffffff817fcbe7>]
_raw_spin_lock_irq+0x17/0x50
[  368.241318] softirqs last  enabled at (512): [<ffffffff81799f7d>]
addrconf_verify_rtnl+0x23d/0x500
[  368.241326] softirqs last disabled at (506): [<ffffffff81799d63>]
addrconf_verify_rtnl+0x23/0x500
[  368.241335] CPU: 2 PID: 56 Comm: kworker/2:1 Tainted: G             L
 4.2.0-rc2+ #21
[  368.241339] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  368.241345] Workqueue: usb_hub_wq hub_event
[  368.241349] task: ffff88021e222600 ti: ffff880218dec000 task.ti:
ffff880218dec000
[  368.241352] RIP: 0010:[<ffffffff813bf2ea>]  [<ffffffff813bf2ea>]
delay_tsc+0x1a/0x50
[  368.241359] RSP: 0018:ffff880218def938  EFLAGS: 00000206
[  368.241363] RAX: 000000005363a164 RBX: 0000000180100008 RCX:
000000005363a164
[  368.241365] RDX: 00000000000000cf RSI: 0000000000000002 RDI:
0000000000000001
[  368.241368] RBP: ffff880218def938 R08: 0000000000000001 R09:
0000000000000000
[  368.241370] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff817fe161
[  368.241373] R13: ffffffff810d021e R14: ffff880218def8c8 R15:
0140000000000000
[  368.241377] FS:  00007fde9af5e940(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[  368.241379] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  368.241382] CR2: 00007f21c0f55000 CR3: 0000000001e0b000 CR4:
00000000000407e0
[  368.241384] Stack:
[  368.241387]  ffff880218def948 ffffffff813bf20f ffff880218def978
ffffffff810b428c
[  368.241392]  ffff88008ced0d70 ffff88008ced0d70 ffff880231f1f800
ffff880231f1fd40
[  368.241398]  ffff880218def9a8 ffffffff817fca99 ffffffff8160f70b
ffffffff8160f844
[  368.241403] Call Trace:
[  368.241410]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  368.241416]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  368.241421]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  368.241427]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  368.241431]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  368.241436]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  368.241440]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  368.241449]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  368.241454]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  368.241460]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  368.241464]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  368.241469]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  368.241474]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  368.241479]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  368.241486]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  368.241491]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  368.241496]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  368.241501]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  368.241505]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  368.241510]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  368.241514]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  368.241518]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  368.241523]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  368.241529]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  368.241534]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  368.241539]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  368.241544]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  368.241548]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  368.241552]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  368.241558]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  368.241562]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  368.241567]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  368.241569] Code: 00 5d c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00
0f 1f 44 00 00 55 48 89 e5 65 8b 35 90 ae c4 7e 0f ae f0 0f 31 89 c1 0f
ae f0 <0f> 31 48 c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39 d7 76 1c f3 90
[  396.239591] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s!
[kworker/2:1:56]
[  396.239601] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec
lirc_dev ir_sony_decoder ir_xmp_decoder ir_sharp_decoder
ir_sanyo_decoder ir_mce_kbd_decoder snd_seq_device ir_jvc_decoder
ir_rc5_decoder ir_rc6_decoder ir_nec_decoder au8522_dig tuner
au8522_decoder au8522_common au0828 tveeprom nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables binfmt_misc nls_iso8859_1
kvm_amd kvm uvcvideo videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel videobuf2_core aesni_intel aes_x86_64 ablk_helper
cryptd lrw hp_wmi gf128mul sparse_keymap snd_hda_codec_idt glue_helper
snd_hda_codec_generic snd_hda_codec_hdmi
[  396.239676]  snd_hda_intel microcode snd_hda_codec hp_accel
tpm_infineon snd_hda_core joydev k10temp serio_raw lis3lv02d snd_hwdep
input_polldev snd_pcm tpm_tis snd_timer i2c_piix4 shpchp mac_hid
parport_pc ppdev lp parport autofs4 pl2303 usbserial hid_generic radeon
usbhid psmouse i2c_algo_bit hid firewire_ohci ttm firewire_core
drm_kms_helper sdhci_pci crc_itu_t r8169 sdhci mii drm wmi video
[  396.239724] irq event stamp: 1850
[  396.239727] hardirqs last  enabled at (1849): [<ffffffff817fce50>]
_raw_spin_unlock_irq+0x30/0x40
[  396.239736] hardirqs last disabled at (1850): [<ffffffff817fcbe7>]
_raw_spin_lock_irq+0x17/0x50
[  396.239742] softirqs last  enabled at (512): [<ffffffff81799f7d>]
addrconf_verify_rtnl+0x23d/0x500
[  396.239749] softirqs last disabled at (506): [<ffffffff81799d63>]
addrconf_verify_rtnl+0x23/0x500
[  396.239758] CPU: 2 PID: 56 Comm: kworker/2:1 Tainted: G             L
 4.2.0-rc2+ #21
[  396.239761] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  396.239768] Workqueue: usb_hub_wq hub_event
[  396.239772] task: ffff88021e222600 ti: ffff880218dec000 task.ti:
ffff880218dec000
[  396.239775] RIP: 0010:[<ffffffff813bf2e5>]  [<ffffffff813bf2e5>]
delay_tsc+0x15/0x50
[  396.239782] RSP: 0018:ffff880218def938  EFLAGS: 00000206
[  396.239785] RAX: 000000004afa4fa4 RBX: 0000000180100008 RCX:
000000004afa42a6
[  396.239788] RDX: 00000000000000de RSI: 0000000000000002 RDI:
0000000000000001
[  396.239791] RBP: ffff880218def938 R08: 0000000000000001 R09:
0000000000000000
[  396.239793] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff817fe161
[  396.239796] R13: ffffffff810d021e R14: ffffffff817fe161 R15:
ffffffff810d021e
[  396.239799] FS:  00007fde9af5e940(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[  396.239802] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  396.239805] CR2: 00007f21c0f55000 CR3: 0000000001e0b000 CR4:
00000000000407e0
[  396.239807] Stack:
[  396.239809]  ffff880218def948 ffffffff813bf20f ffff880218def978
ffffffff810b428c
[  396.239815]  ffff88008ced0d70 ffff88008ced0d70 ffff880231f1f800
ffff880231f1fd40
[  396.239820]  ffff880218def9a8 ffffffff817fca99 ffffffff8160f70b
ffffffff8160f844
[  396.239825] Call Trace:
[  396.239833]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  396.239839]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  396.239844]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  396.239850]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  396.239855]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  396.239859]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  396.239864]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  396.239872]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  396.239878]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  396.239883]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  396.239887]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  396.239892]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  396.239898]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  396.239902]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  396.239909]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  396.239914]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  396.239919]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  396.239924]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  396.239929]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  396.239933]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  396.239937]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  396.239941]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  396.239946]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  396.239953]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  396.239957]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  396.239962]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  396.239967]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  396.239971]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  396.239976]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  396.239981]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  396.239986]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  396.239990]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  396.239992] Code: ff 15 68 bb ae 00 5d c3 0f 1f 40 00 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 65 8b 35 90 ae c4 7e 0f ae f0
0f 31 <89> c1 0f ae f0 0f 31 48 c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39
[  424.238131] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s!
[kworker/2:1:56]
[  424.238143] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi ir_lirc_codec
lirc_dev ir_sony_decoder ir_xmp_decoder ir_sharp_decoder
ir_sanyo_decoder ir_mce_kbd_decoder snd_seq_device ir_jvc_decoder
ir_rc5_decoder ir_rc6_decoder ir_nec_decoder au8522_dig tuner
au8522_decoder au8522_common au0828 tveeprom nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter ip_tables x_tables binfmt_misc nls_iso8859_1
kvm_amd kvm uvcvideo videobuf2_vmalloc videobuf2_memops
ghash_clmulni_intel videobuf2_core aesni_intel aes_x86_64 ablk_helper
cryptd lrw hp_wmi gf128mul sparse_keymap snd_hda_codec_idt glue_helper
snd_hda_codec_generic snd_hda_codec_hdmi
[  424.238218]  snd_hda_intel microcode snd_hda_codec hp_accel
tpm_infineon snd_hda_core joydev k10temp serio_raw lis3lv02d snd_hwdep
input_polldev snd_pcm tpm_tis snd_timer i2c_piix4 shpchp mac_hid
parport_pc ppdev lp parport autofs4 pl2303 usbserial hid_generic radeon
usbhid psmouse i2c_algo_bit hid firewire_ohci ttm firewire_core
drm_kms_helper sdhci_pci crc_itu_t r8169 sdhci mii drm wmi video
[  424.238267] irq event stamp: 1850
[  424.238270] hardirqs last  enabled at (1849): [<ffffffff817fce50>]
_raw_spin_unlock_irq+0x30/0x40
[  424.238280] hardirqs last disabled at (1850): [<ffffffff817fcbe7>]
_raw_spin_lock_irq+0x17/0x50
[  424.238286] softirqs last  enabled at (512): [<ffffffff81799f7d>]
addrconf_verify_rtnl+0x23d/0x500
[  424.238293] softirqs last disabled at (506): [<ffffffff81799d63>]
addrconf_verify_rtnl+0x23/0x500
[  424.238302] CPU: 2 PID: 56 Comm: kworker/2:1 Tainted: G             L
 4.2.0-rc2+ #21
[  424.238306] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  424.238312] Workqueue: usb_hub_wq hub_event
[  424.238316] task: ffff88021e222600 ti: ffff880218dec000 task.ti:
ffff880218dec000
[  424.238319] RIP: 0010:[<ffffffff813bf2ec>]  [<ffffffff813bf2ec>]
delay_tsc+0x1c/0x50
[  424.238327] RSP: 0018:ffff880218def938  EFLAGS: 00000202
[  424.238330] RAX: 000000004294e518 RBX: 0000000180100008 RCX:
000000004294d8ed
[  424.238333] RDX: 00000000000000ed RSI: 0000000000000002 RDI:
0000000000000001
[  424.238335] RBP: ffff880218def938 R08: 0000000000000001 R09:
0000000000000000
[  424.238338] R10: 0000000000000000 R11: 0000000000000000 R12:
ffffffff817fe161
[  424.238340] R13: ffffffff810d021e R14: ffffffff817fe161 R15:
ffffffff810d021e
[  424.238344] FS:  00007fde9af5e940(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[  424.238347] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  424.238350] CR2: 00007f21c0f55000 CR3: 0000000001e0b000 CR4:
00000000000407e0
[  424.238352] Stack:
[  424.238354]  ffff880218def948 ffffffff813bf20f ffff880218def978
ffffffff810b428c
[  424.238360]  ffff88008ced0d70 ffff88008ced0d70 ffff880231f1f800
ffff880231f1fd40
[  424.238365]  ffff880218def9a8 ffffffff817fca99 ffffffff8160f70b
ffffffff8160f844
[  424.238370] Call Trace:
[  424.238377]  [<ffffffff813bf20f>] __delay+0xf/0x20
[  424.238384]  [<ffffffff810b428c>] do_raw_spin_lock+0x8c/0x150
[  424.238388]  [<ffffffff817fca99>] _raw_spin_lock+0x39/0x40
[  424.238394]  [<ffffffff8160f70b>] ?
media_device_unregister_entity+0x3b/0x130
[  424.238399]  [<ffffffff8160f844>] ? media_device_unregister+0x44/0x120
[  424.238403]  [<ffffffff8160f70b>]
media_device_unregister_entity+0x3b/0x130
[  424.238407]  [<ffffffff8160f8ba>] media_device_unregister+0xba/0x120
[  424.238416]  [<ffffffffa05d2072>] au0828_usb_release+0x22/0x50 [au0828]
[  424.238421]  [<ffffffffa05d21fa>] au0828_usb_v4l2_release+0x6a/0x80
[au0828]
[  424.238427]  [<ffffffff816180eb>] v4l2_device_release+0x1b/0x20
[  424.238431]  [<ffffffff816187f5>] v4l2_device_put+0x25/0x30
[  424.238436]  [<ffffffffa05d2164>] au0828_usb_disconnect+0xc4/0xf0
[au0828]
[  424.238441]  [<ffffffff81598bf6>] usb_unbind_interface+0x86/0x270
[  424.238446]  [<ffffffff810add7d>] ? trace_hardirqs_on+0xd/0x10
[  424.238453]  [<ffffffff814db0a1>] __device_release_driver+0xa1/0x150
[  424.238457]  [<ffffffff814db175>] device_release_driver+0x25/0x40
[  424.238463]  [<ffffffff814da7dc>] bus_remove_device+0x11c/0x1a0
[  424.238467]  [<ffffffff814d6df9>] device_del+0x139/0x250
[  424.238472]  [<ffffffff81595de1>] ? remove_intf_ep_devs+0x41/0x60
[  424.238476]  [<ffffffff81596459>] usb_disable_device+0x89/0x270
[  424.238480]  [<ffffffff8158be94>] usb_disconnect+0x94/0x2b0
[  424.238484]  [<ffffffff8158e227>] hub_event+0x767/0x1580
[  424.238490]  [<ffffffff81087762>] ? finish_task_switch+0x52/0x1e0
[  424.238496]  [<ffffffff8107826f>] process_one_work+0x1cf/0x540
[  424.238500]  [<ffffffff81078203>] ? process_one_work+0x163/0x540
[  424.238505]  [<ffffffff81078628>] worker_thread+0x48/0x4a0
[  424.238510]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  424.238514]  [<ffffffff810785e0>] ? process_one_work+0x540/0x540
[  424.238518]  [<ffffffff8107e914>] kthread+0xe4/0x100
[  424.238524]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  424.238528]  [<ffffffff817fd9cf>] ret_from_fork+0x3f/0x70
[  424.238533]  [<ffffffff8107e830>] ? kthread_create_on_node+0x220/0x220
[  424.238535] Code: c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00 00 55 48 89 e5 65 8b 35 90 ae c4 7e 0f ae f0 0f 31 89 c1 0f ae f0
0f 31 <48> c1 e2 20 89 c0 48 09 c2 89 d0 29 ca 39 d7 76 1c f3 90 65 8b




-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978

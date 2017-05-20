Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51161 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbdETLKm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 May 2017 07:10:42 -0400
Date: Sat, 20 May 2017 12:10:40 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: cleanup rc_register_device (v2)
Message-ID: <20170520111040.GA15600@gofer.mess.org>
References: <149380584051.16088.1242474111722854646.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149380584051.16088.1242474111722854646.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 03, 2017 at 12:04:00PM +0200, David Härdeman wrote:
> The device core infrastructure is based on the presumption that
> once a driver calls device_add(), it must be ready to accept
> userspace interaction.
> 
> This requires splitting rc_setup_rx_device() into two functions
> and reorganizing rc_register_device() so that as much work
> as possible is performed before calling device_add().
> 
> Version 2: switch the order in which rc_prepare_rx_device() and
> ir_raw_event_prepare() gets called so that dev->change_protocol()
> gets called before device_add().

With this patch applied, when I plug in an iguanair usb device, I get.

(The raw rc thread has not been started when the input device is registered.)

[   65.875642] usb 7-1.3: new low-speed USB device number 6 using uhci_hcd
[   66.004105] usb 7-1.3: New USB device found, idVendor=1781, idProduct=0938
[   66.004111] usb 7-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   66.004116] usb 7-1.3: Product: USB IR Transceiver
[   66.004120] usb 7-1.3: Manufacturer: IguanaWorks
[   66.057190] Registered IR keymap rc-rc6-mce
[   66.057328] rc rc1: IguanaWorks USB IR Transceiver version 0x0308 as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.3/7-1.3:1.0/rc/rc1
[   66.057423] input: IguanaWorks USB IR Transceiver version 0x0308 as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1.3/7-1.3:1.0/rc/rc1/input24
[   66.057445] BUG: unable to handle kernel NULL pointer dereference at 0000000000000ba0
[   66.057500] IP: __lock_acquire+0x122/0x12e0
[   66.057522] PGD 0 
[   66.057523] P4D 0 

[   66.057556] Oops: 0000 [#1] SMP
[   66.057573] Modules linked in: iguanair(+) mceusb xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun fuse nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_security ip6table_mangle ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_security iptable_mangle iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_codec_idt snd_hda_codec_generic tuner_simple tuner_types wm8775 tda9887 tda8290 tuner coretemp kvm_intel ppdev cx25840 mei_wdt kvm iTCO_wdt iTCO_vendor_support ivtv snd_hda_codec_hdmi irqbypass snd_hda_intel joydev snd_hda_codec tveeprom
[   66.057945]  cx2341x v4l2_common snd_hda_core pcspkr videodev snd_hwdep i2c_i801 snd_seq media ir_rc6_decoder snd_seq_device rc_rc6_mce ir_lirc_codec snd_pcm lirc_dev winbond_cir rc_core mei_me snd_timer snd shpchp mei video parport_pc nfsd soundcore parport acpi_cpufreq tpm_tis tpm_tis_core tpm lpc_ich auth_rpcgss nfs_acl lockd grace sunrpc amdkfd amd_iommu_v2 amdgpu i2c_algo_bit drm_kms_helper syscopyarea sysfillrect e1000e sysimgblt fb_sys_fops ttm hid_sjoy ff_memless firewire_ohci firewire_core drm serio_raw ata_generic pata_acpi crc_itu_t ptp pps_core
[   66.058080] CPU: 3 PID: 2092 Comm: systemd-udevd Not tainted 4.12.0-rc1+ #1
[   66.058080] Hardware name:                  /DG45ID, BIOS IDG4510H.86A.0135.2011.0225.1100 02/25/2011
[   66.058080] task: ffff88bb9e34c000 task.stack: ffffa014c071c000
[   66.058080] RIP: 0010:__lock_acquire+0x122/0x12e0
[   66.058080] RSP: 0018:ffffa014c071f720 EFLAGS: 00010002
[   66.058080] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[   66.058080] RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000000
[   66.058080] RBP: ffffa014c071f7e0 R08: ffffffff9b0be570 R09: 0000000000000001
[   66.058080] R10: 0000000000000000 R11: ffff88bb9e34c000 R12: 0000000000000001
[   66.058080] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000ba0
[   66.058080] FS:  00007f7be5e84640(0000) GS:ffff88bbabd80000(0000) knlGS:0000000000000000
[   66.058080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.058080] CR2: 0000000000000ba0 CR3: 000000021bb83000 CR4: 00000000000006e0
[   66.058080] Call Trace:
[   66.058080]  lock_acquire+0xc7/0x1a0
[   66.058080]  ? lock_acquire+0xc7/0x1a0
[   66.058080]  ? try_to_wake_up+0x40/0x500
[   66.058080]  _raw_spin_lock_irqsave+0x33/0x50
[   66.058080]  ? try_to_wake_up+0x40/0x500
[   66.058080]  try_to_wake_up+0x40/0x500
[   66.058080]  ? input_open_device+0x28/0xa0
[   66.058080]  ? __mutex_lock+0x75/0x970
[   66.058080]  ? rc_open+0x2a/0x80 [rc_core]
[   66.058080]  wake_up_process+0x15/0x20
[   66.058080]  ir_raw_event_handle+0x1e/0x20 [rc_core]
[   66.058080]  iguanair_receiver+0x6c/0xa0 [iguanair]
[   66.058080]  iguanair_open+0x30/0x50 [iguanair]
[   66.058080]  rc_open+0x4e/0x80 [rc_core]
[   66.058080]  ir_open+0x15/0x20 [rc_core]
[   66.058080]  input_open_device+0x7b/0xa0
[   66.058080]  kbd_connect+0x73/0x90
[   66.058080]  ? trace_hardirqs_on_caller+0xed/0x180
[   66.058080]  input_attach_handler+0x1a2/0x1e0
[   66.058080]  input_register_device+0x483/0x530
[   66.058080]  rc_register_device+0x47e/0x590 [rc_core]
[   66.058080]  iguanair_probe+0x500/0x610 [iguanair]
[   66.058080]  usb_probe_interface+0x15f/0x2d0
[   66.058080]  driver_probe_device+0x29c/0x450
[   66.058080]  __driver_attach+0xe3/0xf0
[   66.058080]  ? driver_probe_device+0x450/0x450
[   66.058080]  bus_for_each_dev+0x73/0xc0
[   66.058080]  driver_attach+0x1e/0x20
[   66.058080]  bus_add_driver+0x173/0x270
[   66.058080]  driver_register+0x60/0xe0
[   66.058080]  usb_register_driver+0xaa/0x160
[   66.058080]  ? 0xffffffffc0349000
[   66.058080]  iguanair_driver_init+0x1e/0x1000 [iguanair]
[   66.058080]  do_one_initcall+0x52/0x190
[   66.058080]  ? rcu_read_lock_sched_held+0x5d/0x70
[   66.058080]  ? kmem_cache_alloc_trace+0x1f4/0x260
[   66.058080]  ? do_init_module+0x27/0x1fa
[   66.058080]  do_init_module+0x5f/0x1fa
[   66.058080]  load_module+0x2823/0x2cd0
[   66.058080]  ? vfs_read+0x11b/0x130
[   66.058080]  SYSC_finit_module+0xdf/0x110
[   66.058080]  ? SYSC_finit_module+0xdf/0x110
[   66.058080]  SyS_finit_module+0xe/0x10
[   66.058080]  entry_SYSCALL_64_fastpath+0x18/0xad
[   66.058080] RIP: 0033:0x7f7be4afebf9
[   66.058080] RSP: 002b:00007ffc1e53d558 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   66.058080] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007f7be4afebf9
[   66.058080] RDX: 0000000000000000 RSI: 00007f7be5637995 RDI: 0000000000000007
[   66.058080] RBP: 0000000000000005 R08: 0000000000000000 R09: 00007ffc1e53d670
[   66.058080] R10: 0000000000000007 R11: 0000000000000246 R12: 00007ffc1e53c550
[   66.058080] R13: 00007ffc1e53c530 R14: 0000000000000005 R15: 000055f1457d53d0
[   66.058080] Code: c8 65 48 33 34 25 28 00 00 00 44 89 f0 0f 85 26 0d 00 00 48 81 c4 90 00 00 00 5b 41 5a 41 5c 41 5d 41 5e 41 5f 5d 49 8d 62 f8 c3 <49> 81 3f 80 a9 2e 9c 41 bc 00 00 00 00 44 0f 45 e0 83 fe 01 0f 
[   66.058080] RIP: __lock_acquire+0x122/0x12e0 RSP: ffffa014c071f720
[   66.058080] CR2: 0000000000000ba0
[   66.058080] ---[ end trace a40e73805c213cce ]---

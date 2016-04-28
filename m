Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47448 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269AbcD1Lws (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 07:52:48 -0400
Date: Thu, 28 Apr 2016 08:52:42 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: <laurent.pinchart@ideasonboard.com>, <hans.verkuil@cisco.com>,
	<chehabrafael@gmail.com>, <sakari.ailus@iki.fi>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: fix media_ioctl use-after-free when driver
 unbinds
Message-ID: <20160428085242.09b22bc7@recife.lan>
In-Reply-To: <5720C3CC.5090009@osg.samsung.com>
References: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
	<20160427065526.7f091355@recife.lan>
	<5720C3CC.5090009@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 07:51:08 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> > - cdev patch;
> > - kref patch.
> > 
> > As a bonus side, by breaking into that, it helps to identify what
> > fixes are needed if we found similar issues at the other parts of
> > the subsystems.  
> 
> No problem breaking the it into 3 patches. I think the order should
> be kref and the a patch to set cdev kobj parent. Is that what you
> had in mind?

Works for me.

> 
> > 
> > If I remember well, I ended by having some cdev troubles with the
> > V4L2 core on one of my stress test. So, this is something that
> > we want to double check at RC, DVB and V4L parts that handle
> > cdev, and eventually porting the changes to the core of those
> > subsystems.  
> 
> Is that when you were playing with allocating cdev as opposed to
> setting parent. btw. just setting parent isn't enough. Kobject
> is necessary as it can then invoke the kobject put handler from
> cdev-core.

V4L2 has kref, as far as I remember, but not sure if it is doing
the right thing. As I pointed on the previous e-mail, I'm getting
some cdev issues that seem to be related to V4L2, like this:

[ 1002.856150] general protection fault: 0000 [#5] SMP KASAN
[ 1002.859995] Modules linked in: ir_lirc_codec lirc_dev au8522_dig xc5000 tuner au8522_decoder au8522_common au0828 videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core tveeprom dvb_core rc_core v4l2_common videodev media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel i915 snd_hda_codec_realtek snd_hda_codec_generic sha256_ssse3 sha256_generic hmac drbg btusb btrtl btbcm aesni_intel evdev snd_hda_intel aes_x86_64 lrw btintel i2c_algo_bit snd_hda_codec gf128mul bluetooth glue_helper drm_kms_helper snd_hwdep ablk_helper cryptd snd_hda_core drm serio_raw
[ 1002.870406]  rfkill sg snd_pcm pcspkr snd_timer mei_me snd mei lpc_ich i2c_i801 mfd_core soundcore battery dw_dmac video dw_dmac_core i2c_designware_platform i2c_designware_core acpi_pad button tpm_tis tpm ext4 crc16 jbd2 mbcache dm_mod sd_mod ahci libahci psmouse libata e1000e ehci_pci xhci_pci ptp scsi_mod ehci_hcd pps_core xhci_hcd fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid
[ 1002.874971] CPU: 2 PID: 3640 Comm: v4l_id Tainted: G      D         4.6.0-rc2+ #68
[ 1002.877246] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1002.879650] task: ffff88009c273000 ti: ffff880035c70000 task.ti: ffff880035c70000
[ 1002.882891] RIP: 0010:[<ffffffff81d77a61>]  [<ffffffff81d77a61>] usb_ifnum_to_if+0x31/0x270
[ 1002.886337] RSP: 0018:ffff880035c778d0  EFLAGS: 00010282
[ 1002.889950] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 1ffff1001364fc5e
[ 1002.892009] RDX: 000000000000009e RSI: 0000000000000000 RDI: 00000000000004f0
[ 1002.893996] RBP: ffff880035c77908 R08: 0000000000000001 R09: 0000000000000001
[ 1002.895895] R10: ffff8803a239abf0 R11: 0000000000000000 R12: ffffffffa12be0c0
[ 1002.898465] R13: ffff88009b27eb3c R14: ffff88009b27c080 R15: ffffffffa12a89b0
[ 1002.902048] FS:  00007f0312a7e700(0000) GS:ffff8803c6900000(0000) knlGS:0000000000000000
[ 1002.905584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1002.908676] CR2: 0000000001c84db0 CR3: 00000003a1cd8000 CR4: 00000000003406e0
[ 1002.910528] Stack:
[ 1002.912378]  ffff8803bf048000 ffff88009b27e2f0 ffff88009b27c000 ffffffffa12be0c0
[ 1002.915578]  ffff88009b27eb3c ffff88009b27c080 ffffffffa12a89b0 ffff880035c77940
[ 1002.919242]  ffffffffa12a4a45 ffff880035c77940 ffff88009b27c000 0000000000000000
[ 1002.921590] Call Trace:
[ 1002.923451]  [<ffffffffa12a89b0>] ? au0828_v4l2_close+0x5a0/0x5a0 [au0828]
[ 1002.925339]  [<ffffffffa12a4a45>] au0828_analog_stream_enable+0x85/0x330 [au0828]
[ 1002.927234]  [<ffffffffa12a8b11>] au0828_v4l2_open+0x161/0x350 [au0828]
[ 1002.930247]  [<ffffffffa12a89b0>] ? au0828_v4l2_close+0x5a0/0x5a0 [au0828]
[ 1002.932695]  [<ffffffffa1169561>] v4l2_open+0x1d1/0x350 [videodev]
[ 1002.934556]  [<ffffffff815cc071>] chrdev_open+0x1f1/0x580
[ 1002.936446]  [<ffffffff815cbe80>] ? cdev_put+0x50/0x50
[ 1002.938301]  [<ffffffff815b98a7>] do_dentry_open+0x5d7/0xac0
[ 1002.941460]  [<ffffffff815cbe80>] ? cdev_put+0x50/0x50
[ 1002.943705]  [<ffffffff815bc05b>] vfs_open+0x16b/0x1e0
[ 1002.945529]  [<ffffffff815e1c0b>] ? may_open+0x14b/0x260
[ 1002.947334]  [<ffffffff815eb3f7>] path_openat+0x4f7/0x3a00
[ 1002.949259]  [<ffffffff8156cc95>] ? alloc_debug_processing+0x75/0x1c0
[ 1002.951185]  [<ffffffff815eaf00>] ? vfs_create+0x390/0x390
[ 1002.953004]  [<ffffffff811ad88e>] ? __kernel_text_address+0x7e/0xa0
[ 1002.954820]  [<ffffffff8109154f>] ? print_context_stack+0x7f/0xf0
[ 1002.956646]  [<ffffffff8124b110>] ? debug_check_no_locks_freed+0x290/0x290
[ 1002.959007]  [<ffffffff815b105b>] ? create_object+0x3eb/0x940
[ 1002.962537]  [<ffffffff8124a5f6>] ? trace_hardirqs_on_caller+0x16/0x590
[ 1002.966090]  [<ffffffff815f1cd5>] do_filp_open+0x175/0x230
[ 1002.969603]  [<ffffffff815f1b60>] ? user_path_mountpoint_at+0x40/0x40
[ 1002.973088]  [<ffffffff822d8567>] ? _raw_spin_unlock+0x27/0x40
[ 1002.974921]  [<ffffffff81615b1a>] ? __alloc_fd+0x19a/0x4b0
[ 1002.976759]  [<ffffffff8156d653>] ? kmem_cache_alloc+0x233/0x300
[ 1002.978808]  [<ffffffff815bc615>] do_sys_open+0x195/0x340
[ 1002.982167]  [<ffffffff8123eb5f>] ? up_read+0x1f/0x40
[ 1002.983986]  [<ffffffff815bc480>] ? filp_open+0x60/0x60
[ 1002.985810]  [<ffffffff81242681>] ? trace_hardirqs_off_caller+0x21/0x290
[ 1002.987630]  [<ffffffff8100401b>] ? trace_hardirqs_on_thunk+0x1b/0x1d
[ 1002.989456]  [<ffffffff815bc7de>] SyS_open+0x1e/0x20
[ 1002.991271]  [<ffffffff822d8dc0>] entry_SYSCALL_64_fastpath+0x23/0xc1
[ 1002.993950]  [<ffffffff81242681>] ? trace_hardirqs_off_caller+0x21/0x290
[ 1002.997492] Code: 48 b8 00 00 00 00 00 fc ff df 48 89 e5 41 57 41 56 41 55 41 54 53 48 89 fb 48 81 c7 f0 04 00 00 48 89 fa 48 c1 ea 03 48 83 ec 10 <80> 3c 02 00 0f 85 c6 01 00 00 4c 8b bb f0 04 00 00 4d 85 ff 0f 
[ 1003.000679] RIP  [<ffffffff81d77a61>] usb_ifnum_to_if+0x31/0x270
[ 1003.002620]  RSP <ffff880035c778d0>
[ 1003.019559] ---[ end trace 9127ab975e0f4107 ]---


-- 
Thanks,
Mauro

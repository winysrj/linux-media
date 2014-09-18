Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36601 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbaIRQVT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 12:21:19 -0400
Date: Thu, 18 Sep 2014 13:21:13 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] vb2/saa7134 regression/documentation fixes
Message-ID: <20140918132113.2e3b76f5@recife.lan>
In-Reply-To: <5419B16A.6060800@xs4all.nl>
References: <1410945272-48149-1-git-send-email-hverkuil@xs4all.nl>
	<5419B16A.6060800@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Sep 2014 18:06:02 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/17/2014 11:14 AM, Hans Verkuil wrote:
> > This fixes the VBI regression seen in saa7134 when it was converted
> > to vb2. Tested with my saa7134 board.
> > 
> > It also updates the poll documentation and fixes a saa7134 bug where
> > the WSS signal was never captured.
> > 
> > The first patch should go to 3.17. It won't apply to older kernels,
> > so I guess once this is merged we should post a patch to stable for
> > those older kernels, certainly 3.16.
> > 
> > I would expect this to be an issue for em28xx as well, but I will
> > need to test that. If that driver is affected as well, then this
> > fix needs to go into 3.9 and up.
> 
> Update: the VBI apps won't work with the em28xx driver as I suspected.
> With the fix all is fine for em28xx.

At least here, em28xx with one application (xawtv or qv4l2) reading
at video0 and another one for vbi (mtt or zvbi), I'm getting the
errors below. Clearly, it is not just the poll syscall that it is
wrong on VB2 and/or em28xx.

I'm trying to identify what else is wrong there.

Regards,
Mauro

[63271.912808] ------------[ cut here ]------------
[63271.912832] WARNING: CPU: 5 PID: 14761 at drivers/media/v4l2-core/videobuf2-core.c:2126 __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]()
[63271.912835] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63271.913037]  wmi video r8169 mii
[63271.913048] CPU: 5 PID: 14761 Comm: xawtv Not tainted 3.16.0-rc6+ #23
[63271.913055] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63271.913059]  0000000000000000 00000000051c953c ffff8800c4957c08 ffffffff816f523f
[63271.913067]  0000000000000000 ffff8800c4957c40 ffffffff8108be8d 0000000000000000
[63271.913072]  0000000000000001 ffff8800c5488948 ffff88003dd35500 0000000000000000
[63271.913081] Call Trace:
[63271.913098]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63271.913108]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63271.913115]  [<ffffffff8108bfba>] warn_slowpath_null+0x1a/0x20
[63271.913137]  [<ffffffffa0319951>] __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]
[63271.913155]  [<ffffffffa031a2c5>] vb2_internal_streamoff+0x35/0x90 [videobuf2_core]
[63271.913171]  [<ffffffffa031a355>] vb2_streamoff+0x35/0x60 [videobuf2_core]
[63271.913184]  [<ffffffffa031a3c8>] vb2_ioctl_streamoff+0x48/0x50 [videobuf2_core]
[63271.913200]  [<ffffffffa02f0a8a>] v4l_streamoff+0x1a/0x20 [videodev]
[63271.913215]  [<ffffffffa02f39c4>] __video_do_ioctl+0x294/0x310 [videodev]
[63271.913231]  [<ffffffffa02f63be>] video_usercopy+0x22e/0x5b0 [videodev]
[63271.913244]  [<ffffffffa02f3730>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
[63271.913258]  [<ffffffff810d26f1>] ? remove_wait_queue+0x31/0x40
[63271.913269]  [<ffffffff81425f92>] ? n_tty_write+0x392/0x510
[63271.913283]  [<ffffffffa02f6755>] video_ioctl2+0x15/0x20 [videodev]
[63271.913295]  [<ffffffffa02ef71b>] v4l2_ioctl+0x11b/0x150 [videodev]
[63271.913304]  [<ffffffff81200640>] do_vfs_ioctl+0x2e0/0x4a0
[63271.913310]  [<ffffffff81200881>] SyS_ioctl+0x81/0xa0
[63271.913319]  [<ffffffff81122656>] ? __audit_syscall_exit+0x1f6/0x2a0
[63271.913328]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63271.913333] ---[ end trace 9381964a5237f703 ]---
[63276.841245] ------------[ cut here ]------------
[63276.841256] WARNING: CPU: 1 PID: 1495 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[63276.841258] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/ep_81'
[63276.841260] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.841326]  wmi video r8169 mii
[63276.841333] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.841335] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.841337]  0000000000000000 0000000036bcbe1b ffff8800c1a137e8 ffffffff816f523f
[63276.841342]  ffff8800c1a13830 ffff8800c1a13820 ffffffff8108be8d ffff8800c7896000
[63276.841345]  ffff8800c7e07ea0 ffff8802217877f8 ffff880219ca4c10 ffff88021a763c58
[63276.841349] Call Trace:
[63276.841359]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.841364]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.841368]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.841373]  [<ffffffff81262b98>] ? kernfs_path+0x48/0x60
[63276.841376]  [<ffffffff812662a4>] sysfs_warn_dup+0x64/0x80
[63276.841380]  [<ffffffff8126634e>] sysfs_create_dir_ns+0x8e/0xa0
[63276.841387]  [<ffffffff8135837f>] kobject_add_internal+0xbf/0x3f0
[63276.841391]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.841396]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.841400]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.841403]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.841410]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.841414]  [<ffffffff814ec2c5>] ? usb_enable_endpoint+0x85/0x90
[63276.841418]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.841421]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.841428]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.841439]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.841448]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.841454]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.841463]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.841469]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.841478]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.841486]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.841494]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.841498]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.841503]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.841506]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.841510]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.841514]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.841518]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.841524]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.841529]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.841532]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.841536]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.841540]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.841546]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.841549]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.841553]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.841558]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.841561] ---[ end trace 9381964a5237f704 ]---
[63276.841563] ------------[ cut here ]------------
[63276.841568] WARNING: CPU: 1 PID: 1495 at lib/kobject.c:240 kobject_add_internal+0x284/0x3f0()
[63276.841570] kobject_add_internal failed for ep_81 with -EEXIST, don't try to register things with the same name in the same directory.
[63276.841572] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.841619]  wmi video r8169 mii
[63276.841624] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.841626] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.841627]  0000000000000000 0000000036bcbe1b ffff8800c1a13838 ffffffff816f523f
[63276.841631]  ffff8800c1a13880 ffff8800c1a13870 ffffffff8108be8d ffff880219ca4c20
[63276.841634]  00000000ffffffef ffff88021a364040 ffff880219ca4c10 ffff88021a763c58
[63276.841638] Call Trace:
[63276.841642]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.841646]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.841649]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.841654]  [<ffffffff81358544>] kobject_add_internal+0x284/0x3f0
[63276.841658]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.841661]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.841665]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.841679]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.841684]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.841688]  [<ffffffff814ec2c5>] ? usb_enable_endpoint+0x85/0x90
[63276.841692]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.841707]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.841712]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.841732]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.841741]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.841746]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.841755]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.841761]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.841770]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.841779]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.841787]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.841791]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.841796]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.841800]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.841804]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.841808]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.841813]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.841818]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.841823]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.841827]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.841831]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.841836]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.841841]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.841846]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.841850]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.841855]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.841857] ---[ end trace 9381964a5237f705 ]---
[63276.841867] ------------[ cut here ]------------
[63276.841872] WARNING: CPU: 1 PID: 1495 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[63276.841874] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/ep_82'
[63276.841875] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.841930]  wmi video r8169 mii
[63276.841935] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.841937] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.841939]  0000000000000000 0000000036bcbe1b ffff8800c1a137e8 ffffffff816f523f
[63276.841943]  ffff8800c1a13830 ffff8800c1a13820 ffffffff8108be8d ffff8800c7896000
[63276.841947]  ffff8800c7e07ea0 ffff8802217877f8 ffff880219ca4c10 ffff88021a763c58
[63276.841951] Call Trace:
[63276.841957]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.841961]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.841965]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.841970]  [<ffffffff81262b98>] ? kernfs_path+0x48/0x60
[63276.841973]  [<ffffffff812662a4>] sysfs_warn_dup+0x64/0x80
[63276.841977]  [<ffffffff8126634e>] sysfs_create_dir_ns+0x8e/0xa0
[63276.841983]  [<ffffffff8135837f>] kobject_add_internal+0xbf/0x3f0
[63276.842028]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.842045]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.842081]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.842101]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.842123]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.842145]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.842166]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.842201]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.842225]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.842249]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.842267]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.842278]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.842288]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.842300]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.842311]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.842321]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.842327]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.842333]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.842338]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.842343]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.842349]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.842355]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.842361]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.842367]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.842373]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.842378]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.842384]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.842391]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.842396]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.842402]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.842408]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.842412] ---[ end trace 9381964a5237f706 ]---
[63276.842415] ------------[ cut here ]------------
[63276.842422] WARNING: CPU: 1 PID: 1495 at lib/kobject.c:240 kobject_add_internal+0x284/0x3f0()
[63276.842425] kobject_add_internal failed for ep_82 with -EEXIST, don't try to register things with the same name in the same directory.
[63276.842428] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.842499]  wmi video r8169 mii
[63276.842506] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.842509] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.842512]  0000000000000000 0000000036bcbe1b ffff8800c1a13838 ffffffff816f523f
[63276.842516]  ffff8800c1a13880 ffff8800c1a13870 ffffffff8108be8d ffff880219ca4c20
[63276.842521]  00000000ffffffef ffff88021a364040 ffff880219ca4c10 ffff88021a763c58
[63276.842528] Call Trace:
[63276.842535]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.842541]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.842546]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.842564]  [<ffffffff81358544>] kobject_add_internal+0x284/0x3f0
[63276.842585]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.842603]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.842622]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.842638]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.842658]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.842677]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.842694]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.842715]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.842734]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.842747]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.842754]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.842764]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.842771]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.842784]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.842795]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.842804]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.842809]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.842815]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.842820]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.842826]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.842831]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.842839]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.842845]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.842852]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.842857]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.842863]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.842868]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.842877]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.842882]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.842887]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.842893]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.842897] ---[ end trace 9381964a5237f707 ]---
[63276.842909] ------------[ cut here ]------------
[63276.842914] WARNING: CPU: 1 PID: 1495 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[63276.842918] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/ep_83'
[63276.842920] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.843045]  wmi video r8169 mii
[63276.843052] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.843056] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.843059]  0000000000000000 0000000036bcbe1b ffff8800c1a137e8 ffffffff816f523f
[63276.843065]  ffff8800c1a13830 ffff8800c1a13820 ffffffff8108be8d ffff8800c7896000
[63276.843070]  ffff8800c7e07ea0 ffff8802217877f8 ffff880219ca4c10 ffff88021a763c58
[63276.843086] Call Trace:
[63276.843098]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.843104]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.843109]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.843115]  [<ffffffff81262b98>] ? kernfs_path+0x48/0x60
[63276.843122]  [<ffffffff812662a4>] sysfs_warn_dup+0x64/0x80
[63276.843134]  [<ffffffff8126634e>] sysfs_create_dir_ns+0x8e/0xa0
[63276.843141]  [<ffffffff8135837f>] kobject_add_internal+0xbf/0x3f0
[63276.843147]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.843157]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.843163]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.843171]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.843182]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.843188]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.843193]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.843204]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.843217]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.843232]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.843238]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.843247]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.843254]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.843262]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.843270]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.843277]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.843280]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.843284]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.843287]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.843293]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.843296]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.843300]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.843305]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.843309]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.843312]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.843316]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.843320]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.843325]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.843330]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.843334]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.843338]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.843340] ---[ end trace 9381964a5237f708 ]---
[63276.843342] ------------[ cut here ]------------
[63276.843347] WARNING: CPU: 1 PID: 1495 at lib/kobject.c:240 kobject_add_internal+0x284/0x3f0()
[63276.843349] kobject_add_internal failed for ep_83 with -EEXIST, don't try to register things with the same name in the same directory.
[63276.843350] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.843401]  wmi video r8169 mii
[63276.843405] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.843407] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.843409]  0000000000000000 0000000036bcbe1b ffff8800c1a13838 ffffffff816f523f
[63276.843412]  ffff8800c1a13880 ffff8800c1a13870 ffffffff8108be8d ffff880219ca4c20
[63276.843416]  00000000ffffffef ffff88021a364040 ffff880219ca4c10 ffff88021a763c58
[63276.843419] Call Trace:
[63276.843424]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.843427]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.843431]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.843435]  [<ffffffff81358544>] kobject_add_internal+0x284/0x3f0
[63276.843441]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.843444]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.843448]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.843451]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.843456]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.843459]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.843463]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.843467]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.843475]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.843483]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.843487]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.843496]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.843501]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.843508]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.843516]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.843523]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.843526]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.843530]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.843535]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.843538]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.843542]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.843546]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.843550]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.843554]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.843558]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.843562]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.843566]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.843570]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.843575]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.843579]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.843583]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.843585] ---[ end trace 9381964a5237f709 ]---
[63276.843593] ------------[ cut here ]------------
[63276.843596] WARNING: CPU: 1 PID: 1495 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80()
[63276.843598] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:14.0/usb3/3-2/3-2:1.0/ep_84'
[63276.843600] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.843650]  wmi video r8169 mii
[63276.843654] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.843656] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.843657]  0000000000000000 0000000036bcbe1b ffff8800c1a137e8 ffffffff816f523f
[63276.843661]  ffff8800c1a13830 ffff8800c1a13820 ffffffff8108be8d ffff8800c7896000
[63276.843664]  ffff8800c7e07ea0 ffff8802217877f8 ffff880219ca4c10 ffff88021a763c58
[63276.843668] Call Trace:
[63276.843672]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.843675]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.843679]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.843683]  [<ffffffff81262b98>] ? kernfs_path+0x48/0x60
[63276.843688]  [<ffffffff812662a4>] sysfs_warn_dup+0x64/0x80
[63276.843691]  [<ffffffff8126634e>] sysfs_create_dir_ns+0x8e/0xa0
[63276.843695]  [<ffffffff8135837f>] kobject_add_internal+0xbf/0x3f0
[63276.843699]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.843703]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.843706]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.843709]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.843714]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.843717]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.843721]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.843727]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.843734]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.843742]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.843746]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.843753]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.843758]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.843767]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.843775]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.843781]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.843784]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.843788]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.843792]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.843795]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.843800]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.843804]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.843809]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.843813]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.843816]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.843820]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.843824]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.843829]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.843832]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.843836]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.843841]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.843843] ---[ end trace 9381964a5237f70a ]---
[63276.843845] ------------[ cut here ]------------
[63276.843849] WARNING: CPU: 1 PID: 1495 at lib/kobject.c:240 kobject_add_internal+0x284/0x3f0()
[63276.843851] kobject_add_internal failed for ep_84 with -EEXIST, don't try to register things with the same name in the same directory.
[63276.843852] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63276.843901]  wmi video r8169 mii
[63276.843905] CPU: 1 PID: 1495 Comm: pulseaudio Tainted: G        W     3.16.0-rc6+ #23
[63276.843907] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63276.843908]  0000000000000000 0000000036bcbe1b ffff8800c1a13838 ffffffff816f523f
[63276.843913]  ffff8800c1a13880 ffff8800c1a13870 ffffffff8108be8d ffff880219ca4c20
[63276.843917]  00000000ffffffef ffff88021a364040 ffff880219ca4c10 ffff88021a763c58
[63276.843920] Call Trace:
[63276.843924]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63276.843928]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63276.843931]  [<ffffffff8108bf0c>] warn_slowpath_fmt+0x5c/0x80
[63276.843936]  [<ffffffff81358544>] kobject_add_internal+0x284/0x3f0
[63276.843940]  [<ffffffff81358b75>] kobject_add+0x75/0xd0
[63276.843943]  [<ffffffff81462ae3>] ? device_private_init+0x23/0x80
[63276.843948]  [<ffffffff81462c65>] device_add+0x125/0x630
[63276.843951]  [<ffffffff8146318a>] device_register+0x1a/0x20
[63276.843956]  [<ffffffff814f2fa1>] usb_create_ep_devs+0x81/0xd0
[63276.843959]  [<ffffffff814eb69d>] create_intf_ep_devs+0x5d/0x80
[63276.843962]  [<ffffffff814ec585>] usb_set_interface+0x255/0x380
[63276.843967]  [<ffffffffa061c0a8>] snd_em28xx_capture_open+0x218/0x2d0 [em28xx_alsa]
[63276.843974]  [<ffffffffa012e835>] snd_pcm_open_substream+0x85/0x140 [snd_pcm]
[63276.843983]  [<ffffffffa012e9b2>] snd_pcm_open+0xc2/0x270 [snd_pcm]
[63276.844011]  [<ffffffff811d117c>] ? kmem_cache_alloc_trace+0x3c/0x200
[63276.844034]  [<ffffffffa0100d7a>] ? snd_card_file_add+0x2a/0xd0 [snd]
[63276.844056]  [<ffffffff810bf570>] ? wake_up_state+0x20/0x20
[63276.844079]  [<ffffffffa012eba3>] snd_pcm_capture_open+0x43/0x70 [snd_pcm]
[63276.844104]  [<ffffffffa0100594>] snd_open+0xb4/0x190 [snd]
[63276.844123]  [<ffffffff811f1e79>] chrdev_open+0xb9/0x1a0
[63276.844143]  [<ffffffff811ea7bf>] do_dentry_open+0x1ff/0x340
[63276.844161]  [<ffffffff811f1dc0>] ? cdev_put+0x30/0x30
[63276.844180]  [<ffffffff811eaad1>] finish_open+0x31/0x40
[63276.844197]  [<ffffffff811fca24>] do_last+0xa64/0x1190
[63276.844217]  [<ffffffff811f8d01>] ? link_path_walk+0x81/0x880
[63276.844224]  [<ffffffff811d1316>] ? kmem_cache_alloc_trace+0x1d6/0x200
[63276.844230]  [<ffffffff812edecc>] ? selinux_file_alloc_security+0x3c/0x60
[63276.844237]  [<ffffffff811fd21d>] path_openat+0xcd/0x670
[63276.844242]  [<ffffffff811f8779>] ? putname+0x29/0x40
[63276.844250]  [<ffffffff811fdf02>] ? user_path_at_empty+0x72/0xc0
[63276.844256]  [<ffffffff811fe01d>] do_filp_open+0x4d/0xb0
[63276.844262]  [<ffffffff8120a9fd>] ? __alloc_fd+0x7d/0x120
[63276.844267]  [<ffffffff811ec557>] do_sys_open+0x137/0x240
[63276.844273]  [<ffffffff811ec67e>] SyS_open+0x1e/0x20
[63276.844279]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63276.844283] ---[ end trace 9381964a5237f70b ]---
[63276.947086] xc2028 19-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[63277.889918] xc2028 19-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[63277.904978] xc2028 19-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[63279.266689] tvp5150 19-005c: i2c i/o error: rc == -6
[63279.273050] tvp5150 19-005c: i2c i/o error: rc == -6
[63279.322160] tvp5150 19-005c: i2c i/o error: rc == -6
[63279.323365] tvp5150 19-005c: i2c i/o error: rc == -6
[63279.372175] xc2028 19-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[63280.357379] xc2028 19-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[63280.374595] xc2028 19-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[63280.544446] ------------[ cut here ]------------
[63280.544469] WARNING: CPU: 4 PID: 14819 at drivers/media/v4l2-core/videobuf2-core.c:2126 __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]()
[63280.544472] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63280.544534]  wmi video r8169 mii
[63280.544542] CPU: 4 PID: 14819 Comm: xawtv Tainted: G        W     3.16.0-rc6+ #23
[63280.544545] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63280.544547]  0000000000000000 00000000172d2101 ffff8800c8b9bc08 ffffffff816f523f
[63280.544552]  0000000000000000 ffff8800c8b9bc40 ffffffff8108be8d 0000000000000000
[63280.544556]  0000000000000001 ffff8800c5488948 ffff88021a5b4a00 0000000000000000
[63280.544560] Call Trace:
[63280.544571]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63280.544577]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63280.544581]  [<ffffffff8108bfba>] warn_slowpath_null+0x1a/0x20
[63280.544589]  [<ffffffffa0319951>] __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]
[63280.544597]  [<ffffffffa031a2c5>] vb2_internal_streamoff+0x35/0x90 [videobuf2_core]
[63280.544603]  [<ffffffffa031a355>] vb2_streamoff+0x35/0x60 [videobuf2_core]
[63280.544610]  [<ffffffffa031a3c8>] vb2_ioctl_streamoff+0x48/0x50 [videobuf2_core]
[63280.544619]  [<ffffffffa02f0a8a>] v4l_streamoff+0x1a/0x20 [videodev]
[63280.544628]  [<ffffffffa02f39c4>] __video_do_ioctl+0x294/0x310 [videodev]
[63280.544637]  [<ffffffffa02f63be>] video_usercopy+0x22e/0x5b0 [videodev]
[63280.544645]  [<ffffffffa02f3730>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
[63280.544654]  [<ffffffffa02f6755>] video_ioctl2+0x15/0x20 [videodev]
[63280.544662]  [<ffffffffa02ef71b>] v4l2_ioctl+0x11b/0x150 [videodev]
[63280.544669]  [<ffffffff81200640>] do_vfs_ioctl+0x2e0/0x4a0
[63280.544674]  [<ffffffff81200881>] SyS_ioctl+0x81/0xa0
[63280.544681]  [<ffffffff81122656>] ? __audit_syscall_exit+0x1f6/0x2a0
[63280.544688]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[63280.544690] ---[ end trace 9381964a5237f70c ]---
[63287.078863] tvp5150 19-005c: i2c i/o error: rc == -6
[63287.136674] tvp5150 19-005c: i2c i/o error: rc == -6
[63287.263527] ------------[ cut here ]------------
[63287.263537] WARNING: CPU: 4 PID: 14819 at drivers/media/v4l2-core/videobuf2-core.c:2126 __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]()
[63287.263538] Modules linked in: rc_hauppauge em28xx_rc rc_core lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l em28xx tveeprom fuse ip6table_filter ip6_tables bnep binfmt_misc vfat fat nouveau x86_pkg_temp_thermal coretemp kvm_intel kvm arc4 iwldvm mac80211 i915 uvcvideo iwlwifi ttm videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel crct10dif_pclmul media cfg80211 snd_hda_controller iTCO_wdt mxm_wmi i2c_algo_bit drm_kms_helper drm crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec snd_hwdep iTCO_vendor_support btusb bluetooth snd_seq snd_seq_device snd_pcm snd_timer snd soundcore mei_me mei joydev i2c_i801 serio_raw microcode rfkill i2c_core lpc_ich mfd_core shpchp
[63287.263567]  wmi video r8169 mii
[63287.263570] CPU: 4 PID: 14819 Comm: xawtv Tainted: G        W     3.16.0-rc6+ #23
[63287.263572] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[63287.263573]  0000000000000000 00000000172d2101 ffff8800c8b9bd60 ffffffff816f523f
[63287.263575]  0000000000000000 ffff8800c8b9bd98 ffffffff8108be8d 0000000000000000
[63287.263576]  ffff8800c5488da8 ffff8800c5488948 ffff8800c5488800 ffff8800c54887a0
[63287.263578] Call Trace:
[63287.263583]  [<ffffffff816f523f>] dump_stack+0x45/0x56
[63287.263586]  [<ffffffff8108be8d>] warn_slowpath_common+0x7d/0xa0
[63287.263588]  [<ffffffff8108bfba>] warn_slowpath_null+0x1a/0x20
[63287.263591]  [<ffffffffa0319951>] __vb2_queue_cancel+0x1b1/0x260 [videobuf2_core]
[63287.263594]  [<ffffffff814eb69d>] ? create_intf_ep_devs+0x5d/0x80
[63287.263598]  [<ffffffffa031c62a>] vb2_queue_release+0x1a/0x30 [videobuf2_core]
[63287.263600]  [<ffffffffa031c6a1>] _vb2_fop_release+0x61/0xa0 [videobuf2_core]
[63287.263603]  [<ffffffffa031c70a>] vb2_fop_release+0x2a/0x50 [videobuf2_core]
[63287.263606]  [<ffffffffa0752194>] em28xx_v4l2_close+0xf4/0x1d0 [em28xx_v4l]
[63287.263610]  [<ffffffffa02ef498>] v4l2_release+0x38/0x80 [videodev]
[63287.263613]  [<ffffffff811ef11c>] __fput+0xdc/0x1e0
[63287.263615]  [<ffffffff811ef26e>] ____fput+0xe/0x10
[63287.263618]  [<ffffffff810ab9df>] task_work_run+0x9f/0xe0
[63287.263620]  [<ffffffff81013b71>] do_notify_resume+0x61/0xa0
[63287.263623]  [<ffffffff816fcb22>] int_signal+0x12/0x17
[63287.263624] ---[ end trace 9381964a5237f70d ]---


> 
> 	Hans
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:48846 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaANU4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 15:56:42 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so474602eek.29
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 12:56:41 -0800 (PST)
Message-ID: <52D5A4D0.1020509@googlemail.com>
Date: Tue, 14 Jan 2014 21:57:52 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/7] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <1389567649-26838-1-git-send-email-m.chehab@samsung.com> <1389567649-26838-4-git-send-email-m.chehab@samsung.com> <52D4383B.6030304@googlemail.com> <20140113172334.191862a7@samsung.com> <52D460D8.1000807@googlemail.com> <20140114111054.58ede4a3@samsung.com> <52D57E2C.2070407@googlemail.com> <20140114165512.2d14af95@samsung.com> <20140114173121.1f06ec38@samsung.com>
In-Reply-To: <20140114173121.1f06ec38@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.01.2014 20:31, schrieb Mauro Carvalho Chehab:
>
> Ok, patch 5 is not needed anymore.
>
> However, after a series of removals and re-inserts, I got these:
>
>
> [120982.699455] ------------[ cut here ]------------
> [120982.699509] WARNING: CPU: 0 PID: 7953 at lib/list_debug.c:33 __list_add+0xac/0xc0()
> [120982.699539] list_add corruption. prev->next should be next (ffff88019ffce4f8), but was 0000000d00000007. (prev=ffff880101dbfb48).
> [120982.699566] Modules linked in: lgdt330x tuner_xc2028 tuner tvp5150 rc_hauppauge em28xx_rc rc_core xc5000 drxk em28xx_dvb dvb_core em28xx_alsa em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom v4l2_common videodev media netconsole usb_storage fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 vfat fat iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
> [120982.701828]  snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iTCO_wdt iTCO_vendor_support btusb bluetooth joydev microcode serio_raw r8169 mii i2c_i801 lpc_ich mfd_core rfkill snd_page_alloc snd_timer snd mei_me soundcore mei shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video [last unloaded: videobuf2_memops]
> [120982.703581] CPU: 0 PID: 7953 Comm: xawtv Tainted: G      D      3.13.0-rc1+ #24
> [120982.703610] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> [120982.703638]  0000000000000009 ffff88011f63bb70 ffffffff816a03c6 ffff88011f63bbb8
> [120982.703794]  ffff88011f63bba8 ffffffff8106aaad ffff88018cfb3f48 ffff88019ffce4f8
> [120982.703924]  ffff880101dbfb48 0000000000000282 0000000000000000 ffff88011f63bc08
> [120982.704056] Call Trace:
> [120982.704093]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> [120982.704129]  [<ffffffff8106aaad>] warn_slowpath_common+0x7d/0xa0
> [120982.704162]  [<ffffffff8106ab1c>] warn_slowpath_fmt+0x4c/0x50
> [120982.704197]  [<ffffffff81343bac>] __list_add+0xac/0xc0
> [120982.704233]  [<ffffffffa04fd70b>] buffer_queue+0x7b/0xb0 [em28xx_v4l]
> [120982.704432]  [<ffffffffa04862d4>] __enqueue_in_driver+0x74/0x80 [videobuf2_core]
> [120982.704469]  [<ffffffffa04878c0>] vb2_streamon+0xa0/0x140 [videobuf2_core]
> [120982.704505]  [<ffffffffa04879a8>] vb2_ioctl_streamon+0x48/0x50 [videobuf2_core]
> [120982.704543]  [<ffffffffa04b7a8a>] v4l_streamon+0x1a/0x20 [videodev]
> [120982.704581]  [<ffffffffa04bb644>] __video_do_ioctl+0x2a4/0x330 [videodev]
> [120982.704619]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120982.704658]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120982.704719]  [<ffffffffa04bcae0>] video_usercopy+0x240/0x5d0 [videodev]
> [120982.704756]  [<ffffffff810b811d>] ? trace_hardirqs_on+0xd/0x10
> [120982.704792]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120982.704829]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120982.704867]  [<ffffffffa04bce85>] video_ioctl2+0x15/0x20 [videodev]
> [120982.704903]  [<ffffffffa04b6703>] v4l2_ioctl+0x123/0x160 [videodev]
> [120982.704939]  [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [120982.704974]  [<ffffffff812c7a96>] ? file_has_perm+0x86/0xa0
> [120982.705006]  [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [120982.705039]  [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [120982.705070] ---[ end trace 7e24c4fe20a76f18 ]---
> [120985.899453] ------------[ cut here ]------------
> [120985.899502] WARNING: CPU: 0 PID: 7953 at lib/list_debug.c:33 __list_add+0xac/0xc0()
> [120985.899531] list_add corruption. prev->next should be next (ffff88019ffce4f8), but was           (null). (prev=ffff88018cfb0348).
> [120985.899559] Modules linked in: lgdt330x tuner_xc2028 tuner tvp5150 rc_hauppauge em28xx_rc rc_core xc5000 drxk em28xx_dvb dvb_core em28xx_alsa em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom v4l2_common videodev media netconsole usb_storage fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 vfat fat iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
> [120985.901761]  snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iTCO_wdt iTCO_vendor_support btusb bluetooth joydev microcode serio_raw r8169 mii i2c_i801 lpc_ich mfd_core rfkill snd_page_alloc snd_timer snd mei_me soundcore mei shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video [last unloaded: videobuf2_memops]
> [120985.903502] CPU: 0 PID: 7953 Comm: xawtv Tainted: G      D W    3.13.0-rc1+ #24
> [120985.903530] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> [120985.903557]  0000000000000009 ffff88011f63bb70 ffffffff816a03c6 ffff88011f63bbb8
> [120985.903686]  ffff88011f63bba8 ffffffff8106aaad ffff88018cfb0348 ffff88019ffce4f8
> [120985.903826]  ffff88018cfb0348 0000000000000282 0000000000000000 ffff88011f63bc08
> [120985.903955] Call Trace:
> [120985.903988]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> [120985.904021]  [<ffffffff8106aaad>] warn_slowpath_common+0x7d/0xa0
> [120985.904052]  [<ffffffff8106ab1c>] warn_slowpath_fmt+0x4c/0x50
> [120985.904083]  [<ffffffff81343bac>] __list_add+0xac/0xc0
> [120985.904116]  [<ffffffffa04fd70b>] buffer_queue+0x7b/0xb0 [em28xx_v4l]
> [120985.904295]  [<ffffffffa04862d4>] __enqueue_in_driver+0x74/0x80 [videobuf2_core]
> [120985.904330]  [<ffffffffa04878c0>] vb2_streamon+0xa0/0x140 [videobuf2_core]
> [120985.904363]  [<ffffffffa04879a8>] vb2_ioctl_streamon+0x48/0x50 [videobuf2_core]
> [120985.904398]  [<ffffffffa04b7a8a>] v4l_streamon+0x1a/0x20 [videodev]
> [120985.904433]  [<ffffffffa04bb644>] __video_do_ioctl+0x2a4/0x330 [videodev]
> [120985.904470]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.904504]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.904540]  [<ffffffffa04bcae0>] video_usercopy+0x240/0x5d0 [videodev]
> [120985.904575]  [<ffffffff810b811d>] ? trace_hardirqs_on+0xd/0x10
> [120985.904608]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.904641]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.904676]  [<ffffffffa04bce85>] video_ioctl2+0x15/0x20 [videodev]
> [120985.904710]  [<ffffffffa04b6703>] v4l2_ioctl+0x123/0x160 [videodev]
> [120985.904743]  [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [120985.904780]  [<ffffffff812c7a96>] ? file_has_perm+0x86/0xa0
> [120985.904810]  [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [120985.904843]  [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [120985.904871] ---[ end trace 7e24c4fe20a76f19 ]---
> [120985.904896] ------------[ cut here ]------------
> [120985.904922] WARNING: CPU: 0 PID: 7953 at lib/list_debug.c:36 __list_add+0x8a/0xc0()
> [120985.904953] list_add double add: new=ffff88018cfb0348, prev=ffff88018cfb0348, next=ffff88019ffce4f8.
> [120985.904978] Modules linked in: lgdt330x tuner_xc2028 tuner tvp5150 rc_hauppauge em28xx_rc rc_core xc5000 drxk em28xx_dvb dvb_core em28xx_alsa em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom v4l2_common videodev media netconsole usb_storage fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 vfat fat iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
> [120985.907016]  snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iTCO_wdt iTCO_vendor_support btusb bluetooth joydev microcode serio_raw r8169 mii i2c_i801 lpc_ich mfd_core rfkill snd_page_alloc snd_timer snd mei_me soundcore mei shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video [last unloaded: videobuf2_memops]
> [120985.908654] CPU: 0 PID: 7953 Comm: xawtv Tainted: G      D W    3.13.0-rc1+ #24
> [120985.908680] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> [120985.908707]  0000000000000009 ffff88011f63bb70 ffffffff816a03c6 ffff88011f63bbb8
> [120985.908988]  ffff88011f63bba8 ffffffff8106aaad ffff88018cfb0348 ffff88019ffce4f8
> [120985.909110]  ffff88018cfb0348 0000000000000282 0000000000000000 ffff88011f63bc08
> [120985.909230] Call Trace:
> [120985.909268]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> [120985.909305]  [<ffffffff8106aaad>] warn_slowpath_common+0x7d/0xa0
> [120985.909336]  [<ffffffff8106ab1c>] warn_slowpath_fmt+0x4c/0x50
> [120985.909380]  [<ffffffff81343b8a>] __list_add+0x8a/0xc0
> [120985.909410]  [<ffffffffa04fd70b>] buffer_queue+0x7b/0xb0 [em28xx_v4l]
> [120985.909442]  [<ffffffffa04862d4>] __enqueue_in_driver+0x74/0x80 [videobuf2_core]
> [120985.909474]  [<ffffffffa04878c0>] vb2_streamon+0xa0/0x140 [videobuf2_core]
> [120985.909505]  [<ffffffffa04879a8>] vb2_ioctl_streamon+0x48/0x50 [videobuf2_core]
> [120985.909537]  [<ffffffffa04b7a8a>] v4l_streamon+0x1a/0x20 [videodev]
> [120985.909570]  [<ffffffffa04bb644>] __video_do_ioctl+0x2a4/0x330 [videodev]
> [120985.909604]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.909636]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.909670]  [<ffffffffa04bcae0>] video_usercopy+0x240/0x5d0 [videodev]
> [120985.909702]  [<ffffffff810b811d>] ? trace_hardirqs_on+0xd/0x10
> [120985.909732]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.909764]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.909799]  [<ffffffffa04bce85>] video_ioctl2+0x15/0x20 [videodev]
> [120985.909830]  [<ffffffffa04b6703>] v4l2_ioctl+0x123/0x160 [videodev]
> [120985.909860]  [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [120985.909890]  [<ffffffff812c7a96>] ? file_has_perm+0x86/0xa0
> [120985.909918]  [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [120985.909948]  [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [120985.909974] ---[ end trace 7e24c4fe20a76f1a ]---
> [120985.910186] ------------[ cut here ]------------
> [120985.910213] WARNING: CPU: 0 PID: 7953 at lib/list_debug.c:33 __list_add+0xac/0xc0()
> [120985.910236] list_add corruption. prev->next should be next (ffff88019ffce4f8), but was ffff88018cfb0348. (prev=ffff88018cfb0348).
> [120985.910257] Modules linked in: lgdt330x tuner_xc2028 tuner tvp5150 rc_hauppauge em28xx_rc rc_core xc5000 drxk em28xx_dvb dvb_core em28xx_alsa em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom v4l2_common videodev media netconsole usb_storage fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 vfat fat iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
> [120985.912159]  snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iTCO_wdt iTCO_vendor_support btusb bluetooth joydev microcode serio_raw r8169 mii i2c_i801 lpc_ich mfd_core rfkill snd_page_alloc snd_timer snd mei_me soundcore mei shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video [last unloaded: videobuf2_memops]
> [120985.913642] CPU: 0 PID: 7953 Comm: xawtv Tainted: G      D W    3.13.0-rc1+ #24
> [120985.913667] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> [120985.913691]  0000000000000009 ffff88011f63bb70 ffffffff816a03c6 ffff88011f63bbb8
> [120985.913805]  ffff88011f63bba8 ffffffff8106aaad ffff88018cfb3f48 ffff88019ffce4f8
> [120985.913920]  ffff88018cfb0348 0000000000000282 0000000000000000 ffff88011f63bc08
> [120985.914035] Call Trace:
> [120985.914063]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> [120985.914093]  [<ffffffff8106aaad>] warn_slowpath_common+0x7d/0xa0
> [120985.914121]  [<ffffffff8106ab1c>] warn_slowpath_fmt+0x4c/0x50
> [120985.914150]  [<ffffffff81343bac>] __list_add+0xac/0xc0
> [120985.914180]  [<ffffffffa04fd70b>] buffer_queue+0x7b/0xb0 [em28xx_v4l]
> [120985.914353]  [<ffffffffa04862d4>] __enqueue_in_driver+0x74/0x80 [videobuf2_core]
> [120985.914385]  [<ffffffffa04878c0>] vb2_streamon+0xa0/0x140 [videobuf2_core]
> [120985.914416]  [<ffffffffa04879a8>] vb2_ioctl_streamon+0x48/0x50 [videobuf2_core]
> [120985.914449]  [<ffffffffa04b7a8a>] v4l_streamon+0x1a/0x20 [videodev]
> [120985.914482]  [<ffffffffa04bb644>] __video_do_ioctl+0x2a4/0x330 [videodev]
> [120985.914515]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.914548]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120985.914580]  [<ffffffffa04bcae0>] video_usercopy+0x240/0x5d0 [videodev]
> [120985.914612]  [<ffffffff810b811d>] ? trace_hardirqs_on+0xd/0x10
> [120985.914643]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.914675]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120985.914708]  [<ffffffffa04bce85>] video_ioctl2+0x15/0x20 [videodev]
> [120985.914740]  [<ffffffffa04b6703>] v4l2_ioctl+0x123/0x160 [videodev]
> [120985.914770]  [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [120985.914799]  [<ffffffff812c7a96>] ? file_has_perm+0x86/0xa0
> [120985.914828]  [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [120985.914857]  [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [120985.914884] ---[ end trace 7e24c4fe20a76f1b ]---
> [120991.576999] em2882/3 #0: submit of audio urb failed
> [120991.781651] ------------[ cut here ]------------
> [120991.781700] WARNING: CPU: 0 PID: 7979 at lib/list_debug.c:33 __list_add+0xac/0xc0()
> [120991.781730] list_add corruption. prev->next should be next (ffff88019ffce4f8), but was           (null). (prev=ffff88018cfb1b48).
> [120991.781756] Modules linked in: lgdt330x tuner_xc2028 tuner tvp5150 rc_hauppauge em28xx_rc rc_core xc5000 drxk em28xx_dvb dvb_core em28xx_alsa em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_core em28xx tveeprom v4l2_common videodev media netconsole usb_storage fuse ccm nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep arc4 vfat fat iwldvm mac80211 iwlwifi cfg80211 x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul crc32c_intel ghash_clmulni_intel
> [120991.783977]  snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm iTCO_wdt iTCO_vendor_support btusb bluetooth joydev microcode serio_raw r8169 mii i2c_i801 lpc_ich mfd_core rfkill snd_page_alloc snd_timer snd mei_me soundcore mei shpchp nfsd auth_rpcgss nfs_acl lockd sunrpc nouveau i915 ttm i2c_algo_bit drm_kms_helper drm i2c_core mxm_wmi wmi video [last unloaded: videobuf2_memops]
> [120991.785750] CPU: 0 PID: 7979 Comm: tvtime Tainted: G      D W    3.13.0-rc1+ #24
> [120991.785779] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P04ABI.013.130220.dg 02/20/2013
> [120991.785806]  0000000000000009 ffff88001254fb70 ffffffff816a03c6 ffff88001254fbb8
> [120991.785938]  ffff88001254fba8 ffffffff8106aaad ffff88018cfb3f48 ffff88019ffce4f8
> [120991.786102]  ffff88018cfb1b48 0000000000000282 0000000000000000 ffff88001254fc08
> [120991.786233] Call Trace:
> [120991.786268]  [<ffffffff816a03c6>] dump_stack+0x45/0x56
> [120991.786319]  [<ffffffff8106aaad>] warn_slowpath_common+0x7d/0xa0
> [120991.786359]  [<ffffffff8106ab1c>] warn_slowpath_fmt+0x4c/0x50
> [120991.786393]  [<ffffffff81343bac>] __list_add+0xac/0xc0
> [120991.786429]  [<ffffffffa04fd70b>] buffer_queue+0x7b/0xb0 [em28xx_v4l]
> [120991.786619]  [<ffffffffa04862d4>] __enqueue_in_driver+0x74/0x80 [videobuf2_core]
> [120991.786656]  [<ffffffffa04878c0>] vb2_streamon+0xa0/0x140 [videobuf2_core]
> [120991.786690]  [<ffffffffa04879a8>] vb2_ioctl_streamon+0x48/0x50 [videobuf2_core]
> [120991.786728]  [<ffffffffa04b7a8a>] v4l_streamon+0x1a/0x20 [videodev]
> [120991.786767]  [<ffffffffa04bb644>] __video_do_ioctl+0x2a4/0x330 [videodev]
> [120991.786804]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120991.786841]  [<ffffffffa04bb3a0>] ? v4l_dbg_s_register+0x150/0x150 [videodev]
> [120991.786880]  [<ffffffffa04bcae0>] video_usercopy+0x240/0x5d0 [videodev]
> [120991.786917]  [<ffffffff810b811d>] ? trace_hardirqs_on+0xd/0x10
> [120991.786952]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120991.786988]  [<ffffffffa04b663b>] ? v4l2_ioctl+0x5b/0x160 [videodev]
> [120991.787027]  [<ffffffffa04bce85>] video_ioctl2+0x15/0x20 [videodev]
> [120991.787063]  [<ffffffffa04b6703>] v4l2_ioctl+0x123/0x160 [videodev]
> [120991.787098]  [<ffffffff811db8b0>] do_vfs_ioctl+0x300/0x520
> [120991.787133]  [<ffffffff812c7a96>] ? file_has_perm+0x86/0xa0
> [120991.787165]  [<ffffffff811dbb51>] SyS_ioctl+0x81/0xa0
> [120991.787199]  [<ffffffff816b1929>] system_call_fastpath+0x16/0x1b
> [120991.787230] ---[ end trace 7e24c4fe20a76f1c ]---
Nice. :/
Maybe it's time to check the videobuf2 handling.



Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47483 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750811AbdJWJnH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 05:43:07 -0400
Date: Mon, 23 Oct 2017 10:43:05 +0100
From: Sean Young <sean@mess.org>
To: Laurent Caumont <lcaumont2@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
Message-ID: <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org>
References: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 22, 2017 at 07:49:01PM +0200, Laurent Caumont wrote:
> Hello,
> 
> My LITE-ON DVB-T receiver doesn't work anymore with new ubuntu version.
> uname -a
> Linux bureau 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC
> 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> Could you fix the Kernel crash, please ?
> 
> Thanks.
> 
> dmesg

-snip-

> [    2.886723] WARN_ON(crtc->config->scaler_state.scaler_id < 0)
> [    2.886735] ------------[ cut here ]------------
> [    2.886761] WARNING: CPU: 0 PID: 262 at
> /build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:4755
> skylake_pfit_enable+0xe6/0xf0 [i915]
> [    2.886761] Modules linked in: dm_mirror dm_region_hash dm_log
> hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
> drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
> drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
> hid
> [    2.886771] CPU: 0 PID: 262 Comm: plymouthd Not tainted
> 4.13.0-16-generic #19-Ubuntu
> [    2.886771] Hardware name: System manufacturer System Product
> Name/H110I-PLUS, BIOS 0406 11/16/2015
> [    2.886772] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
> [    2.886788] RIP: 0010:skylake_pfit_enable+0xe6/0xf0 [i915]
> [    2.886789] RSP: 0018:ffff9de64132f910 EFLAGS: 00010282
> [    2.886790] RAX: 0000000000000031 RBX: ffff8e6e31d5d000 RCX: ffffffffba05fcc8
> [    2.886790] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000247
> [    2.886791] RBP: ffff9de64132f930 R08: 0000000000000031 R09: 00000000000002e8
> [    2.886791] R10: ffff8e6e26d8a988 R11: 0000000000000000 R12: ffff8e6e26d88000
> [    2.886792] R13: ffff8e6e26d88000 R14: 00000000fffffffd R15: ffff8e6e323ee800
> [    2.886793] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bc00000(0000)
> knlGS:0000000000000000
> [    2.886793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.886794] CR2: 0000555d9ef9d290 CR3: 0000000227bfc000 CR4: 00000000003406f0
> [    2.886794] Call Trace:
> [    2.886811]  haswell_crtc_enable+0x1d9/0x820 [i915]
> [    2.886825]  intel_update_crtc+0x4b/0xe0 [i915]
> [    2.886838]  skl_update_crtcs+0x1ca/0x290 [i915]
> [    2.886850]  intel_atomic_commit_tail+0x254/0xf90 [i915]
> [    2.886852]  ? __schedule+0x293/0x890
> [    2.886864]  intel_atomic_commit+0x3d5/0x490 [i915]
> [    2.886873]  ? drm_atomic_check_only+0x37b/0x540 [drm]
> [    2.886879]  drm_atomic_commit+0x4b/0x50 [drm]
> [    2.886884]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
> [    2.886890]  __drm_mode_set_config_internal+0x65/0x110 [drm]
> [    2.886895]  drm_mode_setcrtc+0x479/0x630 [drm]
> [    2.886897]  ? ww_mutex_unlock+0x26/0x30
> [    2.886901]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> [    2.886906]  drm_ioctl_kernel+0x5d/0xb0 [drm]
> [    2.886910]  drm_ioctl+0x31b/0x3d0 [drm]
> [    2.886914]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> [    2.886916]  ? new_sync_read+0xde/0x130
> [    2.886918]  do_vfs_ioctl+0xa5/0x610
> [    2.886919]  ? vfs_read+0x115/0x130
> [    2.886920]  SyS_ioctl+0x79/0x90
> [    2.886922]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> [    2.886922] RIP: 0033:0x7ff22dd82ea7
> [    2.886923] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [    2.886924] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
> [    2.886924] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
> [    2.886925] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
> [    2.886925] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
> [    2.886925] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
> [    2.886926] Code: 06 74 81 06 00 41 ff 94 24 f8 06 00 00 5b 41 5c
> 41 5d 41 5e 5d c3 f3 c3 48 c7 c6 a8 34 3e c0 48 c7 c7 db 05 3d c0 e8
> 2b c6 fd f8 <0f> ff eb de 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 83 8f
> 30 37
> [    2.886942] ---[ end trace 5721f5dfb92a50e9 ]---
> [    2.908604] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> output_types (expected 0x00000400, found 0x00000080)
> [    2.908624] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> pch_pfit.enabled (expected 1, found 0)
> [    2.908640] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> pch_pfit.size (expected 0x07800438, found 0x00000000)
> [    2.908654] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> pixel_rate (expected 270000, found 148499)
> [    2.908668] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> base.adjusted_mode.crtc_clock (expected 270000, found 148499)
> [    2.908669] pipe state doesn't match!
> [    2.908676] ------------[ cut here ]------------

This crash is your intel graphics, nothing to do with dvb.

> [    2.908692] WARNING: CPU: 2 PID: 262 at
> /build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:12273
> intel_atomic_commit_tail+0xdb1/0xf90 [i915]
> [    2.908692] Modules linked in: dm_mirror dm_region_hash dm_log
> hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
> drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
> drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
> hid
> [    2.908700] CPU: 2 PID: 262 Comm: plymouthd Tainted: G        W
>   4.13.0-16-generic #19-Ubuntu
> [    2.908701] Hardware name: System manufacturer System Product
> Name/H110I-PLUS, BIOS 0406 11/16/2015
> [    2.908701] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
> [    2.908716] RIP: 0010:intel_atomic_commit_tail+0xdb1/0xf90 [i915]
> [    2.908716] RSP: 0018:ffff9de64132fa90 EFLAGS: 00010286
> [    2.908717] RAX: 0000000000000019 RBX: ffff8e6e26d88310 RCX: ffffffffba05fcc8
> [    2.908718] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000247
> [    2.908718] RBP: ffff9de64132fb48 R08: 0000000000000001 R09: 000000000000031e
> [    2.908718] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8e6e31c54800
> [    2.908719] R13: ffff8e6e31d5d000 R14: ffff8e6e323ee800 R15: ffff8e6e26d88308
> [    2.908720] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bd00000(0000)
> knlGS:0000000000000000
> [    2.908720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.908721] CR2: 000055ded0ab1ac0 CR3: 0000000227bfc000 CR4: 00000000003406e0
> [    2.908721] Call Trace:
> [    2.908724]  ? wait_woken+0x80/0x80
> [    2.908738]  intel_atomic_commit+0x3d5/0x490 [i915]
> [    2.908746]  ? drm_atomic_check_only+0x37b/0x540 [drm]
> [    2.908752]  drm_atomic_commit+0x4b/0x50 [drm]
> [    2.908756]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
> [    2.908762]  __drm_mode_set_config_internal+0x65/0x110 [drm]
> [    2.908768]  drm_mode_setcrtc+0x479/0x630 [drm]
> [    2.908770]  ? ww_mutex_unlock+0x26/0x30
> [    2.908775]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> [    2.908780]  drm_ioctl_kernel+0x5d/0xb0 [drm]
> [    2.908784]  drm_ioctl+0x31b/0x3d0 [drm]
> [    2.908789]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> [    2.908790]  ? new_sync_read+0xde/0x130
> [    2.908792]  do_vfs_ioctl+0xa5/0x610
> [    2.908793]  ? vfs_read+0x115/0x130
> [    2.908794]  SyS_ioctl+0x79/0x90
> [    2.908795]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> [    2.908796] RIP: 0033:0x7ff22dd82ea7
> [    2.908797] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [    2.908797] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
> [    2.908798] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
> [    2.908798] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
> [    2.908799] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
> [    2.908799] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
> [    2.908800] Code: 40 53 3e c0 e8 f2 c6 fc f8 0f ff 0f b6 8d 60 ff
> ff ff 44 0f b6 85 70 ff ff ff e9 00 fd ff ff 48 c7 c7 fe 0d 3d c0 e8
> d0 c6 fc f8 <0f> ff e9 73 f8 ff ff 48 8d 7d 80 31 f6 e8 dd 13 fb f8 48
> 69 c3
> [    2.908816] ---[ end trace 5721f5dfb92a50ea ]---

-snip-

> [   10.843597] Linux video capture interface: v2.00
> [   10.852180] gspca_main: v2.14.0 registered
> [   10.854210] gspca_main: gspca_zc3xx-2.14.0 probing 046d:08a2
> [   10.865118] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
> [   10.865208] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [   10.869232] dvbdev: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)

-snip-

This just shows the device being plugged in.

Thanks

Sean

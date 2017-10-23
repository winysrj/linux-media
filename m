Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56457 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbdJWS5w (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 14:57:52 -0400
Date: Mon, 23 Oct 2017 19:57:50 +0100
From: Sean Young <sean@mess.org>
To: Laurent Caumont <lcaumont2@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: 'LITE-ON USB2.0 DVB-T Tune' driver crash with kernel 4.13 /
 ubuntu 17.10
Message-ID: <20171023185750.5m5qo575myogzbhz@gofer.mess.org>
References: <CACG2urxXyivORcKhgZf=acwA8ajz5UspHf8YTHEQJG=VauqHpg@mail.gmail.com>
 <20171023094305.nxrxsqjrrwtygupc@gofer.mess.org>
 <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACG2urzPV2q63-bLP98cHDDqzP3a-oydDScPqG=tVKSCzxREBg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Please reply to the list.

On Mon, Oct 23, 2017 at 08:48:14PM +0200, Laurent Caumont wrote:
> I'm sorry, the log has been cut when I copy-past it.
> Here is the rest:
> (The crash of the intel driver doesn't seem to make issue to my display.)
> 
> [   12.013019] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
> [   12.013086] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [   12.017153] dvbdev: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
> [   12.576681] r8169 0000:03:00.0 enp3s0: link up
> [   12.576687] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready
> [   12.680633] FS-Cache: Loaded
> [   12.702899] FS-Cache: Netfs 'cifs' registered for caching
> [   12.702965] Key type cifs.spnego registered
> [   12.702967] Key type cifs.idmap registered
> [   12.703119] No dialect specified on mount. Default has changed to a
> more secure dialect, SMB3 (vers=3.0), from CIFS (SMB1). To use the
> less secure SMB1 dialect to access old servers which do not support
> SMB3 specify vers=1.0 on mount. For somewhat newer servers such as
> Windows 7 try vers=2.1.
> [   12.713840] CIFS VFS: cifs_mount failed w/return code = -112
> [   12.762481] vboxdrv: loading out-of-tree module taints kernel.
> [   12.762607] vboxdrv: module verification failed: signature and/or
> required key missing - tainting kernel
> [   12.767368] vboxdrv: Found 4 processor cores
> [   12.785129] vboxdrv: TSC mode is Invariant, tentative frequency 3311999956 Hz
> [   12.785130] vboxdrv: Successfully loaded version 5.1.30_Ubuntu
> (interface 0x002a0000)
> [   12.790471] VBoxNetFlt: Successfully started.
> [   12.797915] VBoxNetAdp: Successfully started.
> [   12.801981] VBoxPciLinuxInit
> [   12.805804] vboxpci: IOMMU not found (not registered)
> [   13.056044] transfer buffer not dma capable

This issue is fixed in commit b47567071527 ("media: dvb: i2c transfers over
usb cannot be done from stack").

> [   13.056053] ------------[ cut here ]------------
> [   13.056057] WARNING: CPU: 2 PID: 23 at
> /build/linux-XO_uEE/linux-4.13.0/drivers/usb/core/hcd.c:1595
> usb_hcd_map_urb_for_dma+0x41d/0x620
> [   13.056058] Modules linked in: pci_stub vboxpci(OE) vboxnetadp(OE)
> vboxnetflt(OE) vboxdrv(OE) nls_utf8 cifs ccm fscache binfmt_misc
> intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel
> kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
> snd_hda_codec_hdmi aesni_intel snd_hda_codec_realtek
> snd_hda_codec_generic aes_x86_64 crypto_simd glue_helper cryptd
> intel_cstate intel_rapl_perf snd_hda_intel eeepc_wmi asus_wmi
> serio_raw sparse_keymap wmi_bmof snd_hda_codec snd_hda_core
> dvb_usb_dibusb_mc dvb_usb_dibusb_mc_common gspca_zc3xx
> dvb_usb_dibusb_common gspca_main snd_usb_audio v4l2_common
> snd_usbmidi_lib snd_hwdep videodev snd_seq_midi snd_seq_midi_event
> media snd_rawmidi dib3000mc dibx000_common dvb_usb snd_pcm dvb_core
> rc_core input_leds joydev snd_seq snd_seq_device snd_timer
> [   13.056077]  snd soundcore shpchp mei_me mei hci_uart btbcm serdev
> btqca btintel bluetooth ecdh_generic acpi_als mac_hid intel_lpss_acpi
> intel_lpss kfifo_buf industrialio acpi_pad cuse parport_pc ppdev lp
> parport ip_tables x_tables autofs4 btrfs xor raid6_pq dm_mirror
> dm_region_hash dm_log hid_generic usbhid uas usb_storage mxm_wmi i915
> i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt r8169
> fb_sys_fops drm mii ahci libahci wmi video pinctrl_sunrisepoint
> i2c_hid pinctrl_intel hid
> [   13.056096] CPU: 2 PID: 23 Comm: kworker/2:0 Tainted: G        W
> OE   4.13.0-16-generic #19-Ubuntu
> [   13.056097] Hardware name: System manufacturer System Product
> Name/H110I-PLUS, BIOS 0406 11/16/2015
> [   13.056099] Workqueue: usb_hub_wq hub_event
> [   13.056100] task: ffff9968b23c17c0 task.stack: ffffaecc40d50000
> [   13.056101] RIP: 0010:usb_hcd_map_urb_for_dma+0x41d/0x620
> [   13.056102] RSP: 0018:ffffaecc40d53380 EFLAGS: 00010282
> [   13.056103] RAX: 000000000000001f RBX: ffff9968af39c540 RCX: 0000000000000000
> [   13.056103] RDX: 0000000000000000 RSI: ffff9968bbd0dc78 RDI: ffff9968bbd0dc78
> [   13.056104] RBP: ffffaecc40d533c0 R08: 0000000000000001 R09: 00000000000003da
> [   13.056104] R10: 0000000000000001 R11: 0000000000000000 R12: 00000000fffffff5
> [   13.056105] R13: 0000000001400000 R14: 0000000000000002 R15: ffff9968b2382000
> [   13.056106] FS:  0000000000000000(0000) GS:ffff9968bbd00000(0000)
> knlGS:0000000000000000
> [   13.056106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   13.056107] CR2: 0000000001270000 CR3: 00000002301ab000 CR4: 00000000003406e0
> [   13.056107] Call Trace:
> [   13.056110]  usb_hcd_submit_urb+0x4ab/0xb70
> [   13.056112]  ? del_timer_sync+0x39/0x40
> [   13.056113]  ? schedule_timeout+0x18a/0x350
> [   13.056114]  ? call_timer_fn+0x130/0x130
> [   13.056115]  usb_submit_urb+0x22d/0x560
> [   13.056117]  ? wake_up_q+0x80/0x80
> [   13.056118]  usb_start_wait_urb+0x6e/0x180
> [   13.056119]  usb_bulk_msg+0xb8/0x160
> [   13.056122]  dvb_usb_generic_rw+0x15c/0x1d0 [dvb_usb]
> [   13.056125]  dibusb_i2c_msg+0xe1/0x130 [dvb_usb_dibusb_common]
> [   13.056126]  dibusb_i2c_xfer+0x12f/0x150 [dvb_usb_dibusb_common]
> [   13.056138]  __i2c_transfer+0x11d/0x400
> [   13.056139]  ? dvb_usb_fe_sleep+0x60/0x60 [dvb_usb]
> [   13.056140]  i2c_transfer+0x50/0xd0
> [   13.056142]  dib3000mc_read_word+0x85/0xe0 [dib3000mc]
> [   13.056143]  dib3000mc_identify+0x17/0xc0 [dib3000mc]
> [   13.056144]  ? dib3000mc_identify+0x17/0xc0 [dib3000mc]
> [   13.056146]  dib3000mc_attach+0x6e/0x600 [dib3000mc]
> [   13.056147]  dibusb_dib3000mc_frontend_attach+0x4c/0x170
> [dvb_usb_dibusb_mc_common]
> [   13.056148]  dvb_usb_adapter_frontend_init+0xdf/0x190 [dvb_usb]
> [   13.056149]  dvb_usb_device_init+0x4e3/0x640 [dvb_usb]
> [   13.056151]  dibusb_mc_probe+0x25/0x27 [dvb_usb_dibusb_mc]
> [   13.056152]  usb_probe_interface+0x124/0x300
> [   13.056154]  driver_probe_device+0x2ff/0x450
> [   13.056155]  __device_attach_driver+0x83/0x100
> [   13.056156]  ? __driver_attach+0xe0/0xe0
> [   13.056157]  bus_for_each_drv+0x69/0xb0
> [   13.056158]  __device_attach+0xdd/0x160
> [   13.056159]  device_initial_probe+0x13/0x20
> [   13.056160]  bus_probe_device+0x92/0xa0
> [   13.056162]  device_add+0x448/0x680
> [   13.056163]  usb_set_configuration+0x505/0x850
> [   13.056165]  generic_probe+0x2e/0x80
> [   13.056166]  usb_probe_device+0x2e/0x60
> [   13.056167]  driver_probe_device+0x2ff/0x450
> [   13.056168]  __device_attach_driver+0x83/0x100
> [   13.056169]  ? __driver_attach+0xe0/0xe0
> [   13.056170]  bus_for_each_drv+0x69/0xb0
> [   13.056171]  __device_attach+0xdd/0x160
> [   13.056172]  device_initial_probe+0x13/0x20
> [   13.056173]  bus_probe_device+0x92/0xa0
> [   13.056174]  device_add+0x448/0x680
> [   13.056179]  ? add_device_randomness+0x9a/0x110
> [   13.056180]  usb_new_device+0x269/0x490
> [   13.056182]  hub_port_connect+0x62d/0x9f0
> [   13.056183]  port_event+0x586/0x6b0
> [   13.056184]  hub_event+0x2e0/0x3a0
> [   13.056186]  process_one_work+0x1e7/0x410
> [   13.056187]  worker_thread+0x4a/0x410
> [   13.056189]  kthread+0x125/0x140
> [   13.056190]  ? process_one_work+0x410/0x410
> [   13.056191]  ? kthread_create_on_node+0x70/0x70
> [   13.056192]  ret_from_fork+0x25/0x30
> [   13.056193] Code: 48 39 c8 73 30 80 3d 76 66 96 00 00 41 bc f5 ff
> ff ff 0f 85 26 ff ff ff 48 c7 c7 a0 20 b3 99 c6 05 5c 66 96 00 01 e8
> 64 47 a3 ff <0f> ff 8b 53 64 e9 09 ff ff ff 65 48 8b 0c 25 00 d3 00 00
> 48 8b
> [   13.056210] ---[ end trace f57fa627e755cd94 ]---
> [   13.056211] dvb-usb: recv bulk message failed: -11
> [   13.056360] dvb-usb: recv bulk message failed: -11
> [   13.056365] dvb-usb: no frontend was attached by 'LITE-ON USB2.0 DVB-T Tuner'
> [   14.504149] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   14.504150] Bluetooth: BNEP filters: protocol multicast
> [   14.504153] Bluetooth: BNEP socket layer initialized
> [   15.740746] rfkill: input handler disabled
> [   23.260332] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:14.0/usb1/1-8/input/input18
> [   23.260554] dvb-usb: schedule remote query interval to 150 msecs.
> [   23.260558] dvb-usb: LITE-ON USB2.0 DVB-T Tuner successfully
> initialized and connected.
> [   25.436052] dvb-usb: bulk message failed: -110 (1/0)
> [   25.436056] dvb-usb: error while querying for an remote control event.
> [   27.612170] dvb-usb: bulk message failed: -110 (1/0)
> [   27.612179] dvb-usb: error while querying for an remote control event.
> [   29.788168] dvb-usb: bulk message failed: -110 (1/0)
> [   29.788177] dvb-usb: error while querying for an remote control event.
> [   31.968145] dvb-usb: bulk message failed: -110 (1/0)
> [   31.968154] dvb-usb: error while querying for an remote control event.
> [   34.140173] dvb-usb: bulk message failed: -110 (1/0)
> [   34.140182] dvb-usb: error while querying for an remote control event.
> [   36.316084] dvb-usb: bulk message failed: -110 (1/0)
> 
> 2017-10-23 11:43 GMT+02:00 Sean Young <sean@mess.org>:
> > On Sun, Oct 22, 2017 at 07:49:01PM +0200, Laurent Caumont wrote:
> >> Hello,
> >>
> >> My LITE-ON DVB-T receiver doesn't work anymore with new ubuntu version.
> >> uname -a
> >> Linux bureau 4.13.0-16-generic #19-Ubuntu SMP Wed Oct 11 18:35:14 UTC
> >> 2017 x86_64 x86_64 x86_64 GNU/Linux
> >>
> >> Could you fix the Kernel crash, please ?
> >>
> >> Thanks.
> >>
> >> dmesg
> >
> > -snip-
> >
> >> [    2.886723] WARN_ON(crtc->config->scaler_state.scaler_id < 0)
> >> [    2.886735] ------------[ cut here ]------------
> >> [    2.886761] WARNING: CPU: 0 PID: 262 at
> >> /build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:4755
> >> skylake_pfit_enable+0xe6/0xf0 [i915]
> >> [    2.886761] Modules linked in: dm_mirror dm_region_hash dm_log
> >> hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
> >> drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
> >> drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
> >> hid
> >> [    2.886771] CPU: 0 PID: 262 Comm: plymouthd Not tainted
> >> 4.13.0-16-generic #19-Ubuntu
> >> [    2.886771] Hardware name: System manufacturer System Product
> >> Name/H110I-PLUS, BIOS 0406 11/16/2015
> >> [    2.886772] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
> >> [    2.886788] RIP: 0010:skylake_pfit_enable+0xe6/0xf0 [i915]
> >> [    2.886789] RSP: 0018:ffff9de64132f910 EFLAGS: 00010282
> >> [    2.886790] RAX: 0000000000000031 RBX: ffff8e6e31d5d000 RCX: ffffffffba05fcc8
> >> [    2.886790] RDX: 0000000000000000 RSI: 0000000000000086 RDI: 0000000000000247
> >> [    2.886791] RBP: ffff9de64132f930 R08: 0000000000000031 R09: 00000000000002e8
> >> [    2.886791] R10: ffff8e6e26d8a988 R11: 0000000000000000 R12: ffff8e6e26d88000
> >> [    2.886792] R13: ffff8e6e26d88000 R14: 00000000fffffffd R15: ffff8e6e323ee800
> >> [    2.886793] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bc00000(0000)
> >> knlGS:0000000000000000
> >> [    2.886793] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [    2.886794] CR2: 0000555d9ef9d290 CR3: 0000000227bfc000 CR4: 00000000003406f0
> >> [    2.886794] Call Trace:
> >> [    2.886811]  haswell_crtc_enable+0x1d9/0x820 [i915]
> >> [    2.886825]  intel_update_crtc+0x4b/0xe0 [i915]
> >> [    2.886838]  skl_update_crtcs+0x1ca/0x290 [i915]
> >> [    2.886850]  intel_atomic_commit_tail+0x254/0xf90 [i915]
> >> [    2.886852]  ? __schedule+0x293/0x890
> >> [    2.886864]  intel_atomic_commit+0x3d5/0x490 [i915]
> >> [    2.886873]  ? drm_atomic_check_only+0x37b/0x540 [drm]
> >> [    2.886879]  drm_atomic_commit+0x4b/0x50 [drm]
> >> [    2.886884]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
> >> [    2.886890]  __drm_mode_set_config_internal+0x65/0x110 [drm]
> >> [    2.886895]  drm_mode_setcrtc+0x479/0x630 [drm]
> >> [    2.886897]  ? ww_mutex_unlock+0x26/0x30
> >> [    2.886901]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> >> [    2.886906]  drm_ioctl_kernel+0x5d/0xb0 [drm]
> >> [    2.886910]  drm_ioctl+0x31b/0x3d0 [drm]
> >> [    2.886914]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> >> [    2.886916]  ? new_sync_read+0xde/0x130
> >> [    2.886918]  do_vfs_ioctl+0xa5/0x610
> >> [    2.886919]  ? vfs_read+0x115/0x130
> >> [    2.886920]  SyS_ioctl+0x79/0x90
> >> [    2.886922]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> >> [    2.886922] RIP: 0033:0x7ff22dd82ea7
> >> [    2.886923] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
> >> 0000000000000010
> >> [    2.886924] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
> >> [    2.886924] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
> >> [    2.886925] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
> >> [    2.886925] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
> >> [    2.886925] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
> >> [    2.886926] Code: 06 74 81 06 00 41 ff 94 24 f8 06 00 00 5b 41 5c
> >> 41 5d 41 5e 5d c3 f3 c3 48 c7 c6 a8 34 3e c0 48 c7 c7 db 05 3d c0 e8
> >> 2b c6 fd f8 <0f> ff eb de 66 0f 1f 44 00 00 0f 1f 44 00 00 55 48 83 8f
> >> 30 37
> >> [    2.886942] ---[ end trace 5721f5dfb92a50e9 ]---
> >> [    2.908604] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> >> output_types (expected 0x00000400, found 0x00000080)
> >> [    2.908624] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> >> pch_pfit.enabled (expected 1, found 0)
> >> [    2.908640] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> >> pch_pfit.size (expected 0x07800438, found 0x00000000)
> >> [    2.908654] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> >> pixel_rate (expected 270000, found 148499)
> >> [    2.908668] [drm:pipe_config_err [i915]] *ERROR* mismatch in
> >> base.adjusted_mode.crtc_clock (expected 270000, found 148499)
> >> [    2.908669] pipe state doesn't match!
> >> [    2.908676] ------------[ cut here ]------------
> >
> > This crash is your intel graphics, nothing to do with dvb.
> >
> >> [    2.908692] WARNING: CPU: 2 PID: 262 at
> >> /build/linux-XO_uEE/linux-4.13.0/drivers/gpu/drm/i915/intel_display.c:12273
> >> intel_atomic_commit_tail+0xdb1/0xf90 [i915]
> >> [    2.908692] Modules linked in: dm_mirror dm_region_hash dm_log
> >> hid_generic usbhid uas usb_storage i915 mxm_wmi i2c_algo_bit
> >> drm_kms_helper r8169 syscopyarea sysfillrect mii sysimgblt fb_sys_fops
> >> drm ahci libahci wmi video pinctrl_sunrisepoint pinctrl_intel i2c_hid
> >> hid
> >> [    2.908700] CPU: 2 PID: 262 Comm: plymouthd Tainted: G        W
> >>   4.13.0-16-generic #19-Ubuntu
> >> [    2.908701] Hardware name: System manufacturer System Product
> >> Name/H110I-PLUS, BIOS 0406 11/16/2015
> >> [    2.908701] task: ffff8e6e276dc740 task.stack: ffff9de64132c000
> >> [    2.908716] RIP: 0010:intel_atomic_commit_tail+0xdb1/0xf90 [i915]
> >> [    2.908716] RSP: 0018:ffff9de64132fa90 EFLAGS: 00010286
> >> [    2.908717] RAX: 0000000000000019 RBX: ffff8e6e26d88310 RCX: ffffffffba05fcc8
> >> [    2.908718] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000247
> >> [    2.908718] RBP: ffff9de64132fb48 R08: 0000000000000001 R09: 000000000000031e
> >> [    2.908718] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8e6e31c54800
> >> [    2.908719] R13: ffff8e6e31d5d000 R14: ffff8e6e323ee800 R15: ffff8e6e26d88308
> >> [    2.908720] FS:  00007ff22e6a6b80(0000) GS:ffff8e6e3bd00000(0000)
> >> knlGS:0000000000000000
> >> [    2.908720] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [    2.908721] CR2: 000055ded0ab1ac0 CR3: 0000000227bfc000 CR4: 00000000003406e0
> >> [    2.908721] Call Trace:
> >> [    2.908724]  ? wait_woken+0x80/0x80
> >> [    2.908738]  intel_atomic_commit+0x3d5/0x490 [i915]
> >> [    2.908746]  ? drm_atomic_check_only+0x37b/0x540 [drm]
> >> [    2.908752]  drm_atomic_commit+0x4b/0x50 [drm]
> >> [    2.908756]  drm_atomic_helper_set_config+0x68/0x90 [drm_kms_helper]
> >> [    2.908762]  __drm_mode_set_config_internal+0x65/0x110 [drm]
> >> [    2.908768]  drm_mode_setcrtc+0x479/0x630 [drm]
> >> [    2.908770]  ? ww_mutex_unlock+0x26/0x30
> >> [    2.908775]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> >> [    2.908780]  drm_ioctl_kernel+0x5d/0xb0 [drm]
> >> [    2.908784]  drm_ioctl+0x31b/0x3d0 [drm]
> >> [    2.908789]  ? drm_mode_getcrtc+0x180/0x180 [drm]
> >> [    2.908790]  ? new_sync_read+0xde/0x130
> >> [    2.908792]  do_vfs_ioctl+0xa5/0x610
> >> [    2.908793]  ? vfs_read+0x115/0x130
> >> [    2.908794]  SyS_ioctl+0x79/0x90
> >> [    2.908795]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> >> [    2.908796] RIP: 0033:0x7ff22dd82ea7
> >> [    2.908797] RSP: 002b:00007ffe7cf09a18 EFLAGS: 00000246 ORIG_RAX:
> >> 0000000000000010
> >> [    2.908797] RAX: ffffffffffffffda RBX: 000055f7852f73a0 RCX: 00007ff22dd82ea7
> >> [    2.908798] RDX: 00007ffe7cf09a50 RSI: 00000000c06864a2 RDI: 0000000000000009
> >> [    2.908798] RBP: 0000000000000002 R08: 0000000000000000 R09: 000055f785303500
> >> [    2.908799] R10: 000055f785302fc0 R11: 0000000000000246 R12: 00007ffe7cf09e30
> >> [    2.908799] R13: 00000000ffffffff R14: 0000000000000000 R15: 00007ff22e4872d0
> >> [    2.908800] Code: 40 53 3e c0 e8 f2 c6 fc f8 0f ff 0f b6 8d 60 ff
> >> ff ff 44 0f b6 85 70 ff ff ff e9 00 fd ff ff 48 c7 c7 fe 0d 3d c0 e8
> >> d0 c6 fc f8 <0f> ff e9 73 f8 ff ff 48 8d 7d 80 31 f6 e8 dd 13 fb f8 48
> >> 69 c3
> >> [    2.908816] ---[ end trace 5721f5dfb92a50ea ]---
> >
> > -snip-
> >
> >> [   10.843597] Linux video capture interface: v2.00
> >> [   10.852180] gspca_main: v2.14.0 registered
> >> [   10.854210] gspca_main: gspca_zc3xx-2.14.0 probing 046d:08a2
> >> [   10.865118] dvb-usb: found a 'LITE-ON USB2.0 DVB-T Tuner' in warm state.
> >> [   10.865208] dvb-usb: will pass the complete MPEG2 transport stream
> >> to the software demuxer.
> >> [   10.869232] dvbdev: DVB: registering new adapter (LITE-ON USB2.0 DVB-T Tuner)
> >
> > -snip-
> >
> > This just shows the device being plugged in.
> >
> > Thanks
> >
> > Sean

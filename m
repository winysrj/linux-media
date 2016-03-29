Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58956 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbcC2Ndv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 09:33:51 -0400
Subject: Re: Can't use USB sound card on 4.6-rc1, works fine on 4.5.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1ceab9c3-4bf1-5e35-f70b-d119f9d30d6a@mokrynskyi.com>
Cc: Nazar Mokrynskyi <nazar@mokrynskyi.com>,
	linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56FA8435.6010807@osg.samsung.com>
Date: Tue, 29 Mar 2016 07:33:41 -0600
MIME-Version: 1.0
In-Reply-To: <1ceab9c3-4bf1-5e35-f70b-d119f9d30d6a@mokrynskyi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/28/2016 10:58 PM, Nazar Mokrynskyi wrote:
> Originally reported here: https://bugzilla.kernel.org/show_bug.cgi?id=115301 but Greg Kroah-Hartman suggested to redirect this to mailing list here.

Hi Mauro,

Could you please send the fix for this bug in for rc-2?

https://lkml.org/lkml/2016/3/15/238

thanks,
-- Shuah
> 
> When I attach USB sound card to USB hub following output appears in dmesg output:
> 
> [   83.074063] usb 3-6: new high-speed USB device number 10 using xhci_hcd
> [   83.239600] usb 3-6: New USB device found, idVendor=041e, idProduct=322c
> [   83.239602] usb 3-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   83.239603] usb 3-6: Product: SB Omni Surround 5.1
> [   83.239604] usb 3-6: Manufacturer: Creative Technology Ltd
> [   83.239605] usb 3-6: SerialNumber: 000000Q6
> [   91.849418] usb 3-9.1: new high-speed USB device number 11 using xhci_hcd
> [   91.924078] usb 3-9.1: New USB device found, idVendor=041e, idProduct=322c
> [   91.924081] usb 3-9.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   91.924083] usb 3-9.1: Product: SB Omni Surround 5.1
> [   91.924084] usb 3-9.1: Manufacturer: Creative Technology Ltd
> [   91.924086] usb 3-9.1: SerialNumber: 000000Q6
> [   91.968105] usbhid 3-9.1:1.4: can't add hid device: -71
> [   91.968117] usbhid: probe of 3-9.1:1.4 failed with error -71
> [   92.195856] usb 3-9.1: USB disconnect, device number 11
> [   92.362345] usb 3-9.1: new high-speed USB device number 12 using xhci_hcd
> [   92.436872] usb 3-9.1: New USB device found, idVendor=041e, idProduct=322c
> [   92.436875] usb 3-9.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   92.436876] usb 3-9.1: Product: SB Omni Surround 5.1
> [   92.436877] usb 3-9.1: Manufacturer: Creative Technology Ltd
> [   92.436878] usb 3-9.1: SerialNumber: 000000Q6
> [  103.716208] usbhid 3-6:1.4: can't add hid device: -110
> [  103.716221] usbhid: probe of 3-6:1.4 failed with error -110
> [  103.716287] usb 3-6: USB disconnect, device number 10
> [  107.438265] hid-generic 0003:041E:322C.0005: usb_submit_urb(ctrl) failed: -1
> [  107.438275] hid-generic 0003:041E:322C.0005: timeout initializing reports
> [  107.438359] input: Creative Technology Ltd SB Omni Surround 5.1 as /devices/pci0000:00/0000:00:14.0/usb3/3-9/3-9.1/3-9.1:1.4/0003:041E:322C.0005/input/input28
> [  107.489481] hid-generic 0003:041E:322C.0005: input,hidraw4: USB HID v1.11 Keyboard [Creative Technology Ltd SB Omni Surround 5.1] on usb-0000:00:14.0-9.1/input4
> [  107.510027] BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
> [  107.510056] IP: [<ffffffffa1511a1b>] usb_audio_probe+0x2bb/0x980 [snd_usb_audio]
> [  107.510087] PGD 0
> [  107.510095] Oops: 0000 [#1] SMP
> [  107.510107] Modules linked in: snd_usb_audio(+) snd_usbmidi_lib vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE) vboxdrv(OE) ccm xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter ip_tables x_tables nf_nat nf_conntrack br_netfilter bridge stp llc bbswitch(OE) bnep zram lz4_compress binfmt_misc uvcvideo videobuf2_vmalloc btusb videobuf2_memops btrtl videobuf2_v4l2 btbcm videobuf2_core btintel bluetooth videodev media arc4 nvidia_uvm(POE) nls_iso8859_1 x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_realtek coretemp snd_hda_codec_hdmi snd_hda_codec_generic kvm_intel kvm snd_hda_intel snd_hda_codec irqbypass crct10dif_pclmul snd_hwdep crc32_pclmul snd_hda_core ghash_clmulni_intel snd_pcm iwlmvm aesni_intel aes_x86_64 glue_helper
> [  107.510352]  lrw snd_seq_midi ablk_helper mac80211 snd_seq_midi_event cryptd joydev nvidia_drm(POE) nvidia_modeset(POE) serio_raw snd_rawmidi iwlwifi snd_seq nvidia(POE) cfg80211 snd_timer rtsx_pci_ms snd_seq_device lpc_ich mei_me memstick mei snd soundcore shpchp intel_smartconnect mac_hid mxm_wmi iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi tuxedo_wmi(OE) wmi parport_pc sunrpc ppdev lp parport usb_storage hid_generic usbhid hid rtsx_pci_sdmmc i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops psmouse firewire_ohci ahci drm firewire_core libahci r8169 rtsx_pci mii crc_itu_t video
> [  107.510548] CPU: 4 PID: 3993 Comm: systemd-udevd Tainted: P           OE   4.6.0-rc1-haswell #1
> [  107.510571] Hardware name: Notebook                         P15SM                          /P15SM                          , BIOS 1.03.04PM v2 02/27/2014
> [  107.510607] task: ffff880379f49d40 ti: ffff8803580a0000 task.ti: ffff8803580a0000
> [  107.510626] RIP: 0010:[<ffffffffa1511a1b>]  [<ffffffffa1511a1b>] usb_audio_probe+0x2bb/0x980 [snd_usb_audio]
> [  107.510658] RSP: 0018:ffff8803580a3ab0  EFLAGS: 00010246
> [  107.510672] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  107.510691] RDX: ffff88032cf9e1c0 RSI: ffff880415453338 RDI: ffff88032cf9e1c0
> [  107.510709] RBP: ffff8803580a3b18 R08: 0000000000000000 R09: ffffffff8146f056
> [  107.510728] R10: ffffea000f87ea00 R11: ffff8803c6566872 R12: ffff8800be7c1b00
> [  107.510747] R13: 0000000000000004 R14: ffff8800be7c1b54 R15: ffff880358188409
> [  107.510766] FS:  00007f92099738c0(0000) GS:ffff88042fb00000(0000) knlGS:0000000000000000
> [  107.510787] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  107.510802] CR2: 0000000000000014 CR3: 000000035802f000 CR4: 00000000001406e0
> [  107.510821] Stack:
> [  107.510827]  ffff8803148da0c8 0000000000000000 ffff88035818b800 ffff8803148da0c8
> [  107.510849]  00000000580a3b18 ffff880353d8a000 3a65313430425355 ffffff0063323233
> [  107.510872]  ffff8803a18b4098 ffff8803a18b4000 ffffffffa152e188 ffff88035818b830
> [  107.510895] Call Trace:
> [  107.510907]  [<ffffffff8167c8fd>] usb_probe_interface+0x1bd/0x300
> [  107.510925]  [<ffffffff815bde4c>] driver_probe_device+0x22c/0x440
> [  107.510942]  [<ffffffff815be131>] __driver_attach+0xd1/0xf0
> [  107.510960]  [<ffffffff815be060>] ? driver_probe_device+0x440/0x440
> [  107.510977]  [<ffffffff815bba64>] bus_for_each_dev+0x64/0xa0
> [  107.510993]  [<ffffffff815bd55e>] driver_attach+0x1e/0x20
> [  107.511008]  [<ffffffff815bd02b>] bus_add_driver+0x1eb/0x280
> [  107.511025]  [<ffffffff815bea60>] driver_register+0x60/0xe0
> [  107.511040]  [<ffffffff8167b274>] usb_register_driver+0x84/0x140
> [  107.511056]  [<ffffffffa14e4000>] ? 0xffffffffa14e4000
> [  107.511074]  [<ffffffffa14e401e>] usb_audio_driver_init+0x1e/0x1000 [snd_usb_audio]
> [  107.511096]  [<ffffffff8100211b>] do_one_initcall+0xab/0x1d0
> [  107.511112]  [<ffffffff811b4d81>] ? __vunmap+0x81/0xd0
> [  107.511127]  [<ffffffff811d1ca6>] ? kmem_cache_alloc_trace+0x176/0x1e0
> [  107.511145]  [<ffffffff811d2f01>] ? kfree+0x151/0x160
> [  107.511162]  [<ffffffff8116fb08>] do_init_module+0x5f/0x1df
> [  107.511178]  [<ffffffff810f98da>] load_module+0x221a/0x2890
> [  107.511194]  [<ffffffff810f6200>] ? __symbol_put+0x40/0x40
> [  107.511210]  [<ffffffff810fa183>] SYSC_finit_module+0xc3/0xf0
> [  107.511226]  [<ffffffff810fa1ce>] SyS_finit_module+0xe/0x10
> [  107.511242]  [<ffffffff81003c89>] do_syscall_64+0x69/0x110
> [  107.511258]  [<ffffffff818661e5>] entry_SYSCALL64_slow_path+0x25/0x25
> [  107.511282] Code: 02 00 4c 89 e7 8b 75 bc e8 93 73 00 00 85 c0 89 c1 0f 88 9b 00 00 00 49 8b 7c 24 10 e8 0f 2f e8 fe 85 c0 89 c1 0f 88 87 00 00 00 <80> 7b 14 00 0f 85 47 04 00 00 49 63 04 24 4c 89 24 c5 c0 1a 53
> [  107.511365] RIP  [<ffffffffa1511a1b>] usb_audio_probe+0x2bb/0x980 [snd_usb_audio]
> [  107.511385]  RSP <ffff8803580a3ab0>
> [  107.511393] CR2: 0000000000000014
> [  107.516696] ---[ end trace 3056620be95ce868 ]---
> 
> Also my laptop has 3 USB 3.0 ports and 1 USB 2.0 port and that 2.0 port stopped working in 4.6.0-rc1, which I think is related, when I plug sound card there LED on it doesn't even flashing.
> 
> I'm not on mailing list, so send me copy when answering, please.
> 


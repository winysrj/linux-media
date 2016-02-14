Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:33617 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbcBNNkX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2016 08:40:23 -0500
Received: by mail-vk0-f48.google.com with SMTP id k196so90617163vka.0
        for <linux-media@vger.kernel.org>; Sun, 14 Feb 2016 05:40:22 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 14 Feb 2016 14:40:22 +0100
Message-ID: <CACS2yxM2+SS-=kDEhRY+ZaJ9NxNx-9qnSJuDd5i2sAtSvwGjbw@mail.gmail.com>
Subject: dvb_usb_dvbsky module loading errors
From: Pavol Domin <pavol.domin@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

trying the latest media tree modules, loading of dvb_usb_sky fails.

Device:
TechnoTrend TT-connect CT2-4650 CI, V1
Bus 001 Device 002: ID 0b48:3012 TechnoTrend AG TT-connect CT2-4650 CI

Env:
Ubuntu 15.10, kernel 4.2.0-27-generic + media tree, MSI X99A SLI PLUS,
GeForce GTX 960

Dmesg:
[    4.941711] media: Linux media interface: v0.10
[    4.943399] WARNING: You are using an experimental version of the
media stack.
                As the driver is backported to an older kernel, it doesn't offer
                enough quality for its usage in production.
                Use it with care.
               Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
                f7b4b54e63643b740c598e044874c4bffa0f04f2 [media]
tvp5150: add HW input connectors support
                82c2ffeb217a024084f3ad0bf3705f5661365804 [media]
tvp5150: document input connectors DT bindings
                b802fb99ae964681d1754428f67970911e0476e9 [media]
tvp5150: move input definition header to dt-bindings
[    4.948652] WARNING: You are using an experimental version of the
media stack.
                As the driver is backported to an older kernel, it doesn't offer
                enough quality for its usage in production.
                Use it with care.
               Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
                f7b4b54e63643b740c598e044874c4bffa0f04f2 [media]
tvp5150: add HW input connectors support
                82c2ffeb217a024084f3ad0bf3705f5661365804 [media]
tvp5150: document input connectors DT bindings
                b802fb99ae964681d1754428f67970911e0476e9 [media]
tvp5150: move input definition header to dt-bindings
[    5.136014] usb 1-1: dvb_usb_v2: found a 'TechnoTrend TT-connect
CT2-4650 CI' in warm state
[    5.136136] usb 1-1: dvb_usb_v2: will pass the complete MPEG2
transport stream to the software demuxer
[    5.136143] DVB: registering new adapter (TechnoTrend TT-connect CT2-4650 CI)
[    5.137383] usb 1-1: dvb_usb_v2: MAC address: bc:ea:2b:65:02:3b
[    5.137702] dvb_create_media_entity: media entity 'dvb-demux' registered.
[    5.139195] i2c i2c-6: Added multiplexed i2c bus 7
[    5.139197] si2168 6-0064: Silicon Labs Si2168 successfully attached
[    5.141987] si2157 7-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[    5.148177] dvb_create_media_entity: media entity 'dvb-ca-en50221'
registered.
[    5.148243] sp2 6-0040: CIMaX SP2 successfully attached
[    5.148248] usb 1-1: DVB: registering adapter 0 frontend 0 (Silicon
Labs Si2168)...
[    5.148250] dvb_create_media_entity: media entity 'Silicon Labs
Si2168' registered.
[    5.148618] ------------[ cut here ]------------
[    5.148623] WARNING: CPU: 0 PID: 449 at
/build/linux-NgsOGa/linux-4.2.0/lib/idr.c:1051 ida_remove+0xef/0x120()
[    5.148624] ida_remove called for id=512 which is not allocated.
[    5.148625] Modules linked in: sp2(OE) si2157(OE) si2168(OE)
dvb_usb_dvbsky(OE+) dvb_usb_v2(OE) m88ds3103(OE) dvb_core(OE)
rc_core(OE) i2c_mux media(OE) snd_hda_codec_hdmi nvidia_uvm(POE)
nvidia_modeset(POE) mxm_wmi nls_iso8859_1 intel_rapl
snd_hda_codec_realtek x86_pkg_temp_thermal intel_powerclamp
snd_hda_codec_generic crct10dif_pclmul crc32_pclmul nct6775
aesni_intel hwmon_vid coretemp snd_hda_intel aes_x86_64 lrw
snd_hda_codec gf128mul snd_hda_core glue_helper snd_hwdep ablk_helper
snd_pcm cryptd sb_edac nvidia(POE) joydev serio_raw edac_core
snd_seq_midi input_leds snd_seq_midi_event snd_rawmidi snd_seq drm
snd_seq_device snd_timer snd lpc_ich mei_me mei soundcore shpchp wmi
mac_hid kvm_intel kvm parport_pc ppdev lp parport autofs4 btrfs xor
raid6_pq hid_logitech_hidpp hid_logitech_dj usbhid
[    5.148656]  hid psmouse e1000e ahci ptp libahci nvme pps_core
[    5.148661] CPU: 0 PID: 449 Comm: systemd-udevd Tainted: P
 OE   4.2.0-27-generic #32-Ubuntu
[    5.148662] Hardware name: MSI MS-7885/X99A SLI PLUS(MS-7885), BIOS
1.90 10/30/2015
[    5.148664]  0000000000000000 0000000041b63e18 ffff8808978e3618
ffffffff817eae99
[    5.148666]  0000000000000000 ffff8808978e3670 ffff8808978e3658
ffffffff8107b9c6
[    5.148668]  ffff880894f6ff08 ffff880898c563d0 ffff880898c563d0
0000000000000292
[    5.148670] Call Trace:
[    5.148675]  [<ffffffff817eae99>] dump_stack+0x45/0x57
[    5.148678]  [<ffffffff8107b9c6>] warn_slowpath_common+0x86/0xc0
[    5.148680]  [<ffffffff8107ba55>] warn_slowpath_fmt+0x55/0x70
[    5.148683]  [<ffffffff810a5468>] ? check_preempt_curr+0x58/0xa0
[    5.148685]  [<ffffffff813c78cf>] ida_remove+0xef/0x120
[    5.148687]  [<ffffffff813c836f>] ida_simple_remove+0x2f/0x50
[    5.148690]  [<ffffffffc033919d>]
__media_device_unregister_entity+0x2d/0xd0 [media]
[    5.148692]  [<ffffffffc033926e>]
media_device_unregister_entity+0x2e/0x40 [media]
[    5.148696]  [<ffffffffc0e02163>] dvb_media_device_free+0x23/0x130 [dvb_core]
[    5.148698]  [<ffffffffc0e022ba>] dvb_unregister_device+0x4a/0xb0 [dvb_core]
[    5.148702]  [<ffffffffc0e08ca9>] dvb_ca_en50221_release+0x79/0xb0 [dvb_core]
[    5.148704]  [<ffffffffc035d289>] sp2_remove+0x49/0xa0 [sp2]
[    5.148707]  [<ffffffff81645baf>] i2c_device_remove+0x4f/0x90
[    5.148711]  [<ffffffff81521151>] __device_release_driver+0xa1/0x150
[    5.148712]  [<ffffffff81521223>] device_release_driver+0x23/0x30
[    5.148714]  [<ffffffff81520855>] bus_remove_device+0x105/0x180
[    5.148716]  [<ffffffff8151cc59>] device_del+0x139/0x260
[    5.148718]  [<ffffffff813c8b5f>] ? kobject_put+0x2f/0x60
[    5.148720]  [<ffffffff81646050>] ? __unregister_dummy+0x30/0x30
[    5.148722]  [<ffffffff8151cda2>] device_unregister+0x22/0x70
[    5.148723]  [<ffffffff8164608e>] __unregister_client+0x3e/0x50
[    5.148725]  [<ffffffff8151c6f0>] device_for_each_child+0x50/0x90
[    5.148727]  [<ffffffff8164814f>] i2c_del_adapter+0x23f/0x340
[    5.148730]  [<ffffffffc0e22984>] dvb_usbv2_exit+0x1c4/0x3c0 [dvb_usb_v2]
[    5.148732]  [<ffffffffc0e2346f>] dvb_usbv2_probe+0xff/0x12a0 [dvb_usb_v2]
[    5.148735]  [<ffffffff815e5212>] usb_probe_interface+0x1b2/0x2d0
[    5.148737]  [<ffffffff815217ea>] driver_probe_device+0x21a/0x490
[    5.148739]  [<ffffffff81521af0>] __driver_attach+0x90/0xa0
[    5.148741]  [<ffffffff81521a60>] ? driver_probe_device+0x490/0x490
[    5.148743]  [<ffffffff8151f38c>] bus_for_each_dev+0x6c/0xc0
[    5.148744]  [<ffffffff81520f8e>] driver_attach+0x1e/0x20
[    5.148746]  [<ffffffff81520abb>] bus_add_driver+0x1eb/0x280
[    5.148748]  [<ffffffff81522390>] driver_register+0x60/0xe0
[    5.148751]  [<ffffffff815e3b24>] usb_register_driver+0x84/0x140
[    5.148753]  [<ffffffffc02b9000>] ? 0xffffffffc02b9000
[    5.148755]  [<ffffffffc02b901e>]
dvbsky_usb_driver_init+0x1e/0x1000 [dvb_usb_dvbsky]
[    5.148758]  [<ffffffff81002123>] do_one_initcall+0xb3/0x200
[    5.148761]  [<ffffffff811de7f7>] ? kmem_cache_alloc_trace+0x187/0x1f0
[    5.148763]  [<ffffffff817e8958>] ? do_init_module+0x28/0x1e7
[    5.148765]  [<ffffffff817e8990>] do_init_module+0x60/0x1e7
[    5.148768]  [<ffffffff81102f96>] load_module+0x1676/0x1c10
[    5.148770]  [<ffffffff810ff0e0>] ? __symbol_put+0x60/0x60
[    5.148774]  [<ffffffff81203770>] ? kernel_read+0x50/0x80
[    5.148776]  [<ffffffff81103789>] SyS_finit_module+0xb9/0xf0
[    5.148779]  [<ffffffff817f1c72>] entry_SYSCALL_64_fastpath+0x16/0x75
[    5.148781] ---[ end trace 85bca7de611a2075 ]---
[    5.149763] dvb_usb_dvbsky: probe of 1-1:1.0 failed with error -12
[    5.149775] usbcore: registered new interface driver dvb_usb_dvbsky

Any ideas?

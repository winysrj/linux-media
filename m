Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:36640 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbBWJBv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 04:01:51 -0500
Received: by pdjp10 with SMTP id p10so24001286pdj.3
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 01:01:50 -0800 (PST)
Date: Mon, 23 Feb 2015 20:01:38 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Gert-Jan van der Stroom <gjstroom@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Mygica T230 DVB-T/T2/C Ubuntu 14.04 (kernel 3.13.0-45) using
 media_build
Message-ID: <20150223090136.GA11783@shambles.windy>
References: <002401d04ea1$e5cf1780$b16d4680$@gmail.com>
 <54EA4BB8.2080106@iki.fi>
 <20150222185503.41cbcb1a@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150222185503.41cbcb1a@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I saw this too, while working with Antti on adding support for 
another rtl2832-based DVB card.

The kernel version
[    0.000000] Linux version 3.13.0-45-generic (buildd@kissel) (gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #74-Ubuntu SMP Tue Jan 13 19:37:48 UTC 2015 (Ubuntu 3.13.0-45.74-generic 3.13.11-ckt13)


This is what dmesg contained:

[  247.897962] BUG: unable to handle kernel NULL pointer dereference at 00000008
[  247.897971] IP: [<f84f62f4>] media_entity_pipeline_start+0x24/0x350 [media]
[  247.897982] *pdpt = 000000001c70f001 *pde = 0000000000000000
[  247.897988] Oops: 0000 [#1] SMP
[  247.897992] Modules linked in: gpio_ich nvidia(POX) snd_hda_codec_hdmi bnep ir_lirc_codec(OX) rfcomm ir_xmp_decoder(OX) lirc_dev(OX) ir_sony_decoder(OX) ir_sharp_decoder(OX) ir_sanyo_decoder(OX) ir_rc6_decoder(OX) ir_rc5_decoder(OX) ir_nec_decoder(OX) ir_mce_kbd_decoder(OX) ir_jvc_decoder(OX) bluetooth rtl2832_sdr(OX) videobuf2_vmalloc(OX) snd_hda_intel videobuf2_memops(OX) snd_intel8x0 snd_ac97_codec snd_hda_codec videobuf2_core(OX) ac97_bus snd_hwdep v4l2_common(OX) snd_pcm videodev(OX) snd_page_alloc fc0013(OX) snd_seq_midi snd_seq_midi_event rtl2832(OX) snd_rawmidi i2c_mux snd_seq dvb_usb_rtl28xxu(OX) dvb_usb_v2(OX) dvb_core(OX) rc_core(OX) snd_seq_device media(OX) snd_timer dcdbas snd serio_raw drm soundcore lpc_ich shpchp ppdev parport_pc lp mac_hid parport hid_generic tg3 usbhid psmouse ptp e1000 pps_core pata_acpi floppy hid
[  247.898043] CPU: 0 PID: 2967 Comm: kdvb-ad-0-fe-0 Tainted: POX 3.13.0-45-generic #74-Ubuntu
[  247.898046] Hardware name: Dell Inc.                 OptiPlex GX280/0DG476, BIOS A07 11/29/2005
[  247.898049] task: e5e9db00 ti: dbb80000 task.ti: dbb80000
[  247.898052] EIP: 0060:[<f84f62f4>] EFLAGS: 00010286 CPU: 0
[  247.898058] EIP is at media_entity_pipeline_start+0x24/0x350 [media]
[  247.898061] EAX: 00000000 EBX: e0b26280 ECX: f7b8a580 EDX: f6aac614
[  247.898063] ESI: f6aac400 EDI: 00000000 EBP: dbb81f08 ESP: dbb81e30
[  247.898066]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  247.898069] CR0: 8005003b CR2: 00000008 CR3: 1c70e000 CR4: 000007f0
[  247.898072] Stack:
[  247.898074]  f7b8a5c8 00000001 00000006 00000000 b7de1fcc 00000039 00000000 00000001
[  247.898081]  00000000 f7b8a5c8 00000001 00000000 dbb81eb4 c1089ef6 dbb81eb8 c108c7c9
[  247.898086]  00000000 f7b8a580 f7b8a5c8 f7b8a580 f261ea00 e5e9db00 dbb81eac c108a44a
[  247.898093] Call Trace:
[  247.898102]  [<c1089ef6>] ? dequeue_task_fair+0x416/0x7c0
[  247.898106]  [<c108c7c9>] ? enqueue_task_fair+0x5d9/0x7e0
[  247.898110]  [<c108a44a>] ? check_preempt_wakeup+0x1aa/0x250
[  247.898115]  [<c1087b21>] ? set_next_entity+0xb1/0xe0
[  247.898120]  [<c100ed20>] ? __switch_to+0xb0/0x340
[  247.898126]  [<c1658fc8>] ? __schedule+0x358/0x770
[  247.898130]  [<c1082c60>] ? try_to_wake_up+0x150/0x240
[  247.898143]  [<f8763121>] dvb_frontend_thread+0x331/0x9a0 [dvb_core]
[  247.898154]  [<f8763121>] ? dvb_frontend_thread+0x331/0x9a0 [dvb_core]
[  247.898158]  [<c1082dc0>] ? default_wake_function+0x10/0x20
[  247.898162]  [<c1090f57>] ? __wake_up_common+0x47/0x70
[  247.898166]  [<c1090f9f>] ? __wake_up_locked+0x1f/0x30
[  247.898177]  [<f8762df0>] ? dvb_frontend_ioctl_legacy.isra.8+0xc20/0xc20 [dvb_core]
[  247.898182]  [<c10751d1>] kthread+0xa1/0xc0
[  247.898187]  [<c1663b37>] ret_from_kernel_thread+0x1b/0x28
[  247.898191]  [<c1075130>] ? kthread_create_on_node+0x140/0x140
[  247.898193] Code: 90 90 90 90 90 90 90 57 8d 7c 24 08 83 e4 f8 ff 77 fc 55 89 e5 57 56 53 81 ec cc 00 00 00 3e 8d 74 26 00 89 c7 89 85 48 ff ff ff <8b> 40 08 89 95 50 ff ff ff 89 85 60 ff ff ff 05 44 02 00
00 89
[  247.898229] EIP: [<f84f62f4>] media_entity_pipeline_start+0x24/0x350 [media] SS:ESP 0068:dbb81e30
[  247.898236] CR2: 0000000000000008
[  247.898241] ---[ end trace 800df23615d3c02a ]---


The git commit for the media_build tree at the time I compiled
everything was

commit  c40e87b410c9ed170e2ae6ca2aeef06a44621b20 
Add writel_relaxed supportHEADmaster
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

HTH
Vince


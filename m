Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:65333 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaGZT1Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 15:27:24 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9C00IY03DNJ800@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 26 Jul 2014 15:27:23 -0400 (EDT)
Date: Sat, 26 Jul 2014 16:27:18 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge
 WinTV 930C-HD (model 1114xx)
Message-id: <20140726162718.660cf512.m.chehab@samsung.com>
In-reply-to: <1406059938-21141-7-git-send-email-zzam@gentoo.org>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
 <1406059938-21141-7-git-send-email-zzam@gentoo.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 22 Jul 2014 22:12:16 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Hi Matthias,

Tried to apply your patch series, but there's something wrong on it.

See the enclosed logs. I suspect that you missed a patch adding the
proper tuner for this device.

Regards,
Mauro

[76183.104385] Linux video capture interface: v2.00
[76183.110508] cx231xx #0: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:b131) with 4 interfaces
[76183.110513] cx231xx #0: registering interface 1
[76183.110602] cx231xx #0: Identified as Hauppauge WinTV 930C-HD (1114xx) / PCTV QuatroStick 522e (card=20)
[76183.211942] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[76183.220035] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
[76183.220043] cx231xx #0: can't change interface 6 alt no. to 0 (err=-22)
[76183.228875] cx25840 0-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[76183.247286] cx25840 0-0044:  Firmware download size changed to 16 bytes max length
[76185.302724] cx25840 0-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[76185.336362] cx231xx #0: Changing the i2c master port to 1
[76185.368850] cx231xx #0: Changing the i2c master port to 3
[76185.368940] cx231xx #0: i2c eeprom 00: 40 20 31 b1 aa 00 00 01 10 00 50 00 30 00 ff ff
[76185.368944] cx231xx #0: i2c eeprom 10: 14 03 48 00 61 00 75 00 70 00 70 00 61 00 75 00
[76185.368946] cx231xx #0: i2c eeprom 20: 67 00 65 00 00 00 00 00 00 00 00 00 00 00 00 00
[76185.368949] cx231xx #0: i2c eeprom 30: 16 03 34 00 30 00 33 00 35 00 31 00 36 00 39 00
[76185.368951] cx231xx #0: i2c eeprom 40: 31 00 31 00 32 00 00 00 ff ff ff ff ff ff ff ff
[76185.368953] cx231xx #0: i2c eeprom 50: 22 03 48 00 61 00 75 00 70 00 70 00 61 00 75 00
[76185.368956] cx231xx #0: i2c eeprom 60: 67 00 65 00 20 00 44 00 65 00 76 00 69 00 63 00
[76185.368958] cx231xx #0: i2c eeprom 70: 65 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[76185.368960] cx231xx #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[76185.368962] cx231xx #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[76185.368964] cx231xx #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[76185.368966] cx231xx #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[76185.368969] cx231xx #0: i2c eeprom c0: 84 09 00 04 20 77 00 40 58 cb 83 f0 73 05 2f 00
[76185.368971] cx231xx #0: i2c eeprom d0: 84 08 00 06 3b b3 01 00 56 2a 95 72 07 70 73 09
[76185.368973] cx231xx #0: i2c eeprom e0: 2e 7f 73 0a f4 ba 72 0b 13 72 0f 05 72 10 01 72
[76185.368975] cx231xx #0: i2c eeprom f0: 11 1f 73 13 eb 79 79 ea 00 00 00 00 00 00 00 00
[76185.368981] tveeprom 1-0000: Hauppauge model 111419, rev E2I6, serial# 8637272
[76185.368984] tveeprom 1-0000: MAC address is 00:0d:fe:83:cb:58
[76185.368987] tveeprom 1-0000: tuner model is unknown (idx 186, type 4)
[76185.368991] tveeprom 1-0000: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[76185.368993] tveeprom 1-0000: audio processor is unknown (idx 47)
[76185.368995] tveeprom 1-0000: decoder processor is unknown (idx 46)
[76185.368998] tveeprom 1-0000: has no radio, has IR receiver, has no IR transmitter
[76185.370090] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.2
[76185.387866] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[76185.431668] Unknown tuner type configuring SIF
[76185.432964] cx231xx #0: video_mux : 0
[76185.432972] cx231xx #0: do_mode_ctrl_overrides : 0xff
[76185.433843] cx231xx #0: do_mode_ctrl_overrides PAL
[76185.463109] cx231xx #0: cx231xx #0/0: registered device video0 [v4l2]
[76185.463321] cx231xx #0: cx231xx #0/0: registered device vbi0
[76185.463325] cx231xx #0: V4L2 device registered as video0 and vbi0
[76185.463331] cx231xx #0: EndPoint Addr 0x84, Alternate settings: 2
[76185.463334] cx231xx #0: Alternate setting 0, max size= 64
[76185.463336] cx231xx #0: Alternate setting 1, max size= 728
[76185.463359] BUG: unable to handle kernel NULL pointer dereference at           (null)
[76185.465295] IP: [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
[76185.465654] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
[76185.465705] cx231xx #0: called cx231xx_uninit_vbi_isoc
[76185.465707] cx231xx #0: cx231xx_stop_stream():: ep_mask = 10
[76185.465872] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
[76185.474837] PGD 21c0fa067 PUD 2182b4067 PMD 0 
[76185.476593] Oops: 0000 [#1] SMP 
[76185.478285] Modules linked in: cx25840 cx231xx(+) cx2341x tveeprom videobuf_vmalloc videobuf_core rc_core v4l2_common videodev media ip6table_filter ip6_tables bnep nouveau x86_pkg_temp_thermal coretemp i915 binfmt_misc kvm_intel kvm ttm i2c_algo_bit drm_kms_helper vfat fat drm arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec iwlwifi crct10dif_pclmul snd_hwdep crc32_pclmul cfg80211 snd_seq snd_seq_device snd_pcm crc32c_intel snd_timer btusb bluetooth iTCO_wdt iTCO_vendor_support mxm_wmi ghash_clmulni_intel lpc_ich i2c_i801 snd mei_me soundcore rfkill joydev serio_raw shpchp mei wmi mfd_core i2c_core video microcode r8169 mii [last unloaded: dvb_core]
[76185.487219] CPU: 0 PID: 12079 Comm: modprobe Not tainted 3.16.0-rc6+ #12
[76185.488936] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
[76185.490710] task: ffff880211172ee0 ti: ffff88021866c000 task.ti: ffff88021866c000
[76185.492502] RIP: 0010:[<ffffffffa048dec8>]  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
[76185.494321] RSP: 0018:ffff88021866fb50  EFLAGS: 00010246
[76185.496037] RAX: ffff88021c34fc00 RBX: ffff8800c4f70000 RCX: 0000000000000006
[76185.497781] RDX: 0000000000000004 RSI: ffff8800c4f70000 RDI: ffffffffa04a7508
[76185.499548] RBP: ffff88021866fb90 R08: 0000000000000000 R09: 00000000000011d3
[76185.501323] R10: 0000000000000000 R11: ffff88021866f85e R12: ffff88021bc20800
[76185.503119] R13: ffff88021bc27c00 R14: ffff8800c4f70168 R15: ffff8802229ca000
[76185.504934] FS:  00007f6c13b2e740(0000) GS:ffff88022f200000(0000) knlGS:0000000000000000
[76185.506662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[76185.508406] CR2: 0000000000000000 CR3: 00000002222b8000 CR4: 00000000001407f0
[76185.510169] Stack:
[76185.511921]  ffff88020000b131 ffffffff00000004 ffff880000000001 ffff8802229ca090
[76185.513725]  ffff8802229ca000 ffffffffa04ab568 ffff88021bc27c30 ffffffffa04ab7a0
[76185.515517]  ffff88021866fbd8 ffffffff814eefcf 000000001866fbb0 ffff88021bc27c00
[76185.517248] Call Trace:
[76185.518963]  [<ffffffff814eefcf>] usb_probe_interface+0x1df/0x330
[76185.520714]  [<ffffffff8146605d>] driver_probe_device+0x12d/0x3d0
[76185.522452]  [<ffffffff814663d3>] __driver_attach+0x93/0xa0
[76185.524203]  [<ffffffff81466340>] ? __device_attach+0x40/0x40
[76185.525959]  [<ffffffff81463f03>] bus_for_each_dev+0x73/0xc0
[76185.527599]  [<ffffffff81465a5e>] driver_attach+0x1e/0x20
[76185.529240]  [<ffffffff81465640>] bus_add_driver+0x180/0x250
[76185.537278]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[76185.538809]  [<ffffffff811b5fd4>] ? __vunmap+0x94/0x100
[76185.540330]  [<ffffffff81106767>] load_module+0x1ea7/0x24f0
[76185.541806]  [<ffffffff81102370>] ? store_uevent+0x70/0x70
[76185.543255]  [<ffffffff811f3200>] ? kernel_read+0x50/0x80
[76185.544661]  [<ffffffff81106f66>] SyS_finit_module+0xa6/0xd0
[76185.546047]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
[76185.547354] Code: 1d 00 00 85 ff 0f 8f 94 04 00 00 0f b6 93 bb 21 00 00 49 8b 87 68 03 00 00 48 89 de 48 c7 c7 08 75 4a a0 4c 8b 84 d0 a0 00 00 00 <49> 8b 00 4c 89 45 d0 48 8b 40 18 0f b6 40 02 0f b6 d0 66 89 93 
[76185.550208] RIP  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
[76185.551613]  RSP <ffff88021866fb50>
[76185.553006] CR2: 0000000000000000
[76185.559997] ---[ end trace 1e58ef345d6b3f24 ]---

$ gdb drivers/media/usb/cx231xx/cx231xx.ko
GNU gdb (GDB) Fedora 7.7.1-15.fc20
Copyright (C) 2014 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from drivers/media/usb/cx231xx/cx231xx.ko...done.
(gdb) list *cx231xx_usb_driver_init+0x1e
0x1e is in buffer_setup (drivers/media/usb/cx231xx/cx231xx-video.c:664).
659	buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
660	{
661		struct cx231xx_fh *fh = vq->priv_data;
662		struct cx231xx *dev = fh->dev;
663	
664		*size = (fh->dev->width * fh->dev->height * dev->format->depth + 7)>>3;
665		if (0 == *count)
666			*count = CX231XX_DEF_BUF;
667	
668		if (*count < CX231XX_MIN_BUF)

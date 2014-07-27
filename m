Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56903 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaG0Jcs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 05:32:48 -0400
Message-ID: <53D4C72A.4010209@gentoo.org>
Date: Sun, 27 Jul 2014 11:32:26 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge
 WinTV 930C-HD (model 1114xx)
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org> <1406059938-21141-7-git-send-email-zzam@gentoo.org> <20140726162718.660cf512.m.chehab@samsung.com>
In-Reply-To: <20140726162718.660cf512.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro.

On 26.07.2014 21:27, Mauro Carvalho Chehab wrote:
> Tried to apply your patch series, but there's something wrong on it.
> 
> See the enclosed logs. I suspect that you missed a patch adding the
> proper tuner for this device.

well, tuner_type is set to TUNER_ABSENT, and for me the oops does not
happen.

> [76185.463359] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [76185.465295] IP: [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> [76185.465654] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
> [76185.465705] cx231xx #0: called cx231xx_uninit_vbi_isoc
> [76185.465707] cx231xx #0: cx231xx_stop_stream():: ep_mask = 10
> [76185.465872] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
> [76185.474837] PGD 21c0fa067 PUD 2182b4067 PMD 0 
> [76185.476593] Oops: 0000 [#1] SMP 
> [76185.478285] Modules linked in: cx25840 cx231xx(+) cx2341x tveeprom videobuf_vmalloc videobuf_core rc_core v4l2_common videodev media ip6table_filter ip6_tables bnep nouveau x86_pkg_temp_thermal coretemp i915 binfmt_misc kvm_intel kvm ttm i2c_algo_bit drm_kms_helper vfat fat drm arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec iwlwifi crct10dif_pclmul snd_hwdep crc32_pclmul cfg80211 snd_seq snd_seq_device snd_pcm crc32c_intel snd_timer btusb bluetooth iTCO_wdt iTCO_vendor_support mxm_wmi ghash_clmulni_intel lpc_ich i2c_i801 snd mei_me soundcore rfkill joydev serio_raw shpchp mei wmi mfd_core i2c_core video microcode r8169 mii [last unloaded: dvb_core]
> [76185.487219] CPU: 0 PID: 12079 Comm: modprobe Not tainted 3.16.0-rc6+ #12
> [76185.488936] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
> [76185.490710] task: ffff880211172ee0 ti: ffff88021866c000 task.ti: ffff88021866c000
> [76185.492502] RIP: 0010:[<ffffffffa048dec8>]  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> [76185.494321] RSP: 0018:ffff88021866fb50  EFLAGS: 00010246
> [76185.496037] RAX: ffff88021c34fc00 RBX: ffff8800c4f70000 RCX: 0000000000000006
> [76185.497781] RDX: 0000000000000004 RSI: ffff8800c4f70000 RDI: ffffffffa04a7508
> [76185.499548] RBP: ffff88021866fb90 R08: 0000000000000000 R09: 00000000000011d3
> [76185.501323] R10: 0000000000000000 R11: ffff88021866f85e R12: ffff88021bc20800
> [76185.503119] R13: ffff88021bc27c00 R14: ffff8800c4f70168 R15: ffff8802229ca000
> [76185.504934] FS:  00007f6c13b2e740(0000) GS:ffff88022f200000(0000) knlGS:0000000000000000
> [76185.506662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [76185.508406] CR2: 0000000000000000 CR3: 00000002222b8000 CR4: 00000000001407f0
> [76185.510169] Stack:
> [76185.511921]  ffff88020000b131 ffffffff00000004 ffff880000000001 ffff8802229ca090
> [76185.513725]  ffff8802229ca000 ffffffffa04ab568 ffff88021bc27c30 ffffffffa04ab7a0
> [76185.515517]  ffff88021866fbd8 ffffffff814eefcf 000000001866fbb0 ffff88021bc27c00
> [76185.517248] Call Trace:
> [76185.518963]  [<ffffffff814eefcf>] usb_probe_interface+0x1df/0x330
> [76185.520714]  [<ffffffff8146605d>] driver_probe_device+0x12d/0x3d0
> [76185.522452]  [<ffffffff814663d3>] __driver_attach+0x93/0xa0
> [76185.524203]  [<ffffffff81466340>] ? __device_attach+0x40/0x40
> [76185.525959]  [<ffffffff81463f03>] bus_for_each_dev+0x73/0xc0
> [76185.527599]  [<ffffffff81465a5e>] driver_attach+0x1e/0x20
> [76185.529240]  [<ffffffff81465640>] bus_add_driver+0x180/0x250
> [76185.537278]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
> [76185.538809]  [<ffffffff811b5fd4>] ? __vunmap+0x94/0x100
> [76185.540330]  [<ffffffff81106767>] load_module+0x1ea7/0x24f0
> [76185.541806]  [<ffffffff81102370>] ? store_uevent+0x70/0x70
> [76185.543255]  [<ffffffff811f3200>] ? kernel_read+0x50/0x80
> [76185.544661]  [<ffffffff81106f66>] SyS_finit_module+0xa6/0xd0
> [76185.546047]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
> [76185.547354] Code: 1d 00 00 85 ff 0f 8f 94 04 00 00 0f b6 93 bb 21 00 00 49 8b 87 68 03 00 00 48 89 de 48 c7 c7 08 75 4a a0 4c 8b 84 d0 a0 00 00 00 <49> 8b 00 4c 89 45 d0 48 8b 40 18 0f b6 40 02 0f b6 d0 66 89 93 
> [76185.550208] RIP  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> [76185.551613]  RSP <ffff88021866fb50>
> [76185.553006] CR2: 0000000000000000
> [76185.559997] ---[ end trace 1e58ef345d6b3f24 ]---
> 

Is the order of the printk messages and of the oops message fixed? Are
all messages printed before the oops also before the oops message?

It seems to oops is at cx231xx_usb_probe+0x5a8/0xb20.

> $ gdb drivers/media/usb/cx231xx/cx231xx.ko
> GNU gdb (GDB) Fedora 7.7.1-15.fc20
> Copyright (C) 2014 Free Software Foundation, Inc.
> License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> This is free software: you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
[...]
> Type "apropos word" to search for commands related to "word"...
> Reading symbols from drivers/media/usb/cx231xx/cx231xx.ko...done.
> (gdb) list *cx231xx_usb_driver_init+0x1e

Could you retry this with the offset from above (0x5a8).
I normally use nm to get the base addr of the function, then add the
offset and then run "addr2line -ispf -e cx231xx.ko -a 0x....."

Regards
Matthias


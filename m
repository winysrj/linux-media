Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:15439 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaG0O7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 10:59:17 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9D002KVLMRZS70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 27 Jul 2014 10:59:15 -0400 (EDT)
Date: Sun, 27 Jul 2014 11:59:11 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/8] cx231xx: Add digital support for [2040:b131] Hauppauge
 WinTV 930C-HD (model 1114xx)
Message-id: <20140727115911.0dde3d30.m.chehab@samsung.com>
In-reply-to: <20140727113248.29dccc38.m.chehab@samsung.com>
References: <1406059938-21141-1-git-send-email-zzam@gentoo.org>
 <1406059938-21141-7-git-send-email-zzam@gentoo.org>
 <20140726162718.660cf512.m.chehab@samsung.com> <53D4C72A.4010209@gentoo.org>
 <20140727104453.4578b353.m.chehab@samsung.com>
 <20140727113248.29dccc38.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Jul 2014 11:32:48 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 27 Jul 2014 10:44:53 -0300
> Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:
> 
> > Em Sun, 27 Jul 2014 11:32:26 +0200
> > Matthias Schwarzott <zzam@gentoo.org> escreveu:
> > 
> > > 
> > > Hi Mauro.
> > > 
> > > On 26.07.2014 21:27, Mauro Carvalho Chehab wrote:
> > > > Tried to apply your patch series, but there's something wrong on it.
> > > > 
> > > > See the enclosed logs. I suspect that you missed a patch adding the
> > > > proper tuner for this device.
> > > 
> > > well, tuner_type is set to TUNER_ABSENT, and for me the oops does not
> > > happen.
> > > 
> > > > [76185.463359] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > > > [76185.465295] IP: [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> > > > [76185.465654] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
> > > > [76185.465705] cx231xx #0: called cx231xx_uninit_vbi_isoc
> > > > [76185.465707] cx231xx #0: cx231xx_stop_stream():: ep_mask = 10
> > > > [76185.465872] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
> > > > [76185.474837] PGD 21c0fa067 PUD 2182b4067 PMD 0 
> > > > [76185.476593] Oops: 0000 [#1] SMP 
> > > > [76185.478285] Modules linked in: cx25840 cx231xx(+) cx2341x tveeprom videobuf_vmalloc videobuf_core rc_core v4l2_common videodev media ip6table_filter ip6_tables bnep nouveau x86_pkg_temp_thermal coretemp i915 binfmt_misc kvm_intel kvm ttm i2c_algo_bit drm_kms_helper vfat fat drm arc4 iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec iwlwifi crct10dif_pclmul snd_hwdep crc32_pclmul cfg80211 snd_seq snd_seq_device snd_pcm crc32c_intel snd_timer btusb bluetooth iTCO_wdt iTCO_vendor_support mxm_wmi ghash_clmulni_intel lpc_ich i2c_i801 snd mei_me soundcore rfkill joydev serio_raw shpchp mei wmi mfd_core i2c_core video microcode r8169 mii [last unloaded: dvb_core]
> > > > [76185.487219] CPU: 0 PID: 12079 Comm: modprobe Not tainted 3.16.0-rc6+ #12
> > > > [76185.488936] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 550P5C/550P7C/SAMSUNG_NP1234567890, BIOS P05ABI.016.130917.dg 09/17/2013
> > > > [76185.490710] task: ffff880211172ee0 ti: ffff88021866c000 task.ti: ffff88021866c000
> > > > [76185.492502] RIP: 0010:[<ffffffffa048dec8>]  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> > > > [76185.494321] RSP: 0018:ffff88021866fb50  EFLAGS: 00010246
> > > > [76185.496037] RAX: ffff88021c34fc00 RBX: ffff8800c4f70000 RCX: 0000000000000006
> > > > [76185.497781] RDX: 0000000000000004 RSI: ffff8800c4f70000 RDI: ffffffffa04a7508
> > > > [76185.499548] RBP: ffff88021866fb90 R08: 0000000000000000 R09: 00000000000011d3
> > > > [76185.501323] R10: 0000000000000000 R11: ffff88021866f85e R12: ffff88021bc20800
> > > > [76185.503119] R13: ffff88021bc27c00 R14: ffff8800c4f70168 R15: ffff8802229ca000
> > > > [76185.504934] FS:  00007f6c13b2e740(0000) GS:ffff88022f200000(0000) knlGS:0000000000000000
> > > > [76185.506662] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [76185.508406] CR2: 0000000000000000 CR3: 00000002222b8000 CR4: 00000000001407f0
> > > > [76185.510169] Stack:
> > > > [76185.511921]  ffff88020000b131 ffffffff00000004 ffff880000000001 ffff8802229ca090
> > > > [76185.513725]  ffff8802229ca000 ffffffffa04ab568 ffff88021bc27c30 ffffffffa04ab7a0
> > > > [76185.515517]  ffff88021866fbd8 ffffffff814eefcf 000000001866fbb0 ffff88021bc27c00
> > > > [76185.517248] Call Trace:
> > > > [76185.518963]  [<ffffffff814eefcf>] usb_probe_interface+0x1df/0x330
> > > > [76185.520714]  [<ffffffff8146605d>] driver_probe_device+0x12d/0x3d0
> > > > [76185.522452]  [<ffffffff814663d3>] __driver_attach+0x93/0xa0
> > > > [76185.524203]  [<ffffffff81466340>] ? __device_attach+0x40/0x40
> > > > [76185.525959]  [<ffffffff81463f03>] bus_for_each_dev+0x73/0xc0
> > > > [76185.527599]  [<ffffffff81465a5e>] driver_attach+0x1e/0x20
> > > > [76185.529240]  [<ffffffff81465640>] bus_add_driver+0x180/0x250
> > > > [76185.537278]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
> > > > [76185.538809]  [<ffffffff811b5fd4>] ? __vunmap+0x94/0x100
> > > > [76185.540330]  [<ffffffff81106767>] load_module+0x1ea7/0x24f0
> > > > [76185.541806]  [<ffffffff81102370>] ? store_uevent+0x70/0x70
> > > > [76185.543255]  [<ffffffff811f3200>] ? kernel_read+0x50/0x80
> > > > [76185.544661]  [<ffffffff81106f66>] SyS_finit_module+0xa6/0xd0
> > > > [76185.546047]  [<ffffffff816fc869>] system_call_fastpath+0x16/0x1b
> > > > [76185.547354] Code: 1d 00 00 85 ff 0f 8f 94 04 00 00 0f b6 93 bb 21 00 00 49 8b 87 68 03 00 00 48 89 de 48 c7 c7 08 75 4a a0 4c 8b 84 d0 a0 00 00 00 <49> 8b 00 4c 89 45 d0 48 8b 40 18 0f b6 40 02 0f b6 d0 66 89 93 
> > > > [76185.550208] RIP  [<ffffffffa048dec8>] cx231xx_usb_probe+0x5a8/0xb20 [cx231xx]
> > > > [76185.551613]  RSP <ffff88021866fb50>
> > > > [76185.553006] CR2: 0000000000000000
> > > > [76185.559997] ---[ end trace 1e58ef345d6b3f24 ]---
> > > > 
> > > 
> > > Is the order of the printk messages and of the oops message fixed? Are
> > > all messages printed before the oops also before the oops message?
> > > 
> > > It seems to oops is at cx231xx_usb_probe+0x5a8/0xb20.
> > > 
> > > > $ gdb drivers/media/usb/cx231xx/cx231xx.ko
> > > > GNU gdb (GDB) Fedora 7.7.1-15.fc20
> > > > Copyright (C) 2014 Free Software Foundation, Inc.
> > > > License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
> > > > This is free software: you are free to change and redistribute it.
> > > > There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
> > > [...]
> > > > Type "apropos word" to search for commands related to "word"...
> > > > Reading symbols from drivers/media/usb/cx231xx/cx231xx.ko...done.
> > > > (gdb) list *cx231xx_usb_driver_init+0x1e
> > > 
> > > Could you retry this with the offset from above (0x5a8).
> > 
> > (gdb) list *cx231xx_usb_probe+0x5a8
> > 0x4ec8 is in cx231xx_usb_probe (drivers/media/usb/cx231xx/cx231xx-cards.c:1432).
> > 1427		uif = udev->actconfig->interface[dev->current_pcb_config.
> > 1428					       hs_config_info[0].interface_info.
> > 1429					       vanc_index + 1];
> > 1430	
> > 1431		dev->vbi_mode.end_point_addr =
> > 1432		    uif->altsetting[0].endpoint[isoc_pipe].desc.
> > 1433				bEndpointAddress;
> > 1434	
> > 1435		dev->vbi_mode.num_alt = uif->num_altsetting;
> > 1436		cx231xx_info("EndPoint Addr 0x%x, Alternate settings: %i\n",
> > 
> > > I normally use nm to get the base addr of the function, then add the
> > > offset and then run "addr2line -ispf -e cx231xx.ko -a 0x....."
> > 
> > Well, gdb is quicker, as it is just one command ;)
> 
> I found the issue. there are just two interfaces on this device, but 

Actually there are 4 interfaces. Still, 5 is out of the array.

> vanc_index is equal to 4 for this PCB. So, it tries to set VBI on
> interface 5, with obviously fails.
> 
> It seems that the code is identifying a wrong PCB for this device.
> 
> That's said, the probe logic is doing a crap job by allowing to go
> past the array.

Just sent a patch detecting this condition and aborting the probe.
That solved the OOPS, but, of course, the device doesn't work.

See the logs.

[  326.546032] usb 3-4: new full-speed USB device number 2 using xhci_hcd
[  326.710374] usb 3-4: not running at top speed; connect to a high speed hub
[  326.713276] usb 3-4: New USB device found, idVendor=2040, idProduct=b131
[  326.713284] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  326.713288] usb 3-4: Product: Hauppauge Device
[  326.713291] usb 3-4: Manufacturer: Hauppauge
[  326.713294] usb 3-4: SerialNumber: 4035169112
[  326.770414] cx231xx #0: New device Hauppauge Hauppauge Device @ 12 Mbps (2040:b131) with 4 interfaces
[  326.770420] cx231xx #0: registering interface 1
[  326.770499] cx231xx #0: Identified as Hauppauge WinTV 930C-HD (1114xx) / PCTV QuatroStick 522e (card=20)
[  326.871215] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[  326.879356] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
[  326.879363] cx231xx #0: can't change interface 6 alt no. to 0 (err=-22)
[  326.890080] cx25840 19-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0)
[  326.909307] cx25840 19-0044:  Firmware download size changed to 16 bytes max length
[  328.991008] cx25840 19-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
[  329.028463] cx231xx #0: Changing the i2c master port to 1
[  329.060338] cx231xx #0: Changing the i2c master port to 3
[  329.060404] cx231xx #0: i2c eeprom 00: 40 20 31 b1 aa 00 00 01 10 00 50 00 30 00 ff ff
[  329.060410] cx231xx #0: i2c eeprom 10: 14 03 48 00 61 00 75 00 70 00 70 00 61 00 75 00
[  329.060413] cx231xx #0: i2c eeprom 20: 67 00 65 00 00 00 00 00 00 00 00 00 00 00 00 00
[  329.060416] cx231xx #0: i2c eeprom 30: 16 03 34 00 30 00 33 00 35 00 31 00 36 00 39 00
[  329.060419] cx231xx #0: i2c eeprom 40: 31 00 31 00 32 00 00 00 ff ff ff ff ff ff ff ff
[  329.060423] cx231xx #0: i2c eeprom 50: 22 03 48 00 61 00 75 00 70 00 70 00 61 00 75 00
[  329.060426] cx231xx #0: i2c eeprom 60: 67 00 65 00 20 00 44 00 65 00 76 00 69 00 63 00
[  329.060429] cx231xx #0: i2c eeprom 70: 65 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  329.060433] cx231xx #0: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  329.060436] cx231xx #0: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  329.060440] cx231xx #0: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  329.060444] cx231xx #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  329.060447] cx231xx #0: i2c eeprom c0: 84 09 00 04 20 77 00 40 58 cb 83 f0 73 05 2f 00
[  329.060450] cx231xx #0: i2c eeprom d0: 84 08 00 06 3b b3 01 00 56 2a 95 72 07 70 73 09
[  329.060453] cx231xx #0: i2c eeprom e0: 2e 7f 73 0a f4 ba 72 0b 13 72 0f 05 72 10 01 72
[  329.060457] cx231xx #0: i2c eeprom f0: 11 1f 73 13 eb 79 79 ea 00 00 00 00 00 00 00 00
[  329.060464] tveeprom 20-0000: Hauppauge model 111419, rev E2I6, serial# 8637272
[  329.060470] tveeprom 20-0000: MAC address is 00:0d:fe:83:cb:58
[  329.060474] tveeprom 20-0000: tuner model is unknown (idx 186, type 4)
[  329.060479] tveeprom 20-0000: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[  329.060483] tveeprom 20-0000: audio processor is unknown (idx 47)
[  329.060486] tveeprom 20-0000: decoder processor is unknown (idx 46)
[  329.060490] tveeprom 20-0000: has no radio, has IR receiver, has no IR transmitter
[  329.061545] cx231xx #0: cx231xx #0: v4l2 driver version 0.0.2
[  329.078247] cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
[  329.116882] Unknown tuner type configuring SIF
[  329.118011] cx231xx #0: video_mux : 0
[  329.118043] cx231xx #0: do_mode_ctrl_overrides : 0xff
[  329.118802] cx231xx #0: do_mode_ctrl_overrides PAL
[  329.145116] cx231xx #0: cx231xx #0/0: registered device video1 [v4l2]
[  329.145290] cx231xx #0: cx231xx #0/0: registered device vbi0
[  329.145294] cx231xx #0: V4L2 device registered as video1 and vbi0
[  329.145296] cx231xx #0: Video PCB interface #4 doesn't exist
[  329.145372] usbcore: registered new interface driver cx231xx
[  329.148408] cx231xx #0:  setPowerMode::mode = 32, No Change req.
[  329.148418] usb 3-4: selecting invalid altsetting 3
[  329.148421] cx231xx #0: cannot change alt number to 3 (error=-22)
[  329.149508] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)
[  329.149570] cx231xx #0: called cx231xx_uninit_vbi_isoc
[  329.149574] cx231xx #0: cx231xx_stop_stream():: ep_mask = 10
[  329.149721] cx231xx #0: can't change interface 5 alt no. to 0 (err=-22)



> 
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

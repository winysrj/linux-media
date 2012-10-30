Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58804 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965239Ab2J3STC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 14:19:02 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so322751bkc.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 11:19:00 -0700 (PDT)
Message-ID: <50900BF6.1030502@googlemail.com>
Date: Tue, 30 Oct 2012 19:18:46 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com> <20121028175752.447c39d5@redhat.com> <508EA1B8.3070304@googlemail.com> <20121029180348.7e7967aa@redhat.com> <508EF1CF.8090602@googlemail.com> <20121030010012.30e1d2de@redhat.com> <20121030020619.6e854f70@redhat.com>
In-Reply-To: <20121030020619.6e854f70@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.10.2012 06:06, schrieb Mauro Carvalho Chehab:

<snip>
> Did a git bisect. The last patch where the bug doesn't occur is this 
> changeset:
> 	em28xx: add module parameter for selection of the preferred USB transfer type
>
> That means that this changeset broke it:
>
> 	em28xx: use common urb data copying function for vbi and non-vbi devices
Ok, thanks.
That means we are VERY close...

I think this is the only change that could cause the trouble:
> @@ -599,6 +491,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
>  			len = actual_length - 4;
>  		} else if (p[0] == 0x22 && p[1] == 0x5a) {
>  			/* start video */
> +			dev->capture_type = 1;
>  			p += 4;
>  			len = actual_length - 4;
>  		} else {

Could you try again with this line commented out ? (em28xx-video.c, line
494 in the patched file).
usb_debug=1 would be usefull, too.

> I didn't test them with my Silvercrest webcam yet.

I re-tested 5 minutes ago with this device and it works fine.
Btw, which frame rates do you get  ? ;)

Regards,
Frank

> I hope that helps.
>
> Regards,
> Mauro
>
> PS.: Logs of the latest working driver is enclosed.
>
>
> [ 4658.112071] media: Linux media interface: v0.10
> [ 4658.118615] Linux video capture interface: v2.00
> [ 4658.123229] WARNING: You are using an experimental version of the media stack.
> 	As the driver is backported to an older kernel, it doesn't offer
> 	enough quality for its usage in production.
> 	Use it with care.
> Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
> 	d259aec2578fe66c43ae89ef65735fa7b70fa948 [media] em28xx: add module parameter for selection of the preferred USB transfer type
> 	2c930ac7e1aa0c8181d5d283e4cb5de69b8121d5 [media] em28xx: improve USB endpoint logic, also use bulk transfers
> 	6b43cf6a235d564487fd10d73d8c377d4d6bafff [media] em28xx: set USB alternate settings for analog video bulk transfers properly
> [ 4658.192384] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
> [ 4658.200654] em28xx: Audio Vendor Class interface 0 found
> [ 4658.205957] em28xx: Video interface 0 found
> [ 4658.210133] em28xx: DVB interface 0 found
> [ 4658.214178] em28xx #0: chip ID is em2882/em2883
> [ 4658.361126] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
> [ 4658.369192] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
> [ 4658.377234] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
> [ 4658.385334] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
> [ 4658.393444] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 4658.401638] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 4658.409788] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
> [ 4658.417909] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
> [ 4658.425992] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
> [ 4658.434026] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
> [ 4658.442100] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
> [ 4658.450227] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
> [ 4658.458311] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
> [ 4658.466409] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
> [ 4658.474500] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
> [ 4658.482585] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
> [ 4658.490566] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
> [ 4658.497081] em28xx #0: EEPROM info:
> [ 4658.500564] em28xx #0:	AC97 audio (5 sample rates)
> [ 4658.505346] em28xx #0:	500mA max power
> [ 4658.509087] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
> [ 4658.515433] em28xx #0: Identified as Hauppauge WinTV HVR 950 (card=16)
> [ 4658.525141] tveeprom 3-0050: Hauppauge model 65201, rev A1C0, serial# 1917178
> [ 4658.532283] tveeprom 3-0050: tuner model is Xceive XC3028 (idx 120, type 71)
> [ 4658.539312] tveeprom 3-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
> [ 4658.548426] tveeprom 3-0050: audio processor is None (idx 0)
> [ 4658.554069] tveeprom 3-0050: has radio
> [ 4658.606748] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
> [ 4658.612155] tvp5150 3-005c: tvp5150am1 detected.
> [ 4658.636054] tuner 3-0061: Tuner -1 found with type(s) Radio TV.
> [ 4658.643381] xc2028: Xcv2028/3028 init called!
> [ 4658.643384] xc2028 3-0061: creating new instance
> [ 4658.647993] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
> [ 4658.654089] xc2028 3-0061: xc2028_set_config called
> [ 4658.654102] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4658.654104] xc2028 3-0061: generic_set_freq called
> [ 4658.654105] xc2028 3-0061: should set frequency 567250 kHz
> [ 4658.654106] xc2028 3-0061: check_firmware called
> [ 4658.655153] em28xx #0: Config register raw data: 0xd0
> [ 4658.660914] xc2028 3-0061: request_firmware_nowait(): OK
> [ 4658.660917] xc2028 3-0061: load_all_firmwares called
> [ 4658.660919] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [ 4658.670417] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
> [ 4658.670424] xc2028 3-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
> [ 4658.670430] xc2028 3-0061: Reading firmware type BASE FM (401), id 0, size=8562.
> [ 4658.670436] xc2028 3-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
> [ 4658.670441] xc2028 3-0061: Reading firmware type BASE (1), id 0, size=8706.
> [ 4658.670446] xc2028 3-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
> [ 4658.670451] xc2028 3-0061: Reading firmware type (0), id 100000007, size=161.
> [ 4658.670453] xc2028 3-0061: Reading firmware type MTS (4), id 100000007, size=169.
> [ 4658.670455] xc2028 3-0061: Reading firmware type (0), id 200000007, size=161.
> [ 4658.670457] xc2028 3-0061: Reading firmware type MTS (4), id 200000007, size=169.
> [ 4658.670459] xc2028 3-0061: Reading firmware type (0), id 400000007, size=161.
> [ 4658.670460] xc2028 3-0061: Reading firmware type MTS (4), id 400000007, size=169.
> [ 4658.670462] xc2028 3-0061: Reading firmware type (0), id 800000007, size=161.
> [ 4658.670464] xc2028 3-0061: Reading firmware type MTS (4), id 800000007, size=169.
> [ 4658.670467] xc2028 3-0061: Reading firmware type (0), id 3000000e0, size=161.
> [ 4658.670469] xc2028 3-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
> [ 4658.670471] xc2028 3-0061: Reading firmware type (0), id c000000e0, size=161.
> [ 4658.670472] xc2028 3-0061: Reading firmware type MTS (4), id c000000e0, size=169.
> [ 4658.670474] xc2028 3-0061: Reading firmware type (0), id 200000, size=161.
> [ 4658.670476] xc2028 3-0061: Reading firmware type MTS (4), id 200000, size=169.
> [ 4658.670478] xc2028 3-0061: Reading firmware type (0), id 4000000, size=161.
> [ 4658.670480] xc2028 3-0061: Reading firmware type MTS (4), id 4000000, size=169.
> [ 4658.670481] xc2028 3-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
> [ 4658.670485] xc2028 3-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
> [ 4658.670488] xc2028 3-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
> [ 4658.670491] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
> [ 4658.670493] xc2028 3-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
> [ 4658.670495] xc2028 3-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
> [ 4658.670499] xc2028 3-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
> [ 4658.670501] xc2028 3-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
> [ 4658.670503] xc2028 3-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
> [ 4658.670506] xc2028 3-0061: Reading firmware type FM (400), id 0, size=135.
> [ 4658.670508] xc2028 3-0061: Reading firmware type (0), id 10, size=161.
> [ 4658.670510] xc2028 3-0061: Reading firmware type MTS (4), id 10, size=169.
> [ 4658.670513] xc2028 3-0061: Reading firmware type (0), id 1000400000, size=169.
> [ 4658.670514] xc2028 3-0061: Reading firmware type (0), id c00400000, size=161.
> [ 4658.670516] xc2028 3-0061: Reading firmware type (0), id 800000, size=161.
> [ 4658.670518] xc2028 3-0061: Reading firmware type (0), id 8000, size=161.
> [ 4658.670519] xc2028 3-0061: Reading firmware type LCD (1000), id 8000, size=161.
> [ 4658.670521] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
> [ 4658.670525] xc2028 3-0061: Reading firmware type MTS (4), id 8000, size=169.
> [ 4658.670527] xc2028 3-0061: Reading firmware type (0), id b700, size=161.
> [ 4658.670529] xc2028 3-0061: Reading firmware type LCD (1000), id b700, size=161.
> [ 4658.670531] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
> [ 4658.670533] xc2028 3-0061: Reading firmware type (0), id 2000, size=161.
> [ 4658.670535] xc2028 3-0061: Reading firmware type MTS (4), id b700, size=169.
> [ 4658.670538] xc2028 3-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
> [ 4658.670540] xc2028 3-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
> [ 4658.670543] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
> [ 4658.670546] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
> [ 4658.670549] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
> [ 4658.670551] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
> [ 4658.670554] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
> [ 4658.670557] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
> [ 4658.670560] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
> [ 4658.670564] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
> [ 4658.670566] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
> [ 4658.670569] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
> [ 4658.670572] xc2028 3-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
> [ 4658.670576] xc2028 3-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
> [ 4658.670579] xc2028 3-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
> [ 4658.670584] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
> [ 4658.670587] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
> [ 4658.670589] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
> [ 4658.670592] xc2028 3-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
> [ 4658.670596] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
> [ 4658.670599] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
> [ 4658.670602] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
> [ 4658.670605] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
> [ 4658.670607] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
> [ 4658.670609] xc2028 3-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
> [ 4658.670613] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
> [ 4658.670616] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
> [ 4658.670618] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
> [ 4658.670621] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
> [ 4658.670623] xc2028 3-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
> [ 4658.670626] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
> [ 4658.670629] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
> [ 4658.670632] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
> [ 4658.670636] xc2028 3-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
> [ 4658.670639] xc2028 3-0061: Firmware files loaded.
> [ 4658.671468] em28xx #0: AC97 vendor ID = 0xffffffff
> [ 4658.677461] em28xx #0: AC97 features = 0x6a90
> [ 4658.681817] em28xx #0: Empia 202 AC97 audio processor detected
> [ 4658.844996] em28xx #0: v4l2 driver version 0.1.3
> [ 4658.850119] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4658.850123] xc2028 3-0061: generic_set_freq called
> [ 4658.850125] xc2028 3-0061: should set frequency 567250 kHz
> [ 4658.850127] xc2028 3-0061: check_firmware called
> [ 4658.850129] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
> [ 4658.883049] xc2028 3-0061: load_firmware called
> [ 4658.883053] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4658.883058] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4658.883063] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4660.005871] xc2028 3-0061: Load init1 firmware, if exists
> [ 4660.005875] xc2028 3-0061: load_firmware called
> [ 4660.005878] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
> [ 4660.005884] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
> [ 4660.005890] xc2028 3-0061: load_firmware called
> [ 4660.005891] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4660.005896] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4660.005900] xc2028 3-0061: load_firmware called
> [ 4660.005902] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
> [ 4660.005906] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
> [ 4660.005909] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
> [ 4660.005912] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
> [ 4660.032132] xc2028 3-0061: Trying to load scode 0
> [ 4660.032136] xc2028 3-0061: load_scode called
> [ 4660.032138] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
> [ 4660.032144] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
> [ 4660.032148] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4660.033125] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4660.034125] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4660.146418] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
> [ 4660.211039] em28xx #0: V4L2 video device registered as video0
> [ 4660.216790] em28xx #0: V4L2 VBI device registered as vbi0
> [ 4660.222176] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
> [ 4660.223495] usbcore: registered new interface driver em28xx
> [ 4660.232396] em28xx-audio.c: probing for em28xx Audio Vendor Class
> [ 4660.238494] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [ 4660.244484] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
> [ 4660.251461] Em28xx: Initialized (Em28xx Audio Extension) extension
> [ 4660.260023] WARNING: You are using an experimental version of the media stack.
> 	As the driver is backported to an older kernel, it doesn't offer
> 	enough quality for its usage in production.
> 	Use it with care.
> Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
> 	d259aec2578fe66c43ae89ef65735fa7b70fa948 [media] em28xx: add module parameter for selection of the preferred USB transfer type
> 	2c930ac7e1aa0c8181d5d283e4cb5de69b8121d5 [media] em28xx: improve USB endpoint logic, also use bulk transfers
> 	6b43cf6a235d564487fd10d73d8c377d4d6bafff [media] em28xx: set USB alternate settings for analog video bulk transfers properly
> [ 4660.454482] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
> [ 4660.521856] xc2028: Xcv2028/3028 init called!
> [ 4660.521862] xc2028 3-0061: attaching existing instance
> [ 4660.527023] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
> [ 4660.533123] em28xx #0: em28xx #0/2: xc3028 attached
> [ 4660.538023] DVB: registering new adapter (em28xx #0)
> [ 4660.543012] usb 1-6: DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
> [ 4660.553173] em28xx #0: Successfully loaded em28xx-dvb
> [ 4660.558234] Em28xx: Initialized (Em28xx dvb Extension) extension
> [ 4660.577432] WARNING: You are using an experimental version of the media stack.
> 	As the driver is backported to an older kernel, it doesn't offer
> 	enough quality for its usage in production.
> 	Use it with care.
> Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
> 	d259aec2578fe66c43ae89ef65735fa7b70fa948 [media] em28xx: add module parameter for selection of the preferred USB transfer type
> 	2c930ac7e1aa0c8181d5d283e4cb5de69b8121d5 [media] em28xx: improve USB endpoint logic, also use bulk transfers
> 	6b43cf6a235d564487fd10d73d8c377d4d6bafff [media] em28xx: set USB alternate settings for analog video bulk transfers properly
> [ 4660.670144] Registered IR keymap rc-hauppauge
> [ 4660.674637] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0/input19
> [ 4660.684089] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0
> [ 4660.697886] Em28xx: Initialized (Em28xx Input Extension) extension
> [ 4672.157416] xc2028 3-0061: xc2028_get_reg 0002 called
> [ 4672.181327] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
> [ 4672.187513] xc2028 3-0061: xc2028_signal called
> [ 4672.187662] xc2028 3-0061: xc2028_get_reg 0002 called
> [ 4672.212286] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
> [ 4672.218475] xc2028 3-0061: signal strength is 0
> [ 4672.285133] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4672.285137] xc2028 3-0061: generic_set_freq called
> [ 4672.285138] xc2028 3-0061: should set frequency 567250 kHz
> [ 4672.285139] xc2028 3-0061: check_firmware called
> [ 4672.285140] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
> [ 4672.324934] xc2028 3-0061: load_firmware called
> [ 4672.324938] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4672.324944] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4672.324949] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
> [ 4673.463009] xc2028 3-0061: Load init1 firmware, if exists
> [ 4673.463013] xc2028 3-0061: load_firmware called
> [ 4673.463016] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
> [ 4673.463023] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
> [ 4673.463028] xc2028 3-0061: load_firmware called
> [ 4673.463030] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4673.463034] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4673.463038] xc2028 3-0061: load_firmware called
> [ 4673.463040] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
> [ 4673.463045] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
> [ 4673.463048] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
> [ 4673.463051] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
> [ 4673.489121] xc2028 3-0061: Trying to load scode 0
> [ 4673.489125] xc2028 3-0061: load_scode called
> [ 4673.489127] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
> [ 4673.489133] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
> [ 4673.489138] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4673.490114] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4673.491118] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4673.603232] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
> [ 4673.735595] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4673.735599] xc2028 3-0061: generic_set_freq called
> [ 4673.735602] xc2028 3-0061: should set frequency 567250 kHz
> [ 4673.735604] xc2028 3-0061: check_firmware called
> [ 4673.735605] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
> [ 4673.775203] xc2028 3-0061: load_firmware called
> [ 4673.775208] xc2028 3-0061: seek_firmware called, want type=BASE MTS (5), id 0000000000000000.
> [ 4673.775213] xc2028 3-0061: Found firmware for type=BASE MTS (5), id 0000000000000000.
> [ 4673.775217] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
> [ 4674.905886] xc2028 3-0061: Load init1 firmware, if exists
> [ 4674.905890] xc2028 3-0061: load_firmware called
> [ 4674.905891] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4674.905895] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4674.905898] xc2028 3-0061: load_firmware called
> [ 4674.905899] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4674.905902] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
> [ 4674.905905] xc2028 3-0061: load_firmware called
> [ 4674.905906] xc2028 3-0061: seek_firmware called, want type=MTS (4), id 0000000000000100.
> [ 4674.905908] xc2028 3-0061: Found firmware for type=MTS (4), id 000000000000b700.
> [ 4674.905910] xc2028 3-0061: Loading firmware for type=MTS (4), id 000000000000b700.
> [ 4674.932253] xc2028 3-0061: Trying to load scode 0
> [ 4674.932256] xc2028 3-0061: load_scode called
> [ 4674.932258] xc2028 3-0061: seek_firmware called, want type=MTS SCODE (20000004), id 000000000000b700.
> [ 4674.932262] xc2028 3-0061: Found firmware for type=MTS SCODE (20000004), id 000000000000b700.
> [ 4674.932265] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
> [ 4674.946107] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4674.947106] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4674.948084] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4675.060498] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
> [ 4675.060566] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4675.060568] xc2028 3-0061: generic_set_freq called
> [ 4675.060569] xc2028 3-0061: should set frequency 67250 kHz
> [ 4675.060570] xc2028 3-0061: check_firmware called
> [ 4675.060572] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
> [ 4675.060575] xc2028 3-0061: BASE firmware not changed.
> [ 4675.060577] xc2028 3-0061: Std-specific firmware already loaded.
> [ 4675.060578] xc2028 3-0061: SCODE firmware already loaded.
> [ 4675.060579] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4675.062036] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4675.063047] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4675.175446] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
> [ 4675.178098] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4675.178102] xc2028 3-0061: generic_set_freq called
> [ 4675.178104] xc2028 3-0061: should set frequency 67250 kHz
> [ 4675.178106] xc2028 3-0061: check_firmware called
> [ 4675.178108] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
> [ 4675.178114] xc2028 3-0061: BASE firmware not changed.
> [ 4675.178115] xc2028 3-0061: Std-specific firmware already loaded.
> [ 4675.178117] xc2028 3-0061: SCODE firmware already loaded.
> [ 4675.178119] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4675.179213] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4675.180221] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4675.292362] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
> [ 4677.622717] xc2028 3-0061: xc2028_set_analog_freq called
> [ 4677.622722] xc2028 3-0061: generic_set_freq called
> [ 4677.622725] xc2028 3-0061: should set frequency 67250 kHz
> [ 4677.622726] xc2028 3-0061: check_firmware called
> [ 4677.622728] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
> [ 4677.622734] xc2028 3-0061: BASE firmware not changed.
> [ 4677.622736] xc2028 3-0061: Std-specific firmware already loaded.
> [ 4677.622738] xc2028 3-0061: SCODE firmware already loaded.
> [ 4677.622740] xc2028 3-0061: xc2028_get_reg 0004 called
> [ 4677.623940] xc2028 3-0061: xc2028_get_reg 0008 called
> [ 4677.624940] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
> [ 4677.737991] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
> [ 4677.798357] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
>
>



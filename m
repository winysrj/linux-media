Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab2J2UDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 16:03:53 -0400
Date: Mon, 29 Oct 2012 18:03:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
Message-ID: <20121029180348.7e7967aa@redhat.com>
In-Reply-To: <508EA1B8.3070304@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<20121028175752.447c39d5@redhat.com>
	<508EA1B8.3070304@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 17:33:12 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 28.10.2012 21:57, schrieb Mauro Carvalho Chehab:
> > Em Sun, 21 Oct 2012 19:52:05 +0300
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> This patch series adds support for USB bulk transfers to the em28xx driver.
> >>
> >> Patch 1 is a bugfix for the image data processing with non-interlaced devices (webcams)
> >> that should be considered for stable (see commit message).
> >>
> >> Patches 2-21 extend the driver to support USB bulk transfers.
> >> USB endpoint mapping had to be extended and is a bit tricky.
> >> It might still not be sufficient to handle ALL isoc/bulk endpoints of ALL existing devices,
> >> but it should work with the devices we have seen so far and (most important !) 
> >> preserves backwards compatibility to the current driver behavior.
> >> Isoc endpoints/transfers are preffered by default, patch 21 adds a module parameter to change this behavior.
> >>
> >> The last two patches are follow-up patches not really related to USB tranfers.
> >> Patch 22 reduces the code size in em28xx-video by merging the two URB data processing functions 
> >> and patch 23 enables VBI-support for em2840-devices.
> >>
> >> Please note that I could test the changes with an analog non-interlaced non-VBI device only !
> >> So further tests with DVB/interlaced/VBI devices are strongly recommended !
> > Did a quick test here with all applied, with analog TV with xawtv and tvtime. 
> > Didn't work.
> 
> Ok, thanks for testing.
> 
> > I'll need to postpone it, until I have more time to double check it and bisect.
> 
> I would also need further informations about the test you've made (did
> you enable bulk ?) and the device you used (supports VBI ?).

I used a WinTV HVR-950/980. Logs enclosed.

Regards,
Mauro


[ 8410.539167] media: Linux media interface: v0.10
[ 8410.554658] Linux video capture interface: v2.00
[ 8410.559272] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[ 8410.669117] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[ 8410.677360] em28xx: Audio Vendor Class interface 0 found
[ 8410.682652] em28xx: Video interface 0 found
[ 8410.686817] em28xx: DVB interface 0 found
[ 8410.690955] em28xx #0: chip ID is em2882/em2883
[ 8410.837123] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[ 8410.845092] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[ 8410.853063] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[ 8410.861019] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[ 8410.868974] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 8410.876926] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 8410.884901] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[ 8410.892874] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[ 8410.900838] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[ 8410.908791] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[ 8410.916743] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 8410.924695] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 8410.932646] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 8410.940596] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[ 8410.948549] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[ 8410.956502] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[ 8410.964459] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
[ 8410.970959] em28xx #0: EEPROM info:
[ 8410.974431] em28xx #0:	AC97 audio (5 sample rates)
[ 8410.979201] em28xx #0:	500mA max power
[ 8410.982948] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[ 8410.989277] em28xx #0: Identified as Hauppauge WinTV HVR 950 (card=16)
[ 8410.997388] tveeprom 3-0050: Hauppauge model 65201, rev A1C0, serial# 1917178
[ 8411.004502] tveeprom 3-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[ 8411.011522] tveeprom 3-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[ 8411.020646] tveeprom 3-0050: audio processor is None (idx 0)
[ 8411.026281] tveeprom 3-0050: has radio
[ 8411.092490] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[ 8411.097904] tvp5150 3-005c: tvp5150am1 detected.
[ 8411.132278] tuner 3-0061: Tuner -1 found with type(s) Radio TV.
[ 8411.151694] xc2028: Xcv2028/3028 init called!
[ 8411.151698] xc2028 3-0061: creating new instance
[ 8411.156310] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 8411.162389] xc2028 3-0061: xc2028_set_config called
[ 8411.162403] xc2028 3-0061: xc2028_set_analog_freq called
[ 8411.162405] xc2028 3-0061: generic_set_freq called
[ 8411.162458] xc2028 3-0061: should set frequency 567250 kHz
[ 8411.162460] xc2028 3-0061: check_firmware called
[ 8411.162835] em28xx #0: Config register raw data: 0xd0
[ 8411.168575] em28xx #0: AC97 vendor ID = 0xffffffff
[ 8411.173820] em28xx #0: AC97 features = 0x6a90
[ 8411.178202] em28xx #0: Empia 202 AC97 audio processor detected
[ 8411.213621] xc2028 3-0061: request_firmware_nowait(): OK
[ 8411.213624] xc2028 3-0061: load_all_firmwares called
[ 8411.213626] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[ 8411.223191] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
[ 8411.223198] xc2028 3-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
[ 8411.223204] xc2028 3-0061: Reading firmware type BASE FM (401), id 0, size=8562.
[ 8411.223209] xc2028 3-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
[ 8411.223214] xc2028 3-0061: Reading firmware type BASE (1), id 0, size=8706.
[ 8411.223219] xc2028 3-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
[ 8411.223222] xc2028 3-0061: Reading firmware type (0), id 100000007, size=161.
[ 8411.223224] xc2028 3-0061: Reading firmware type MTS (4), id 100000007, size=169.
[ 8411.223226] xc2028 3-0061: Reading firmware type (0), id 200000007, size=161.
[ 8411.223227] xc2028 3-0061: Reading firmware type MTS (4), id 200000007, size=169.
[ 8411.223229] xc2028 3-0061: Reading firmware type (0), id 400000007, size=161.
[ 8411.223231] xc2028 3-0061: Reading firmware type MTS (4), id 400000007, size=169.
[ 8411.223233] xc2028 3-0061: Reading firmware type (0), id 800000007, size=161.
[ 8411.223235] xc2028 3-0061: Reading firmware type MTS (4), id 800000007, size=169.
[ 8411.223237] xc2028 3-0061: Reading firmware type (0), id 3000000e0, size=161.
[ 8411.223239] xc2028 3-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
[ 8411.223241] xc2028 3-0061: Reading firmware type (0), id c000000e0, size=161.
[ 8411.223242] xc2028 3-0061: Reading firmware type MTS (4), id c000000e0, size=169.
[ 8411.223244] xc2028 3-0061: Reading firmware type (0), id 200000, size=161.
[ 8411.223246] xc2028 3-0061: Reading firmware type MTS (4), id 200000, size=169.
[ 8411.223248] xc2028 3-0061: Reading firmware type (0), id 4000000, size=161.
[ 8411.223249] xc2028 3-0061: Reading firmware type MTS (4), id 4000000, size=169.
[ 8411.223251] xc2028 3-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
[ 8411.223254] xc2028 3-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
[ 8411.223257] xc2028 3-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
[ 8411.223259] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
[ 8411.223262] xc2028 3-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
[ 8411.223264] xc2028 3-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
[ 8411.223266] xc2028 3-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
[ 8411.223269] xc2028 3-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
[ 8411.223271] xc2028 3-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
[ 8411.223273] xc2028 3-0061: Reading firmware type FM (400), id 0, size=135.
[ 8411.223275] xc2028 3-0061: Reading firmware type (0), id 10, size=161.
[ 8411.223277] xc2028 3-0061: Reading firmware type MTS (4), id 10, size=169.
[ 8411.223279] xc2028 3-0061: Reading firmware type (0), id 1000400000, size=169.
[ 8411.223281] xc2028 3-0061: Reading firmware type (0), id c00400000, size=161.
[ 8411.223282] xc2028 3-0061: Reading firmware type (0), id 800000, size=161.
[ 8411.223284] xc2028 3-0061: Reading firmware type (0), id 8000, size=161.
[ 8411.223286] xc2028 3-0061: Reading firmware type LCD (1000), id 8000, size=161.
[ 8411.223288] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
[ 8411.223290] xc2028 3-0061: Reading firmware type MTS (4), id 8000, size=169.
[ 8411.223292] xc2028 3-0061: Reading firmware type (0), id b700, size=161.
[ 8411.223294] xc2028 3-0061: Reading firmware type LCD (1000), id b700, size=161.
[ 8411.223295] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
[ 8411.223298] xc2028 3-0061: Reading firmware type (0), id 2000, size=161.
[ 8411.223300] xc2028 3-0061: Reading firmware type MTS (4), id b700, size=169.
[ 8411.223302] xc2028 3-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
[ 8411.223304] xc2028 3-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
[ 8411.223306] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
[ 8411.223309] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
[ 8411.223311] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
[ 8411.223313] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
[ 8411.223316] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
[ 8411.223319] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
[ 8411.223321] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
[ 8411.223325] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
[ 8411.223327] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
[ 8411.223330] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
[ 8411.223332] xc2028 3-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[ 8411.223336] xc2028 3-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
[ 8411.223339] xc2028 3-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[ 8411.223343] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
[ 8411.223346] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
[ 8411.223348] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
[ 8411.223351] xc2028 3-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[ 8411.223354] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
[ 8411.223358] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
[ 8411.223360] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
[ 8411.223363] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
[ 8411.223365] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
[ 8411.223367] xc2028 3-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[ 8411.223371] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
[ 8411.223374] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
[ 8411.223377] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
[ 8411.223379] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
[ 8411.223382] xc2028 3-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
[ 8411.223385] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
[ 8411.223388] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
[ 8411.223390] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
[ 8411.223393] xc2028 3-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
[ 8411.223396] xc2028 3-0061: Firmware files loaded.
[ 8411.346732] em28xx #0: v4l2 driver version 0.1.3
[ 8411.351857] xc2028 3-0061: xc2028_set_analog_freq called
[ 8411.351860] xc2028 3-0061: generic_set_freq called
[ 8411.351874] xc2028 3-0061: should set frequency 567250 kHz
[ 8411.351878] xc2028 3-0061: check_firmware called
[ 8411.351879] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
[ 8411.384856] xc2028 3-0061: load_firmware called
[ 8411.384860] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8411.384865] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8411.384869] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8412.464685] xc2028 3-0061: Load init1 firmware, if exists
[ 8412.464689] xc2028 3-0061: load_firmware called
[ 8412.464691] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[ 8412.464698] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[ 8412.464703] xc2028 3-0061: load_firmware called
[ 8412.464705] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8412.464709] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8412.464714] xc2028 3-0061: load_firmware called
[ 8412.464715] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
[ 8412.464720] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
[ 8412.464723] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
[ 8412.464726] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[ 8412.490792] xc2028 3-0061: Trying to load scode 0
[ 8412.490796] xc2028 3-0061: load_scode called
[ 8412.490798] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
[ 8412.490804] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
[ 8412.490808] xc2028 3-0061: xc2028_get_reg 0004 called
[ 8412.491762] xc2028 3-0061: xc2028_get_reg 0008 called
[ 8412.492886] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 8412.605248] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[ 8412.671096] em28xx #0: V4L2 video device registered as video0
[ 8412.676837] em28xx #0: V4L2 VBI device registered as vbi0
[ 8412.682216] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
[ 8412.684011] usbcore: registered new interface driver em28xx
[ 8412.699349] em28xx-audio.c: probing for em28xx Audio Vendor Class
[ 8412.705435] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 8412.711431] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[ 8412.718705] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 8412.738793] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[ 8412.907194] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
[ 8412.996749] xc2028: Xcv2028/3028 init called!
[ 8412.996753] xc2028 3-0061: attaching existing instance
[ 8413.001881] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[ 8413.007953] em28xx #0: em28xx #0/2: xc3028 attached
[ 8413.013015] DVB: registering new adapter (em28xx #0)
[ 8413.018017] usb 1-6: DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[ 8413.029903] em28xx #0: Successfully loaded em28xx-dvb
[ 8413.034970] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 8413.056144] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[ 8413.160007] Registered IR keymap rc-hauppauge
[ 8413.164522] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0/input11
[ 8413.174318] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0
[ 8413.183921] Em28xx: Initialized (Em28xx Input Extension) extension
[ 8440.697028] [drm] nouveau 0000:0f:00.0: Setting dpms mode 0 on vga encoder (output 0)
[ 8454.966006] xc2028 3-0061: xc2028_get_reg 0002 called
[ 8454.990113] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
[ 8454.996282] xc2028 3-0061: xc2028_signal called
[ 8454.997656] xc2028 3-0061: xc2028_get_reg 0002 called
[ 8455.021846] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
[ 8455.028012] xc2028 3-0061: signal strength is 0
[ 8455.102094] [drm] nouveau 0000:0f:00.0: Setting dpms mode 3 on vga encoder (output 0)
[ 8455.130131] [drm] nouveau 0000:0f:00.0: Setting dpms mode 0 on vga encoder (output 0)
[ 8455.137940] [drm] nouveau 0000:0f:00.0: Output VGA-1 is running on CRTC 0 using output A
[ 8455.249617] xc2028 3-0061: xc2028_set_analog_freq called
[ 8455.249621] xc2028 3-0061: generic_set_freq called
[ 8455.249623] xc2028 3-0061: should set frequency 567250 kHz
[ 8455.249624] xc2028 3-0061: check_firmware called
[ 8455.249625] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
[ 8455.289395] xc2028 3-0061: load_firmware called
[ 8455.289399] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8455.289402] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8455.289405] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 8456.364027] xc2028 3-0061: Load init1 firmware, if exists
[ 8456.364031] xc2028 3-0061: load_firmware called
[ 8456.364034] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[ 8456.364040] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[ 8456.364045] xc2028 3-0061: load_firmware called
[ 8456.364047] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8456.364051] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8456.364056] xc2028 3-0061: load_firmware called
[ 8456.364057] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
[ 8456.364062] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
[ 8456.364065] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
[ 8456.364067] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[ 8456.390174] xc2028 3-0061: Trying to load scode 0
[ 8456.390177] xc2028 3-0061: load_scode called
[ 8456.390180] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
[ 8456.390186] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
[ 8456.390190] xc2028 3-0061: xc2028_get_reg 0004 called
[ 8456.391165] xc2028 3-0061: xc2028_get_reg 0008 called
[ 8456.392133] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 8456.504746] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[ 8456.631140] xc2028 3-0061: xc2028_set_analog_freq called
[ 8456.631145] xc2028 3-0061: generic_set_freq called
[ 8456.631147] xc2028 3-0061: should set frequency 567250 kHz
[ 8456.631149] xc2028 3-0061: check_firmware called
[ 8456.631151] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[ 8456.670654] xc2028 3-0061: load_firmware called
[ 8456.670658] xc2028 3-0061: seek_firmware called, want type=BASE MTS (5), id 0000000000000000.
[ 8456.670663] xc2028 3-0061: Found firmware for type=BASE MTS (5), id 0000000000000000.
[ 8456.670666] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[ 8457.775318] xc2028 3-0061: Load init1 firmware, if exists
[ 8457.775321] xc2028 3-0061: load_firmware called
[ 8457.775323] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8457.775327] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8457.775330] xc2028 3-0061: load_firmware called
[ 8457.775331] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8457.775334] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[ 8457.775336] xc2028 3-0061: load_firmware called
[ 8457.775337] xc2028 3-0061: seek_firmware called, want type=MTS (4), id 0000000000000100.
[ 8457.775340] xc2028 3-0061: Found firmware for type=MTS (4), id 000000000000b700.
[ 8457.775342] xc2028 3-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[ 8457.801526] xc2028 3-0061: Trying to load scode 0
[ 8457.801529] xc2028 3-0061: load_scode called
[ 8457.801530] xc2028 3-0061: seek_firmware called, want type=MTS SCODE (20000004), id 000000000000b700.
[ 8457.801534] xc2028 3-0061: Found firmware for type=MTS SCODE (20000004), id 000000000000b700.
[ 8457.801536] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 8457.815266] xc2028 3-0061: xc2028_get_reg 0004 called
[ 8457.816264] xc2028 3-0061: xc2028_get_reg 0008 called
[ 8457.817263] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 8457.929985] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[ 8457.930049] xc2028 3-0061: xc2028_set_analog_freq called
[ 8457.930052] xc2028 3-0061: generic_set_freq called
[ 8457.930055] xc2028 3-0061: should set frequency 67250 kHz
[ 8457.930056] xc2028 3-0061: check_firmware called
[ 8457.930058] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[ 8457.930064] xc2028 3-0061: BASE firmware not changed.
[ 8457.930066] xc2028 3-0061: Std-specific firmware already loaded.
[ 8457.930067] xc2028 3-0061: SCODE firmware already loaded.
[ 8457.930070] xc2028 3-0061: xc2028_get_reg 0004 called
[ 8457.931458] xc2028 3-0061: xc2028_get_reg 0008 called
[ 8457.932474] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 8458.044925] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
[ 8458.047565] xc2028 3-0061: xc2028_set_analog_freq called
[ 8458.047569] xc2028 3-0061: generic_set_freq called
[ 8458.047571] xc2028 3-0061: should set frequency 67250 kHz
[ 8458.047573] xc2028 3-0061: check_firmware called
[ 8458.047575] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[ 8458.047581] xc2028 3-0061: BASE firmware not changed.
[ 8458.047583] xc2028 3-0061: Std-specific firmware already loaded.
[ 8458.047584] xc2028 3-0061: SCODE firmware already loaded.
[ 8458.047587] xc2028 3-0061: xc2028_get_reg 0004 called
[ 8458.048645] xc2028 3-0061: xc2028_get_reg 0008 called
[ 8458.049645] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[ 8458.161860] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
[ 8463.248599] xc2028 3-0061: xc2028_get_reg 0002 called
[ 8463.249590] xc2028 3-0061: xc2028_get_reg 0001 called
[ 8463.250577] xc2028 3-0061: AFC is 0 Hz
[ 8463.250581] xc2028 3-0061: xc2028_signal called
[ 8463.250583] xc2028 3-0061: xc2028_get_reg 0002 called
[ 8463.251561] xc2028 3-0061: xc2028_get_reg 0040 called
[ 8463.252561] xc2028 3-0061: signal strength is 20479

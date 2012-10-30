Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2J3DAm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 23:00:42 -0400
Date: Tue, 30 Oct 2012 01:00:12 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
Message-ID: <20121030010012.30e1d2de@redhat.com>
In-Reply-To: <508EF1CF.8090602@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<20121028175752.447c39d5@redhat.com>
	<508EA1B8.3070304@googlemail.com>
	<20121029180348.7e7967aa@redhat.com>
	<508EF1CF.8090602@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 23:14:55 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 29.10.2012 22:03, schrieb Mauro Carvalho Chehab:
> > Em Mon, 29 Oct 2012 17:33:12 +0200
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 28.10.2012 21:57, schrieb Mauro Carvalho Chehab:
> >>> Em Sun, 21 Oct 2012 19:52:05 +0300
> >>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >>>
> >>>> This patch series adds support for USB bulk transfers to the em28xx driver.
> >>>>
> >>>> Patch 1 is a bugfix for the image data processing with non-interlaced devices (webcams)
> >>>> that should be considered for stable (see commit message).
> >>>>
> >>>> Patches 2-21 extend the driver to support USB bulk transfers.
> >>>> USB endpoint mapping had to be extended and is a bit tricky.
> >>>> It might still not be sufficient to handle ALL isoc/bulk endpoints of ALL existing devices,
> >>>> but it should work with the devices we have seen so far and (most important !) 
> >>>> preserves backwards compatibility to the current driver behavior.
> >>>> Isoc endpoints/transfers are preffered by default, patch 21 adds a module parameter to change this behavior.
> >>>>
> >>>> The last two patches are follow-up patches not really related to USB tranfers.
> >>>> Patch 22 reduces the code size in em28xx-video by merging the two URB data processing functions 
> >>>> and patch 23 enables VBI-support for em2840-devices.
> >>>>
> >>>> Please note that I could test the changes with an analog non-interlaced non-VBI device only !
> >>>> So further tests with DVB/interlaced/VBI devices are strongly recommended !
> >>> Did a quick test here with all applied, with analog TV with xawtv and tvtime. 
> >>> Didn't work.
> >> Ok, thanks for testing.
> >>
> >>> I'll need to postpone it, until I have more time to double check it and bisect.
> >> I would also need further informations about the test you've made (did
> >> you enable bulk ?) and the device you used (supports VBI ?).
> > I used a WinTV HVR-950/980. Logs enclosed.
> >
> > Regards,
> > Mauro
> 
> Thanks.
> Did you load the module with prefer_bulk=1 ?

No.

> You just started xawtv/tvtime but got no picture, right ?

Yes. I tested also v4l2grab. No frames got returned there.

> 
> There is nothing unusual in the log, except...
> 
> ...
> > [ 8412.464698] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
> ...
> > [ 8412.464709] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
> ...

Those are normal. AFAIKT, only firmwares < version 2.0 had init broken into
INIT0 and INIT1.

> > [ 8412.490804] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.

This is ok, as another similar SCODE firmware got loaded.

> 
> and
> 
> ...
> > [ 8454.966006] xc2028 3-0061: xc2028_get_reg 0002 called
> > [ 8454.990113] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
> > [ 8454.996282] xc2028 3-0061: xc2028_signal called
> > [ 8454.997656] xc2028 3-0061: xc2028_get_reg 0002 called
> > [ 8455.021846] xc2028 3-0061: i2c input error: rc = -19 (should be 2)

Those are weird. In any case, as far as I remember, even if xc3028 is bad tuned,
em28xx should be outputing some data. I suspect, however, that those errors
maybe because the em28xx chip has died already.

> 
> Are these errors normal ?
> Are you sure the device is working properly without my patches ?

Yes. See below.

> 
> You could try to load the em28xx module with usb_debug=1.

I'll post it on a separate email.

> 
> Regards,
> Frank
> 
> 

dmesg without your patches:

[  729.964324] Linux video capture interface: v2.00
[  729.968927] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[  730.034451] em28xx: New device  WinTV HVR-980 @ 480 Mbps (2040:6513, interface 0, class 0)
[  730.042715] em28xx: Audio Vendor Class interface 0 found
[  730.048033] em28xx: Video interface 0 found
[  730.052225] em28xx: DVB interface 0 found
[  730.056320] em28xx #0: chip ID is em2882/em2883
[  730.202750] em28xx #0: i2c eeprom 00: 1a eb 67 95 40 20 13 65 d0 12 5c 03 82 1e 6a 18
[  730.210868] em28xx #0: i2c eeprom 10: 00 00 24 57 66 07 01 00 00 00 00 00 00 00 00 00
[  730.218848] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00 00 00 5b 1c 00 00
[  730.226821] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 01 01 00 00 00 00
[  730.234811] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  730.242808] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  730.250807] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 18 03 34 00 30 00
[  730.258803] em28xx #0: i2c eeprom 70: 32 00 38 00 34 00 34 00 39 00 30 00 31 00 38 00
[  730.266796] em28xx #0: i2c eeprom 80: 00 00 1e 03 57 00 69 00 6e 00 54 00 56 00 20 00
[  730.274765] em28xx #0: i2c eeprom 90: 48 00 56 00 52 00 2d 00 39 00 38 00 30 00 00 00
[  730.282760] em28xx #0: i2c eeprom a0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[  730.290778] em28xx #0: i2c eeprom b0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[  730.298778] em28xx #0: i2c eeprom c0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[  730.306775] em28xx #0: i2c eeprom d0: 84 12 00 00 05 50 1a 7f d4 78 23 b1 fe d0 18 85
[  730.314746] em28xx #0: i2c eeprom e0: ff 00 00 00 04 84 0a 00 01 01 20 77 00 40 fa 40
[  730.322743] em28xx #0: i2c eeprom f0: 1d f0 74 02 01 00 01 79 4f 00 00 00 00 00 00 00
[  730.330763] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x994b2bdd
[  730.337267] em28xx #0: EEPROM info:
[  730.340743] em28xx #0:	AC97 audio (5 sample rates)
[  730.345516] em28xx #0:	500mA max power
[  730.349252] em28xx #0:	Table at 0x24, strings=0x1e82, 0x186a, 0x0000
[  730.355582] em28xx #0: Identified as Hauppauge WinTV HVR 950 (card=16)
[  730.363404] tveeprom 3-0050: Hauppauge model 65201, rev A1C0, serial# 1917178
[  730.370572] tveeprom 3-0050: tuner model is Xceive XC3028 (idx 120, type 71)
[  730.377626] tveeprom 3-0050: TV standards PAL(B/G) PAL(I) PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xd4)
[  730.386774] tveeprom 3-0050: audio processor is None (idx 0)
[  730.392461] tveeprom 3-0050: has radio
[  730.443029] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[  730.448418] tvp5150 3-005c: tvp5150am1 detected.
[  730.471249] tuner 3-0061: Tuner -1 found with type(s) Radio TV.
[  730.479100] xc2028: Xcv2028/3028 init called!
[  730.479104] xc2028 3-0061: creating new instance
[  730.483747] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  730.489852] xc2028 3-0061: xc2028_set_config called
[  730.489862] xc2028 3-0061: xc2028_set_analog_freq called
[  730.489865] xc2028 3-0061: generic_set_freq called
[  730.489867] xc2028 3-0061: should set frequency 567250 kHz
[  730.489868] xc2028 3-0061: check_firmware called
[  730.490080] em28xx #0: Config register raw data: 0xd0
[  730.495854] em28xx #0: AC97 vendor ID = 0xffffffff
[  730.501095] em28xx #0: AC97 features = 0x6a90
[  730.505468] em28xx #0: Empia 202 AC97 audio processor detected
[  730.506556] xc2028 3-0061: request_firmware_nowait(): OK
[  730.506557] xc2028 3-0061: load_all_firmwares called
[  730.506558] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  730.506563] xc2028 3-0061: Reading firmware type BASE F8MHZ (3), id 0, size=8718.
[  730.506568] xc2028 3-0061: Reading firmware type BASE F8MHZ MTS (7), id 0, size=8712.
[  730.506572] xc2028 3-0061: Reading firmware type BASE FM (401), id 0, size=8562.
[  730.506576] xc2028 3-0061: Reading firmware type BASE FM INPUT1 (c01), id 0, size=8576.
[  730.506580] xc2028 3-0061: Reading firmware type BASE (1), id 0, size=8706.
[  730.506584] xc2028 3-0061: Reading firmware type BASE MTS (5), id 0, size=8682.
[  730.506586] xc2028 3-0061: Reading firmware type (0), id 100000007, size=161.
[  730.506587] xc2028 3-0061: Reading firmware type MTS (4), id 100000007, size=169.
[  730.506588] xc2028 3-0061: Reading firmware type (0), id 200000007, size=161.
[  730.506590] xc2028 3-0061: Reading firmware type MTS (4), id 200000007, size=169.
[  730.506591] xc2028 3-0061: Reading firmware type (0), id 400000007, size=161.
[  730.506592] xc2028 3-0061: Reading firmware type MTS (4), id 400000007, size=169.
[  730.506593] xc2028 3-0061: Reading firmware type (0), id 800000007, size=161.
[  730.506595] xc2028 3-0061: Reading firmware type MTS (4), id 800000007, size=169.
[  730.506596] xc2028 3-0061: Reading firmware type (0), id 3000000e0, size=161.
[  730.506597] xc2028 3-0061: Reading firmware type MTS (4), id 3000000e0, size=169.
[  730.506598] xc2028 3-0061: Reading firmware type (0), id c000000e0, size=161.
[  730.506600] xc2028 3-0061: Reading firmware type MTS (4), id c000000e0, size=169.
[  730.506601] xc2028 3-0061: Reading firmware type (0), id 200000, size=161.
[  730.506602] xc2028 3-0061: Reading firmware type MTS (4), id 200000, size=169.
[  730.506603] xc2028 3-0061: Reading firmware type (0), id 4000000, size=161.
[  730.506605] xc2028 3-0061: Reading firmware type MTS (4), id 4000000, size=169.
[  730.506606] xc2028 3-0061: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=149.
[  730.506608] xc2028 3-0061: Reading firmware type D2620 DTV6 QAM (68), id 0, size=149.
[  730.506610] xc2028 3-0061: Reading firmware type D2633 DTV6 QAM (70), id 0, size=149.
[  730.506611] xc2028 3-0061: Reading firmware type D2620 DTV7 (88), id 0, size=149.
[  730.506613] xc2028 3-0061: Reading firmware type D2633 DTV7 (90), id 0, size=149.
[  730.506615] xc2028 3-0061: Reading firmware type D2620 DTV78 (108), id 0, size=149.
[  730.506616] xc2028 3-0061: Reading firmware type D2633 DTV78 (110), id 0, size=149.
[  730.506618] xc2028 3-0061: Reading firmware type D2620 DTV8 (208), id 0, size=149.
[  730.506619] xc2028 3-0061: Reading firmware type D2633 DTV8 (210), id 0, size=149.
[  730.506620] xc2028 3-0061: Reading firmware type FM (400), id 0, size=135.
[  730.506622] xc2028 3-0061: Reading firmware type (0), id 10, size=161.
[  730.506623] xc2028 3-0061: Reading firmware type MTS (4), id 10, size=169.
[  730.506624] xc2028 3-0061: Reading firmware type (0), id 1000400000, size=169.
[  730.506626] xc2028 3-0061: Reading firmware type (0), id c00400000, size=161.
[  730.506627] xc2028 3-0061: Reading firmware type (0), id 800000, size=161.
[  730.506628] xc2028 3-0061: Reading firmware type (0), id 8000, size=161.
[  730.506629] xc2028 3-0061: Reading firmware type LCD (1000), id 8000, size=161.
[  730.506631] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id 8000, size=161.
[  730.506632] xc2028 3-0061: Reading firmware type MTS (4), id 8000, size=169.
[  730.506633] xc2028 3-0061: Reading firmware type (0), id b700, size=161.
[  730.506635] xc2028 3-0061: Reading firmware type LCD (1000), id b700, size=161.
[  730.506636] xc2028 3-0061: Reading firmware type LCD NOGD (3000), id b700, size=161.
[  730.506637] xc2028 3-0061: Reading firmware type (0), id 2000, size=161.
[  730.506639] xc2028 3-0061: Reading firmware type MTS (4), id b700, size=169.
[  730.506640] xc2028 3-0061: Reading firmware type MTS LCD (1004), id b700, size=169.
[  730.506642] xc2028 3-0061: Reading firmware type MTS LCD NOGD (3004), id b700, size=169.
[  730.506644] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, size=192.
[  730.506645] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, size=192.
[  730.506647] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, size=192.
[  730.506648] xc2028 3-0061: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, size=192.
[  730.506650] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (60210020), id 0, size=192.
[  730.506652] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, size=192.
[  730.506654] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080 (60410020), id 0, size=192.
[  730.506655] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, size=192.
[  730.506657] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id 8000, size=192.
[  730.506659] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, size=192.
[  730.506661] xc2028 3-0061: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[  730.506663] xc2028 3-0061: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (60023000), id 8000, size=192.
[  730.506666] xc2028 3-0061: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[  730.506667] xc2028 3-0061: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, size=192.
[  730.506669] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, size=192.
[  730.506670] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id f00000007, size=192.
[  730.506673] xc2028 3-0061: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[  730.506676] xc2028 3-0061: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020), id 0, size=192.
[  730.506677] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5640 (60000000), id 300000007, size=192.
[  730.506679] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5740 (60000000), id c00000007, size=192.
[  730.506680] xc2028 3-0061: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, size=192.
[  730.506682] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id c04c000f0, size=192.
[  730.506684] xc2028 3-0061: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[  730.506686] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, size=192.
[  730.506688] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id 200000, size=192.
[  730.506689] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6340 (60000000), id 200000, size=192.
[  730.506691] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id c044000e0, size=192.
[  730.506693] xc2028 3-0061: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (60090020), id 0, size=192.
[  730.506695] xc2028 3-0061: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000000e0, size=192.
[  730.506697] xc2028 3-0061: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id 3000000e0, size=192.
[  730.506699] xc2028 3-0061: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140 (60810020), id 0, size=192.
[  730.506700] xc2028 3-0061: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, size=192.
[  730.506701] xc2028 3-0061: Firmware files loaded.
[  730.678409] em28xx #0: v4l2 driver version 0.1.3
[  730.683501] xc2028 3-0061: xc2028_set_analog_freq called
[  730.683505] xc2028 3-0061: generic_set_freq called
[  730.683507] xc2028 3-0061: should set frequency 567250 kHz
[  730.683509] xc2028 3-0061: check_firmware called
[  730.683511] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
[  730.716365] xc2028 3-0061: load_firmware called
[  730.716369] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
[  730.716374] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[  730.716378] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[  731.861264] xc2028 3-0061: Load init1 firmware, if exists
[  731.861268] xc2028 3-0061: load_firmware called
[  731.861270] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[  731.861276] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[  731.861281] xc2028 3-0061: load_firmware called
[  731.861283] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[  731.861288] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[  731.861292] xc2028 3-0061: load_firmware called
[  731.861293] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
[  731.861298] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
[  731.861301] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
[  731.861304] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[  731.887500] xc2028 3-0061: Trying to load scode 0
[  731.887503] xc2028 3-0061: load_scode called
[  731.887505] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
[  731.887511] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
[  731.887515] xc2028 3-0061: xc2028_get_reg 0004 called
[  731.888497] xc2028 3-0061: xc2028_get_reg 0008 called
[  731.889496] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  732.003679] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[  732.068097] em28xx #0: V4L2 video device registered as video0
[  732.073835] em28xx #0: V4L2 VBI device registered as vbi0
[  732.079217] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
[  732.080529] usbcore: registered new interface driver em28xx
[  732.086501] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
[  732.090205] em28xx-audio.c: probing for em28xx Audio Vendor Class
[  732.096308] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  732.102295] em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab
[  732.109507] Em28xx: Initialized (Em28xx Audio Extension) extension
[  732.119372] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[  732.328571] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.
[  732.413454] xc2028: Xcv2028/3028 init called!
[  732.413458] xc2028 3-0061: attaching existing instance
[  732.418586] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  732.424659] em28xx #0: em28xx #0/2: xc3028 attached
[  732.429525] DVB: registering new adapter (em28xx #0)
[  732.434539] usb 1-6: DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[  732.447070] em28xx #0: Successfully loaded em28xx-dvb
[  732.452142] Em28xx: Initialized (Em28xx dvb Extension) extension
[  732.460597] WARNING: You are using an experimental version of the media stack.
	As the driver is backported to an older kernel, it doesn't offer
	enough quality for its usage in production.
	Use it with care.
Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
	8e216e50ddca0550ffd477ce27e843a506b3ae2e [media] it913x [BUG] Enable endpoint 3 on devices with HID interface
	684259353666b05a148cc70dfeed8e699daedbcd [media] Add Fujitsu Siemens Amilo Pi 2530 to gspca upside down table
	a66cd0b691c730ed751dbf66ffbd0edf18241790 [media] winbond-cir: do not rename input name
[  732.544391] Registered IR keymap rc-hauppauge
[  732.549270] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0/input10
[  732.558649] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-6/rc/rc0
[  732.568394] Em28xx: Initialized (Em28xx Input Extension) extension
[  769.673455] [drm] nouveau 0000:0f:00.0: Setting dpms mode 0 on vga encoder (output 0)
[  779.605647] fuse init (API version 7.20)
[  781.388965] [drm] nouveau 0000:0f:00.0: Setting dpms mode 3 on vga encoder (output 0)
[  781.417059] [drm] nouveau 0000:0f:00.0: Setting dpms mode 0 on vga encoder (output 0)
[  781.424867] [drm] nouveau 0000:0f:00.0: Output VGA-1 is running on CRTC 0 using output A
[  798.020393] xc2028 3-0061: xc2028_get_reg 0002 called
[  798.044399] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
[  798.050585] xc2028 3-0061: xc2028_signal called
[  798.050657] xc2028 3-0061: xc2028_get_reg 0002 called
[  798.075410] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
[  798.081607] xc2028 3-0061: signal strength is 0
[  798.139585] xc2028 3-0061: xc2028_set_analog_freq called
[  798.139589] xc2028 3-0061: generic_set_freq called
[  798.139592] xc2028 3-0061: should set frequency 567250 kHz
[  798.139594] xc2028 3-0061: check_firmware called
[  798.139595] xc2028 3-0061: checking firmware, user requested type=F8MHZ MTS (6), id 00000000000000ff, scode_tbl (0), scode_nr 0
[  798.178937] xc2028 3-0061: load_firmware called
[  798.178942] xc2028 3-0061: seek_firmware called, want type=BASE F8MHZ MTS (7), id 0000000000000000.
[  798.178948] xc2028 3-0061: Found firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[  798.178952] xc2028 3-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[  799.277736] xc2028 3-0061: Load init1 firmware, if exists
[  799.277740] xc2028 3-0061: load_firmware called
[  799.277742] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[  799.277749] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
[  799.277754] xc2028 3-0061: load_firmware called
[  799.277756] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[  799.277760] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[  799.277764] xc2028 3-0061: load_firmware called
[  799.277766] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS (6), id 00000000000000ff.
[  799.277770] xc2028 3-0061: Selecting best matching firmware (3 bits) for type=MTS (4), id 00000000000000ff:
[  799.277773] xc2028 3-0061: Found firmware for type=MTS (4), id 0000000100000007.
[  799.277776] xc2028 3-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[  799.303867] xc2028 3-0061: Trying to load scode 0
[  799.303870] xc2028 3-0061: load_scode called
[  799.303872] xc2028 3-0061: seek_firmware called, want type=F8MHZ MTS SCODE (20000006), id 0000000100000007.
[  799.303878] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.
[  799.303882] xc2028 3-0061: xc2028_get_reg 0004 called
[  799.304845] xc2028 3-0061: xc2028_get_reg 0008 called
[  799.305878] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  799.418259] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[  799.548720] xc2028 3-0061: xc2028_set_analog_freq called
[  799.548725] xc2028 3-0061: generic_set_freq called
[  799.548727] xc2028 3-0061: should set frequency 567250 kHz
[  799.548729] xc2028 3-0061: check_firmware called
[  799.548731] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[  799.588185] xc2028 3-0061: load_firmware called
[  799.588189] xc2028 3-0061: seek_firmware called, want type=BASE MTS (5), id 0000000000000000.
[  799.588194] xc2028 3-0061: Found firmware for type=BASE MTS (5), id 0000000000000000.
[  799.588198] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
[  800.719235] xc2028 3-0061: Load init1 firmware, if exists
[  800.719240] xc2028 3-0061: load_firmware called
[  800.719242] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[  800.719248] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[  800.719253] xc2028 3-0061: load_firmware called
[  800.719255] xc2028 3-0061: seek_firmware called, want type=BASE INIT1 MTS (4005), id 0000000000000000.
[  800.719259] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
[  800.719263] xc2028 3-0061: load_firmware called
[  800.719265] xc2028 3-0061: seek_firmware called, want type=MTS (4), id 0000000000000100.
[  800.719268] xc2028 3-0061: Found firmware for type=MTS (4), id 000000000000b700.
[  800.719271] xc2028 3-0061: Loading firmware for type=MTS (4), id 000000000000b700.
[  800.745365] xc2028 3-0061: Trying to load scode 0
[  800.745368] xc2028 3-0061: load_scode called
[  800.745370] xc2028 3-0061: seek_firmware called, want type=MTS SCODE (20000004), id 000000000000b700.
[  800.745375] xc2028 3-0061: Found firmware for type=MTS SCODE (20000004), id 000000000000b700.
[  800.745379] xc2028 3-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[  800.759139] xc2028 3-0061: xc2028_get_reg 0004 called
[  800.760235] xc2028 3-0061: xc2028_get_reg 0008 called
[  800.761212] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  800.873497] xc2028 3-0061: divisor= 00 00 8d d0 (freq=567.250)
[  800.873562] xc2028 3-0061: xc2028_set_analog_freq called
[  800.873565] xc2028 3-0061: generic_set_freq called
[  800.873568] xc2028 3-0061: should set frequency 67250 kHz
[  800.873569] xc2028 3-0061: check_firmware called
[  800.873571] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[  800.873577] xc2028 3-0061: BASE firmware not changed.
[  800.873578] xc2028 3-0061: Std-specific firmware already loaded.
[  800.873580] xc2028 3-0061: SCODE firmware already loaded.
[  800.873582] xc2028 3-0061: xc2028_get_reg 0004 called
[  800.874965] xc2028 3-0061: xc2028_get_reg 0008 called
[  800.876048] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  800.988426] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
[  800.991100] xc2028 3-0061: xc2028_set_analog_freq called
[  800.991103] xc2028 3-0061: generic_set_freq called
[  800.991105] xc2028 3-0061: should set frequency 67250 kHz
[  800.991107] xc2028 3-0061: check_firmware called
[  800.991108] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[  800.991114] xc2028 3-0061: BASE firmware not changed.
[  800.991116] xc2028 3-0061: Std-specific firmware already loaded.
[  800.991117] xc2028 3-0061: SCODE firmware already loaded.
[  800.991119] xc2028 3-0061: xc2028_get_reg 0004 called
[  800.992091] xc2028 3-0061: xc2028_get_reg 0008 called
[  800.993091] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  801.105365] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
[  806.140059] xc2028 3-0061: xc2028_get_reg 0002 called
[  806.141054] xc2028 3-0061: xc2028_get_reg 0001 called
[  806.142034] xc2028 3-0061: AFC is 0 Hz
[  806.142037] xc2028 3-0061: xc2028_signal called
[  806.142039] xc2028 3-0061: xc2028_get_reg 0002 called
[  806.143056] xc2028 3-0061: xc2028_get_reg 0040 called
[  806.144056] xc2028 3-0061: signal strength is 24575
[  808.181238] xc2028 3-0061: xc2028_set_analog_freq called
[  808.181242] xc2028 3-0061: generic_set_freq called
[  808.181245] xc2028 3-0061: should set frequency 67250 kHz
[  808.181247] xc2028 3-0061: check_firmware called
[  808.181249] xc2028 3-0061: checking firmware, user requested type=MTS (4), id 0000000000000100, scode_tbl (0), scode_nr 0
[  808.181254] xc2028 3-0061: BASE firmware not changed.
[  808.181256] xc2028 3-0061: Std-specific firmware already loaded.
[  808.181258] xc2028 3-0061: SCODE firmware already loaded.
[  808.181260] xc2028 3-0061: xc2028_get_reg 0004 called
[  808.182219] xc2028 3-0061: xc2028_get_reg 0008 called
[  808.183218] xc2028 3-0061: Device is Xceive 3028 version 1.0, firmware version 2.7
[  808.295515] xc2028 3-0061: divisor= 00 00 10 d0 (freq=67.250)
[  808.362457] xc2028 3-0061: Putting xc2028/3028 into poweroff mode.

It working perfectly with xawtv.

-- 
Regards,
Mauro

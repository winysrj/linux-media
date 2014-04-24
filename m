Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:32777 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDXTJg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Apr 2014 15:09:36 -0400
Received: by mail-ee0-f43.google.com with SMTP id e53so2178792eek.2
        for <linux-media@vger.kernel.org>; Thu, 24 Apr 2014 12:09:34 -0700 (PDT)
Date: Thu, 24 Apr 2014 21:09:30 +0200
From: Daniel Exner <dex@dragonslave.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: dex@dragonslave.de
Subject: Re: Terratec Cinergy T XS Firmware (Kernel 3.14.1)
Message-ID: <20140424210930.592ec21c@Mycroft>
In-Reply-To: <20140424082919.66f7eab1@samsung.com>
References: <535823E6.8020802@dragonslave.de>
	<CAGoCfizxAopbb4pEtGXVtSSuccqAfu7iqB8Oc2Lb6TOS=6QL8g@mail.gmail.com>
	<5358279C.5060108@dragonslave.de>
	<20140424082919.66f7eab1@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/yRkSuk4je5tNSbVraJ9R.hY"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/yRkSuk4je5tNSbVraJ9R.hY
Content-Type: multipart/mixed; boundary="MP_/mM7czX=bb3V4nGPNetj1cKC"

--MP_/mM7czX=bb3V4nGPNetj1cKC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Am Thu, 24 Apr 2014 08:29:19 -0300
schrieb Mauro Carvalho Chehab <m.chehab@samsung.com>:

> That doesn't seem to be a driver issue, but a badly extracted
> firmware. The firmware version should be 2.7. It the version doesn't
> match, that means that the firmware was not properly loaded.
>=20
> The driver checks if the firmware version loaded matches the version
> of the file, and prints warnings via dmesg.
>=20
> Are you sure that the md5sum of the firmware is=20
> 293dc5e915d9a0f74a368f8a2ce3cc10?
>=20

Yes, I am sure. The tuner-xc2028 module even reports FW Version 2.7.

What I suspect is, that this piece of hardware simply doesn't work with
that firmware version.=20

Find attached the whole output of dmesg after loading the module with
debug=3D1, pluggin in device and starting xawtv.

Greetings
Daniel
--=20
Daniel Exner
Public-Key: https://www.dragonslave.de/pub_key.asc

--MP_/mM7czX=bb3V4nGPNetj1cKC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=xc2028.txt

usb 3-2: new high-speed USB device number 3 using xhci_hcd
usb 3-2: New USB device found, idVendor=3D0ccd, idProduct=3D0043
usb 3-2: New USB device strings: Mfr=3D2, Product=3D1, SerialNumber=3D0
usb 3-2: Product: Cinergy T USB XS
usb 3-2: Manufacturer: TerraTec Electronic GmbH
em28xx: New device TerraTec Electronic GmbH Cinergy T USB XS @ 480 Mbps (0c=
cd:0043, interface 0, class 0)
em28xx: Video interface 0 found: isoc
em28xx: DVB interface 0 found: isoc
em28xx: chip ID is em2870
em2870 #0: EEPROM ID =3D 1a eb 67 95, EEPROM hash =3D 0x8d1e3bdf
em2870 #0: EEPROM info:
em2870 #0: 	No audio on board.
em2870 #0: 	500mA max power
em2870 #0: 	Table at offset 0x06, strings=3D0x246a, 0x348e, 0x0000
em2870 #0: Identified as Terratec Cinergy T XS (card=3D43)
em2870 #0:=20

em2870 #0: The support for this board weren't valid yet.
em2870 #0: Please send a report of having this working
em2870 #0: not to V4L mailing list (and/or to other addresses)

em2870 #0: analog set to isoc mode.
em2870 #0: dvb set to isoc mode.
usbcore: registered new interface driver em28xx
em2870 #0: Registering V4L2 extension
Chip ID is not zero. It is not a TEA5767
tuner 16-0060: Tuner -1 found with type(s) Radio TV.
xc2028: Xcv2028/3028 init called!
xc2028 16-0060: creating new instance
xc2028 16-0060: type set to XCeive xc2028/xc3028 tuner
xc2028 16-0060: xc2028_set_config called
xc2028 16-0060: xc2028_set_analog_freq called
xc2028 16-0060: generic_set_freq called
xc2028 16-0060: should set frequency 567250 kHz
xc2028 16-0060: check_firmware called
xc2028 16-0060: xc2028_set_analog_freq called
xc2028 16-0060: generic_set_freq called
xc2028 16-0060: should set frequency 567250 kHz
xc2028 16-0060: check_firmware called
xc2028 16-0060: request_firmware_nowait(): OK
xc2028 16-0060: load_all_firmwares called
xc2028 16-0060: Loading 80 firmware images from xc3028-v27.fw, type: xc2028=
 firmware, ver 2.7
xc2028 16-0060: Reading firmware type BASE F8MHZ (3), id 0, size=3D8718.
xc2028 16-0060: Reading firmware type BASE F8MHZ MTS (7), id 0, size=3D8712.
xc2028 16-0060: Reading firmware type BASE FM (401), id 0, size=3D8562.
xc2028 16-0060: Reading firmware type BASE FM INPUT1 (c01), id 0, size=3D85=
76.
xc2028 16-0060: Reading firmware type BASE (1), id 0, size=3D8706.
xc2028 16-0060: Reading firmware type BASE MTS (5), id 0, size=3D8682.
xc2028 16-0060: Reading firmware type (0), id 100000007, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 100000007, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 200000007, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 200000007, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 400000007, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 400000007, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 800000007, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 800000007, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 3000000e0, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 3000000e0, size=3D169.
xc2028 16-0060: Reading firmware type (0), id c000000e0, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id c000000e0, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 200000, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 200000, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 4000000, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 4000000, size=3D169.
xc2028 16-0060: Reading firmware type D2633 DTV6 ATSC (10030), id 0, size=
=3D149.
xc2028 16-0060: Reading firmware type D2620 DTV6 QAM (68), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2633 DTV6 QAM (70), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2620 DTV7 (88), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2633 DTV7 (90), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2620 DTV78 (108), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2633 DTV78 (110), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2620 DTV8 (208), id 0, size=3D149.
xc2028 16-0060: Reading firmware type D2633 DTV8 (210), id 0, size=3D149.
xc2028 16-0060: Reading firmware type FM (400), id 0, size=3D135.
xc2028 16-0060: Reading firmware type (0), id 10, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 10, size=3D169.
xc2028 16-0060: Reading firmware type (0), id 1000400000, size=3D169.
xc2028 16-0060: Reading firmware type (0), id c00400000, size=3D161.
xc2028 16-0060: Reading firmware type (0), id 800000, size=3D161.
xc2028 16-0060: Reading firmware type (0), id 8000, size=3D161.
xc2028 16-0060: Reading firmware type LCD (1000), id 8000, size=3D161.
xc2028 16-0060: Reading firmware type LCD NOGD (3000), id 8000, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id 8000, size=3D169.
xc2028 16-0060: Reading firmware type (0), id b700, size=3D161.
xc2028 16-0060: Reading firmware type LCD (1000), id b700, size=3D161.
xc2028 16-0060: Reading firmware type LCD NOGD (3000), id b700, size=3D161.
xc2028 16-0060: Reading firmware type (0), id 2000, size=3D161.
xc2028 16-0060: Reading firmware type MTS (4), id b700, size=3D169.
xc2028 16-0060: Reading firmware type MTS LCD (1004), id b700, size=3D169.
xc2028 16-0060: Reading firmware type MTS LCD NOGD (3004), id b700, size=3D=
169.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_3280 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_3300 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_3440 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_3460 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type DTV6 ATSC OREN36 SCODE HAS_IF_3800 (6=
0210020), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_4000 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type DTV6 ATSC TOYOTA388 SCODE HAS_IF_4080=
 (60410020), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_4200 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_4320 (60008000), id=
 8000, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_4450 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type MTS LCD NOGD MONO IF SCODE HAS_IF_450=
0 (6002b004), id b700, size=3D192.
xc2028 16-0060: Reading firmware type LCD NOGD IF SCODE HAS_IF_4600 (600230=
00), id 8000, size=3D192.
xc2028 16-0060: Reading firmware type DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 S=
CODE HAS_IF_4760 (620003e0), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_4940 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_5260 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_5320 (60008000), id=
 f00000007, size=3D192.
xc2028 16-0060: Reading firmware type DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE =
HAS_IF_5400 (65000380), id 0, size=3D192.
xc2028 16-0060: Reading firmware type DTV6 ATSC OREN538 SCODE HAS_IF_5580 (=
60110020), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_5640 (60000000), id 3000=
00007, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_5740 (60000000), id c000=
00007, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_5900 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_6000 (60008000), id=
 c04c000f0, size=3D192.
xc2028 16-0060: Reading firmware type DTV6 QAM ATSC LG60 F6MHZ SCODE HAS_IF=
_6200 (68050060), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_6240 (60000000), id 10, =
size=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_6320 (60008000), id=
 200000, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_6340 (60000000), id 2000=
00, size=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_6500 (60008000), id=
 c044000e0, size=3D192.
xc2028 16-0060: Reading firmware type DTV6 ATSC ATI638 SCODE HAS_IF_6580 (6=
0090020), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_6600 (60000000), id 3000=
000e0, size=3D192.
xc2028 16-0060: Reading firmware type MONO SCODE HAS_IF_6680 (60008000), id=
 3000000e0, size=3D192.
xc2028 16-0060: Reading firmware type DTV6 ATSC TOYOTA794 SCODE HAS_IF_8140=
 (60810020), id 0, size=3D192.
xc2028 16-0060: Reading firmware type SCODE HAS_IF_8200 (60000000), id 0, s=
ize=3D192.
xc2028 16-0060: Firmware files loaded.
em2870 #0: V4L2 video device registered as video1
xc2028 16-0060: Putting xc2028/3028 into poweroff mode.
em2870 #0: V4L2 extension successfully initialized
em28xx: Registered (Em28xx v4l2 Extension) extension
xc2028 16-0060: xc2028_signal called
xc2028 16-0060: xc2028_set_analog_freq called
xc2028 16-0060: generic_set_freq called
xc2028 16-0060: should set frequency 567250 kHz
xc2028 16-0060: check_firmware called
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: Retrying firmware load
xc2028 16-0060: checking firmware, user requested type=3DF8MHZ (2), id 0000=
0000000000ff, scode_tbl (0), scode_nr 0
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE F8MHZ (3), id 000000=
0000000000.
xc2028 16-0060: Found firmware for type=3DBASE F8MHZ (3), id 00000000000000=
00.
xc2028 16-0060: Loading firmware for type=3DBASE F8MHZ (3), id 000000000000=
0000.
xc2028 16-0060: Load init1 firmware, if exists
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 F8MHZ (4003), =
id 0000000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 F8MHZ (4003), id =
0000000000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DBASE INIT1 (4001), id 000=
0000000000000.
xc2028 16-0060: Can't find firmware for type=3DBASE INIT1 (4001), id 000000=
0000000000.
xc2028 16-0060: load_firmware called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ (2), id 00000000000=
000ff.
xc2028 16-0060: Selecting best matching firmware (3 bits) for type=3D(0), i=
d 00000000000000ff:
xc2028 16-0060: Found firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Loading firmware for type=3D(0), id 0000000100000007.
xc2028 16-0060: Trying to load scode 0
xc2028 16-0060: load_scode called
xc2028 16-0060: seek_firmware called, want type=3DF8MHZ SCODE (20000002), i=
d 0000000100000007.
xc2028 16-0060: Found firmware for type=3DSCODE (20000000), id 0000000f0000=
0007.
xc2028 16-0060: Loading SCODE for type=3DMONO SCODE HAS_IF_5320 (60008000),=
 id 0000000f00000007.
xc2028 16-0060: xc2028_get_reg 0004 called
xc2028 16-0060: xc2028_get_reg 0008 called
xc2028 16-0060: Device is Xceive 34584 version 8.7, firmware version 1.8
xc2028 16-0060: Incorrect readback of firmware version.
xc2028 16-0060: divisor=3D 00 00 8d d0 (freq=3D567.250)
xc2028 16-0060: xc2028_set_analog_freq called
xc2028 16-0060: generic_set_freq called
xc2028 16-0060: should set frequency 567250 kHz
xc2028 16-0060: check_firmware called
xc2028 16-0060: xc2028_get_frequency called
xc2028 16-0060: xc2028_set_analog_freq called
xc2028 16-0060: generic_set_freq called
xc2028 16-0060: should set frequency 567250 kHz
xc2028 16-0060: check_firmware called

--MP_/mM7czX=bb3V4nGPNetj1cKC--

--Sig_/yRkSuk4je5tNSbVraJ9R.hY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBCgAGBQJTWWFqAAoJEJzUMd6kHcEpTxUP/j1Ng0qd3D3kt2vxw/R27/3V
az+hhvxGrUgpW56dszaJewIMFZ9yh7z3Ip4KTvNoy22MbYpDGT527733T7LVUUp9
auexzdnvOO9iPerKeeWXPJag17UUlH2kGtMDNMXF44L2AUW3bpDhv8bF5srBVJGi
BuIeG5acRmutt+ieqG1Nm11mqDvMiNWm70V1Tiyw+aIYL8e79XmwWXqTTNeJSNFL
KpWAI1CfxHpSKiDw385jhNnwOyHPlR5mitUR4/fiheHsjAJ/r5AIWihtJqEL511n
q2PGqOrfV83zyQMmoT6mTSBR/E4Ta57CPD/55F9yqAw0LkTRf9jgXiLgpfN7I08h
7dVkhM/QKzhnY6va7rjo3cwn7T/ogUCx+dUIEtrGuuoFDIWwpMiVc1f7O3yG+LAW
U23ndqQayUjLO9xiEZccsBXyQKn6eesGmEVy20AJYs6Xlvsj1aMYaE5COJuKz0Ey
qO+n/pKFYbsfqhjQzxTiPhiIQ0N4XznCTNz0IJWSxqFcWURUE0kn+sk8qm0Ky8Gg
ZmMc5jBhTPIhREoR2X6we57ed9c1ag0t9VaFMxqH7aR1wIC/k/z2RvshWko1aBaE
khX85lTH32nYA3KTczAMoIUEC1autpyFT5Keci4mqN35rWfC7slhc8Qb6MPbHKne
V3YH0AyDFVan3et8GoAJ
=7nW4
-----END PGP SIGNATURE-----

--Sig_/yRkSuk4je5tNSbVraJ9R.hY--

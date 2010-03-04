Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57715 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab0CDKBb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 05:01:31 -0500
Received: by fxm19 with SMTP id 19so2609680fxm.21
        for <linux-media@vger.kernel.org>; Thu, 04 Mar 2010 02:01:29 -0800 (PST)
Message-ID: <4B8F84F7.4040005@edagames.com>
Date: Thu, 04 Mar 2010 11:01:27 +0100
From: =?UTF-8?B?SsOpcsOpbXkgTGFs?= <jerry@edagames.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cinergy Hybrid T USB XS (2882) 0ccd:005e
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig97E0EBAED57431CEAB6E4893"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig97E0EBAED57431CEAB6E4893
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
using kernel 2.6.33, dvb is not working (no /dev/dvb)
I'm willing to help and can quickly test patches on em28xx module.
Thanks for any advice.


Regards,
J=C3=A9r=C3=A9my.

[ 1820.020978] usb 1-2: New USB device found, idVendor=3D0ccd, idProduct=3D=
005e
[ 1820.020985] usb 1-2: New USB device strings: Mfr=3D3, Product=3D1, Ser=
ialNumber=3D2
[ 1820.020991] usb 1-2: Product: Cinergy Hybrid T USB XS (2882)
[ 1820.020996] usb 1-2: Manufacturer: TerraTec Electronic GmbH
[ 1820.021026] usb 1-2: SerialNumber: 070802004968
[ 1820.053960] em28xx: New device TerraTec Electronic GmbH Cinergy Hybrid=
 T USB XS (2882) @ 480 Mbps (0ccd:005e, interface 0, class 0)
[ 1820.054059] em28xx #0: chip ID is em2882/em2883
[ 1820.229575] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 5e 00 d0 12 5c=
 03 9e 40 de 1c
[ 1820.229595] em28xx #0: i2c eeprom 10: 6a 34 27 57 46 07 01 00 00 00 00=
 00 00 00 00 00
[ 1820.229613] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14=
 00 5b 1e 00 00
[ 1820.229630] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00=
 00 00 00 00 00
[ 1820.229648] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00
[ 1820.229664] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00
[ 1820.229681] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 34=
 03 54 00 65 00
[ 1820.229698] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63=
 00 20 00 45 00
[ 1820.229716] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f=
 00 6e 00 69 00
[ 1820.229733] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48=
 00 00 00 40 03
[ 1820.229750] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00 67=
 00 79 00 20 00
[ 1820.229767] em28xx #0: i2c eeprom b0: 48 00 79 00 62 00 72 00 69 00 64=
 00 20 00 54 00
[ 1820.229784] em28xx #0: i2c eeprom c0: 20 00 55 00 53 00 42 00 20 00 58=
 00 53 00 20 00
[ 1820.229801] em28xx #0: i2c eeprom d0: 28 00 32 00 38 00 38 00 32 00 29=
 00 00 00 1c 03
[ 1820.229818] em28xx #0: i2c eeprom e0: 30 00 37 00 30 00 38 00 30 00 32=
 00 30 00 30 00
[ 1820.229835] em28xx #0: i2c eeprom f0: 34 00 39 00 36 00 38 00 00 00 00=
 00 00 00 dc 00
[ 1820.229855] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0xde6f=
68be
[ 1820.229859] em28xx #0: EEPROM info:
[ 1820.229862] em28xx #0:	AC97 audio (5 sample rates)
[ 1820.229866] em28xx #0:	500mA max power
[ 1820.229870] em28xx #0:	Table at 0x27, strings=3D0x409e, 0x1cde, 0x346a=

[ 1820.230584] em28xx #0: Identified as Terratec Hybrid XS (em2882) (card=
=3D55)
[ 1820.235611] tvp5150 2-005c: chip found @ 0xb8 (em28xx #0)
[ 1820.241539] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
[ 1820.241682] xc2028 2-0061: creating new instance
[ 1820.241687] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[ 1820.241700] usb 1-2: firmware: requesting xc3028-v27.fw
[ 1820.248483] xc2028 2-0061: Loading 80 firmware images from xc3028-v27.=
fw, type: xc2028 firmware, ver 2.7
[ 1820.296074] xc2028 2-0061: Loading firmware for type=3DBASE MTS (5), i=
d 0000000000000000.
[ 1821.336717] xc2028 2-0061: Loading firmware for type=3DMTS (4), id 000=
000000000b700.
[ 1821.353577] xc2028 2-0061: Loading SCODE for type=3DMTS LCD NOGD MONO =
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[ 1821.536445] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:0=
0:1d.7/usb1/1-2/input/input14
[ 1821.537408] em28xx #0: Config register raw data: 0xd0
[ 1821.538157] em28xx #0: AC97 vendor ID =3D 0xffffffff
[ 1821.538521] em28xx #0: AC97 features =3D 0x6a90
[ 1821.538525] em28xx #0: Empia 202 AC97 audio processor detected
[ 1821.668567] tvp5150 2-005c: tvp5150am1 detected.
[ 1821.772948] em28xx #0: v4l2 driver version 0.1.2
[ 1821.859523] em28xx #0: V4L2 video device registered as video0
[ 1821.859529] em28xx #0: V4L2 VBI device registered as vbi0
[ 1821.876848] usbcore: registered new interface driver em28xx
[ 1821.876855] em28xx driver loaded
[ 1821.883693] em28xx-audio.c: probing for em28x1 non standard usbaudio
[ 1821.883699] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 1821.884343] Em28xx: Initialized (Em28xx Audio Extension) extension
[ 1821.948647] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1821.964394] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1821.980520] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1821.986999] Em28xx: Initialized () extension
[ 1821.996529] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1821.996536] tvp5150 2-005c: *** unknown tvp3e04 chip detected.
[ 1821.996540] tvp5150 2-005c: *** Rom ver is 12.0
[ 1822.056515] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1822.076390] tvp5150 2-005c: i2c i/o error: rc =3D=3D -19 (should be 1)=

[ 1822.252526] tvp5150 2-005c: tvp5150am1 detected.


--------------enig97E0EBAED57431CEAB6E4893
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuPhPcACgkQDMRIEQdBQdynFwCfUvj3Vi7+QxTg5/pppBlgTKMq
X3gAoJQm5wmFyjZDLEbU5ldHIP5gkK2r
=GijI
-----END PGP SIGNATURE-----

--------------enig97E0EBAED57431CEAB6E4893--

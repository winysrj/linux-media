Return-path: <mchehab@pedra>
Received: from smtp.domeneshop.no ([194.63.248.54]:56231 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0JQNPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 09:15:54 -0400
Received: from aannecy-158-1-96-38.w90-52.abo.wanadoo.fr ([90.52.199.38])
	by smtp.domeneshop.no with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <pmb@fa2k.net>)
	id 1P7SwG-0005C8-Bt
	for linux-media@vger.kernel.org; Sun, 17 Oct 2010 15:06:12 +0200
Message-ID: <4CBAF4BD.20906@fa2k.net>
Date: Sun, 17 Oct 2010 15:06:05 +0200
From: =?ISO-8859-1?Q?Marius_Bj=F8rnstad?= <pmb@fa2k.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx in v4l-dvb destroyed my USB TV card
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig91BCD81B0F1D0292BB7EE450"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig91BCD81B0F1D0292BB7EE450
Content-Type: multipart/mixed;
 boundary="------------090808070105000402070909"

This is a multi-part message in MIME format.
--------------090808070105000402070909
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

A problem with the em28xx driver was brought up in June by Thorsten
Hirsch: http://www.spinics.net/lists/linux-media/msg20588.html . I also
have a "TerraTec Cinergy Hybrid T USB XS". When I used my device with
Linux, it would take a long time to be recognised by the OS, and this
would get worse. At this point, the device is not recognised, and almost
completely dead.

When I plug it in, I get errors like
---------------------------------------------
Oct 17 14:34:55 muon kernel: [ 7111.324875] hub 1-1:1.0: unable to
enumerate USB device on port 2
Oct 17 14:34:55 muon kernel: [ 7111.580618] hub 1-1:1.0: unable to
enumerate USB device on port 2
Oct 17 14:34:55 muon kernel: [ 7111.840481] hub 1-1:1.0: unable to
enumerate USB device on port 2
Oct 17 14:34:55 muon kernel: [ 7112.092358] hub 1-1:1.0: unable to
enumerate USB device on port 2
----------------------------------------------
and these keep coming until the device is removed. The device is also
not available in windows.

I have attached an excerpt from /var/log/messages , when the device was
connected, before it was destroyed. Here is some more contextual info:

uname -a:
Linux muon 2.6.32-24-generic #41-Ubuntu SMP Thu Aug 19 01:38:40 UTC 2010
x86_64 GNU/Linux

Driver: v4l-dvb. The install process from linuxtv.org leaves me
oblivious of the version number, but I used the most recent version as
of a few weeks ago.

Firmware: I have "linux-firmware-nonfree" from Ubuntu installed, but I
don't know if v4l-dvb replaces the firmware file.


I have a different version of the stick than what was mentioned in the
above link: USB ID 0ccd:005e. In the post at
http://ubuntuforums.org/showpost.php?p=3D7832485&postcount=3D3 , it is
stated that this version requires a different firmware: . In my kernel
log it says that
xc3028-v27.fw is loaded, I think this could be the problem.

I was hoping someone could provide insight, or an explanation, and maybe
(but not likely) a way to resurrect my device. I hope that someone could
either 1) refute this problem with their own anecdotal evidence, or 2)
actually remove support for 0ccd:005e from the driver, to prevent this
from happening to anyone else.

I know this is a bit off topic, but if anyone could recommend a cheap
replacement DVB-C card for a laptop, that definitely works with Linux,
that would be great.

Many thanks,
Marius

--------------090808070105000402070909
Content-Type: text/plain;
 name="terratec.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="terratec.txt"

Oct 10 12:14:07 muon kernel: [  243.458871] usb 1-1.2: new high speed USB=
 device using ehci_hcd and address 10
Oct 10 12:14:07 muon kernel: [  243.592097] usb 1-1.2: configuration #1 c=
hosen from 1 choice
Oct 10 12:14:07 muon kernel: [  243.665278] IR NEC protocol handler initi=
alized
Oct 10 12:14:07 muon kernel: [  243.672512] IR RC5(x) protocol handler in=
itialized
Oct 10 12:14:07 muon kernel: [  243.675282] IR RC6 protocol handler initi=
alized
Oct 10 12:14:07 muon kernel: [  243.694576] em28xx: New device TerraTec E=
lectronic GmbH Cinergy Hybrid T USB XS (2882) @ 480 Mbps (0ccd:005e, inte=
rface 0, class 0)
Oct 10 12:14:07 muon kernel: [  243.694680] em28xx #0: chip ID is em2882/=
em2883
Oct 10 12:14:07 muon kernel: [  243.695521] IR JVC protocol handler initi=
alized
Oct 10 12:14:07 muon kernel: [  243.698768] IR Sony protocol handler init=
ialized
Oct 10 12:14:07 muon kernel: [  243.898418] em28xx #0: i2c eeprom 00: 1a =
eb 67 95 cd 0c 5e 00 d0 12 5c 03 9e 40 de 1c
Oct 10 12:14:07 muon kernel: [  243.898430] em28xx #0: i2c eeprom 10: 6a =
34 27 57 46 07 01 00 00 00 00 00 00 00 00 00
Oct 10 12:14:07 muon kernel: [  243.898441] em28xx #0: i2c eeprom 20: 46 =
00 01 00 f0 10 31 00 b8 00 14 00 5b 1e 00 00
Oct 10 12:14:07 muon kernel: [  243.898451] em28xx #0: i2c eeprom 30: 00 =
00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
Oct 10 12:14:07 muon kernel: [  243.898461] em28xx #0: i2c eeprom 40: 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 10 12:14:07 muon kernel: [  243.898470] em28xx #0: i2c eeprom 50: 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Oct 10 12:14:07 muon kernel: [  243.898480] em28xx #0: i2c eeprom 60: 00 =
00 00 00 00 00 00 00 00 00 34 03 54 00 65 00
Oct 10 12:14:07 muon kernel: [  243.898490] em28xx #0: i2c eeprom 70: 72 =
00 72 00 61 00 54 00 65 00 63 00 20 00 45 00
Oct 10 12:14:07 muon kernel: [  243.898500] em28xx #0: i2c eeprom 80: 6c =
00 65 00 63 00 74 00 72 00 6f 00 6e 00 69 00
Oct 10 12:14:07 muon kernel: [  243.898510] em28xx #0: i2c eeprom 90: 63 =
00 20 00 47 00 6d 00 62 00 48 00 00 00 40 03
Oct 10 12:14:07 muon kernel: [  243.898520] em28xx #0: i2c eeprom a0: 43 =
00 69 00 6e 00 65 00 72 00 67 00 79 00 20 00
Oct 10 12:14:07 muon kernel: [  243.898530] em28xx #0: i2c eeprom b0: 48 =
00 79 00 62 00 72 00 69 00 64 00 20 00 54 00
Oct 10 12:14:07 muon kernel: [  243.898539] em28xx #0: i2c eeprom c0: 20 =
00 55 00 53 00 42 00 20 00 58 00 53 00 20 00
Oct 10 12:14:07 muon kernel: [  243.898549] em28xx #0: i2c eeprom d0: 28 =
00 32 00 38 00 38 00 32 00 29 00 00 00 1c 03
Oct 10 12:14:07 muon kernel: [  243.898559] em28xx #0: i2c eeprom e0: 30 =
00 36 00 31 00 31 00 30 00 32 00 30 00 30 00
Oct 10 12:14:07 muon kernel: [  243.898569] em28xx #0: i2c eeprom f0: 33 =
00 34 00 35 00 34 00 00 00 00 00 00 00 00 00
Oct 10 12:14:07 muon kernel: [  243.898580] em28xx #0: EEPROM ID=3D 0x956=
7eb1a, EEPROM hash =3D 0x3513bdbe
Oct 10 12:14:07 muon kernel: [  243.898583] em28xx #0: EEPROM info:
Oct 10 12:14:07 muon kernel: [  243.898585] em28xx #0:	AC97 audio (5 samp=
le rates)
Oct 10 12:14:07 muon kernel: [  243.898586] em28xx #0:	500mA max power
Oct 10 12:14:07 muon kernel: [  243.898589] em28xx #0:	Table at 0x27, str=
ings=3D0x409e, 0x1cde, 0x346a
Oct 10 12:14:07 muon kernel: [  243.899748] em28xx #0: Identified as Terr=
atec Hybrid XS (em2882) (card=3D55)
Oct 10 12:14:07 muon kernel: [  243.904977] tvp5150 8-005c: chip found @ =
0xb8 (em28xx #0)
Oct 10 12:14:07 muon kernel: [  243.914266] tuner 8-0061: chip found @ 0x=
c2 (em28xx #0)
Oct 10 12:14:07 muon kernel: [  243.938302] xc2028 8-0061: creating new i=
nstance
Oct 10 12:14:07 muon kernel: [  243.938307] xc2028 8-0061: type set to XC=
eive xc2028/xc3028 tuner
Oct 10 12:14:07 muon kernel: [  243.938318] usb 1-1.2: firmware: requesti=
ng xc3028-v27.fw
Oct 10 12:14:07 muon kernel: [  243.973963] xc2028 8-0061: Loading 80 fir=
mware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Oct 10 12:14:08 muon kernel: [  244.031263] xc2028 8-0061: Loading firmwa=
re for type=3DBASE MTS (5), id 0000000000000000.
Oct 10 12:14:09 muon kernel: [  245.076321] xc2028 8-0061: Loading firmwa=
re for type=3DMTS (4), id 000000000000b700.
Oct 10 12:14:09 muon kernel: [  245.093165] xc2028 8-0061: Loading SCODE =
for type=3DMTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 00000000=
0000b700.
Oct 10 12:14:09 muon kernel: [  245.284941] Registered IR keymap rc-terra=
tec-cinergy-xs
Oct 10 12:14:09 muon kernel: [  245.285059] input: em28xx IR (em28xx #0) =
as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/rc/rc0/input16
Oct 10 12:14:09 muon kernel: [  245.285167] rc0: em28xx IR (em28xx #0) as=
 /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/rc/rc0
Oct 10 12:14:09 muon kernel: [  245.285627] em28xx #0: Config register ra=
w data: 0xd0
Oct 10 12:14:09 muon kernel: [  245.286368] em28xx #0: AC97 vendor ID =3D=
 0xffffffff
Oct 10 12:14:09 muon kernel: [  245.286744] em28xx #0: AC97 features =3D =
0x6a90
Oct 10 12:14:09 muon kernel: [  245.286747] em28xx #0: Empia 202 AC97 aud=
io processor detected
Oct 10 12:14:09 muon kernel: [  245.485014] tvp5150 8-005c: tvp5150am1 de=
tected.
Oct 10 12:14:09 muon kernel: [  245.585465] em28xx #0: v4l2 driver versio=
n 0.1.2
Oct 10 12:14:09 muon kernel: [  245.691471] em28xx #0: V4L2 video device =
registered as video1
Oct 10 12:14:09 muon kernel: [  245.691476] em28xx #0: V4L2 VBI device re=
gistered as vbi0
Oct 10 12:14:09 muon kernel: [  245.692108] usbcore: registered new inter=
face driver em28xx
Oct 10 12:14:09 muon kernel: [  245.692468] em28xx driver loaded
Oct 10 12:14:09 muon kernel: [  245.707723] em28xx_alsa: disagrees about =
version of symbol snd_pcm_new
Oct 10 12:14:09 muon kernel: [  245.707728] em28xx_alsa: Unknown symbol s=
nd_pcm_new
Oct 10 12:14:09 muon kernel: [  245.707898] em28xx_alsa: disagrees about =
version of symbol snd_card_register
Oct 10 12:14:09 muon kernel: [  245.707902] em28xx_alsa: Unknown symbol s=
nd_card_register
Oct 10 12:14:09 muon kernel: [  245.708059] em28xx_alsa: disagrees about =
version of symbol snd_card_free
Oct 10 12:14:09 muon kernel: [  245.708062] em28xx_alsa: Unknown symbol s=
nd_card_free
Oct 10 12:14:09 muon kernel: [  245.708356] em28xx_alsa: disagrees about =
version of symbol snd_pcm_lib_ioctl
Oct 10 12:14:09 muon kernel: [  245.708359] em28xx_alsa: Unknown symbol s=
nd_pcm_lib_ioctl
Oct 10 12:14:09 muon kernel: [  245.708757] em28xx_alsa: disagrees about =
version of symbol snd_pcm_set_ops
Oct 10 12:14:09 muon kernel: [  245.708760] em28xx_alsa: Unknown symbol s=
nd_pcm_set_ops
Oct 10 12:14:09 muon kernel: [  245.709064] em28xx_alsa: disagrees about =
version of symbol snd_pcm_hw_constraint_integer
Oct 10 12:14:09 muon kernel: [  245.709068] em28xx_alsa: Unknown symbol s=
nd_pcm_hw_constraint_integer
Oct 10 12:14:09 muon kernel: [  245.709632] em28xx_alsa: disagrees about =
version of symbol snd_card_create
Oct 10 12:14:09 muon kernel: [  245.709635] em28xx_alsa: Unknown symbol s=
nd_card_create
Oct 10 12:14:09 muon kernel: [  245.709783] em28xx_alsa: disagrees about =
version of symbol snd_pcm_period_elapsed
Oct 10 12:14:09 muon kernel: [  245.709786] em28xx_alsa: Unknown symbol s=
nd_pcm_period_elapsed
Oct 10 12:14:09 muon kernel: [  245.838092] tvp5150 8-005c: tvp5150am1 de=
tected.
Oct 10 12:14:10 muon kernel: [  246.040731] xc2028 8-0061: attaching exis=
ting instance
Oct 10 12:14:10 muon kernel: [  246.040734] xc2028 8-0061: type set to XC=
eive xc2028/xc3028 tuner
Oct 10 12:14:10 muon kernel: [  246.040735] em28xx #0: em28xx #0/2: xc302=
8 attached
Oct 10 12:14:10 muon kernel: [  246.040738] DVB: registering new adapter =
(em28xx #0)
Oct 10 12:14:10 muon kernel: [  246.040740] DVB: registering adapter 0 fr=
ontend 0 (Zarlink ZL10353 DVB-T)...
Oct 10 12:14:10 muon kernel: [  246.040987] em28xx #0: Successfully loade=
d em28xx-dvb
Oct 10 12:14:10 muon kernel: [  246.040992] Em28xx: Initialized (Em28xx d=
vb Extension) extension
Oct 10 12:14:40 muon kernel: [  276.174469] xc2028 8-0061: Loading firmwa=
re for type=3DBASE F8MHZ MTS (7), id 0000000000000000.
Oct 10 12:14:41 muon kernel: [  277.233983] xc2028 8-0061: Loading firmwa=
re for type=3DD2633 DTV7 (90), id 0000000000000000.
Oct 10 12:14:41 muon kernel: [  277.247977] xc2028 8-0061: Loading SCODE =
for type=3DDTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e=
0), id 0000000000000000.


--------------090808070105000402070909--

--------------enig91BCD81B0F1D0292BB7EE450
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAky69MEACgkQIRM7pB2DyhaSMQCfSxOPrtoDoSXMMGts6YtG25pA
i0EAoJ7OtTHBBQL5hgGwc6wigXCqAVzB
=StMU
-----END PGP SIGNATURE-----

--------------enig91BCD81B0F1D0292BB7EE450--

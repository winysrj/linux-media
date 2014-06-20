Return-path: <linux-media-owner@vger.kernel.org>
Received: from 216-82-208-22.static.grandenetworks.net ([216.82.208.22]:45685
	"EHLO mx1.mthode.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaFTFyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jun 2014 01:54:22 -0400
Message-ID: <53A3CB23.2000209@gentoo.org>
Date: Fri, 20 Jun 2014 00:48:19 -0500
From: Matthew Thode <prometheanfire@gentoo.org>
Reply-To: prometheanfire@gentoo.org
MIME-Version: 1.0
To: isely@pobox.com, linux-media@vger.kernel.org
Subject: pvrusb2 has a new device (wintv-hvr-1955)
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="sUgtdw5F6pM2NQLFxUUXaNU99k37dx0T2"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sUgtdw5F6pM2NQLFxUUXaNU99k37dx0T2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Just bought a wintv-hvr-1955 (sold as a wintv-hvr-1950)
160111 LF
Rev B1|7

It has a slightly new usb id, 2040:7502 vs 2040:7501
I edited the kernel to have the driver as it exists for the 7501 for the
7502 (as you can imagine, it didn't work).

It still has the CY7C68013A USB pieces, but I don't know how to check
the tuner and demodulators (which I imagine is why this is failing to wor=
k).

Here's some dmesg output of it failing to load, this is about as far I
can get with my current linux hacking knowledge.

[  391.895250] usb 1-4: new high-speed USB device number 5 using ehci-pci=

[  392.333922] usb 1-4: New USB device found, idVendor=3D2040, idProduct=3D=
7502
[  392.333927] usb 1-4: New USB device strings: Mfr=3D1, Product=3D2,
SerialNumber=3D3
[  392.333929] usb 1-4: Product: WinTV
[  392.333930] usb 1-4: Manufacturer: Hauppauge
[  392.333932] usb 1-4: SerialNumber: 7300-00-F084C888
[  392.337566] pvrusb2: Hardware description: WinTV HVR-1950 Model 751xx
[  392.373602] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address 0x71.
[  392.373627] Registered IR keymap rc-hauppauge
[  392.373702] input: i2c IR (WinTV HVR-1950 Model 75 as
/devices/virtual/rc/rc0/input5
[  392.373742] rc0: i2c IR (WinTV HVR-1950 Model 75 as
/devices/virtual/rc/rc0
[  392.373744] ir-kbd-i2c: i2c IR (WinTV HVR-1950 Model 75 detected at
i2c-0/0-0071/ir0 [pvrusb2_a]
[  392.373749] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address 0x70.
[  392.377934] cx25840 0-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
[  392.395116] pvrusb2: Attached sub-driver cx25840
[  392.397754] tda9887 0-0042: creating new instance
[  392.397757] tda9887 0-0042: tda988[5/6/7] found
[  392.400183] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  392.400186] tuner 0-0042: Tuner 74 found with type(s) Radio TV.
[  392.400202] pvrusb2: Attached sub-driver tuner
[  394.808884] cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382 byte=
s)
[  394.970408] tveeprom 0-00a2: Hauppauge model 160111, rev B1I7,
serial# 8702088
[  394.970412] tveeprom 0-00a2: MAC address is 00:0d:fe:84:c8:88
[  394.970413] tveeprom 0-00a2: tuner model is unknown (idx 187, type 4)
[  394.970415] tveeprom 0-00a2: TV standards NTSC(M) ATSC/DVB Digital
(eeprom 0x88)
[  394.970417] tveeprom 0-00a2: audio processor is CX25843 (idx 37)
[  394.970419] tveeprom 0-00a2: decoder processor is CX25843 (idx 30)
[  394.970420] tveeprom 0-00a2: has radio, has IR receiver, has IR
transmitter
[  394.970425] pvrusb2: Supported video standard(s) reported available
in hardware: PAL-M/N/Nc;NTSC-M/Mj/Mk;ATSC-8VSB/16VSB
[  394.970427] pvrusb2: Initial video standard (determined by device
type): NTSC-M
[  394.970442] pvrusb2: Device initialization completed successfully.
[  394.970614] pvrusb2: registered device video0 [mpeg]
[  394.970617] DVB: registering new adapter (pvrusb2-dvb)
[  397.421679] cx25840 0-0044: loaded v4l-cx25840.fw firmware (16382 byte=
s)
[  397.590387] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  397.648404] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  397.667384] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  398.059485] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  398.111284] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  398.128856] tda9887 0-0042: i2c i/o error: rc =3D=3D -5 (should be 4)
[  398.128860] cx25840 0-0044: 0x0000 is not a valid video input!
[  398.169176] s5h1411_readreg: readreg error (ret =3D=3D -5)
[  398.169179] pvrusb2: no frontend was attached!
[  398.169181] pvrusb2: unregistering DVB devices

--=20
-- Matthew Thode (prometheanfire)


--sUgtdw5F6pM2NQLFxUUXaNU99k37dx0T2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCgAGBQJTo8tUAAoJECRx6z5ArFrDoMEQAL8IIiImQa6LBv5PS8Npu8+D
6XvJXb0njLp32kzUXm/aH9DYDfWPdBhrQ9s7WWxLGA5aGf90jFQ+FHhzMFL1AEUs
VlIyN120/IQzrUtpkxQggVEH6LGd4AEOAjnE4WUjH8Qk8Es/z/b6ID39Nuf/mIa4
uLBi/CljRpHeqY0EWNa9fRyaUIA3uKbyB2DOH3wxL58aDmjCFNYGSDDdclH4dHU6
rYmu3XN88/W1xZ8xJAmXeFZ/Eivb+5ToJ+30rGkNEYvSGbkGCnltRTBqJxF2lEQ3
qXB1iDJLg6jOxOHwX85mQ4DHvkJDaI9wLcYCvDtK58dNTD9/9dTmvJ5+EtbtJllU
cwMIfVchE9IPMPY0SXD6bDjMez11O3T4CTi+kDGcWlqziQANUjeZWl+SZ+Z4KyEB
i8veehPuFAtxfgraUXNk5ovOI1VsLvvXeDv8R6za79vyS4HiKQdruQkocXnSZQ2B
EjT32u574lNOSFO4lydB3taQgiSSTCWh0mp9GRWC7Ic5tKReE8NAt+Ln1dSlxYEj
rzQmC6YKczcyyZ+17ON1aJU/hcmGKzJmRV58YT+R1ljXnEvRU8zdiJpm8uKfbg9X
456soCXsZioKaQ0EUUVTOx/uiYvwrnXWyaHuzleu9tKzRhY8S49m1/30hnq4gEC6
5PioPaI/oj3I8SmoLjKj
=afD2
-----END PGP SIGNATURE-----

--sUgtdw5F6pM2NQLFxUUXaNU99k37dx0T2--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49282 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab2CTNEW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 09:04:22 -0400
Date: Tue, 20 Mar 2012 14:04:11 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hans-Frieder Vogt <hfvogt@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] Basic AF9035/AF9033 driver
Message-ID: <20120320140411.58b5808b@milhouse>
In-Reply-To: <4F67CF24.8050601@redhat.com>
References: <201202222321.43972.hfvogt@gmx.net>
 <4F67CF24.8050601@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+UMKRvNKk+AdXR5O3lPmm9Y"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/+UMKRvNKk+AdXR5O3lPmm9Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Thank you for working on a af903x driver.

I tried to test the driver on a debian 3.2 kernel, after applying a small f=
ix:

> diff -Nupr a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-u=
sb/Makefile
> --- a/drivers/media/dvb/dvb-usb/Makefile        2012-01-22 02:53:17.00000=
0000 +0100
> +++ b/drivers/media/dvb/dvb-usb/Makefile        2012-02-20 23:22:38.38587=
7784 +0100
> @@ -75,6 +75,9 @@ obj-$(CONFIG_DVB_USB_DTV5100) +=3D dvb-usb
>  dvb-usb-af9015-objs =3D af9015.o
>  obj-$(CONFIG_DVB_USB_AF9015) +=3D dvb-usb-af9015.o
> =20
> +dvb-usb-af903x-objs =3D af903x-core.o af903x-devices.o af903x-fe.o af903=
x-tuners.o
> +obj-$(DVB_USB_AF903X) +=3D dvb-usb-af903x.o

It should be CONFIG_DVB_USB_AF903X here.

> +
>  dvb-usb-cinergyT2-objs =3D cinergyT2-core.o cinergyT2-fe.o
>  obj-$(CONFIG_DVB_USB_CINERGY_T2) +=3D dvb-usb-cinergyT2.o


Unfortunately it turns out that my stick uses an older tuner:

[   91.396087] usb 1-1: new high-speed USB device number 4 using ehci_hcd
[   91.534709] usb 1-1: New USB device found, idVendor=3D15a4, idProduct=3D=
1001
[   91.534724] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[   91.534735] usb 1-1: Product: AF9035A USB Device
[   91.534743] usb 1-1: Manufacturer: Afa Technologies Inc.
[   91.534752] usb 1-1: SerialNumber: AF0102020700001
[   91.537709] af903x: 1 Tuners of Type=3D0x28, Arch Mode=3DDCA, Remote=3DN=
EC
[   91.552954] dvb-usb: found a 'ITEtech USB2.0 DVB-T Recevier' in cold sta=
te, will try to load a firmware
[   91.565312] dvb-usb: downloading firmware from file 'dvb-usb-af9035-03.f=
w'
[   91.875659] af903x: device init ...
[   91.875671] af903x: requested tuner id 40 not enabled
[   91.875682] af903x: device_init Fail: -22

So I'm wondering how big the differences between the fc0011 and fc0012 are.
Can the 0011 be implemented in the 0012 driver, or does it require a separa=
te driver?
Please give me a few hints, to I can work on implementing support for that =
tuner.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/+UMKRvNKk+AdXR5O3lPmm9Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPaIBLAAoJEPUyvh2QjYsOixwP/28HAL3FLtA7Daiw2Yjc48GQ
YnVktDir/YHwzyZBt7xWDWqPHh7IWcsm3M3Hi7pHqJoGycKYsZuSa8phN2+3+6Nn
GY2V7N5ajEAr3qjv8nCnrkKJxmxCaw1TMK8A4aY7zg2RPOILd4p5q2THY5IVGbv1
sXAn4753tykWa6PQ/GBx8LpMmMf3S3qE/5cbje0+fWk72RE25fnp/w6pXerBGeTj
k3Gv3qNE7Hql8cPs1OOxabJPQtLnO8z1/DYND7lKS5wouUuVASzD/Ps5JyiGfPtF
tuZZW8zWqQD0pOaBaN+d7+y91RABKP7QMI8zYnkSPGdMXIZJE1w0RHa1jOBUtJ1n
x7bBUaSvuc60Vug0PL4rGQhpsyjqcbzDfxq+UCPouMcVclq7O6GrdExJpZmJPjlc
KYBArl8ZKYapkE0V9y/hiDaUTOs+4Fv77h/Cvv0qfjj5X72oYVENcht15pP+fnys
tj3RM5hMHtCsH5R4RM91ogHewYCGuRn0/ZmzcyUOt/GM3NryxcLxDY32d2N3S8db
gVPzWxV2EqlxrX3PXKvnFKggiUWm1CfYyEVeZ7319GEqcjzj91VfHqNlusjJKld6
rYbnFwTFN+dHfUoAtCIXbUwljJmGtbrx/IRy589ZRvm76tCBlhX6DOOt6epuqYx/
5se/HoallPQzDSVymGQc
=aGBP
-----END PGP SIGNATURE-----

--Sig_/+UMKRvNKk+AdXR5O3lPmm9Y--

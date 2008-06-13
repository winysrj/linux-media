Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dkuhlen@gmx.net>) id 1K7AgX-00004y-1j
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 16:55:26 +0200
From: Dominik Kuhlen <dkuhlen@gmx.net>
To: linux-dvb@linuxtv.org
Date: Fri, 13 Jun 2008 16:54:11 +0200
References: <f3acf9620806130531j18a64bbcw92256044a491a26f@mail.gmail.com>
In-Reply-To: <f3acf9620806130531j18a64bbcw92256044a491a26f@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200806131654.11715.dkuhlen@gmx.net>
Subject: Re: [linux-dvb] Firmware extraction script for Pinnacle PCTV Sat
	Pro USB
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0467248420=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0467248420==
Content-Type: multipart/signed;
  boundary="nextPart2528752.7rg6RyCUgq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2528752.7rg6RyCUgq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
On Friday 13 June 2008, anton repko wrote:
> Hi,
> I extracted firmware for DVB-S Pinnacle PCTV Sat Pro USB (450e) from file=
 on
> installation cd:
> /mnt/cdrom0/Driver/PCTV 4XXe/pctv4XXe.sys
> I placed it also on my site:
> http://www.natur.cuni.cz/~repko/fw/pctv4XXe.sys
> because Pinnacle has some new driver, which I haven't tried yet:
> http://cdn.pinnaclesys.com/SupportFiles/PCTV%20Drivers/PCTV%20400e,%20450=
e,%20452e/XP32.ZIP
>=20
>=20
> #!/bin/bash
> dd if=3Dpctv4XXe.sys of=3Ddvb-ttusb2-a.raw bs=3D8 skip=3D22287 count=3D13=
90
> dd if=3Dpctv4XXe.sys of=3Ddvb-ttusb2-b.raw bs=3D8 skip=3D23682 count=3D14=
08
> dd if=3Dpctv4XXe.sys of=3Ddvb-usb-pctv-400e-01.raw bs=3D8 skip=3D25093 co=
unt=3D1315
> dd if=3Dpctv4XXe.sys of=3Ddvb-ttusb2-c.raw bs=3D8 skip=3D26411 count=3D12=
32
> dd if=3Dpctv4XXe.sys of=3Ddvb-ttusb2-d.raw bs=3D8 skip=3D27646 count=3D13=
26
> dd if=3Dpctv4XXe.sys of=3Ddvb-ttusb2-e.raw bs=3D8 skip=3D28975 count=3D13=
78
> dd if=3Dpctv4XXe.sys of=3Ddvb-usb-pctv-450e-01.raw bs=3D8 skip=3D30356 co=
unt=3D1323
> dd if=3Dpctv4XXe.sys of=3Ddvb-usb-pctv-452e-01.raw bs=3D8 skip=3D31682 co=
unt=3D1375
Are you sure that the 450e does need a firmware?
I know that the 452e does not.

Dominik

--nextPart2528752.7rg6RyCUgq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhSihMACgkQ6OXrfqftMKJaCgCeOIdx37oZuoMYzVRke/ENSger
1goAnRDZSqkkHW+ZaaJOODl0Vfl7Yhld
=IYnQ
-----END PGP SIGNATURE-----

--nextPart2528752.7rg6RyCUgq--


--===============0467248420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0467248420==--

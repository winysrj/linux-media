Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34621 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932291Ab2CGQX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 11:23:58 -0500
Message-ID: <1331137433.4765.3.camel@localhost>
Subject: Re: Technotrend TT-Connect CT 3650 and dvb_ca
From: Martin MAURER <martinmaurer@gmx.at>
Reply-To: martinmaurer@gmx.at
To: Johan =?ISO-8859-1?Q?Hen=E6s?= <johan@henes.no>
Cc: linux-media@vger.kernel.org
Date: Wed, 07 Mar 2012 17:23:53 +0100
In-Reply-To: <4F56763C.50806@henes.no>
References: <4F56763C.50806@henes.no>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-s/QEe6kZYmqFohb8hjAA"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-s/QEe6kZYmqFohb8hjAA
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi Johan,

I have a similar problem which happens every few days with this card.
For me it helps to remove and reinsert the kernel module whenever this
happens.
"rmmod -f dvb_usb_ttusb2 && modprobe dvb_usb_ttusb2"

see also the following unresolved threads:
http://www.spinics.net/lists/linux-media/msg43531.html

http://www.spinics.net/lists/linux-media/msg43813.html

Martin


On Tue, 2012-03-06 at 21:40 +0100, Johan Hen=E6s wrote:
> Hello Everyone !
>=20
> I have three DVB-C devices of the type mentioned, connected to my=20
> mythtv-server which have been working great for a long time. As my cable=
=20
> provider now are planning to start encrypting all channels, I have=20
> bought a Xcrypt CAM module as needed. I soon realised that I needed to=
=20
> upgrade the kernel and are now running kernel /: 3.2.0-17-generic=20
> #27-Ubuntu SMP Fri Feb 24 22:03:50 UTC 2012 x86_64 x86_64 x86_64=20
> GNU/Linux/ .
>=20
> When inserting the module everything looks well :
>=20
> /dvb_ca adapter 0: DVB CAM detected and initialised successfully/
>=20
> The problems start when trying to watch an encrypted channel. I do get a=
=20
> channel lock in myth, so far so good, but no picture...
>=20
> In my syslog I see the following :
>=20
> /dvb_ca adapter 0: CAM tried to send a buffer larger than the link=20
> buffer size (32896 > 255)!
> dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount size!
> dvb_ca adapter 0: DVB CAM link initialisation failed :(/
>=20
> Any ideas on what might be wrong ?
>=20
> Best regards,
>=20
> Johan
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=-s/QEe6kZYmqFohb8hjAA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABCAAGBQJPV4uZAAoJEJAm2rnb24AZd38H/3eYoKB7421xlrX3KDT9NXyB
TIQTt5UMvgdkRA8a4E0iGB2dts93OU1LJ5QL/FpXgWrQOA3loJ1TQZA1f7h4qyTQ
4HZZPmRMRUg9PRSk1GCrOTikdoguvQ6TsHezUGhuC8k3EofsOpL/Tjq4lFXcK8ax
Zum81FChp2fS6uzYdalzOgeEjx2rRyS8cJwX6ScX2H6g1WTVUi0grI6Sw6t/a4Bm
BIv/5x3qq5HdkMTOjMUss1gpKaEbsNR1gU6Qdd96jUP9sPBaP/phSYBG8z0aSxnD
Ri0OQztDv3CgKA4H+Ifm1Fd7tj4VhjtFzIADdQWZyB7Cm1+qudHrK5/xMh7VrRs=
=Vs6j
-----END PGP SIGNATURE-----

--=-s/QEe6kZYmqFohb8hjAA--


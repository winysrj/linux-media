Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:40997 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632AbbLGNRG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2015 08:17:06 -0500
Date: Mon, 7 Dec 2015 11:16:49 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 2/4] WHENCE: use https://linuxtv.org for LinuxTV URLs
Message-ID: <20151207111649.30ef0fa2@recife.lan>
In-Reply-To: <1449454726.2824.64.camel@decadent.org.uk>
References: <a825eaec8d62f2679880fc1679622da9d77820a9.1449232861.git.mchehab@osg.samsung.com>
	<e9a73f67222e49579154d3b8cb3ae71aa7898d94.1449232861.git.mchehab@osg.samsung.com>
	<1449454726.2824.64.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vJ1K5MDQkm6PFvuqGaBBVVU"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/vJ1K5MDQkm6PFvuqGaBBVVU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Em Mon, 07 Dec 2015 02:18:46 +0000
Ben Hutchings <ben@decadent.org.uk> escreveu:

> On Fri, 2015-12-04 at 10:46 -0200, Mauro Carvalho Chehab wrote:
> > While https was always supported on linuxtv.org, only in
> > Dec 3 2015 the website is using valid certificates.
> >=20
> > As we're planning to drop pure http support on some
> > future, change the http://linuxtv.org references at firmware/WHENCE
> > file to point to https://linuxtv.org instead.
>=20
> I've made the corresponding change in the linux-firmware.git
> repository.=20

Thanks!

>=C2=A0I don't know who, if anyone, maintains the firmware
> subdirectory now.

Well, I guess it should be fine then to send this patch via the
media tree.

Regards,
Mauro

>=20
> Ben.
>=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> > =C2=A0firmware/WHENCE | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/firmware/WHENCE b/firmware/WHENCE
> > index 0c4d96dee9b6..de6f22e008f1 100644
> > --- a/firmware/WHENCE
> > +++ b/firmware/WHENCE
> > @@ -677,7 +677,7 @@ File: av7110/bootcode.bin
> > =C2=A0
> > =C2=A0Licence: GPLv2 or later
> > =C2=A0
> > -ARM assembly source code available at http://www.linuxtv.org/downloads=
/firmware/Boot.S
> > +ARM assembly source code available at https://linuxtv.org/downloads/fi=
rmware/Boot.S
> > =C2=A0
> > =C2=A0-----------------------------------------------------------------=
---------
> > =C2=A0

--Sig_/vJ1K5MDQkm6PFvuqGaBBVVU
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWZYbCAAoJEAhfPr2O5OEVZ40QAIWl5GPSppF7NkqBvo9wY2KM
LA8sanug0mRikqbpemjMCVmfDxWfTyI2teB+6eJ3CqAB60WpamtJbUhDzbbnj+cd
Rwf5sqQ7x76rBmbD2pm7MDjRZDa9DT0eYzlCi5VXe+LKAMMBiG5lavXS+Pxe6qL2
j3RPLojmGxakggpTtc8w/ttKVMwi6dbOKjIIs49+jnpYdX69xLZnifo43xYSPsTN
xl+qZLgqHpWynCu5r2zb6PVvumZ5tAoMoRZLgKYeS/9NKLUxIbjevQS4dfgkJUvO
VL5o0LhWlveE7Ryc04Cq30OzOXuY+6vu7pUDJ7W4q7Pg1lndy9Xhqh4/QopgFLXH
klj5ZHsOSqsbciVeLzhh0/t7yHN4eCYafiZN1udp1zGWhqdQ6qEjpC/n720Rs6X0
4P0t82olxbD35zr9Z0TFzx+daE7t/TLAsRijLaJcojSkL736GXWVNPaWLU9E8VCg
m+yZdkYfdvs4t6Jd7sbZMQMMZN8zEGTOP63L3DuLfvmy646+MMSRAxf6zUQ3gjFB
8pAqgN495OTtN+r3gb+kMOam/HftxRUQNQjL5JGCPgIjtN5EARai/t45ag/qKCUK
dV3CUabVaGMfC7SEvlVeCY3mTHTLrMY31i2Iay2ybgQGndZ5hA+Gprev1sqnBrvO
3cAIzRnhpXKLuheXbQtQ
=6r73
-----END PGP SIGNATURE-----

--Sig_/vJ1K5MDQkm6PFvuqGaBBVVU--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52281 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbeF1VQT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 17:16:19 -0400
Date: Thu, 28 Jun 2018 23:16:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] media: i2c: lm3560: add support for
 lm3559 chip
Message-ID: <20180628211617.GB29146@amd>
References: <E1fYVI6-0004bV-EO@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <E1fYVI6-0004bV-EO@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is an automatic generated email to let you know that the following p=
atch were queued:
>=20
> Subject: media: i2c: lm3560: add support for lm3559 chip
> Author:  Pavel Machek <pavel@ucw.cz>
> Date:    Sun May 6 04:06:07 2018 -0400
>=20
> Add support for LM3559, as found in Motorola Droid 4 phone, for
> example. SW interface seems to be identical.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

I'd also recommend this one:

https://lkml.org/lkml/2018/5/6/46

Using most agressive settings by default is wrong.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAls1UCEACgkQMOfwapXb+vK/cACfbdPlK3b6cBOpvURDhSWY2aA6
MsoAn0pr8QcTK5iVat7dvst5B7IaPFM5
=9Td8
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--

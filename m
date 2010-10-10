Return-path: <mchehab@pedra>
Received: from smtp205.alice.it ([82.57.200.101]:47253 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab0JJLAZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Oct 2010 07:00:25 -0400
Date: Sun, 10 Oct 2010 13:00:17 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca, audio and ov534: regression.
Message-Id: <20101010130017.c90769d9.ospite@studenti.unina.it>
In-Reply-To: <20101010122129.68f3718a@tele>
References: <20101006123321.baade0a4.ospite@studenti.unina.it>
	<20101006134855.43879d74@tele>
	<20101006160441.6ee9583d.ospite@studenti.unina.it>
	<20101006203553.22edfeb7@tele>
	<20101010120250.4739ce08.ospite@studenti.unina.it>
	<20101010122129.68f3718a@tele>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Oct_2010_13_00_17_+0200_czjJpATQp=rK3A9v"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Sun__10_Oct_2010_13_00_17_+0200_czjJpATQp=rK3A9v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Oct 2010 12:21:29 +0200
Jean-Francois Moine <moinejf@free.fr> wrote:

> On Sun, 10 Oct 2010 12:02:50 +0200
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>=20
> > JF this change as is does not work for me, if I change the second
> > check to=20
> > 	if (gspca_dev->audio && i > 1)
> >=20
> > it does, but I don't know if this breaks anything else.
>=20
> Hi Antonio,
>=20
> You are right, this is the way the test must be.
>=20
> I'll try to have this in the kernel 2.6.36.
>=20

Thanks, feel free to add=20

Reported-by: Antonio Ospite <ospite@studenti.unina.it>

or Tested-by or whatever-by you consider appropriate.

Regards,
  Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Sun__10_Oct_2010_13_00_17_+0200_czjJpATQp=rK3A9v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyxnMEACgkQ5xr2akVTsAH1JwCgkfWoUR+vjpf/U+RXpWcAXNSx
loUAoI219ptsOv1URC5LncM3K3kGx52h
=52SJ
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Oct_2010_13_00_17_+0200_czjJpATQp=rK3A9v--

Return-path: <mchehab@pedra>
Received: from smtp209.alice.it ([82.57.200.105]:38946 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab0KJVYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 16:24:32 -0500
Date: Wed, 10 Nov 2010 22:24:18 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Bounty for the first Open Source driver for Kinect
Message-Id: <20101110222418.6098a92a.ospite@studenti.unina.it>
In-Reply-To: <AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_22_24_18_+0100_whEI45MQrzUPIZ.b"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Wed__10_Nov_2010_22_24_18_+0100_whEI45MQrzUPIZ.b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Nov 2010 22:14:36 +0100
Markus Rechberger <mrechberger@gmail.com> wrote:

> On Wed, Nov 10, 2010 at 9:54 PM, Mohamed Ikbel Boulabiar
> <boulabiar@gmail.com> wrote:
> > The bounty is already taken by that developer.
> >
> > But now, the Kinect thing is supported like a GPL userspace library.
> > Maybe still need more work to be rewritten as a kernel module.
> >
>=20
> This should better remain in userspace and interface libv4l/libv4l2 no
> need to make things more complicated than they have to be.

I can see at least two reasons for a kernel driver:
 1. performance
 2. out-of-the-box experience: the casual user who wants to just use
    kinect as a normal webcam doesn't have to care about installing some
    library

If there are arguments against a kernel driver I can't see them yet.

Ciao,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__10_Nov_2010_22_24_18_+0100_whEI45MQrzUPIZ.b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzbDYIACgkQ5xr2akVTsAFktQCfYk6GJdG6H427quSb2+8Mzio0
nbkAnRktvsRZxfpfJTR8tLwU95MHJBvR
=AJxb
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_22_24_18_+0100_whEI45MQrzUPIZ.b--

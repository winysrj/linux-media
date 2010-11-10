Return-path: <mchehab@pedra>
Received: from smtp207.alice.it ([82.57.200.103]:43967 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010Ab0KJXaE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 18:30:04 -0500
Date: Thu, 11 Nov 2010 00:29:52 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Subject: Re: Bounty for the first Open Source driver for Kinect
Message-Id: <20101111002952.f5873ed4.ospite@studenti.unina.it>
In-Reply-To: <AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
	<AANLkTi=5dNVBHvEtLxcO52AynjCyJq=Dpi6NqMEjd0tb@mail.gmail.com>
	<20101110222418.6098a92a.ospite@studenti.unina.it>
	<AANLkTin+HtdoXO7+ObNCoix70knaL+Fi4725BOWVXuy9@mail.gmail.com>
	<AANLkTim4hzoTg4t-jHFUCrpQwQ9Pj2sbJAH=iuawrK7E@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Nov_2010_00_29_52_+0100_zoRwTZ_Qe4qx4hPT"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Thu__11_Nov_2010_00_29_52_+0100_zoRwTZ_Qe4qx4hPT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Nov 2010 00:13:09 +0100
Markus Rechberger <mrechberger@gmail.com> wrote:

> On Wed, Nov 10, 2010 at 11:48 PM, Mohamed Ikbel Boulabiar
> <boulabiar@gmail.com> wrote:
> > On Wed, Nov 10, 2010 at 10:24 PM, Antonio Ospite
> > <ospite@studenti.unina.it> wrote:
> >> If there are arguments against a kernel driver I can't see them yet.
[...]
> > If I want to use this device, I will add many userspace code to create
> > the skeleton model and that need much computation. Kernel Module adds
> > performance to my other code.
>=20
> just some experience from our side, we do have fully working
> video4linux1/2 drivers
> in userspace, the only exception we have is a very thin layered
> kernelmodule in order
> to improve the datatransfer.

Markus, can you point to some example so I can get a clearer picture?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Thu__11_Nov_2010_00_29_52_+0100_zoRwTZ_Qe4qx4hPT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzbKvAACgkQ5xr2akVTsAFvEACfZpg/G+Wwt43Lkq6f5JTpYaGa
fKkAn0H66iCZCYc0SJEtYD51Srw++wRz
=XZp8
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Nov_2010_00_29_52_+0100_zoRwTZ_Qe4qx4hPT--

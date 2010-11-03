Return-path: <mchehab@gaivota>
Received: from smtp205.alice.it ([82.57.200.101]:39019 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755501Ab0KCUzO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Nov 2010 16:55:14 -0400
Date: Wed, 3 Nov 2010 21:53:39 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: maciej.rutecki@gmail.com
Cc: =?UTF-8?B?VMO1bnU=?= Samuel <tonu@jes.ee>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: gspca for_2.6.36 - maybe does not work properly for me (ov534)
Message-Id: <20101103215339.bf451689.ospite@studenti.unina.it>
In-Reply-To: <201011032007.25474.maciej.rutecki@gmail.com>
References: <1288264077.1891.40.camel@x41.itrotid.ee>
	<201011032007.25474.maciej.rutecki@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Nov_2010_21_53_40_+0100_/ZqU1j36OlUIk3rq"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

--Signature=_Wed__3_Nov_2010_21_53_40_+0100_/ZqU1j36OlUIk3rq
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Nov 2010 20:07:25 +0100
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> (add CC's)
> On czwartek, 28 pa=C5=BAdziernika 2010 o 13:07:57 T=C3=B5nu Samuel wrote:
> > I am Sony PS3 Eye webcam user.
> >

Please more context in the Subject next time :)

> > After installing 2.6.36 this camera gets recognized but actually does
> > not work. It might be some own stupidity of improper kernel
> > configuration but I cannot track it down at moment.
> >

This is fixed in 2.6.37-rc1, Mauro this should go in 2.6.36.1 as well,
ASAP please as we missed 2.6.36.

This is the thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg23039.html

This is the patch:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3Df43402fa55bf5e7e190c176343015122f694857c

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__3_Nov_2010_21_53_40_+0100_/ZqU1j36OlUIk3rq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzRy9QACgkQ5xr2akVTsAHqeQCgo+LHKwQp8P316VZbgGz6Ezbo
DqEAoJEtQazNxRrME0oJmh77VrySyeYc
=QyHQ
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Nov_2010_21_53_40_+0100_/ZqU1j36OlUIk3rq--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58520 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757483AbcBSMfD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 07:35:03 -0500
Date: Fri, 19 Feb 2016 10:34:48 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Russel Winder <russel@winder.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160219103448.6c28f379@recife.lan>
In-Reply-To: <1455870493.8834.8.camel@winder.org.uk>
References: <20160217145254.3085b333@lwn.net>
	<20160217215138.15b6de82@recife.lan>
	<1455783420.10645.21.camel@winder.org.uk>
	<20160218063114.370b84cf@recife.lan>
	<20160218071014.61fb3d18@recife.lan>
	<20160218072806.04484884@recife.lan>
	<1455870493.8834.8.camel@winder.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8GxcOvVw_VcUE30c=ytqRZH"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/8GxcOvVw_VcUE30c=ytqRZH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Em Fri, 19 Feb 2016 08:28:13 +0000
Russel Winder <russel@winder.org.uk> escreveu:

> On Thu, 2016-02-18 at 07:28 -0200, Mauro Carvalho Chehab wrote:
> > Em Thu, 18 Feb 2016 07:10:14 -0200
> > [=E2=80=A6]
> >=20
> > Stupid me: it should be just:
> > 	asciidoc book.asciidoc
> >=20
> > Still, there are lots of broken things there, and lots of errors when
> > building it:
> > 	https://mchehab.fedorapeople.org/media-kabi-docs-test/book.html
> >=20
> > Ok, I would expect the need to handling some things manually, but
> > it worries that it broke the tables. For example, see
> > "Table 1. Control IDs" at https://mchehab.fedorapeople.org/media-kabi
> > -docs-test/book.html
> >=20
> > It was mapped as a 3 cols table, but this is how it should be,
> > instead:
> > 	https://linuxtv.org/downloads/v4l-dvb-apis/control.html
> > =09
> > As this table has actually 5 cols, because some controls have a list
> > of multiple values (see V4L2_CID_COLORFX for example). =20
>=20
> I will not be able to do anything to help with any of this today, but I
> can try and take a look tomorrow.
>=20
> Certainly an automated translation will not do all the complicated
> bits, that will need manual intervention.

True, although I would feel more comfortable if we can use a tool for
those nested tables, as there are a lot of them at the V4L2 part of
the media kAPI doc. It would probably worth to either write a script
or to patch an existing tool like pandoc to make it work with
nested tables.

> I may well be able to assist
> on this. I think the transform from DocBook/XML is worth a bit of up
> front effort now, so as to make everything so much easier for all
> concerned in the future. Obviously I do not have data relating to this
> project, just experience and anecdotal evidence from others.


Thanks!

--=20
Thanks,
Mauro

--Sig_/8GxcOvVw_VcUE30c=ytqRZH
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxwvoAAoJEAhfPr2O5OEVddsP/0Sv9Xn4yKmEX/hXtVzjrWsN
4vKTI9IKNmOwpQoq12K+J+QhD/GSMbvwLBZEKDlCYSDutprqT5z/+J73ILSg9yDs
pfdK+4jhUSqeyECSCZ8Btrm6LacoPZzx3ZKMIAsJokYu7UkWviuz9gZQfdpjIXdw
PgRYGRxuQ3ueI5G4fZV5fj0Oe1PZEf3PnczMZqzCI1ClXhT+KxyCeI7bBwokldpq
ckvGwK7QD1uBXxOqkf9WsKdNgnbzoaF8Piv2Tel6BiyMV3aMvsGCIvSL06c8Yo1X
C4FaaEGQdViVAg0xeOXhAztRpjM3HsBh6VBQFfsjWxEQ9/z23ilmLSesyv233zuF
HWqUKGKlqPt3poFC0SHX0lPXyqt7J+03qNQY04ANVdLS9VepudOJPRn5uuG5MsSh
5AWpy4sRL8MdHz9J0TVHs5V4Z75RfIm5VHBqmiBTtbCRWrW1CFLQaK7mBIv63ovR
593s8TBYwJmA982EXmm/HUPUNw1+T1Edyg2ilN5zd47J/4gkgE8G7h2zPjDv23j1
qKXuIaL06vG841e/obXFAnJKLI2vkdrKnEiCR5veNcQvJmGWwqJECnYw3vKCqIQg
2rn6d+6dE5QfPRm0D/U6sKJ6GZg4BHzIrq04VMxW14t1z80kcfjfEwJj0BpOCQAr
wCqEcPGnp9wqc7FZBXdl
=fiex
-----END PGP SIGNATURE-----

--Sig_/8GxcOvVw_VcUE30c=ytqRZH--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424633AbcBRIbe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 03:31:34 -0500
Date: Thu, 18 Feb 2016 06:31:14 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Russel Winder <russel@winder.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160218063114.370b84cf@recife.lan>
In-Reply-To: <1455783420.10645.21.camel@winder.org.uk>
References: <20160217145254.3085b333@lwn.net>
	<20160217215138.15b6de82@recife.lan>
	<1455783420.10645.21.camel@winder.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mqPfHCJx2xC4wGro4=Hjbgz"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/mqPfHCJx2xC4wGro4=Hjbgz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Em Thu, 18 Feb 2016 08:17:00 +0000
Russel Winder <russel@winder.org.uk> escreveu:

> On Wed, 2016-02-17 at 21:51 -0200, Mauro Carvalho Chehab wrote:
> > [=E2=80=A6]
> >=20
> > We have 2 types of documentation for the Kernel part of the
> > subsystem,
> > Both using DocBook:
> > - The uAPI documentation:
> > 	https://linuxtv.org/downloads/v4l-dvb-apis
> > - The kAPI documentation:
> > 	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/
> > mediadev.html =20
> [=E2=80=A6]
>=20
> I may not be introducing new data here but=E2=80=A6
>=20
> Whilst ReStructuredText and Markdown are fairly popular text markup
> languages, they are not related to the DocBook/XML toolchain.
>=20
> Many people, especially authors of books etc. are not really willing to
> write in DocBook/XML even though it is the re-purposable representation
> of choice for most of the major publishers. This led to ASCIIDoc.
>=20
> ASCIIDoc is a plain text markup language in the same way
> ReStructuredText and Markdown are, but it's intention was always to be
> a lightweight front end to DocBook/XML so as to allow authors to write
> in a nice markup language but work with the DocBook/XML toolchain.
>=20
> ASCIIDoc has gained quite a strong following. So much so that it now
> has a life of its own separate from the DocBook/XML tool chain. There
> is ASCIIDoctor which generates PDF, HTML,=E2=80=A6 from the source without
> using DocBook/XML, yet the source can quite happily go through a
> DocBook/XML toolchain as well.
>=20
> Many of the open source projects I am involved with are now using
> ASCIIDoctor as the documentation form. This has increased the number of
> non-main-contributor contributions via pull requests. It is so much
> easier to work with ASCIIDoc(tor) source than DocBook/XML source.=C2=A0

Are there any tools that would convert from DocBook to ASCIIDoc?

Thanks,
Mauro

--Sig_/mqPfHCJx2xC4wGro4=Hjbgz
Content-Type: application/pgp-signature
Content-Description: Assinatura digital OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxYFUAAoJEAhfPr2O5OEVpN8P/jT3y/CMPUZhsA5EjhHBEaTs
cZwySHfmOnUkikyTdk+2pOW0nE4mqq7fR5qDEbZNUTIz3pDlDttYwQUbm/PxO8CJ
7nY2m5kkMkFTuj5Ot7iZILywVEAQcwMKKFZq5Du9EgXS1q8N6FsMyP/jpUuXhPJY
G4mSIuIGVzP2Cjny0tpcC3G0qEYWtbY+KPvmBUToZSQPs/A9Ic5RwkTxl2SGm9bd
YuyYrzlUG6xWB3tnDP57YP8R3ETp9wHYyi0C+xE5/wiJPs8dhcYHu3K/dhknSpvW
mt3Fmle08GJOHfPI3B4/4mbBFHNk7aDbhXbDjfMonnK8Pd5I6gGUqy8LM7aKuWcA
vlN21eGmeCpiv89Ku7WUgnJNk5plu8T3GUJb59EdDqB3kys+u3spnMibL2bL2gLt
+UIuZhQfzJnbFq7GqN43qnM9/Xn/LedPva00SSzWJE7HOHe6+gC+/8tIDc3m5/1M
g9YWwi4s/Di39Uz4Clfj7u6cSryc9gtRgCMMeJ5fxR4N9erd2ZeNnsARA1Laey7P
TiHkyrDmoAr43QkyjfHlKqu44HTG/NvwVBrnRwr/n2mEXg687a+4IHH17anf8nic
y0nejIHjPD9Y7XPRstmc/+uYAQpRWvhTxHZbZzDP4zAZeSFc9y7dZW24MK1k3xIs
VwDVKa7evAA+BEivqdlm
=2odO
-----END PGP SIGNATURE-----

--Sig_/mqPfHCJx2xC4wGro4=Hjbgz--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:33980 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424633AbcBRIRD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 03:17:03 -0500
Message-ID: <1455783420.10645.21.camel@winder.org.uk>
Subject: Re: V4L docs and docbook
From: Russel Winder <russel@winder.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Date: Thu, 18 Feb 2016 08:17:00 +0000
In-Reply-To: <20160217215138.15b6de82@recife.lan>
References: <20160217145254.3085b333@lwn.net>
	 <20160217215138.15b6de82@recife.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-RIHORTTAmlKX4wwEl+gP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-RIHORTTAmlKX4wwEl+gP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-02-17 at 21:51 -0200, Mauro Carvalho Chehab wrote:
> [=E2=80=A6]
>=20
> We have 2 types of documentation for the Kernel part of the
> subsystem,
> Both using DocBook:
> - The uAPI documentation:
> 	https://linuxtv.org/downloads/v4l-dvb-apis
> - The kAPI documentation:
> 	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/
> mediadev.html
[=E2=80=A6]

I may not be introducing new data here but=E2=80=A6

Whilst ReStructuredText and Markdown are fairly popular text markup
languages, they are not related to the DocBook/XML toolchain.

Many people, especially authors of books etc. are not really willing to
write in DocBook/XML even though it is the re-purposable representation
of choice for most of the major publishers. This led to ASCIIDoc.

ASCIIDoc is a plain text markup language in the same way
ReStructuredText and Markdown are, but it's intention was always to be
a lightweight front end to DocBook/XML so as to allow authors to write
in a nice markup language but work with the DocBook/XML toolchain.

ASCIIDoc has gained quite a strong following. So much so that it now
has a life of its own separate from the DocBook/XML tool chain. There
is ASCIIDoctor which generates PDF, HTML,=E2=80=A6 from the source without
using DocBook/XML, yet the source can quite happily go through a
DocBook/XML toolchain as well.

Many of the open source projects I am involved with are now using
ASCIIDoctor as the documentation form. This has increased the number of
non-main-contributor contributions via pull requests. It is so much
easier to work with ASCIIDoc(tor) source than DocBook/XML source.=C2=A0
=C2=A0
--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-RIHORTTAmlKX4wwEl+gP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlbFffwACgkQ+ooS3F10Be8eKACfb4VdsySNko7XDd812gXWji1a
PYQAniAFHxAY0enyry08K77urTa74yBC
=rul/
-----END PGP SIGNATURE-----

--=-RIHORTTAmlKX4wwEl+gP--


Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33017 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305Ab0BRBL5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2010 20:11:57 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4B684782.9090703@redhat.com>
References: <1257041675.3136.310.camel@localhost>
	 <4B0AB325.8020605@infradead.org>  <4B684782.9090703@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GPvSDJjp803Go4mXPCSx"
Date: Thu, 18 Feb 2010 01:11:54 +0000
Message-ID: <1266455514.10567.670.camel@localhost>
Mime-Version: 1.0
Subject: Re: [PATCH] V4L/DVB: lgs8gxx: remove firmware for lgs8g75
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GPvSDJjp803Go4mXPCSx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-02 at 13:40 -0200, Mauro Carvalho Chehab wrote:
> Mauro Carvalho Chehab wrote:
> > Ben Hutchings wrote:
> >> The recently added support for lgs8g75 included some 8051 machine code
> >> without accompanying source code.  Replace this with use of the
> >> firmware loader.
> >>
> >> Compile-tested only.
> >>
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >> ---
> >> This firmware can be added to linux-firmware.git instead, and I will b=
e
> >> requesting that very shortly.
> >=20
> > Had you submitted a patch for it already? Could you please test the pat=
ch before we commit it at the tree?
>=20
> Ping.

I'm still trying to get some response from David Woodhouse to my
previous pull request.

Ben.

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-GPvSDJjp803Go4mXPCSx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS3yT2Oe/yOyVhhEJAQJgZhAAnvcTcPElWr2SIKo/ecNAlIdJy72Wk2qx
t/tI1Flf5+9slPUkh+BuKg0eamv5grCP8qPs77RQQxahlz5lvCmrqzcsp81Tp6dv
A6vtUgC1X6Au5iAMNZQh5TvJDKUxkn3xvBBBqNFVRBvGqoV2zicnYlv2EzNh91Bt
qE4iA5M+SetFkSA243R8d/TU9utgxRCOhfzN5zaV/LEF3O7YzKUhofoeA0F3Mjen
XXrOXqIEffuQZzIFLOkutHzJs3hXx60/nRqR3o+27iYI1js2ARUGXrZG/2ct4A44
rRiKQFm4/d5Wf6Im1G0Vc5nwK5yplUbqAYoCC/wkZjjKqtKUOAZEM5QMcBdO8OIp
IwZ1Ll7edkDHLELDRFgif54Ip/Gm97KpWmcuJjkX0XPk9FHyNxXtyOP7J7+xYxKa
yImNOTusfypwXf9Pqecuv7ZHur8znceDlyCPzLfEihbxRE9RaCFW8p+7DxzfScyq
IQsBbefPoZ27UcGZPgjH6neW47e+z6zNbYA0SvjrgNYhIuLvX4yPnrs7Cv4dnbSI
wu1M6HO9OfWoupceU8mHD99L3Z8tICO7k5VilxB8gy6Ztzd3eKKiW8H42hG5S2vE
YRWfwmrQfasdA7HphXiiQpd/xNn28mLtF7/O0fcZ13wv18o0tLTVYyJUCKbAS3zn
RKoq8ej/ZbY=
=FIhy
-----END PGP SIGNATURE-----

--=-GPvSDJjp803Go4mXPCSx--

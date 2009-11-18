Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out113.alice.it ([85.37.17.113]:1499 "EHLO
	smtp-out113.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbZKRRCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 12:02:51 -0500
Date: Wed, 18 Nov 2009 18:02:16 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/3] em-x270: don't use pxa_camera init() callback
Message-Id: <20091118180216.7d769c3e.ospite@studenti.unina.it>
In-Reply-To: <Pine.LNX.4.64.0911181107540.5702@axis700.grange>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
	<1258495463-26029-2-git-send-email-ospite@studenti.unina.it>
	<Pine.LNX.4.64.0911181107540.5702@axis700.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Nov_2009_18_02_16_+0100_EjxAmkot05ieymnl"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__18_Nov_2009_18_02_16_+0100_EjxAmkot05ieymnl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Nov 2009 11:10:06 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> On Tue, 17 Nov 2009, Antonio Ospite wrote:
>=20
> > pxa_camera init() is going to be removed.
>=20
> My nitpick here would be - I would put it the other way round. We do not=
=20
> remove .init() in platforms, because it is going to be removed, but rathe=
r=20
> we perform initialisation statically, because we think this is better so,=
=20
> and then .init becomes useless and gets removed.
>=20

TBH, I am persuaded that the current use of init() is ambiguous /per se/
and so we'd just better not use it at all. If static initialization for
sensor GPIOs is better, well I just trust you on that.
However, the point here is not about static/dynamic initialization, it
is more about pxa_camera init() used one time to configure MFP pins, and
another time to request resources for the *sensor*, and in both cases
(mis)used as it was going to be called at _module_init_ time only, which
it wasn't.

So, can you see why I consider these changes (patches 1 and 2) as
merely functional to the removal of init() from pxa_camera?

Anyhow, if you don't like references to a future change without an
explanation I can arrange something in commit messages for the first
two patches :)

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__18_Nov_2009_18_02_16_+0100_EjxAmkot05ieymnl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksEKJgACgkQ5xr2akVTsAHlUwCgghkEfmE7sLxHRsZG28RQaSFg
ZREAoIm7KYFgWeinY5X0PfOIQsSV/qmj
=OkgW
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Nov_2009_18_02_16_+0100_EjxAmkot05ieymnl--

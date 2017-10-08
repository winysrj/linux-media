Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60221 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753644AbdJHTf4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Oct 2017 15:35:56 -0400
Message-ID: <1507491334.2677.83.camel@decadent.org.uk>
Subject: Re: [PATCH] v4l2-dv-timings.h: fix polarity for 4k formats
From: Ben Hutchings <ben@decadent.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>, stable@vger.kernel.org
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sun, 08 Oct 2017 20:35:34 +0100
In-Reply-To: <57270BC5.2010709@xs4all.nl>
References: <57270BC5.2010709@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-3L+k1khwEWj8bcJuWfIi"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-3L+k1khwEWj8bcJuWfIi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-05-02 at 10:11 +0200, Hans Verkuil wrote:
> Backport to 3.16-4.0 of mainline commit 3020ca711871fdaf0c15c8bab677a6bc3=
02e28fe
>=20
> The VSync polarity was negative instead of positive for the 4k CEA format=
s.
> I probably copy-and-pasted these from the DMT 4k format, which does have =
a
> negative VSync polarity.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Martin Bugge <marbugge@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
[...]

I've belatedly queued this up for 3.16.

Ben.

--=20
Ben Hutchings
compatible: Gracefully accepts erroneous data from any source


--=-3L+k1khwEWj8bcJuWfIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlnafgcACgkQ57/I7JWG
EQkqqQ//Qaxt5XRQp0t3+Fy3rLpJQVs9K3YS+JCOOCt1P73PRuCZHUBa6L8BRaPd
ttOjm7g2SeYxyyYcgUAANcodGaF2JWTBDoqNeAnO492lqkS7FHgcqvzCd8Gmexkt
Qf/5tvEaT+rn8XxvyJ11ii+lthC4z4VW1OAdG0NGsqeM+xJEvqPXBHzT97wjPlHQ
yDAJnIopskEUsuVRFKI2tI/Dg4pkZBdALyH27NGzSGnMMwKafVLC8DENxcpTsfCu
qx4ts3SmoNpeveylMzuM25KsodXdcWG5tN0eTNng1cvXVKw3zNVgN2jkvfqG5nnV
aqECefP26GFfaXy7Ovy4QFoy4rkjewJIVzD+4W7Ip++3dLqbPizTNeZLpoyZTkcZ
cfsJquoy5VLHNW56xbVImmJCdtdVIsNmCk3GkbhhE0OmKhtilDJzucxqO+PaMsiE
usE5X1spXDBkuJDFqEPjPznqsizw9e+sKGzypaNnIgkmNs24Npu4tXn+wk5cGApU
OEPyQdW1dYPar2e+UX86NqhzdggWb2BgpQa7Wrhuld52t+O9iUHqatqqCFw1Bz6A
uCnUORCr+4e2C79J+/NAm9Iq8Gi4H8M8LY1qISnVUfKt906RUim+LqKC9heZUA5G
xsNb9wJa+qz47osOdhMe7Hdxue4DO++rYIkbSs5NmJh8XMR3qAw=
=tCmN
-----END PGP SIGNATURE-----

--=-3L+k1khwEWj8bcJuWfIi--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48935 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558AbbBIJRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 04:17:09 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Subject: Re: [PATCH] media: bcm2048: remove unused return of function
Date: Mon, 9 Feb 2015 10:17:05 +0100
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, mchehab@osg.samsung.com,
	gregkh@linuxfoundation.org, hans.verkuil@cisco.com, pavel@ucw.cz,
	wsa@the-dreams.de, luke.hart@birchleys.eu, askb23@gmail.com
References: <20150208222911.GA18445@turing>
In-Reply-To: <20150208222911.GA18445@turing>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6849251.1S69iB9MMd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201502091017.06043@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart6849251.1S69iB9MMd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 February 2015 23:29:11 Luis de Bethencourt wrote:
> Integer return of bcm2048_parse_rds_rt () is never used,
> changing the return type to void.
>=20
> Signed-off-by: Luis de Bethencourt <luis.bg@samsung.com>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20

Looks good,

Acked-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6849251.1S69iB9MMd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTYexIACgkQi/DJPQPkQ1Ja3wCcDm52G9dV3ClVYPkY1nA0x0y5
ORMAnR1U0Va5FyoTZIGf8mlLrH/NyojN
=gmEm
-----END PGP SIGNATURE-----

--nextPart6849251.1S69iB9MMd--

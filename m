Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46040 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753780AbdIDPtm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 11:49:42 -0400
Date: Mon, 4 Sep 2017 17:49:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        sre@kernel.org
Subject: Re: [PATCH v7 01/18] v4l: fwnode: Move KernelDoc documentation to
 the header
Message-ID: <20170904154940.GA19484@amd>
References: <20170903174958.27058-1-sakari.ailus@linux.intel.com>
 <20170903174958.27058-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <20170903174958.27058-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2017-09-03 20:49:41, Sakari Ailus wrote:
> In V4L2 the practice is to have the KernelDoc documentation in the header
> and not in .c source code files. This consequientally makes the V4L2

consequientally: spelling?

> fwnode function documentation part of the Media documentation build.
>=20
> Also correct the link related function and argument naming in
> documentation.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>

Something funny going on with utf-8 here.

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmtdhQACgkQMOfwapXb+vLaIwCeOPrJsSUSKtY1Z/guQjHpjW+R
uREAoKP9bKses/ZucaZ3e/C2dMBIo/2f
=ZfIc
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--

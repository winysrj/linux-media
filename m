Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45908 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729670AbeKFAqs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 19:46:48 -0500
Date: Mon, 5 Nov 2018 16:25:40 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Colin King <colin.king@canonical.com>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][staging-next] drivers: staging: cedrus: find ctx before
 dereferencing it ctx
Message-ID: <20181105152540.htkdtrcdsnngu7pk@flea>
References: <20181102190126.5628-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qrokgdyikkbb3l7i"
Content-Disposition: inline
In-Reply-To: <20181102190126.5628-1-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qrokgdyikkbb3l7i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2018 at 07:01:26PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Currently if count is an invalid value the v4l2_info message will
> dereference a null ctx pointer to get the dev information. Fix
> this by finding ctx first and then checking for an invalid count,
> this way ctxt will be non-null hence avoiding the null pointer
> dereference.
>=20
> Detected by CoverityScan, CID#1475337 ("Explicit null dereferenced")
>=20
> Fixes: 50e761516f2b ("media: platform: Add Cedrus VPU decoder driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--qrokgdyikkbb3l7i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+Bg9AAKCRDj7w1vZxhR
xZUqAQDGGL3Cal9ZlDCJ14U0DlM9zhHuK4KtiYu61PvfaYkZBwEAlg4GtFWZ8CNj
Eqj7X17qQd5grDaN0mMyJYUuh0wfSwI=
=bM2L
-----END PGP SIGNATURE-----

--qrokgdyikkbb3l7i--

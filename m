Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:46211 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729711AbeKFV7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 16:59:46 -0500
Date: Tue, 6 Nov 2018 13:34:13 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] cedrus: check if kzalloc() fails
Message-ID: <20181106123413.fjd3rqm2f5vtgwpx@flea>
References: <b9bd5d87291191eeeef2b0611a1cc0acde52b2c9.1541503285.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="67n4uz3ligiokdwv"
Content-Disposition: inline
In-Reply-To: <b9bd5d87291191eeeef2b0611a1cc0acde52b2c9.1541503285.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--67n4uz3ligiokdwv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 06, 2018 at 06:21:29AM -0500, Mauro Carvalho Chehab wrote:
> As warned by static code analizer checkers:
> 	drivers/staging/media/sunxi/cedrus/cedrus.c: drivers/staging/media/sunxi=
/cedrus/cedrus.c:93 cedrus_init_ctrls() error: potential null dereference '=
ctx->ctrls'.  (kzalloc returns null)
>=20
> The problem is that it assumes that kzalloc() will always
> succeed.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--67n4uz3ligiokdwv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRcEzekXsqa64kGDp7j7w1vZxhRxQUCW+GKRQAKCRDj7w1vZxhR
xUWSAP9ZNKEKY9nYo11FL2VugoldFcfFGjKJ5fhtCwIt3u4n+QEAvtfbznZnnGPZ
KMHNfcwXsKl8Ee3U+j8ON7ECOSx84gM=
=/nYs
-----END PGP SIGNATURE-----

--67n4uz3ligiokdwv--

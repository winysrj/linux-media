Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43828 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753955AbeFKHg7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 03:36:59 -0400
Date: Mon, 11 Jun 2018 09:36:47 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] media/platform/cadence: add <linux/slab.h> to fix
 build error
Message-ID: <20180611073647.6j4wsvoh4ceavpih@flea>
References: <2feda2a7-8008-f36d-67fa-a4aa38ea75ae@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7s22rh25vss7iztt"
Content-Disposition: inline
In-Reply-To: <2feda2a7-8008-f36d-67fa-a4aa38ea75ae@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7s22rh25vss7iztt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 08, 2018 at 02:19:06PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>=20
> Add #include <linux/slab.h> to fix build errors.
> This driver uses kzalloc() and kfree() so it needs to #include
> the appropriate header file for those interfaces.
>=20
> Fixes these build errors:
>=20
> ../drivers/media/platform/cadence/cdns-csi2rx.c: In function 'csi2rx_prob=
e':
> ../drivers/media/platform/cadence/cdns-csi2rx.c:421:2: error: implicit de=
claration of function 'kzalloc' [-Werror=3Dimplicit-function-declaration]
>   csi2rx =3D kzalloc(sizeof(*csi2rx), GFP_KERNEL);
> ../drivers/media/platform/cadence/cdns-csi2rx.c:421:9: warning: assignmen=
t makes pointer from integer without a cast [enabled by default]
>   csi2rx =3D kzalloc(sizeof(*csi2rx), GFP_KERNEL);
> ../drivers/media/platform/cadence/cdns-csi2rx.c:466:2: error: implicit de=
claration of function 'kfree' [-Werror=3Dimplicit-function-declaration]
>   kfree(csi2rx);
>=20
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Maxime Ripard <maxime.ripard@bootlin.com>

Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--7s22rh25vss7iztt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlseJnUACgkQ0rTAlCFN
r3Q4Dg//VP8T3jxM0rblJGasy9u4CCkqiuQVD4ca88Rl2ULtOu2N5SVrvpId9BY3
GcqEdnl8NGvNxh6+pE0mATcZ+Tyf2p5WNHOfQCfaTA9y4uHVdBFwrHY+uGdFc2+M
xd1goA2Arkm/kaLg2en1G0t9K5PzN7Gueg7ZW91vNv+sYJMTkNK1U79kM2zUs0EV
N8+2oEzDuaQEl9hBcyceGZyRVZj6bDjUPV+uHP9PIOTXsH091vkGWOfdkK1+a2qW
QE2i1Kqmfoc2qfkoSjdk8LqFyvO+N24Zp6mJ2LAX8GNC7OyLPkygjA0mWMYX+mva
ZERPiftXdkC58IQrn+Cfy4vUA/9uJfbUO2cv8oWety4xb738sHvCUzCQQ2BbFUWi
NsFL7mjCm0l96l7gn+HW/R3f6wEuiB7yDPngNPtluYGOhOtdXGW5O/vE7OmNu27w
EB2ML83bkym7HRPrYb7I9NjMOGYBusM1LlRKHFYq2X/iKWz4DM3ytDz4A/l9tUEM
HKE01juiXaa/tCG05R1GegD6monzYQI+LCXV1umcUrqZaQNrKfQcQ7/szm82Tdl4
nEnRY1dPwoIPt/zNCqjiyz1XyGseu8WYw3Z+j7ZusWGmdkFlNMHOK21eha5WgYgm
V6RzMJ1WLqoQxT63U7jA3z0BF7NGqaMQCxbT3v1CLUyd1euRLqs=
=olOh
-----END PGP SIGNATURE-----

--7s22rh25vss7iztt--

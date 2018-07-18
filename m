Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:43348 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbeGRQPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 12:15:04 -0400
Date: Wed, 18 Jul 2018 17:36:34 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 2/3] media: ov772x: use SCCB regmap
Message-ID: <20180718153634.2alvxz5ezkvgslny@ninjato>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jazh47z6lyczwhhc"
Content-Disposition: inline
In-Reply-To: <1531756070-8560-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jazh47z6lyczwhhc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 17, 2018 at 12:47:49AM +0900, Akinobu Mita wrote:
> Convert ov772x register access to use SCCB regmap.
>=20
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

=46rom an I2C point of view, this makes a lot of sense:

Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--jazh47z6lyczwhhc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltPXoIACgkQFA3kzBSg
KbbW/A/8C8AMzlravGGpg5e8TgE+OqFoMzorRCLI2cF/AnZQxkI3CRfd2nN2do46
j7p9hav4v6+zwnwZKylcyEh0Dn5MIb0m3zdgRDfpM/BjK4nhtD9P4itdMtDsUC99
ZEIkKpRiqDCL0sxHZlshxqfUvNPtrav1uhr3/+Emwa8da64qcJBiQnMDbnA8cBNv
DksCSntk1Myyu1YtysuuTLfztCVLIJ8QTvA45kWggC8KtgcmrvwrqdLdjIOMSTdy
0lp3Qsw0mb2vyT3cKbVyRAeoJ1RaZmC/elwebeZzXlP1aVqTVfjx8eg6mHLYeXud
/lbsF3rWuUOP+Q67qSsDywdW5Sf3MPCiCGf6WqSIjnBY2bVtJafmcsa3hInh9S/r
08EEXzM4E2vrRlAjSAAI516tpV/z5HG7GKVwqLXTcss0PxqjT4PxrVuBkyBkFpKu
7/nJLowu1rzeexYW3mPuQ6u7kb1BSKWFnDj8GkH//HWFFOz21bYGlNGzB92hijiR
HFiUPLkcCffwtJY5jbzkgPK/+6iYGn1CXEUGrETBGA+qFgrBgPyCng1QH4TFbkbt
bAJv7dTf5Fh0l7+NMbqTE5meNrKbGmBv/1cYI4XLGoltohPZM6Jca8uIeSWEo/oo
EQvWIZWMEi4nCfQupSXAP+TEhaBgQyRn4A1qmzNqbFBUOQx9ClI=
=S+Zy
-----END PGP SIGNATURE-----

--jazh47z6lyczwhhc--

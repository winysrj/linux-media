Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:59570 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728326AbeGTWn4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jul 2018 18:43:56 -0400
Date: Fri, 20 Jul 2018 23:53:44 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-media@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
Message-ID: <20180720215344.6it2k5wckxvwx25p@ninjato>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
 <20180718152832.ylu6rlcsaom2q4xm@ninjato>
 <20180718153140.GP5700@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="thlbihjlzr3hfduh"
Content-Disposition: inline
In-Reply-To: <20180718153140.GP5700@sirena.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--thlbihjlzr3hfduh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2018 at 04:31:40PM +0100, Mark Brown wrote:
> On Wed, Jul 18, 2018 at 05:28:32PM +0200, Wolfram Sang wrote:
> > On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:
>=20
> > > +	ret =3D __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> > > +			       I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL);
>=20
> > Mark: __i2c_smbus_xfer is a dependency on i2c/for-next. Do you want an
> > immutable branch for that?
>=20
> Oh dear, that dependency wasn't mentioned anywhere I can see in the
> submissions and I already applied this and created a signed tag :( .
> I'll need a branch to pull in if I'm going to apply this (which I'd
> prefer, it tends to make life easier).

Here is it:

git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/smbus_xfer_=
unlock-immutable


--thlbihjlzr3hfduh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltSWeQACgkQFA3kzBSg
KbalqQ//eXO5qwL/dvh6/tCimdspOB4VsuYGxqQTNHnaUpio9dbQRB7SWETV4Rrb
2PGkl9lMXEuiDe2HcWACPOXEYdrS9O/vit6T1QS5iLuiGfuY2GCyR9B2VbiACvQn
+yMy81wZ5wS8MKB+QbyFjvxzzVt67+nYPvQioQdLsWK/y/ZyqT9a4IZFBJeFyvPN
v2MPGcpNcQ0Ea5mPNsrpadILrwrZBXsUfnmvGwhu/qG+lTOAx+GCR7LlQmsM/e7+
d8oR3doGcYkRVmQYELhqVnamGsWGARub4ex8ijsUCNb9IrXiMo30IIW9xEnpUs5P
bTeJOoL+S6NVpthAaTF4ghAzlTSS4eYYKa03xjSXA/+jFJ4jKa7dQI4Lr1xyGuiJ
Mx1i9fA+wEh84eG5LzVfKH5833R6L/ye3CY0OdyWB3XYjNw8a+jF5JCW1cfoe6n+
YSq4Cn14PHuqyVYJeWoU3BqbcRwtJnYYwHwMeJzzis+poutBsyttamT+sbWKX29E
zIlLX91HDH9Iz9fiTiPN12xnQpdxpOf3sCJl4Y3+KPOIrtG+0wr1KoBm6knDoBzg
It+F0MtXzDCzO+mnU4DdwsB7DZugIklpfSKFvgaLaiudijOqa9clE0bkIqdQo9mY
iwLcbQnAExnszZSwSl9Kk580Tg2RcoWsrNr2IjQeghPUdngpSbY=
=wFYq
-----END PGP SIGNATURE-----

--thlbihjlzr3hfduh--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:43250 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730996AbeGRQHA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 12:07:00 -0400
Date: Wed, 18 Jul 2018 17:28:32 +0200
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
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
Message-ID: <20180718152832.ylu6rlcsaom2q4xm@ninjato>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vom6revifzdsh7p6"
Content-Disposition: inline
In-Reply-To: <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vom6revifzdsh7p6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:
> This adds Serial Camera Control Bus (SCCB) support for regmap API that
> is intended to be used by some of Omnivision sensor drivers.
>=20
> The ov772x and ov9650 drivers are going to use this SCCB regmap API.
>=20
> The ov772x driver was previously only worked with the i2c controller
> drivers that support I2C_FUNC_PROTOCOL_MANGLING, because the ov772x
> device doesn't support repeated starts.  After commit 0b964d183cbf
> ("media: ov772x: allow i2c controllers without
> I2C_FUNC_PROTOCOL_MANGLING"), reading ov772x register is replaced with
> issuing two separated i2c messages in order to avoid repeated start.
> Using this SCCB regmap hides the implementation detail.
>=20
> The ov9650 driver also issues two separated i2c messages to read the
> registers as the device doesn't support repeated start.  So it can
> make use of this SCCB regmap.

Cool, this series really gets better and better each time. Thank you for
keeping at it! And thanks to everyone for their suggestions. I really
like how we do not introduce a couple of i2c_sccb_* functions with a
need to export them. And given the nature of regmap, I'd think it should
be fairly easy to add support for ov2659 somewhen which has 16 bit
registers? Only minor nits:

> +#include <linux/regmap.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>

Sort these?

> +/**
> + * regmap_sccb_read - Read data from SCCB slave device
> + * @context: Device that will be interacted wit

"with"

> +	ret =3D __i2c_smbus_xfer(i2c->adapter, i2c->addr, i2c->flags,
> +			       I2C_SMBUS_WRITE, reg, I2C_SMBUS_BYTE, NULL);

Mark: __i2c_smbus_xfer is a dependency on i2c/for-next. Do you want an
immutable branch for that?

> +/**
> + * regmap_sccb_write - Write data to SCCB slave device
> + * @context: Device that will be interacted wit

"with"

But in general (especially for the I2C parts):

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--vom6revifzdsh7p6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltPXJwACgkQFA3kzBSg
KbaMww/8CxZhHTEM02/4oJgatS4pz9I/9AqBgUxNgIYWF32BEPKBVMr3Td8Z3pI7
L2B00WYTbgvqQ16zOFEHpPtkFGnPXPbdIpxnNeDM5IEw+rNe2igVUdcVRmN8Bdpi
SKakv7pn4GyUUnrE5RslT4GoORbKG1lwood6GHUIMNd0dUt80AmjDYq35RSsSzpD
4JKTeH+EwYsd+CxuZj9z5g/CMpUdO6ikyLaBLbB0BggY/yVWC3tRtOUE/lfkh1yv
7SAn5zhbDseDZGd7WbYnRgNOU33OzPvjfNV4GWen+pqbJl9JfxiGOGz7PAzqJGNv
201UD3D5bEYBf8XhVUim2hOfhXydE8BBW2AMVRcBx/4X1HC9aaP7rzqU0SqZNvKq
F5K5Eix6yUwCTTU1kXMA+jc/HRqx/oS7jaM3hP1JcegXFVYeOTWPCbhwSekazHW2
zGsKkUBxGuawTOCLQHfIQajUZt1wa8tnvvhwf3xzN82YxVcGW9hs46aecVy/3mFG
FbL8dwf4vl8rRDU7Di5Qlx3M6FuVS8Q4XZ8ZiGoZCMDlhy3ls9AWs2+wH8fzoh66
hFKMYmZsJJNvrjt8TNm3YbV3Q7KzpPzm5c/zZCXwZ4p3+y3F6WqY+r1Xl2bctHin
hXyNsYL+JWaIhL/m5FeWY65Ku6tPL1568jHFdnyL50vImZCFAUw=
=Ar7Y
-----END PGP SIGNATURE-----

--vom6revifzdsh7p6--

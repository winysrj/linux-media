Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:51980 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755285AbeFNPeF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:34:05 -0400
Date: Fri, 15 Jun 2018 00:33:58 +0900
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Message-ID: <20180614153357.vgz4umv2aqudghm3@ninjato>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ogt4kb64h2rsdv5p"
Content-Disposition: inline
In-Reply-To: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ogt4kb64h2rsdv5p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 13, 2018 at 12:34:46AM +0900, Akinobu Mita wrote:
> (This is 2nd version of SCCB helpers patch.  After 1st version was
> submitted, I sent alternative patch titled "i2c: add I2C_M_FORCE_STOP".
> But it wasn't accepted because it makes the I2C core code unreadable.
> I couldn't find out a way to untangle it, so I returned to the original
> approach.)
>=20
> This adds Serial Camera Control Bus (SCCB) helper functions (sccb_read_by=
te
> and sccb_write_byte) that are intended to be used by some of Omnivision
> sensor drivers.
>=20
> The ov772x driver is going to use these functions in order to make it work
> with most i2c controllers.
>=20
> As the ov772x device doesn't support repeated starts, this driver current=
ly
> requires I2C_FUNC_PROTOCOL_MANGLING that is not supported by many i2c
> controller drivers.
>=20
> With the sccb_read_byte() that issues two separated requests in order to
> avoid repeated start, the driver doesn't require I2C_FUNC_PROTOCOL_MANGLI=
NG.

=46rom a first glance, this looks like my preferred solution so far.
Thanks for doing it! Let me sleep a bit over it for a thorough review...

> --- /dev/null
> +++ b/drivers/media/i2c/sccb.h

I'd prefer this file to be in the i2c realm. Maybe
'include/linux/i2c-sccb.h" or something. I will come back to this.


--ogt4kb64h2rsdv5p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlsiiuAACgkQFA3kzBSg
KbZw1BAAiOEK85Tbx4HkWj6fKtMEgE0MW5T8BtJUeKdY292zuETTYAYfYv+IEFDO
cWzCUYhr8D/uIoHIyV/ACNLmJWJizNSbNmOcghUS+Nm4JoYMA0JfoopKqFFbyBOh
P2sC9jMsyJfQAw9MaPYUWME5mmcWDXs1wCebtxvcssdIv+AP8UE2KpGG2mcC/Mbe
vP6MkbjifZ20q9JNcbcg8HgTp/8132XScJjBpJBIeT7JBsYlVobyzCULX8Fy4V6w
DY8eJwT9gUf+5wQyavIH7PrL9WtiNs/z0Rgpqh0opROTAEwN+zG4QXRGpi4dKM8x
L6pGFHCZQN+gPQn2c/qxUVJvSp5tH8ZAcyTKa5JChEmgXBYtBVUnb0hPI1Z47IIR
ggAb+n/EW2CJhG0kRDu5p+tKQ2RH3O88nzw/nCtvZKpeukpO+Xf0u9+ORuQpNPtO
h3IcXfjWURCA/mkZH8426aMEEMRYE5FTDpI9zdtPxGR/4HgKWB9mqSX8u0ntGGHb
kPnFOFx0WrAsGfVQoQS3YZ9sFuP8WPrnicGllAi7pf6ny6l4Ki5qYAroaTNx5c4j
XPrDTy+acjeCH/RypPOA2xWn+J84ZyCrqsZswVdTET1evJWfzBgf9tUQ6wF4hWFA
M8A4BQU0vGFh1p8icQGpK6HIl72Z8VKSt9mCz1EZqBibXlqJgrg=
=to7b
-----END PGP SIGNATURE-----

--ogt4kb64h2rsdv5p--

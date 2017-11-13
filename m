Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752734AbdKMPT1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 10:19:27 -0500
Date: Mon, 13 Nov 2017 16:19:23 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: et8ek8: select V4L2_FWNODE
Message-ID: <20171113151923.zgjiv7eum6vmh7j6@earth>
References: <20171113135658.3208951-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="towyvlz7na6qu5ry"
Content-Disposition: inline
In-Reply-To: <20171113135658.3208951-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--towyvlz7na6qu5ry
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 13, 2017 at 02:56:45PM +0100, Arnd Bergmann wrote:
> v4l2_async_register_subdev_sensor_common() is only provided when
> CONFIG_V4L2_FWNODE is enabled, otherwise we get a link failure:
>=20
> drivers/media/i2c/et8ek8/et8ek8_driver.o: In function `et8ek8_probe':
> et8ek8_driver.c:(.text+0x884): undefined reference to `v4l2_async_registe=
r_subdev_sensor_common'
>=20
> This adds a Kconfig 'select' statement like all the other users of
> this interface have.
>=20
> Fixes: d8932f38c10f ("media: et8ek8: Add support for flash and lens devic=
es")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/i2c/et8ek8/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/media/i2c/et8ek8/Kconfig b/drivers/media/i2c/et8ek8/=
Kconfig
> index 14399365ad7f..9fe409e95666 100644
> --- a/drivers/media/i2c/et8ek8/Kconfig
> +++ b/drivers/media/i2c/et8ek8/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_ET8EK8
>  	tristate "ET8EK8 camera sensor support"
>  	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select V4L2_FWNODE
>  	---help---
>  	  This is a driver for the Toshiba ET8EK8 5 MP camera sensor.
>  	  It is used for example in Nokia N900 (RX-51).
> --=20
> 2.9.0
>=20

--towyvlz7na6qu5ry
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAloJt/MACgkQ2O7X88g7
+pqY2Q//S/YaqQwgCs8l2YbiW0F2hjOzlc8I4ftv8hJpYPzHYUaP7j3OJ0/sswZX
PRMOakvOXEPw9BH1MZX3Dl70GE3bJmDWRx04mNoOe6E6zrQoRBfZQqftUQF+DuMz
2Z2UIenezS7ZBOOdkHU96sYUDwGE7FBfsLcnVhdvJeUg0PFrYyYs1ACAeHNg19dP
kEN9+GeyeFrIdOcTGmRNpjmIpq9KMbPcTm0rzy4khjGyPiEqPjGbDuXcKlq+lRbr
XsYYTW/aKShYgi3K2Znzx6ky+ocIYb2hs/4vSVLbVNDqfHOAnsXt9W/CdeYLny+g
SJBR0a3ZPUR7NnF+EGIAFTFkCFfbTJfXcMSnLgZu0T4WYXhjdrKaJ1NNTNZRbpZc
65rQAB2FHzqcvWzxrQC8lTjtVuYyiHYhf4U24Ohah+dfYnUrICS8b4JDmth8EnTr
0/3dzgkdnlOKofgYjdPtUN88iT0lnfK5a6BT84zV9Bt0vZbBiLCJfjPA4+0462Fq
J0ZqqCqRgs18Hp7sw9iyl/b32k9CCuGPUKkRx1qN2lpjuUmdl76ezTjFjdtuNhkO
oytZvumgZZfENX2m/+U3Z6FIxFWy4XeEsd3KFQoDA6hk/1W2tgl8XlGrB4zst+fM
RF+Xyfvn2HKx9LnH/LCuYwjYiiLShGOpnjX9WN18BPVlckogn5M=
=fFCI
-----END PGP SIGNATURE-----

--towyvlz7na6qu5ry--

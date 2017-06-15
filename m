Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44452 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbdFOJYa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 05:24:30 -0400
Date: Thu, 15 Jun 2017 11:24:26 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, robh@kernel.org, pavel@ucw.cz
Subject: Re: [PATCH 5/8] v4l2-flash: Flash ops aren't mandatory
Message-ID: <20170615092425.xcgeiu65yxawczr5@earth>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="velhfojf4dfdolay"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--velhfojf4dfdolay
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 14, 2017 at 12:47:16PM +0300, Sakari Ailus wrote:
> None of the flash operations are not mandatory and therefore there should
> be no need for the flash ops structure either. Accept NULL.

I think you negated one time too much :). Otherwise:

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/v4l2-flash-led-class.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/med=
ia/v4l2-core/v4l2-flash-led-class.c
> index 6d69119..fdb79da 100644
> --- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
> @@ -18,7 +18,7 @@
>  #include <media/v4l2-flash-led-class.h>
> =20
>  #define has_flash_op(v4l2_flash, op)				\
> -	(v4l2_flash && v4l2_flash->ops->op)
> +	(v4l2_flash && v4l2_flash->ops && v4l2_flash->ops->op)
> =20
>  #define call_flash_op(v4l2_flash, op, arg)			\
>  		(has_flash_op(v4l2_flash, op) ?			\
> @@ -618,7 +618,7 @@ struct v4l2_flash *v4l2_flash_init(
>  	struct v4l2_subdev *sd;
>  	int ret;
> =20
> -	if (!fled_cdev || !ops || !config)
> +	if (!fled_cdev || !config)
>  		return ERR_PTR(-EINVAL);
> =20
>  	led_cdev =3D &fled_cdev->led_cdev;
> --=20
> 2.1.4
>=20

--velhfojf4dfdolay
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAllCUkkACgkQ2O7X88g7
+prCgw//Z+PbxbBha/NBeJrtIz0f2EnldqIB8Lelh+f95cjxfbjrHd8xWI0/tp2i
ktCNQZai1qNAbYhgWPdkoKnBzQeINjc+M/OXpgrLV45Mjxob/Fi0MFdGxrURfd3y
u+pNRouFkE/x/XwuU7JkQ9HqsX69ZigM2KyHZbBF42g1wOHzBcxhi51RlnegLIDd
Vbe8XmSem3GJ/VJwvtpDJbgXpAF8r52TDNI6rCh6ZrlFphSw9kcRL4PF/xpJUggN
HxsQz4C6lbUQiCHyfMBzCy88eDqlweV917M8GEowe5i/fiVC5qFRl9j2bzGX89Bz
79IGVjIma5ucyvNYOkdgIbOMZiACXtLzSJaixjIp020U1rJGL3wOT8N+QAJ1txd3
s/mrqYoN8gXslJvMGu3EYQmHTqLFiQcTFEVT1CKj8WnM2oxxXObRPLmdDpt28XPF
qZwAKCgUNfq0kb4BehotQPu6G6gqr17PG259e8NZXqnxhtFYG64ki+uoJAeN6klx
yj0dQXDJkKo8I01Zlet+avXSq50+BuM5HeiVIaTxxssjwnEgT1kfNkrgMwpDikiL
8gHalwO4yCm4mCXLKaVs8NPWjTYJxHJaZRbxNYqBFaFHXVo8vQ92xrmaaqLgdsDM
TOs07xHCFtajPJLyECWQjh3EuzG52v6QwhbXOKHukPLSYwM8I2I=
=GYJw
-----END PGP SIGNATURE-----

--velhfojf4dfdolay--

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJ2XEx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:04:53 -0400
Date: Mon, 30 Oct 2017 00:04:50 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 28/32] smiapp: Add support for flash and lens devices
Message-ID: <20171029230450.5ehspnbjourkpsa2@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-29-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lwstatjrx5o72xvo"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-29-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lwstatjrx5o72xvo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:38AM +0300, Sakari Ailus wrote:
> Parse async sub-devices related to the sensor by switching the async
> sub-device registration function.
>=20
> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
>=20
> This does not yet address providing the user space with information on how
> to associate the sensor or lens devices but the kernel now has the
> necessary information to do that.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index fbd851be51d2..a87c50373813 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -3118,7 +3118,7 @@ static int smiapp_probe(struct i2c_client *client,
>  	if (rval < 0)
>  		goto out_media_entity_cleanup;
> =20
> -	rval =3D v4l2_async_register_subdev(&sensor->src->sd);
> +	rval =3D v4l2_async_register_subdev_sensor_common(&sensor->src->sd);
>  	if (rval < 0)
>  		goto out_media_entity_cleanup;
> =20
> --=20
> 2.11.0
>=20

--lwstatjrx5o72xvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XpIACgkQ2O7X88g7
+pqUThAApViwbUMmrcoy49/+t02Ml4JS4Y4GDKVOq7J+d1ExCGA+GetwesJcyfOV
HEV0WLyEYlR4t6BEmlJ3O6qy1N1iF1/sWIg2YSlT8D1RYwTtGbrbsZpL1Kp9Ll06
J+gmFHX4Q51i+GoMZKOUMQ3y4sXChbkJ7IyBzcpXCE++10YJ6VtWHdFSKxqgWpZs
3LhOGZGx5G+IEVQeXIYj6B1SSGLJ2k3+cYKXUjRf4Dyp2c/V3e6CobyKZcZ3u11Q
IOLIYaR6a8P59o92K2OsCWyb+GRynq4TcWnFWTKWIADyIkvmxQso/7liVzlLCUox
2e2x3RwbiausgYCiV+zWl7vJ3qauNpO+vOZ1XbysL+vvx+YAbOubEYhIvYcLTx/G
SXAf6SBadzPpjFmWNV2clAbT953nna8KdS/yVWVIgEw61lzM7s3ZuTOGKWSSO9I8
IRui5pZRNzOjyFWre4u5TnIbsPLHOIrrsyRNJCjcYZ2oxOWLxW5VgMfExwt/u7hP
7rnWXO1Suoj8ml0C226k2PyiD3gQ60rtM9GEgfVLTRObgKihqJm5zC1/lWpv1M4N
DdjnvAgAU8xS+cJycOWdGlCdPrJOUJoYd+tlWOOIvD2nu5QkNbA5qUIGNVXHMsqR
5EstBH09v47ApNIEiHLynLJ4uj+415LT4u+GCpiqeu0bHZKipKc=
=ksnX
-----END PGP SIGNATURE-----

--lwstatjrx5o72xvo--

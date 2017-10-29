Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdJ2XFq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:05:46 -0400
Date: Mon, 30 Oct 2017 00:05:43 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 30/32] ov5670: Add support for flash and lens devices
Message-ID: <20171029230543.ccwaj6f66xlhnbd2@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-31-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="prhrm5mdxvum4gt4"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-31-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--prhrm5mdxvum4gt4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:40AM +0300, Sakari Ailus wrote:
> Parse async sub-devices related to the sensor by switching the async
> sub-device registration function.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/i2c/ov5670.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
> index a65469f88e36..9f9196568eb8 100644
> --- a/drivers/media/i2c/ov5670.c
> +++ b/drivers/media/i2c/ov5670.c
> @@ -2529,7 +2529,7 @@ static int ov5670_probe(struct i2c_client *client)
>  	}
> =20
>  	/* Async register for subdev */
> -	ret =3D v4l2_async_register_subdev(&ov5670->sd);
> +	ret =3D v4l2_async_register_subdev_sensor_common(&ov5670->sd);
>  	if (ret < 0) {
>  		err_msg =3D "v4l2_async_register_subdev() error";
>  		goto error_entity_cleanup;
> --=20
> 2.11.0
>=20

--prhrm5mdxvum4gt4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2XscACgkQ2O7X88g7
+prHCg//f6BYT8oYjqpcSI5CAf+iTBTns2wWMGZmm+WXpd+iDzUXw5jJblWiOyZ3
dZapmwfd+Lj11dGCot7bIgs/K2v5+OfkulkO4fg0SrBF7xy/fmyNoigNxoSwSh+t
8qT9QX0mh3v+W/P245YqsV374SyWIGmopyA789xW7aRa2XKVgmzfN/okUxcvy4xN
lsdTKvwuwpUa1BdNHgAF0miYhv4hkN3rTI+GTJkxTKowj0sSZTJo1GZBBWV/6z1r
rDLfucv/pgWDTh2yNnbMaB/1X9QkSGk0LLBEyrvBTU+YKI3leBe89X32JMNyo/88
c9PoCOr2++DZRb+27s8z3cZRVZ7b/r2mrqX8+QUU57V3mp+T3BOd0KA3YcmMZINL
3xjXs8ZtYLlwSQTWWDNhahQQmYr1/kYK+DZGVvkgWdgBt7jt8BKlSUEKbu5jCEWv
HfaSmrzOK4o6Mctci5dPZFo0Com7BImCCoD5cTtJrUUxVKk69adV6HEJ7Z7agFzT
sJDE/qYiiYXD10Pnw9gFrvRgcO6G4v6+a5lEjMvaVFTKDOQRYx0nUmskI8TTIB92
oUexohTxcR0tu9vILW3gaeVC9IvvKWP0ZyJVBjIeCIdI7prZJ/LbXPPxOthlllhr
v+RYnKuxPOjBVpNBLjXSeT+/NTn96gKUSZ3bec9jsDP5p4NlmEk=
=TRGE
-----END PGP SIGNATURE-----

--prhrm5mdxvum4gt4--

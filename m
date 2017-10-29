Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJ2XFU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 19:05:20 -0400
Date: Mon, 30 Oct 2017 00:05:17 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 29/32] et8ek8: Add support for flash and lens devices
Message-ID: <20171029230517.2wco6qndrffcp65i@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-30-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="saa3ztkljw4i7iu7"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-30-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--saa3ztkljw4i7iu7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:39AM +0300, Sakari Ailus wrote:
> Parse async sub-devices related to the sensor by switching the async
> sub-device registration function.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/i2c/et8ek8/et8ek8_driver.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/et8ek8/et8ek8_driver.c b/drivers/media/i2c=
/et8ek8/et8ek8_driver.c
> index c14f0fd6ded3..e9eff9039ef5 100644
> --- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
> +++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
> @@ -1453,7 +1453,7 @@ static int et8ek8_probe(struct i2c_client *client,
>  		goto err_mutex;
>  	}
> =20
> -	ret =3D v4l2_async_register_subdev(&sensor->subdev);
> +	ret =3D v4l2_async_register_subdev_sensor_common(&sensor->subdev);
>  	if (ret < 0)
>  		goto err_entity;
> =20
> --=20
> 2.11.0
>=20

--saa3ztkljw4i7iu7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2Xq0ACgkQ2O7X88g7
+prAfA/7BueRLgPVMWRA3GhZW+DOcIBwSp/ZHiRAvaJbeYNdXd3pmqVJRVddBXd8
+BQA1glnh+43nPuJ2YnQDflvw/6pfiA/z9V1fbos4hrHPDASmVnYAc/jBpzS3lxZ
kH0Ci8BOBctaSTcZZTu6rlR2TBW0mE/Y2znlVzvKDEmDOBwdAIWvXVsT1W+6GxPM
QEGyyE1R89ktpOQ6qQOIaudYKD92HQWJGkPVWKJFyeWq24fRSEVSP2AQM2bZnu6H
Mr8kzGd/oT23V6Fekf9J0q4CebQqJIlfsU27hHNwoiVHgy7KahhLg1oCgrgVXtms
TfMPFRyFIj652w4hqv1KtBC9Trf/NOfZ3EDUVz9vit9h1m1tBNWSHOZTYm+jlFm6
wSmHhTulgIApgy/ZSklvpKlRB7Jekc0cQFgJAH5mwI/x/WvKfRQ7lMvgTguUvGqE
WdUZyjNy8nWw66IOn1ZfisY3zo28tY4PBs2uasIKERnjDZPLceH+am8UXahDaVVq
U2VCMkkJDV0CHmzu71QIed6BBYRGLES+k6QyBQR0xEUioRCRiBDfKcGVKvLL/IX0
BHp8tcm7v/XVlcwBie9P9cVbelRI7BAn/5DPmHEAGOww7ZrSUnYpUUCTw6mR2E5h
Xgpf1I+odaU9ofyp45DXjq0P0T3ZzzuhTD72RxcS77DaHYYfVV8=
=Yqe1
-----END PGP SIGNATURE-----

--saa3ztkljw4i7iu7--

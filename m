Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([5.45.101.7]:52836 "EHLO ring0.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbcISUTF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:19:05 -0400
Date: Mon, 19 Sep 2016 22:11:32 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 01/17] smiapp: Move sub-device initialisation into a
 separate function
Message-ID: <20160919201131.f5eeca2vvjabqhpm@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-2-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vs6oqvgfsuzoygvp"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-2-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vs6oqvgfsuzoygvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:15PM +0300, Sakari Ailus wrote:
> Simplify smiapp_init() by moving the initialisation of individual
> sub-devices to a separate function.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 108 +++++++++++++++------------=
------
>  1 file changed, 49 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index 44f8c7e..862017e 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
>
> [...]
>
> +	if (sensor->scaler)
> +		smiapp_create_subdev(sensor, sensor->scaler, "scaler");

I would add the NULL check to smiapp_create_subdev.

> +	smiapp_create_subdev(sensor, sensor->binner, "binner");
> +	smiapp_create_subdev(sensor, sensor->pixel_array, "pixel_array");
> =20
>  	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
>=20

-- Sebastian

--vs6oqvgfsuzoygvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4EZxAAoJENju1/PIO/qaVbQP/RuY1B7k4dVERfoYzsV/T1aX
adchWhooVbR3BOF6DltbwVGKp4LPxXBaW0zV2lhxmmiciqOWPWg+rRthIyT57siP
tr038OwvHvbWB/UEWzIlrAjhoCMNXTw+DT26QTMT7VHyO5KKyyZgDbr/WFhOBv9U
lD5jTz5XARAw+g4Pu8VFMzQvkfrfLyiNtko4INqNx+GmiVwLCqBacsYtWIfbeDdJ
Wzs5hzkWja+xJPEcGrDMCEMrkAvqiQBvaRXOjL+OT+uw+DB0R/1tJUQRh4bsHLUq
I2zQ0aisUyO9R/Z0BDH5R23g8IHaQ6TkrvRGgUIFAMvL1u1e0uloj3DaoS7Lgkts
3Vb0eGxMxWbrLN+vRUcArQIzMwQHcBblgtawRPF7Ap7qpPm+R3FxHOUMIcorjAkZ
qEf1lW9OeNnCsloV4rE08tcOG8oLf3xnkP/HmH7NNzHwVQWKmV1M8Rq7rqZ38qfS
vb78wznLXDhF81JzmadyoYqErdwaJQy2LwFxv44Yd3YnZHzSUHdOjdc8FYK5Jq1h
UZvwFYlGmvvw9IN6y1epBWc5x8GxGKOyLzopduoA2yyOIwjhUNsMULIKF5TsdhWt
K9peZiSeHKz3SOe40D5zkfYq1bN36lOXCf+Lwy+CIjFhA+IAb/kStcbP8LAMjKEj
mL1yOhOuwcBN54LAsEWf
=UcMV
-----END PGP SIGNATURE-----

--vs6oqvgfsuzoygvp--

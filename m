Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759658AbcHaMN4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:13:56 -0400
Date: Wed, 31 Aug 2016 14:13:43 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] smiapp: Return -EPROBE_DEFER if the clock cannot be
 obtained
Message-ID: <20160831121342.2pj23xapnb4gz2ys@earth>
References: <1472629325-30875-1-git-send-email-sakari.ailus@linux.intel.com>
 <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mipdbmcqj2ici6fd"
Content-Disposition: inline
In-Reply-To: <1472629325-30875-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mipdbmcqj2ici6fd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 31, 2016 at 10:42:03AM +0300, Sakari Ailus wrote:
> The clock may be provided by a driver which is yet to probe.

This probably fixes N950 with built-in drivers, where I could see
smiapp fails due to missing clk. I have not yet further anaylsed it,
since more important parts like display output are also not yet
working.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index 92a6859..aaf5299 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2558,7 +2558,7 @@ static int smiapp_init(struct smiapp_sensor *sensor)
>  		sensor->ext_clk =3D devm_clk_get(&client->dev, NULL);
>  		if (IS_ERR(sensor->ext_clk)) {
>  			dev_err(&client->dev, "could not get clock\n");
> -			return PTR_ERR(sensor->ext_clk);
> +			return -EPROBE_DEFER;
>  		}
> =20
>  		rval =3D clk_set_rate(sensor->ext_clk,

With the error being rewritten to EPROBE_DEFER, the actual error
number should be part of the error message:

dev_err(&client->dev, "could not get clock (%d)\n", PTR_ERR(sensor->ext_clk=
));

-- Sebastian

--mipdbmcqj2ici6fd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXxsn2AAoJENju1/PIO/qaPY8P/3nWd/elz4q07chUnJOI+1To
r2EtFB4T21A5t16eb+ymZHWRqyIpGnlAPyAhvmlRyAYkTJZ4yIhaVcgEsqN7/Qaa
4gP47AY/ayI+IQX943oi1o0f4xE4ebYfToov1RhPuZdg6/K3gxlLkQ3mmzNAD0ZB
FebxO47tpRx64QJ2m1eLLvTLLibG8qo+uWVNZoJJMEJ3+EomHFshbK3EJCwI57hM
zw9ZvAH28h1zhiyeCc5xLBJYeBgKTtWXY2D7T7NQeozk9mbG6Qs5k0wzWSOkz9wu
hgPgHUJc0SZ2H0+x+L4tiFj+b74JmqbBXBonGBGmNGfgHCYkycKybURhYupDzXyX
boHB2ArV4iecobxZcPdXu7vH/23XhRXjt2DrUrIz5h53XnP8IeGZPIC4JRfjjO/J
O03p6lPfhf9QtjZ+6ZRP9yoGonduAHWKp/Fbjk14b5MAz/RkywzuZm6NiYDEClCp
aWzHYIJUXSjWZz6YQNfVc/EGhPbmZ/rlXKTGM7PUQjC6XrT8pqo5rZ319MG10oXy
CGJ7OZEFiuuALeoK9dX3h4NY5v8incpNAyxrjPqfHrafFuQVS1FEBqbgVjWk+akv
SR0+Lvrc0/UuU2oEsNSocEpQBzYxmJ5eFxx6gobUqSfXjjtcrh3D+I5CrAYB99XV
pRvpCnNnCYZ4bSyKTnGn
=iFLl
-----END PGP SIGNATURE-----

--mipdbmcqj2ici6fd--

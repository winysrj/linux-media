Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:48250 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdDCK0u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Apr 2017 06:26:50 -0400
Date: Mon, 3 Apr 2017 12:26:46 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 9/9] [media] cx231xx: stop double error reporting
Message-ID: <20170403102646.GA2750@katana>
References: <1491208718-32068-1-git-send-email-peda@axentia.se>
 <1491208718-32068-10-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1491208718-32068-10-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2017 at 10:38:38AM +0200, Peter Rosin wrote:
> i2c_mux_add_adapter already logs a message on failure.
>=20
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>  drivers/media/usb/cx231xx/cx231xx-i2c.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/=
cx231xx/cx231xx-i2c.c
> index 35e9acfe63d3..dff514e147da 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -576,17 +576,10 @@ int cx231xx_i2c_mux_create(struct cx231xx *dev)
> =20
>  int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
>  {
> -	int rc;
> -
> -	rc =3D i2c_mux_add_adapter(dev->muxc,
> -				 0,
> -				 mux_no /* chan_id */,
> -				 0 /* class */);
> -	if (rc)
> -		dev_warn(dev->dev,
> -			 "i2c mux %d register FAILED\n", mux_no);
> -
> -	return rc;
> +	return i2c_mux_add_adapter(dev->muxc,
> +				   0,
> +				   mux_no /* chan_id */,
> +				   0 /* class */);

Could be argued that the whole function is obsolete now and the
c231xx-core can call i2c_mux_add_adapter() directly. But maybe this is a
seperate patch.

>  }
> =20
>  void cx231xx_i2c_mux_unregister(struct cx231xx *dev)
> --=20
> 2.1.4
>=20

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJY4iNlAAoJEBQN5MwUoCm2sbMP/R+uUIWP56gcLxJglfrRrEOT
vI1ZGJhxSTNKmX8wllynWF+y+cVMH3wh4pR/lX6nvx1SWhAYrvoXWPSJyDWlb5wn
mckYHav1xCHe3lTEDcyPqH5Er8ffpDjaNxmRZmmmot2jH9ett2LLwCTGdOoMc2xd
IN9n2hiNiSRZIfHz/kVBcXldeFVMpwdF4XmtwL4VuW8X2sAhiU3aFFypJWCN57xM
6Nj6MPJcNBlX0catYl22OzAyxQK10vWU+vpGgS5czxOW81dCYRBFHkLXVH40GEme
mFfhSQEimRggBo5HZlKEHXI8+mUQdXWLueLGJNiLaLbF+gByNHKbkIPQKujqUk0A
6z4gclhO7KSGGwk4XvziwVNCeYNi6dwmbZJ/TBVGi6anUKIWWO9U5DqM8dGbQQYD
gbFzLH+ntAp3W2QzQ2/ws0h0tH6K5RLvw/FGmfdKUFYu8S8EUYHGkSvFqXr6zjcB
p3wlx9t9eDICKhJGqgVaCorU9zAUZUxKFEh3TNpYaK/1M4AHIgAZdAZhqU6SHcty
eAAHbSukO/POS3nt38FW/17N/0K5hJFqgAgMk0NrgzeboORnJaDUGBprlLB/JydD
96qIQ2NhVrRj1oBMVSSzlmDYjC7Irp/KZOwybbYrQe3M4qVeCJ5hVzF1Y+pVTeCO
UOj3YW3tZ9kTvRGBJ0zO
=gZBA
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--

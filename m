Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:35148 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933396AbeGIQOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jul 2018 12:14:45 -0400
Date: Mon, 9 Jul 2018 18:14:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v3 2/2] media: ov772x: use SCCB helpers
Message-ID: <20180709161443.ubxu4el6bp6zgerj@ninjato>
References: <1531150874-4595-1-git-send-email-akinobu.mita@gmail.com>
 <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q6bhdtnqnhemclct"
Content-Disposition: inline
In-Reply-To: <1531150874-4595-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q6bhdtnqnhemclct
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>  static int ov772x_read(struct i2c_client *client, u8 addr)
>  {
> -	int ret;
> -	u8 val;
> -
> -	ret =3D i2c_master_send(client, &addr, 1);
> -	if (ret < 0)
> -		return ret;
> -	ret =3D i2c_master_recv(client, &val, 1);
> -	if (ret < 0)
> -		return ret;
> -
> -	return val;
> +	return sccb_read_byte(client, addr);
>  }
> =20
>  static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 va=
lue)
>  {
> -	return i2c_smbus_write_byte_data(client, addr, value);
> +	return sccb_write_byte(client, addr, value);
>  }

Minor nit: I'd rather drop these two functions and use the
sccb-accessors directly.

However, I really like how this looks here: It is totally clear we are
doing SCCB and hide away all the details.


--q6bhdtnqnhemclct
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAltDifMACgkQFA3kzBSg
KbaPVRAAlDy/Uxnqx+KsTV9vZm8aYx4F2fiUQMYhQRO5EfT/SL9aVRJbSG7qfAPd
OsR8pJvvRcRMK+fsqwsQwMO5d34llJxTMtQxVDzESI5CQOn6tK0+kGhh0FaRJHPP
T4E4bbyvmge3QUbz++RUqrB40eVr2QuUY/5vXl7w99p54NhpOjOSrjvjGZR3p7Mq
lAzuihyDfFSabnb8XXGBgE8WVDfj8HN22Ub0QgwET1vD8LU5l+GDOPgnbmjGI4SM
ZK9UOB3breq1M1TVUrO7rOVs1iNrMb/S+FUfJWUk0WgPDtfBRB7udzcLsVaVDolL
LBnpjzdMfb2xehvXTnCLctWr0CeWy9iyqBooSQaBIfnCVo4F3SjpbaVqyXg7rihK
x9UjsFZ/Y9EtB1VldRRPa+bRUtYNTJSt/+EMG1KXLH12SM1LCjda/lkxsPnTWO3u
z8hLdahM4ubsVzhwIWM5I5RP7woQumY9mTS2KShIZx29C57ui5VK+OWiW1VrUW/f
YLCjf9ndPgfCQxhhk9KX5ckblD8QWYY1MWEaYbZEDUWk8mqQCXRVRzo3KjgjwOIH
acaoxXwL60r2WI+t7sXxyHS6u1AVYcofgl64ZnhnhEV8pmWfk+hJY+OtdUIw90rG
f/RbjVYKRJJjn++ebNwJxuLv0lxBfesDGpBafyBSy1BftHAQETQ=
=kt5+
-----END PGP SIGNATURE-----

--q6bhdtnqnhemclct--

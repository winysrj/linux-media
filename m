Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40018 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933638AbeFLQ2R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 12:28:17 -0400
Date: Tue, 12 Jun 2018 18:28:12 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [RFC PATCH v2] media: i2c: add SCCB helpers
Message-ID: <20180612162812.7w4o4pnhqrr62ze6@earth.universe>
References: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yanlvuhd76bjoglc"
Content-Disposition: inline
In-Reply-To: <1528817686-7067-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yanlvuhd76bjoglc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

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
>=20
> Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> * v2
> - Convert all helpers into static inline functions, and remove C source
>   and Kconfig option.
> - Acquire i2c adapter lock while issuing two requests for sccb_read_byte
>=20
>  drivers/media/i2c/sccb.h | 74 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 drivers/media/i2c/sccb.h
>=20
> diff --git a/drivers/media/i2c/sccb.h b/drivers/media/i2c/sccb.h
> new file mode 100644
> index 0000000..a531fdc
> --- /dev/null
> +++ b/drivers/media/i2c/sccb.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Serial Camera Control Bus (SCCB) helper functions
> + */
> +
> +#ifndef __SCCB_H__
> +#define __SCCB_H__
> +
> +#include <linux/i2c.h>
> +
> +/**
> + * sccb_read_byte - Read data from SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to be read from
> + *
> + * This executes the 2-phase write transmission cycle that is followed b=
y a
> + * 2-phase read transmission cycle, returning negative errno else a data=
 byte
> + * received from the device.
> + */
> +static inline int sccb_read_byte(struct i2c_client *client, u8 addr)
> +{
> +	u8 val;
> +	struct i2c_msg msg[] =3D {
> +		{
> +			.addr =3D client->addr,
> +			.len =3D 1,
> +			.buf =3D &addr,
> +		},
> +		{
> +			.addr =3D client->addr,
> +			.flags =3D I2C_M_RD,
> +			.len =3D 1,
> +			.buf =3D &val,
> +		},
> +	};
> +	int ret;
> +	int i;
> +
> +	i2c_lock_adapter(client->adapter);
> +
> +	/* Issue two separated requests in order to avoid repeated start */
> +	for (i =3D 0; i < 2; i++) {
> +		ret =3D __i2c_transfer(client->adapter, &msg[i], 1);
> +		if (ret !=3D 1)
> +			break;
> +	}
> +
> +	i2c_unlock_adapter(client->adapter);
> +
> +	return i =3D=3D 2 ? val : ret;
> +}
> +
> +/**
> + * sccb_write_byte - Write data to SCCB slave device
> + * @client: Handle to slave device
> + * @addr: Register to write to
> + * @data: Value to be written
> + *
> + * This executes the SCCB 3-phase write transmission cycle, returning ne=
gative
> + * errno else zero on success.
> + */
> +static inline int sccb_write_byte(struct i2c_client *client, u8 addr, u8=
 data)
> +{
> +	int ret;
> +	unsigned char msgbuf[] =3D { addr, data };
> +
> +	ret =3D i2c_master_send(client, msgbuf, 2);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +#endif /* __SCCB_H__ */
> --=20
> 2.7.4
>=20

--yanlvuhd76bjoglc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlsf9JkACgkQ2O7X88g7
+pq2FQ//a40f5EXy3lYRn5iIxdm1AZ3f1yuhwMr7tn5EGbDTyyhIT8e6A6CeNFg+
QFU1bK38MgwVcfOwxOKA7oyw+SNAETsl7yYRSxbo9eI7jbJgp7mrVFby/pbhvhFo
/IIHjQQMdaX7n3MU9B852XvvpByt5FL1y3ipc2W0aWcxSr7WnksioSKJTT3tXzlT
S1P7xtGbcUuDTaIlpy4jsfDbE+nVDqtjtiG3ba6Z64elE+NPXLavVkpg8WJpKN0o
2quPMGsWVARJvtU/tcmfXQa1IkImJ2IbmKSsIUhTDfJGhStvMInw171JoQ4kKaWs
Nth6QXXXPwkc1fwZ/s2BTCcmctngCAJwAk4a6F7UMUaADNG25Q/4yVDRR2uRHgDw
d5iiwGk79QQX1QV7lPmdd9aB82oJ5Y4XRHkzt+ckbav6pJIdzHNqnF8Pm04QzG8H
clJlEQB8//OyCbm1mBac2pBLc9jesgt1VFVjdyQ3FCdBeRZhXeOy0mwvdhb2OGsB
lFgeOV6ilACb0qSvB3z9XI5kRsxPPjnDRvZWWP0I6xrVXCF4FkQQJUGUU2zVUHhz
XCqQ2AqmZzrLNGE3blpFWO+ZexbRKylNw3RlEMPk7AMY6d7LxZVsylcudFhzkRUA
cy07eE0PMzHvIr1HSrGOCtc2d/fEt+hJZ8L37EGUEwqC/XjVIJ0=
=0HON
-----END PGP SIGNATURE-----

--yanlvuhd76bjoglc--

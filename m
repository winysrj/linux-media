Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbcISWvd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:51:33 -0400
Date: Tue, 20 Sep 2016 00:51:28 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 4/5] smiapp: Use runtime PM
Message-ID: <20160919225127.ncjux2ybgqt66axu@earth>
References: <1473938961-16067-5-git-send-email-sakari.ailus@linux.intel.com>
 <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mng6hxhcbac37g6x"
Content-Disposition: inline
In-Reply-To: <1473980009-19377-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mng6hxhcbac37g6x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 16, 2016 at 01:53:29AM +0300, Sakari Ailus wrote:
> [...]
>
> diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/s=
miapp/smiapp-regs.c
> index 1e501c0..a9c7baf 100644
> --- a/drivers/media/i2c/smiapp/smiapp-regs.c
> +++ b/drivers/media/i2c/smiapp/smiapp-regs.c
> @@ -18,6 +18,7 @@
> =20
>  #include <linux/delay.h>
>  #include <linux/i2c.h>
> +#include <linux/pm_runtime.h>
> =20
>  #include "smiapp.h"
>  #include "smiapp-regs.h"
> @@ -288,8 +289,12 @@ int smiapp_write_no_quirk(struct smiapp_sensor *sens=
or, u32 reg, u32 val)
>   */
>  int smiapp_write(struct smiapp_sensor *sensor, u32 reg, u32 val)
>  {
> +	struct i2c_client *client =3D v4l2_get_subdevdata(&sensor->src->sd);
>  	int rval;
> =20
> +	if (pm_runtime_suspended(&client->dev))
> +		return 0;
> +

This looks racy. What if idle countdown runs out immediately after
this check? If you can't call get_sync in this function you can
call pm_runtime_get() before the suspend check and pm_runtime_put
before returning from the function, so that the device keeps being
enabled.

Also I would expect some error code instead of success for early
return due to device being suspended?

>  	rval =3D smiapp_call_quirk(sensor, reg_access, true, &reg, &val);
>  	if (rval =3D=3D -ENOIOCTLCMD)
>  		return 0;
>
> [...]

-- Sebastian

--mng6hxhcbac37g6x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4GvsAAoJENju1/PIO/qaQ1YP/2Y7SSsC+R95++mMlEWEV5of
R3AY2BLmMUS7l8MjSV/vPxlLlaS7H0Ty2MHAXgRGLk2l+zPSduxUKPt86Z+hX56n
ZzG+e/OuQoVNLzKqg6hyJQNssMVfy7AyDWXwlQNf2wSqJ+2xCaqTaXejH89vb1Dp
kBxqPrDA0l0YiH2xw7uCSvKLU1oVFhwJmX6U2khLWyjdB+Ff99uVYUlT6PeKSsY9
Za3ljPyJmPW+tA6LRXX2C5T1KySRmjDkujuKkRHuynjg8l2u4TGj5RXyiTBwqTRA
z3kY6lMeAbRdLQnyZ+sNAXdg9d7yhsYlNK0cwkZjpRAUtgrN6cu+Y6/7T/cNun68
DERZBfGnG5GXT+SY2vuOWLGtKsfdhl8T9RFN+FSMcBmlQFM2i0SMfk/Fd1lKC4xa
paMx8IMD9Bw5ogA3asHCNqdzJGaMoHoAd9qsWjdVNY9dROIxjOxxb0eKeZoZxyUs
8O4cGj483LL6FmqYn3CyOrsG3PhaagJ4ygTbLVoDfYn87qAkxQYmg91/6o6R61l9
dFHQy79e+Gc9VzkkqX8H5vka29h2K/JBIXgGu4QEwonzY6YP9BeG+mKnHZbSHcJn
dM80VuoEOZxB4H2vLxSvSEMmFZdq2D8qsUIHLZhbS5/CGbyaF6PWAopBNCfWvsBR
Qm8Nu1xSj8tO5hNfzrEW
=13+k
-----END PGP SIGNATURE-----

--mng6hxhcbac37g6x--

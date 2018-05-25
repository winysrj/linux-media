Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33618 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934397AbeEYNmC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 09:42:02 -0400
Date: Fri, 25 May 2018 15:41:59 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH v2 2/2] smiapp: Support the "upside-down" property
Message-ID: <20180525134159.ju7dz3dp7wtveswc@earth.universe>
References: <20180525122726.3409-1-sakari.ailus@linux.intel.com>
 <20180525122726.3409-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dhjtmgxncbav75rz"
Content-Disposition: inline
In-Reply-To: <20180525122726.3409-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--dhjtmgxncbav75rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 25, 2018 at 03:27:26PM +0300, Sakari Ailus wrote:
> Use the "upside-down" property to tell that the sensor is mounted upside
> down. This reverses the behaviour of the VFLIP and HFLIP controls as well
> as the pixel order.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Patch subject and description should be s/"upside-down"/"rotation"/g ?

>  .../devicetree/bindings/media/i2c/nokia,smia.txt         |  2 ++
>  drivers/media/i2c/smiapp/smiapp-core.c                   | 16 ++++++++++=
++++++
>  2 files changed, 18 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt b=
/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> index 33f10a94c381..6f509657470e 100644
> --- a/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/nokia,smia.txt
> @@ -29,6 +29,8 @@ Optional properties
>  - reset-gpios: XSHUTDOWN GPIO
>  - flash-leds: See ../video-interfaces.txt
>  - lens-focus: See ../video-interfaces.txt
> +- rotation: Integer property; valid values are 0 (sensor mounted upright)
> +	    and 180 (sensor mounted upside down).
> =20
> =20
>  Endpoint node mandatory properties
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/s=
miapp/smiapp-core.c
> index e1f8208581aa..32286df6ab43 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -2764,6 +2764,7 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(=
struct device *dev)
>  	struct v4l2_fwnode_endpoint *bus_cfg;
>  	struct fwnode_handle *ep;
>  	struct fwnode_handle *fwnode =3D dev_fwnode(dev);
> +	u32 rotation;
>  	int i;
>  	int rval;
> =20
> @@ -2800,6 +2801,21 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig=
(struct device *dev)
> =20
>  	dev_dbg(dev, "lanes %u\n", hwcfg->lanes);
> =20
> +	rval =3D fwnode_property_read_u32(fwnode, "upside-down", &rotation);

"rotation"

> +	if (!rval) {
> +		switch (rotation) {
> +		case 180:
> +			hwcfg->module_board_orient =3D
> +				SMIAPP_MODULE_BOARD_ORIENT_180;
> +			/* Fall through */
> +		case 0:
> +			break;
> +		default:
> +			dev_err(dev, "invalid rotation %u\n", rotation);
> +			goto out_err;
> +		}
> +	}
> +
>  	/* NVM size is not mandatory */
>  	fwnode_property_read_u32(fwnode, "nokia,nvm-size", &hwcfg->nvm_size);

-- Sebastian

--dhjtmgxncbav75rz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlsIEqQACgkQ2O7X88g7
+povKQ//dol6a49oUiScNQN96wjIBLdzZERFor5/ckQqQQnEoKGWYkQM+Zi31CMW
V/bOcOjPvlET38pyrlTsOAEeLLYrZH+Qyb84v1X5fY9l7MdAXKqdCuKkPaSiLfTB
7JUH6je9yOX1EpdMLfD5zZUXhNJsz1joGdtDAAkswt9Pu0i9I0z9dU62mWF9x8XI
0uZnmqIk7U6YSRhggdT0V2ke97Nh1wBK02DL7KX8mSJTrNy1KAJ9rVSlmt829H3k
8YzA7FFSbuE5APEukOpJMUqbIJqoHwVt96m9ho3UCvb9VDRoIQGGd7mmDtxuQqCP
byfDRGyHguzkh4BFFGSrTzbZFAp2TVckVhYB446Eb+lVRzPjfFFxS587sjuQHqXN
Uzv35hdAi3adDiO/XpABVKHM+mY/hxPdAZKQRf6wPqkN1uwBkSGveGKlUH2O3Knl
xAkaiRhsvDeWKsDvQssX1Vyon6SvqLvU2amOJJep9wD39nKWZc3/cfIIY+D6979G
GsH2lLEA9bJq0QK77+xM1WrC1iJrg58Pd46nfxHUs40+JopCtcbIwP5kKjoex+lg
NE0mzeIFWqqm9o1eP3UEq+wIuScfl42GvOyP0mNaRKMiFsvC+EP53aMo7W1i/9gL
umuYH5vOkTGACbFeiSC0V4tlg8m+5o5on1OZH/eBYcRlm1jJPuw=
=y4IG
-----END PGP SIGNATURE-----

--dhjtmgxncbav75rz--

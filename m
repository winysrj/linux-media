Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33910 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936061AbeEYOJ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 10:09:58 -0400
Date: Fri, 25 May 2018 16:09:55 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH v2.2 2/2] smiapp: Support the "rotation" property
Message-ID: <20180525140955.7exw6kqiffpsnzkl@earth.universe>
References: <20180525134055.11121-1-sakari.ailus@linux.intel.com>
 <20180525135235.12386-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="igw2kkayvoaycave"
Content-Disposition: inline
In-Reply-To: <20180525135235.12386-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--igw2kkayvoaycave
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 25, 2018 at 04:52:35PM +0300, Sakari Ailus wrote:
> Use the "rotation" property to tell that the sensor is mounted upside
> down. This reverses the behaviour of the VFLIP and HFLIP controls as well
> as the pixel order.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

> since v2.2:
>=20
> - Fix property name in code.
>=20
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
> index e1f8208581aa..e9e0f21efc2a 100644
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
> +	rval =3D fwnode_property_read_u32(fwnode, "rotation", &rotation);
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
> =20
> --=20
> 2.11.0
>=20

--igw2kkayvoaycave
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlsIGTMACgkQ2O7X88g7
+prv8g/+LU3V96tQYWrEVFBgPnMtaBcsfJY+3B2PJMicJLoh9KBcr67I2bzDYBcn
T3bSDe4z6tlPTkO0JomOaNwicrGmxSKuuJfJ2Y1RBXh7VHA7gY0kRDBRfdAG5l7q
NVsXQEavdc55E8fxjiVJOKknZMOAppz+4+qm8dGUOk90e6h+bMLGzSrG+b3ACjC1
GtrmoyVUFhOmHFyD8aiy1g9EcIkEJkgZBCEaBM+bV6SfWvCWV0CXvDuEiycBK+GP
ic7UFEUwKaqTTOWEyDlSyV93NsEZ5mIpQitFkTLf5u6OIOdlnsJH1VI+BDTbZWX8
jW7FaG1AMnFvqs5/NzicD/VpBZnt7/njkOkUgV8c969a+uB0mhZVPLX92GFEM2np
n87dzT2m+OS7WllBMMjk16O9006nhA+EMqxrtfO89aGXHlNrM3QtNTuwgcbrJ9X/
qA153HyBUKhvMsvS7ccLcauNAe7qx3uBSva8dboZoL3wTIL8eoZTwgTREpioFy76
m/XHXqAKE0CQV7BZe2Shk5Prjorj/sY0DjiDpnFK+J9j0IC2CWD8XYVb1Xucc7XV
F7ZEMunK8+uBpRIGA2luD2T0px821Umr3FcGFjpZNstbWoEUhmSgGpG5R+qLjPtX
RBy3a8hvLRWuihxLtdflkzThBe/uxwKdnaR2sPzlCUDGNHVPwbQ=
=Lz2M
-----END PGP SIGNATURE-----

--igw2kkayvoaycave--

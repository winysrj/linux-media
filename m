Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37040 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdFPMHV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:07:21 -0400
Date: Fri, 16 Jun 2017 14:07:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org
Subject: Re: [PATCH 7/8] smiapp: Add support for flash, lens and EEPROM
 devices
Message-ID: <20170616120712.GA5774@amd>
References: <1497433639-13101-1-git-send-email-sakari.ailus@linux.intel.com>
 <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1497433639-13101-8-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> These types devices aren't directly related to the sensor, but are
> nevertheless handled by the smiapp driver due to the relationship of these
> component to the main part of the camera module --- the sensor.
>=20
> Additionally, for the async sub-device registration to work, the notifier
> containing matching fwnodes will need to be registered. This is natural to
> perform in a sensor driver as well.
>=20
> This does not yet address providing the user space with information on how
> to associate the sensor, lens or EEPROM devices but the kernel now has the
> necessary information to do that.

Let me see... I guess this is going to be quite interesting for me,
too, because I'll be able to remove similar code in omap3 isp driver.

I'm getting same error as the build bot... which is expected as you
did mention it depends on some other series.

(I'll take a look if I can test it easily.)

Acked-by: Pavel Machek <pavel@ucw.cz>


> @@ -2849,6 +2878,45 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig=
(struct device *dev)
> =20
>  	v4l2_fwnode_endpoint_free(bus_cfg);
>  	fwnode_handle_put(ep);
> +
> +	sensor->notifier.subdevs =3D
> +		devm_kcalloc(dev, SMIAPP_MAX_ASYNC_SUBDEVS,
> +			     sizeof(struct v4l2_async_subdev *), GFP_KERNEL);
> +	if (!sensor->notifier.subdevs)
> +		goto out_err;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(props); i++) {
> +		struct device_node *node;
> +		unsigned int j =3D 0;
> +
> +		while ((node =3D of_parse_phandle(dev->of_node, props[i], j++))) {
> +			struct v4l2_async_subdev **asd =3D
> +				 &sensor->notifier.subdevs[
> +					 sensor->notifier.num_subdevs];
> +
> +			if (WARN_ON(sensor->notifier.num_subdevs >=3D
> +				    SMIAPP_MAX_ASYNC_SUBDEVS)) {
> +				of_node_put(node);
> +				goto out;
> +			}
> +
> +			*asd =3D devm_kzalloc(
> +				dev, sizeof(struct v4l2_async_subdev),
> +				GFP_KERNEL);
> +			if (!*asd) {
> +				of_node_put(node);
> +				goto out_err;
> +			}
> +
> +			(*asd)->match.fwnode.fwnode =3D of_fwnode_handle(node);
> +			(*asd)->match_type =3D V4L2_ASYNC_MATCH_FWNODE;
> +			sensor->notifier.num_subdevs++;
> +
> +			of_node_put(node);
> +		}
> +	}
> +
> +out:
>  	return hwcfg;
> =20
>  out_err:
> @@ -2861,18 +2929,17 @@ static int smiapp_probe(struct i2c_client *client,
>  			const struct i2c_device_id *devid)
>  {
>  	struct smiapp_sensor *sensor;
> -	struct smiapp_hwconfig *hwcfg =3D smiapp_get_hwconfig(&client->dev);
>  	unsigned int i;
>  	int rval;
> =20
> -	if (hwcfg =3D=3D NULL)
> -		return -ENODEV;
> -
>  	sensor =3D devm_kzalloc(&client->dev, sizeof(*sensor), GFP_KERNEL);
>  	if (sensor =3D=3D NULL)
>  		return -ENOMEM;
> =20
> -	sensor->hwcfg =3D hwcfg;
> +	sensor->hwcfg =3D smiapp_get_hwconfig(&client->dev, sensor);
> +	if (sensor->hwcfg =3D=3D NULL)
> +		return -ENODEV;
> +
>  	mutex_init(&sensor->mutex);
>  	sensor->src =3D &sensor->ssds[sensor->ssds_used];
> =20
> diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp=
/smiapp.h
> index f74d695..21a55de 100644
> --- a/drivers/media/i2c/smiapp/smiapp.h
> +++ b/drivers/media/i2c/smiapp/smiapp.h
> @@ -20,6 +20,7 @@
>  #define __SMIAPP_PRIV_H_
> =20
>  #include <linux/mutex.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/i2c/smiapp.h>
> @@ -143,6 +144,9 @@ struct smiapp_csi_data_format {
>  	u8 pixel_order;
>  };
> =20
> +/* Lens, EEPROM and a flash LEDs? */
> +#define SMIAPP_MAX_ASYNC_SUBDEVS	3
> +
>  #define SMIAPP_SUBDEVS			3
> =20
>  #define SMIAPP_PA_PAD_SRC		0
> @@ -189,6 +193,7 @@ struct smiapp_sensor {
>  	struct regulator *vana;
>  	struct clk *ext_clk;
>  	struct gpio_desc *xshutdown;
> +	struct v4l2_async_notifier notifier;
>  	u32 limits[SMIAPP_LIMIT_LAST];
>  	u8 nbinning_subtypes;
>  	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllDyfAACgkQMOfwapXb+vJdEQCgogAIcSyrxAuFbGoZmahr30hh
sQ4Ani7tLOAwCx/T/SCggLfDo/2jWDW7
=/xNl
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--

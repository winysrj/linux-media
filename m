Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:36034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026AbbDPFZP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2015 01:25:15 -0400
Date: Thu, 16 Apr 2015 07:24:42 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: pavel@ucw.cz, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v8 1/1] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150416052442.GA31095@earth>
References: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <1429141034-29237-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

Since this driver won't make it into 4.1 anyways, I have one more
comment:

On Thu, Apr 16, 2015 at 02:37:13AM +0300, Sakari Ailus wrote:
> From: Pavel Machek <pavel@ucw.cz>
>=20
> Add device tree support for adp1653 flash LED driver.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> Hi folks,
>=20
> Here's an updated adp1653 DT patch, with changes since v7:
>=20
> - Include of.h and gpio/consumer.h instead of of_gpio.h and gpio.h.
>=20
> - Don't initialise ret as zero in __adp1653_set_power(), check ret only w=
hen
>   it's been set.
>=20
> - Don't check for node non-NULL in adp1653_of_init(). It never is NULL.
>=20
> - Remove temporary variable val in adp1653_of_init().
>=20
> - If the device has no of_node, check that platform data is non-NULL;
>   otherwise return an error.
>=20
> - Assign flash->platform_data only if dev->of_node is NULL.
>=20
>  drivers/media/i2c/adp1653.c |  100 +++++++++++++++++++++++++++++++++++++=
+-----
>  include/media/adp1653.h     |    8 ++--
>  2 files changed, 95 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 873fe19..c70abab 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -8,6 +8,7 @@
>   * Contributors:
>   *	Sakari Ailus <sakari.ailus@iki.fi>
>   *	Tuukka Toivonen <tuukkat76@gmail.com>
> + *	Pavel Machek <pavel@ucw.cz>
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
> @@ -34,6 +35,8 @@
>  #include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
> +#include <linux/of.h>
> +#include <linux/gpio/consumer.h>
>  #include <media/adp1653.h>
>  #include <media/v4l2-device.h>
> =20
> @@ -308,16 +311,28 @@ __adp1653_set_power(struct adp1653_flash *flash, in=
t on)
>  {
>  	int ret;
> =20
> -	ret =3D flash->platform_data->power(&flash->subdev, on);
> -	if (ret < 0)
> -		return ret;
> +	if (flash->platform_data->power) {
> +		ret =3D flash->platform_data->power(&flash->subdev, on);
> +		if (ret < 0)
> +			return ret;
> +	} else {
> +		gpiod_set_value(flash->platform_data->enable_gpio, on);
> +		if (on)
> +			/* Some delay is apparently required. */
> +			udelay(20);
> +	}

I suggest to remove the power callback from platform data. Instead
you can require to setup a gpiod lookup table in the boardcode, if
platform data based initialization is used (see for example si4713
initialization in board-rx51-periphals.c).

This will reduce complexity in the driver and should be fairly easy
to implement, since there is no adp1653 platform code user in the
mainline kernel anyways.

>  	if (!on)
>  		return 0;
> =20
>  	ret =3D adp1653_init_device(flash);
> -	if (ret < 0)
> +	if (ret >=3D 0)
> +		return ret;
> +
> +	if (flash->platform_data->power)
>  		flash->platform_data->power(&flash->subdev, 0);
> +	else
> +		gpiod_set_value(flash->platform_data->enable_gpio, 0);
> =20
>  	return ret;
>  }
> @@ -407,21 +422,85 @@ static int adp1653_resume(struct device *dev)
> =20
>  #endif /* CONFIG_PM */
> =20
> +static int adp1653_of_init(struct i2c_client *client,
> +			   struct adp1653_flash *flash,
> +			   struct device_node *node)
> +{
> +	struct adp1653_platform_data *pd;
> +	struct device_node *child;
> +
> +	pd =3D devm_kzalloc(&client->dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return -ENOMEM;
> +	flash->platform_data =3D pd;
> +
> +	child =3D of_get_child_by_name(node, "flash");
> +	if (!child)
> +		return -EINVAL;
> +
> +	if (of_property_read_u32(child, "flash-timeout-us",
> +				 &pd->max_flash_timeout))
> +		goto err;
> +
> +	if (of_property_read_u32(child, "flash-max-microamp",
> +				 &pd->max_flash_intensity))
> +		goto err;
> +
> +	pd->max_flash_intensity /=3D 1000;
> +
> +	if (of_property_read_u32(child, "led-max-microamp",
> +				 &pd->max_torch_intensity))
> +		goto err;
> +
> +	pd->max_torch_intensity /=3D 1000;
> +	of_node_put(child);
> +
> +	child =3D of_get_child_by_name(node, "indicator");
> +	if (!child)
> +		return -EINVAL;
> +
> +	if (of_property_read_u32(child, "led-max-microamp",
> +				 &pd->max_indicator_intensity))
> +		goto err;
> +
> +	of_node_put(child);
> +
> +	pd->enable_gpio =3D devm_gpiod_get(&client->dev, "enable");
> +	if (!pd->enable_gpio) {
> +		dev_err(&client->dev, "Error getting GPIO\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +err:
> +	dev_err(&client->dev, "Required property not found\n");
> +	of_node_put(child);
> +	return -EINVAL;
> +}
> +
> +
>  static int adp1653_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *devid)
>  {
>  	struct adp1653_flash *flash;
>  	int ret;
> =20
> -	/* we couldn't work without platform data */
> -	if (client->dev.platform_data =3D=3D NULL)
> -		return -ENODEV;
> -
>  	flash =3D devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
>  	if (flash =3D=3D NULL)
>  		return -ENOMEM;
> =20
> -	flash->platform_data =3D client->dev.platform_data;
> +	if (client->dev.of_node) {
> +		ret =3D adp1653_of_init(client, flash, client->dev.of_node);
> +		if (ret)
> +			return ret;
> +	} else {
> +		if (!client->dev.platform_data) {
> +			dev_err(&client->dev,
> +				"Neither DT not platform data provided\n");
> +			return EINVAL;
> +		}
> +		flash->platform_data =3D client->dev.platform_data;
> +	}
> =20
>  	mutex_init(&flash->power_lock);
> =20
> @@ -442,6 +521,7 @@ static int adp1653_probe(struct i2c_client *client,
>  	return 0;
> =20
>  free_and_quit:
> +	dev_err(&client->dev, "adp1653: failed to register device\n");
>  	v4l2_ctrl_handler_free(&flash->ctrls);
>  	return ret;
>  }
> @@ -464,7 +544,7 @@ static const struct i2c_device_id adp1653_id_table[] =
=3D {
>  };
>  MODULE_DEVICE_TABLE(i2c, adp1653_id_table);
> =20
> -static struct dev_pm_ops adp1653_pm_ops =3D {
> +static const struct dev_pm_ops adp1653_pm_ops =3D {
>  	.suspend	=3D adp1653_suspend,
>  	.resume		=3D adp1653_resume,
>  };
> diff --git a/include/media/adp1653.h b/include/media/adp1653.h
> index 1d9b48a..9779c85 100644
> --- a/include/media/adp1653.h
> +++ b/include/media/adp1653.h
> @@ -100,9 +100,11 @@ struct adp1653_platform_data {
>  	int (*power)(struct v4l2_subdev *sd, int on);
> =20
>  	u32 max_flash_timeout;		/* flash light timeout in us */
> -	u32 max_flash_intensity;	/* led intensity, flash mode */
> -	u32 max_torch_intensity;	/* led intensity, torch mode */
> -	u32 max_indicator_intensity;	/* indicator led intensity */
> +	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
> +	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
> +	u32 max_indicator_intensity;	/* indicator led intensity, uA */
> +
> +	struct gpio_desc *enable_gpio;	/* for device-tree based boot */

IMHO this should become part of "struct adp1653_flash", so that
adp1653_platform_data only contains variables, which should be
filled by boardcode / manual DT parsing code.

>  };
> =20
>  #define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subd=
ev)
> --=20
> 1.7.10.4
>=20

-- Sebastian

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVL0eVAAoJENju1/PIO/qa3K8QAKc5DzOtiPgDAm7pvM240xlk
1kf4eXp/MACygEykqkETs288OFzpmetUkVJc8iSWogYzRlvyomGA9hYIAzgScQwK
JThYZUJJW1OmCcG7nWrb0ddOSkCKt1En0CZZ+CWGv+dk2SyML8KKN51VhHpkh/wT
+5aFDH6Jcs1Iwu9TUSgqGSnCgMZCropJbgKGDaEZbG55upYn+BkmT40TvetOJH7x
720vwnabOEThJomP2DHbKtLi3++QqBPO0gIt6/976I/yWVMesrHtIio2GEK53KQ4
MHvRBllccRk/DSbKWuJVVDREe3aZsGiqy5ffKpc7ullrGOsgZMLTR3l1a14u55Uq
mTKauFLI7OHyKtZc0zdEi6Dwf2U7GEaIf4bd59WoGDMYNr8KyO8eWADBKpop7P3B
muyj/28LqF3Qjt6+kjWyxiLzl8e4CrQz0rSRvYUaSmzUXkX8N7HsHNtEPBBEBLgh
+X6TtAIQlcKzQZxcWSwYg1+SzrGEHdZqjQB44jJizUPkOYFdPvQPXjZ0oKlADMLO
2A1MIYM4VRdj+CInbYzV8PnitNz7fW5wY/zPbtkfcclpb2I3YnUHNFbPgQrxGtMq
XZ+HBlpqcbhIu9tCXLwISPmaATdAt8KxwIU/gRyI1PfJsiY+iFcAr27jPFTAfFlj
DeYSK8Z6oNiFv8kKa3QM
=d1WW
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

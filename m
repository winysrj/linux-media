Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:50247 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbeHJKTr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 06:19:47 -0400
Date: Fri, 10 Aug 2018 09:51:00 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: petrcvekcz@gmail.com
Cc: marek.vasut@gmail.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, robert.jarzmik@free.fr,
        slapin@ossfans.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v1 4/5] [media] i2c: drop soc_camera code from ov9640 and
 switch to v4l2_async
Message-ID: <20180810075100.GC7060@w540>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
 <60f150555da249bea9da274ee1e0e30c2d50ca02.1533774451.git.petrcvekcz@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ctP54qlpMx3WjD+/"
Content-Disposition: inline
In-Reply-To: <60f150555da249bea9da274ee1e0e30c2d50ca02.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ctP54qlpMx3WjD+/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Petr,

On Thu, Aug 09, 2018 at 03:39:48AM +0200, petrcvekcz@gmail.com wrote:
> From: Petr Cvek <petrcvekcz@gmail.com>
>
> This patch removes the dependency on an obsoleted soc_camera from ov9640
> driver and changes the code to be a standalone v4l2 async subdevice.
> It also adds GPIO allocations for power and reset signals (as they are not
> handled by soc_camera now).
>
> The patch should make ov9640 again compatible with the pxa_camera driver.

Are there board files using this driverin mainline ? (git grep says so)
Care to port them to use the new driver if necessary? You can have a
look at the SH4 Migo-R board, which recently underwent the same
process (arch/sh/boards/mach-migor/setup.c)

I also suggest to adjust the build system in a single patch with this
changes, but that's not a big deal...

>
> Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
> ---
>  drivers/media/i2c/ov9640.c | 76 ++++++++++++++++++++++++++------------
>  drivers/media/i2c/ov9640.h |  2 +
>  2 files changed, 55 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/media/i2c/ov9640.c b/drivers/media/i2c/ov9640.c
> index c63948989688..44129c60c524 100644
> --- a/drivers/media/i2c/ov9640.c
> +++ b/drivers/media/i2c/ov9640.c
> @@ -9,6 +9,7 @@
>   * Kuninori Morimoto <morimoto.kuninori@renesas.com>
>   *
>   * Based on ov7670 and soc_camera_platform driver,
> + * transition from soc_camera to pxa_camera based on mt9m111
>   *
>   * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
>   * Copyright (C) 2008 Magnus Damm

While at there, drop the license text and add SPDX identifier please

> @@ -27,10 +28,14 @@
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/videodev2.h>
>
> -#include <media/soc_camera.h>
> +#include <media/v4l2-async.h>
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
> +
> +#include <linux/gpio/consumer.h>
>
>  #include "ov9640.h"
>
> @@ -323,11 +328,23 @@ static int ov9640_set_register(struct v4l2_subdev *sd,
>
>  static int ov9640_s_power(struct v4l2_subdev *sd, int on)
>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	struct ov9640_priv *priv = to_ov9640_sensor(sd);
> -
> -	return soc_camera_set_power(&client->dev, ssdd, priv->clk, on);
> +	int ret = 0;
> +
> +	if (on) {
> +		gpiod_set_value(priv->gpio_power, 1);
> +		mdelay(1);

mdelay() is backed by a busy-waiting loop, according to
timers-howto.txt and for milliseconds-long sleeps is not suggested.
Please try to quantify the required delay and use msleep_range().

> +		ret = v4l2_clk_enable(priv->clk);

Is this required by the pxa camera driver using v4l2_clk_ APIs?
Otherwise you should use the clk API directly.

> +		mdelay(1);
> +		gpiod_set_value(priv->gpio_reset, 0);
> +	} else {
> +		gpiod_set_value(priv->gpio_reset, 1);
> +		mdelay(1);
> +		v4l2_clk_disable(priv->clk);
> +		mdelay(1);
> +		gpiod_set_value(priv->gpio_power, 0);
> +	}
> +	return ret;
>  }
>
>  /* select nearest higher resolution for capture */
> @@ -631,14 +648,10 @@ static const struct v4l2_subdev_core_ops ov9640_core_ops = {
>  static int ov9640_g_mbus_config(struct v4l2_subdev *sd,
>  				struct v4l2_mbus_config *cfg)

g_mbus/s_mbus are deprecated. Unless the pxa camera driver wants them
all format negotiation should go through s_fmt/g_fmt pad operations

>  {
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
> -
>  	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_MASTER |
>  		V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_HIGH |
>  		V4L2_MBUS_DATA_ACTIVE_HIGH;
>  	cfg->type = V4L2_MBUS_PARALLEL;
> -	cfg->flags = soc_camera_apply_board_flags(ssdd, cfg);
>
>  	return 0;
>  }
> @@ -667,18 +680,27 @@ static int ov9640_probe(struct i2c_client *client,
>  			const struct i2c_device_id *did)
>  {
>  	struct ov9640_priv *priv;
> -	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	int ret;
>
> -	if (!ssdd) {
> -		dev_err(&client->dev, "Missing platform_data for driver\n");
> -		return -EINVAL;
> -	}
> -
> -	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
> +	priv = devm_kzalloc(&client->dev, sizeof(*priv),
> +			    GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
>
> +	priv->gpio_power = devm_gpiod_get(&client->dev, "Camera power",
> +					  GPIOD_OUT_LOW);
> +	if (IS_ERR_OR_NULL(priv->gpio_power)) {
> +		ret = PTR_ERR(priv->gpio_power);
> +		return ret;
> +	}
> +
> +	priv->gpio_reset = devm_gpiod_get(&client->dev, "Camera reset",
> +					  GPIOD_OUT_HIGH);
> +	if (IS_ERR_OR_NULL(priv->gpio_reset)) {
> +		ret = PTR_ERR(priv->gpio_reset);
> +		return ret;
> +	}
> +
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov9640_subdev_ops);
>
>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
> @@ -692,17 +714,25 @@ static int ov9640_probe(struct i2c_client *client,
>
>  	priv->clk = v4l2_clk_get(&client->dev, "mclk");
>  	if (IS_ERR(priv->clk)) {
> -		ret = PTR_ERR(priv->clk);
> +		ret = -EPROBE_DEFER;

Why are you forcing EPROBE_DEFER instead of returning the clk_get()
return value?

Thanks
   j

>  		goto eclkget;
>  	}
>
>  	ret = ov9640_video_probe(client);
> -	if (ret) {
> -		v4l2_clk_put(priv->clk);
> -eclkget:
> -		v4l2_ctrl_handler_free(&priv->hdl);
> -	}
> +	if (ret)
> +		goto eprobe;
>
> +	priv->subdev.dev = &client->dev;
> +	ret = v4l2_async_register_subdev(&priv->subdev);
> +	if (ret)
> +		goto eprobe;
> +
> +	return 0;
> +
> +eprobe:
> +	v4l2_clk_put(priv->clk);
> +eclkget:
> +	v4l2_ctrl_handler_free(&priv->hdl);
>  	return ret;
>  }
>
> @@ -712,7 +742,7 @@ static int ov9640_remove(struct i2c_client *client)
>  	struct ov9640_priv *priv = to_ov9640_sensor(sd);
>
>  	v4l2_clk_put(priv->clk);
> -	v4l2_device_unregister_subdev(&priv->subdev);
> +	v4l2_async_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);
>  	return 0;
>  }
> diff --git a/drivers/media/i2c/ov9640.h b/drivers/media/i2c/ov9640.h
> index 65d13ff17536..be5e4b29ac69 100644
> --- a/drivers/media/i2c/ov9640.h
> +++ b/drivers/media/i2c/ov9640.h
> @@ -200,6 +200,8 @@ struct ov9640_priv {
>  	struct v4l2_subdev		subdev;
>  	struct v4l2_ctrl_handler	hdl;
>  	struct v4l2_clk			*clk;
> +	struct gpio_desc		*gpio_power;
> +	struct gpio_desc		*gpio_reset;
>
>  	int				model;
>  	int				revision;
> --
> 2.18.0
>

--ctP54qlpMx3WjD+/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbbUPkAAoJEHI0Bo8WoVY8k3YP/Ri9m1TTiknWb6GhfkL7RA5i
zpThF6f2ys5ZW6U+Hpg0EFEfWDGAGkUq75eXIIaUL4AVBuGiDex46bSYQwhQqLAP
OfdJrWd6zEWEICyQV2SN5eDiJsS+Euene7Kl91Pw9t/APKP560SuZOo5x4Pv8x6p
mMe849stNjikWExTLob2m5jZusEGSfwtqS06JMB4r3Af4hp+8/0lEGD4fBa4lieW
3GmqHb8CUCyem0/Q9Vpc5c6Gln6pQCvvRfVMuOvrPBSsCdQtGpBxctLmq1NihcFU
iAgkr3WuQgwojhhn6uuJ2F8w5o8HjEtIRQ6GruAAK65Rmph7+GUD4MYJF8kGxjRs
ViDmailOG2B9L7OFYqmGthLx9jDc9CSh6kuw5OOG6PHUGF1lmFzr572P1QMzgRgv
fQ7P3Qbv4niAjbZ9znZfvynwmPTizT/ZbINVXT4v63IHArh2cHcSuHCyQgx2N3jM
uE+WaRKXr5Z68wJ3+WpIxs01iQ4A+vKSYrZqQNdF/qdjUYT4+a5rVkz3ATOhxOno
zILcd0mkT1VqVwNztCQKJq5LQpfUn8w1A6x15DD8b6XA+kc+/Ykbe+865DbUV4ee
UfVqMIFQqEURf7LYLd67RELzpgSpdpxCVWZkT909l8EEQzt9W/adaNTpsaquU8g9
owoG1By+gWaa4geGWxpQ
=6vva
-----END PGP SIGNATURE-----

--ctP54qlpMx3WjD+/--

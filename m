Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42633 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011AbaLKIKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 03:10:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	m.chehab@samsung.com, linux-arm-kernel@lists.infradead.org,
	s.nawrocki@samsung.com, festevam@gmail.com,
	devicetree@vger.kernel.org
Subject: Re: [v3][PATCH 3/5] media: ov2640: add primary dt support
Date: Thu, 11 Dec 2014 10:10:46 +0200
Message-ID: <2810609.1cJv5BoTgd@avalon>
In-Reply-To: <1418283339-16281-4-git-send-email-josh.wu@atmel.com>
References: <1418283339-16281-1-git-send-email-josh.wu@atmel.com> <1418283339-16281-4-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

I only have three minor comments. After fixing them,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Thursday 11 December 2014 15:35:37 Josh Wu wrote:
> Add device tree support for ov2640.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> v2 -> v3:
>   1. fix gpiod usage.
>   2. refine the ov2640_probe() function.
> 
> v1 -> v2:
>   1. use gpiod APIs.
>   2. change the gpio pin's name according to datasheet.
>   3. reduce the delay for .reset() function.
> 
>  drivers/media/i2c/soc_camera/ov2640.c | 87 +++++++++++++++++++++++++++++---
>  1 file changed, 81 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
> b/drivers/media/i2c/soc_camera/ov2640.c index 9ee910d..e0bcf5b 100644
> --- a/drivers/media/i2c/soc_camera/ov2640.c
> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> @@ -18,6 +18,8 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/videodev2.h>
> 
> @@ -283,6 +285,10 @@ struct ov2640_priv {
>  	u32	cfmt_code;
>  	struct v4l2_clk			*clk;
>  	const struct ov2640_win_size	*win;
> +
> +	struct soc_camera_subdev_desc	ssdd_dt;
> +	struct gpio_desc *resetb_gpio;
> +	struct gpio_desc *pwdn_gpio;
>  };
> 
>  /*
> @@ -1047,6 +1053,63 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
>  	.video	= &ov2640_subdev_video_ops,
>  };
> 
> +/* OF probe functions */
> +static int ov2640_hw_power(struct device *dev, int on)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ov2640_priv *priv = to_ov2640(client);
> +
> +	dev_dbg(&client->dev, "%s: %s the camera\n",
> +			__func__, on ? "ENABLE" : "DISABLE");
> +
> +	if (priv->pwdn_gpio)
> +		gpiod_direction_output(priv->pwdn_gpio, !on);
> +
> +	return 0;
> +}
> +
> +static int ov2640_hw_reset(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ov2640_priv *priv = to_ov2640(client);
> +
> +	if (priv->resetb_gpio) {
> +		/* Active the resetb pin to perform a reset pulse */
> +		gpiod_direction_output(priv->resetb_gpio, 1);
> +		usleep_range(3000, 5000);
> +		gpiod_direction_output(priv->resetb_gpio, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov2640_probe_dt(struct i2c_client *client,
> +		struct ov2640_priv *priv)
> +{
> +	/* reset is not actived */

Do you mean that you configure the reset signal as inactive ? I would state 
that as "Request the reset GPIO deasserted".

> +	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
> +			GPIOD_OUT_LOW);
> +	if (!priv->resetb_gpio)
> +		dev_dbg(&client->dev, "resetb gpio is not assigned!\n");
> +	else if (IS_ERR(priv->resetb_gpio))
> +		return PTR_ERR(priv->resetb_gpio);
> +
> +	/* Power down actived */

And "Request the power down GPIO asserted".

> +	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> +			GPIOD_OUT_HIGH);
> +	if (!priv->pwdn_gpio)
> +		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
> +	else if (IS_ERR(priv->pwdn_gpio))
> +		return PTR_ERR(priv->pwdn_gpio);
> +
> +	/* Initialize the soc_camera_subdev_desc */
> +	priv->ssdd_dt.power = ov2640_hw_power;
> +	priv->ssdd_dt.reset = ov2640_hw_reset;
> +	client->dev.platform_data = &priv->ssdd_dt;
> +
> +	return 0;
> +}
> +
>  /*
>   * i2c_driver functions
>   */
> @@ -1058,12 +1121,6 @@ static int ov2640_probe(struct i2c_client *client,
>  	struct i2c_adapter	*adapter = to_i2c_adapter(client->dev.parent);
>  	int			ret;
> 
> -	if (!ssdd) {
> -		dev_err(&adapter->dev,
> -			"OV2640: Missing platform_data for driver\n");
> -		return -EINVAL;
> -	}
> -
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA)) {
>  		dev_err(&adapter->dev,
>  			"OV2640: I2C-Adapter doesn't support SMBUS\n");
> @@ -1077,6 +1134,17 @@ static int ov2640_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  	}
> 
> +	if (!ssdd && !client->dev.of_node) {
> +		dev_err(&client->dev, "Missing platform_data for driver\n");
> +		return  -EINVAL;
> +	}
> +
> +	if (!ssdd && client->dev.of_node) {

You can just test for !ssdd as you've tested client->dev.of_node above 
already.

> +		ret = ov2640_probe_dt(client, priv);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
> @@ -1123,9 +1191,16 @@ static const struct i2c_device_id ov2640_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov2640_id);
> 
> +static const struct of_device_id ov2640_of_match[] = {
> +	{.compatible = "ovti,ov2640", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ov2640_of_match);
> +
>  static struct i2c_driver ov2640_i2c_driver = {
>  	.driver = {
>  		.name = "ov2640",
> +		.of_match_table = of_match_ptr(ov2640_of_match),
>  	},
>  	.probe    = ov2640_probe,
>  	.remove   = ov2640_remove,

-- 
Regards,

Laurent Pinchart


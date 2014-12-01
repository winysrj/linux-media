Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59907 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLAWcs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 17:32:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] media: ov2640: add primary dt support
Date: Tue, 02 Dec 2014 00:33:21 +0200
Message-ID: <2588866.n5Pjp1h670@avalon>
In-Reply-To: <1417170507-11172-3-git-send-email-josh.wu@atmel.com>
References: <1417170507-11172-1-git-send-email-josh.wu@atmel.com> <1417170507-11172-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Friday 28 November 2014 18:28:25 Josh Wu wrote:
> Add device tree support for ov2640.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  drivers/media/i2c/soc_camera/ov2640.c | 95 +++++++++++++++++++++++++++++---
>  1 file changed, 89 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/ov2640.c
> b/drivers/media/i2c/soc_camera/ov2640.c index 9ee910d..6506126 100644
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
> +	int reset_pin;
> +	int pwr_down_pin;
>  };
> 
>  /*
> @@ -1047,6 +1053,70 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
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
> +	/* enable or disable the camera */
> +	gpio_direction_output(priv->pwr_down_pin, !on);

Isn't there a delay required to wake the chip up ?

> +
> +	return 0;
> +}
> +
> +static int ov2640_hw_reset(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ov2640_priv *priv = to_ov2640(client);
> +

If the reset GPIO isn't specified you should return immediately without 
waiting 120ms.

> +	/* If enabled, give a reset impulse */
> +	gpio_direction_output(priv->reset_pin, 0);
> +	msleep(20);

Please use usleep_range().

> +	gpio_direction_output(priv->reset_pin, 1);
> +	msleep(100);

Is the reset delay documented somewhere ? 100ms seems pretty large to me.

> +
> +	return 0;
> +}
> +
> +static int ov2640_probe_dt(struct i2c_client *client,
> +		struct ov2640_priv *priv)
> +{
> +	struct device_node *np = client->dev.of_node;
> +	int ret;
> +
> +	priv->reset_pin = of_get_named_gpio(np, "reset-gpio", 0);
> +	priv->pwr_down_pin = of_get_named_gpio(np, "power-down-gpio", 0);
> +	if (!gpio_is_valid(priv->reset_pin) ||
> +			!gpio_is_valid(priv->pwr_down_pin))
> +		return -EINVAL;
> +
> +	ret = devm_gpio_request(&client->dev, priv->pwr_down_pin,
> +			"power-down-pin");
> +	if (ret < 0) {
> +		dev_err(&client->dev, "request gpio pin %d failed\n",
> +				priv->pwr_down_pin);
> +		return ret;
> +	}
> +
> +	ret = devm_gpio_request(&client->dev, priv->reset_pin, "reset_pin");
> +	if (ret < 0) {
> +		dev_err(&client->dev, "request gpio pin %d failed\n",
> +				priv->reset_pin);
> +		return ret;
> +	}

Please use the gpiod API with the devm_gpiod_get_index_optional() function, it 
will simply your code and take care about GPIO polarity automatically. Don't 
forget to specify the default state using the GPIOD_* flags.

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
> @@ -1058,12 +1128,6 @@ static int ov2640_probe(struct i2c_client *client,
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
> @@ -1077,6 +1141,18 @@ static int ov2640_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  	}
> 
> +	if (!ssdd) {
> +		if (client->dev.of_node) {
> +			ret = ov2640_probe_dt(client, priv);
> +			if (ret)
> +				return ret;
> +		} else {
> +			dev_err(&client->dev,
> +				"Missing platform_data for driver\n");
> +			return  -EINVAL;
> +		}
> +	}
> +
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
>  	v4l2_ctrl_new_std(&priv->hdl, &ov2640_ctrl_ops,
> @@ -1123,9 +1199,16 @@ static const struct i2c_device_id ov2640_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov2640_id);
> 
> +static const struct of_device_id ov2640_of_match[] = {
> +	{.compatible = "omnivision,ov2640", },
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


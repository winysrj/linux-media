Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52596 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750941AbdAaKbw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:31:52 -0500
Date: Tue, 31 Jan 2017 12:20:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        devicetree@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 10/16] ov2640: enable clock and fix power/reset
Message-ID: <20170131102020.GT7139@valkosipuli.retiisi.org.uk>
References: <20170130140628.18088-1-hverkuil@xs4all.nl>
 <20170130140628.18088-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170130140628.18088-11-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patchset!

On Mon, Jan 30, 2017 at 03:06:22PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Convert v4l2_clk to normal clk, enable the clock and fix the power/reset
> handling.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/ov2640.c | 80 +++++++++++++++++-----------------------------
>  1 file changed, 29 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> index 83f88ef..565742b 100644
> --- a/drivers/media/i2c/ov2640.c
> +++ b/drivers/media/i2c/ov2640.c
> @@ -16,15 +16,14 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/i2c.h>
> +#include <linux/clk.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/gpio.h>
>  #include <linux/gpio/consumer.h>
> -#include <linux/of_gpio.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/videodev2.h>
>  
> -#include <media/v4l2-clk.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-subdev.h>
>  #include <media/v4l2-ctrls.h>
> @@ -284,7 +283,7 @@ struct ov2640_priv {
>  	struct v4l2_subdev		subdev;
>  	struct v4l2_ctrl_handler	hdl;
>  	u32	cfmt_code;
> -	struct v4l2_clk			*clk;
> +	struct clk			*clk;

Nice!

>  	const struct ov2640_win_size	*win;
>  
>  	struct gpio_desc *resetb_gpio;
> @@ -656,8 +655,9 @@ static int ov2640_mask_set(struct i2c_client *client,
>  	return i2c_smbus_write_byte_data(client, reg, val);
>  }
>  
> -static int ov2640_reset(struct i2c_client *client)
> +static int ov2640_reset(struct v4l2_subdev *sd, u32 val)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	int ret;
>  	const struct regval_list reset_seq[] = {
>  		{BANK_SEL, BANK_SEL_SENS},
> @@ -735,21 +735,6 @@ static int ov2640_s_register(struct v4l2_subdev *sd,
>  }
>  #endif
>  
> -static int ov2640_s_power(struct v4l2_subdev *sd, int on)
> -{
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
> -	struct ov2640_priv *priv = to_ov2640(client);
> -
> -	gpiod_direction_output(priv->pwdn_gpio, !on);
> -	if (on && priv->resetb_gpio) {
> -		/* Active the resetb pin to perform a reset pulse */
> -		gpiod_direction_output(priv->resetb_gpio, 1);
> -		usleep_range(3000, 5000);
> -		gpiod_direction_output(priv->resetb_gpio, 0);

Do you still perform the reset sequence somewhere? This could be crucial for
reliability.

> -	}
> -	return 0;
> -}
> -
>  /* Select the nearest higher resolution for capture */
>  static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
>  {
> @@ -769,9 +754,10 @@ static const struct ov2640_win_size *ov2640_select_win(u32 *width, u32 *height)
>  	return &ov2640_supported_win_sizes[default_size];
>  }
>  
> -static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
> +static int ov2640_set_params(struct v4l2_subdev *sd, u32 *width, u32 *height,
>  			     u32 code)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ov2640_priv       *priv = to_ov2640(client);
>  	const struct regval_list *selected_cfmt_regs;
>  	int ret;
> @@ -802,7 +788,7 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>  	}
>  
>  	/* reset hardware */
> -	ov2640_reset(client);
> +	ov2640_reset(sd, 0);
>  
>  	/* initialize the sensor with default data */
>  	dev_dbg(&client->dev, "%s: Init default", __func__);
> @@ -840,7 +826,7 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
>  
>  err:
>  	dev_err(&client->dev, "%s: Error %d", __func__, ret);
> -	ov2640_reset(client);
> +	ov2640_reset(sd, 0);
>  	priv->win = NULL;
>  
>  	return ret;
> @@ -877,7 +863,6 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>  		struct v4l2_subdev_format *format)
>  {
>  	struct v4l2_mbus_framefmt *mf = &format->format;
> -	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
>  	if (format->pad)
>  		return -EINVAL;
> @@ -902,7 +887,7 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
>  	}
>  
>  	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> -		return ov2640_set_params(client, &mf->width,
> +		return ov2640_set_params(sd, &mf->width,
>  					 &mf->height, mf->code);
>  	cfg->try_fmt = *mf;
>  	return 0;
> @@ -947,10 +932,6 @@ static int ov2640_video_probe(struct i2c_client *client)
>  	const char *devname;
>  	int ret;
>  
> -	ret = ov2640_s_power(&priv->subdev, 1);
> -	if (ret < 0)
> -		return ret;
> -
>  	/*
>  	 * check and show product ID and manufacturer ID
>  	 */
> @@ -978,7 +959,6 @@ static int ov2640_video_probe(struct i2c_client *client)
>  	ret = v4l2_ctrl_handler_setup(&priv->hdl);
>  
>  done:
> -	ov2640_s_power(&priv->subdev, 0);
>  	return ret;
>  }
>  
> @@ -991,7 +971,7 @@ static struct v4l2_subdev_core_ops ov2640_subdev_core_ops = {
>  	.g_register	= ov2640_g_register,
>  	.s_register	= ov2640_s_register,
>  #endif
> -	.s_power	= ov2640_s_power,
> +	.reset		= ov2640_reset,

Why?

We have s_power() callback. Shouldn't you run the reset sequence when the
device is powered on?

Few if any bridge / ISP drivers will use the reset op. It should rather be
removed.

>  };
>  
>  static const struct v4l2_subdev_pad_ops ov2640_subdev_pad_ops = {
> @@ -1006,9 +986,17 @@ static struct v4l2_subdev_ops ov2640_subdev_ops = {
>  	.pad	= &ov2640_subdev_pad_ops,
>  };
>  
> -static int ov2640_probe_dt(struct i2c_client *client,
> -		struct ov2640_priv *priv)
> +static int ov2640_init_gpio(struct i2c_client *client,
> +			    struct ov2640_priv *priv)
>  {
> +	/* Request the power down GPIO deasserted */
> +	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> +			GPIOD_OUT_LOW);
> +	if (!priv->pwdn_gpio)
> +		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");

I'm pretty sure not finding a GPIO using devm_gpiod_get_optional() already
produces at least one line of output elsewhere.

> +	else if (IS_ERR(priv->pwdn_gpio))
> +		return PTR_ERR(priv->pwdn_gpio);
> +
>  	/* Request the reset GPIO deasserted */
>  	priv->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
>  			GPIOD_OUT_LOW);
> @@ -1017,14 +1005,6 @@ static int ov2640_probe_dt(struct i2c_client *client,
>  	else if (IS_ERR(priv->resetb_gpio))
>  		return PTR_ERR(priv->resetb_gpio);
>  
> -	/* Request the power down GPIO asserted */
> -	priv->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> -			GPIOD_OUT_HIGH);
> -	if (!priv->pwdn_gpio)
> -		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");

Same here.

> -	else if (IS_ERR(priv->pwdn_gpio))
> -		return PTR_ERR(priv->pwdn_gpio);
> -
>  	return 0;
>  }
>  
> @@ -1051,9 +1031,10 @@ static int ov2640_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  	}
>  
> -	priv->clk = v4l2_clk_get(&client->dev, "xvclk");
> +	priv->clk = clk_get(&client->dev, "xvclk");
>  	if (IS_ERR(priv->clk))
>  		return -EPROBE_DEFER;
> +	clk_prepare_enable(priv->clk);

I wonder V4L2 clock framework did this. This should be done in the s_power()
callback, not here.

>  
>  	if (!client->dev.of_node) {
>  		dev_err(&client->dev, "Missing platform_data for driver\n");
> @@ -1061,9 +1042,9 @@ static int ov2640_probe(struct i2c_client *client,
>  		goto err_clk;
>  	}
>  
> -	ret = ov2640_probe_dt(client, priv);
> +	ret = ov2640_init_gpio(client, priv);
>  	if (ret)
> -		goto err_clk;
> +		return ret;
>  
>  	v4l2_i2c_subdev_init(&priv->subdev, client, &ov2640_subdev_ops);
>  	v4l2_ctrl_handler_init(&priv->hdl, 2);
> @@ -1074,25 +1055,23 @@ static int ov2640_probe(struct i2c_client *client,
>  	priv->subdev.ctrl_handler = &priv->hdl;
>  	if (priv->hdl.error) {
>  		ret = priv->hdl.error;
> -		goto err_clk;
> +		goto err_hdl;
>  	}
>  
>  	ret = ov2640_video_probe(client);
>  	if (ret < 0)
> -		goto err_videoprobe;
> +		goto err_hdl;
>  
>  	ret = v4l2_async_register_subdev(&priv->subdev);
>  	if (ret < 0)
> -		goto err_videoprobe;
> +		goto err_hdl;
>  
>  	dev_info(&adapter->dev, "OV2640 Probed\n");
>  
>  	return 0;
>  
> -err_videoprobe:
> +err_hdl:
>  	v4l2_ctrl_handler_free(&priv->hdl);
> -err_clk:
> -	v4l2_clk_put(priv->clk);
>  	return ret;
>  }
>  
> @@ -1101,9 +1080,8 @@ static int ov2640_remove(struct i2c_client *client)
>  	struct ov2640_priv       *priv = to_ov2640(client);
>  
>  	v4l2_async_unregister_subdev(&priv->subdev);
> -	v4l2_clk_put(priv->clk);
> -	v4l2_device_unregister_subdev(&priv->subdev);
>  	v4l2_ctrl_handler_free(&priv->hdl);

Shouldn't you free the control handler afterwards? I'm not sure if this
makes a lot of difference though.

> +	v4l2_device_unregister_subdev(&priv->subdev);
>  	return 0;
>  }
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

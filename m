Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36710 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751906AbeEGJcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 05:32:22 -0400
Date: Mon, 7 May 2018 12:32:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: i2c: mt9t112: Add device tree support
Message-ID: <20180507093219.hrhaliadccaytenj@valkosipuli.retiisi.org.uk>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524654014-17852-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1524654014-17852-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Apr 25, 2018 at 01:00:14PM +0200, Jacopo Mondi wrote:
> Add support for OF systems to mt9t112 image sensor driver.
> 
> As the devicetree bindings use standard name for 'powerdown' gpio, and while
> at there, update the existing mt9t112 users to use the new name.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/sh/boards/mach-ecovec24/setup.c |  4 +-
>  drivers/media/i2c/mt9t112.c          | 87 +++++++++++++++++++++++++++++++-----
>  2 files changed, 77 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
> index adc61d1..16de9ec 100644
> --- a/arch/sh/boards/mach-ecovec24/setup.c
> +++ b/arch/sh/boards/mach-ecovec24/setup.c
> @@ -480,7 +480,7 @@ static struct gpiod_lookup_table tw9910_gpios = {
>  static struct gpiod_lookup_table mt9t112_0_gpios = {
>  	.dev_id		= "0-003c",
>  	.table		= {
> -		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA3, "standby",
> +		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA3, "powerdown",
>  			    GPIO_ACTIVE_HIGH),
>  	},
>  };
> @@ -488,7 +488,7 @@ static struct gpiod_lookup_table mt9t112_0_gpios = {
>  static struct gpiod_lookup_table mt9t112_1_gpios = {
>  	.dev_id		= "1-003c",
>  	.table		= {
> -		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA4, "standby",
> +		GPIO_LOOKUP("sh7724_pfc", GPIO_PTA4, "powerdown",
>  			    GPIO_ACTIVE_HIGH),
>  	},
>  };
> diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
> index af8cca9..704e7fb 100644
> --- a/drivers/media/i2c/mt9t112.c
> +++ b/drivers/media/i2c/mt9t112.c
> @@ -32,6 +32,7 @@
> 
>  #include <media/i2c/mt9t112.h>
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-fwnode.h>
>  #include <media/v4l2-image-sizes.h>
>  #include <media/v4l2-subdev.h>
> 
> @@ -77,6 +78,15 @@
>  #define VAR(id, offset)  _VAR(id, offset, 0x0000)
>  #define VAR8(id, offset) _VAR(id, offset, 0x8000)
> 
> +/*
> + * Default PLL configuration for 24MHz input clock
> + */
> +static struct mt9t112_platform_data mt9t112_default_pdata_24MHz = {
> +	.divider	= {
> +		0x49, 0x6, 0, 6, 0, 9, 9, 6, 0,
> +	},
> +};
> +
>  /************************************************************************
>   *			struct
>   ***********************************************************************/
> @@ -88,6 +98,7 @@ struct mt9t112_format {
>  };
> 
>  struct mt9t112_priv {
> +	struct device			*dev;
>  	struct v4l2_subdev		 subdev;
>  	struct mt9t112_platform_data	*info;
>  	struct i2c_client		*client;
> @@ -1066,13 +1077,39 @@ static int mt9t112_camera_probe(struct i2c_client *client)
>  	return ret;
>  }
> 
> +static int mt9t112_parse_dt(struct mt9t112_priv *priv)
> +{
> +	struct fwnode_handle *fwnode = dev_fwnode(priv->dev);
> +	struct fwnode_handle *ep;
> +	struct v4l2_fwnode_endpoint vep;
> +	int ret;
> +
> +	ep = fwnode_graph_get_next_endpoint(fwnode, NULL);
> +	if (IS_ERR_OR_NULL(ep)) {
> +		dev_err(priv->dev, "No endpoint registered\n");
> +		return PTR_ERR(ep);
> +	}
> +
> +	ret = v4l2_fwnode_endpoint_parse(ep, &vep);
> +	fwnode_handle_put(ep);
> +	if (ret) {
> +		dev_err(priv->dev, "Unable to parse endpoint: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (vep.bus.parallel.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +		priv->info->flags = MT9T112_FLAG_PCLK_RISING_EDGE;
> +
> +	return 0;
> +}
> +
>  static int mt9t112_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
>  	struct mt9t112_priv *priv;
>  	int ret;
> 
> -	if (!client->dev.platform_data) {
> +	if (!client->dev.of_node && !client->dev.platform_data) {
>  		dev_err(&client->dev, "mt9t112: missing platform data!\n");
>  		return -EINVAL;
>  	}
> @@ -1081,23 +1118,39 @@ static int mt9t112_probe(struct i2c_client *client,
>  	if (!priv)
>  		return -ENOMEM;
> 
> -	priv->info = client->dev.platform_data;
>  	priv->init_done = false;
> -
> -	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> -
> -	priv->clk = devm_clk_get(&client->dev, "extclk");
> -	if (PTR_ERR(priv->clk) == -ENOENT) {
> +	priv->dev = &client->dev;
> +
> +	if (client->dev.platform_data) {
> +		priv->info = client->dev.platform_data;
> +
> +		priv->clk = devm_clk_get(&client->dev, "extclk");

extclk needs to be documented in DT binding documentation.

> +		if (PTR_ERR(priv->clk) == -ENOENT) {
> +			priv->clk = NULL;
> +		} else if (IS_ERR(priv->clk)) {
> +			dev_err(&client->dev,
> +				"Unable to get clock \"extclk\"\n");
> +			return PTR_ERR(priv->clk);
> +		}
> +	} else {
> +		/*
> +		 * External clock frequencies != 24MHz are only supported
> +		 * for non-OF systems.
> +		 */

Shouldn't you actually set the frequency? Or perhaps even better to check
it, and use assigned-clocks and assigned-clock-rates properties?

>  		priv->clk = NULL;
> -	} else if (IS_ERR(priv->clk)) {
> -		dev_err(&client->dev, "Unable to get clock \"extclk\"\n");
> -		return PTR_ERR(priv->clk);
> +		priv->info = &mt9t112_default_pdata_24MHz;
> +
> +		ret = mt9t112_parse_dt(priv);
> +		if (ret)
> +			return ret;
>  	}
> 
> -	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
> +	v4l2_i2c_subdev_init(&priv->subdev, client, &mt9t112_subdev_ops);
> +
> +	priv->standby_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
>  						     GPIOD_OUT_HIGH);
>  	if (IS_ERR(priv->standby_gpio)) {
> -		dev_err(&client->dev, "Unable to get gpio \"standby\"\n");
> +		dev_err(&client->dev, "Unable to get gpio \"powerdown\"\n");
>  		return PTR_ERR(priv->standby_gpio);
>  	}
> 
> @@ -1124,9 +1177,19 @@ static const struct i2c_device_id mt9t112_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, mt9t112_id);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id mt9t112_of_match[] = {
> +	{ .compatible = "micron,mt9t111", },
> +	{ .compatible = "micron,mt9t112", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, mt9t112_of_match);
> +#endif
> +
>  static struct i2c_driver mt9t112_i2c_driver = {
>  	.driver = {
>  		.name = "mt9t112",
> +		.of_match_table = of_match_ptr(mt9t112_of_match),

No need to use of_match_ptr().

>  	},
>  	.probe    = mt9t112_probe,
>  	.remove   = mt9t112_remove,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi

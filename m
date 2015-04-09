Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40350 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750876AbbDIVsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 17:48:23 -0400
Date: Fri, 10 Apr 2015 00:47:39 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@osdl.org>, pali.rohar@gmail.com,
	sre@debian.org, sre@ring0.de,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
	aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
	patrikbachan@gmail.com, galak@codeaurora.org,
	bcousson@baylibre.com, m.chehab@samsung.com,
	devicetree@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Subject: Re: [PATCHv7] media: i2c/adp1653: Devicetree support for adp1653
Message-ID: <20150409214739.GD20756@valkosipuli.retiisi.org.uk>
References: <20150402203417.GA6336@amd>
 <20150403083353.GA21070@amd>
 <20150403113216.GK20756@valkosipuli.retiisi.org.uk>
 <20150403202624.GA4308@amd>
 <20150403213655.GO20756@valkosipuli.retiisi.org.uk>
 <20150404074337.GA31064@amd>
 <20150404102435.GR20756@valkosipuli.retiisi.org.uk>
 <20150404171116.GA15025@Nokia-N900>
 <20150404200307.GS20756@valkosipuli.retiisi.org.uk>
 <20150409074238.GA22603@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150409074238.GA22603@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

(Cc linux-media. Media related patches should be sent there.)

On Thu, Apr 09, 2015 at 09:42:38AM +0200, Pavel Machek wrote:
> 
> Add device tree support for adp1653 flash LED driver.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> ---
> 
> Second part of a patch after documentation was merged.
> 
> Please apply,
> 							Pavel
> 
> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index 873fe19..d703636 100644
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
> +#include <linux/of_gpio.h>
> +#include <linux/gpio.h>

As Sebastian suggested, linux/of.h and linux/gpio/consumer.h should be used.

>  #include <media/adp1653.h>
>  #include <media/v4l2-device.h>
>  
> @@ -306,9 +309,17 @@ adp1653_init_device(struct adp1653_flash *flash)
>  static int
>  __adp1653_set_power(struct adp1653_flash *flash, int on)
>  {
> -	int ret;
> +	int ret = 0;
> +
> +	if (flash->platform_data->power) {
> +		ret = flash->platform_data->power(&flash->subdev, on);
> +	} else {
> +		gpiod_set_value(flash->platform_data->enable_gpio, on);
> +		if (on)
> +			/* Some delay is apparently required. */
> +			udelay(20);
> +	}
>  
> -	ret = flash->platform_data->power(&flash->subdev, on);
>  	if (ret < 0)
>  		return ret;

Please check ret after assigning it. The assignment in declaration is
unnecessary.

>  
> @@ -316,8 +327,13 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
>  		return 0;
>  
>  	ret = adp1653_init_device(flash);
> -	if (ret < 0)
> +	if (ret >= 0)
> +		return ret;
> +
> +	if (flash->platform_data->power)
>  		flash->platform_data->power(&flash->subdev, 0);
> +	else
> +		gpiod_set_value(flash->platform_data->enable_gpio, 0);
>  
>  	return ret;
>  }
> @@ -407,21 +423,78 @@ static int adp1653_resume(struct device *dev)
>  
>  #endif /* CONFIG_PM */
>  
> +static int adp1653_of_init(struct i2c_client *client,
> +			   struct adp1653_flash *flash,
> +			   struct device_node *node)
> +{
> +	u32 val;
> +	struct adp1653_platform_data *pd;
> +	struct device_node *child = NULL;

The NULL assignment can be removed.

> +
> +	if (!node)
> +		return -EINVAL;

node is always non-NULL here; no need to check.

> +
> +	pd = devm_kzalloc(&client->dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return -ENOMEM;
> +	flash->platform_data = pd;
> +
> +	child = of_get_child_by_name(node, "flash");
> +	if (!child)
> +		return -EINVAL;
> +
> +	if (of_property_read_u32(child, "flash-timeout-us", &val))

You could read the values directly to the appropriate struct
adp1653_platform_data field.

> +		goto err;
> +
> +	pd->max_flash_timeout = val;
> +	if (of_property_read_u32(child, "flash-max-microamp", &val))
> +		goto err;
> +	pd->max_flash_intensity = val/1000;
> +
> +	if (of_property_read_u32(child, "max-microamp", &val))
> +		goto err;
> +	pd->max_torch_intensity = val/1000;
> +	of_node_put(child);
> +
> +	child = of_get_child_by_name(node, "indicator");
> +	if (!child)
> +		return -EINVAL;
> +	if (of_property_read_u32(child, "max-microamp", &val))

Let's wait a bit the resolution of the property name. I'm in principle fine
with both. I can do the change once it's been decided, hopefully very soon.

> +		goto err;
> +	pd->max_indicator_intensity = val;
> +
> +	of_node_put(child);
> +
> +	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable");
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
>  
> -	/* we couldn't work without platform data */
> -	if (client->dev.platform_data == NULL)
> -		return -ENODEV;
> -
>  	flash = devm_kzalloc(&client->dev, sizeof(*flash), GFP_KERNEL);
>  	if (flash == NULL)
>  		return -ENOMEM;
>  
>  	flash->platform_data = client->dev.platform_data;

I think it'd be cleaner to make the assignment only if not using of, i.e.
add else branch to the if below.

> +	if (client->dev.of_node) {
> +		ret = adp1653_of_init(client, flash, client->dev.of_node);
> +		if (ret)
> +			return ret;
> +	}
>  
>  	mutex_init(&flash->power_lock);
>  
> @@ -442,6 +515,7 @@ static int adp1653_probe(struct i2c_client *client,
>  	return 0;
>  
>  free_and_quit:
> +	dev_err(&client->dev, "adp1653: failed to register device\n");
>  	v4l2_ctrl_handler_free(&flash->ctrls);
>  	return ret;
>  }
> @@ -464,7 +538,7 @@ static const struct i2c_device_id adp1653_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, adp1653_id_table);
>  
> -static struct dev_pm_ops adp1653_pm_ops = {
> +static const struct dev_pm_ops adp1653_pm_ops = {
>  	.suspend	= adp1653_suspend,
>  	.resume		= adp1653_resume,
>  };
> diff --git a/include/media/adp1653.h b/include/media/adp1653.h
> index 1d9b48a..34b505e 100644
> --- a/include/media/adp1653.h
> +++ b/include/media/adp1653.h
> @@ -100,9 +100,11 @@ struct adp1653_platform_data {
>  	int (*power)(struct v4l2_subdev *sd, int on);
>  
>  	u32 max_flash_timeout;		/* flash light timeout in us */
> -	u32 max_flash_intensity;	/* led intensity, flash mode */
> -	u32 max_torch_intensity;	/* led intensity, torch mode */
> -	u32 max_indicator_intensity;	/* indicator led intensity */
> +	u32 max_flash_intensity;	/* led intensity, flash mode, mA */
> +	u32 max_torch_intensity;	/* led intensity, torch mode, mA */
> +	u32 max_indicator_intensity;	/* indicator led intensity, uA */
> +
> +	struct gpio_desc *enable_gpio;	/* for device-tree based boot */
>  };
>  
>  #define to_adp1653_flash(sd)	container_of(sd, struct adp1653_flash, subdev)
> 

Let me know if you're going to send v8 or if I can make the changes. I think
we're pretty much done then.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35184 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387865AbeIUAZq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:25:46 -0400
Date: Thu, 20 Sep 2018 21:40:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/4] [media] ad5820: Add support for enable pin
Message-ID: <20180920184054.lbd77a3w56cflfym@valkosipuli.retiisi.org.uk>
References: <20180920161912.17063-1-ricardo.ribalda@gmail.com>
 <20180920161912.17063-2-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920161912.17063-2-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thanks for the set! A few comments below...

On Thu, Sep 20, 2018 at 06:19:10PM +0200, Ricardo Ribalda Delgado wrote:
> This patch adds support for a programmable enable pin. It can be used in
> situations where the ANA-vcc is not configurable (dummy-regulator), or
> just to have a more fine control of the power saving.
> 
> The use of the enable pin is optional

Missing period at the end of the sentence.

> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/i2c/Kconfig  |  2 +-
>  drivers/media/i2c/ad5820.c | 20 ++++++++++++++++++++
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index bfdb494686bf..1ba6eaaf58fb 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -321,7 +321,7 @@ config VIDEO_ML86V7667
>  
>  config VIDEO_AD5820
>  	tristate "AD5820 lens voice coil support"
> -	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	depends on GPIOLIB && I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
>  	---help---
>  	  This is a driver for the AD5820 camera lens voice coil.
>  	  It is used for example in Nokia N900 (RX-51).
> diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
> index 22759aaa2dba..20931217e3b1 100644
> --- a/drivers/media/i2c/ad5820.c
> +++ b/drivers/media/i2c/ad5820.c
> @@ -27,6 +27,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/gpio/consumer.h>
>  
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> @@ -55,6 +56,8 @@ struct ad5820_device {
>  	u32 focus_ramp_time;
>  	u32 focus_ramp_mode;
>  
> +	struct gpio_desc *enable_gpio;
> +
>  	struct mutex power_lock;
>  	int power_count;
>  
> @@ -122,6 +125,9 @@ static int ad5820_power_off(struct ad5820_device *coil, bool standby)
>  		ret = ad5820_update_hw(coil);
>  	}
>  
> +	if (coil->enable_gpio)
> +		gpiod_set_value_cansleep(coil->enable_gpio, 0);

gpiod_set_value_cansleep(), as I think most (or all?) similar functions,
are happy with NULL gpio descriptor. You can thus drop the NULL check here
and below.

> +
>  	ret2 = regulator_disable(coil->vana);
>  	if (ret)
>  		return ret;
> @@ -136,6 +142,9 @@ static int ad5820_power_on(struct ad5820_device *coil, bool restore)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (coil->enable_gpio)
> +		gpiod_set_value_cansleep(coil->enable_gpio, 1);
> +
>  	if (restore) {
>  		/* Restore the hardware settings. */
>  		coil->standby = false;
> @@ -146,6 +155,8 @@ static int ad5820_power_on(struct ad5820_device *coil, bool restore)
>  	return 0;
>  
>  fail:
> +	if (coil->enable_gpio)
> +		gpiod_set_value_cansleep(coil->enable_gpio, 0);
>  	coil->standby = true;
>  	regulator_disable(coil->vana);
>  
> @@ -312,6 +323,15 @@ static int ad5820_probe(struct i2c_client *client,
>  		return ret;
>  	}
>  
> +	coil->enable_gpio = devm_gpiod_get_optional(&client->dev, "enable",
> +						    GPIOD_OUT_LOW);
> +	if (IS_ERR(coil->enable_gpio)) {
> +		ret = PTR_ERR(coil->enable_gpio);
> +		if (ret == -EPROBE_DEFER)
> +			dev_err(&client->dev, "could not get enable gpio\n");
> +		return ret;
> +	}
> +
>  	mutex_init(&coil->power_lock);
>  
>  	v4l2_i2c_subdev_init(&coil->subdev, client, &ad5820_ops);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi

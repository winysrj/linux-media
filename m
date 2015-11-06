Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40852 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161222AbbKFU2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Nov 2015 15:28:45 -0500
Date: Fri, 6 Nov 2015 14:28:40 -0600
From: Rob Herring <robh@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] mt9v032: Add reset and standby gpios
Message-ID: <20151106202840.GA19748@rob-hp-laptop>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 06, 2015 at 02:13:43PM +0100, Markus Pargmann wrote:
> Add optional reset and standby gpios. The reset gpio is used to reset
> the chip in power_on().
> 
> The standby gpio is not used currently. It is just unset, so the chip is
> not in standby.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  .../devicetree/bindings/media/i2c/mt9v032.txt      |  2 ++

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/i2c/mt9v032.c                        | 23 ++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> index 202565313e82..100f0ae43269 100644
> --- a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> @@ -20,6 +20,8 @@ Optional Properties:
>  
>  - link-frequencies: List of allowed link frequencies in Hz. Each frequency is
>  	expressed as a 64-bit big-endian integer.
> +- reset-gpios: GPIO handle which is connected to the reset pin of the chip.
> +- standby-gpios: GPIO handle which is connected to the standby pin of the chip.
>  
>  For further reading on port node refer to
>  Documentation/devicetree/bindings/media/video-interfaces.txt.
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index a68ce94ee097..4aefde9634f5 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -24,6 +24,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-mediabus.h>
>  #include <linux/module.h>
> +#include <linux/gpio/consumer.h>
>  
>  #include <media/mt9v032.h>
>  #include <media/v4l2-ctrls.h>
> @@ -251,6 +252,8 @@ struct mt9v032 {
>  
>  	struct regmap *regmap;
>  	struct clk *clk;
> +	struct gpio_desc *reset_gpio;
> +	struct gpio_desc *standby_gpio;
>  
>  	struct mt9v032_platform_data *pdata;
>  	const struct mt9v032_model_info *model;
> @@ -312,16 +315,26 @@ static int mt9v032_power_on(struct mt9v032 *mt9v032)
>  	struct regmap *map = mt9v032->regmap;
>  	int ret;
>  
> +	gpiod_set_value_cansleep(mt9v032->reset_gpio, 1);
> +
>  	ret = clk_set_rate(mt9v032->clk, mt9v032->sysclk);
>  	if (ret < 0)
>  		return ret;
>  
> +	/* system clock has to be enabled before releasing the reset */
>  	ret = clk_prepare_enable(mt9v032->clk);
>  	if (ret)
>  		return ret;
>  
>  	udelay(1);
>  
> +	gpiod_set_value_cansleep(mt9v032->reset_gpio, 0);
> +
> +	/*
> +	 * After releasing reset, it can take up to 1us until the chip is done
> +	 */
> +	udelay(1);
> +
>  	/* Reset the chip and stop data read out */
>  	ret = regmap_write(map, MT9V032_RESET, 1);
>  	if (ret < 0)
> @@ -954,6 +967,16 @@ static int mt9v032_probe(struct i2c_client *client,
>  	if (IS_ERR(mt9v032->clk))
>  		return PTR_ERR(mt9v032->clk);
>  
> +	mt9v032->reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
> +						      GPIOD_OUT_HIGH);
> +	if (IS_ERR(mt9v032->reset_gpio))
> +		return PTR_ERR(mt9v032->reset_gpio);
> +
> +	mt9v032->standby_gpio = devm_gpiod_get_optional(&client->dev, "standby",
> +							GPIOD_OUT_LOW);
> +	if (IS_ERR(mt9v032->standby_gpio))
> +		return PTR_ERR(mt9v032->standby_gpio);
> +
>  	mutex_init(&mt9v032->power_lock);
>  	mt9v032->pdata = pdata;
>  	mt9v032->model = (const void *)did->driver_data;
> -- 
> 2.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44500 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbbKIM2r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 07:28:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] mt9v032: Add reset and standby gpios
Date: Mon, 09 Nov 2015 14:28:56 +0200
Message-ID: <1763974.WDKlRvPG0G@avalon>
In-Reply-To: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
References: <1446815625-18413-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Thank you for the patch.

On Friday 06 November 2015 14:13:43 Markus Pargmann wrote:
> Add optional reset and standby gpios. The reset gpio is used to reset
> the chip in power_on().
> 
> The standby gpio is not used currently. It is just unset, so the chip is
> not in standby.

We could use a gpio hog for this, but given that the standby signal should 
eventually get used, and given that specifying it in DT is a good hardware 
description, that looks good to me.

> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  .../devicetree/bindings/media/i2c/mt9v032.txt      |  2 ++
>  drivers/media/i2c/mt9v032.c                        | 23 +++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt index
> 202565313e82..100f0ae43269 100644
> --- a/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9v032.txt
> @@ -20,6 +20,8 @@ Optional Properties:
> 
>  - link-frequencies: List of allowed link frequencies in Hz. Each frequency
> is expressed as a 64-bit big-endian integer.
> +- reset-gpios: GPIO handle which is connected to the reset pin of the chip.
> +- standby-gpios: GPIO handle which is connected to the standby pin of the
> chip.
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

module.h escaped my vigilance, but let's try to keep headers alphabetically 
sorted.
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

Nitpicking, the driver capitalizes the first letter of comments.

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

The delay isn't necessary if there's no reset GPIO. How about

	if (mt9v032->reset_gpio) {
		gpiod_set_value_cansleep(mt9v032->reset_gpio, 0);

		/* After releasing reset, it can take up to 1us until the
		 * chip is done.
		 */
		udelay(1);
	}

And, according to the datasheet, the delay is 10 SYSCLK periods. 1µs should be 
safe as the minimum SYSCLK frequency is 13 MHz. I'd still mention it in a 
comment, maybe as

		/* After releasing reset we need to wait 10 clock cycles
		 * before accessing the sensor over I2C. As the minimum SYSCLK
		 * frequency is 13MHz, waiting 1µs will be enough in the worst
		 * case.
		 */
		udelay(1);

If you're fine with these changes there's no need to resubmit the patch, I can 
fix it when applying it to my tree.

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

-- 
Regards,

Laurent Pinchart


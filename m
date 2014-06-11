Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48285 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbaFKLjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:39:40 -0400
Message-ID: <1402486778.4107.131.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 36/43] gpio: pca953x: Add reset-gpios property
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:39:38 +0200
In-Reply-To: <1402178205-22697-37-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-37-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
[...]
>  static int pca953x_read_single(struct pca953x_chip *chip, int reg, u32 *val,
> @@ -735,6 +741,26 @@ static int pca953x_probe(struct i2c_client *client,
>  		/* If I2C node has no interrupts property, disable GPIO interrupts */
>  		if (of_find_property(client->dev.of_node, "interrupts", NULL) == NULL)
>  			irq_base = -1;
> +
> +		/* see if we need to de-assert a reset pin */
> +		ret = of_get_named_gpio_flags(client->dev.of_node,
> +					      "reset-gpios", 0,
> +					      &chip->reset_gpio_flags);
> +		if (gpio_is_valid(ret)) {
> +			chip->reset_gpio = ret;
> +			ret = devm_gpio_request_one(&client->dev,
> +						    chip->reset_gpio,
> +						    GPIOF_DIR_OUT,
> +						    "pca953x_reset");
> +			if (ret == 0) {
> +				/* bring chip out of reset */
> +				dev_info(&client->dev, "releasing reset\n");

I think dev_dbg would be more appropriate.

> +				gpio_set_value(chip->reset_gpio,
> +					       (chip->reset_gpio_flags ==
> +						OF_GPIO_ACTIVE_LOW) ? 1 : 0);
> +			}

You could use the gpiod API (include/gpio/consumer.h) here and have it
do the polarity handling automatically.

regards
Philipp


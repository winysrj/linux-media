Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59886 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbcEXMW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 08:22:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dragos Bogdan <dragos.bogdan@analog.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] adv7604: Add support for hardware reset
Date: Tue, 24 May 2016 15:23:13 +0300
Message-ID: <91532796.nYkeRRUBbm@avalon>
In-Reply-To: <1464081202-25043-1-git-send-email-dragos.bogdan@analog.com>
References: <1464081202-25043-1-git-send-email-dragos.bogdan@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dragos,

On Tuesday 24 May 2016 12:13:22 Dragos Bogdan wrote:
> The part can be reset by a low pulse on the RESET pin (i.e. a hardware
> reset) with a minimum width of 5 ms. It is recommended to wait 5 ms after
> the low pulse before an I2C write is performed to the part. For safety
> reasons, the delays will be 10 ms.
> The RESET pin can be tied high, so the GPIO is optional.
> 
> Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
> ---
>  drivers/media/i2c/adv7604.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 41a1bfc..fac0ff1 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -164,6 +164,7 @@ struct adv76xx_state {
>  	struct adv76xx_platform_data pdata;
> 
>  	struct gpio_desc *hpd_gpio[4];
> +	struct gpio_desc *reset_gpio;
> 
>  	struct v4l2_subdev sd;
>  	struct media_pad pads[ADV76XX_PAD_MAX];
> @@ -2996,6 +2997,21 @@ static int configure_regmaps(struct adv76xx_state
> *state) return 0;
>  }
> 
> +static int adv76xx_reset(struct adv76xx_state *state)
> +{
> +	if (state->reset_gpio) {
> +		/* ADV76XX can be reset by a low reset pulse of minimum 5 ms. */
> +		gpiod_set_value_cansleep(state->reset_gpio, 0);
> +		mdelay(10);

A busy loop of 10ms is very long, please use usleep_range() instead. As the 
minimum is 5ms and you're fine with 10ms, you can use usleep_range(5000, 
10000).

> +		gpiod_set_value_cansleep(state->reset_gpio, 1);
> +		/* It is recommended to wait 5 ms after the low pulse before */
> +		/* an I2C write is performed to the ADV76XX. */
> +		mdelay(10);

Ditto.

> +	}
> +
> +	return 0;
> +}
> +
>  static int adv76xx_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
> @@ -3059,6 +3075,12 @@ static int adv76xx_probe(struct i2c_client *client,
>  		if (state->hpd_gpio[i])
>  			v4l_info(client, "Handling HPD %u GPIO\n", i);
>  	}
> +	state->reset_gpio = devm_gpiod_get_optional(&client->dev, "reset",
> +								GPIOD_OUT_HIGH);
> +	if (IS_ERR(state->reset_gpio))
> +		return PTR_ERR(state->reset_gpio);
> +
> +	adv76xx_reset(state);
> 
>  	state->timings = cea640x480;
>  	state->format = adv76xx_format_info(state, MEDIA_BUS_FMT_YUYV8_2X8);

-- 
Regards,

Laurent Pinchart


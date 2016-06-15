Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49345 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbcFOQJ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 12:09:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dragos Bogdan <dragos.bogdan@analog.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2] [media] adv7604: Add support for hardware reset
Date: Wed, 15 Jun 2016 19:09:34 +0300
Message-ID: <1986640.t9SmG4kvzc@avalon>
In-Reply-To: <1464100407-5935-1-git-send-email-dragos.bogdan@analog.com>
References: <1464100407-5935-1-git-send-email-dragos.bogdan@analog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dragos,

Thank you for the patch.

On Tuesday 24 May 2016 17:33:27 Dragos Bogdan wrote:
> The part can be reset by a low pulse on the RESET pin (i.e. a hardware
> reset) with a minimum width of 5 ms. It is recommended to wait 5 ms
> after the low pulse before an I2C write is performed to the part.
> For safety reasons, the delays will be between 5 and 10 ms.
> 
> The RESET pin can be tied high, so the GPIO is optional.
> 
> Signed-off-by: Dragos Bogdan <dragos.bogdan@analog.com>
> ---
> Changes since v1:
>  - Replace mdelay() with usleep_range();
>  - Limit the comments to 75 characters per line.
> 
>  drivers/media/i2c/adv7604.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 41a1bfc..73c79bb 100644
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

Given that the function always returns 0 and that the return value is never 
checked I'd turn it into a void function.

> +{
> +	if (state->reset_gpio) {

Nitpicking, if you write this as

	if (!state->reset_gpio)
		return;

then you can lower the indendation of the following code block. That's a 
matter of style and preferences though, so I'll let you decide what you 
prefer.

Apart from that,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +		/* ADV76XX can be reset by a low reset pulse of minimum 5 ms. */
> +		gpiod_set_value_cansleep(state->reset_gpio, 0);
> +		usleep_range(5000, 10000);
> +		gpiod_set_value_cansleep(state->reset_gpio, 1);
> +		/* It is recommended to wait 5 ms after the low pulse before */
> +		/* an I2C write is performed to the ADV76XX. */
> +		usleep_range(5000, 10000);
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


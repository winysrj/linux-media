Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49658 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbcBIRVo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 12:21:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, hans.verkuil@cisco.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH v4] adv7604: add direct interrupt handling
Date: Tue, 09 Feb 2016 19:22:05 +0200
Message-ID: <6444162.Rd25FHs0Jy@avalon>
In-Reply-To: <1455036019-7066-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1455036019-7066-1-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Tuesday 09 February 2016 17:40:19 Ulrich Hecht wrote:
> When probed from device tree, the i2c client driver can handle the
> interrupt on its own.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
> v4: As suggested by Hans and Lars-Peter, this revision attempts to parse the
> interrupts node to determine polarity, and passes the appropriate flags to
> devm_request_threaded_irq().

I should have replied before you posted v4, sorry about that, but I think this 
is unneeded.

The I2C core retrieves the interrupt with of_irq_get_byname() or of_irq_get(). 
The former calls the latter, and the call stack continues with 
irq_create_of_mapping() and irq_create_fwspec_mapping(). That function will 
call irq_domain_translate() to translate the IRQ spec retrieved from DT to an 
IRQ type, and then set the type with irq_set_irq_type().

If my understanding is correct all the work is done for you already.

The real problem is how to configure the adv7604 interrupt polarity. You can 
simply call irq_get_trigger_type() to retrieve the trigger type, but that 
would leave open the question of what to do if the board includes an inverter 
on the IRQ line. I wonder whether it wouldn't be better to hardcode the IRQ 
polarity on the adv7604 side, and document the DT IRQ flag as the polarity at 
the SoC interrupt pin to match the hardcoded (and documented) polarity at the 
adv7604 pin.

> v3: uses IRQ_RETVAL
> 
> v2: implements the suggested style changes and drops the IRQF_TRIGGER_LOW
> flag, which is handled in the device tree.
> 
> 
>  drivers/media/i2c/adv7604.c | 50 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 49 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 66dbe86..2a1ae6d 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -31,6 +31,8 @@
>  #include <linux/gpio/consumer.h>
>  #include <linux/hdmi.h>
>  #include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -1971,6 +1973,16 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32
> status, bool *handled) return 0;
>  }
> 
> +static irqreturn_t adv76xx_irq_handler(int irq, void *devid)
> +{
> +	struct adv76xx_state *state = devid;
> +	bool handled;
> +
> +	adv76xx_isr(&state->sd, 0, &handled);
> +
> +	return IRQ_RETVAL(handled);
> +}
> +
>  static int adv76xx_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
> {
>  	struct adv76xx_state *state = to_state(sd);
> @@ -2799,6 +2811,7 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) struct device_node *endpoint;
>  	struct device_node *np;
>  	unsigned int flags;
> +	u32 irq[2];
>  	u32 v= -1;
> 
>  	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
> @@ -2844,8 +2857,20 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) state->pdata.op_656_range = 1;
>  	}
> 
> -	/* Disable the interrupt for now as no DT-based board uses it. */
>  	state->pdata.int1_config = ADV76XX_INT1_CONFIG_DISABLED;
> +	if (!of_property_read_u32_array(np, "interrupts", irq, 2)) {
> +		switch (irq[1]) {
> +		case IRQ_TYPE_LEVEL_LOW:
> +			state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_LOW;
> +			break;
> +		case IRQ_TYPE_LEVEL_HIGH:
> +			state->pdata.int1_config = ADV76XX_INT1_CONFIG_ACTIVE_HIGH;
> +			break;
> +		default:
> +			WARN(1, "Unsupported interrupt configuration.");
> +			break;
> +		}
> +	}
> 
>  	/* Use the default I2C addresses. */
>  	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
> @@ -3235,6 +3260,29 @@ static int adv76xx_probe(struct i2c_client *client,
>  	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
>  			client->addr << 1, client->adapter->name);
> 
> +	if (client->irq) {
> +		unsigned long flags = IRQF_ONESHOT;
> +
> +		switch (state->pdata.int1_config) {
> +		case ADV76XX_INT1_CONFIG_ACTIVE_LOW:
> +			flags |= IRQF_TRIGGER_LOW;
> +			break;
> +		case ADV76XX_INT1_CONFIG_ACTIVE_HIGH:
> +			flags |= IRQF_TRIGGER_HIGH;
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		err = devm_request_threaded_irq(&client->dev,
> +						client->irq,
> +						NULL, adv76xx_irq_handler,
> +						flags,
> +						dev_name(&client->dev), state);
> +		if (err)
> +			goto err_entity;
> +	}
> +
>  	err = v4l2_async_register_subdev(sd);
>  	if (err)
>  		goto err_entity;

-- 
Regards,

Laurent Pinchart


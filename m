Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53808 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbcF0J0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:26:44 -0400
Subject: Re: [PATCH v4 2/8] media: adv7604: automatic "default-input"
 selection
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1462975376-491-3-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9ddc9fce-5b1f-53d7-4bc9-d23f92737155@xs4all.nl>
Date: Mon, 27 Jun 2016 11:26:38 +0200
MIME-Version: 1.0
In-Reply-To: <1462975376-491-3-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2016 04:02 PM, Ulrich Hecht wrote:
> From: William Towle <william.towle@codethink.co.uk>
> 
> Add logic such that the "default-input" property becomes unnecessary
> for chips that only have one suitable input (ADV7611 by design, and
> ADV7612 due to commit 7111cddd518f ("[media] media: adv7604: reduce
> support to first (digital) input").
> 
> Additionally, Ian's documentation in commit bf9c82278c34 ("[media]
> media: adv7604: ability to read default input port from DT") states
> that the "default-input" property should reside directly in the node
> for adv7612. Hence, also adjust the parsing to make the implementation
> consistent with this.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/i2c/adv7604.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 41a1bfc..d722c16 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2788,7 +2788,7 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  	struct device_node *np;
>  	unsigned int flags;
>  	int ret;
> -	u32 v;
> +	u32 v = -1;
>  
>  	np = state->i2c_clients[ADV76XX_PAGE_IO]->dev.of_node;
>  
> @@ -2810,6 +2810,22 @@ static int adv76xx_parse_dt(struct adv76xx_state *state)
>  
>  	of_node_put(endpoint);
>  
> +	if (of_property_read_u32(np, "default-input", &v)) {
> +		/* not specified ... can we choose automatically? */
> +		switch (state->info->type) {
> +		case ADV7611:
> +			v = 0;
> +			break;
> +		case ADV7612:
> +			if (state->info->max_port == ADV76XX_PAD_HDMI_PORT_A)
> +				v = 0;
> +			/* else is unhobbled, leave unspecified */

Please add a break here, don't fall through.

What happens when the default_input is unspecified? I don't really like this,
I think that if nothing is specified, then it should just fall back to
input 0.

Note that neither include/media/i2c/adv7604.h nor Documentation/devicetree/bindings/media/i2c/adv7604.txt
say anything about this either.

Regards,

	Hans

> +		default:
> +			break;
> +		}
> +	}
> +	state->pdata.default_input = v;
> +
>  	flags = bus_cfg.bus.parallel.flags;
>  
>  	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> 

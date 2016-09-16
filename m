Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53859 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbcIPJ4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 05:56:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, william.towle@codethink.co.uk,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] media: adv7604: automatic "default-input" selection
Date: Fri, 16 Sep 2016 12:57:21 +0300
Message-ID: <3410700.SJlxHzK90c@avalon>
In-Reply-To: <20160916093942.17213-3-ulrich.hecht+renesas@gmail.com>
References: <20160916093942.17213-1-ulrich.hecht+renesas@gmail.com> <20160916093942.17213-3-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Friday 16 Sep 2016 11:39:42 Ulrich Hecht wrote:
> Fall back to input 0 if "default-input" property is not present.
> 
> Documentation states that the "default-input" property should reside
> directly in the node for adv7612.

Not just fo adv7612.

> Hence, also adjust the parsing to make the implementation consistent with
> this.
> 
> Based on patch by William Towle <william.towle@codethink.co.uk>.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/adv7604.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4003831..055c9df 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state)
> 	if (!of_property_read_u32(endpoint, "default-input", &v))

Should this be removed if the property has to be in the device node and not in 
the endpoint ?

>  		state->pdata.default_input = v;
>  	else
> -		state->pdata.default_input = -1;
> +		state->pdata.default_input = 0;

What was the use case for setting it to -1 ? Is it safe to change that ?

>  	of_node_put(endpoint);
> 
> +	if (!of_property_read_u32(np, "default-input", &v))
> +		state->pdata.default_input = v;
> +
>  	flags = bus_cfg.bus.parallel.flags;
> 
>  	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)

-- 
Regards,

Laurent Pinchart


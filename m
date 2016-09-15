Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51860 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbcIOQmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 12:42:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, william.towle@codethink.co.uk
Subject: Re: [PATCH v8 1/2] media: adv7604: automatic "default-input" selection
Date: Thu, 15 Sep 2016 19:42:53 +0300
Message-ID: <1962610.tCZYpFzJAm@avalon>
In-Reply-To: <20160915132408.20776-2-ulrich.hecht+renesas@gmail.com>
References: <20160915132408.20776-1-ulrich.hecht+renesas@gmail.com> <20160915132408.20776-2-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Thursday 15 Sep 2016 15:24:07 Ulrich Hecht wrote:
> Fall back to input 0 if "default-input" property is not present.
> 
> Additionally, documentation in commit bf9c82278c34 ("[media]
> media: adv7604: ability to read default input port from DT") states
> that the "default-input" property should reside directly in the node
> for adv7612.

Actually it doesn't. The DT bindings specifies "default-input" as an endpoint 
property, even though the example sets it in the device node. That's 
inconsistent so the DT bindings document should be fixed. I believe the 
property should be set in the device node, it doesn't make much sense to have 
different default inputs per port.

> Hence, also adjust the parsing to make the implementation
> consistent with this.
> 
> Based on patch by William Towle <william.towle@codethink.co.uk>.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/i2c/adv7604.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4003831..055c9df 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3077,10 +3077,13 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) if (!of_property_read_u32(endpoint, "default-input", &v))
>  		state->pdata.default_input = v;
>  	else
> -		state->pdata.default_input = -1;
> +		state->pdata.default_input = 0;
> 
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


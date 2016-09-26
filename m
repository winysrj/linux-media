Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56291 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcIZIbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 04:31:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
Cc: hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        magnus.damm@gmail.com, william.towle@codethink.co.uk,
        devicetree@vger.kernel.org, radhey.shyam.pandey@xilinx.com
Subject: Re: [PATCH v2 2/2] media: adv7604: automatic "default-input" selection
Date: Mon, 26 Sep 2016 11:31:04 +0300
Message-ID: <35118931.XClsGmnAtQ@avalon>
In-Reply-To: <1474550340-31455-3-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1474550340-31455-1-git-send-email-ulrich.hecht+renesas@gmail.com> <1474550340-31455-3-git-send-email-ulrich.hecht+renesas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ulrich,

Thank you for the patch.

On Thursday 22 Sep 2016 15:19:00 Ulrich Hecht wrote:
> Documentation states that the "default-input" property should reside
> directly in the node of the device.  This adjusts the parsing to make the
> implementation consistent with the documentation.
> 
> Based on patch by William Towle <william.towle@codethink.co.uk>.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/adv7604.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 4003831..fa7046e 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3074,13 +3074,13 @@ static int adv76xx_parse_dt(struct adv76xx_state
> *state) return ret;
>  	}
> 
> -	if (!of_property_read_u32(endpoint, "default-input", &v))
> +	of_node_put(endpoint);
> +
> +	if (!of_property_read_u32(np, "default-input", &v))
>  		state->pdata.default_input = v;
>  	else
>  		state->pdata.default_input = -1;
> 
> -	of_node_put(endpoint);
> -
>  	flags = bus_cfg.bus.parallel.flags;
> 
>  	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)

-- 
Regards,

Laurent Pinchart


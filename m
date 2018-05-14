Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59620 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeENCqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 22:46:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] media: rcar-vin: Add support for R-Car R8A77995 SoC
Date: Mon, 14 May 2018 05:46:55 +0300
Message-ID: <2337294.rJBFDRl5Yn@avalon>
In-Reply-To: <1526032781-14319-2-git-send-email-jacopo+renesas@jmondi.org>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org> <1526032781-14319-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Friday, 11 May 2018 12:59:37 EEST Jacopo Mondi wrote:
> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
> b/drivers/media/platform/rcar-vin/rcar-core.c index d3072e1..e547ef7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -985,6 +985,10 @@ static const struct rvin_group_route
> _rcar_info_r8a77970_routes[] = { { /* Sentinel */ }
>  };
> 
> +static const struct rvin_group_route _rcar_info_r8a77995_routes[] = {
> +	{ /* Sentinel */ }
> +};
> +
>  static const struct rvin_info rcar_info_r8a77970 = {
>  	.model = RCAR_GEN3,
>  	.use_mc = true,
> @@ -993,6 +997,14 @@ static const struct rvin_info rcar_info_r8a77970 = {
>  	.routes = _rcar_info_r8a77970_routes,
>  };
> 
> +static const struct rvin_info rcar_info_r8a77995 = {
> +	.model = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +	.routes = _rcar_info_r8a77995_routes,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
>  		.compatible = "renesas,vin-r8a7778",
> @@ -1034,6 +1046,10 @@ static const struct of_device_id rvin_of_id_table[] =
> { .compatible = "renesas,vin-r8a77970",
>  		.data = &rcar_info_r8a77970,
>  	},
> +	{
> +		.compatible = "renesas,vin-r8a77995",
> +		.data = &rcar_info_r8a77995,
> +	},
>  	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);


-- 
Regards,

Laurent Pinchart

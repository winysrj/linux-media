Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:47130 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932319AbeGDHgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jul 2018 03:36:39 -0400
Subject: Re: [PATCH v6 10/10] media: rcar-vin: Add support for R-Car R8A77995
 SoC
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1528796612-7387-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1fc42981-2269-d6f5-921d-6730661542c7@xs4all.nl>
Date: Wed, 4 Jul 2018 09:36:34 +0200
MIME-Version: 1.0
In-Reply-To: <1528796612-7387-11-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/18 11:43, Jacopo Mondi wrote:
> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Checkpatch reports:

WARNING: DT compatible string "renesas,vin-r8a77995" appears un-documented -- check ./Documentation/devicetree/bindings/
#29: FILE: drivers/media/platform/rcar-vin/rcar-core.c:1150:
+               .compatible = "renesas,vin-r8a77995",

I'll still accept this series since this compatible string is already used in
a dtsi, but if someone can document this for the bindings?

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index a2d166f..bd99d56 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1045,6 +1045,18 @@ static const struct rvin_info rcar_info_r8a77970 = {
>  	.routes = rcar_info_r8a77970_routes,
>  };
>  
> +static const struct rvin_group_route rcar_info_r8a77995_routes[] = {
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a77995 = {
> +	.model = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +	.routes = rcar_info_r8a77995_routes,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
>  		.compatible = "renesas,vin-r8a7778",
> @@ -1086,6 +1098,10 @@ static const struct of_device_id rvin_of_id_table[] = {
>  		.compatible = "renesas,vin-r8a77970",
>  		.data = &rcar_info_r8a77970,
>  	},
> +	{
> +		.compatible = "renesas,vin-r8a77995",
> +		.data = &rcar_info_r8a77995,
> +	},
>  	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> 

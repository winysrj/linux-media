Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46802 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeEPUxe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 16:53:34 -0400
Received: by mail-wr0-f196.google.com with SMTP id x9-v6so462391wrl.13
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 13:53:34 -0700 (PDT)
Date: Wed, 16 May 2018 22:53:31 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 4/4] media: rcar-vin: Add support for R-Car R8A77995
 SoC
Message-ID: <20180516205331.GE17838@bigcity.dyn.berto.se>
References: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526473016-30559-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526473016-30559-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-05-16 14:16:56 +0200, Jacopo Mondi wrote:
> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index ea74c55..fba8610 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1104,6 +1104,10 @@ static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
>  	{ /* Sentinel */ }
>  };
>  
> +static const struct rvin_group_route _rcar_info_r8a77995_routes[] = {

Nitpick and I see that the error is not yours but present in other but 
not all route declarations. But the intention is not to have a leading _ 
here.  A patch to clean that up for _rcar_info_r8a77965_routes[] and 
_rcar_info_r8a77970_routes[] would be welcome, or I can do it if you are 
over loaded.

> +	{ /* Sentinel */ }
> +};
> +
>  static const struct rvin_info rcar_info_r8a77970 = {
>  	.model = RCAR_GEN3,
>  	.use_mc = true,
> @@ -1112,6 +1116,14 @@ static const struct rvin_info rcar_info_r8a77970 = {
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
> @@ -1153,6 +1165,10 @@ static const struct of_device_id rvin_of_id_table[] = {
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
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:41458 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752866AbeEKKoN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 06:44:13 -0400
Received: by mail-lf0-f67.google.com with SMTP id m17-v6so2116789lfj.8
        for <linux-media@vger.kernel.org>; Fri, 11 May 2018 03:44:13 -0700 (PDT)
Date: Fri, 11 May 2018 12:44:10 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/5] media: rcar-vin: Add support for R-Car R8A77995 SoC
Message-ID: <20180511104410.GB18974@bigcity.dyn.berto.se>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526032781-14319-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526032781-14319-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-11 11:59:37 +0200, Jacopo Mondi wrote:
> Add R-Car R8A77995 SoC to the rcar-vin supported ones.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

I would move this to be the last patch in the series as a indication 
that capture on R8A77995 is now ready to be used. But for the change 
itself.

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3072e1..e547ef7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -985,6 +985,10 @@ static const struct rvin_group_route _rcar_info_r8a77970_routes[] = {
>  	{ /* Sentinel */ }
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
> @@ -1034,6 +1046,10 @@ static const struct of_device_id rvin_of_id_table[] = {
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

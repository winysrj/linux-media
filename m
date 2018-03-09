Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40467 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932068AbeCIPsP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:48:15 -0500
Subject: Re: [PATCH v12 32/33] rcar-vin: enable support for r8a7796
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-33-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1e34a894-bdd6-b095-5133-8976a624bf9e@xs4all.nl>
Date: Fri, 9 Mar 2018 16:48:13 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-33-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:05, Niklas Söderlund wrote:
> Add the SoC specific information for Renesas r8a7796.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 44 +++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index bc116cc0181171e0..0040f92bfdff947a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -931,6 +931,46 @@ static const struct rvin_info rcar_info_r8a7795es1 = {
>  	.routes = rcar_info_r8a7795es1_routes,
>  };
>  
> +static const struct rvin_group_route rcar_info_r8a7796_routes[] = {
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 0, .mask = BIT(0) | BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 0, .mask = BIT(1) | BIT(4) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 1, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 1, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 1, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 1, .vin = 1, .mask = BIT(4) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 2, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 2, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 2, .vin = 2, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 2, .vin = 2, .mask = BIT(4) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 3, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI20, .channel = 1, .vin = 3, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI40, .channel = 3, .vin = 3, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 3, .vin = 3, .mask = BIT(4) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 4, .mask = BIT(0) | BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 4, .mask = BIT(1) | BIT(4) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 5, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 5, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 5, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 1, .vin = 5, .mask = BIT(4) },
> +	{ .csi = RVIN_CSI40, .channel = 0, .vin = 6, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI20, .channel = 0, .vin = 6, .mask = BIT(2) },
> +	{ .csi = RVIN_CSI40, .channel = 2, .vin = 6, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 2, .vin = 6, .mask = BIT(4) },
> +	{ .csi = RVIN_CSI40, .channel = 1, .vin = 7, .mask = BIT(0) },
> +	{ .csi = RVIN_CSI20, .channel = 1, .vin = 7, .mask = BIT(1) },
> +	{ .csi = RVIN_CSI40, .channel = 3, .vin = 7, .mask = BIT(3) },
> +	{ .csi = RVIN_CSI20, .channel = 3, .vin = 7, .mask = BIT(4) },
> +	{ /* Sentinel */ }
> +};
> +
> +static const struct rvin_info rcar_info_r8a7796 = {
> +	.model = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +	.routes = rcar_info_r8a7796_routes,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
>  		.compatible = "renesas,vin-r8a7778",
> @@ -964,6 +1004,10 @@ static const struct of_device_id rvin_of_id_table[] = {
>  		.compatible = "renesas,vin-r8a7795",
>  		.data = &rcar_info_r8a7795,
>  	},
> +	{
> +		.compatible = "renesas,vin-r8a7796",
> +		.data = &rcar_info_r8a7796,
> +	},
>  	{ /* Sentinel */ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58827 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933162AbdIYKre (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:47:34 -0400
Subject: Re: [PATCH v6 24/25] rcar-vin: enable support for r8a7795
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-25-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c69e22ea-f407-a34f-01db-0fe88c69c8c3@xs4all.nl>
Date: Mon, 25 Sep 2017 12:47:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-25-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> Add the SoC specific information for Renesas r8a7795.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/Kconfig     |   2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c | 145 ++++++++++++++++++++++++++++
>  2 files changed, 146 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
> index af4c98b44d2e22cb..8fa7ee468c63afb9 100644
> --- a/drivers/media/platform/rcar-vin/Kconfig
> +++ b/drivers/media/platform/rcar-vin/Kconfig
> @@ -6,7 +6,7 @@ config VIDEO_RCAR_VIN
>  	select V4L2_FWNODE
>  	---help---
>  	  Support for Renesas R-Car Video Input (VIN) driver.
> -	  Supports R-Car Gen2 SoCs.
> +	  Supports R-Car Gen2 and Gen3 SoCs.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called rcar-vin.
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index dec91e2f3ccdbd93..58d903ab9fb83faf 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -21,6 +21,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> +#include <linux/sys_soc.h>
>  
>  #include <media/v4l2-fwnode.h>
>  
> @@ -987,7 +988,139 @@ static const struct rvin_info rcar_info_gen2 = {
>  	.max_height = 2048,
>  };
>  
> +static const struct rvin_info rcar_info_r8a7795 = {
> +	.chip = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +
> +	.num_chsels = 5,
> +	.chsels = {
> +		{
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +		}, {
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI41, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +		},
> +	},
> +};
> +
> +static const struct rvin_info rcar_info_r8a7795es1 = {
> +	.chip = RCAR_GEN3,
> +	.use_mc = true,
> +	.max_width = 4096,
> +	.max_height = 4096,
> +
> +	.num_chsels = 6,
> +	.chsels = {
> +		{
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI21, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI40, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +			{ .csi = RVIN_CSI21, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI40, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI21, .chan = 1 },
> +			{ .csi = RVIN_CSI40, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +			{ .csi = RVIN_CSI21, .chan = 3 },
> +		}, {
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +		}, {
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI21, .chan = 1 },
> +		}, {
> +			{ .csi = RVIN_CSI21, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 0 },
> +			{ .csi = RVIN_CSI20, .chan = 0 },
> +			{ .csi = RVIN_CSI41, .chan = 2 },
> +			{ .csi = RVIN_CSI20, .chan = 2 },
> +			{ .csi = RVIN_CSI21, .chan = 2 },
> +		}, {
> +			{ .csi = RVIN_CSI41, .chan = 1 },
> +			{ .csi = RVIN_CSI20, .chan = 1 },
> +			{ .csi = RVIN_CSI21, .chan = 1 },
> +			{ .csi = RVIN_CSI41, .chan = 3 },
> +			{ .csi = RVIN_CSI20, .chan = 3 },
> +			{ .csi = RVIN_CSI21, .chan = 3 },
> +		},
> +	},
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
> +	{
> +		.compatible = "renesas,vin-r8a7795",
> +		.data = &rcar_info_r8a7795,
> +	},
>  	{
>  		.compatible = "renesas,vin-r8a7794",
>  		.data = &rcar_info_gen2,
> @@ -1020,6 +1153,11 @@ static const struct of_device_id rvin_of_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>  
> +static const struct soc_device_attribute r8a7795es1[] = {
> +	{ .soc_id = "r8a7795", .revision = "ES1.*" },
> +	{ /* sentinel */ }
> +};
> +
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *match;
> @@ -1038,6 +1176,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	vin->dev = &pdev->dev;
>  	vin->info = match->data;
>  
> +	/*
> +	 * Special care is needed on r8a7795 ES1.x since it
> +	 * uses different routing then r8a7795 ES2.0.
> +	 */
> +	if (vin->info == &rcar_info_r8a7795 && soc_device_match(r8a7795es1))
> +		vin->info = &rcar_info_r8a7795es1;
> +
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (mem == NULL)
>  		return -EINVAL;
> 

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53571 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933315AbdIYJor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:44:47 -0400
Subject: Re: [PATCH v6 03/25] rcar-vin: move chip information to own struct
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-4-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2fe2125c-0fa9-3113-dd49-05a4dd5f17d8@xs4all.nl>
Date: Mon, 25 Sep 2017 11:44:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> When Gen3 support is added to the driver more then chip id will be

then -> than

> different for the different Soc. To avoid a lot of if statements in the
> code create a struct chip_info to contain this information.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 49 ++++++++++++++++++++++++-----
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  3 +-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 12 +++++--
>  3 files changed, 53 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index aefbe8e3ccddb3e4..dae38de706b66b64 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -277,14 +277,47 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>   * Platform Device Driver
>   */
>  
> +static const struct rvin_info rcar_info_h1 = {
> +	.chip = RCAR_H1,
> +};
> +
> +static const struct rvin_info rcar_info_m1 = {
> +	.chip = RCAR_M1,
> +};
> +
> +static const struct rvin_info rcar_info_gen2 = {
> +	.chip = RCAR_GEN2,
> +};
> +
>  static const struct of_device_id rvin_of_id_table[] = {
> -	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
> -	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
> -	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
> -	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> -	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> -	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> -	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },
> +	{
> +		.compatible = "renesas,vin-r8a7794",
> +		.data = &rcar_info_gen2,
> +	},
> +	{
> +		.compatible = "renesas,vin-r8a7793",
> +		.data = &rcar_info_gen2,
> +	},
> +	{
> +		.compatible = "renesas,vin-r8a7791",
> +		.data = &rcar_info_gen2,
> +	},
> +	{
> +		.compatible = "renesas,vin-r8a7790",
> +		.data = &rcar_info_gen2,
> +	},
> +	{
> +		.compatible = "renesas,vin-r8a7779",
> +		.data = &rcar_info_h1,
> +	},
> +	{
> +		.compatible = "renesas,vin-r8a7778",
> +		.data = &rcar_info_m1,
> +	},
> +	{
> +		.compatible = "renesas,rcar-gen2-vin",
> +		.data = &rcar_info_gen2,
> +	},
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
> @@ -305,7 +338,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  
>  	vin->dev = &pdev->dev;
> -	vin->chip = (enum chip_id)match->data;
> +	vin->info = match->data;
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (mem == NULL)
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 81ff59c3b4744075..02a08cf5acfce1ce 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -266,7 +266,8 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	pix->sizeimage = max_t(u32, pix->sizeimage,
>  			       rvin_format_sizeimage(pix));
>  
> -	if (vin->chip == RCAR_M1 && pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
> +	if (vin->info->chip == RCAR_M1 &&
> +	    pix->pixelformat == V4L2_PIX_FMT_XBGR32) {
>  		vin_err(vin, "pixel format XBGR32 not supported on M1\n");
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 9d0d4a5001b6ccd8..13466dfd72292fc0 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -88,11 +88,19 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>  
> +/**
> + * struct rvin_info - Information about the particular VIN implementation
> + * @chip:		type of VIN chip
> + */
> +struct rvin_info {
> +	enum chip_id chip;
> +};
> +
>  /**
>   * struct rvin_dev - Renesas VIN device structure
>   * @dev:		(OF) device
>   * @base:		device I/O register space remapped to virtual memory
> - * @chip:		type of VIN chip
> + * @info:		info about VIN instance
>   *
>   * @vdev:		V4L2 video device associated with VIN
>   * @v4l2_dev:		V4L2 device
> @@ -120,7 +128,7 @@ struct rvin_graph_entity {
>  struct rvin_dev {
>  	struct device *dev;
>  	void __iomem *base;
> -	enum chip_id chip;
> +	const struct rvin_info *info;
>  
>  	struct video_device vdev;
>  	struct v4l2_device v4l2_dev;
> 

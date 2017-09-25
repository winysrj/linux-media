Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:53070 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932627AbdIYKEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:04:34 -0400
Subject: Re: [PATCH v6 15/25] rcar-vin: add flag to switch to media controller
 mode
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-16-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <75410683-4bd5-54e4-7d17-0b5378af10b2@xs4all.nl>
Date: Mon, 25 Sep 2017 12:04:31 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-16-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> On Gen3 a media controller API needs to be used to allow userspace to
> configure the subdevices in the pipeline instead of directly controlling
> a single source subdevice, which is and will continue to be the mode of
> operation on Gen2.
> 
> Prepare for these two modes of operation by adding a flag to struct
> rvin_graph_entity which will control which mode to use.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans


> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 6 +++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 65f01b6781c0aefd..fbbb22924cf3a045 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -279,18 +279,21 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  
>  static const struct rvin_info rcar_info_h1 = {
>  	.chip = RCAR_H1,
> +	.use_mc = false,
>  	.max_width = 2048,
>  	.max_height = 2048,
>  };
>  
>  static const struct rvin_info rcar_info_m1 = {
>  	.chip = RCAR_M1,
> +	.use_mc = false,
>  	.max_width = 2048,
>  	.max_height = 2048,
>  };
>  
>  static const struct rvin_info rcar_info_gen2 = {
>  	.chip = RCAR_GEN2,
> +	.use_mc = false,
>  	.max_width = 2048,
>  	.max_height = 2048,
>  };
> @@ -387,7 +390,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  	v4l2_async_notifier_unregister(&vin->notifier);
>  
>  	/* Checks internaly if handlers have been init or not */
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +	if (!vin->info->use_mc)
> +		v4l2_ctrl_handler_free(&vin->ctrl_handler);
>  
>  	rvin_v4l2_remove(vin);
>  
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 94c606f2b8f2f246..819d9c04ed8ffb36 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -77,12 +77,14 @@ struct rvin_graph_entity {
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> + * @use_mc:		use media controller instead of controlling subdevice
>   *
>   * max_width:		max input width the VIN supports
>   * max_height:		max input height the VIN supports
>   */
>  struct rvin_info {
>  	enum chip_id chip;
> +	bool use_mc;
>  
>  	unsigned int max_width;
>  	unsigned int max_height;
> 

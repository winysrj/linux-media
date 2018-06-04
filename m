Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:46321 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbeFDMq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:46:27 -0400
Received: by mail-lf0-f68.google.com with SMTP id j13-v6so20545370lfb.13
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:46:26 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:46:24 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v5 05/10] media: rcar-vin: Cache the mbus configuration
 flags
Message-ID: <20180604124624.GK19674@bigcity.dyn.berto.se>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527583688-314-6-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527583688-314-6-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-29 10:48:03 +0200, Jacopo Mondi wrote:
> Media bus configuration flags and media bus type were so far a property
> of each VIN instance, as the subdevice they were connected to was
> immutable during the whole system life time.
> 
> With the forth-coming introduction of parallel input devices support,
> a VIN instance can have the subdevice it is connected to switched at
> runtime, from a CSI-2 subdevice to a parallel one and viceversa, through
> the modification of links between media entities in the media controller
> graph. To avoid discarding the per-subdevice configuration flags retrieved by
> v4l2_fwnode parsing facilities, cache them in the 'rvin_graph_entity'
> member of each VIN instance, opportunely renamed to 'rvin_parallel_entity'.
> 
> Also modify the register configuration function to take mbus flags into
> account when running on a bus type that supports them.
> 
> The media bus type currently in use will be updated in a follow-up patch
> to the link state change notification function.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 21 ++++++++-----------
>  drivers/media/platform/rcar-vin/rcar-dma.c  | 32 +++++++++++++++++++----------
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 22 ++++++++++++++------
>  3 files changed, 45 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index f7a28e9..fc98986 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -526,30 +526,29 @@ static int rvin_parallel_parse_v4l2(struct device *dev,
>  				    struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = dev_get_drvdata(dev);
> -	struct rvin_graph_entity *rvge =
> -		container_of(asd, struct rvin_graph_entity, asd);
> +	struct rvin_parallel_entity *rvpe =
> +		container_of(asd, struct rvin_parallel_entity, asd);
>  
>  	if (vep->base.port || vep->base.id)
>  		return -ENOTCONN;
>  
> -	vin->mbus_cfg.type = vep->bus_type;
> +	vin->parallel = rvpe;
> +	vin->parallel->mbus_type = vep->bus_type;
>  
> -	switch (vin->mbus_cfg.type) {
> +	switch (vin->parallel->mbus_type) {
>  	case V4L2_MBUS_PARALLEL:
>  		vin_dbg(vin, "Found PARALLEL media bus\n");
> -		vin->mbus_cfg.flags = vep->bus.parallel.flags;
> +		vin->parallel->mbus_flags = vep->bus.parallel.flags;
>  		break;
>  	case V4L2_MBUS_BT656:
>  		vin_dbg(vin, "Found BT656 media bus\n");
> -		vin->mbus_cfg.flags = 0;
> +		vin->parallel->mbus_flags = 0;
>  		break;
>  	default:
>  		vin_err(vin, "Unknown media bus type\n");
>  		return -EINVAL;
>  	}
>  
> -	vin->parallel = rvge;
> -
>  	return 0;
>  }
>  
> @@ -559,7 +558,7 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
>  
>  	ret = v4l2_async_notifier_parse_fwnode_endpoints(
>  		vin->dev, &vin->notifier,
> -		sizeof(struct rvin_graph_entity), rvin_parallel_parse_v4l2);
> +		sizeof(struct rvin_parallel_entity), rvin_parallel_parse_v4l2);
>  	if (ret)
>  		return ret;
>  
> @@ -795,10 +794,6 @@ static int rvin_mc_init(struct rvin_dev *vin)
>  {
>  	int ret;
>  
> -	/* All our sources are CSI-2 */
> -	vin->mbus_cfg.type = V4L2_MBUS_CSI2;
> -	vin->mbus_cfg.flags = 0;
> -
>  	vin->pad.flags = MEDIA_PAD_FL_SINK;
>  	ret = media_entity_pads_init(&vin->vdev.entity, 1, &vin->pad);
>  	if (ret)
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index f1c3585..d2b7002 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -659,8 +659,12 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY8_2X8:
>  		/* BT.656 8bit YCbCr422 or BT.601 8bit YCbCr422 */
> -		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
> -			VNMC_INF_YUV8_BT656 : VNMC_INF_YUV8_BT601;
> +		if (!vin->is_csi &&
> +		    vin->parallel->mbus_type == V4L2_MBUS_BT656)
> +			vnmc |= VNMC_INF_YUV8_BT656;
> +		else
> +			vnmc |= VNMC_INF_YUV8_BT601;
> +
>  		input_is_yuv = true;
>  		break;
>  	case MEDIA_BUS_FMT_RGB888_1X24:
> @@ -668,8 +672,12 @@ static int rvin_setup(struct rvin_dev *vin)
>  		break;
>  	case MEDIA_BUS_FMT_UYVY10_2X10:
>  		/* BT.656 10bit YCbCr422 or BT.601 10bit YCbCr422 */
> -		vnmc |= vin->mbus_cfg.type == V4L2_MBUS_BT656 ?
> -			VNMC_INF_YUV10_BT656 : VNMC_INF_YUV10_BT601;
> +		if (!vin->is_csi &&
> +		    vin->parallel->mbus_type == V4L2_MBUS_BT656)
> +			vnmc |= VNMC_INF_YUV10_BT656;
> +		else
> +			vnmc |= VNMC_INF_YUV10_BT601;
> +
>  		input_is_yuv = true;
>  		break;
>  	default:
> @@ -682,13 +690,15 @@ static int rvin_setup(struct rvin_dev *vin)
>  	else
>  		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
>  
> -	/* Hsync Signal Polarity Select */
> -	if (!(vin->mbus_cfg.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> -		dmr2 |= VNDMR2_HPS;
> +	if (!vin->is_csi) {
> +		/* Hsync Signal Polarity Select */
> +		if (!(vin->parallel->mbus_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW))
> +			dmr2 |= VNDMR2_HPS;
>  
> -	/* Vsync Signal Polarity Select */
> -	if (!(vin->mbus_cfg.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> -		dmr2 |= VNDMR2_VPS;
> +		/* Vsync Signal Polarity Select */
> +		if (!(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
> +			dmr2 |= VNDMR2_VPS;
> +	}
>  
>  	/*
>  	 * Output format
> @@ -734,7 +744,7 @@ static int rvin_setup(struct rvin_dev *vin)
>  
>  	if (vin->info->model == RCAR_GEN3) {
>  		/* Select between CSI-2 and parallel input */
> -		if (vin->mbus_cfg.type == V4L2_MBUS_CSI2)
> +		if (vin->is_csi)
>  			vnmc &= ~VNMC_DPINE;
>  		else
>  			vnmc |= VNMC_DPINE;
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index ebb480f7..8bc3704 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -73,16 +73,22 @@ struct rvin_video_format {
>  };
>  
>  /**
> - * struct rvin_graph_entity - Video endpoint from async framework
> + * struct rvin_parallel_entity - Parallel video input endpoint descriptor
>   * @asd:	sub-device descriptor for async framework
>   * @subdev:	subdevice matched using async framework
> + * @mbus_type:	media bus type
> + * @mbus_flags:	media bus configuration flags
>   * @source_pad:	source pad of remote subdevice
>   * @sink_pad:	sink pad of remote subdevice
> + *
>   */
> -struct rvin_graph_entity {
> +struct rvin_parallel_entity {
>  	struct v4l2_async_subdev asd;
>  	struct v4l2_subdev *subdev;
>  
> +	enum v4l2_mbus_type mbus_type;
> +	unsigned int mbus_flags;
> +
>  	unsigned int source_pad;
>  	unsigned int sink_pad;
>  };
> @@ -146,7 +152,8 @@ struct rvin_info {
>   * @v4l2_dev:		V4L2 device
>   * @ctrl_handler:	V4L2 control handler
>   * @notifier:		V4L2 asynchronous subdevs notifier
> - * @parallel:		entity in the DT for local parallel subdevice
> + *
> + * @parallel:		parallel input subdevice descriptor
>   *
>   * @group:		Gen3 CSI group
>   * @id:			Gen3 group id for this VIN
> @@ -164,7 +171,8 @@ struct rvin_info {
>   * @sequence:		V4L2 buffers sequence number
>   * @state:		keeps track of operation state
>   *
> - * @mbus_cfg:		media bus configuration from DT
> + * @is_csi:		flag to mark the VIN as using a CSI-2 subdevice
> + *
>   * @mbus_code:		media bus format code
>   * @format:		active V4L2 pixel format
>   *
> @@ -182,7 +190,8 @@ struct rvin_dev {
>  	struct v4l2_device v4l2_dev;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	struct v4l2_async_notifier notifier;
> -	struct rvin_graph_entity *parallel;
> +
> +	struct rvin_parallel_entity *parallel;
>  
>  	struct rvin_group *group;
>  	unsigned int id;
> @@ -199,7 +208,8 @@ struct rvin_dev {
>  	unsigned int sequence;
>  	enum rvin_dma_state state;
>  
> -	struct v4l2_mbus_config mbus_cfg;
> +	bool is_csi;
> +
>  	u32 mbus_code;
>  	struct v4l2_pix_format format;
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund

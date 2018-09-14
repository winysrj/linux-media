Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34526 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbeINQAI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 12:00:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] media: vsp1: use periods at the end of comment sentences
Date: Fri, 14 Sep 2018 13:46:24 +0300
Message-ID: <1884612.Xc9YZolMWV@avalon>
In-Reply-To: <20180831144044.31713-7-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com> <20180831144044.31713-7-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 31 August 2018 17:40:44 EEST Kieran Bingham wrote:
> The style of this driver uses periods at the end of sentences in
> comments, but it is applied inconsitently.
> 
> Update a selection of comments which were discovered to be missing their
> period. Also fix the spelling of one usage of 'instantiate'
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/platform/vsp1/vsp1_brx.c    | 4 ++--
>  drivers/media/platform/vsp1/vsp1_drv.c    | 6 +++---
>  drivers/media/platform/vsp1/vsp1_entity.c | 2 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 4 ++--
>  drivers/media/platform/vsp1/vsp1_sru.c    | 2 +-
>  drivers/media/platform/vsp1/vsp1_uds.c    | 6 +++---
>  drivers/media/platform/vsp1/vsp1_video.c  | 2 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 2 +-
>  8 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_brx.c
> b/drivers/media/platform/vsp1/vsp1_brx.c index 359917b5d842..5e50178b057d
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_brx.c
> +++ b/drivers/media/platform/vsp1/vsp1_brx.c
> @@ -153,7 +153,7 @@ static int brx_set_format(struct v4l2_subdev *subdev,
>  	format = vsp1_entity_get_pad_format(&brx->entity, config, fmt->pad);
>  	*format = fmt->format;
> 
> -	/* Reset the compose rectangle */
> +	/* Reset the compose rectangle. */
>  	if (fmt->pad != brx->entity.source_pad) {
>  		struct v4l2_rect *compose;
> 
> @@ -164,7 +164,7 @@ static int brx_set_format(struct v4l2_subdev *subdev,
>  		compose->height = format->height;
>  	}
> 
> -	/* Propagate the format code to all pads */
> +	/* Propagate the format code to all pads. */
>  	if (fmt->pad == BRX_PAD_SINK(0)) {
>  		unsigned int i;
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> b/drivers/media/platform/vsp1/vsp1_drv.c index b6619c9c18bb..249963cb2ec0
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -802,7 +802,7 @@ static int vsp1_probe(struct platform_device *pdev)
> 
>  	platform_set_drvdata(pdev, vsp1);
> 
> -	/* I/O and IRQ resources (clock managed by the clock PM domain) */
> +	/* I/O and IRQ resources (clock managed by the clock PM domain). */
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
>  	if (IS_ERR(vsp1->mmio))
> @@ -821,7 +821,7 @@ static int vsp1_probe(struct platform_device *pdev)
>  		return ret;
>  	}
> 
> -	/* FCP (optional) */
> +	/* FCP (optional). */
>  	fcp_node = of_parse_phandle(pdev->dev.of_node, "renesas,fcp", 0);
>  	if (fcp_node) {
>  		vsp1->fcp = rcar_fcp_get(fcp_node);
> @@ -869,7 +869,7 @@ static int vsp1_probe(struct platform_device *pdev)
> 
>  	dev_dbg(&pdev->dev, "IP version 0x%08x\n", vsp1->version);
> 
> -	/* Instanciate entities */
> +	/* Instantiate entities. */
>  	ret = vsp1_create_entities(vsp1);
>  	if (ret < 0) {
>  		dev_err(&pdev->dev, "failed to create entities\n");
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c
> b/drivers/media/platform/vsp1/vsp1_entity.c index
> 36a29e13109e..a54ab528b060 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -404,7 +404,7 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev
> *subdev, format = vsp1_entity_get_pad_format(entity, config,
> entity->source_pad); *format = fmt->format;
> 
> -	/* Reset the crop and compose rectangles */
> +	/* Reset the crop and compose rectangles. */
>  	selection = vsp1_entity_get_pad_selection(entity, config, fmt->pad,
>  						  V4L2_SEL_TGT_CROP);
>  	selection->left = 0;
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index f8005b60b9d2..616afa7e165f
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -108,7 +108,7 @@ static void rpf_configure_stream(struct vsp1_entity
> *entity, vsp1_rpf_write(rpf, dlb, VI6_RPF_INFMT, infmt);
>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_DSWAP, fmtinfo->swap);
> 
> -	/* Output location */
> +	/* Output location. */
>  	if (pipe->brx) {
>  		const struct v4l2_rect *compose;
> 
> @@ -309,7 +309,7 @@ static void rpf_configure_partition(struct vsp1_entity
> *entity,
> 
>  	/*
>  	 * Interlaced pipelines will use the extended pre-cmd to process
> -	 * SRCM_ADDR_{Y,C0,C1}
> +	 * SRCM_ADDR_{Y,C0,C1}.
>  	 */
>  	if (pipe->interlaced) {
>  		vsp1_rpf_configure_autofld(rpf, dl);
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c
> b/drivers/media/platform/vsp1/vsp1_sru.c index 2a40e09b9aa7..f48b085b5b5e
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -339,7 +339,7 @@ static void sru_partition(struct vsp1_entity *entity,
>  	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
>  					    SRU_PAD_SOURCE);
> 
> -	/* Adapt if SRUx2 is enabled */
> +	/* Adapt if SRUx2 is enabled. */
>  	if (input->width != output->width) {
>  		window->width /= 2;
>  		window->left /= 2;
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index 7c11651db5d4..c704bdaf4edc
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -314,13 +314,13 @@ static void uds_configure_partition(struct vsp1_entity
> *entity, output = vsp1_entity_get_pad_format(&uds->entity,
> uds->entity.config, UDS_PAD_SOURCE);
> 
> -	/* Input size clipping */
> +	/* Input size clipping. */
>  	vsp1_uds_write(uds, dlb, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
>  		       (0 << VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
>  		       (partition->uds_sink.width
>  				<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
> 
> -	/* Output size clipping */
> +	/* Output size clipping. */
>  	vsp1_uds_write(uds, dlb, VI6_UDS_CLIP_SIZE,
>  		       (partition->uds_source.width
>  				<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
> @@ -374,7 +374,7 @@ static void uds_partition(struct vsp1_entity *entity,
>  	const struct v4l2_mbus_framefmt *output;
>  	const struct v4l2_mbus_framefmt *input;
> 
> -	/* Initialise the partition state */
> +	/* Initialise the partition state. */
>  	partition->uds_sink = *window;
>  	partition->uds_source = *window;
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 9404d7968371..c114cc4d2349
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -891,7 +891,7 @@ static void vsp1_video_cleanup_pipeline(struct
> vsp1_pipeline *pipe) pipe->stream_config = NULL;
>  	pipe->configured = false;
> 
> -	/* Release our partition table allocation */
> +	/* Release our partition table allocation. */
>  	kfree(pipe->part_table);
>  	pipe->part_table = NULL;
>  }
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index c2a1a7f97e26..32bb207b2007
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -317,7 +317,7 @@ static void wpf_configure_stream(struct vsp1_entity
> *entity,
> 
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
> 
> -	/* Enable interrupts */
> +	/* Enable interrupts. */
>  	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
>  	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
>  			   VI6_WFP_IRQ_ENB_DFEE);


-- 
Regards,

Laurent Pinchart

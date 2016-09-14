Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:36047 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756249AbcINT1h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 15:27:37 -0400
Received: by mail-lf0-f48.google.com with SMTP id g62so17532095lfe.3
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 12:27:36 -0700 (PDT)
Date: Wed, 14 Sep 2016 21:27:33 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 11/13] v4l: vsp1: Determine partition requirements for
 scaled images
Message-ID: <20160914192733.GL739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473808626-19488-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1473808626-19488-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-14 02:17:04 +0300, Laurent Pinchart wrote:
> From: Kieran Bingham <kieran+renesas@bingham.xyz>
> 
> The partition algorithm needs to determine the capabilities of each
> entity in the pipeline to identify the correct maximum partition width.
> 
> Extend the vsp1 entity operations to provide a max_width operation and
> use this call to calculate the number of partitions that will be
> processed by the algorithm.
> 
> Gen 2 hardware does not require multiple partitioning, and as such
> will always return a single partition.
> 
> Signed-off-by: Kieran Bingham <kieran+renesas@bingham.xyz>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

I can't find the information about the partition limitations for SRU or 
UDS in any of the documents I have. But for the parts not relating to 
the logic of figuring out the hscale from the input/output formats 
width:

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/vsp1/vsp1_entity.h |  3 +++
>  drivers/media/platform/vsp1/vsp1_pipe.h   |  5 ++++
>  drivers/media/platform/vsp1/vsp1_sru.c    | 19 +++++++++++++++
>  drivers/media/platform/vsp1/vsp1_uds.c    | 25 +++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_video.c  | 40 +++++++++++++++++++++++++++++++
>  5 files changed, 92 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index 0e3e394c44cd..90a4d95c0a50 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -77,11 +77,14 @@ struct vsp1_route {
>   * @destroy:	Destroy the entity.
>   * @configure:	Setup the hardware based on the entity state (pipeline, formats,
>   *		selection rectangles, ...)
> + * @max_width:	Return the max supported width of data that the entity can
> + *		process in a single operation.
>   */
>  struct vsp1_entity_operations {
>  	void (*destroy)(struct vsp1_entity *);
>  	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
>  			  struct vsp1_dl_list *, enum vsp1_entity_params);
> +	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
>  };
>  
>  struct vsp1_entity {
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
> index d20d997b1fda..af4cd23d399b 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -77,6 +77,8 @@ enum vsp1_pipeline_state {
>   * @uds_input: entity at the input of the UDS, if the UDS is present
>   * @entities: list of entities in the pipeline
>   * @dl: display list associated with the pipeline
> + * @div_size: The maximum allowed partition size for the pipeline
> + * @partitions: The number of partitions used to process one frame
>   */
>  struct vsp1_pipeline {
>  	struct media_pipeline pipe;
> @@ -104,6 +106,9 @@ struct vsp1_pipeline {
>  	struct list_head entities;
>  
>  	struct vsp1_dl_list *dl;
> +
> +	unsigned int div_size;
> +	unsigned int partitions;
>  };
>  
>  void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
> diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
> index 9d4a1afb6634..b4e568a3b4ed 100644
> --- a/drivers/media/platform/vsp1/vsp1_sru.c
> +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> @@ -306,8 +306,27 @@ static void sru_configure(struct vsp1_entity *entity,
>  	vsp1_sru_write(sru, dl, VI6_SRU_CTRL2, param->ctrl2);
>  }
>  
> +static unsigned int sru_max_width(struct vsp1_entity *entity,
> +				  struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_sru *sru = to_sru(&entity->subdev);
> +	struct v4l2_mbus_framefmt *input;
> +	struct v4l2_mbus_framefmt *output;
> +
> +	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
> +					   SRU_PAD_SINK);
> +	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
> +					    SRU_PAD_SOURCE);
> +
> +	if (input->width != output->width)
> +		return 512;
> +	else
> +		return 256;
> +}
> +
>  static const struct vsp1_entity_operations sru_entity_ops = {
>  	.configure = sru_configure,
> +	.max_width = sru_max_width,
>  };
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
> index 62beae5d6944..706b6e85f47d 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -311,8 +311,33 @@ static void uds_configure(struct vsp1_entity *entity,
>  		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
>  }
>  
> +static unsigned int uds_max_width(struct vsp1_entity *entity,
> +				  struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_uds *uds = to_uds(&entity->subdev);
> +	const struct v4l2_mbus_framefmt *output;
> +	const struct v4l2_mbus_framefmt *input;
> +	unsigned int hscale;
> +
> +	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
> +					   UDS_PAD_SINK);
> +	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
> +					    UDS_PAD_SOURCE);
> +	hscale = output->width / input->width;
> +
> +	if (hscale <= 2)
> +		return 256;
> +	else if (hscale <= 4)
> +		return 512;
> +	else if (hscale <= 8)
> +		return 1024;
> +	else
> +		return 2048;
> +}
> +
>  static const struct vsp1_entity_operations uds_entity_ops = {
>  	.configure = uds_configure,
> +	.max_width = uds_max_width,
>  };
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index b8339d874df4..b903cc5471e0 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -169,6 +169,43 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
>  }
>  
>  /* -----------------------------------------------------------------------------
> + * VSP1 Partition Algorithm support
> + */
> +
> +static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
> +	const struct v4l2_mbus_framefmt *format;
> +	struct vsp1_entity *entity;
> +	unsigned int div_size;
> +
> +	format = vsp1_entity_get_pad_format(&pipe->output->entity,
> +					    pipe->output->entity.config,
> +					    RWPF_PAD_SOURCE);
> +	div_size = format->width;
> +
> +	/* Gen2 hardware doesn't require image partitioning. */
> +	if (vsp1->info->gen == 2) {
> +		pipe->div_size = div_size;
> +		pipe->partitions = 1;
> +		return;
> +	}
> +
> +	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> +		unsigned int entity_max = VSP1_VIDEO_MAX_WIDTH;
> +
> +		if (entity->ops->max_width) {
> +			entity_max = entity->ops->max_width(entity, pipe);
> +			if (entity_max)
> +				div_size = min(div_size, entity_max);
> +		}
> +	}
> +
> +	pipe->div_size = div_size;
> +	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
> +}
> +
> +/* -----------------------------------------------------------------------------
>   * Pipeline Management
>   */
>  
> @@ -594,6 +631,9 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>  {
>  	struct vsp1_entity *entity;
>  
> +	/* Determine this pipelines sizes for image partitioning support. */
> +	vsp1_video_pipeline_setup_partitions(pipe);
> +
>  	/* Prepare the display list. */
>  	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
>  	if (!pipe->dl)
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund

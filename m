Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48478 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbdBMVwd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 16:52:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 4/8] v4l: vsp1: Move partition rectangles to struct
Date: Mon, 13 Feb 2017 23:52:58 +0200
Message-ID: <4172040.3kVqaMM1Dh@avalon>
In-Reply-To: <2a0da9a22511742091a8b8d1b79549f3cbd0c775.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com> <2a0da9a22511742091a8b8d1b79549f3cbd0c775.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 10 Feb 2017 20:27:32 Kieran Bingham wrote:
> As we develop the partition algorithm, we need to store more information
> per partition to describe the phase and other parameters.
> 
> To keep this data together, further abstract the existing v4l2_rect
> into a partition specific structure
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_pipe.h  | 12 ++++++++++--
>  drivers/media/platform/vsp1/vsp1_rpf.c   |  4 ++--
>  drivers/media/platform/vsp1/vsp1_uds.c   |  8 +++++---
>  drivers/media/platform/vsp1/vsp1_video.c | 14 ++++++++++----
>  drivers/media/platform/vsp1/vsp1_wpf.c   |  9 +++++----
>  5 files changed, 32 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index 5aa31143ce59..6494c4c75023
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -60,6 +60,14 @@ enum vsp1_pipeline_state {
>  };
> 
>  /*
> + * struct vsp1_partition - A description of each partition slice performed
> by HW
> + * @dest: The position and dimension of this partition in the destination
> image
> + */
> +struct vsp1_partition {
> +	struct v4l2_rect dest;

Given that we only partition the image horizontally, how about just storing 
the left and width values ?

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +};
> +
> +/*
>   * struct vsp1_pipeline - A VSP1 hardware pipeline
>   * @pipe: the media pipeline
>   * @irqlock: protects the pipeline state
> @@ -114,8 +122,8 @@ struct vsp1_pipeline {
>  	struct vsp1_dl_list *dl;
> 
>  	unsigned int partitions;
> -	struct v4l2_rect partition;
> -	struct v4l2_rect part_table[VSP1_PIPE_MAX_PARTITIONS];
> +	struct vsp1_partition *partition;
> +	struct vsp1_partition part_table[VSP1_PIPE_MAX_PARTITIONS];
>  };
> 
>  void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index b2e34a800ffa..df380a237118
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -107,9 +107,9 @@ static void rpf_configure(struct vsp1_entity *entity,
>  			output = vsp1_entity_get_pad_format(wpf, wpf->config,
>  							    RWPF_PAD_SOURCE);
> 
> -			crop.width = pipe->partition.width * input_width
> +			crop.width = pipe->partition->dest.width * input_width
>  				   / output->width;
> -			crop.left += pipe->partition.left * input_width
> +			crop.left += pipe->partition->dest.left * input_width
>  				   / output->width;
>  		}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c
> b/drivers/media/platform/vsp1/vsp1_uds.c index da8f89a31ea4..98c0836d6dcd
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -272,11 +272,13 @@ static void uds_configure(struct vsp1_entity *entity,
>  	bool multitap;
> 
>  	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
> -		const struct v4l2_rect *clip = &pipe->partition;
> +		struct vsp1_partition *partition = pipe->partition;
> 
>  		vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
> -			       (clip->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) 
|
> -			       (clip->height << 
VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
> +			       (partition->dest.width
> +					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
> +			       (partition->dest.height
> +					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
>  		return;
>  	}
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 4ade958a1c9e..a978508a4993
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -271,8 +271,11 @@ static void vsp1_video_pipeline_setup_partitions(struct
> vsp1_pipeline *pipe)
> 
>  	/* Gen2 hardware doesn't require image partitioning. */
>  	if (vsp1->info->gen == 2) {
> +		struct vsp1_partition *partition = &pipe->part_table[0];
> +
>  		pipe->partitions = 1;
> -		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
> +		partition->dest = vsp1_video_partition(pipe, div_size, 0);
> +
>  		return;
>  	}
> 
> @@ -288,8 +291,11 @@ static void vsp1_video_pipeline_setup_partitions(struct
> vsp1_pipeline *pipe)
> 
>  	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
> 
> -	for (i = 0; i < pipe->partitions; i++)
> -		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
> +	for (i = 0; i < pipe->partitions; i++) {
> +		struct vsp1_partition *partition = &pipe->part_table[i];
> +
> +		partition->dest = vsp1_video_partition(pipe, div_size, i);
> +	}
>  }
> 
>  /*
> ---------------------------------------------------------------------------
> -- @@ -373,7 +379,7 @@ static void vsp1_video_pipeline_run_partition(struct
> vsp1_pipeline *pipe, {
>  	struct vsp1_entity *entity;
> 
> -	pipe->partition = pipe->part_table[partition_number];
> +	pipe->partition = &pipe->part_table[partition_number];
> 
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>  		if (entity->ops->configure)
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c
> b/drivers/media/platform/vsp1/vsp1_wpf.c index ad67034e08e9..bd4cd2807cc6
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -227,7 +227,7 @@ static void wpf_configure(struct vsp1_entity *entity,
>  		 * multiple slices.
>  		 */
>  		if (pipe->partitions > 1)
> -			width = pipe->partition.width;
> +			width = pipe->partition->dest.width;
> 
>  		vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
>  			       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
> @@ -255,10 +255,11 @@ static void wpf_configure(struct vsp1_entity *entity,
>  			 * order the partitions correctly.
>  			 */
>  			if (flip & BIT(WPF_CTRL_HFLIP))
> -				offset = format->width - pipe->partition.left
> -					- pipe->partition.width;
> +				offset = format->width
> +					- pipe->partition->dest.left
> +					- pipe->partition->dest.width;
>  			else
> -				offset = pipe->partition.left;
> +				offset = pipe->partition->dest.left;
> 
>  			mem.addr[0] += offset * fmtinfo->bpp[0] / 8;
>  			if (format->num_planes > 1) {

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47521 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbdBMTX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:23:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] v4l: vsp1: Move vsp1_video_pipeline_setup_partitions() function
Date: Mon, 13 Feb 2017 21:23:51 +0200
Message-ID: <9209013.DxhxRJN60N@avalon>
In-Reply-To: <1478283570-19688-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1478283570-19688-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 04 Nov 2016 18:19:28 Kieran Bingham wrote:
> Separate the code change from the function move so that code changes can
> be clearly identified. This commit has no functional change.
> 
> The partition algorithm functions will be changed, and
> vsp1_video_partition() will call vsp1_video_pipeline_setup_partitions().
> To prepare for that, move the function without any code change.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

(assuming I don't conclude in my review of patches 3/4 and 4/4 that this isn't 
needed :-))

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 74 ++++++++++++++---------------
>  1 file changed, 37 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index d1d3413c6fdf..6d43c02bbc56
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -175,43 +175,6 @@ static int __vsp1_video_try_format(struct vsp1_video
> *video, * VSP1 Partition Algorithm support
>   */
> 
> -static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline
> *pipe) -{
> -	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
> -	const struct v4l2_mbus_framefmt *format;
> -	struct vsp1_entity *entity;
> -	unsigned int div_size;
> -
> -	/*
> -	 * Partitions are computed on the size before rotation, use the format
> -	 * at the WPF sink.
> -	 */
> -	format = vsp1_entity_get_pad_format(&pipe->output->entity,
> -					    pipe->output->entity.config,
> -					    RWPF_PAD_SINK);
> -	div_size = format->width;
> -
> -	/* Gen2 hardware doesn't require image partitioning. */
> -	if (vsp1->info->gen == 2) {
> -		pipe->div_size = div_size;
> -		pipe->partitions = 1;
> -		return;
> -	}
> -
> -	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> -		unsigned int entity_max = VSP1_VIDEO_MAX_WIDTH;
> -
> -		if (entity->ops->max_width) {
> -			entity_max = entity->ops->max_width(entity, pipe);
> -			if (entity_max)
> -				div_size = min(div_size, entity_max);
> -		}
> -	}
> -
> -	pipe->div_size = div_size;
> -	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
> -}
> -
>  /**
>   * vsp1_video_partition - Calculate the active partition output window
>   *
> @@ -286,6 +249,43 @@ static struct v4l2_rect vsp1_video_partition(struct
> vsp1_pipeline *pipe, return partition;
>  }
> 
> +static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline
> *pipe) +{
> +	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
> +	const struct v4l2_mbus_framefmt *format;
> +	struct vsp1_entity *entity;
> +	unsigned int div_size;
> +
> +	/*
> +	 * Partitions are computed on the size before rotation, use the format
> +	 * at the WPF sink.
> +	 */
> +	format = vsp1_entity_get_pad_format(&pipe->output->entity,
> +					    pipe->output->entity.config,
> +					    RWPF_PAD_SINK);
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
>  /*
> ---------------------------------------------------------------------------
> -- * Pipeline Management
>   */

-- 
Regards,

Laurent Pinchart

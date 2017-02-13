Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48270 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752199AbdBMVVh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 16:21:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] v4l: vsp1: Calculate partition sizes at stream start.
Date: Mon, 13 Feb 2017 23:21:58 +0200
Message-ID: <3804080.QOE9vPlxB7@avalon>
In-Reply-To: <1478283570-19688-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478283570-19688-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1478283570-19688-4-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 04 Nov 2016 18:19:29 Kieran Bingham wrote:
> Previously the active window and partition sizes for each partition is

s/is/were/

> calculated for each partition every frame. This data is constant and
> only needs to be calculated once at the start of the stream.
> 
> Extend the vsp1_pipe object to store the maximum number of partitions
> possible and pre-calculate the partition sizes into this table.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_pipe.h  | 6 ++++++
>  drivers/media/platform/vsp1/vsp1_video.c | 8 ++++++--
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index f181949824c9..3af96c4ea244
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -20,6 +20,9 @@
> 
>  #include <media/media-entity.h>
> 
> +/* Max Video Width / Min Partition Size = 8190/128 */
> +#define VSP1_PIPE_MAX_PARTITIONS 64
> +
>  struct vsp1_dl_list;
>  struct vsp1_rwpf;
> 
> @@ -81,7 +84,9 @@ enum vsp1_pipeline_state {
>   * @dl: display list associated with the pipeline
>   * @div_size: The maximum allowed partition size for the pipeline
>   * @partitions: The number of partitions used to process one frame
> + * @partition: The current partition for configuration to process
>   * @current_partition: The partition number currently being configured
> + * @part_table: The pre-calculated partitions used by the pipeline
>   */
>  struct vsp1_pipeline {
>  	struct media_pipeline pipe;
> @@ -116,6 +121,7 @@ struct vsp1_pipeline {
>  	unsigned int partitions;
>  	struct v4l2_rect partition;
>  	unsigned int current_partition;
> +	struct v4l2_rect part_table[VSP1_PIPE_MAX_PARTITIONS];

That's an extra 1kB or kmalloc'ed data. I'd prefer allocating it dynamically 
as needed.

>  };
> 
>  void vsp1_pipeline_reset(struct vsp1_pipeline *pipe);
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 6d43c02bbc56..c4a8c30df108
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -255,6 +255,7 @@ static void vsp1_video_pipeline_setup_partitions(struct
> vsp1_pipeline *pipe) const struct v4l2_mbus_framefmt *format;
>  	struct vsp1_entity *entity;
>  	unsigned int div_size;
> +	int i;

i can never be negative, you can make it an unsigned int.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	/*
>  	 * Partitions are computed on the size before rotation, use the format
> @@ -269,6 +270,7 @@ static void vsp1_video_pipeline_setup_partitions(struct
> vsp1_pipeline *pipe) if (vsp1->info->gen == 2) {
>  		pipe->div_size = div_size;
>  		pipe->partitions = 1;
> +		pipe->part_table[0] = vsp1_video_partition(pipe, div_size, 0);
>  		return;
>  	}
> 
> @@ -284,6 +286,9 @@ static void vsp1_video_pipeline_setup_partitions(struct
> vsp1_pipeline *pipe)
> 
>  	pipe->div_size = div_size;
>  	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
> +
> +	for (i = 0; i < pipe->partitions; i++)
> +		pipe->part_table[i] = vsp1_video_partition(pipe, div_size, i);
>  }
> 
>  /* ------------------------------------------------------------------------
> @@ -355,8 +360,7 @@ static void vsp1_video_pipeline_run_partition(struct
> vsp1_pipeline *pipe, {
>  	struct vsp1_entity *entity;
> 
> -	pipe->partition = vsp1_video_partition(pipe, pipe->div_size,
> -					       pipe->current_partition);
> +	pipe->partition = pipe->part_table[pipe->current_partition];
> 
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
>  		if (entity->ops->configure)

-- 
Regards,

Laurent Pinchart

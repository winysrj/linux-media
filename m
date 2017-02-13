Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48745 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdBMWxb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 17:53:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 6/8] v4l: vsp1: Allow entities to participate in the partition algorithm
Date: Tue, 14 Feb 2017 00:51:10 +0200
Message-ID: <1775251.033ku1xShs@avalon>
In-Reply-To: <be9e5af279f5adb4d1c3ada3c9402ce202aff5c4.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com> <be9e5af279f5adb4d1c3ada3c9402ce202aff5c4.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 10 Feb 2017 20:27:34 Kieran Bingham wrote:
> The configuration of the pipeline, and entities directly affects the
> inputs required to each entity for the partition algorithm. Thus it
> makes sense to involve those entities in the decision making process.
> 
> Extend the entity ops API to provide an optional '.partition' call. This
> allows entities which may effect the partition window, to process based
> on their configuration.
> 
> Entities implementing this operation must return their required input
> parameters, which will be passed down the chain. This creates a process
> whereby each entity describes what is required to satisfy the required
> output to it's predecessor in the pipeline.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_entity.h |  8 ++++-
>  drivers/media/platform/vsp1/vsp1_pipe.c   | 22 ++++++++++++-
>  drivers/media/platform/vsp1/vsp1_pipe.h   | 35 +++++++++++++++++--
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 33 +++++++++---------
>  drivers/media/platform/vsp1/vsp1_sru.c    | 29 +++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_uds.c    | 45 ++++++++++++++++++++++--
>  drivers/media/platform/vsp1/vsp1_video.c  | 32 ++++++++++-------
>  drivers/media/platform/vsp1/vsp1_wpf.c    | 29 +++++++++++----
>  8 files changed, 195 insertions(+), 38 deletions(-)

[snip]

> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
> b/drivers/media/platform/vsp1/vsp1_pipe.c index 280ba0804699..16f2eada54d5
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -331,6 +331,28 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline
> *pipe, vsp1_uds_set_alpha(pipe->uds, dl, alpha);
>  }
> 
> +/*
> + * Propagate the partition calculations through the pipeline
> + *
> + * Work backwards through the pipe, allowing each entity to update
> + * the partition parameters based on it's configuration, and the entity

s/it's/its/

> + * connected to it's source. Each entity must produce the partition

Ditto.

> + * required for the next entity in the routing.

Maybe "for the previous entity in the pipeline" ?

> + */
> +void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
> +				       struct vsp1_partition *partition,
> +				       unsigned int index,
> +				       struct vsp1_partition_rect *rect)
> +{
> +	struct vsp1_entity *entity;
> +
> +	list_for_each_entry_reverse(entity, &pipe->entities, list_pipe) {
> +		if (entity->ops->partition)
> +			rect = entity->ops->partition(entity, pipe, partition,
> +						      index, rect);

How about modifying the rect argument in place ? I think that would simplify 
the code.

> +	}
> +}
> +
>  void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
>  {
>  	unsigned long flags;
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index 6494c4c75023..718ca0a5eca7
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -60,11 +60,32 @@ enum vsp1_pipeline_state {
>  };
> 
>  /*
> + * struct vsp1_partition_rect
> + *
> + * replicates struct v4l2_rect, but with an offset to apply
> + */
> +struct vsp1_partition_rect {

Let's name this vsp1_partition_window, as that's what it describes.

> +	__s32   left;
> +	__s32   top;
> +	__u32   width;
> +	__u32   height;
> +	__u32   offset;
> +};
> +
> +/*
>   * struct vsp1_partition - A description of each partition slice performed
> by HW
> - * @dest: The position and dimension of this partition in the destination
> image
> + * @rpf: The RPF partition window configuration
> + * @uds_sink: The UDS input partition window configuration
> + * @uds_source: The UDS output partition window configuration
> + * @sru: The SRU partition window configuration
> + * @wpf: The WPF partition window configuration
>   */
>  struct vsp1_partition {
> -	struct v4l2_rect dest;
> +	struct vsp1_partition_rect rpf;
> +	struct vsp1_partition_rect uds_sink;
> +	struct vsp1_partition_rect uds_source;
> +	struct vsp1_partition_rect sru;
> +	struct vsp1_partition_rect wpf;
>  };
> 
>  /*
> @@ -117,6 +138,11 @@ struct vsp1_pipeline {
>  	struct vsp1_entity *uds;
>  	struct vsp1_entity *uds_input;
> 
> +	/*
> +	 * The order of this list should be representative of the order and

I'd say it "must be identical to the order of the entities in the pipeline".

> +	 * routing of the the pipeline, as it is assumed by the partition
> +	 * algorithm that we can walk this list in sequence.
> +	 */
>  	struct list_head entities;
> 
>  	struct vsp1_dl_list *dl;
> @@ -139,6 +165,11 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline
> *pipe); void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
>  				   struct vsp1_dl_list *dl, unsigned int 
alpha);
> 
> +void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
> +				       struct vsp1_partition *partition,
> +				       unsigned int index,
> +				       struct vsp1_partition_rect *rect);
> +
>  void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
>  void vsp1_pipelines_resume(struct vsp1_device *vsp1);
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
> b/drivers/media/platform/vsp1/vsp1_rpf.c index df380a237118..94541ab4ca36
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c

[snip]

> +/*
> + * Perform RPF specific calculations for the Partition Algorithm

Is the "Partition Algorithm" such an almighty power that it requires caps ? 
:-) I think I'd drop the comment, the operation kerneldoc in vsp1_entity.h 
should be enough.

> + */
> +struct vsp1_partition_rect *rpf_partition(struct vsp1_entity *entity,

This function should be static. Same comment for the other modules.

> +					  struct vsp1_pipeline *pipe,
> +					  struct vsp1_partition *partition,
> +					  unsigned int partition_idx,
> +					  struct vsp1_partition_rect *dest)
> +{
> +	/* Duplicate the target configuration to the RPF */
> +	partition->rpf = *dest;
> +
> +	return &partition->rpf;
> +}

[snip]

-- 
Regards,

Laurent Pinchart

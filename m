Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44887 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbcLNUVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 15:21:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 1/4] v4l: vsp1: Move vsp1_video_setup_pipeline()
Date: Wed, 14 Dec 2016 22:21:47 +0200
Message-ID: <2672723.BZYFsk6GIb@avalon>
In-Reply-To: <1481651984-7687-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1481651984-7687-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday 13 Dec 2016 17:59:41 Kieran Bingham wrote:
> Move the static vsp1_video_setup_pipeline() function in preparation for
> the callee updates so that the vsp1_video_pipeline_run() call can
> configure pipelines following suspend resume actions.
> 
> This commit is just a code move for clarity performing no functional
> change.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

provided of course we still need this after the rework of 2/4.

> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 82 ++++++++++++++---------------
>  1 file changed, 41 insertions(+), 41 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index d351b9c768d2..44b687c0b8df
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -350,6 +350,47 @@ static void vsp1_video_frame_end(struct vsp1_pipeline
> *pipe, pipe->buffers_ready |= 1 << video->pipe_index;
>  }
> 
> +static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_entity *entity;
> +
> +	/* Determine this pipelines sizes for image partitioning support. */
> +	vsp1_video_pipeline_setup_partitions(pipe);
> +
> +	/* Prepare the display list. */
> +	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
> +	if (!pipe->dl)
> +		return -ENOMEM;
> +
> +	if (pipe->uds) {
> +		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
> +
> +		/* If a BRU is present in the pipeline before the UDS, the 
alpha
> +		 * component doesn't need to be scaled as the BRU output alpha
> +		 * value is fixed to 255. Otherwise we need to scale the alpha
> +		 * component only when available at the input RPF.
> +		 */
> +		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
> +			uds->scale_alpha = false;
> +		} else {
> +			struct vsp1_rwpf *rpf =
> +				to_rwpf(&pipe->uds_input->subdev);
> +
> +			uds->scale_alpha = rpf->fmtinfo->alpha;
> +		}
> +	}
> +
> +	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> +		vsp1_entity_route_setup(entity, pipe->dl);
> +
> +		if (entity->ops->configure)
> +			entity->ops->configure(entity, pipe, pipe->dl,
> +					       VSP1_ENTITY_PARAMS_INIT);
> +	}
> +
> +	return 0;
> +}
> +
>  static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
>  					      struct vsp1_dl_list *dl)
>  {
> @@ -747,47 +788,6 @@ static void vsp1_video_buffer_queue(struct vb2_buffer
> *vb) spin_unlock_irqrestore(&pipe->irqlock, flags);
>  }
> 
> -static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
> -{
> -	struct vsp1_entity *entity;
> -
> -	/* Determine this pipelines sizes for image partitioning support. */
> -	vsp1_video_pipeline_setup_partitions(pipe);
> -
> -	/* Prepare the display list. */
> -	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
> -	if (!pipe->dl)
> -		return -ENOMEM;
> -
> -	if (pipe->uds) {
> -		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
> -
> -		/* If a BRU is present in the pipeline before the UDS, the 
alpha
> -		 * component doesn't need to be scaled as the BRU output alpha
> -		 * value is fixed to 255. Otherwise we need to scale the alpha
> -		 * component only when available at the input RPF.
> -		 */
> -		if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
> -			uds->scale_alpha = false;
> -		} else {
> -			struct vsp1_rwpf *rpf =
> -				to_rwpf(&pipe->uds_input->subdev);
> -
> -			uds->scale_alpha = rpf->fmtinfo->alpha;
> -		}
> -	}
> -
> -	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> -		vsp1_entity_route_setup(entity, pipe->dl);
> -
> -		if (entity->ops->configure)
> -			entity->ops->configure(entity, pipe, pipe->dl,
> -					       VSP1_ENTITY_PARAMS_INIT);
> -	}
> -
> -	return 0;
> -}
> -
>  static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int
> count) {
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);

-- 
Regards,

Laurent Pinchart


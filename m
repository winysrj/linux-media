Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42502 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbeC2LhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 07:37:14 -0400
Subject: Re: [PATCH 12/15] v4l: vsp1: Generalize detection of entity removal
 from DRM pipeline
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-13-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <4841fc82-0201-2a53-53ce-6da7c144a75e@ideasonboard.com>
Date: Thu, 29 Mar 2018 12:37:07 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-13-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the patch,

On 26/02/18 21:45, Laurent Pinchart wrote:
> When disabling a DRM plane, the corresponding RPF is only marked as
> removed from the pipeline in the atomic update handler, with the actual
> removal happening when configuring the pipeline at atomic commit time.
> This is required as the RPF has to be disabled in the hardware, which
> can't be done from the atomic update handler.
> 
> The current implementation is RPF-specific. Make it independent of the
> entity type by using the entity's pipe pointer to mark removal from the
> pipeline. This will allow using the mechanism to remove BRU instances.

Nice improvement ...

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index d705a6e9fa1d..6c60b72b6f50 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -346,13 +346,12 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  
>  	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
> -		/* Disconnect unused RPFs from the pipeline. */
> -		if (entity->type == VSP1_ENTITY_RPF &&
> -		    !pipe->inputs[entity->index]) {
> +		/* Disconnect unused entities from the pipeline. */
> +		if (!entity->pipe) {
>  			vsp1_dl_list_write(dl, entity->route->reg,
>  					   VI6_DPR_NODE_UNUSED);

I don't think it's a problem, as we don't unset the entity->pipe for arbitrary
entities, but what happens if we set an HGO/HGT entity to NULL (these currently
have 0 as the route->reg. This would risk writing VI6_DPR_NODE_UNUSED to the
VI6_CMD(0) register?

In fact any entity in the pipeline with a null pipe pointer could cause this...
so we'd best be sure that they are right. Otherwise this could cause some crazy
bugs manifesting with the hardware doing something unexpected.

Assuming that won't be a problem,

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

>  
> -			entity->pipe = NULL;
> +			entity->sink = NULL;
>  			list_del(&entity->list_pipe);
>  
>  			continue;
> @@ -569,10 +568,11 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  			rpf_index);
>  
>  		/*
> -		 * Remove the RPF from the pipe's inputs. The atomic flush
> -		 * handler will disable the input and remove the entity from the
> -		 * pipe's entities list.
> +		 * Remove the RPF from the pipeline's inputs. Keep it in the
> +		 * pipeline's entity list to let vsp1_du_pipeline_configure()
> +		 * remove it from the hardware pipeline.
>  		 */
> +		rpf->entity.pipe = NULL;
>  		drm_pipe->pipe.inputs[rpf_index] = NULL;
>  		return 0;
>  	}
> 

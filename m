Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37772 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751165AbdGMNAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 09:00:36 -0400
Subject: Re: [PATCH v2 04/14] v4l: vsp1: Store source and sink pointers as
 vsp1_entity
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-5-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <7dbc0bcd-bc72-b45c-0fcd-56b0780880a9@ideasonboard.com>
Date: Thu, 13 Jul 2017 14:00:31 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-5-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

This looks like a good simplification/removal of obfuscation to me!

On 26/06/17 19:12, Laurent Pinchart wrote:
> The internal VSP entity source and sink pointers are stored as
> media_entity pointers, which are then cast to a vsp1_entity. As all
> sources and sinks are vsp1_entity instances, we can store the
> vsp1_entity pointers directly.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c    |  4 ++--
>  drivers/media/platform/vsp1/vsp1_drv.c    |  2 +-
>  drivers/media/platform/vsp1/vsp1_entity.c | 26 +++++++++++++-------------
>  drivers/media/platform/vsp1/vsp1_entity.h |  4 ++--
>  4 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index bc3fd9bc7126..2d5a74e95e09 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -587,7 +587,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  		if (ret < 0)
>  			return ret;
>  
> -		rpf->entity.sink = &vsp1->bru->entity.subdev.entity;
> +		rpf->entity.sink = &vsp1->bru->entity;
>  		rpf->entity.sink_pad = i;
>  	}
>  
> @@ -598,7 +598,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
>  	if (ret < 0)
>  		return ret;
>  
> -	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity.subdev.entity;
> +	vsp1->bru->entity.sink = &vsp1->wpf[0]->entity;
>  	vsp1->bru->entity.sink_pad = RWPF_PAD_SINK;
>  
>  	ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 35087d5573ce..9b3a0790f92a 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -121,7 +121,7 @@ static int vsp1_create_sink_links(struct vsp1_device *vsp1,
>  				return ret;
>  
>  			if (flags & MEDIA_LNK_FL_ENABLED)
> -				source->sink = entity;
> +				source->sink = sink;
>  		}
>  	}
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index 4bdb3b141611..71dd903263ad 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -24,18 +24,11 @@
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
>  
> -static inline struct vsp1_entity *
> -media_entity_to_vsp1_entity(struct media_entity *entity)
> -{
> -	return container_of(entity, struct vsp1_entity, subdev.entity);
> -}
> -
>  void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  			     struct vsp1_pipeline *pipe,
>  			     struct vsp1_dl_list *dl)
>  {
>  	struct vsp1_entity *source;
> -	struct vsp1_entity *sink;
>  
>  	if (entity->type == VSP1_ENTITY_HGO) {
>  		u32 smppt;
> @@ -44,7 +37,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  		 * The HGO is a special case, its routing is configured on the
>  		 * sink pad.
>  		 */
> -		source = media_entity_to_vsp1_entity(entity->sources[0]);
> +		source = entity->sources[0];
>  		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
>  		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
>  
> @@ -57,7 +50,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  		 * The HGT is a special case, its routing is configured on the
>  		 * sink pad.
>  		 */
> -		source = media_entity_to_vsp1_entity(entity->sources[0]);
> +		source = entity->sources[0];
>  		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
>  		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
>  
> @@ -69,9 +62,8 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
>  	if (source->route->reg == 0)
>  		return;
>  
> -	sink = media_entity_to_vsp1_entity(source->sink);
>  	vsp1_dl_list_write(dl, source->route->reg,
> -			   sink->route->inputs[source->sink_pad]);
> +			   source->sink->route->inputs[source->sink_pad]);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -316,6 +308,12 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
>   * Media Operations
>   */
>  
> +static inline struct vsp1_entity *
> +media_entity_to_vsp1_entity(struct media_entity *entity)
> +{
> +	return container_of(entity, struct vsp1_entity, subdev.entity);
> +}
> +
>  static int vsp1_entity_link_setup_source(const struct media_pad *source_pad,
>  					 const struct media_pad *sink_pad,
>  					 u32 flags)
> @@ -339,7 +337,7 @@ static int vsp1_entity_link_setup_source(const struct media_pad *source_pad,
>  		    sink->type != VSP1_ENTITY_HGT) {
>  			if (source->sink)
>  				return -EBUSY;
> -			source->sink = sink_pad->entity;
> +			source->sink = sink;
>  			source->sink_pad = sink_pad->index;
>  		}
>  	} else {
> @@ -355,15 +353,17 @@ static int vsp1_entity_link_setup_sink(const struct media_pad *source_pad,
>  				       u32 flags)
>  {
>  	struct vsp1_entity *sink;
> +	struct vsp1_entity *source;
>  
>  	sink = media_entity_to_vsp1_entity(sink_pad->entity);
> +	source = media_entity_to_vsp1_entity(source_pad->entity);
>  
>  	if (flags & MEDIA_LNK_FL_ENABLED) {
>  		/* Fan-in is limited to one. */
>  		if (sink->sources[sink_pad->index])
>  			return -EBUSY;
>  
> -		sink->sources[sink_pad->index] = source_pad->entity;
> +		sink->sources[sink_pad->index] = source;
>  	} else {
>  		sink->sources[sink_pad->index] = NULL;
>  	}
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index c169a060b6d2..4362cd4e90ba 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -104,8 +104,8 @@ struct vsp1_entity {
>  	struct media_pad *pads;
>  	unsigned int source_pad;
>  
> -	struct media_entity **sources;
> -	struct media_entity *sink;
> +	struct vsp1_entity **sources;
> +	struct vsp1_entity *sink;
>  	unsigned int sink_pad;
>  
>  	struct v4l2_subdev subdev;
> 

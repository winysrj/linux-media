Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53417 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbJ1Bdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2015 21:33:35 -0400
Date: Wed, 28 Oct 2015 10:33:31 +0900
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 15/19] v4l: vsp1: Use media entity enumeration API
Message-ID: <20151028103331.65669f3d@concha.lan>
In-Reply-To: <1445900510-1398-16-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
	<1445900510-1398-16-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Oct 2015 01:01:46 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> From: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 45 ++++++++++++++++++++++----------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index ce10d86..b3fd2be 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -311,24 +311,35 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
>  					 struct vsp1_rwpf *output)
>  {
>  	struct vsp1_entity *entity;
> -	unsigned int entities = 0;
> +	struct media_entity_enum entities;
>  	struct media_pad *pad;
> +	int rval;
>  	bool bru_found = false;
>  
>  	input->location.left = 0;
>  	input->location.top = 0;
>  
> +	rval = media_entity_enum_init(
> +		&entities, input->entity.pads[RWPF_PAD_SOURCE].graph_obj.mdev);
> +	if (rval)
> +		return rval;
> +
>  	pad = media_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
>  
>  	while (1) {
> -		if (pad == NULL)
> -			return -EPIPE;
> +		if (pad == NULL) {
> +			rval = -EPIPE;
> +			goto out;
> +		}
>  
>  		/* We've reached a video node, that shouldn't have happened. */
> -		if (!is_media_entity_v4l2_subdev(pad->entity))
> -			return -EPIPE;
> +		if (!is_media_entity_v4l2_subdev(pad->entity)) {
> +			rval = -EPIPE;
> +			goto out;
> +		}
>  
> -		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
> +		entity = to_vsp1_entity(
> +			media_entity_to_v4l2_subdev(pad->entity));
>  
>  		/* A BRU is present in the pipeline, store the compose rectangle
>  		 * location in the input RPF for use when configuring the RPF.
> @@ -351,15 +362,18 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
>  			break;
>  
>  		/* Ensure the branch has no loop. */
> -		if (entities & (1 << media_entity_id(&entity->subdev.entity)))
> -			return -EPIPE;
> -
> -		entities |= 1 << media_entity_id(&entity->subdev.entity);
> +		if (media_entity_enum_test_and_set(&entities,
> +						   &entity->subdev.entity)) {
> +			rval = -EPIPE;
> +			goto out;
> +		}
>  
>  		/* UDS can't be chained. */
>  		if (entity->type == VSP1_ENTITY_UDS) {
> -			if (pipe->uds)
> -				return -EPIPE;
> +			if (pipe->uds) {
> +				rval = -EPIPE;
> +				goto out;
> +			}
>  
>  			pipe->uds = entity;
>  			pipe->uds_input = bru_found ? pipe->bru
> @@ -377,9 +391,12 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
>  
>  	/* The last entity must be the output WPF. */
>  	if (entity != &output->entity)
> -		return -EPIPE;
> +		rval = -EPIPE;
>  
> -	return 0;
> +out:
> +	media_entity_enum_cleanup(&entities);
> +
> +	return rval;
>  }
>  
>  static void __vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)


-- 

Cheers,
Mauro

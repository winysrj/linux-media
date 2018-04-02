Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36581 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbeDBM5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 08:57:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 12/15] v4l: vsp1: Generalize detection of entity removal from DRM pipeline
Date: Mon, 02 Apr 2018 15:57:13 +0300
Message-ID: <2504001.NRtzAvQP2M@avalon>
In-Reply-To: <4841fc82-0201-2a53-53ce-6da7c144a75e@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com> <20180226214516.11559-13-laurent.pinchart+renesas@ideasonboard.com> <4841fc82-0201-2a53-53ce-6da7c144a75e@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Thursday, 29 March 2018 14:37:07 EEST Kieran Bingham wrote:
> On 26/02/18 21:45, Laurent Pinchart wrote:
> > When disabling a DRM plane, the corresponding RPF is only marked as
> > removed from the pipeline in the atomic update handler, with the actual
> > removal happening when configuring the pipeline at atomic commit time.
> > This is required as the RPF has to be disabled in the hardware, which
> > can't be done from the atomic update handler.
> > 
> > The current implementation is RPF-specific. Make it independent of the
> > entity type by using the entity's pipe pointer to mark removal from the
> > pipeline. This will allow using the mechanism to remove BRU instances.
> 
> Nice improvement ...
> 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drm.c | 14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index d705a6e9fa1d..6c60b72b6f50
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -346,13 +346,12 @@ static void vsp1_du_pipeline_configure(struct
> > vsp1_pipeline *pipe)
> >  	dl = vsp1_dl_list_get(pipe->output->dlm);
> >  	
> >  	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
> > -		/* Disconnect unused RPFs from the pipeline. */
> > -		if (entity->type == VSP1_ENTITY_RPF &&
> > -		    !pipe->inputs[entity->index]) {
> > +		/* Disconnect unused entities from the pipeline. */
> > +		if (!entity->pipe) {
> >  			vsp1_dl_list_write(dl, entity->route->reg,
> >  					   VI6_DPR_NODE_UNUSED);
> 
> I don't think it's a problem, as we don't unset the entity->pipe for
> arbitrary entities, but what happens if we set an HGO/HGT entity to NULL
> (these currently have 0 as the route->reg. This would risk writing
> VI6_DPR_NODE_UNUSED to the VI6_CMD(0) register?
> 
> In fact any entity in the pipeline with a null pipe pointer could cause
> this... so we'd best be sure that they are right. Otherwise this could
> cause some crazy bugs manifesting with the hardware doing something
> unexpected.

First of all, this code handles the DRM pipeline only, which can't contain an 
HGO or HGT. If we ever have to add an HGO or HGT to the DRM pipeline (I don't 
see a use case for now, but who knows), this will sure need to be fixed, among 
other things because the VI6_DPR_HGO_SMPPT and VI6_DPR_HGT_SMPPT registers 
would need to be configured.

This being said, the idea behind this code is that when an entity is added to 
a pipeline, it will be added to the pipeline's entities list, and its pipe 
field will be set to point to the pipeline object. Removing an entity from a 
pipeline thus requires the opposite actions, removing it from the entities 
list and setting the pipe field to NULL.

Due to the architecture of the DRM pipeline handling code, there is a need to 
reconfigure routing when an entity is removed from a pipeline. We can't 
reconfigure routing at the point where we get notified that entities need to 
be removed from the pipeline. We thus need to track removed entities, and then 
reconfigure routing later. This patch implements such a mechanism by using the 
pipe pointer to track entity removal, and then removes them from the 
pipeline's list of entities later after reconfiguring routing.

You are worried that any entity in the pipeline with a NULL pipe pointer could 
cause issues. The pipe pointer is set to a non-NULL value when an entity is 
added to the pipeline, so the only way for the pipe pointer to be NULL here is 
for an entity that was part of a pipeline to be removed from it. As the HGO 
and HGT entities are never added to the pipeline, that's not an issue.

> Assuming that won't be a problem,

I believe that assumption to be correct :-)

> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > -			entity->pipe = NULL;
> > +			entity->sink = NULL;
> >  			list_del(&entity->list_pipe);
> >  			
> >  			continue;
> > @@ -569,10 +568,11 @@ int vsp1_du_atomic_update(struct device *dev,
> > unsigned int pipe_index,
> >  			rpf_index);
> >  		
> >  		/*
> > -		 * Remove the RPF from the pipe's inputs. The atomic flush
> > -		 * handler will disable the input and remove the entity from the
> > -		 * pipe's entities list.
> > +		 * Remove the RPF from the pipeline's inputs. Keep it in the
> > +		 * pipeline's entity list to let vsp1_du_pipeline_configure()
> > +		 * remove it from the hardware pipeline.
> >  		 */
> > +		rpf->entity.pipe = NULL;
> >  		drm_pipe->pipe.inputs[rpf_index] = NULL;
> >  		return 0;
> >  	}

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53211 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964935AbdIYU7T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 16:59:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kieran.bingham@ideasonboard.com
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: vsp1: Start and stop DRM pipeline independently of planes
Date: Mon, 25 Sep 2017 23:59:07 +0300
Message-ID: <17726601.dARtd6loas@avalon>
In-Reply-To: <5b2b812b-f0ba-257b-ac71-13f21d0635ec@ideasonboard.com>
References: <20170815225744.14730-1-laurent.pinchart+renesas@ideasonboard.com> <5b2b812b-f0ba-257b-ac71-13f21d0635ec@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Monday, 25 September 2017 20:25:14 EEST Kieran Bingham wrote:
> On 15/08/17 23:57, Laurent Pinchart wrote:
> > The KMS API supports enabling a CRTC without any plane. To enable that
> > use case, we need to start the pipeline when configuring the LIF,
> > instead of when enabling the first plane.
> 
> Tested and verified on Salvator-X ES1.0 using the KMS Test suite, including
> suspend/resume, in combination with the "[PATCH 0/3] R-Car DU: Clip planes
> to screen boundaries" series.
> 
> Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drm.c | 37 ++++++++++++++++++++---------
> >  1 file changed, 27 insertions(+), 10 deletions(-)
> > 
> > This patch is based on top of the VSP+DU large patch series queued through
> > Dave's DRM tree for v4.14-rc1. It doesn't can't be merged independently
> > through the linux-media tree for the same kernel version. As the change is
> > not urgent, it can be delayed until v4.15-rc1.
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 4dfbeac8f42c..7ce69f23f50a
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -84,8 +84,12 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
> > pipe_index,> 
> >  	struct vsp1_drm_pipeline *drm_pipe;
> >  	struct vsp1_pipeline *pipe;
> >  	struct vsp1_bru *bru;
> > 
> > +	struct vsp1_entity *entity;
> > +	struct vsp1_entity *next;
> > +	struct vsp1_dl_list *dl;
> > 
> >  	struct v4l2_subdev_format format;
> >  	const char *bru_name;
> > 
> > +	unsigned long flags;
> > 
> >  	unsigned int i;
> >  	int ret;
> > 
> > @@ -250,6 +254,29 @@ int vsp1_du_setup_lif(struct device *dev, unsigned
> > int pipe_index,> 
> >  	vsp1_write(vsp1, VI6_DISP_IRQ_STA, 0);
> >  	vsp1_write(vsp1, VI6_DISP_IRQ_ENB, 0);
> > 
> > +	/* Configure all entities in the pipeline. */
> > +	dl = vsp1_dl_list_get(pipe->output->dlm);
> > +
> > +	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
> > +		vsp1_entity_route_setup(entity, pipe, dl);
> > +
> > +		if (entity->ops->configure) {
> > +			entity->ops->configure(entity, pipe, dl,
> > +					       VSP1_ENTITY_PARAMS_INIT);
> > +			entity->ops->configure(entity, pipe, dl,
> > +					       VSP1_ENTITY_PARAMS_RUNTIME);
> > +			entity->ops->configure(entity, pipe, dl,
> > +					       VSP1_ENTITY_PARAMS_PARTITION);
> > +		}
> 
> Hrm ... this configure section now has quite a lot duplicated from the
> vsp1_du_atomic_flush(). Perhaps we could abstract that part out to a common
> function - but I don't think that's essential.

Let's do so on top of your pending patches then. Feel free to give it a go if 
you want to ;-)

> > +	}
> > +
> > +	vsp1_dl_list_commit(dl);
> > +
> > +	/* Start the pipeline. */
> > +	spin_lock_irqsave(&pipe->irqlock, flags);
> > +	vsp1_pipeline_run(pipe);
> > +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> > +
> > 
> >  	dev_dbg(vsp1->dev, "%s: pipeline enabled\n", __func__);
> >  	
> >  	return 0;
> > 
> > @@ -488,7 +515,6 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned
> > int pipe_index)> 
> >  	struct vsp1_entity *next;
> >  	struct vsp1_dl_list *dl;
> >  	const char *bru_name;
> > 
> > -	unsigned long flags;
> > 
> >  	unsigned int i;
> >  	int ret;
> > 
> > @@ -570,15 +596,6 @@ void vsp1_du_atomic_flush(struct device *dev,
> > unsigned int pipe_index)> 
> >  	}
> >  	
> >  	vsp1_dl_list_commit(dl);
> > 
> > -
> > -	/* Start or stop the pipeline if needed. */
> > -	if (!drm_pipe->enabled && pipe->num_inputs) {
> > -		spin_lock_irqsave(&pipe->irqlock, flags);
> > -		vsp1_pipeline_run(pipe);
> > -		spin_unlock_irqrestore(&pipe->irqlock, flags);
> > -	} else if (drm_pipe->enabled && !pipe->num_inputs) {
> > -		vsp1_pipeline_stop(pipe);
> > -	}
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);

-- 
Regards,

Laurent Pinchart

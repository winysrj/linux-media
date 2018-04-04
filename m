Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48562 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752219AbeDDV5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 17:57:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 13/15] v4l: vsp1: Assign BRU and BRS to pipelines dynamically
Date: Thu, 05 Apr 2018 00:57:23 +0300
Message-ID: <47593337.LS3i7tY9ab@avalon>
In-Reply-To: <48239272-4f3f-1245-5ad9-c54c1413c1c2@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com> <20180226214516.11559-14-laurent.pinchart+renesas@ideasonboard.com> <48239272-4f3f-1245-5ad9-c54c1413c1c2@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 4 April 2018 19:00:10 EEST Kieran Bingham wrote:
> Hi Laurent,
> 
> Thank you for the patch.
> 
> I don't envy you on having to deal with this one ... it's a bit of a pain
> ...

Yes it was a bit painful :-/ The devil was both in the big picture and the 
details this time.

> On 26/02/18 21:45, Laurent Pinchart wrote:
> > The VSPDL variant drives two DU channels through two LIF and two
> > blenders, BRU and BRS. The DU channels thus share the five available
> > VSPDL inputs and expose them as five KMS planes.
> > 
> > The current implementation assigns the BRS to the second LIF and thus
> > artificially limits the number of planes for the second display channel
> > to two at most.
> > 
> > Lift this artificial limitation by assigning the BRU and BRS to the
> > display pipelines on demand based on the number of planes used by each
> > pipeline. When a display pipeline needs more than two inputs and the BRU
> > is already in use by the other pipeline, this requires reconfiguring the
> > other pipeline to free the BRU before processing, which can result in
> > frame drop on both pipelines.
> 
> So this is a hard one!
>  - Having to dynamically reconfigure "someone else's" pipes ...
> 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Except for the recursion, which is unavoidable, and the lock handling across
> function calls which is ... unavoidable I think as well (at least for the
> moment), my only quibble is the naming of the 'notify' variable, which is
> not particularly clear in terms of who it notifies. (Internal, vs DRM)
> 
> I'll leave it up to you to decide whether or not to rename it though, and if
> you're happy with the naming then fine.

I agree with you, please see below.

> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drm.c | 160 ++++++++++++++++++++++------
> >  drivers/media/platform/vsp1/vsp1_drm.h |   9 ++
> >  2 files changed, 144 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 6c60b72b6f50..87e31ba0ddf5
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -39,7 +39,13 @@ static void vsp1_du_pipeline_frame_end(struct
> > vsp1_pipeline *pipe,> 
> >  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
> >  	
> >  	if (drm_pipe->du_complete)
> > 
> > -		drm_pipe->du_complete(drm_pipe->du_private, completed);
> > +		drm_pipe->du_complete(drm_pipe->du_private,
> > +				      completed && !notify);
> > +
> > +	if (notify) {
> > +		drm_pipe->force_bru_release = false;
> > +		wake_up(&drm_pipe->wait_queue);
> > +	}
> 
> Notify seems such a nondescript verb to use here, and confuses me against
> who we are notifying  - and why (it's an internal notification, but notify
> makes me think we are 'notifying' the DU - which is exactly the opposite).
> 
> (Perhaps this is actually a comment for the previous patch, but I've gone
> out-of-order, due to the complexities here...)
> 
> Could this be 'internal', 'released' or 'reconfigured', or something to
> distinguish that this frame-end is not a normal frame-completion event ?

I think internal is a better name than notify. I'll pick that.

> >  }
> >  
> >  /* ----------------------------------------------------------------------
> > @@ -149,6 +155,10 @@ static int vsp1_du_pipeline_setup_rpf(struct
> > vsp1_device *vsp1,
> >  }
> >  
> >  /* Setup the BRU source pad. */
> > +static int vsp1_du_pipeline_setup_input(struct vsp1_device *vsp1,
> > +					struct vsp1_pipeline *pipe);
> > +static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe);
> > +
> 
> Ohhh lovely, recursion...
> Ohhh lovely, recursion...

I wanted to avoid it but haven't found a better way.

> >  static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
> >  				      struct vsp1_pipeline *pipe)
> >  {
> > @@ -156,8 +166,93 @@ static int vsp1_du_pipeline_setup_bru(struct
> > vsp1_device *vsp1,
> >  	struct v4l2_subdev_format format = {
> >  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> >  	};
> > +	struct vsp1_entity *bru;
> >  	int ret;
> > 
> > +	/*
> > +	 * Pick a BRU:
> > +	 * - If we need more than two inputs, use the main BRU.
> > +	 * - Otherwise, if we are not forced to release our BRU, keep it.
> > +	 * - Else, use any free BRU (randomly starting with the main BRU).
> > +	 */
> > +	if (pipe->num_inputs > 2)
> > +		bru = &vsp1->bru->entity;
> > +	else if (pipe->bru && !drm_pipe->force_bru_release)
> > +		bru = pipe->bru;
> > +	else if (!vsp1->bru->entity.pipe)
> > +		bru = &vsp1->bru->entity;
> > +	else
> > +		bru = &vsp1->brs->entity;
> 
> Ok - that tooks some iterations to go through - but I think it covers all
> the bases.
> 
> > +
> > +	/* Switch BRU if needed. */
> > +	if (bru != pipe->bru) {
> > +		struct vsp1_entity *released_bru = NULL;
> > +
> > +		/* Release our BRU if we have one. */
> > +		if (pipe->bru) {
> > +			/*
> > +			 * The BRU might be acquired by the other pipeline in
> > +			 * the next step. We must thus remove it from the list
> > +			 * of entities for this pipeline. The other pipeline's
> > +			 * hardware configuration will reconfigure the BRU
> > +			 * routing.
> > +			 *
> > +			 * However, if the other pipeline doesn't acquire our
> > +			 * BRU, we need to keep it in the list, otherwise the
> > +			 * hardware configuration step won't disconnect it from
> > +			 * the pipeline. To solve this, store the released BRU
> > +			 * pointer to add it back to the list of entities later
> > +			 * if it isn't acquired by the other pipeline.
> > +			 */
> > +			released_bru = pipe->bru;
> > +
> > +			list_del(&pipe->bru->list_pipe);
> > +			pipe->bru->sink = NULL;
> > +			pipe->bru->pipe = NULL;
> > +			pipe->bru = NULL;
> > +		}
> > +
> > +		/*
> > +		 * If the BRU we need is in use, force the owner pipeline to
> > +		 * switch to the other BRU and wait until the switch completes.
> > +		 */
> > +		if (bru->pipe) {
> > +			struct vsp1_drm_pipeline *owner_pipe;
> > +
> > +			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
> > +			owner_pipe->force_bru_release = true;
> > +
> > +			vsp1_du_pipeline_setup_input(vsp1, &owner_pipe->pipe);
> > +			vsp1_du_pipeline_configure(&owner_pipe->pipe);
> > +
> > +			ret = wait_event_timeout(owner_pipe->wait_queue,
> > +						 !owner_pipe->force_bru_release,
> > +						 msecs_to_jiffies(500));
> > +			if (ret == 0)
> > +				dev_warn(vsp1->dev,
> > +					 "DRM pipeline %u reconfiguration timeout\n",
> > +					 owner_pipe->pipe.lif->index);
> > +		}
> > +
> > +		/*
> > +		 * If the BRU we have released previously hasn't been acquired
> > +		 * by the other pipeline, add it back to the entities list (with
> > +		 * the pipe pointer NULL) to let vsp1_du_pipeline_configure()
> > +		 * disconnect it from the hardware pipeline.
> > +		 */
> > +		if (released_bru && !released_bru->pipe)
> > +			list_add_tail(&released_bru->list_pipe,
> > +				      &pipe->entities);
> > +
> > +		/* Add the BRU to the pipeline. */
> > +		pipe->bru = bru;
> > +		pipe->bru->pipe = pipe;
> > +		pipe->bru->sink = &pipe->output->entity;
> > +		pipe->bru->sink_pad = 0;
> > +
> > +		list_add_tail(&pipe->bru->list_pipe, &pipe->entities);
> > +	}
> > +
> 
> Phew ... that's quite some chunk of interacting code ...
> 
> I've gone through it with the combinations of two pipes, 1 and 2, then
> swapping them around when say pipe 2 has 3 inputs.
> 
> It seems to scan through OK in my head ... but I think I've gone a bit
> cross-eyed now :D
> 
> Have we got some tests in place for the various combinations of paths
> through here ?

Maybe not for all combinations, but there's a kms-test-brxalloc.py test in the 
bru-brs branch of git://git.ideasonboard.com/renesas/kms-tests.git

> >  	/*
> >  	 * Configure the format on the BRU source and verify that it matches 
the
> >  	 * requested format. We don't set the media bus code as it is 
configured

[snip]

> > @@ -516,6 +623,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
> >   */
> >  
> >  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
> >  {
> > +	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> > +
> > +	mutex_lock(&vsp1->drm->lock);
> 
> Ouch ... we have to lock ...
> 
> >  }
> >  EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
> > 
> > @@ -629,6 +739,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned
> > int pipe_index)
> >  	vsp1_du_pipeline_setup_input(vsp1, pipe);
> >  	vsp1_du_pipeline_configure(pipe);
> > 
> > +	mutex_unlock(&vsp1->drm->lock);
> 
> And unlock in different functions ? :-(
> 
> (Yes, I see that we do - because we are crossing pipes...)

That's also something I would have liked to avoid :-/

> 
> >  }
> >  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);

[snip]

-- 
Regards,

Laurent Pinchart

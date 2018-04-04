Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48540 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752141AbeDDVn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 17:43:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 11/15] v4l: vsp1: Add per-display list completion notification support
Date: Thu, 05 Apr 2018 00:43:37 +0300
Message-ID: <12800662.MfxixVfYp4@avalon>
In-Reply-To: <cebc5274-09f7-b352-122d-debee39218fd@ideasonboard.com>
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com> <20180226214516.11559-12-laurent.pinchart+renesas@ideasonboard.com> <cebc5274-09f7-b352-122d-debee39218fd@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Wednesday, 4 April 2018 19:16:46 EEST Kieran Bingham wrote:
> On 26/02/18 21:45, Laurent Pinchart wrote:
> > Display list completion is already reported to the frame end handler,
> > but that mechanism is global to all display lists. In order to implement
> > BRU and BRS reassignment in DRM pipelines we will need to wait for
> > completion of a particular display list. Extend the display list and
> > frame end handler APIs to support such a notification.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_dl.c    | 27 +++++++++++++++++++++++++--
> >  drivers/media/platform/vsp1/vsp1_dl.h    |  4 ++--
> >  drivers/media/platform/vsp1/vsp1_drm.c   |  4 ++--
> >  drivers/media/platform/vsp1/vsp1_pipe.c  |  5 +++--
> >  drivers/media/platform/vsp1/vsp1_pipe.h  |  3 ++-
> >  drivers/media/platform/vsp1/vsp1_video.c |  4 ++--
> >  6 files changed, 36 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> > b/drivers/media/platform/vsp1/vsp1_dl.c index 0b86ed01e85d..eb2971218e28
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_dl.c
> > +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> > @@ -72,6 +72,7 @@ struct vsp1_dl_body {
> >   * @fragments: list of extra display list bodies
> >   * @has_chain: if true, indicates that there's a partition chain
> >   * @chain: entry in the display list partition chain
> > + * @notify: whether the display list completion should be notified
> >   */
> >  struct vsp1_dl_list {
> >  	struct list_head list;
> > @@ -85,6 +86,8 @@ struct vsp1_dl_list {
> >  	bool has_chain;
> >  	struct list_head chain;
> > +
> > +	bool notify;
> >  };
> >  
> >  enum vsp1_dl_mode {
> > @@ -550,8 +553,16 @@ static void vsp1_dl_list_commit_continuous(struct
> > vsp1_dl_list *dl)> 
> >  	 * case we can't replace the queued list by the new one, as we could
> >  	 * race with the hardware. We thus mark the update as pending, it will
> >  	 * be queued up to the hardware by the frame end interrupt handler.
> > +	 *
> > +	 * If a display list is already pending we simply drop it as the new
> > +	 * display list is assumed to contain a more recent configuration. It
> > is
> > +	 * an error if the already pending list has the notify flag set, as
> > +	 * there is then a process waiting for that list to complete. This
> > +	 * shouldn't happen as the waiting process should perform proper
> > +	 * locking, but warn just in case.
> >  	 */
> >  	if (vsp1_dl_list_hw_update_pending(dlm)) {
> > +		WARN_ON(dlm->pending && dlm->pending->notify);
> >  		__vsp1_dl_list_put(dlm->pending);
> >  		dlm->pending = dl;
> > 
> > @@ -581,7 +592,7 @@ static void vsp1_dl_list_commit_singleshot(struct
> > vsp1_dl_list *dl)
> >  	dlm->active = dl;
> >  }
> > 
> > -void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> > +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool notify)
> 
> Rather than changing the vsp1_dl_list_commit() function - would it be nicer
> to have an API to request or set the notify property? :
> 
> @@..@@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
> ...
> +	/* The BRx will be released, without sending an update to DRM */
> +	if (drm_pipe->force_bru_release)
> +		vsp1_dl_list_request_internal_notify(dl);
> 
> 	vsp1_dl_list_commit(dl);
> ...

That's not a bad idea, but I wonder if it's worth it as we'll have to call an 
extra function for what is essentially an internal API. On the other hand this 
isn't a common case, so it's not a hot code path. We could also argue equally 
that it is the commit that is internal or that it is the display list that is 
for internal purpose. Do you think an extra function call is better ? If you 
do I'll change it.

> >  {
> >  	struct vsp1_dl_manager *dlm = dl->dlm;
> >  	struct vsp1_dl_list *dl_child;
> > @@ -598,6 +609,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> >  		}
> >  	}
> > 
> > +	dl->notify = notify;
> > +
> >  	spin_lock_irqsave(&dlm->lock, flags);
> >  	
> >  	if (dlm->singleshot)
> > @@ -615,16 +628,23 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
> >  /**
> >   * vsp1_dlm_irq_frame_end - Display list handler for the frame end
> >   interrupt
> >   * @dlm: the display list manager
> > + * @notify: whether the display list that completed has notification
> > enabled
> >   *
> >   * Return true if the previous display list has completed at frame end,
> >   or false
> >   * if it has been delayed by one frame because the display list commit
> >   raced
> >   * with the frame end interrupt. The function always returns true in
> >   header mode
> >   * as display list processing is then not continuous and races never
> >   occur.
> > + *
> > + * Upon return, the @notify parameter is set to true if the previous
> > display
> > + * list has completed and had been queued with the notify flag, or to
> > false
> > + * otherwise. Notification is only supported for continuous mode.
> >   */
> > -bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
> > +bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm, bool *notify)
> >  {
> >  	bool completed = false;
> > 
> > +	*notify = false;
> > +
> >  	spin_lock(&dlm->lock);
> >  	
> >  	/*
> > @@ -652,6 +672,9 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager
> > *dlm)
> >  	 * frame end interrupt. The display list thus becomes active.
> >  	 */
> >  	if (dlm->queued) {
> > +		*notify = dlm->queued->notify;
> > +		dlm->queued->notify = false;
> > +
> >  		__vsp1_dl_list_put(dlm->active);
> >  		dlm->active = dlm->queued;
> >  		dlm->queued = NULL;
> > diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
> > b/drivers/media/platform/vsp1/vsp1_dl.h index ee3508172f0a..480c6b0dd2e4
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_dl.h
> > +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> > @@ -27,12 +27,12 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
> > vsp1_device *vsp1,
> >  					unsigned int prealloc);
> >  void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
> >  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
> > -bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
> > +bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm, bool *notify);
> > 
> >  struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
> >  void vsp1_dl_list_put(struct vsp1_dl_list *dl);
> >  void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
> > -void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
> > +void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool notify);
> > 
> >  struct vsp1_dl_body *vsp1_dl_fragment_alloc(struct vsp1_device *vsp1,
> >  					    unsigned int num_entries);
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 1c8adda47440..d705a6e9fa1d
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> > @@ -34,7 +34,7 @@
> >   */
> >  
> >  static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
> > -				       bool completed)
> > +				       bool completed, bool notify)
> >  {
> >  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
> > 
> > @@ -370,7 +370,7 @@ static void vsp1_du_pipeline_configure(struct
> > vsp1_pipeline *pipe)
> >  		}
> >  	}
> > 
> > -	vsp1_dl_list_commit(dl);
> > +	vsp1_dl_list_commit(dl, false);
> >  }
> >  
> >  /* ----------------------------------------------------------------------
> > diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
> > b/drivers/media/platform/vsp1/vsp1_pipe.c index
> > 99ccbac3256a..4d819c9019f4 100644
> > --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> > +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> > @@ -316,6 +316,7 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
> >  void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
> >  {
> >  	bool completed;
> > +	bool notify;
> > 
> >  	if (pipe == NULL)
> >  		return;
> > @@ -325,7 +326,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline
> > *pipe)
> >  	 * up being postponed by one frame. @completed represents whether the
> >  	 * active frame was finished or postponed.
> >  	 */
> > -	completed = vsp1_dlm_irq_frame_end(pipe->output->dlm);
> > +	completed = vsp1_dlm_irq_frame_end(pipe->output->dlm, &notify);
> 
> Eugh ... two return values, one passed back through the return, and the
> other passed as a pointer.

I don't like it much either :-/

> What about converting this to some flags which get passed into the
> pipe->frame_end() instead?

That's a very good idea, I'll do that.

> >  	if (pipe->hgo)
> >  		vsp1_hgo_frame_end(pipe->hgo);
> > 
> > @@ -338,7 +339,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline
> > *pipe)> 
> >  	 * frame_end to account for vblank events.
> >  	 */
> >  	if (pipe->frame_end)
> > -		pipe->frame_end(pipe, completed);
> > +		pipe->frame_end(pipe, completed, notify);
> > 
> >  	pipe->sequence++;
> >  }
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> > b/drivers/media/platform/vsp1/vsp1_pipe.h index
> > dfff9b5685fe..482711024fa2 100644
> > --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> > +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> > @@ -118,7 +118,8 @@ struct vsp1_pipeline {
> >  	enum vsp1_pipeline_state state;
> >  	wait_queue_head_t wq;
> > 
> > -	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed);
> > +	void (*frame_end)(struct vsp1_pipeline *pipe, bool completed,
> > +			  bool notify);
> > 
> >  	struct mutex lock;
> >  	struct kref kref;
> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> > b/drivers/media/platform/vsp1/vsp1_video.c index
> > cdd53d6cc408..483b4259e1b4 100644
> > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -437,14 +437,14 @@ static void vsp1_video_pipeline_run(struct
> > vsp1_pipeline *pipe)> 
> >  	}
> >  	
> >  	/* Complete, and commit the head display list. */
> > -	vsp1_dl_list_commit(pipe->dl);
> > +	vsp1_dl_list_commit(pipe->dl, false);
> > 
> >  	pipe->dl = NULL;
> >  	
> >  	vsp1_pipeline_run(pipe);
> >  }
> >  
> >  static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe,
> > -					  bool completed)
> > +					  bool completed, bool notify)
> >  {
> >  	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
> >  	enum vsp1_pipeline_state state;

-- 
Regards,

Laurent Pinchart

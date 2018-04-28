Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54206 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751151AbeD1TPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 15:15:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 7/8] v4l: vsp1: Integrate DISCOM in display pipeline
Date: Sat, 28 Apr 2018 22:15:38 +0300
Message-ID: <2726723.Sl6OlPdl7O@avalon>
In-Reply-To: <759b7675-d0d5-4a31-0949-2affd4019f77@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-8-laurent.pinchart+renesas@ideasonboard.com> <759b7675-d0d5-4a31-0949-2affd4019f77@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Saturday, 28 April 2018 21:58:53 EEST Kieran Bingham wrote:
> On 22/04/18 23:34, Laurent Pinchart wrote:
> > The DISCOM is used to compute CRCs on display frames. Integrate it in
> > the display pipeline at the output of the blending unit to process
> > output frames.
> > 
> > Computing CRCs on input frames is possible by positioning the DISCOM at
> > a different point in the pipeline. This use case isn't supported at the
> > moment and could be implemented by extending the API between the VSP1
> > and DU drivers if needed.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> Only a couple of small questions - but nothing to block an RB tag.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_drm.c | 115 +++++++++++++++++++++++++++-
> >  drivers/media/platform/vsp1/vsp1_drm.h |  12 ++++
> >  2 files changed, 124 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> > b/drivers/media/platform/vsp1/vsp1_drm.c index 5fc31578f9b0..7864b43a90e1
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.c
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.c

[snip]

> > @@ -748,6 +847,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned
> > int pipe_index,> 
> >  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> >  	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
> > 
> > +	drm_pipe->crc.source = cfg->crc.source;
> > +	drm_pipe->crc.index = cfg->crc.index;
> 
> I think this could be shortened to
> 
> 	drm_pipe->crc = cfg->crc;
> 
> Or is that a GCC extension. Either way, it's just a matter of taste, and you
> might prefer to be more explicit.

That's what I had written in the first place, only to have gcc throwing an 
error because the crc fields are anonymous structures.

> > +
> >  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
> >  	vsp1_du_pipeline_configure(pipe);
> >  	mutex_unlock(&vsp1->drm->lock);

[snip]

> > diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
> > b/drivers/media/platform/vsp1/vsp1_drm.h index e5b88b28806c..1e7670955ef0
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_drm.h
> > +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> > @@ -13,6 +13,8 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/wait.h>
> > 
> > +#include <media/vsp1.h>
> > +
> >  #include "vsp1_pipe.h"
> >  
> >  /**
> > @@ -22,6 +24,9 @@
> >   * @height: output display height
> >   * @force_brx_release: when set, release the BRx during the next
> >   reconfiguration
> >   * @wait_queue: wait queue to wait for BRx release completion
> > + * @uif: UIF entity if available for the pipeline
> > + * @crc.source: source for CRC calculation
> > + * @crc.index: index of the CRC source plane (when crc.source is set to
> > plane)
> >   * @du_complete: frame completion callback for the DU driver (optional)
> >   * @du_private: data to be passed to the du_complete callback
> >   */
> > @@ -34,6 +39,13 @@ struct vsp1_drm_pipeline {
> >  	bool force_brx_release;
> >  	wait_queue_head_t wait_queue;
> > 
> > +	struct vsp1_entity *uif;
> > +
> > +	struct {
> > +		enum vsp1_du_crc_source source;
> > +		unsigned int index;
> > +	} crc;
> 
> Does this have to be duplicated ? Or can it be included from the API
> header...

It's a good point. I thought it might not be worth it just for two fields, but 
I see no compelling reason against it. I'll introduce a new structure.

> > +
> >  	/* Frame synchronisation */
> >  	void (*du_complete)(void *data, bool completed, u32 crc);
> >  	void *du_private;

-- 
Regards,

Laurent Pinchart

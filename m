Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52326 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdCDXku (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 18:40:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 3/3] drm: rcar-du: Register a completion callback with VSP1
Date: Sun, 05 Mar 2017 01:41:23 +0200
Message-ID: <1811507.1SveQbyGeY@avalon>
In-Reply-To: <4036908.C45uQTknvk@avalon>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com> <bbd6cfc198254a60d7369c0101ab027bb7b56946.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com> <4036908.C45uQTknvk@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Saturday 04 Mar 2017 15:07:09 Laurent Pinchart wrote:
> On Saturday 04 Mar 2017 02:01:19 Kieran Bingham wrote:
> > Currently we process page flip events on every display interrupt,
> > however this does not take into consideration the processing time needed
> > by the VSP1 utilised in the pipeline.
> > 
> > Register a callback with the VSP driver to obtain completion events, and
> > track them so that we only perform page flips when the full display
> > pipeline has completed for the frame.
> > 
> > Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > ---
> > 
> > v2:
> >  - Commit message completely re-worded for patch re-work.
> >  - drm_crtc_handle_vblank() re-instated in event of rcrtc->pending
> >  - removed passing of unnecessary 'data' through callbacks
> >  - perform page flips from the VSP completion handler
> >  - add locking around pending flags
> >  
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 10 +++++++--
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  2 ++-
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 29 +++++++++++++++++++++++++++-
> >  3 files changed, 39 insertions(+), 2 deletions(-)

[snip]

> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c index b0ff304ce3dc..1fcd311badb1
> > 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c

[snip]

> > @@ -28,6 +28,22 @@
> >  #include "rcar_du_kms.h"
> >  #include "rcar_du_vsp.h"
> > 
> > +static void rcar_du_vsp_complete(void *private)
> > +{
> > +	struct rcar_du_crtc *crtc = (struct rcar_du_crtc *)private;
> > +	struct drm_device *dev = crtc->crtc.dev;
> > +	unsigned long flags;
> > +	bool pending;
> > +
> > +	spin_lock_irqsave(&dev->event_lock, flags);
> > +	pending = crtc->pending;
> > +	crtc->pending = false;
> > +	spin_unlock_irqrestore(&dev->event_lock, flags);
> > +
> > +	if (pending)
> > +		rcar_du_crtc_finish_page_flip(crtc);
> 
> This seems to duplicate the synchronization mechanism based on events in
> rcar_du_crtc_atomic_begin(). I need to check that in more details.

Indeed it does, and I don't think that's needed. You might be able to shorten 
the race window on the DU side, but you won't be able to close it completely 
as detecting the race requires information that is only available to the VSP 
driver. Fixing the race on the VSP side will make this dead code, so you can 
remove the addition of the pending flag from this patch.

> > +}

-- 
Regards,

Laurent Pinchart

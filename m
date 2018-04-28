Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54382 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751331AbeD1UP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 16:15:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 8/8] drm: rcar-du: Add support for CRC computation
Date: Sat, 28 Apr 2018 23:15:42 +0300
Message-ID: <5006409.6GS1l2aLKO@avalon>
In-Reply-To: <2d89cb02-6df2-0240-82ab-c6b51ef129ac@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-9-laurent.pinchart+renesas@ideasonboard.com> <2d89cb02-6df2-0240-82ab-c6b51ef129ac@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Saturday, 28 April 2018 22:16:48 EEST Kieran Bingham wrote:
> On 22/04/18 23:34, Laurent Pinchart wrote:
> > Implement CRC computation configuration and reporting through the DRM
> > debugfs-based CRC API. The CRC source can be configured to any input
> > plane or the pipeline output.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> I don't think I have any actual blocking questions here, so feel free to add
> a
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> I'll not be in distress if the CRC structures remain duplicated (although I
> see from your other mail you've considered defining the structure
> non-anonymously
> 
> > ---
> > Changes since v1:
> > 
> > - Format the source names using plane IDs instead of plane indices
> > ---
> > 
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 156 ++++++++++++++++++++++++++--
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  19 ++++
> >  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |   7 ++
> >  3 files changed, 176 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> > b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c index c4420538ec85..d71d709fe3d9
> > 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c

[snip]

> > @@ -710,15 +756,111 @@ static void rcar_du_crtc_disable_vblank(struct
> > drm_crtc *crtc)
> >  	rcrtc->vblank_enable = false;
> >  }
> > 
> > -static const struct drm_crtc_funcs crtc_funcs = {
> > -	.reset = drm_atomic_helper_crtc_reset,
> > +static int rcar_du_crtc_set_crc_source(struct drm_crtc *crtc,
> > +				       const char *source_name,
> > +				       size_t *values_cnt)
> > +{
> > +	struct rcar_du_crtc *rcrtc = to_rcar_crtc(crtc);
> > +	struct drm_modeset_acquire_ctx ctx;
> > +	struct drm_crtc_state *crtc_state;
> > +	struct drm_atomic_state *state;
> > +	enum vsp1_du_crc_source source;
> > +	unsigned int index = 0;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	/*
> > +	 * Parse the source name. Supported values are "plane%u" to compute the
> > +	 * CRC on an input plane (%u is the plane ID), and "auto" to compute
> > the
> > +	 * CRC on the composer (VSP) output.
> > +	 */
> > +	if (!source_name) {
> > +		source = VSP1_DU_CRC_NONE;
> > +	} else if (!strcmp(source_name, "auto")) {
> > +		source = VSP1_DU_CRC_OUTPUT;
> > +	} else if (strstarts(source_name, "plane")) {
> > +		source = VSP1_DU_CRC_PLANE;
> > +
> > +		ret = kstrtouint(source_name + strlen("plane"), 10, &index);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		for (i = 0; i < rcrtc->vsp->num_planes; ++i) {
> > +			if (index == rcrtc->vsp->planes[i].plane.base.id) {
> > +				index = i;
> > +				break;
> > +			}
> > +		}
> > +
> > +		if (i >= rcrtc->vsp->num_planes)
> > +			return -EINVAL;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> > +
> > +	*values_cnt = 1;
> > +
> > +	/* Perform an atomic commit to set the CRC source. */
> > +	drm_modeset_acquire_init(&ctx, 0);
> > +
> > +	state = drm_atomic_state_alloc(crtc->dev);
> > +	if (!state) {
> > +		ret = -ENOMEM;
> > +		goto unlock;
> > +	}
> > +
> > +	state->acquire_ctx = &ctx;
> > +
> > +retry:
> > +	crtc_state = drm_atomic_get_crtc_state(state, crtc);
> > +	if (!IS_ERR(crtc_state)) {
> > +		struct rcar_du_crtc_state *rcrtc_state;
> > +
> > +		rcrtc_state = to_rcar_crtc_state(crtc_state);
> > +		rcrtc_state->crc.source = source;
> > +		rcrtc_state->crc.index = index;
> > +
> > +		ret = drm_atomic_commit(state);
> 
> Does this 'cost' a vblank ? (as in - does this action being performed from
> userspace have the capability to cause flicker, or loss of frame?)

It shouldn't cause flicker, but it could delay atomic commits queued by 
userspace by one frame. It's not ideal, but given that changing the CRC source 
requires a pipeline update on the VSP side, creating an atomic commit 
internally in the driver was the easiest solution.

Now that the BRU/BRS series has created infrastructure on the VSP side to 
perform pipeline reconfiguration we could also take advantage of that, but it 
would still incur a delay of one frame, so I don't think that would really 
help.

> > +	} else {
> > +		ret = PTR_ERR(crtc_state);
> > +	}
> > +
> > +	if (ret == -EDEADLK) {
> > +		drm_atomic_state_clear(state);
> > +		drm_modeset_backoff(&ctx);
> > +		goto retry;
> 
> Not knowing what the -EDEADLK represents yet, this isn't an infinite loop
> opportunity is it ? (I assume the state_clear(),backoff() clean up and
> prevent that.)

-EDEADLK comes from the drm_atomic_get_crtc_state() or drm_atomic_commit() 
calls trying to lock a ww-mutex in a way that would cause a deadlock. In that 
case a backoff sequence is needed to release all locks that have been 
successfully taken, followed by a retry. The ww-mutex API should prevent 
infinite loops by ensuring fairness between the contenders.

> > +	}
> > +
> > +	drm_atomic_state_put(state);
> > +
> > +unlock:
> > +	drm_modeset_drop_locks(&ctx);
> > +	drm_modeset_acquire_fini(&ctx);
> > +
> > +	return 0;
> > +}

[snip]

> > diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> > b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h index fdc2bf99bda1..518ee2c60eb8
> > 100644
> > --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> > +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> > @@ -21,6 +21,8 @@
> >  #include <drm/drmP.h>
> >  #include <drm/drm_crtc.h>
> > 
> > +#include <media/vsp1.h>
> > +
> >  struct rcar_du_group;
> >  struct rcar_du_vsp;
> > 
> > @@ -69,6 +71,23 @@ struct rcar_du_crtc {
> > 
> >  #define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
> > 
> > +/**
> > + * struct rcar_du_crtc_state - Driver-specific CRTC state
> > + * @state: base DRM CRTC state
> > + * @crc.source: source for CRC calculation
> > + * @crc.index: index of the CRC source plane (when crc.source is set to
> > plane)
> > + */
> > +struct rcar_du_crtc_state {
> > +	struct drm_crtc_state state;
> > +
> > +	struct {
> > +		enum vsp1_du_crc_source source;
> > +		unsigned int index;
> > +	} crc;
> 
> Another definition of this structure ... (is this the third?) do we need to
> replicate it each time ? (I know it's small ... but I love to keep things
> DRY)

I'll fix that as I've introduced a vsp1_du_crc_config structure in response to 
your review of patch 7/8.

> > +};
> > +
> > +#define to_rcar_crtc_state(s) container_of(s, struct rcar_du_crtc_state,
> > state)
> > +
> >  enum rcar_du_output {
> >  	RCAR_DU_OUTPUT_DPAD0,
> >  	RCAR_DU_OUTPUT_DPAD1,

-- 
Regards,

Laurent Pinchart

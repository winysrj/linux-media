Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36360 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752417AbcJKQrt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 12:47:49 -0400
Received: by mail-lf0-f67.google.com with SMTP id b75so4696906lfg.3
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 09:47:48 -0700 (PDT)
Date: Tue, 11 Oct 2016 17:51:36 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Brian Starkey <brian.starkey@arm.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, liviu.dudau@arm.com,
        robdclark@gmail.com, hverkuil@xs4all.nl, eric@anholt.net,
        ville.syrjala@linux.intel.com, daniel@ffwll.ch
Subject: Re: [RFC PATCH 04/11] drm: Add __drm_framebuffer_remove_atomic
Message-ID: <20161011155136.GG20761@phenom.ffwll.local>
References: <1476197648-24918-1-git-send-email-brian.starkey@arm.com>
 <1476197648-24918-5-git-send-email-brian.starkey@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476197648-24918-5-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 11, 2016 at 03:54:01PM +0100, Brian Starkey wrote:
> Implement the CRTC/Plane disable functionality of drm_framebuffer_remove
> using the atomic API, and use it if possible.
> 
> For atomic drivers, this removes the possibility of several commits when
> a framebuffer is in use by more than one CRTC/plane.
> 
> Additionally, this will provide a suitable place to support the removal
> of a framebuffer from a writeback connector, in the case that a
> writeback connector is still actively using a framebuffer when it is
> removed by userspace.
> 
> Signed-off-by: Brian Starkey <brian.starkey@arm.com>

Just the small comment here: Last time around I wanted toland an atomic
disable function for fb remove code it blew up. Need to check out git
history to make sure we've addressed those isses.  Caveat emperor ;-)
-Daniel

> ---
>  drivers/gpu/drm/drm_framebuffer.c |  154 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 152 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
> index 528f75d..b02cf73 100644
> --- a/drivers/gpu/drm/drm_framebuffer.c
> +++ b/drivers/gpu/drm/drm_framebuffer.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/export.h>
>  #include <drm/drmP.h>
> +#include <drm/drm_atomic.h>
>  #include <drm/drm_auth.h>
>  #include <drm/drm_framebuffer.h>
>  
> @@ -795,6 +796,148 @@ void drm_framebuffer_cleanup(struct drm_framebuffer *fb)
>  EXPORT_SYMBOL(drm_framebuffer_cleanup);
>  
>  /**
> + * __drm_framebuffer_remove_atomic - atomic version of __drm_framebuffer_remove
> + * @dev: drm device
> + * @fb: framebuffer to remove
> + *
> + * If the driver implements the atomic API, we can handle the disabling of all
> + * CRTCs/planes which use a framebuffer which is going away in a single atomic
> + * commit.
> + *
> + * This scans all CRTCs and planes in @dev's mode_config. If they're using @fb,
> + * it is removed and the CRTC/plane disabled.
> + * The legacy references are dropped and the ->fb pointers set to NULL
> + * accordingly.
> + *
> + * Returns:
> + * true if the framebuffer was successfully removed from use
> + */
> +static bool __drm_framebuffer_remove_atomic(struct drm_device *dev,
> +		struct drm_framebuffer *fb)
> +{
> +	struct drm_modeset_acquire_ctx ctx;
> +	struct drm_atomic_state *state;
> +	struct drm_connector_state *conn_state;
> +	struct drm_connector *connector;
> +	struct drm_plane *plane;
> +	struct drm_crtc *crtc;
> +	unsigned plane_mask;
> +	int i, ret;
> +
> +	drm_modeset_acquire_init(&ctx, 0);
> +
> +	state = drm_atomic_state_alloc(dev);
> +	if (!state)
> +		return false;
> +
> +	state->acquire_ctx = &ctx;
> +
> +retry:
> +	drm_for_each_crtc(crtc, dev) {
> +		struct drm_plane_state *primary_state;
> +		struct drm_crtc_state *crtc_state;
> +
> +		primary_state = drm_atomic_get_plane_state(state, crtc->primary);
> +		if (IS_ERR(primary_state)) {
> +			ret = PTR_ERR(primary_state);
> +			goto fail;
> +		}
> +
> +		if (primary_state->fb != fb)
> +			continue;
> +
> +		crtc_state = drm_atomic_get_crtc_state(state, crtc);
> +		if (IS_ERR(crtc_state)) {
> +			ret = PTR_ERR(crtc_state);
> +			goto fail;
> +		}
> +
> +		/* Only handle the CRTC itself here, handle the plane later */
> +		ret = drm_atomic_set_mode_for_crtc(crtc_state, NULL);
> +		if (ret != 0)
> +			goto fail;
> +
> +		crtc_state->active = false;
> +
> +		/* Get the connectors in order to disable them */
> +		ret = drm_atomic_add_affected_connectors(state, crtc);
> +		if (ret)
> +			goto fail;
> +	}
> +
> +	plane_mask = 0;
> +	drm_for_each_plane(plane, dev) {
> +		struct drm_plane_state *plane_state;
> +
> +		plane_state = drm_atomic_get_plane_state(state, plane);
> +		if (IS_ERR(plane_state)) {
> +			ret = PTR_ERR(plane_state);
> +			goto fail;
> +		}
> +
> +		if (plane_state->fb != fb)
> +			continue;
> +
> +		plane->old_fb = plane->fb;
> +		plane_mask |= 1 << drm_plane_index(plane);
> +
> +		/*
> +		 * Open-coded copy of __drm_atomic_helper_disable_plane to avoid
> +		 * a dependency on atomic-helper
> +		 */
> +		ret = drm_atomic_set_crtc_for_plane(plane_state, NULL);
> +		if (ret != 0)
> +			goto fail;
> +
> +		drm_atomic_set_fb_for_plane(plane_state, NULL);
> +		plane_state->crtc_x = 0;
> +		plane_state->crtc_y = 0;
> +		plane_state->crtc_w = 0;
> +		plane_state->crtc_h = 0;
> +		plane_state->src_x = 0;
> +		plane_state->src_y = 0;
> +		plane_state->src_w = 0;
> +		plane_state->src_h = 0;
> +	}
> +
> +	/* All of the connectors in state need disabling */
> +	for_each_connector_in_state(state, connector, conn_state, i) {
> +		ret = drm_atomic_set_crtc_for_connector(conn_state,
> +							NULL);
> +		if (ret)
> +			goto fail;
> +	}
> +
> +	if (WARN_ON(!plane_mask)) {
> +		DRM_ERROR("Couldn't find any usage of [FB:%d]\n", fb->base.id);
> +		ret = -ENOENT;
> +		goto fail;
> +	}
> +
> +	ret = drm_atomic_commit(state);
> +
> +fail:
> +	drm_atomic_clean_old_fb(dev, plane_mask, ret);
> +
> +	if (ret == -EDEADLK)
> +		goto backoff;
> +
> +	if (ret != 0)
> +		drm_atomic_state_free(state);
> +
> +	drm_modeset_drop_locks(&ctx);
> +	drm_modeset_acquire_fini(&ctx);
> +
> +	return ret ? false : true;
> +
> +backoff:
> +	drm_atomic_state_clear(state);
> +	drm_modeset_backoff(&ctx);
> +
> +	goto retry;
> +}
> +
> +/**
>   * __drm_framebuffer_remove - remove all usage of a framebuffer object
>   * @dev: drm device
>   * @fb: framebuffer to remove
> @@ -869,9 +1012,16 @@ void drm_framebuffer_remove(struct drm_framebuffer *fb)
>  	 * in-use fb with fb-id == 0. Userspace is allowed to shoot its own foot
>  	 * in this manner.
>  	 */
> -	if (drm_framebuffer_read_refcount(fb) > 1)
> -		if (!__drm_framebuffer_remove(dev, fb))
> +	if (drm_framebuffer_read_refcount(fb) > 1) {
> +		bool removed;
> +		if (dev->mode_config.funcs->atomic_commit)
> +			removed = __drm_framebuffer_remove_atomic(dev, fb);
> +		else
> +			removed = __drm_framebuffer_remove(dev, fb);
> +
> +		if (!removed)
>  			DRM_ERROR("failed to remove fb from active usage\n");
> +	}
>  
>  	drm_framebuffer_unreference(fb);
>  }
> -- 
> 1.7.9.5
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

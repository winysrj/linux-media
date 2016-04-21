Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35234 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDUQK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 12:10:29 -0400
Received: by mail-wm0-f42.google.com with SMTP id e201so92818118wme.0
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2016 09:10:28 -0700 (PDT)
Date: Thu, 21 Apr 2016 18:10:25 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] drm: rcar-du: Add Z-order support for VSP planes
Message-ID: <20160421161025.GD2510@phenom.ffwll.local>
References: <1461201253-12170-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1461201253-12170-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461201253-12170-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 21, 2016 at 04:14:12AM +0300, Laurent Pinchart wrote:
> Make the Z-order of VSP planes configurable through the zpos property,
> exactly as for the native DU planes.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 16 ++++++++++++----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h |  2 ++
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index de7ef041182b..62e9619eaea4 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -180,8 +180,9 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
>  
>  	WARN_ON(!pixelformat);
>  
> -	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, pixelformat,
> -			      fb->pitches[0], paddr, &src, &dst);
> +	vsp1_du_atomic_update_zpos(plane->vsp->vsp, plane->index, pixelformat,
> +				   fb->pitches[0], paddr, &src, &dst,
> +				   state->zpos);
>  }
>  
>  static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
> @@ -220,8 +221,8 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
>  	if (plane->state->crtc)
>  		rcar_du_vsp_plane_setup(rplane);
>  	else
> -		vsp1_du_atomic_update(rplane->vsp->vsp, rplane->index, 0, 0, 0,
> -				      NULL, NULL);
> +		vsp1_du_atomic_update_zpos(rplane->vsp->vsp, rplane->index,
> +					   0, 0, 0, NULL, NULL, 0);
>  }
>  
>  static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
> @@ -269,6 +270,7 @@ static void rcar_du_vsp_plane_reset(struct drm_plane *plane)
>  		return;
>  
>  	state->alpha = 255;
> +	state->zpos = plane->type == DRM_PLANE_TYPE_PRIMARY ? 0 : 1;
>  
>  	plane->state = &state->state;
>  	plane->state->plane = plane;
> @@ -283,6 +285,8 @@ static int rcar_du_vsp_plane_atomic_set_property(struct drm_plane *plane,
>  
>  	if (property == rcdu->props.alpha)
>  		rstate->alpha = val;
> +	else if (property == rcdu->props.zpos)
> +		rstate->zpos = val;
>  	else
>  		return -EINVAL;
>  
> @@ -299,6 +303,8 @@ static int rcar_du_vsp_plane_atomic_get_property(struct drm_plane *plane,
>  
>  	if (property == rcdu->props.alpha)
>  		*val = rstate->alpha;
> +	else if (property == rcdu->props.zpos)
> +		*val = rstate->zpos;
>  	else
>  		return -EINVAL;
>  
> @@ -378,6 +384,8 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
>  
>  		drm_object_attach_property(&plane->plane.base,
>  					   rcdu->props.alpha, 255);
> +		drm_object_attach_property(&plane->plane.base,
> +					   rcdu->props.zpos, 1);
>  	}
>  
>  	return 0;
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> index df3bf3805c69..510dcc9c6816 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> @@ -44,6 +44,7 @@ static inline struct rcar_du_vsp_plane *to_rcar_vsp_plane(struct drm_plane *p)
>   * @state: base DRM plane state
>   * @format: information about the pixel format used by the plane
>   * @alpha: value of the plane alpha property
> + * @zpos: value of the plane zpos property
>   */
>  struct rcar_du_vsp_plane_state {
>  	struct drm_plane_state state;
> @@ -51,6 +52,7 @@ struct rcar_du_vsp_plane_state {
>  	const struct rcar_du_format_info *format;
>  
>  	unsigned int alpha;
> +	unsigned int zpos;

There's lots of effort by various people to create a generic zpos/blending
set of properties. Care to jump onto that effort and making it finally
happen for real? I kinda don't want to have a propliferation of slightly
diffferent zpos/blending props across all the drivers ...
-Daniel

>  };
>  
>  static inline struct rcar_du_vsp_plane_state *
> -- 
> 2.7.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

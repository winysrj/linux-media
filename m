Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46359 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751866AbdHASKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 14:10:24 -0400
Subject: Re: [PATCH v2 12/14] drm: rcar-du: Support multiple sources from the
 same VSP
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-13-laurent.pinchart+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <2ff1d13c-cdf9-3e65-d24d-72b9deb3d3cb@ideasonboard.com>
Date: Tue, 1 Aug 2017 19:10:20 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-13-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/06/17 19:12, Laurent Pinchart wrote:
> On R-Car H3 ES2.0, DU channels 0 and 3 are served by two separate
> pipelines from the same VSP. Support this in the DU driver.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

This looks good to me.

Minor nit / comment can be safely ignored. Mostly just me thinking outload.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c |  2 +-
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  3 ++
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c  | 91 ++++++++++++++++++++++++++++++----
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 37 +++++++-------
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h  | 10 +++-
>  5 files changed, 110 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> index 345eff72f581..8f942ebdd0c6 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -721,7 +721,7 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp, unsigned int index)
>  	rcrtc->index = index;
>  
>  	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE))
> -		primary = &rcrtc->vsp->planes[0].plane;
> +		primary = &rcrtc->vsp->planes[rcrtc->vsp_pipe].plane;
>  	else
>  		primary = &rgrp->planes[index % 2].plane;
>  
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> index b199ed5adf36..0b6d26ecfc38 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -35,6 +35,8 @@ struct rcar_du_vsp;
>   * @flip_wait: wait queue used to signal page flip completion
>   * @outputs: bitmask of the outputs (enum rcar_du_output) driven by this CRTC
>   * @group: CRTC group this CRTC belongs to
> + * @vsp: VSP feeding video to this CRTC
> + * @vsp_pipe: index of the VSP pipeline feeding video to this CRTC
>   */
>  struct rcar_du_crtc {
>  	struct drm_crtc crtc;
> @@ -52,6 +54,7 @@ struct rcar_du_crtc {
>  
>  	struct rcar_du_group *group;
>  	struct rcar_du_vsp *vsp;
> +	unsigned int vsp_pipe;
>  };
>  
>  #define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> index f4125c8ca902..82b978a5dae6 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
> @@ -432,6 +432,83 @@ static int rcar_du_properties_init(struct rcar_du_device *rcdu)
>  	return 0;
>  }
>  
> +static int rcar_du_vsps_init(struct rcar_du_device *rcdu)
> +{
> +	const struct device_node *np = rcdu->dev->of_node;
> +	struct of_phandle_args args;
> +	struct {
> +		struct device_node *np;
> +		unsigned int crtcs_mask;
> +	} vsps[RCAR_DU_MAX_VSPS] = { { 0, }, };
> +	unsigned int vsps_count = 0;
> +	unsigned int cells;
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * First parse the DT vsps property to populate the list of VSPs. Each
> +	 * entry contains a pointer to the VSP DT node and a bitmask of the
> +	 * connected DU CRTCs.
> +	 */
> +	cells = of_property_count_u32_elems(np, "vsps") / rcdu->num_crtcs - 1;
> +	if (cells > 1)
> +		return -EINVAL;
> +
> +	for (i = 0; i < rcdu->num_crtcs; ++i) {
> +		unsigned int j;
> +
> +		ret = of_parse_phandle_with_fixed_args(np, "vsps", cells, i,
> +						       &args);
> +		if (ret < 0)
> +			goto error;
> +
> +		/*
> +		 * Add the VSP to the list or update the corresponding existing
> +		 * entry if the VSP has already been added.
> +		 */
> +		for (j = 0; j < vsps_count; ++j) {
> +			if (vsps[j].np == args.np)
> +				break;
> +		}
> +
> +		if (j < vsps_count)
> +			of_node_put(args.np);
> +		else
> +			vsps[vsps_count++].np = args.np;
> +
> +		vsps[j].crtcs_mask |= 1 << i;

I do love the BIT(x) macro personally - but it's not important :)

> +
> +		/* Store the VSP pointer and pipe index in the CRTC. */
> +		rcdu->crtcs[i].vsp = &rcdu->vsps[j];
> +		rcdu->crtcs[i].vsp_pipe = cells >= 1 ? args.args[0] : 0;
> +	}
> +
> +	/*
> +	 * Then initialize all the VSPs from the node pointers and CRTCs bitmask
> +	 * computed previously.
> +	 */
> +	for (i = 0; i < vsps_count; ++i) {
> +		struct rcar_du_vsp *vsp = &rcdu->vsps[i];
> +
> +		vsp->index = i;
> +		vsp->dev = rcdu;
> +
> +		ret = rcar_du_vsp_init(vsp, vsps[i].np, vsps[i].crtcs_mask);
> +		if (ret < 0)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	for (i = 0; i < ARRAY_SIZE(vsps); ++i) {
> +		if (vsps[i].np)

Minor nit: of_node_put already has NULL protection so we don't need this 'if'
but it probably does make it clearer that we are only putting back nodes that we
collected.

> +			of_node_put(vsps[i].np);
> +	}
> +
> +	return ret;
> +}
> +
>  int rcar_du_modeset_init(struct rcar_du_device *rcdu)
>  {
>  	static const unsigned int mmio_offsets[] = {
> @@ -499,17 +576,9 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
>  
>  	/* Initialize the compositors. */
>  	if (rcar_du_has(rcdu, RCAR_DU_FEATURE_VSP1_SOURCE)) {
> -		for (i = 0; i < rcdu->num_crtcs; ++i) {
> -			struct rcar_du_vsp *vsp = &rcdu->vsps[i];
> -
> -			vsp->index = i;
> -			vsp->dev = rcdu;
> -			rcdu->crtcs[i].vsp = vsp;
> -
> -			ret = rcar_du_vsp_init(vsp);
> -			if (ret < 0)
> -				return ret;
> -		}
> +		ret = rcar_du_vsps_init(rcdu);
> +		if (ret < 0)
> +			return ret;
>  	}
>  
>  	/* Create the CRTCs. */
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index d46dce054442..3e9098dac0d2 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -19,6 +19,7 @@
>  #include <drm/drm_gem_cma_helper.h>
>  #include <drm/drm_plane_helper.h>
>  
> +#include <linux/bitops.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/of_platform.h>
>  #include <linux/scatterlist.h>
> @@ -81,22 +82,22 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  	 */
>  	crtc->group->need_restart = true;
>  
> -	vsp1_du_setup_lif(crtc->vsp->vsp, 0, &cfg);
> +	vsp1_du_setup_lif(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
>  }
>  
>  void rcar_du_vsp_disable(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_setup_lif(crtc->vsp->vsp, 0, NULL);
> +	vsp1_du_setup_lif(crtc->vsp->vsp, crtc->vsp_pipe, NULL);
>  }
>  
>  void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_begin(crtc->vsp->vsp, 0);
> +	vsp1_du_atomic_begin(crtc->vsp->vsp, crtc->vsp_pipe);
>  }
>  
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_flush(crtc->vsp->vsp, 0);
> +	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe);
>  }
>  
>  /* Keep the two tables in sync. */
> @@ -162,6 +163,7 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
>  {
>  	struct rcar_du_vsp_plane_state *state =
>  		to_rcar_vsp_plane_state(plane->plane.state);
> +	struct rcar_du_crtc *crtc = to_rcar_crtc(state->state.crtc);
>  	struct drm_framebuffer *fb = plane->plane.state->fb;
>  	struct vsp1_du_atomic_config cfg = {
>  		.pixelformat = 0,
> @@ -192,7 +194,8 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
>  		}
>  	}
>  
> -	vsp1_du_atomic_update(plane->vsp->vsp, 0, plane->index, &cfg);
> +	vsp1_du_atomic_update(plane->vsp->vsp, crtc->vsp_pipe,
> +			      plane->index, &cfg);
>  }
>  
>  static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
> @@ -288,11 +291,13 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
>  					struct drm_plane_state *old_state)
>  {
>  	struct rcar_du_vsp_plane *rplane = to_rcar_vsp_plane(plane);
> +	struct rcar_du_crtc *crtc = to_rcar_crtc(old_state->crtc);
>  
>  	if (plane->state->crtc)
>  		rcar_du_vsp_plane_setup(rplane);
>  	else
> -		vsp1_du_atomic_update(rplane->vsp->vsp, 0, rplane->index, NULL);
> +		vsp1_du_atomic_update(rplane->vsp->vsp, crtc->vsp_pipe,
> +				      rplane->index, NULL);
>  }
>  
>  static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
> @@ -391,23 +396,17 @@ static const struct drm_plane_funcs rcar_du_vsp_plane_funcs = {
>  	.atomic_get_property = rcar_du_vsp_plane_atomic_get_property,
>  };
>  
> -int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
> +int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
> +		     unsigned int crtcs)
>  {
>  	struct rcar_du_device *rcdu = vsp->dev;
>  	struct platform_device *pdev;
> -	struct device_node *np;
> +	unsigned int num_crtcs = hweight32(crtcs);

Ohhh a new one to me - I didn't know we had hweight in the kernel. I think I'd
done bit-counts maually elsewhere. :S

/me updates mind wiki.


>  	unsigned int i;
>  	int ret;
>  
>  	/* Find the VSP device and initialize it. */
> -	np = of_parse_phandle(rcdu->dev->of_node, "vsps", vsp->index);
> -	if (!np) {
> -		dev_err(rcdu->dev, "vsps node not found\n");
> -		return -ENXIO;
> -	}
> -
>  	pdev = of_find_device_by_node(np);
> -	of_node_put(np);
>  	if (!pdev)
>  		return -ENXIO;
>  
> @@ -428,15 +427,15 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp)
>  		return -ENOMEM;
>  
>  	for (i = 0; i < vsp->num_planes; ++i) {
> -		enum drm_plane_type type = i ? DRM_PLANE_TYPE_OVERLAY
> -					 : DRM_PLANE_TYPE_PRIMARY;
> +		enum drm_plane_type type = i < num_crtcs
> +					 ? DRM_PLANE_TYPE_PRIMARY
> +					 : DRM_PLANE_TYPE_OVERLAY;
>  		struct rcar_du_vsp_plane *plane = &vsp->planes[i];
>  
>  		plane->vsp = vsp;
>  		plane->index = i;
>  
> -		ret = drm_universal_plane_init(rcdu->ddev, &plane->plane,
> -					       1 << vsp->index,
> +		ret = drm_universal_plane_init(rcdu->ddev, &plane->plane, crtcs,
>  					       &rcar_du_vsp_plane_funcs,
>  					       formats_kms,
>  					       ARRAY_SIZE(formats_kms), type,
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> index 8861661590ff..f876c512163c 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> @@ -64,13 +64,19 @@ to_rcar_vsp_plane_state(struct drm_plane_state *state)
>  }
>  
>  #ifdef CONFIG_DRM_RCAR_VSP
> -int rcar_du_vsp_init(struct rcar_du_vsp *vsp);
> +int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
> +		     unsigned int crtcs);
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_disable(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc);
>  #else
> -static inline int rcar_du_vsp_init(struct rcar_du_vsp *vsp) { return -ENXIO; };
> +static inline int rcar_du_vsp_init(struct rcar_du_vsp *vsp,
> +				   struct device_node *np,
> +				   unsigned int crtcs)
> +{
> +	return -ENXIO;
> +}
>  static inline void rcar_du_vsp_enable(struct rcar_du_crtc *crtc) { };
>  static inline void rcar_du_vsp_disable(struct rcar_du_crtc *crtc) { };
>  static inline void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc) { };
> 

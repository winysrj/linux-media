Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34088 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdGMNQH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 09:16:07 -0400
Subject: Re: [PATCH v2 06/14] v4l: vsp1: Add pipe index argument to the VSP-DU
 API
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20170626181226.29575-1-laurent.pinchart+renesas@ideasonboard.com>
 <20170626181226.29575-7-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <915884a5-e69d-b821-4a53-afa73a03c233@gmail.com>
Date: Thu, 13 Jul 2017 14:16:03 +0100
MIME-Version: 1.0
In-Reply-To: <20170626181226.29575-7-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 19:12, Laurent Pinchart wrote:
> In the H3 ES2.0 SoC the VSP2-DL instance has two connections to DU
> channels that need to be configured independently. Extend the VSP-DU API
> with a pipeline index to identify which pipeline the caller wants to
> operate on.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

A bit of comment merge between this and the next patch but it's minor and not
worth the effort to change that ... so I'll happily ignore it if you do :)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 12 ++++++------
>  drivers/media/platform/vsp1/vsp1_drm.c | 32 ++++++++++++++++++++++----------
>  include/media/vsp1.h                   | 10 ++++++----
>  3 files changed, 34 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index f870445ebc8d..d46dce054442 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -81,22 +81,22 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
>  	 */
>  	crtc->group->need_restart = true;
>  
> -	vsp1_du_setup_lif(crtc->vsp->vsp, &cfg);
> +	vsp1_du_setup_lif(crtc->vsp->vsp, 0, &cfg);
>  }
>  
>  void rcar_du_vsp_disable(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_setup_lif(crtc->vsp->vsp, NULL);
> +	vsp1_du_setup_lif(crtc->vsp->vsp, 0, NULL);
>  }
>  
>  void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_begin(crtc->vsp->vsp);
> +	vsp1_du_atomic_begin(crtc->vsp->vsp, 0);
>  }
>  
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_flush(crtc->vsp->vsp);
> +	vsp1_du_atomic_flush(crtc->vsp->vsp, 0);
>  }
>  
>  /* Keep the two tables in sync. */
> @@ -192,7 +192,7 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
>  		}
>  	}
>  
> -	vsp1_du_atomic_update(plane->vsp->vsp, plane->index, &cfg);
> +	vsp1_du_atomic_update(plane->vsp->vsp, 0, plane->index, &cfg);
>  }
>  
>  static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
> @@ -292,7 +292,7 @@ static void rcar_du_vsp_plane_atomic_update(struct drm_plane *plane,
>  	if (plane->state->crtc)
>  		rcar_du_vsp_plane_setup(rplane);
>  	else
> -		vsp1_du_atomic_update(rplane->vsp->vsp, rplane->index, NULL);
> +		vsp1_du_atomic_update(rplane->vsp->vsp, 0, rplane->index, NULL);
>  }
>  
>  static const struct drm_plane_helper_funcs rcar_du_vsp_plane_helper_funcs = {
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index c72d021ff820..daaafe7885fa 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -58,21 +58,26 @@ EXPORT_SYMBOL_GPL(vsp1_du_init);
>  /**
>   * vsp1_du_setup_lif - Setup the output part of the VSP pipeline
>   * @dev: the VSP device
> + * @pipe_index: the DRM pipeline index
>   * @cfg: the LIF configuration
>   *
>   * Configure the output part of VSP DRM pipeline for the given frame @cfg.width
> - * and @cfg.height. This sets up formats on the BRU source pad, the WPF0 sink
> - * and source pads, and the LIF sink pad.
> + * and @cfg.height. This sets up formats on the blend unit (BRU or BRS) source
> + * pad, the WPF sink and source pads, and the LIF sink pad.
>   *
> - * As the media bus code on the BRU source pad is conditioned by the
> - * configuration of the BRU sink 0 pad, we also set up the formats on all BRU
> + * The @pipe_index argument selects which DRM pipeline to setup. The number of
> + * available pipelines depend on the VSP instance.
> + *
> + * As the media bus code on the blend unit source pad is conditioned by the
> + * configuration of its sink 0 pad, we also set up the formats on all blend unit
>   * sinks, even if the configuration will be overwritten later by
> - * vsp1_du_setup_rpf(). This ensures that the BRU configuration is set to a well
> - * defined state.
> + * vsp1_du_setup_rpf(). This ensures that the blend unit configuration is set to
> + * a well defined state.

I presume those comment updates for the BRU/ blend-unit configuration are
actually for the next patch - but I don't think it matters here - and isn't
worth the effort to move the hunks.

It all reads OK.


>   *
>   * Return 0 on success or a negative error code on failure.
>   */
> -int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
> +int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
> +		      const struct vsp1_du_lif_config *cfg)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> @@ -81,6 +86,9 @@ int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg)
>  	unsigned int i;
>  	int ret;
>  
> +	if (pipe_index > 0)
> +		return -EINVAL;
> +
>  	if (!cfg) {
>  		/*
>  		 * NULL configuration means the CRTC is being disabled, stop
> @@ -232,8 +240,9 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
>  /**
>   * vsp1_du_atomic_begin - Prepare for an atomic update
>   * @dev: the VSP device
> + * @pipe_index: the DRM pipeline index
>   */
> -void vsp1_du_atomic_begin(struct device *dev)
> +void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> @@ -245,6 +254,7 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
>  /**
>   * vsp1_du_atomic_update - Setup one RPF input of the VSP pipeline
>   * @dev: the VSP device
> + * @pipe_index: the DRM pipeline index
>   * @rpf_index: index of the RPF to setup (0-based)
>   * @cfg: the RPF configuration
>   *
> @@ -271,7 +281,8 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
>   *
>   * Return 0 on success or a negative error code on failure.
>   */
> -int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
> +int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
> +			  unsigned int rpf_index,
>  			  const struct vsp1_du_atomic_config *cfg)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> @@ -437,8 +448,9 @@ static unsigned int rpf_zpos(struct vsp1_device *vsp1, struct vsp1_rwpf *rpf)
>  /**
>   * vsp1_du_atomic_flush - Commit an atomic update
>   * @dev: the VSP device
> + * @pipe_index: the DRM pipeline index
>   */
> -void vsp1_du_atomic_flush(struct device *dev)
> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_pipeline *pipe = &vsp1->drm->pipe;
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index c837383b2013..c8fc868fb0f2 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -38,7 +38,8 @@ struct vsp1_du_lif_config {
>  	void *callback_data;
>  };
>  
> -int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config *cfg);
> +int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
> +		      const struct vsp1_du_lif_config *cfg);
>  
>  struct vsp1_du_atomic_config {
>  	u32 pixelformat;
> @@ -50,10 +51,11 @@ struct vsp1_du_atomic_config {
>  	unsigned int zpos;
>  };
>  
> -void vsp1_du_atomic_begin(struct device *dev);
> -int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
> +void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
> +int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
> +			  unsigned int rpf,
>  			  const struct vsp1_du_atomic_config *cfg);
> -void vsp1_du_atomic_flush(struct device *dev);
> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index);
>  int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
>  void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
>  
> 

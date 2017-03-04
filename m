Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52348 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752186AbdCDXr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Mar 2017 18:47:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/3] v4l: vsp1: extend VSP1 module API to allow DRM callbacks
Date: Sun, 05 Mar 2017 01:48:33 +0200
Message-ID: <5795168.BWSj1XIdJL@avalon>
In-Reply-To: <b23c4017e8f7346a1c15d7e192a8e0f626121dca.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4a217716bf5515d07dcb6d2b052f883eeecae9e8.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com> <b23c4017e8f7346a1c15d7e192a8e0f626121dca.1488592678.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Saturday 04 Mar 2017 02:01:17 Kieran Bingham wrote:
> To be able to perform page flips in DRM without flicker we need to be
> able to notify the rcar-du module when the VSP has completed its
> processing.
> 
> We must not have bidirectional dependencies on the two components to
> maintain support for loadable modules, thus we extend the API to allow
> a callback to be registered within the VSP DRM interface.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v2:
>  - vsp1_du_setup_lif() uses config structure to set callbacks
>  - vsp1_du_pipeline_frame_end() moved to interrupt section
>  - vsp1_du_pipeline_frame_end registered in vsp1_drm_init()
>    meaning of any NULL values
>  - removed unnecessary 'private data' variables
> 
>  drivers/media/platform/vsp1/vsp1_drm.c | 20 ++++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_drm.h | 10 ++++++++++
>  include/media/vsp1.h                   |  3 +++
>  3 files changed, 33 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
> b/drivers/media/platform/vsp1/vsp1_drm.c index 7dce55043379..85e5ebca82a5
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -36,6 +36,16 @@ void vsp1_drm_display_start(struct vsp1_device *vsp1)
>  	vsp1_dlm_irq_display_start(vsp1->drm->pipe.output->dlm);
>  }
> 
> +static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe)
> +{
> +	struct vsp1_drm *drm = to_vsp1_drm(pipe);
> +
> +	if (drm->du_complete && drm->du_pending) {
> +		drm->du_complete(drm->du_private);
> +		drm->du_pending = false;
> +	}
> +}
> +
>  /* ------------------------------------------------------------------------
>   * DU Driver API
>   */
> @@ -95,6 +105,7 @@ int vsp1_du_setup_lif(struct device *dev, const struct
> vsp1_du_lif_config *cfg)
> 		}
> 
>  		pipe->num_inputs = 0;
> +		vsp1->drm->du_complete = NULL;
> 
>  		vsp1_dlm_reset(pipe->output->dlm);
>  		vsp1_device_put(vsp1);
> @@ -196,6 +207,13 @@ int vsp1_du_setup_lif(struct device *dev, const struct
> vsp1_du_lif_config *cfg) if (ret < 0)
>  		return ret;
> 
> +	/*
> +	 * Register a callback to allow us to notify the DRM framework of 
frame
> +	 * completion events.
> +	 */
> +	vsp1->drm->du_complete = cfg->callback;
> +	vsp1->drm->du_private = cfg->callback_data;
> +
>  	ret = media_pipeline_start(&pipe->output->entity.subdev.entity,
>  					  &pipe->pipe);
>  	if (ret < 0) {
> @@ -504,6 +522,7 @@ void vsp1_du_atomic_flush(struct device *dev)
> 
>  	vsp1_dl_list_commit(pipe->dl);
>  	pipe->dl = NULL;
> +	vsp1->drm->du_pending = true;
> 
>  	/* Start or stop the pipeline if needed. */
>  	if (!vsp1->drm->num_inputs && pipe->num_inputs) {
> @@ -597,6 +616,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
>  	pipe->lif = &vsp1->lif->entity;
>  	pipe->output = vsp1->wpf[0];
>  	pipe->output->pipe = pipe;
> +	pipe->frame_end = vsp1_du_pipeline_frame_end;
> 
>  	return 0;
>  }
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h
> b/drivers/media/platform/vsp1/vsp1_drm.h index 9e28ab9254ba..3a53e9a60c73
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -33,8 +33,18 @@ struct vsp1_drm {
>  		struct v4l2_rect compose;
>  		unsigned int zpos;
>  	} inputs[VSP1_MAX_RPF];
> +
> +	/* Frame syncronisation */
> +	void (*du_complete)(void *);
> +	void *du_private;

These fields need to be documented.

> +	bool du_pending;

You can remove the du_pending flag, see my comments in patch 2/3.

>  };
> 
> +static inline struct vsp1_drm *to_vsp1_drm(struct vsp1_pipeline *pipe)
> +{
> +	return container_of(pipe, struct vsp1_drm, pipe);
> +}
> +
>  int vsp1_drm_init(struct vsp1_device *vsp1);
>  void vsp1_drm_cleanup(struct vsp1_device *vsp1);
>  int vsp1_drm_create_links(struct vsp1_device *vsp1);
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index bfc701f04f3f..f6629f19f209 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -23,6 +23,9 @@ int vsp1_du_init(struct device *dev);
>  struct vsp1_du_lif_config {
>  	unsigned int width;
>  	unsigned int height;
> +
> +	void (*callback)(void *);
> +	void *callback_data;

These fields need to be documented too.

>  };
> 
>  int vsp1_du_setup_lif(struct device *dev, const struct vsp1_du_lif_config
> *cfg);

-- 
Regards,

Laurent Pinchart

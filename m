Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:50065 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759745AbeD1KDU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 06:03:20 -0400
Date: Sat, 28 Apr 2018 12:03:16 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 5/8] v4l: vsp1: Extend the DU API to support CRC
 computation
Message-ID: <20180428100316.GC18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IpbVkmxF4tDyP/Kb"
Content-Disposition: inline
In-Reply-To: <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--IpbVkmxF4tDyP/Kb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,
   just one minor comment below

On Mon, Apr 23, 2018 at 01:34:27AM +0300, Laurent Pinchart wrote:
> Add a parameter (in the form of a structure to ease future API
> extensions) to the VSP atomic flush handler to pass CRC source
> configuration, and pass the CRC value to the completion callback.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  6 ++++--
>  drivers/media/platform/vsp1/vsp1_drm.c |  6 ++++--
>  drivers/media/platform/vsp1/vsp1_drm.h |  2 +-
>  include/media/vsp1.h                   | 29 +++++++++++++++++++++++++++--
>  4 files changed, 36 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index 2c260c33840b..bdcec201591f 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -31,7 +31,7 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
>
> -static void rcar_du_vsp_complete(void *private, bool completed)
> +static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
>  {
>  	struct rcar_du_crtc *crtc = private;
>
> @@ -102,7 +102,9 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc)
>
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe);
> +	struct vsp1_du_atomic_pipe_config cfg = { { 0, } };
> +
> +	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
>  }
>
>  /* Keep the two tables in sync. */
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 2b29a83dceb9..5fc31578f9b0 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -36,7 +36,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  	bool complete = completion == VSP1_DL_FRAME_END_COMPLETED;
>
>  	if (drm_pipe->du_complete)
> -		drm_pipe->du_complete(drm_pipe->du_private, complete);
> +		drm_pipe->du_complete(drm_pipe->du_private, complete, 0);
>
>  	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
>  		drm_pipe->force_brx_release = false;
> @@ -739,8 +739,10 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
>   * vsp1_du_atomic_flush - Commit an atomic update
>   * @dev: the VSP device
>   * @pipe_index: the DRM pipeline index
> + * @cfg: atomic pipe configuration
>   */
> -void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
> +			  const struct vsp1_du_atomic_pipe_config *cfg)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index f4af1b2b12d6..e5b88b28806c 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -35,7 +35,7 @@ struct vsp1_drm_pipeline {
>  	wait_queue_head_t wait_queue;
>
>  	/* Frame synchronisation */
> -	void (*du_complete)(void *, bool);
> +	void (*du_complete)(void *data, bool completed, u32 crc);
>  	void *du_private;
>  };
>
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index ff7ef894465d..ac63a9928a79 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -34,7 +34,7 @@ struct vsp1_du_lif_config {
>  	unsigned int width;
>  	unsigned int height;
>
> -	void (*callback)(void *, bool);
> +	void (*callback)(void *data, bool completed, u32 crc);
>  	void *callback_data;
>  };
>
> @@ -61,11 +61,36 @@ struct vsp1_du_atomic_config {
>  	unsigned int zpos;
>  };
>
> +/**
> + * enum vsp1_du_crc_source - Source used for CRC calculation
> + * @VSP1_DU_CRC_NONE: CRC calculation disabled
> + * @VSP_DU_CRC_PLANE: Perform CRC calculation on an input plane
> + * @VSP_DU_CRC_OUTPUT: Perform CRC calculation on the composed output

These two paramters are called VSP1_DU_CRC_* not VSP_DU_CRC_*


> + */
> +enum vsp1_du_crc_source {
> +	VSP1_DU_CRC_NONE,
> +	VSP1_DU_CRC_PLANE,
> +	VSP1_DU_CRC_OUTPUT,
> +};
> +
> +/**
> + * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
> + * @crc.source: source for CRC calculation
> + * @crc.index: index of the CRC source plane (when crc.source is set to plane)
> + */
> +struct vsp1_du_atomic_pipe_config {
> +	struct  {
> +		enum vsp1_du_crc_source source;
> +		unsigned int index;
> +	} crc;
> +};
> +
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
>  int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  			  unsigned int rpf,
>  			  const struct vsp1_du_atomic_config *cfg);
> -void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index);
> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
> +			  const struct vsp1_du_atomic_pipe_config *cfg);
>  int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
>  void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
>
> --
> Regards,
>
> Laurent Pinchart
>

--IpbVkmxF4tDyP/Kb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa5EbkAAoJEHI0Bo8WoVY8L1oQAJ6GOLL+u25ID4RbFB1NLSBk
k0AD6d9ZwL6DZhUzVrBG7rmtbmDV58sO3KFvc4wkJxDWq3GUU3CvWV1iGl7lTtWB
dbdyA4+uyDm2w0FZHRrQLENqV4NkgUPobeyA7yrzJjlsaXi1BNYqsMQnqMHoSeYU
v9hMKW/sMLTHJVkGef+5ttWpBvobNwzex3anmcVny+0p/b2K7CQMeCRfSWJgdE4z
UcSjkN5nXFgI/+Obc7OvFcclExaNCqI1hzCPKUhWPJ4HV2P4iFHsX1xUcKjD3kt3
58sglTDDwCfGxygl9OthcIpz6SW79nAMqEo/3uVpF6ftDrjjg1uAOOxuTALbbxlN
PKPjPJgouS+4CE6Z4bfWYYEp/OQMgjIungwAdr0TpiIRk96CYOMKO0AEiE5GpjuW
n3vir7hof4AUMtZoqVo687e/TH4y5IWLAEo2xW0Giv4ZP9L0xdYQ1xaEP2x9UGeC
2ab4Ds8BImRaTjOOv5nAoXWokjUoRfZ81MGTHujooc3emRfgdf91zxcpGrWa2ouY
FWpDIY4kJG5Yu08Zc7+1mVOBp4WLMyXpoInM9NOZYIXSZ7dWy6gmFi/fBDYN4T1y
Inl+BLBVnyKsV/x6mC+/HfU7G2YY3ddeyNdK5Pc3emkoQZ5sOic5R/kty1IjOBlx
ZQ266a0eTKnPA9BMD62S
=6DzM
-----END PGP SIGNATURE-----

--IpbVkmxF4tDyP/Kb--

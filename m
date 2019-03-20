Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFE4C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E3B206BA
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfCTOTM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:19:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48489 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfCTOTL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:19:11 -0400
X-Originating-IP: 90.88.33.153
Received: from aptenodytes (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 1615560014;
        Wed, 20 Mar 2019 14:19:06 +0000 (UTC)
Message-ID: <1f7df78264eb964ae941f572b7affde34bfc3538.camel@bootlin.com>
Subject: Re: [RFC PATCH 02/20] drm: Remove users of
 drm_format_(horz|vert)_chroma_subsampling
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date:   Wed, 20 Mar 2019 15:19:06 +0100
In-Reply-To: <df29f4927fae6733994bed0a16ca2177a532d996.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <df29f4927fae6733994bed0a16ca2177a532d996.1553032382.git-series.maxime.ripard@bootlin.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Le mardi 19 mars 2019 à 22:57 +0100, Maxime Ripard a écrit :
> drm_format_horz_chroma_subsampling and drm_format_vert_chroma_subsampling
> are basically a lookup in the drm_format_info table plus an access to the
> hsub and vsub fields of the appropriate entry.
> 
> Most drivers are using this function while having access to the entry
> already, which means that we will perform an unnecessary lookup. Removing
> the call to these functions is therefore more efficient.
> 
> Some drivers will not have access to that entry in the function, but in
> this case the overhead is minimal (we just have to call drm_format_info()
> to perform the lookup) and we can even avoid multiple, inefficient lookups
> in some places that need multiple fields from the drm_format_info
> structure.
> 
> This is amplified by the fact that most of the time the callers will have
> to retrieve both the vsub and hsub fields, meaning that they would perform
> twice the lookup.

Cheers for nuking these two as well!

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c |  9 +----
>  drivers/gpu/drm/drm_fourcc.c                    | 34 +------------------
>  drivers/gpu/drm/imx/ipuv3-plane.c               | 15 +++-----
>  drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c       |  9 +----
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c      | 24 +++++--------
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c        |  2 +-
>  drivers/gpu/drm/msm/msm_fb.c                    |  8 +---
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c      |  9 +----
>  drivers/gpu/drm/rockchip/rockchip_drm_vop.c     | 13 ++-----
>  drivers/gpu/drm/tegra/fb.c                      |  9 +----
>  drivers/gpu/drm/vc4/vc4_plane.c                 | 13 ++-----
>  include/drm/drm_fourcc.h                        |  2 +-
>  12 files changed, 37 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
> index e836e2de35ce..fdd607ad27fe 100644
> --- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
> +++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
> @@ -603,8 +603,6 @@ static int atmel_hlcdc_plane_atomic_check(struct drm_plane *p,
>  	const struct drm_display_mode *mode;
>  	struct drm_crtc_state *crtc_state;
>  	unsigned int tmp;
> -	int hsub = 1;
> -	int vsub = 1;
>  	int ret;
>  	int i;
>  
> @@ -642,13 +640,10 @@ static int atmel_hlcdc_plane_atomic_check(struct drm_plane *p,
>  	if (state->nplanes > ATMEL_HLCDC_LAYER_MAX_PLANES)
>  		return -EINVAL;
>  
> -	hsub = drm_format_horz_chroma_subsampling(fb->format->format);
> -	vsub = drm_format_vert_chroma_subsampling(fb->format->format);
> -
>  	for (i = 0; i < state->nplanes; i++) {
>  		unsigned int offset = 0;
> -		int xdiv = i ? hsub : 1;
> -		int ydiv = i ? vsub : 1;
> +		int xdiv = i ? fb->format->hsub : 1;
> +		int ydiv = i ? fb->format->vsub : 1;
>  
>  		state->bpp[i] = fb->format->cpp[i];
>  		if (!state->bpp[i])
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index 22c7fa459f65..04be330b7cae 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -326,40 +326,6 @@ int drm_format_plane_cpp(uint32_t format, int plane)
>  EXPORT_SYMBOL(drm_format_plane_cpp);
>  
>  /**
> - * drm_format_horz_chroma_subsampling - get the horizontal chroma subsampling factor
> - * @format: pixel format (DRM_FORMAT_*)
> - *
> - * Returns:
> - * The horizontal chroma subsampling factor for the
> - * specified pixel format.
> - */
> -int drm_format_horz_chroma_subsampling(uint32_t format)
> -{
> -	const struct drm_format_info *info;
> -
> -	info = drm_format_info(format);
> -	return info ? info->hsub : 1;
> -}
> -EXPORT_SYMBOL(drm_format_horz_chroma_subsampling);
> -
> -/**
> - * drm_format_vert_chroma_subsampling - get the vertical chroma subsampling factor
> - * @format: pixel format (DRM_FORMAT_*)
> - *
> - * Returns:
> - * The vertical chroma subsampling factor for the
> - * specified pixel format.
> - */
> -int drm_format_vert_chroma_subsampling(uint32_t format)
> -{
> -	const struct drm_format_info *info;
> -
> -	info = drm_format_info(format);
> -	return info ? info->vsub : 1;
> -}
> -EXPORT_SYMBOL(drm_format_vert_chroma_subsampling);
> -
> -/**
>   * drm_format_plane_width - width of the plane given the first plane
>   * @width: width of the first plane
>   * @format: pixel format
> diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
> index 21e964f6ab5c..2530143281b2 100644
> --- a/drivers/gpu/drm/imx/ipuv3-plane.c
> +++ b/drivers/gpu/drm/imx/ipuv3-plane.c
> @@ -115,8 +115,8 @@ drm_plane_state_to_ubo(struct drm_plane_state *state)
>  	cma_obj = drm_fb_cma_get_gem_obj(fb, 1);
>  	BUG_ON(!cma_obj);
>  
> -	x /= drm_format_horz_chroma_subsampling(fb->format->format);
> -	y /= drm_format_vert_chroma_subsampling(fb->format->format);
> +	x /= fb->format->hsub;
> +	y /= fb->format->vsub;
>  
>  	return cma_obj->paddr + fb->offsets[1] + fb->pitches[1] * y +
>  	       fb->format->cpp[1] * x - eba;
> @@ -134,8 +134,8 @@ drm_plane_state_to_vbo(struct drm_plane_state *state)
>  	cma_obj = drm_fb_cma_get_gem_obj(fb, 2);
>  	BUG_ON(!cma_obj);
>  
> -	x /= drm_format_horz_chroma_subsampling(fb->format->format);
> -	y /= drm_format_vert_chroma_subsampling(fb->format->format);
> +	x /= fb->format->hsub;
> +	y /= fb->format->vsub;
>  
>  	return cma_obj->paddr + fb->offsets[2] + fb->pitches[2] * y +
>  	       fb->format->cpp[2] * x - eba;
> @@ -348,7 +348,6 @@ static int ipu_plane_atomic_check(struct drm_plane *plane,
>  	struct drm_framebuffer *old_fb = old_state->fb;
>  	unsigned long eba, ubo, vbo, old_ubo, old_vbo, alpha_eba;
>  	bool can_position = (plane->type == DRM_PLANE_TYPE_OVERLAY);
> -	int hsub, vsub;
>  	int ret;
>  
>  	/* Ok to disable */
> @@ -467,10 +466,8 @@ static int ipu_plane_atomic_check(struct drm_plane *plane,
>  		 * The x/y offsets must be even in case of horizontal/vertical
>  		 * chroma subsampling.
>  		 */
> -		hsub = drm_format_horz_chroma_subsampling(fb->format->format);
> -		vsub = drm_format_vert_chroma_subsampling(fb->format->format);
> -		if (((state->src.x1 >> 16) & (hsub - 1)) ||
> -		    ((state->src.y1 >> 16) & (vsub - 1)))
> +		if (((state->src.x1 >> 16) & (fb->format->hsub - 1)) ||
> +		    ((state->src.y1 >> 16) & (fb->format->vsub - 1)))
>  			return -EINVAL;
>  		break;
>  	case DRM_FORMAT_RGB565_A8:
> diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
> index 6aefcd6db46b..a9492c488441 100644
> --- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
> +++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
> @@ -553,14 +553,9 @@ static void _dpu_plane_setup_scaler(struct dpu_plane *pdpu,
>  		struct dpu_plane_state *pstate,
>  		const struct dpu_format *fmt, bool color_fill)
>  {
> -	uint32_t chroma_subsmpl_h, chroma_subsmpl_v;
> +	const struct drm_format_info *info = drm_format_info(fmt->base.pixel_format);
>  
>  	/* don't chroma subsample if decimating */
> -	chroma_subsmpl_h =
> -		drm_format_horz_chroma_subsampling(fmt->base.pixel_format);
> -	chroma_subsmpl_v =
> -		drm_format_vert_chroma_subsampling(fmt->base.pixel_format);
> -
>  	/* update scaler. calculate default config for QSEED3 */
>  	_dpu_plane_setup_scaler3(pdpu, pstate,
>  			drm_rect_width(&pdpu->pipe_cfg.src_rect),
> @@ -568,7 +563,7 @@ static void _dpu_plane_setup_scaler(struct dpu_plane *pdpu,
>  			drm_rect_width(&pdpu->pipe_cfg.dst_rect),
>  			drm_rect_height(&pdpu->pipe_cfg.dst_rect),
>  			&pstate->scaler3_cfg, fmt,
> -			chroma_subsmpl_h, chroma_subsmpl_v);
> +			info->hsub, info->vsub);
>  }
>  
>  /**
> diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> index be13140967b4..9d9fb6c5fd68 100644
> --- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> +++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
> @@ -650,10 +650,10 @@ static int calc_scalex_steps(struct drm_plane *plane,
>  		uint32_t pixel_format, uint32_t src, uint32_t dest,
>  		uint32_t phasex_steps[COMP_MAX])
>  {
> +	const struct drm_format_info *info = drm_format_info(pixel_format);
>  	struct mdp5_kms *mdp5_kms = get_kms(plane);
>  	struct device *dev = mdp5_kms->dev->dev;
>  	uint32_t phasex_step;
> -	unsigned int hsub;
>  	int ret;
>  
>  	ret = calc_phase_step(src, dest, &phasex_step);
> @@ -662,11 +662,9 @@ static int calc_scalex_steps(struct drm_plane *plane,
>  		return ret;
>  	}
>  
> -	hsub = drm_format_horz_chroma_subsampling(pixel_format);
> -
>  	phasex_steps[COMP_0]   = phasex_step;
>  	phasex_steps[COMP_3]   = phasex_step;
> -	phasex_steps[COMP_1_2] = phasex_step / hsub;
> +	phasex_steps[COMP_1_2] = phasex_step / info->hsub;
>  
>  	return 0;
>  }
> @@ -675,10 +673,10 @@ static int calc_scaley_steps(struct drm_plane *plane,
>  		uint32_t pixel_format, uint32_t src, uint32_t dest,
>  		uint32_t phasey_steps[COMP_MAX])
>  {
> +	const struct drm_format_info *info = drm_format_info(pixel_format);
>  	struct mdp5_kms *mdp5_kms = get_kms(plane);
>  	struct device *dev = mdp5_kms->dev->dev;
>  	uint32_t phasey_step;
> -	unsigned int vsub;
>  	int ret;
>  
>  	ret = calc_phase_step(src, dest, &phasey_step);
> @@ -687,11 +685,9 @@ static int calc_scaley_steps(struct drm_plane *plane,
>  		return ret;
>  	}
>  
> -	vsub = drm_format_vert_chroma_subsampling(pixel_format);
> -
>  	phasey_steps[COMP_0]   = phasey_step;
>  	phasey_steps[COMP_3]   = phasey_step;
> -	phasey_steps[COMP_1_2] = phasey_step / vsub;
> +	phasey_steps[COMP_1_2] = phasey_step / info->vsub;
>  
>  	return 0;
>  }
> @@ -699,8 +695,9 @@ static int calc_scaley_steps(struct drm_plane *plane,
>  static uint32_t get_scale_config(const struct mdp_format *format,
>  		uint32_t src, uint32_t dst, bool horz)
>  {
> +	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
>  	bool scaling = format->is_yuv ? true : (src != dst);
> -	uint32_t sub, pix_fmt = format->base.pixel_format;
> +	uint32_t sub;
>  	uint32_t ya_filter, uv_filter;
>  	bool yuv = format->is_yuv;
>  
> @@ -708,8 +705,7 @@ static uint32_t get_scale_config(const struct mdp_format *format,
>  		return 0;
>  
>  	if (yuv) {
> -		sub = horz ? drm_format_horz_chroma_subsampling(pix_fmt) :
> -			     drm_format_vert_chroma_subsampling(pix_fmt);
> +		sub = horz ? info->hsub : info->vsub;
>  		uv_filter = ((src / sub) <= dst) ?
>  				   SCALE_FILTER_BIL : SCALE_FILTER_PCMN;
>  	}
> @@ -754,7 +750,7 @@ static void mdp5_write_pixel_ext(struct mdp5_kms *mdp5_kms, enum mdp5_pipe pipe,
>  	uint32_t src_w, int pe_left[COMP_MAX], int pe_right[COMP_MAX],
>  	uint32_t src_h, int pe_top[COMP_MAX], int pe_bottom[COMP_MAX])
>  {
> -	uint32_t pix_fmt = format->base.pixel_format;
> +	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
>  	uint32_t lr, tb, req;
>  	int i;
>  
> @@ -763,8 +759,8 @@ static void mdp5_write_pixel_ext(struct mdp5_kms *mdp5_kms, enum mdp5_pipe pipe,
>  		uint32_t roi_h = src_h;
>  
>  		if (format->is_yuv && i == COMP_1_2) {
> -			roi_w /= drm_format_horz_chroma_subsampling(pix_fmt);
> -			roi_h /= drm_format_vert_chroma_subsampling(pix_fmt);
> +			roi_w /= info->hsub;
> +			roi_h /= info->vsub;
>  		}
>  
>  		lr  = (pe_left[i] >= 0) ?
> diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> index 72ab8d89efa4..b30b2f4efc60 100644
> --- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> +++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> @@ -135,7 +135,7 @@ uint32_t mdp5_smp_calculate(struct mdp5_smp *smp,
>  	uint32_t blkcfg = 0;
>  
>  	nplanes = info->num_planes;
> -	hsub = drm_format_horz_chroma_subsampling(fmt);
> +	hsub = info->hsub;
>  
>  	/* different if BWC (compressed framebuffer?) enabled: */
>  	nlines = 2;
> diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
> index 432beddafb9e..f69c0afd6ec6 100644
> --- a/drivers/gpu/drm/msm/msm_fb.c
> +++ b/drivers/gpu/drm/msm/msm_fb.c
> @@ -145,16 +145,12 @@ static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
>  	struct drm_framebuffer *fb;
>  	const struct msm_format *format;
>  	int ret, i, n;
> -	unsigned int hsub, vsub;
>  
>  	DBG("create framebuffer: dev=%p, mode_cmd=%p (%dx%d@%4.4s)",
>  			dev, mode_cmd, mode_cmd->width, mode_cmd->height,
>  			(char *)&mode_cmd->pixel_format);
>  
>  	n = info->num_planes;
> -	hsub = drm_format_horz_chroma_subsampling(mode_cmd->pixel_format);
> -	vsub = drm_format_vert_chroma_subsampling(mode_cmd->pixel_format);
> -
>  	format = kms->funcs->get_format(kms, mode_cmd->pixel_format,
>  			mode_cmd->modifier[0]);
>  	if (!format) {
> @@ -180,8 +176,8 @@ static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
>  	}
>  
>  	for (i = 0; i < n; i++) {
> -		unsigned int width = mode_cmd->width / (i ? hsub : 1);
> -		unsigned int height = mode_cmd->height / (i ? vsub : 1);
> +		unsigned int width = mode_cmd->width / (i ? info->hsub : 1);
> +		unsigned int height = mode_cmd->height / (i ? info->vsub : 1);
>  		unsigned int min_size;
>  
>  		min_size = (height - 1) * mode_cmd->pitches[i]
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> index 606d176d5d96..c318fae28581 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> @@ -79,18 +79,13 @@ rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
>  	struct drm_framebuffer *fb;
>  	struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
>  	struct drm_gem_object *obj;
> -	unsigned int hsub;
> -	unsigned int vsub;
>  	int num_planes = min_t(int, info->num_planes, ROCKCHIP_MAX_FB_BUFFER);
>  	int ret;
>  	int i;
>  
> -	hsub = drm_format_horz_chroma_subsampling(mode_cmd->pixel_format);
> -	vsub = drm_format_vert_chroma_subsampling(mode_cmd->pixel_format);
> -
>  	for (i = 0; i < num_planes; i++) {
> -		unsigned int width = mode_cmd->width / (i ? hsub : 1);
> -		unsigned int height = mode_cmd->height / (i ? vsub : 1);
> +		unsigned int width = mode_cmd->width / (i ? info->hsub : 1);
> +		unsigned int height = mode_cmd->height / (i ? info->vsub : 1);
>  		unsigned int min_size;
>  
>  		obj = drm_gem_object_lookup(file_priv, mode_cmd->handles[i]);
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> index c7d4c6073ea5..88c3902057f3 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
> @@ -317,21 +317,18 @@ static void scl_vop_cal_scl_fac(struct vop *vop, const struct vop_win_data *win,
>  			     uint32_t src_w, uint32_t src_h, uint32_t dst_w,
>  			     uint32_t dst_h, uint32_t pixel_format)
>  {
> +	const struct drm_format_info *info = drm_format_info(pixel_format);
>  	uint16_t yrgb_hor_scl_mode, yrgb_ver_scl_mode;
>  	uint16_t cbcr_hor_scl_mode = SCALE_NONE;
>  	uint16_t cbcr_ver_scl_mode = SCALE_NONE;
> -	int hsub = drm_format_horz_chroma_subsampling(pixel_format);
> -	int vsub = drm_format_vert_chroma_subsampling(pixel_format);
> -	const struct drm_format_info *info;
>  	bool is_yuv = false;
> -	uint16_t cbcr_src_w = src_w / hsub;
> -	uint16_t cbcr_src_h = src_h / vsub;
> +	uint16_t cbcr_src_w = src_w / info->hsub;
> +	uint16_t cbcr_src_h = src_h / info->vsub;
>  	uint16_t vsu_mode;
>  	uint16_t lb_mode;
>  	uint32_t val;
>  	int vskiplines;
>  
> -	info = drm_format_info(pixel_format);
>  
>  	if (info->is_yuv)
>  		is_yuv = true;
> @@ -819,8 +816,8 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
>  		    (state->rotation & DRM_MODE_REFLECT_X) ? 1 : 0);
>  
>  	if (is_yuv) {
> -		int hsub = drm_format_horz_chroma_subsampling(fb->format->format);
> -		int vsub = drm_format_vert_chroma_subsampling(fb->format->format);
> +		int hsub = fb->format->hsub;
> +		int vsub = fb->format->vsub;
>  		int bpp = fb->format->cpp[1];
>  
>  		uv_obj = fb->obj[1];
> diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
> index bc8f9afd1b5f..ddf2c764f24c 100644
> --- a/drivers/gpu/drm/tegra/fb.c
> +++ b/drivers/gpu/drm/tegra/fb.c
> @@ -132,18 +132,15 @@ struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
>  					const struct drm_mode_fb_cmd2 *cmd)
>  {
>  	const struct drm_format_info *info = drm_get_format_info(dev, cmd);
> -	unsigned int hsub, vsub, i;
>  	struct tegra_bo *planes[4];
>  	struct drm_gem_object *gem;
>  	struct drm_framebuffer *fb;
> +	unsigned int i;
>  	int err;
>  
> -	hsub = drm_format_horz_chroma_subsampling(cmd->pixel_format);
> -	vsub = drm_format_vert_chroma_subsampling(cmd->pixel_format);
> -
>  	for (i = 0; i < info->num_planes; i++) {
> -		unsigned int width = cmd->width / (i ? hsub : 1);
> -		unsigned int height = cmd->height / (i ? vsub : 1);
> +		unsigned int width = cmd->width / (i ? info->hsub : 1);
> +		unsigned int height = cmd->height / (i ? info->vsub : 1);
>  		unsigned int size, bpp;
>  
>  		gem = drm_gem_object_lookup(file, cmd->handles[i]);
> diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
> index 138a9ff23b70..6605c1b7370d 100644
> --- a/drivers/gpu/drm/vc4/vc4_plane.c
> +++ b/drivers/gpu/drm/vc4/vc4_plane.c
> @@ -310,10 +310,10 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
>  	struct drm_framebuffer *fb = state->fb;
>  	struct drm_gem_cma_object *bo = drm_fb_cma_get_gem_obj(fb, 0);
>  	u32 subpixel_src_mask = (1 << 16) - 1;
> -	u32 format = fb->format->format;
>  	int num_planes = fb->format->num_planes;
>  	struct drm_crtc_state *crtc_state;
> -	u32 h_subsample, v_subsample;
> +	u32 h_subsample = fb->format->hsub;
> +	u32 v_subsample = fb->format->vsub;
>  	int i, ret;
>  
>  	crtc_state = drm_atomic_get_existing_crtc_state(state->state,
> @@ -328,9 +328,6 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
>  	if (ret)
>  		return ret;
>  
> -	h_subsample = drm_format_horz_chroma_subsampling(format);
> -	v_subsample = drm_format_vert_chroma_subsampling(format);
> -
>  	for (i = 0; i < num_planes; i++)
>  		vc4_state->offsets[i] = bo->paddr + fb->offsets[i];
>  
> @@ -538,7 +535,8 @@ static int vc4_plane_mode_set(struct drm_plane *plane,
>  	const struct hvs_format *format = vc4_get_hvs_format(fb->format->format);
>  	u64 base_format_mod = fourcc_mod_broadcom_mod(fb->modifier);
>  	int num_planes = fb->format->num_planes;
> -	u32 h_subsample, v_subsample;
> +	u32 h_subsample = fb->format->hsub;
> +	u32 v_subsample = fb->format->vsub;
>  	bool mix_plane_alpha;
>  	bool covers_screen;
>  	u32 scl0, scl1, pitch0;
> @@ -568,9 +566,6 @@ static int vc4_plane_mode_set(struct drm_plane *plane,
>  		scl1 = vc4_get_scl_field(state, 0);
>  	}
>  
> -	h_subsample = drm_format_horz_chroma_subsampling(format->drm);
> -	v_subsample = drm_format_vert_chroma_subsampling(format->drm);
> -
>  	rotation = drm_rotation_simplify(state->rotation,
>  					 DRM_MODE_ROTATE_0 |
>  					 DRM_MODE_REFLECT_X |
> diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
> index 41779b327d91..eeec449d6c6a 100644
> --- a/include/drm/drm_fourcc.h
> +++ b/include/drm/drm_fourcc.h
> @@ -269,8 +269,6 @@ uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
>  uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
>  				     uint32_t bpp, uint32_t depth);
>  int drm_format_plane_cpp(uint32_t format, int plane);
> -int drm_format_horz_chroma_subsampling(uint32_t format);
> -int drm_format_vert_chroma_subsampling(uint32_t format);
>  int drm_format_plane_width(int width, uint32_t format, int plane);
>  int drm_format_plane_height(int height, uint32_t format, int plane);
>  unsigned int drm_format_info_block_width(const struct drm_format_info *info,
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com


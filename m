Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DACC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31ED4213F2
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfCTOQo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:16:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53723 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfCTOQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:16:44 -0400
X-Originating-IP: 90.88.33.153
Received: from aptenodytes (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id C78CC6001F;
        Wed, 20 Mar 2019 14:16:37 +0000 (UTC)
Message-ID: <b394d97f158497a204bd1c699e4b2d06f2cd0a5e.camel@bootlin.com>
Subject: Re: [RFC PATCH 01/20] drm: Remove users of drm_format_num_planes
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
Date:   Wed, 20 Mar 2019 15:16:37 +0100
In-Reply-To: <fecde1c7b65caa0e876a2f01769289a883014712.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <fecde1c7b65caa0e876a2f01769289a883014712.1553032382.git-series.maxime.ripard@bootlin.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Tue, 2019-03-19 at 22:57 +0100, Maxime Ripard wrote:
> drm_format_num_planes() is basically a lookup in the drm_format_info table
> plus an access to the num_planes field of the appropriate entry.
> 
> Most drivers are using this function while having access to the entry
> already, which means that we will perform an unnecessary lookup. Removing
> the call to drm_format_num_planes is therefore more efficient.
> 
> Some drivers will not have access to that entry in the function, but in
> this case the overhead is minimal (we just have to call drm_format_info()
> to perform the lookup) and we can even avoid multiple, inefficient lookups
> in some places that need multiple fields from the drm_format_info
> structure.

Great, happy to see drm_format_num_planes getting nuked!

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/arm/malidp_mw.c             |  2 +-
>  drivers/gpu/drm/armada/armada_fb.c          |  3 ++-
>  drivers/gpu/drm/drm_fourcc.c                | 16 ----------------
>  drivers/gpu/drm/mediatek/mtk_drm_fb.c       |  6 ++++--
>  drivers/gpu/drm/meson/meson_overlay.c       |  2 +-
>  drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c |  9 ++++++---
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c    |  3 ++-
>  drivers/gpu/drm/msm/msm_fb.c                |  8 ++++++--
>  drivers/gpu/drm/omapdrm/omap_fb.c           |  4 +++-
>  drivers/gpu/drm/rockchip/rockchip_drm_fb.c  |  6 +++---
>  drivers/gpu/drm/tegra/fb.c                  |  3 ++-
>  drivers/gpu/drm/vc4/vc4_plane.c             |  2 +-
>  drivers/gpu/drm/zte/zx_plane.c              |  4 +---
>  include/drm/drm_fourcc.h                    |  1 -
>  14 files changed, 32 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
> index 041a64dc7167..91580b7a3781 100644
> --- a/drivers/gpu/drm/arm/malidp_mw.c
> +++ b/drivers/gpu/drm/arm/malidp_mw.c
> @@ -153,7 +153,7 @@ malidp_mw_encoder_atomic_check(struct drm_encoder *encoder,
>  		return -EINVAL;
>  	}
>  
> -	n_planes = drm_format_num_planes(fb->format->format);
> +	n_planes = fb->format->num_planes;
>  	for (i = 0; i < n_planes; i++) {
>  		struct drm_gem_cma_object *obj = drm_fb_cma_get_gem_obj(fb, i);
>  		/* memory write buffers are never rotated */
> diff --git a/drivers/gpu/drm/armada/armada_fb.c b/drivers/gpu/drm/armada/armada_fb.c
> index 058ac7d9920f..a2f6472eb482 100644
> --- a/drivers/gpu/drm/armada/armada_fb.c
> +++ b/drivers/gpu/drm/armada/armada_fb.c
> @@ -87,6 +87,7 @@ struct armada_framebuffer *armada_framebuffer_create(struct drm_device *dev,
>  struct drm_framebuffer *armada_fb_create(struct drm_device *dev,
>  	struct drm_file *dfile, const struct drm_mode_fb_cmd2 *mode)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev, mode);
>  	struct armada_gem_object *obj;
>  	struct armada_framebuffer *dfb;
>  	int ret;
> @@ -97,7 +98,7 @@ struct drm_framebuffer *armada_fb_create(struct drm_device *dev,
>  		mode->pitches[2]);
>  
>  	/* We can only handle a single plane at the moment */
> -	if (drm_format_num_planes(mode->pixel_format) > 1 &&
> +	if (info->num_planes > 1 &&
>  	    (mode->handles[0] != mode->handles[1] ||
>  	     mode->handles[0] != mode->handles[2])) {
>  		ret = -EINVAL;
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index ba7e19d4336c..22c7fa459f65 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -306,22 +306,6 @@ drm_get_format_info(struct drm_device *dev,
>  EXPORT_SYMBOL(drm_get_format_info);
>  
>  /**
> - * drm_format_num_planes - get the number of planes for format
> - * @format: pixel format (DRM_FORMAT_*)
> - *
> - * Returns:
> - * The number of planes used by the specified pixel format.
> - */
> -int drm_format_num_planes(uint32_t format)
> -{
> -	const struct drm_format_info *info;
> -
> -	info = drm_format_info(format);
> -	return info ? info->num_planes : 1;
> -}
> -EXPORT_SYMBOL(drm_format_num_planes);
> -
> -/**
>   * drm_format_plane_cpp - determine the bytes per pixel value
>   * @format: pixel format (DRM_FORMAT_*)
>   * @plane: plane index
> diff --git a/drivers/gpu/drm/mediatek/mtk_drm_fb.c b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
> index e20fcaef2851..68fdef8b12bd 100644
> --- a/drivers/gpu/drm/mediatek/mtk_drm_fb.c
> +++ b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
> @@ -32,10 +32,11 @@ static struct drm_framebuffer *mtk_drm_framebuffer_init(struct drm_device *dev,
>  					const struct drm_mode_fb_cmd2 *mode,
>  					struct drm_gem_object *obj)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev, mode);
>  	struct drm_framebuffer *fb;
>  	int ret;
>  
> -	if (drm_format_num_planes(mode->pixel_format) != 1)
> +	if (info->num_planes != 1)
>  		return ERR_PTR(-EINVAL);
>  
>  	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
> @@ -88,6 +89,7 @@ struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
>  					       struct drm_file *file,
>  					       const struct drm_mode_fb_cmd2 *cmd)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev, cmd);
>  	struct drm_framebuffer *fb;
>  	struct drm_gem_object *gem;
>  	unsigned int width = cmd->width;
> @@ -95,7 +97,7 @@ struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
>  	unsigned int size, bpp;
>  	int ret;
>  
> -	if (drm_format_num_planes(cmd->pixel_format) != 1)
> +	if (info->num_planes != 1)
>  		return ERR_PTR(-EINVAL);
>  
>  	gem = drm_gem_object_lookup(file, cmd->handles[0]);
> diff --git a/drivers/gpu/drm/meson/meson_overlay.c b/drivers/gpu/drm/meson/meson_overlay.c
> index 691a9fd16b36..8ff15d01a8f9 100644
> --- a/drivers/gpu/drm/meson/meson_overlay.c
> +++ b/drivers/gpu/drm/meson/meson_overlay.c
> @@ -466,7 +466,7 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
>  	}
>  
>  	/* Update Canvas with buffer address */
> -	priv->viu.vd1_planes = drm_format_num_planes(fb->format->format);
> +	priv->viu.vd1_planes = fb->format->num_planes;
>  
>  	switch (priv->viu.vd1_planes) {
>  	case 3:
> diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
> index 0874f0a53bf9..1aed51b49be4 100644
> --- a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
> +++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
> @@ -1040,10 +1040,11 @@ int dpu_format_check_modified_format(
>  		const struct drm_mode_fb_cmd2 *cmd,
>  		struct drm_gem_object **bos)
>  {
> -	int ret, i, num_base_fmt_planes;
> +	const struct drm_format_info *info;
>  	const struct dpu_format *fmt;
>  	struct dpu_hw_fmt_layout layout;
>  	uint32_t bos_total_size = 0;
> +	int ret, i;
>  
>  	if (!msm_fmt || !cmd || !bos) {
>  		DRM_ERROR("invalid arguments\n");
> @@ -1051,14 +1052,16 @@ int dpu_format_check_modified_format(
>  	}
>  
>  	fmt = to_dpu_format(msm_fmt);
> -	num_base_fmt_planes = drm_format_num_planes(fmt->base.pixel_format);
> +	info = drm_format_info(fmt->base.pixel_format);
> +	if (!info)
> +		return -EINVAL;
>  
>  	ret = dpu_format_get_plane_sizes(fmt, cmd->width, cmd->height,
>  			&layout, cmd->pitches);
>  	if (ret)
>  		return ret;
>  
> -	for (i = 0; i < num_base_fmt_planes; i++) {
> +	for (i = 0; i < info->num_planes; i++) {
>  		if (!bos[i]) {
>  			DRM_ERROR("invalid handle for plane %d\n", i);
>  			return -EINVAL;
> diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> index 6153514db04c..72ab8d89efa4 100644
> --- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> +++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
> @@ -127,13 +127,14 @@ uint32_t mdp5_smp_calculate(struct mdp5_smp *smp,
>  		const struct mdp_format *format,
>  		u32 width, bool hdecim)
>  {
> +	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
>  	struct mdp5_kms *mdp5_kms = get_kms(smp);
>  	int rev = mdp5_cfg_get_hw_rev(mdp5_kms->cfg);
>  	int i, hsub, nplanes, nlines;
>  	u32 fmt = format->base.pixel_format;
>  	uint32_t blkcfg = 0;
>  
> -	nplanes = drm_format_num_planes(fmt);
> +	nplanes = info->num_planes;
>  	hsub = drm_format_horz_chroma_subsampling(fmt);
>  
>  	/* different if BWC (compressed framebuffer?) enabled: */
> diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
> index 136058978e0f..432beddafb9e 100644
> --- a/drivers/gpu/drm/msm/msm_fb.c
> +++ b/drivers/gpu/drm/msm/msm_fb.c
> @@ -106,9 +106,11 @@ const struct msm_format *msm_framebuffer_format(struct drm_framebuffer *fb)
>  struct drm_framebuffer *msm_framebuffer_create(struct drm_device *dev,
>  		struct drm_file *file, const struct drm_mode_fb_cmd2 *mode_cmd)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev,
> +								 mode_cmd);
>  	struct drm_gem_object *bos[4] = {0};
>  	struct drm_framebuffer *fb;
> -	int ret, i, n = drm_format_num_planes(mode_cmd->pixel_format);
> +	int ret, i, n = info->num_planes;
>  
>  	for (i = 0; i < n; i++) {
>  		bos[i] = drm_gem_object_lookup(file, mode_cmd->handles[i]);
> @@ -135,6 +137,8 @@ struct drm_framebuffer *msm_framebuffer_create(struct drm_device *dev,
>  static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
>  		const struct drm_mode_fb_cmd2 *mode_cmd, struct drm_gem_object **bos)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev,
> +								 mode_cmd);
>  	struct msm_drm_private *priv = dev->dev_private;
>  	struct msm_kms *kms = priv->kms;
>  	struct msm_framebuffer *msm_fb = NULL;
> @@ -147,7 +151,7 @@ static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
>  			dev, mode_cmd, mode_cmd->width, mode_cmd->height,
>  			(char *)&mode_cmd->pixel_format);
>  
> -	n = drm_format_num_planes(mode_cmd->pixel_format);
> +	n = info->num_planes;
>  	hsub = drm_format_horz_chroma_subsampling(mode_cmd->pixel_format);
>  	vsub = drm_format_vert_chroma_subsampling(mode_cmd->pixel_format);
>  
> diff --git a/drivers/gpu/drm/omapdrm/omap_fb.c b/drivers/gpu/drm/omapdrm/omap_fb.c
> index 4f8eb9d08f99..cfb641363a32 100644
> --- a/drivers/gpu/drm/omapdrm/omap_fb.c
> +++ b/drivers/gpu/drm/omapdrm/omap_fb.c
> @@ -298,7 +298,9 @@ void omap_framebuffer_describe(struct drm_framebuffer *fb, struct seq_file *m)
>  struct drm_framebuffer *omap_framebuffer_create(struct drm_device *dev,
>  		struct drm_file *file, const struct drm_mode_fb_cmd2 *mode_cmd)
>  {
> -	unsigned int num_planes = drm_format_num_planes(mode_cmd->pixel_format);
> +	const struct drm_format_info *info = drm_get_format_info(dev,
> +								 mode_cmd);
> +	unsigned int num_planes = info->num_planes;
>  	struct drm_gem_object *bos[4];
>  	struct drm_framebuffer *fb;
>  	int i;
> diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> index 97438bbbe389..606d176d5d96 100644
> --- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> +++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
> @@ -74,19 +74,19 @@ static struct drm_framebuffer *
>  rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
>  			const struct drm_mode_fb_cmd2 *mode_cmd)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev,
> +								 mode_cmd);
>  	struct drm_framebuffer *fb;
>  	struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
>  	struct drm_gem_object *obj;
>  	unsigned int hsub;
>  	unsigned int vsub;
> -	int num_planes;
> +	int num_planes = min_t(int, info->num_planes, ROCKCHIP_MAX_FB_BUFFER);
>  	int ret;
>  	int i;
>  
>  	hsub = drm_format_horz_chroma_subsampling(mode_cmd->pixel_format);
>  	vsub = drm_format_vert_chroma_subsampling(mode_cmd->pixel_format);
> -	num_planes = min(drm_format_num_planes(mode_cmd->pixel_format),
> -			 ROCKCHIP_MAX_FB_BUFFER);
>  
>  	for (i = 0; i < num_planes; i++) {
>  		unsigned int width = mode_cmd->width / (i ? hsub : 1);
> diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
> index 0a4ce05e00ab..bc8f9afd1b5f 100644
> --- a/drivers/gpu/drm/tegra/fb.c
> +++ b/drivers/gpu/drm/tegra/fb.c
> @@ -131,6 +131,7 @@ struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
>  					struct drm_file *file,
>  					const struct drm_mode_fb_cmd2 *cmd)
>  {
> +	const struct drm_format_info *info = drm_get_format_info(dev, cmd);
>  	unsigned int hsub, vsub, i;
>  	struct tegra_bo *planes[4];
>  	struct drm_gem_object *gem;
> @@ -140,7 +141,7 @@ struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
>  	hsub = drm_format_horz_chroma_subsampling(cmd->pixel_format);
>  	vsub = drm_format_vert_chroma_subsampling(cmd->pixel_format);
>  
> -	for (i = 0; i < drm_format_num_planes(cmd->pixel_format); i++) {
> +	for (i = 0; i < info->num_planes; i++) {
>  		unsigned int width = cmd->width / (i ? hsub : 1);
>  		unsigned int height = cmd->height / (i ? vsub : 1);
>  		unsigned int size, bpp;
> diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
> index 1babfeca0c92..138a9ff23b70 100644
> --- a/drivers/gpu/drm/vc4/vc4_plane.c
> +++ b/drivers/gpu/drm/vc4/vc4_plane.c
> @@ -537,7 +537,7 @@ static int vc4_plane_mode_set(struct drm_plane *plane,
>  	u32 ctl0_offset = vc4_state->dlist_count;
>  	const struct hvs_format *format = vc4_get_hvs_format(fb->format->format);
>  	u64 base_format_mod = fourcc_mod_broadcom_mod(fb->modifier);
> -	int num_planes = drm_format_num_planes(format->drm);
> +	int num_planes = fb->format->num_planes;
>  	u32 h_subsample, v_subsample;
>  	bool mix_plane_alpha;
>  	bool covers_screen;
> diff --git a/drivers/gpu/drm/zte/zx_plane.c b/drivers/gpu/drm/zte/zx_plane.c
> index 83d236fd893c..c6a8be444300 100644
> --- a/drivers/gpu/drm/zte/zx_plane.c
> +++ b/drivers/gpu/drm/zte/zx_plane.c
> @@ -199,7 +199,6 @@ static void zx_vl_plane_atomic_update(struct drm_plane *plane,
>  	u32 dst_x, dst_y, dst_w, dst_h;
>  	uint32_t format;
>  	int fmt;
> -	int num_planes;
>  	int i;
>  
>  	if (!fb)
> @@ -218,9 +217,8 @@ static void zx_vl_plane_atomic_update(struct drm_plane *plane,
>  	dst_h = drm_rect_height(dst);
>  
>  	/* Set up data address registers for Y, Cb and Cr planes */
> -	num_planes = drm_format_num_planes(format);
>  	paddr_reg = layer + VL_Y;
> -	for (i = 0; i < num_planes; i++) {
> +	for (i = 0; i < fb->format->num_planes; i++) {
>  		cma_obj = drm_fb_cma_get_gem_obj(fb, i);
>  		paddr = cma_obj->paddr + fb->offsets[i];
>  		paddr += src_y * fb->pitches[i];
> diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
> index b3d9d88ab290..41779b327d91 100644
> --- a/include/drm/drm_fourcc.h
> +++ b/include/drm/drm_fourcc.h
> @@ -268,7 +268,6 @@ drm_get_format_info(struct drm_device *dev,
>  uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
>  uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
>  				     uint32_t bpp, uint32_t depth);
> -int drm_format_num_planes(uint32_t format);
>  int drm_format_plane_cpp(uint32_t format, int plane);
>  int drm_format_horz_chroma_subsampling(uint32_t format);
>  int drm_format_vert_chroma_subsampling(uint32_t format);
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com


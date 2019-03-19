Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD63CC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC69C217F4
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727596AbfCSV5m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:57:42 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:47957 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfCSV5l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:41 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 13106C0008;
        Tue, 19 Mar 2019 21:57:36 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 03/20] drm/fourcc: Pass the format_info pointer to drm_format_plane_cpp
Date:   Tue, 19 Mar 2019 22:57:08 +0100
Message-Id: <6e5850afb02cc2851fe3229122fb3cb4869dc108.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

So far, the drm_format_plane_cpp function was operating on the format's
fourcc and was doing a lookup to retrieve the drm_format_info structure and
return the cpp.

However, this is inefficient since in most cases, we will have the
drm_format_info pointer already available so we shouldn't have to perform a
new lookup. Some drm_fourcc functions also already operate on the
drm_format_info pointer for that reason, so the API is quite inconsistent
there.

Let's follow the latter pattern and remove the extra lookup while being a
bit more consistent.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c         | 4 +++-
 drivers/gpu/drm/arm/malidp_hw.c                | 4 +++-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c          | 4 +++-
 drivers/gpu/drm/cirrus/cirrus_main.c           | 4 +++-
 drivers/gpu/drm/drm_client.c                   | 3 ++-
 drivers/gpu/drm/drm_fb_helper.c                | 2 +-
 drivers/gpu/drm/drm_fourcc.c                   | 7 ++-----
 drivers/gpu/drm/i915/intel_sprite.c            | 3 ++-
 drivers/gpu/drm/mediatek/mtk_drm_fb.c          | 2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c      | 3 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c       | 2 +-
 drivers/gpu/drm/msm/msm_fb.c                   | 2 +-
 drivers/gpu/drm/radeon/radeon_fb.c             | 4 +++-
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c     | 2 +-
 drivers/gpu/drm/stm/ltdc.c                     | 2 +-
 drivers/gpu/drm/tegra/fb.c                     | 2 +-
 drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c | 2 +-
 drivers/gpu/drm/zte/zx_plane.c                 | 2 +-
 include/drm/drm_fourcc.h                       | 2 +-
 19 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index 5cbde74b97dd..48170a843b48 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -123,6 +123,8 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 					 struct drm_mode_fb_cmd2 *mode_cmd,
 					 struct drm_gem_object **gobj_p)
 {
+	const struct drm_format_info *info = drm_get_format_info(dev,
+								 mode_cmd);
 	struct amdgpu_device *adev = rfbdev->adev;
 	struct drm_gem_object *gobj = NULL;
 	struct amdgpu_bo *abo = NULL;
@@ -133,7 +135,7 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 	int height = mode_cmd->height;
 	u32 cpp;
 
-	cpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0);
+	cpp = drm_format_plane_cpp(info, 0);
 
 	/* need to align pitch with crtc limits */
 	mode_cmd->pitches[0] = amdgpu_align_pitch(adev, mode_cmd->width, cpp,
diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index b9bed1138fa3..07971ad53b29 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -326,12 +326,14 @@ static void malidp500_modeset(struct malidp_hw_device *hwdev, struct videomode *
 
 static int malidp500_rotmem_required(struct malidp_hw_device *hwdev, u16 w, u16 h, u32 fmt)
 {
+	const struct drm_format_info *info = drm_format_info(fmt);
+
 	/*
 	 * Each layer needs enough rotation memory to fit 8 lines
 	 * worth of pixel data. Required size is then:
 	 *    size = rotated_width * (bpp / 8) * 8;
 	 */
-	return w * drm_format_plane_cpp(fmt, 0) * 8;
+	return w * drm_format_plane_cpp(info, 0) * 8;
 }
 
 static void malidp500_se_write_pp_coefftab(struct malidp_hw_device *hwdev,
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 39df62acac69..759847bafda8 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -137,6 +137,8 @@ static int cirrusfb_create_object(struct cirrus_fbdev *afbdev,
 			       const struct drm_mode_fb_cmd2 *mode_cmd,
 			       struct drm_gem_object **gobj_p)
 {
+	const struct drm_format_info *info = drm_get_format_info(dev,
+								 mode_cmd);
 	struct drm_device *dev = afbdev->helper.dev;
 	struct cirrus_device *cdev = dev->dev_private;
 	u32 bpp;
@@ -144,7 +146,7 @@ static int cirrusfb_create_object(struct cirrus_fbdev *afbdev,
 	struct drm_gem_object *gobj;
 	int ret = 0;
 
-	bpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0) * 8;
+	bpp = drm_format_plane_cpp(info, 0) * 8;
 
 	if (!cirrus_check_framebuffer(cdev, mode_cmd->width, mode_cmd->height,
 				      bpp, mode_cmd->pitches[0]))
diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c b/drivers/gpu/drm/cirrus/cirrus_main.c
index 57f8fe6d020b..66d0d2c5211d 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -41,13 +41,15 @@ cirrus_user_framebuffer_create(struct drm_device *dev,
 			       struct drm_file *filp,
 			       const struct drm_mode_fb_cmd2 *mode_cmd)
 {
+	const struct drm_format_info *info = drm_get_format_info(dev,
+								 mode_cmd);
 	struct cirrus_device *cdev = dev->dev_private;
 	struct drm_gem_object *obj;
 	struct drm_framebuffer *fb;
 	u32 bpp;
 	int ret;
 
-	bpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0) * 8;
+	bpp = drm_format_plane_cpp(info, 0) * 8;
 
 	if (!cirrus_check_framebuffer(cdev, mode_cmd->width, mode_cmd->height,
 				      bpp, mode_cmd->pitches[0]))
diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 9b2bd28dde0a..305d6dd5d201 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -242,6 +242,7 @@ static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 static struct drm_client_buffer *
 drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
+	const struct drm_format_info *info = drm_format_info(format);
 	struct drm_mode_create_dumb dumb_args = { };
 	struct drm_device *dev = client->dev;
 	struct drm_client_buffer *buffer;
@@ -257,7 +258,7 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u
 
 	dumb_args.width = width;
 	dumb_args.height = height;
-	dumb_args.bpp = drm_format_plane_cpp(format, 0) * 8;
+	dumb_args.bpp = drm_format_plane_cpp(info, 0) * 8;
 	ret = drm_mode_create_dumb(dev, &dumb_args, client->file);
 	if (ret)
 		goto err_delete;
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 04d23cb430bf..257a9c995057 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -768,7 +768,7 @@ static void drm_fb_helper_dirty_blit_real(struct drm_fb_helper *fb_helper,
 					  struct drm_clip_rect *clip)
 {
 	struct drm_framebuffer *fb = fb_helper->fb;
-	unsigned int cpp = drm_format_plane_cpp(fb->format->format, 0);
+	unsigned int cpp = drm_format_plane_cpp(fb->format, 0);
 	size_t offset = clip->y1 * fb->pitches[0] + clip->x1 * cpp;
 	void *src = fb_helper->fbdev->screen_buffer + offset;
 	void *dst = fb_helper->buffer->vaddr + offset;
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 04be330b7cae..d8ada4cb689e 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -307,17 +307,14 @@ EXPORT_SYMBOL(drm_get_format_info);
 
 /**
  * drm_format_plane_cpp - determine the bytes per pixel value
- * @format: pixel format (DRM_FORMAT_*)
+ * @format: pixel format info
  * @plane: plane index
  *
  * Returns:
  * The bytes per pixel value for the specified plane.
  */
-int drm_format_plane_cpp(uint32_t format, int plane)
+int drm_format_plane_cpp(const struct drm_format_info *info, int plane)
 {
-	const struct drm_format_info *info;
-
-	info = drm_format_info(format);
 	if (!info || plane >= info->num_planes)
 		return 0;
 
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index b56a1a9ad01d..ee0e99b13532 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -297,7 +297,8 @@ skl_plane_max_stride(struct intel_plane *plane,
 		     u32 pixel_format, u64 modifier,
 		     unsigned int rotation)
 {
-	int cpp = drm_format_plane_cpp(pixel_format, 0);
+	const struct drm_format_info *info = drm_format_info(pixel_format);
+	int cpp = drm_format_plane_cpp(info, 0);
 
 	/*
 	 * "The stride in bytes must not exceed the
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_fb.c b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
index 68fdef8b12bd..af90c84e9e02 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_fb.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
@@ -104,7 +104,7 @@ struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
 	if (!gem)
 		return ERR_PTR(-ENOENT);
 
-	bpp = drm_format_plane_cpp(cmd->pixel_format, 0);
+	bpp = drm_format_plane_cpp(info, 0);
 	size = (height - 1) * cmd->pitches[0] + width * bpp;
 	size += cmd->offsets[0];
 
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index b0cf63c4e3d7..aadae21f8818 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -782,6 +782,7 @@ static void get_roi(struct drm_crtc *crtc, uint32_t *roi_w, uint32_t *roi_h)
 
 static void mdp5_crtc_restore_cursor(struct drm_crtc *crtc)
 {
+	const struct drm_format_info *info = drm_format_info(DRM_FORMAT_ARGB8888);
 	struct mdp5_crtc_state *mdp5_cstate = to_mdp5_crtc_state(crtc->state);
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
@@ -800,7 +801,7 @@ static void mdp5_crtc_restore_cursor(struct drm_crtc *crtc)
 	width = mdp5_crtc->cursor.width;
 	height = mdp5_crtc->cursor.height;
 
-	stride = width * drm_format_plane_cpp(DRM_FORMAT_ARGB8888, 0);
+	stride = width * drm_format_plane_cpp(info, 0);
 
 	get_roi(crtc, &roi_w, &roi_h);
 
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index b30b2f4efc60..03d503d8c3ba 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -158,7 +158,7 @@ uint32_t mdp5_smp_calculate(struct mdp5_smp *smp,
 	for (i = 0; i < nplanes; i++) {
 		int n, fetch_stride, cpp;
 
-		cpp = drm_format_plane_cpp(fmt, i);
+		cpp = drm_format_plane_cpp(info, i);
 		fetch_stride = width * cpp / (i ? hsub : 1);
 
 		n = DIV_ROUND_UP(fetch_stride * nlines, smp->blk_size);
diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
index f69c0afd6ec6..ee91058c7974 100644
--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -181,7 +181,7 @@ static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
 		unsigned int min_size;
 
 		min_size = (height - 1) * mode_cmd->pitches[i]
-			 + width * drm_format_plane_cpp(mode_cmd->pixel_format, i)
+			 + width * drm_format_plane_cpp(info, i)
 			 + mode_cmd->offsets[i];
 
 		if (bos[i]->size < min_size) {
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 1179034024ae..88fc1a6e2e43 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -125,6 +125,8 @@ static int radeonfb_create_pinned_object(struct radeon_fbdev *rfbdev,
 					 struct drm_mode_fb_cmd2 *mode_cmd,
 					 struct drm_gem_object **gobj_p)
 {
+	const struct drm_format_info *info = drm_get_format_info(dev,
+								 mode_cmd);
 	struct radeon_device *rdev = rfbdev->rdev;
 	struct drm_gem_object *gobj = NULL;
 	struct radeon_bo *rbo = NULL;
@@ -135,7 +137,7 @@ static int radeonfb_create_pinned_object(struct radeon_fbdev *rfbdev,
 	int height = mode_cmd->height;
 	u32 cpp;
 
-	cpp = drm_format_plane_cpp(mode_cmd->pixel_format, 0);
+	cpp = drm_format_plane_cpp(info, 0);
 
 	/* need to align pitch with crtc limits */
 	mode_cmd->pitches[0] = radeon_align_pitch(rdev, mode_cmd->width, cpp,
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
index c318fae28581..c602cb2f4d3c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -98,7 +98,7 @@ rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
 
 		min_size = (height - 1) * mode_cmd->pitches[i] +
 			mode_cmd->offsets[i] +
-			width * drm_format_plane_cpp(mode_cmd->pixel_format, i);
+			width * drm_format_plane_cpp(info, i);
 
 		if (obj->size < min_size) {
 			drm_gem_object_put_unlocked(obj);
diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index b1741a9d5be2..b226df7dbf6f 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -779,7 +779,7 @@ static void ltdc_plane_atomic_update(struct drm_plane *plane,
 
 	/* Configures the color frame buffer pitch in bytes & line length */
 	pitch_in_bytes = fb->pitches[0];
-	line_length = drm_format_plane_cpp(fb->format->format, 0) *
+	line_length = drm_format_plane_cpp(fb->format, 0) *
 		      (x1 - x0 + 1) + (ldev->caps.bus_width >> 3) - 1;
 	val = ((pitch_in_bytes << 16) | line_length);
 	reg_update_bits(ldev->regs, LTDC_L1CFBLR + lofs,
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index ddf2c764f24c..0a97458b286a 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -149,7 +149,7 @@ struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
 			goto unreference;
 		}
 
-		bpp = drm_format_plane_cpp(cmd->pixel_format, i);
+		bpp = drm_format_plane_cpp(info, i);
 
 		size = (height - 1) * cmd->pitches[i] +
 		       width * bpp + cmd->offsets[i];
diff --git a/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c b/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
index 2737b6fdadc8..57dda9d1a45d 100644
--- a/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
+++ b/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
@@ -36,7 +36,7 @@ MODULE_PARM_DESC(spi_max, "Set a lower SPI max transfer size");
 void tinydrm_memcpy(void *dst, void *vaddr, struct drm_framebuffer *fb,
 		    struct drm_rect *clip)
 {
-	unsigned int cpp = drm_format_plane_cpp(fb->format->format, 0);
+	unsigned int cpp = drm_format_plane_cpp(fb->format, 0);
 	unsigned int pitch = fb->pitches[0];
 	void *src = vaddr + (clip->y1 * pitch) + (clip->x1 * cpp);
 	size_t len = (clip->x2 - clip->x1) * cpp;
diff --git a/drivers/gpu/drm/zte/zx_plane.c b/drivers/gpu/drm/zte/zx_plane.c
index c6a8be444300..41bd0db4e876 100644
--- a/drivers/gpu/drm/zte/zx_plane.c
+++ b/drivers/gpu/drm/zte/zx_plane.c
@@ -222,7 +222,7 @@ static void zx_vl_plane_atomic_update(struct drm_plane *plane,
 		cma_obj = drm_fb_cma_get_gem_obj(fb, i);
 		paddr = cma_obj->paddr + fb->offsets[i];
 		paddr += src_y * fb->pitches[i];
-		paddr += src_x * drm_format_plane_cpp(format, i);
+		paddr += src_x * drm_format_plane_cpp(fb->format, i);
 		zx_writel(paddr_reg, paddr);
 		paddr_reg += 4;
 	}
diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
index eeec449d6c6a..97a58f3e7462 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -268,7 +268,7 @@ drm_get_format_info(struct drm_device *dev,
 uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
 uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
 				     uint32_t bpp, uint32_t depth);
-int drm_format_plane_cpp(uint32_t format, int plane);
+int drm_format_plane_cpp(const struct drm_format_info *info, int plane);
 int drm_format_plane_width(int width, uint32_t format, int plane);
 int drm_format_plane_height(int height, uint32_t format, int plane);
 unsigned int drm_format_info_block_width(const struct drm_format_info *info,
-- 
git-series 0.9.1

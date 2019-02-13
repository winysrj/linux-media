Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04AFC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80D342075D
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390000AbfBMN3W (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:29:22 -0500
Received: from mga07.intel.com ([134.134.136.100]:2839 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbfBMN3V (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 08:29:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 05:29:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,365,1544515200"; 
   d="scan'208";a="318662136"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2019 05:29:17 -0800
From:   Swati Sharma <swati2.sharma@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>
Subject: [PATCH 2/6] drm/i915: Preparations for enabling P010, P012, P016 formats
Date:   Wed, 13 Feb 2019 18:55:29 +0530
Message-Id: <1550064333-6168-3-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
References: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

Preparations for enabling P010, P012 and P016 formats. These
formats will extend NV12 for larger bit depths.

Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_atomic_plane.c |  2 +-
 drivers/gpu/drm/i915/intel_display.c      | 27 +++++++++++++++++++++------
 drivers/gpu/drm/i915/intel_drv.h          |  1 +
 drivers/gpu/drm/i915/intel_pm.c           | 14 +++++++-------
 drivers/gpu/drm/i915/intel_sprite.c       | 22 +++++++++++++++++++---
 5 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_atomic_plane.c b/drivers/gpu/drm/i915/intel_atomic_plane.c
index 01bf3ce..c802987 100644
--- a/drivers/gpu/drm/i915/intel_atomic_plane.c
+++ b/drivers/gpu/drm/i915/intel_atomic_plane.c
@@ -136,7 +136,7 @@ int intel_plane_atomic_check_with_state(const struct intel_crtc_state *old_crtc_
 		new_crtc_state->active_planes |= BIT(plane->id);
 
 	if (new_plane_state->base.visible &&
-	    new_plane_state->base.fb->format->format == DRM_FORMAT_NV12)
+	    is_planar_yuv_format(new_plane_state->base.fb->format->format))
 		new_crtc_state->nv12_planes |= BIT(plane->id);
 
 	if (new_plane_state->base.visible &&
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 5b8dabd..77bc046 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2677,6 +2677,12 @@ int skl_format_to_fourcc(int format, bool rgb_order, bool alpha)
 		return DRM_FORMAT_RGB565;
 	case PLANE_CTL_FORMAT_NV12:
 		return DRM_FORMAT_NV12;
+	case PLANE_CTL_FORMAT_P010:
+		return DRM_FORMAT_P010;
+	case PLANE_CTL_FORMAT_P012:
+		return DRM_FORMAT_P012;
+	case PLANE_CTL_FORMAT_P016:
+		return DRM_FORMAT_P016;
 	default:
 	case PLANE_CTL_FORMAT_XRGB_8888:
 		if (rgb_order) {
@@ -3176,7 +3182,7 @@ int skl_check_plane_surface(struct intel_plane_state *plane_state)
 	 * Handle the AUX surface first since
 	 * the main surface setup depends on it.
 	 */
-	if (fb->format->format == DRM_FORMAT_NV12) {
+	if (is_planar_yuv_format(fb->format->format)) {
 		ret = skl_check_nv12_aux_surface(plane_state);
 		if (ret)
 			return ret;
@@ -3601,6 +3607,12 @@ static u32 skl_plane_ctl_format(u32 pixel_format)
 		return PLANE_CTL_FORMAT_YUV422 | PLANE_CTL_YUV422_VYUY;
 	case DRM_FORMAT_NV12:
 		return PLANE_CTL_FORMAT_NV12;
+	case DRM_FORMAT_P010:
+		return PLANE_CTL_FORMAT_P010;
+	case DRM_FORMAT_P012:
+		return PLANE_CTL_FORMAT_P012;
+	case DRM_FORMAT_P016:
+		return PLANE_CTL_FORMAT_P016;
 	default:
 		MISSING_CASE(pixel_format);
 	}
@@ -5033,9 +5045,9 @@ u16 skl_scaler_calc_phase(int sub, int scale, bool chroma_cosited)
 		return 0;
 	}
 
-	if (format && format->format == DRM_FORMAT_NV12 &&
+	if (format && is_planar_yuv_format(format->format) &&
 	    (src_h < SKL_MIN_YUV_420_SRC_H || src_w < SKL_MIN_YUV_420_SRC_W)) {
-		DRM_DEBUG_KMS("NV12: src dimensions not met\n");
+		DRM_DEBUG_KMS("Planar YUV: src dimensions not met\n");
 		return -EINVAL;
 	}
 
@@ -5109,7 +5121,7 @@ static int skl_update_scaler_plane(struct intel_crtc_state *crtc_state,
 
 	/* Pre-gen11 and SDR planes always need a scaler for planar formats. */
 	if (!icl_is_hdr_plane(intel_plane) &&
-	    fb && fb->format->format == DRM_FORMAT_NV12)
+	    fb && is_planar_yuv_format(fb->format->format))
 		need_scaler = true;
 
 	ret = skl_update_scaler(crtc_state, force_detach,
@@ -5146,6 +5158,9 @@ static int skl_update_scaler_plane(struct intel_crtc_state *crtc_state,
 	case DRM_FORMAT_UYVY:
 	case DRM_FORMAT_VYUY:
 	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_P010:
+	case DRM_FORMAT_P012:
+	case DRM_FORMAT_P016:
 		break;
 	default:
 		DRM_DEBUG_KMS("[PLANE:%d:%s] FB:%d unsupported scaling format 0x%x\n",
@@ -11198,7 +11213,7 @@ static int icl_check_nv12_planes(struct intel_crtc_state *crtc_state)
 		}
 
 		if (!linked_state) {
-			DRM_DEBUG_KMS("Need %d free Y planes for NV12\n",
+			DRM_DEBUG_KMS("Need %d free Y planes for planar YUV\n",
 				      hweight8(crtc_state->nv12_planes));
 
 			return -EINVAL;
@@ -13829,7 +13844,7 @@ static void fb_obj_bump_render_priority(struct drm_i915_gem_object *obj)
 	 *            or
 	 *    cdclk/crtc_clock
 	 */
-	mult = pixel_format == DRM_FORMAT_NV12 ? 2 : 3;
+	mult = is_planar_yuv_format(pixel_format) ? 2 : 3;
 	tmpclk1 = (1 << 16) * mult - 1;
 	tmpclk2 = (1 << 8) * ((max_dotclk << 8) / crtc_clock);
 	max_scale = min(tmpclk1, tmpclk2);
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index fd50c962..a106b73 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -2304,6 +2304,7 @@ bool intel_sdvo_init(struct drm_i915_private *dev_priv,
 
 
 /* intel_sprite.c */
+bool is_planar_yuv_format(u32 pixelformat);
 int intel_usecs_to_scanlines(const struct drm_display_mode *adjusted_mode,
 			     int usecs);
 struct intel_plane *intel_sprite_plane_create(struct drm_i915_private *dev_priv,
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index 454581b..b9eedba 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3970,7 +3970,7 @@ static void skl_ddb_entry_init_from_hw(struct drm_i915_private *dev_priv,
 		val = I915_READ(PLANE_BUF_CFG(pipe, plane_id));
 		val2 = I915_READ(PLANE_NV12_BUF_CFG(pipe, plane_id));
 
-		if (fourcc == DRM_FORMAT_NV12)
+		if (is_planar_yuv_format(fourcc))
 			swap(val, val2);
 
 		skl_ddb_entry_init_from_hw(dev_priv, ddb_y, val);
@@ -4180,7 +4180,7 @@ int skl_check_pipe_max_pixel_rate(struct intel_crtc *intel_crtc,
 
 	if (intel_plane->id == PLANE_CURSOR)
 		return 0;
-	if (plane == 1 && format != DRM_FORMAT_NV12)
+	if (plane == 1 && !is_planar_yuv_format(format))
 		return 0;
 
 	/*
@@ -4192,7 +4192,7 @@ int skl_check_pipe_max_pixel_rate(struct intel_crtc *intel_crtc,
 	height = drm_rect_height(&intel_pstate->base.src) >> 16;
 
 	/* UV plane does 1/2 pixel sub-sampling */
-	if (plane == 1 && format == DRM_FORMAT_NV12) {
+	if (plane == 1 && is_planar_yuv_format(format)) {
 		width /= 2;
 		height /= 2;
 	}
@@ -4578,9 +4578,9 @@ int skl_check_pipe_max_pixel_rate(struct intel_crtc *intel_crtc,
 	const struct drm_framebuffer *fb = pstate->fb;
 	u32 interm_pbpl;
 
-	/* only NV12 format has two planes */
-	if (color_plane == 1 && fb->format->format != DRM_FORMAT_NV12) {
-		DRM_DEBUG_KMS("Non NV12 format have single plane\n");
+	/* only planar format has two planes */
+	if (color_plane == 1 && !is_planar_yuv_format(fb->format->format)) {
+		DRM_DEBUG_KMS("Non planar format have single plane\n");
 		return -EINVAL;
 	}
 
@@ -4591,7 +4591,7 @@ int skl_check_pipe_max_pixel_rate(struct intel_crtc *intel_crtc,
 	wp->x_tiled = fb->modifier == I915_FORMAT_MOD_X_TILED;
 	wp->rc_surface = fb->modifier == I915_FORMAT_MOD_Y_TILED_CCS ||
 			 fb->modifier == I915_FORMAT_MOD_Yf_TILED_CCS;
-	wp->is_planar = fb->format->format == DRM_FORMAT_NV12;
+	wp->is_planar = is_planar_yuv_format(fb->format->format);
 
 	if (plane->id == PLANE_CURSOR) {
 		wp->width = intel_pstate->base.crtc_w;
diff --git a/drivers/gpu/drm/i915/intel_sprite.c b/drivers/gpu/drm/i915/intel_sprite.c
index 6103986..1be7d59 100644
--- a/drivers/gpu/drm/i915/intel_sprite.c
+++ b/drivers/gpu/drm/i915/intel_sprite.c
@@ -41,6 +41,19 @@
 #include "i915_drv.h"
 #include <drm/drm_color_mgmt.h>
 
+bool is_planar_yuv_format(u32 pixelformat)
+{
+	switch (pixelformat) {
+	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_P010:
+	case DRM_FORMAT_P012:
+	case DRM_FORMAT_P016:
+		return true;
+	default:
+		return false;
+	}
+}
+
 int intel_usecs_to_scanlines(const struct drm_display_mode *adjusted_mode,
 			     int usecs)
 {
@@ -335,7 +348,7 @@ int intel_plane_check_src_coordinates(struct intel_plane_state *plane_state)
 				      0, INT_MAX);
 
 	/* TODO: handle sub-pixel coordinates */
-	if (plane_state->base.fb->format->format == DRM_FORMAT_NV12 &&
+	if (is_planar_yuv_format(plane_state->base.fb->format->format) &&
 	    !icl_is_hdr_plane(plane)) {
 		y_hphase = skl_scaler_calc_phase(1, hscale, false);
 		y_vphase = skl_scaler_calc_phase(1, vscale, false);
@@ -1564,10 +1577,10 @@ static int skl_plane_check_nv12_rotation(const struct intel_plane_state *plane_s
 	int src_w = drm_rect_width(&plane_state->base.src) >> 16;
 
 	/* Display WA #1106 */
-	if (fb->format->format == DRM_FORMAT_NV12 && src_w & 3 &&
+	if (is_planar_yuv_format(fb->format->format) && src_w & 3 &&
 	    (rotation == DRM_MODE_ROTATE_270 ||
 	     rotation == (DRM_MODE_REFLECT_X | DRM_MODE_ROTATE_90))) {
-		DRM_DEBUG_KMS("src width must be multiple of 4 for rotated NV12\n");
+		DRM_DEBUG_KMS("src width must be multiple of 4 for rotated planar YUV\n");
 		return -EINVAL;
 	}
 
@@ -1958,6 +1971,9 @@ static bool skl_plane_format_mod_supported(struct drm_plane *_plane,
 	case DRM_FORMAT_UYVY:
 	case DRM_FORMAT_VYUY:
 	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_P010:
+	case DRM_FORMAT_P012:
+	case DRM_FORMAT_P016:
 		if (modifier == I915_FORMAT_MOD_Yf_TILED)
 			return true;
 		/* fall through */
-- 
1.9.1


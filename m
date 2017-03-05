Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:39162 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbdCEKAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 05:00:51 -0500
From: Randy Li <ayaka@soulik.info>
To: dri-devel@lists.freedesktop.org
Cc: clinton.a.taylor@intel.com, daniel@fooishbar.org,
        ville.syrjala@linux.intel.com, linux-media@vger.kernel.org,
        mchehab@kernel.org, linux-kernel@vger.kernel.org,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v6 3/3] drm/rockchip: Support 10 bits yuv format in vop
Date: Sun,  5 Mar 2017 18:00:33 +0800
Message-Id: <1488708033-5691-4-git-send-email-ayaka@soulik.info>
In-Reply-To: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
References: <1488708033-5691-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rockchip use a special pixel format for those yuv pixel
format with 10 bits color depth.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c  |  1 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c | 34 ++++++++++++++++++++++++++---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h |  1 +
 drivers/gpu/drm/rockchip/rockchip_vop_reg.c |  2 ++
 include/uapi/drm/drm_fourcc.h               | 11 ++++++++++
 5 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
index c9ccdf8..250fd29 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -230,6 +230,7 @@ void rockchip_drm_mode_config_init(struct drm_device *dev)
 	 */
 	dev->mode_config.max_width = 4096;
 	dev->mode_config.max_height = 4096;
+	dev->mode_config.allow_fb_modifiers = true;
 
 	dev->mode_config.funcs = &rockchip_drm_mode_config_funcs;
 	dev->mode_config.helper_private = &rockchip_mode_config_helpers;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 76c79ac..45da270 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -232,6 +232,7 @@ static enum vop_data_format vop_convert_format(uint32_t format)
 	case DRM_FORMAT_BGR565:
 		return VOP_FMT_RGB565;
 	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_P010:
 		return VOP_FMT_YUV420SP;
 	case DRM_FORMAT_NV16:
 		return VOP_FMT_YUV422SP;
@@ -249,12 +250,28 @@ static bool is_yuv_support(uint32_t format)
 	case DRM_FORMAT_NV12:
 	case DRM_FORMAT_NV16:
 	case DRM_FORMAT_NV24:
+	case DRM_FORMAT_P010:
 		return true;
 	default:
 		return false;
 	}
 }
 
+static bool is_support_fb(struct drm_framebuffer *fb)
+{
+	switch (fb->format->format) {
+	case DRM_FORMAT_NV12:
+	case DRM_FORMAT_NV16:
+	case DRM_FORMAT_NV24:
+		return true;
+	case DRM_FORMAT_P010:
+		if (fb->modifier == DRM_FORMAT_MOD_ROCKCHIP_10BITS)
+			return true;
+	default:
+		return false;
+	}
+
+}
 static bool is_alpha_support(uint32_t format)
 {
 	switch (format) {
@@ -680,7 +697,7 @@ static int vop_plane_atomic_check(struct drm_plane *plane,
 	 * Src.x1 can be odd when do clip, but yuv plane start point
 	 * need align with 2 pixel.
 	 */
-	if (is_yuv_support(fb->format->format) && ((state->src.x1 >> 16) % 2))
+	if (is_support_fb(fb) && ((state->src.x1 >> 16) % 2))
 		return -EINVAL;
 
 	return 0;
@@ -723,6 +740,7 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 	dma_addr_t dma_addr;
 	uint32_t val;
 	bool rb_swap;
+	bool is_10_bits = false;
 	int format;
 
 	/*
@@ -739,6 +757,9 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 		return;
 	}
 
+	if (fb->modifier == DRM_FORMAT_MOD_ROCKCHIP_10BITS)
+		is_10_bits = true;
+
 	obj = rockchip_fb_get_gem_obj(fb, 0);
 	rk_obj = to_rockchip_obj(obj);
 
@@ -753,7 +774,10 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 	dsp_sty = dest->y1 + crtc->mode.vtotal - crtc->mode.vsync_start;
 	dsp_st = dsp_sty << 16 | (dsp_stx & 0xffff);
 
-	offset = (src->x1 >> 16) * fb->format->cpp[0];
+	if (is_10_bits)
+		offset = (src->x1 >> 16) * 10 / 8;
+	else
+		offset = (src->x1 >> 16) * fb->format->cpp[0];
 	offset += (src->y1 >> 16) * fb->pitches[0];
 	dma_addr = rk_obj->dma_addr + offset + fb->offsets[0];
 
@@ -764,6 +788,7 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 	VOP_WIN_SET(vop, win, format, format);
 	VOP_WIN_SET(vop, win, yrgb_vir, fb->pitches[0] >> 2);
 	VOP_WIN_SET(vop, win, yrgb_mst, dma_addr);
+	VOP_WIN_SET(vop, win, fmt_10, is_10_bits);
 	if (is_yuv_support(fb->format->format)) {
 		int hsub = drm_format_horz_chroma_subsampling(fb->format->format);
 		int vsub = drm_format_vert_chroma_subsampling(fb->format->format);
@@ -772,7 +797,10 @@ static void vop_plane_atomic_update(struct drm_plane *plane,
 		uv_obj = rockchip_fb_get_gem_obj(fb, 1);
 		rk_uv_obj = to_rockchip_obj(uv_obj);
 
-		offset = (src->x1 >> 16) * bpp / hsub;
+		if (is_10_bits)
+			offset = (src->x1 >> 16) * 10 / 8 / hsub;
+		else
+			offset = (src->x1 >> 16) * bpp / hsub;
 		offset += (src->y1 >> 16) * fb->pitches[1] / vsub;
 
 		dma_addr = rk_uv_obj->dma_addr + offset + fb->offsets[1];
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
index 5a4faa85..1743797 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -116,6 +116,7 @@ struct vop_win_phy {
 
 	struct vop_reg enable;
 	struct vop_reg format;
+	struct vop_reg fmt_10;
 	struct vop_reg rb_swap;
 	struct vop_reg act_info;
 	struct vop_reg dsp_info;
diff --git a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
index 91fbc7b..9bbdf3c 100644
--- a/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
+++ b/drivers/gpu/drm/rockchip/rockchip_vop_reg.c
@@ -44,6 +44,7 @@ static const uint32_t formats_win_full[] = {
 	DRM_FORMAT_NV12,
 	DRM_FORMAT_NV16,
 	DRM_FORMAT_NV24,
+	DRM_FORMAT_P010,
 };
 
 static const uint32_t formats_win_lite[] = {
@@ -178,6 +179,7 @@ static const struct vop_win_phy rk3288_win01_data = {
 	.nformats = ARRAY_SIZE(formats_win_full),
 	.enable = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 0),
 	.format = VOP_REG(RK3288_WIN0_CTRL0, 0x7, 1),
+	.fmt_10 = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 4),
 	.rb_swap = VOP_REG(RK3288_WIN0_CTRL0, 0x1, 12),
 	.act_info = VOP_REG(RK3288_WIN0_ACT_INFO, 0x1fff1fff, 0),
 	.dsp_info = VOP_REG(RK3288_WIN0_DSP_INFO, 0x0fff0fff, 0),
diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 306f979..209bdb6 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -189,6 +189,7 @@ extern "C" {
 #define DRM_FORMAT_MOD_VENDOR_SAMSUNG 0x04
 #define DRM_FORMAT_MOD_VENDOR_QCOM    0x05
 #define DRM_FORMAT_MOD_VENDOR_VIVANTE 0x06
+#define DRM_FORMAT_MOD_VENDOR_ROCKCHIP 0x07
 /* add more to the end as needed */
 
 #define fourcc_mod_code(vendor, val) \
@@ -313,6 +314,16 @@ extern "C" {
  */
 #define DRM_FORMAT_MOD_VIVANTE_SPLIT_SUPER_TILED fourcc_mod_code(VIVANTE, 4)
 
+/*
+ * Rockchip 10bits color depth layout
+ *
+ * It could be regard as a compact variant of P010. The 6 bits set to zero
+ * in P010 are used to store the next pixel in this format. The stride should
+ * be aligned with 8 bit(a byte), so there would be zero bits at the last byte
+ * if the pixel can't fill it. And this format is not a tiling layout.
+ */
+#define DRM_FORMAT_MOD_ROCKCHIP_10BITS fourcc_mod_code(ROCKCHIP, 1)
+
 #if defined(__cplusplus)
 }
 #endif
-- 
2.7.4

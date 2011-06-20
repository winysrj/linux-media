Return-path: <mchehab@pedra>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:45267 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750789Ab1FTU0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:26:06 -0400
Received: from c-67-161-37-189.hsd1.ca.comcast.net ([67.161.37.189] helo=jbarnes-desktop)
	by box514.bluehost.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <jbarnes@virtuousgeek.org>)
	id 1QYl2r-000497-9Y
	for linux-media@vger.kernel.org; Mon, 20 Jun 2011 14:26:05 -0600
From: Jesse Barnes <jbarnes@virtuousgeek.org> (by way of Jesse Barnes
	<jbarnes@virtuousgeek.org>)
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Mon, 20 Jun 2011 13:11:41 -0700
Message-Id: <1308600701-7442-5-git-send-email-jbarnes@virtuousgeek.org>
In-Reply-To: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
References: <1308600701-7442-1-git-send-email-jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATCH 4/4] drm/i915: add SNB video sprite support
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The video sprites support video surface formats natively and can handle
scaling well.  So add support for them using the new DRM core overlay
support functions.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/gpu/drm/i915/Makefile         |    1 +
 drivers/gpu/drm/i915/i915_reg.h       |   52 +++++++++
 drivers/gpu/drm/i915/intel_display.c  |   19 +++-
 drivers/gpu/drm/i915/intel_drv.h      |   14 +++
 drivers/gpu/drm/i915/intel_fb.c       |    6 +
 drivers/gpu/drm/i915/intel_overlay2.c |  188 +++++++++++++++++++++++++++++++++
 6 files changed, 274 insertions(+), 6 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/intel_overlay2.c

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 0ae6a7c..6193471 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -28,6 +28,7 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o i915_mem.o \
 	  intel_dvo.o \
 	  intel_ringbuffer.o \
 	  intel_overlay.o \
+	  intel_overlay2.o \
 	  intel_opregion.o \
 	  dvo_ch7xxx.o \
 	  dvo_ch7017.o \
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 2f967af..c81c4e7 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2627,6 +2627,58 @@
 #define _DSPBSURF		0x7119C
 #define _DSPBTILEOFF		0x711A4
 
+/* Sprite A control */
+#define _DVSACNTR		0x72180
+#define   DVS_ENABLE		(1<<31)
+#define   DVS_GAMMA_ENABLE	(1<<30)
+#define   DVS_PIXFORMAT_MASK	(3<<25)
+#define   DVS_FORMAT_YUV422	(0<<25)
+#define   DVS_FORMAT_RGBX101010	(1<<25)
+#define   DVS_FORMAT_RGBX888	(2<<25)
+#define   DVS_FORMAT_RGBX161616	(3<<25)
+#define   DVS_SOURCE_KEY	(1<<22)
+#define   DVS_RGB_ORDER_RGBX	(1<<20)
+#define   DVS_YUV_BYTE_ORDER_MASK (3<<16)
+#define   DVS_YUV_ORDER_YUYV	(0<<16)
+#define   DVS_YUV_ORDER_UYVY	(1<<16)
+#define   DVS_YUV_ORDER_YVYU	(2<<16)
+#define   DVS_YUV_ORDER_VYUY	(3<<16)
+#define   DVS_DEST_KEY		(1<<2)
+#define   DVS_TRICKLE_FEED_DISABLE (1<<14)
+#define   DVS_TILED		(1<<10)
+#define _DVSASTRIDE		0x72188
+#define _DVSAPOS		0x7218c
+#define _DVSASIZE		0x72190
+#define _DVSAKEYVAL		0x72194
+#define _DVSAKEYMSK		0x72198
+#define _DVSASURF		0x7219c
+#define _DVSAKEYMAXVAL		0x721a0
+#define _DVSATILEOFF		0x721a4
+#define _DVSASURFLIVE		0x721ac
+#define _DVSASCALE		0x72204
+#define _DVSAGAMC		0x72300
+
+#define _DVSBCNTR		0x73180
+#define _DVSBSTRIDE		0x73188
+#define _DVSBPOS		0x7318c
+#define _DVSBSIZE		0x73190
+#define _DVSBKEYVAL		0x73194
+#define _DVSBKEYMSK		0x73198
+#define _DVSBSURF		0x7319c
+#define _DVSBKEYMAXVAL		0x731a0
+#define _DVSBTILEOFF		0x731a4
+#define _DVSBSURFLIVE		0x731ac
+#define _DVSBSCALE		0x73204
+#define _DVSBGAMC		0x73300
+
+#define DVSCNTR(pipe) _PIPE(pipe, _DVSACNTR, _DVSBCNTR)
+#define DVSSTRIDE(pipe) _PIPE(pipe, _DVSASTRIDE, _DVSBSTRIDE)
+#define DVSPOS(pipe) _PIPE(pipe, _DVSAPOS, _DVSBPOS)
+#define DVSSURF(pipe) _PIPE(pipe, _DVSASURF, _DVSBSURF)
+#define DVSSIZE(pipe) _PIPE(pipe, _DVSASIZE, _DVSBSIZE)
+#define DVSSCALE(pipe) _PIPE(pipe, _DVSASCALE, _DVSBSCALE)
+#define DVSTILEOFF(pipe) _PIPE(pipe, _DVSATILEOFF, _DVSBTILEOFF)
+
 /* VBIOS regs */
 #define VGACNTRL		0x71400
 # define VGA_DISP_DISABLE			(1 << 31)
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7901f16..72a570a 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -900,8 +900,8 @@ static void assert_panel_unlocked(struct drm_i915_private *dev_priv,
 	     pipe_name(pipe));
 }
 
-static void assert_pipe(struct drm_i915_private *dev_priv,
-			enum pipe pipe, bool state)
+void assert_pipe(struct drm_i915_private *dev_priv,
+		 enum pipe pipe, bool state)
 {
 	int reg;
 	u32 val;
@@ -914,8 +914,6 @@ static void assert_pipe(struct drm_i915_private *dev_priv,
 	     "pipe %c assertion failure (expected %s, current %s)\n",
 	     pipe_name(pipe), state_string(state), state_string(cur_state));
 }
-#define assert_pipe_enabled(d, p) assert_pipe(d, p, true)
-#define assert_pipe_disabled(d, p) assert_pipe(d, p, false)
 
 static void assert_plane_enabled(struct drm_i915_private *dev_priv,
 				 enum plane plane)
@@ -4319,7 +4317,8 @@ static void sandybridge_update_wm(struct drm_device *dev)
 				 &sandybridge_cursor_wm_info, latency,
 				 &plane_wm, &cursor_wm)) {
 		I915_WRITE(WM0_PIPEA_ILK,
-			   (plane_wm << WM0_PIPE_PLANE_SHIFT) | cursor_wm);
+			   (plane_wm << WM0_PIPE_PLANE_SHIFT) |
+			   (plane_wm << WM0_PIPE_SPRITE_SHIFT) | cursor_wm);
 		DRM_DEBUG_KMS("FIFO watermarks For pipe A -"
 			      " plane %d, " "cursor: %d\n",
 			      plane_wm, cursor_wm);
@@ -4331,7 +4330,8 @@ static void sandybridge_update_wm(struct drm_device *dev)
 				 &sandybridge_cursor_wm_info, latency,
 				 &plane_wm, &cursor_wm)) {
 		I915_WRITE(WM0_PIPEB_ILK,
-			   (plane_wm << WM0_PIPE_PLANE_SHIFT) | cursor_wm);
+			   (plane_wm << WM0_PIPE_PLANE_SHIFT) |
+			   (plane_wm << WM0_PIPE_SPRITE_SHIFT) | cursor_wm);
 		DRM_DEBUG_KMS("FIFO watermarks For pipe B -"
 			      " plane %d, cursor: %d\n",
 			      plane_wm, cursor_wm);
@@ -4371,6 +4371,11 @@ static void sandybridge_update_wm(struct drm_device *dev)
 		   (plane_wm << WM1_LP_SR_SHIFT) |
 		   cursor_wm);
 
+#if 0
+	I915_WRITE(WM1S_LP_ILK,
+		   WM1S_LP_EN |
+#endif
+
 	/* WM2 */
 	if (!ironlake_compute_srwm(dev, 2, enabled,
 				   SNB_READ_WM2_LATENCY() * 500,
@@ -8013,6 +8018,8 @@ void intel_modeset_init(struct drm_device *dev)
 
 	for (i = 0; i < dev_priv->num_pipe; i++) {
 		intel_crtc_init(dev, i);
+		if (HAS_PCH_SPLIT(dev))
+			intel_plane_init(dev, i);
 	}
 
 	/* Just disable it once at startup */
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index d73e622..232d797 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -173,10 +173,18 @@ struct intel_crtc {
 	unsigned int bpp;
 };
 
+struct intel_plane {
+	struct drm_plane base;
+	enum pipe pipe;
+	struct drm_i915_gem_object *obj;
+	u32 lut_r[1024], lut_g[1024], lut_b[1024];
+};
+
 #define to_intel_crtc(x) container_of(x, struct intel_crtc, base)
 #define to_intel_connector(x) container_of(x, struct intel_connector, base)
 #define to_intel_encoder(x) container_of(x, struct intel_encoder, base)
 #define to_intel_framebuffer(x) container_of(x, struct intel_framebuffer, base)
+#define to_intel_plane(x) container_of(x, struct intel_plane, base)
 
 #define DIP_TYPE_AVI    0x82
 #define DIP_VERSION_AVI 0x2
@@ -255,6 +263,7 @@ intel_dp_set_m_n(struct drm_crtc *crtc, struct drm_display_mode *mode,
 extern bool intel_dpd_is_edp(struct drm_device *dev);
 extern void intel_edp_link_config (struct intel_encoder *, int *, int *);
 extern bool intel_encoder_is_pch_edp(struct drm_encoder *encoder);
+extern void intel_plane_init(struct drm_device *dev, enum pipe pipe);
 
 /* intel_panel.c */
 extern void intel_fixed_panel_mode(struct drm_display_mode *fixed_mode,
@@ -346,5 +355,10 @@ extern int intel_overlay_attrs(struct drm_device *dev, void *data,
 extern void intel_fb_output_poll_changed(struct drm_device *dev);
 extern void intel_fb_restore_mode(struct drm_device *dev);
 
+extern void assert_pipe(struct drm_i915_private *dev_priv, enum pipe pipe,
+			bool state);
+#define assert_pipe_enabled(d, p) assert_pipe(d, p, true)
+#define assert_pipe_disabled(d, p) assert_pipe(d, p, false)
+
 extern void intel_init_clock_gating(struct drm_device *dev);
 #endif /* __INTEL_DRV_H__ */
diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 11baa99..513a40c 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -270,8 +270,14 @@ void intel_fb_restore_mode(struct drm_device *dev)
 {
 	int ret;
 	drm_i915_private_t *dev_priv = dev->dev_private;
+	struct drm_mode_config *config = &dev->mode_config;
+	struct drm_plane *plane;
 
 	ret = drm_fb_helper_restore_fbdev_mode(&dev_priv->fbdev->helper);
 	if (ret)
 		DRM_DEBUG("failed to restore crtc mode\n");
+
+	/* Be sure to shut off any planes that may be active */
+	list_for_each_entry(plane, &config->plane_list, head)
+		plane->funcs->disable_plane(plane);
 }
diff --git a/drivers/gpu/drm/i915/intel_overlay2.c b/drivers/gpu/drm/i915/intel_overlay2.c
new file mode 100644
index 0000000..19fd76f
--- /dev/null
+++ b/drivers/gpu/drm/i915/intel_overlay2.c
@@ -0,0 +1,188 @@
+/*
+ * Copyright © 2011 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Authors:
+ *   Jesse Barnes <jbarnes@virtuousgeek.org>
+ *
+ * New plane/sprite handling.
+ *
+ * The older chips had a separate interface for programming plane related
+ * registers; newer ones are much simpler and we can use the new DRM plane
+ * support.
+ */
+#include "drmP.h"
+#include "drm_crtc.h"
+#include "intel_drv.h"
+#include "i915_drm.h"
+#include "i915_drv.h"
+
+static int
+intel_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
+		   struct drm_framebuffer *fb, int crtc_x, int crtc_y,
+		   unsigned int crtc_w, unsigned int crtc_h,
+		   uint32_t src_x, uint32_t src_y,
+		   uint32_t src_w, uint32_t src_h)
+{
+	struct drm_device *dev = plane->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_plane *intel_plane = to_intel_plane(plane);
+	struct intel_framebuffer *intel_fb;
+	struct drm_i915_gem_object *obj, *old_obj;
+	int pipe = intel_plane->pipe;
+	unsigned long start, offset;
+	u32 dvscntr;
+	u32 reg = DVSCNTR(pipe);
+	int ret = 0;
+	int x = src_x >> 16, y = src_y >> 16;
+
+	assert_pipe_enabled(dev_priv, pipe);
+
+	intel_fb = to_intel_framebuffer(fb);
+	obj = intel_fb->obj;
+
+	old_obj = intel_plane->obj;
+
+	mutex_lock(&dev->struct_mutex);
+	ret = intel_pin_and_fence_fb_obj(dev, obj, NULL);
+	if (ret)
+		goto out_unlock;
+
+	intel_plane->obj = obj;
+
+	dvscntr = I915_READ(reg);
+
+	/* Mask out pixel format bits in case we change it */
+	dvscntr &= ~DVS_PIXFORMAT_MASK;
+	dvscntr &= ~DVS_RGB_ORDER_RGBX;
+	dvscntr &= ~DVS_YUV_BYTE_ORDER_MASK;
+
+	switch (fb->pixel_format) {
+	case V4L2_PIX_FMT_BGR32:
+		dvscntr |= DVS_FORMAT_RGBX888;
+		break;
+	case V4L2_PIX_FMT_RGB32:
+		dvscntr |= DVS_FORMAT_RGBX888 | DVS_RGB_ORDER_RGBX;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		dvscntr |= DVS_FORMAT_YUV422 | DVS_YUV_ORDER_YUYV;
+		break;
+	case V4L2_PIX_FMT_YVYU:
+		dvscntr |= DVS_FORMAT_YUV422 | DVS_YUV_ORDER_YVYU;
+		break;
+	case V4L2_PIX_FMT_UYVY:
+		dvscntr |= DVS_FORMAT_YUV422 | DVS_YUV_ORDER_UYVY;
+		break;
+	case V4L2_PIX_FMT_VYUY:
+		dvscntr |= DVS_FORMAT_YUV422 | DVS_YUV_ORDER_VYUY;
+		break;
+	default:
+		ret = -EINVAL;
+		DRM_DEBUG_KMS("bad pixel format\n");
+		goto out_unlock;
+	}
+
+	if (obj->tiling_mode != I915_TILING_X) {
+		DRM_DEBUG_KMS("plane surfaces must be X tiled\n");
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	dvscntr |= DVS_TILED;
+
+	/* must disable */
+	dvscntr |= DVS_TRICKLE_FEED_DISABLE;
+	dvscntr |= DVS_DEST_KEY;
+	dvscntr |= DVS_ENABLE;
+
+	start = obj->gtt_offset;
+	offset = y * fb->pitch + x * (fb->bits_per_pixel / 8);
+
+	I915_WRITE(DVSSTRIDE(pipe), fb->pitch);
+	I915_WRITE(DVSPOS(pipe), (crtc_y << 16) | crtc_x);
+	I915_WRITE(DVSTILEOFF(pipe), (y << 16) | x);
+	I915_WRITE(DVSSIZE(pipe), (fb->height << 16) | fb->width);
+	I915_WRITE(DVSSCALE(pipe), 0);
+	I915_WRITE(reg, dvscntr);
+	I915_WRITE(DVSSURF(pipe), start);
+	POSTING_READ(DVSSURF(pipe));
+
+	/* Unpin old obj after new one is active to avoid ugliness */
+	if (old_obj) {
+		intel_wait_for_vblank(dev, to_intel_crtc(crtc)->pipe);
+		i915_gem_object_unpin(old_obj);
+	}
+
+out_unlock:
+	mutex_unlock(&dev->struct_mutex);
+
+	return ret;
+}
+
+static void
+intel_disable_plane(struct drm_plane *plane)
+{
+	struct drm_device *dev = plane->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_plane *intel_plane = to_intel_plane(plane);
+	int pipe = intel_plane->pipe;
+
+	I915_WRITE(DVSCNTR(pipe), I915_READ(DVSCNTR(pipe)) & ~DVS_ENABLE);
+	I915_WRITE(DVSSURF(pipe), 0);
+	POSTING_READ(DVSSURF(pipe));
+}
+
+static const struct drm_plane_funcs intel_plane_funcs = {
+	.update_plane = intel_update_plane,
+	.disable_plane = intel_disable_plane,
+};
+
+static uint32_t snb_plane_formats[] = {
+	V4L2_PIX_FMT_BGR32,
+	V4L2_PIX_FMT_RGB32,
+	V4L2_PIX_FMT_YUYV,
+	V4L2_PIX_FMT_YVYU,
+	V4L2_PIX_FMT_UYVY,
+	V4L2_PIX_FMT_VYUY,
+};
+
+void
+intel_plane_init(struct drm_device *dev, enum pipe pipe)
+{
+	struct intel_plane *intel_plane;
+	unsigned long possible_crtcs;
+
+	if (!IS_GEN6(dev)) {
+		DRM_ERROR("new plane code only for SNB\n");
+		return;
+	}
+
+	intel_plane = kzalloc(sizeof(struct intel_plane), GFP_KERNEL);
+	if (!intel_plane)
+		return;
+
+	intel_plane->pipe = pipe;
+	possible_crtcs = (1 << pipe);
+	drm_plane_init(dev, &intel_plane->base, possible_crtcs,
+		       &intel_plane_funcs, snb_plane_formats,
+		       ARRAY_SIZE(snb_plane_formats));
+}
+
-- 
1.7.4.1



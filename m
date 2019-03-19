Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB78C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FCD52085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfCSV6N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:13 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:35761 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfCSV6M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:12 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 8C5201BF208;
        Tue, 19 Mar 2019 21:58:05 +0000 (UTC)
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
Subject: [RFC PATCH 07/20] drm/fb: Move from drm_format_info to image_format_info
Date:   Tue, 19 Mar 2019 22:57:12 +0100
Message-Id: <f10708c5de8cb98c861c23c22a26bb9553d601cd.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Start converting the DRM drivers by changing the struct drm_framebuffer
structure to hold a pointer to image_format_info instead, and converting
everyone that depends on it.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/Kconfig                         |  1 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c          |  4 ++--
 drivers/gpu/drm/arm/malidp_drv.c                |  2 +-
 drivers/gpu/drm/arm/malidp_planes.c             |  8 ++++----
 drivers/gpu/drm/armada/armada_fb.c              |  2 +-
 drivers/gpu/drm/armada/armada_overlay.c         |  3 ++-
 drivers/gpu/drm/armada/armada_plane.c           |  3 ++-
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c |  4 +++-
 drivers/gpu/drm/bochs/bochs.h                   |  4 +++-
 drivers/gpu/drm/bochs/bochs_hw.c                |  3 ++-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c           |  4 ++--
 drivers/gpu/drm/cirrus/cirrus_main.c            |  4 ++--
 drivers/gpu/drm/drm_atomic.c                    |  1 +-
 drivers/gpu/drm/drm_client.c                    |  1 +-
 drivers/gpu/drm/drm_crtc.c                      |  1 +-
 drivers/gpu/drm/drm_fb_cma_helper.c             |  5 +++--
 drivers/gpu/drm/drm_fb_helper.c                 | 15 +++++++-------
 drivers/gpu/drm/drm_fourcc.c                    |  8 ++++----
 drivers/gpu/drm/drm_framebuffer.c               | 11 +++++-----
 drivers/gpu/drm/drm_gem_framebuffer_helper.c    |  5 +++--
 drivers/gpu/drm/drm_plane.c                     |  1 +-
 drivers/gpu/drm/exynos/exynos_drm_fb.c          |  3 ++-
 drivers/gpu/drm/gma500/framebuffer.c            |  2 +-
 drivers/gpu/drm/i915/i915_drv.h                 |  6 ++++--
 drivers/gpu/drm/i915/intel_display.c            | 11 +++++-----
 drivers/gpu/drm/imx/ipuv3-plane.c               |  5 +++--
 drivers/gpu/drm/mediatek/mtk_drm_fb.c           |  4 ++--
 drivers/gpu/drm/meson/meson_overlay.c           | 12 +++++------
 drivers/gpu/drm/msm/msm_fb.c                    |  8 ++++----
 drivers/gpu/drm/omapdrm/omap_fb.c               |  6 +++---
 drivers/gpu/drm/radeon/radeon_fb.c              |  4 ++--
 drivers/gpu/drm/rockchip/rockchip_drm_fb.c      |  4 ++--
 drivers/gpu/drm/stm/ltdc.c                      |  2 +-
 drivers/gpu/drm/sun4i/sun4i_backend.c           |  7 ++++---
 drivers/gpu/drm/sun4i/sun4i_frontend.c          | 19 +++++++++---------
 drivers/gpu/drm/sun4i/sun8i_ui_layer.c          |  2 ++-
 drivers/gpu/drm/sun4i/sun8i_vi_layer.c          |  6 ++++--
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.c         |  6 ++++--
 drivers/gpu/drm/sun4i/sun8i_vi_scaler.h         |  5 +++--
 drivers/gpu/drm/tegra/fb.c                      |  2 +-
 drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c  |  2 +-
 drivers/gpu/drm/zte/zx_plane.c                  |  2 +-
 include/drm/drm_fourcc.h                        |  4 +++-
 include/drm/drm_framebuffer.h                   |  3 ++-
 include/drm/drm_mode_config.h                   |  4 ++--
 45 files changed, 126 insertions(+), 93 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index bd943a71756c..7992a95ea965 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -12,6 +12,7 @@ menuconfig DRM
 	select FB_CMDLINE
 	select I2C
 	select I2C_ALGOBIT
+	select IMAGE_FORMATS
 	select DMA_SHARED_BUFFER
 	select SYNC_FILE
 	help
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index 48170a843b48..2d2e091da19b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -123,8 +123,8 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 					 struct drm_mode_fb_cmd2 *mode_cmd,
 					 struct drm_gem_object **gobj_p)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct amdgpu_device *adev = rfbdev->adev;
 	struct drm_gem_object *gobj = NULL;
 	struct amdgpu_bo *abo = NULL;
diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index ab50ad06e271..fec4fe15a71b 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -264,7 +264,7 @@ static bool
 malidp_verify_afbc_framebuffer_caps(struct drm_device *dev,
 				    const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 
 	if ((mode_cmd->modifier[0] >> 56) != DRM_FORMAT_MOD_VENDOR_ARM) {
 		DRM_DEBUG_KMS("Unknown modifier (not Arm)\n");
diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index c9a6d3e0cada..6d2dad4642be 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -415,7 +415,7 @@ static int malidp_de_plane_check(struct drm_plane *plane,
 	for (i = 0; i < ms->n_planes; i++) {
 		u8 alignment = malidp_hw_get_pitch_align(mp->hwdev, rotated);
 
-		if ((fb->pitches[i] * drm_format_info_block_height(fb->format, i))
+		if ((fb->pitches[i] * image_format_block_height(fb->format, i))
 				& (alignment - 1)) {
 			DRM_DEBUG_KMS("Invalid pitch %u for plane %d\n",
 				      fb->pitches[i], i);
@@ -423,8 +423,8 @@ static int malidp_de_plane_check(struct drm_plane *plane,
 		}
 	}
 
-	block_w = drm_format_info_block_width(fb->format, 0);
-	block_h = drm_format_info_block_height(fb->format, 0);
+	block_w = image_format_block_width(fb->format, 0);
+	block_h = image_format_block_height(fb->format, 0);
 	if (fb->width % block_w || fb->height % block_h) {
 		DRM_DEBUG_KMS("Buffer width/height needs to be a multiple of tile sizes");
 		return -EINVAL;
@@ -512,7 +512,7 @@ static void malidp_de_set_plane_pitches(struct malidp_plane *mp,
 	 * in a tile.
 	 */
 	for (i = 0; i < num_strides; ++i) {
-		unsigned int block_h = drm_format_info_block_height(mp->base.state->fb->format, i);
+		unsigned int block_h = image_format_block_height(mp->base.state->fb->format, i);
 
 		malidp_hw_write(mp->hwdev, pitches[i] * block_h,
 				mp->layer->base +
diff --git a/drivers/gpu/drm/armada/armada_fb.c b/drivers/gpu/drm/armada/armada_fb.c
index a2f6472eb482..10e9ab534658 100644
--- a/drivers/gpu/drm/armada/armada_fb.c
+++ b/drivers/gpu/drm/armada/armada_fb.c
@@ -87,7 +87,7 @@ struct armada_framebuffer *armada_framebuffer_create(struct drm_device *dev,
 struct drm_framebuffer *armada_fb_create(struct drm_device *dev,
 	struct drm_file *dfile, const struct drm_mode_fb_cmd2 *mode)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev, mode);
+	const struct image_format_info *info = drm_get_format_info(dev, mode);
 	struct armada_gem_object *obj;
 	struct armada_framebuffer *dfb;
 	int ret;
diff --git a/drivers/gpu/drm/armada/armada_overlay.c b/drivers/gpu/drm/armada/armada_overlay.c
index 8d770641fcc4..8574fa02879d 100644
--- a/drivers/gpu/drm/armada/armada_overlay.c
+++ b/drivers/gpu/drm/armada/armada_overlay.c
@@ -12,6 +12,7 @@
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
 #include <drm/armada_drm.h>
+#include <linux/image-formats.h>
 #include "armada_crtc.h"
 #include "armada_drm.h"
 #include "armada_fb.h"
@@ -107,7 +108,7 @@ static void armada_drm_overlay_plane_atomic_update(struct drm_plane *plane,
 	if (old_state->src.x1 != state->src.x1 ||
 	    old_state->src.y1 != state->src.y1 ||
 	    old_state->fb != state->fb) {
-		const struct drm_format_info *format;
+		const struct image_format_info *format;
 		u16 src_x, pitches[3];
 		u32 addrs[2][3];
 
diff --git a/drivers/gpu/drm/armada/armada_plane.c b/drivers/gpu/drm/armada/armada_plane.c
index 9f36423dd394..91cf01317098 100644
--- a/drivers/gpu/drm/armada/armada_plane.c
+++ b/drivers/gpu/drm/armada/armada_plane.c
@@ -10,6 +10,7 @@
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
+#include <linux/image-formats.h>
 #include "armada_crtc.h"
 #include "armada_drm.h"
 #include "armada_fb.h"
@@ -39,7 +40,7 @@ void armada_drm_plane_calc(struct drm_plane_state *state, u32 addrs[2][3],
 	u16 pitches[3], bool interlaced)
 {
 	struct drm_framebuffer *fb = state->fb;
-	const struct drm_format_info *format = fb->format;
+	const struct image_format_info *format = fb->format;
 	unsigned int num_planes = format->num_planes;
 	unsigned int x = state->src.x1 >> 16;
 	unsigned int y = state->src.y1 >> 16;
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index fdd607ad27fe..550a47c09408 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -17,6 +17,8 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/image-formats.h>
+
 #include "atmel_hlcdc_dc.h"
 
 /**
@@ -360,7 +362,7 @@ atmel_hlcdc_plane_update_general_settings(struct atmel_hlcdc_plane *plane,
 {
 	unsigned int cfg = ATMEL_HLCDC_LAYER_DMA_BLEN_INCR16 | state->ahb_id;
 	const struct atmel_hlcdc_layer_desc *desc = plane->layer.desc;
-	const struct drm_format_info *format = state->base.fb->format;
+	const struct image_format_info *format = state->base.fb->format;
 
 	/*
 	 * Rotation optimization is not working on RGB888 (rotation is still
diff --git a/drivers/gpu/drm/bochs/bochs.h b/drivers/gpu/drm/bochs/bochs.h
index 03711394f1ed..7dbcf664c0f1 100644
--- a/drivers/gpu/drm/bochs/bochs.h
+++ b/drivers/gpu/drm/bochs/bochs.h
@@ -110,6 +110,8 @@ static inline u64 bochs_bo_mmap_offset(struct bochs_bo *bo)
 
 /* ---------------------------------------------------------------------- */
 
+struct image_format_info;
+
 /* bochs_hw.c */
 int bochs_hw_init(struct drm_device *dev);
 void bochs_hw_fini(struct drm_device *dev);
@@ -117,7 +119,7 @@ void bochs_hw_fini(struct drm_device *dev);
 void bochs_hw_setmode(struct bochs_device *bochs,
 		      struct drm_display_mode *mode);
 void bochs_hw_setformat(struct bochs_device *bochs,
-			const struct drm_format_info *format);
+			const struct image_format_info *format);
 void bochs_hw_setbase(struct bochs_device *bochs,
 		      int x, int y, u64 addr);
 int bochs_hw_load_edid(struct bochs_device *bochs);
diff --git a/drivers/gpu/drm/bochs/bochs_hw.c b/drivers/gpu/drm/bochs/bochs_hw.c
index 3e04b2f0ec08..8f6a04b2d373 100644
--- a/drivers/gpu/drm/bochs/bochs_hw.c
+++ b/drivers/gpu/drm/bochs/bochs_hw.c
@@ -5,6 +5,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/image-formats.h>
 #include "bochs.h"
 
 /* ---------------------------------------------------------------------- */
@@ -234,7 +235,7 @@ void bochs_hw_setmode(struct bochs_device *bochs,
 }
 
 void bochs_hw_setformat(struct bochs_device *bochs,
-			const struct drm_format_info *format)
+			const struct image_format_info *format)
 {
 	DRM_DEBUG_DRIVER("format %c%c%c%c\n",
 			 (format->format >>  0) & 0xff,
diff --git a/drivers/gpu/drm/cirrus/cirrus_fbdev.c b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
index 759847bafda8..a0bef1337761 100644
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -137,8 +137,8 @@ static int cirrusfb_create_object(struct cirrus_fbdev *afbdev,
 			       const struct drm_mode_fb_cmd2 *mode_cmd,
 			       struct drm_gem_object **gobj_p)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct drm_device *dev = afbdev->helper.dev;
 	struct cirrus_device *cdev = dev->dev_private;
 	u32 bpp;
diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c b/drivers/gpu/drm/cirrus/cirrus_main.c
index 66d0d2c5211d..8afc6a351ecd 100644
--- a/drivers/gpu/drm/cirrus/cirrus_main.c
+++ b/drivers/gpu/drm/cirrus/cirrus_main.c
@@ -41,8 +41,8 @@ cirrus_user_framebuffer_create(struct drm_device *dev,
 			       struct drm_file *filp,
 			       const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct cirrus_device *cdev = dev->dev_private;
 	struct drm_gem_object *obj;
 	struct drm_framebuffer *fb;
diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
index 5eb40130fafb..6a0aff2bd7f4 100644
--- a/drivers/gpu/drm/drm_atomic.c
+++ b/drivers/gpu/drm/drm_atomic.c
@@ -32,6 +32,7 @@
 #include <drm/drm_mode.h>
 #include <drm/drm_print.h>
 #include <drm/drm_writeback.h>
+#include <linux/image-formats.h>
 #include <linux/sync_file.h>
 
 #include "drm_crtc_internal.h"
diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 305d6dd5d201..9df52b7fd074 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -3,6 +3,7 @@
  * Copyright 2018 Noralf Trønnes
  */
 
+#include <linux/image-formats.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 7dabbaf033a1..2a6d811b19df 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -30,6 +30,7 @@
  *      Jesse Barnes <jesse.barnes@intel.com>
  */
 #include <linux/ctype.h>
+#include <linux/image-formats.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/export.h>
diff --git a/drivers/gpu/drm/drm_fb_cma_helper.c b/drivers/gpu/drm/drm_fb_cma_helper.c
index 5f8074ffe7d9..f6573a3ee90b 100644
--- a/drivers/gpu/drm/drm_fb_cma_helper.c
+++ b/drivers/gpu/drm/drm_fb_cma_helper.c
@@ -22,6 +22,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_plane.h>
+#include <linux/image-formats.h>
 #include <linux/module.h>
 
 /**
@@ -74,8 +75,8 @@ dma_addr_t drm_fb_cma_get_gem_addr(struct drm_framebuffer *fb,
 	struct drm_gem_cma_object *obj;
 	dma_addr_t paddr;
 	u8 h_div = 1, v_div = 1;
-	u32 block_w = drm_format_info_block_width(fb->format, plane);
-	u32 block_h = drm_format_info_block_height(fb->format, plane);
+	u32 block_w = image_format_block_width(fb->format, plane);
+	u32 block_h = image_format_block_height(fb->format, plane);
 	u32 block_size = fb->format->char_per_block[plane];
 	u32 sample_x;
 	u32 sample_y;
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 257a9c995057..c91200af3fdd 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -31,6 +31,7 @@
 
 #include <linux/console.h>
 #include <linux/dma-buf.h>
+#include <linux/image-formats.h>
 #include <linux/kernel.h>
 #include <linux/sysrq.h>
 #include <linux/slab.h>
@@ -768,7 +769,7 @@ static void drm_fb_helper_dirty_blit_real(struct drm_fb_helper *fb_helper,
 					  struct drm_clip_rect *clip)
 {
 	struct drm_framebuffer *fb = fb_helper->fb;
-	unsigned int cpp = drm_format_plane_cpp(fb->format, 0);
+	unsigned int cpp = image_format_plane_cpp(fb->format, 0);
 	size_t offset = clip->y1 * fb->pitches[0] + clip->x1 * cpp;
 	void *src = fb_helper->fbdev->screen_buffer + offset;
 	void *dst = fb_helper->buffer->vaddr + offset;
@@ -1698,8 +1699,8 @@ int drm_fb_helper_check_var(struct fb_var_screeninfo *var,
 		var->pixclock = 0;
 	}
 
-	if ((drm_format_info_block_width(fb->format, 0) > 1) ||
-	    (drm_format_info_block_height(fb->format, 0) > 1))
+	if ((image_format_block_width(fb->format, 0) > 1) ||
+	    (image_format_block_height(fb->format, 0) > 1))
 		return -EINVAL;
 
 	/*
@@ -1934,9 +1935,9 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 		DRM_DEBUG("test CRTC %d primary plane\n", i);
 
 		for (j = 0; j < plane->format_count; j++) {
-			const struct drm_format_info *fmt;
+			const struct image_format_info *fmt;
 
-			fmt = drm_format_info(plane->format_types[j]);
+			fmt = image_format_drm_lookup(plane->format_types[j]);
 
 			/*
 			 * Do not consider YUV or other complicated formats
@@ -2086,8 +2087,8 @@ void drm_fb_helper_fill_var(struct fb_info *info, struct drm_fb_helper *fb_helpe
 {
 	struct drm_framebuffer *fb = fb_helper->fb;
 
-	WARN_ON((drm_format_info_block_width(fb->format, 0) > 1) ||
-		(drm_format_info_block_height(fb->format, 0) > 1));
+	WARN_ON((image_format_block_width(fb->format, 0) > 1) ||
+		(image_format_block_height(fb->format, 0) > 1));
 	info->pseudo_palette = fb_helper->pseudo_palette;
 	info->var.xres_virtual = fb->width;
 	info->var.yres_virtual = fb->height;
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 57389b9753b2..6ddb1c28be49 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -286,20 +286,20 @@ EXPORT_SYMBOL(drm_format_info);
  * @mode_cmd: metadata from the userspace fb creation request
  *
  * Returns:
- * The instance of struct drm_format_info that describes the pixel format, or
+ * The instance of struct image_format_info that describes the pixel format, or
  * NULL if the format is unsupported.
  */
-const struct drm_format_info *
+const struct image_format_info *
 drm_get_format_info(struct drm_device *dev,
 		    const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = NULL;
+	const struct image_format_info *info = NULL;
 
 	if (dev->mode_config.funcs->get_format_info)
 		info = dev->mode_config.funcs->get_format_info(mode_cmd);
 
 	if (!info)
-		info = drm_format_info(mode_cmd->pixel_format);
+		info = image_format_drm_lookup(mode_cmd->pixel_format);
 
 	return info;
 }
diff --git a/drivers/gpu/drm/drm_framebuffer.c b/drivers/gpu/drm/drm_framebuffer.c
index d8d75e25f6fb..90c77a6633be 100644
--- a/drivers/gpu/drm/drm_framebuffer.c
+++ b/drivers/gpu/drm/drm_framebuffer.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/image-formats.h>
 #include <drm/drmP.h>
 #include <drm/drm_auth.h>
 #include <drm/drm_framebuffer.h>
@@ -146,7 +147,7 @@ int drm_mode_addfb_ioctl(struct drm_device *dev,
 }
 
 static int fb_plane_width(int width,
-			  const struct drm_format_info *format, int plane)
+			  const struct image_format_info *format, int plane)
 {
 	if (plane == 0)
 		return width;
@@ -155,7 +156,7 @@ static int fb_plane_width(int width,
 }
 
 static int fb_plane_height(int height,
-			   const struct drm_format_info *format, int plane)
+			   const struct image_format_info *format, int plane)
 {
 	if (plane == 0)
 		return height;
@@ -166,11 +167,11 @@ static int fb_plane_height(int height,
 static int framebuffer_check(struct drm_device *dev,
 			     const struct drm_mode_fb_cmd2 *r)
 {
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	int i;
 
 	/* check if the format is supported at all */
-	info = __drm_format_info(r->pixel_format);
+	info = __image_format_drm_lookup(r->pixel_format);
 	if (!info) {
 		struct drm_format_name_buf format_name;
 
@@ -197,7 +198,7 @@ static int framebuffer_check(struct drm_device *dev,
 		unsigned int width = fb_plane_width(r->width, info, i);
 		unsigned int height = fb_plane_height(r->height, info, i);
 		unsigned int block_size = info->char_per_block[i];
-		u64 min_pitch = drm_format_info_min_pitch(info, i, width);
+		u64 min_pitch = image_format_min_pitch(info, i, width);
 
 		if (!block_size && (r->modifier[i] == DRM_FORMAT_MOD_LINEAR)) {
 			DRM_DEBUG_KMS("Format requires non-linear modifier for plane %d\n", i);
diff --git a/drivers/gpu/drm/drm_gem_framebuffer_helper.c b/drivers/gpu/drm/drm_gem_framebuffer_helper.c
index 65edb1ccb185..a2a01afeba3e 100644
--- a/drivers/gpu/drm/drm_gem_framebuffer_helper.c
+++ b/drivers/gpu/drm/drm_gem_framebuffer_helper.c
@@ -11,6 +11,7 @@
 
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
+#include <linux/image-formats.h>
 #include <linux/reservation.h>
 #include <linux/slab.h>
 
@@ -149,7 +150,7 @@ drm_gem_fb_create_with_funcs(struct drm_device *dev, struct drm_file *file,
 			     const struct drm_mode_fb_cmd2 *mode_cmd,
 			     const struct drm_framebuffer_funcs *funcs)
 {
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	struct drm_gem_object *objs[4];
 	struct drm_framebuffer *fb;
 	int ret, i;
@@ -171,7 +172,7 @@ drm_gem_fb_create_with_funcs(struct drm_device *dev, struct drm_file *file,
 		}
 
 		min_size = (height - 1) * mode_cmd->pitches[i]
-			 + drm_format_info_min_pitch(info, i, width)
+			 + image_format_min_pitch(info, i, width)
 			 + mode_cmd->offsets[i];
 
 		if (objs[i]->size < min_size) {
diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.c
index 4cfb56893b7f..b67be56e71cc 100644
--- a/drivers/gpu/drm/drm_plane.c
+++ b/drivers/gpu/drm/drm_plane.c
@@ -20,6 +20,7 @@
  * OF THIS SOFTWARE.
  */
 
+#include <linux/image-formats.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_fb.c b/drivers/gpu/drm/exynos/exynos_drm_fb.c
index 1f11ab0f8e9d..be41d986e481 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_fb.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_fb.c
@@ -19,6 +19,7 @@
 #include <drm/drm_fb_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_probe_helper.h>
+#include <linux/image-formats.h>
 #include <uapi/drm/exynos_drm.h>
 
 #include "exynos_drm_drv.h"
@@ -98,7 +99,7 @@ static struct drm_framebuffer *
 exynos_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
 		      const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev, mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev, mode_cmd);
 	struct exynos_drm_gem *exynos_gem[MAX_FB_BUFFER];
 	struct drm_framebuffer *fb;
 	int i;
diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 46f0078f7a91..f160e3c257c1 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -225,7 +225,7 @@ static int psb_framebuffer_init(struct drm_device *dev,
 					const struct drm_mode_fb_cmd2 *mode_cmd,
 					struct gtt_range *gt)
 {
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	int ret;
 
 	/*
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 9adc7bb9e69c..6a085185e7fc 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -379,6 +379,8 @@ enum fb_op_origin {
 	ORIGIN_DIRTYFB,
 };
 
+struct image_format_info;
+
 struct intel_fbc {
 	/* This is always the inner lock when overlapping with struct_mutex and
 	 * it's the outer lock when overlapping with stolen_lock. */
@@ -435,7 +437,7 @@ struct intel_fbc {
 		} plane;
 
 		struct {
-			const struct drm_format_info *format;
+			const struct image_format_info *format;
 			unsigned int stride;
 		} fb;
 	} state_cache;
@@ -458,7 +460,7 @@ struct intel_fbc {
 		} crtc;
 
 		struct {
-			const struct drm_format_info *format;
+			const struct image_format_info *format;
 			unsigned int stride;
 		} fb;
 
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index ccb616351bba..86febe2ee510 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/image-formats.h>
 #include <linux/input.h>
 #include <linux/intel-iommu.h>
 #include <linux/kernel.h>
@@ -2443,15 +2444,15 @@ static unsigned int intel_fb_modifier_to_tiling(u64 fb_modifier)
  * us a ratio of one byte in the CCS for each 8x16 pixels in the
  * main surface.
  */
-static const struct drm_format_info ccs_formats[] = {
+static const struct image_format_info ccs_formats[] = {
 	{ .format = DRM_FORMAT_XRGB8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
 	{ .format = DRM_FORMAT_XBGR8888, .depth = 24, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
 	{ .format = DRM_FORMAT_ARGB8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
 	{ .format = DRM_FORMAT_ABGR8888, .depth = 32, .num_planes = 2, .cpp = { 4, 1, }, .hsub = 8, .vsub = 16, },
 };
 
-static const struct drm_format_info *
-lookup_format_info(const struct drm_format_info formats[],
+static const struct image_format_info *
+lookup_format_info(const struct image_format_info formats[],
 		   int num_formats, u32 format)
 {
 	int i;
@@ -2464,7 +2465,7 @@ lookup_format_info(const struct drm_format_info formats[],
 	return NULL;
 }
 
-static const struct drm_format_info *
+static const struct image_format_info *
 intel_get_format_info(const struct drm_mode_fb_cmd2 *cmd)
 {
 	switch (cmd->modifier[0]) {
@@ -4982,7 +4983,7 @@ static int
 skl_update_scaler(struct intel_crtc_state *crtc_state, bool force_detach,
 		  unsigned int scaler_user, int *scaler_id,
 		  int src_w, int src_h, int dst_w, int dst_h,
-		  const struct drm_format_info *format, bool need_scaler)
+		  const struct image_format_info *format, bool need_scaler)
 {
 	struct intel_crtc_scaler_state *scaler_state =
 		&crtc_state->scaler_state;
diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index 2530143281b2..6bbacba90661 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -12,6 +12,7 @@
 #include <drm/drm_gem_cma_helper.h>
 #include <drm/drm_gem_framebuffer_helper.h>
 #include <drm/drm_plane_helper.h>
+#include <linux/image-formats.h>
 
 #include "video/imx-ipu-v3.h"
 #include "imx-drm.h"
@@ -549,7 +550,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 	unsigned long alpha_eba = 0;
 	enum ipu_color_space ics;
 	unsigned int axi_id = 0;
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	u8 burstsize, num_bursts;
 	u32 width, height;
 	int active;
@@ -626,7 +627,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 
 	width = drm_rect_width(&state->src) >> 16;
 	height = drm_rect_height(&state->src) >> 16;
-	info = drm_format_info(fb->format->format);
+	info = fb->format;
 	ipu_calculate_bursts(width, info->cpp[0], fb->pitches[0],
 			     &burstsize, &num_bursts);
 
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_fb.c b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
index af90c84e9e02..ee71d96dc0cd 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_fb.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_fb.c
@@ -32,7 +32,7 @@ static struct drm_framebuffer *mtk_drm_framebuffer_init(struct drm_device *dev,
 					const struct drm_mode_fb_cmd2 *mode,
 					struct drm_gem_object *obj)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev, mode);
+	const struct image_format_info *info = drm_get_format_info(dev, mode);
 	struct drm_framebuffer *fb;
 	int ret;
 
@@ -89,7 +89,7 @@ struct drm_framebuffer *mtk_drm_mode_fb_create(struct drm_device *dev,
 					       struct drm_file *file,
 					       const struct drm_mode_fb_cmd2 *cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev, cmd);
+	const struct image_format_info *info = drm_get_format_info(dev, cmd);
 	struct drm_framebuffer *fb;
 	struct drm_gem_object *gem;
 	unsigned int width = cmd->width;
diff --git a/drivers/gpu/drm/meson/meson_overlay.c b/drivers/gpu/drm/meson/meson_overlay.c
index 6987c15b6ab9..b84187da6426 100644
--- a/drivers/gpu/drm/meson/meson_overlay.c
+++ b/drivers/gpu/drm/meson/meson_overlay.c
@@ -474,8 +474,8 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
 		priv->viu.vd1_addr2 = gem->paddr + fb->offsets[2];
 		priv->viu.vd1_stride2 = fb->pitches[2];
 		priv->viu.vd1_height2 =
-			drm_format_plane_height(fb->height,
-						fb->format, 2);
+			image_format_plane_height(fb->height,
+						  fb->format, 2);
 		DRM_DEBUG("plane 2 addr 0x%x stride %d height %d\n",
 			 priv->viu.vd1_addr2,
 			 priv->viu.vd1_stride2,
@@ -486,8 +486,8 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
 		priv->viu.vd1_addr1 = gem->paddr + fb->offsets[1];
 		priv->viu.vd1_stride1 = fb->pitches[1];
 		priv->viu.vd1_height1 =
-			drm_format_plane_height(fb->height,
-						fb->format, 1);
+			image_format_plane_height(fb->height,
+						  fb->format, 1);
 		DRM_DEBUG("plane 1 addr 0x%x stride %d height %d\n",
 			 priv->viu.vd1_addr1,
 			 priv->viu.vd1_stride1,
@@ -498,8 +498,8 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
 		priv->viu.vd1_addr0 = gem->paddr + fb->offsets[0];
 		priv->viu.vd1_stride0 = fb->pitches[0];
 		priv->viu.vd1_height0 =
-			drm_format_plane_height(fb->height,
-						fb->format, 0);
+			image_format_plane_height(fb->height,
+						  fb->format, 0);
 		DRM_DEBUG("plane 0 addr 0x%x stride %d height %d\n",
 			 priv->viu.vd1_addr0,
 			 priv->viu.vd1_stride0,
diff --git a/drivers/gpu/drm/msm/msm_fb.c b/drivers/gpu/drm/msm/msm_fb.c
index ee91058c7974..296fb89cdbd0 100644
--- a/drivers/gpu/drm/msm/msm_fb.c
+++ b/drivers/gpu/drm/msm/msm_fb.c
@@ -106,8 +106,8 @@ const struct msm_format *msm_framebuffer_format(struct drm_framebuffer *fb)
 struct drm_framebuffer *msm_framebuffer_create(struct drm_device *dev,
 		struct drm_file *file, const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct drm_gem_object *bos[4] = {0};
 	struct drm_framebuffer *fb;
 	int ret, i, n = info->num_planes;
@@ -137,8 +137,8 @@ struct drm_framebuffer *msm_framebuffer_create(struct drm_device *dev,
 static struct drm_framebuffer *msm_framebuffer_init(struct drm_device *dev,
 		const struct drm_mode_fb_cmd2 *mode_cmd, struct drm_gem_object **bos)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct msm_drm_private *priv = dev->dev_private;
 	struct msm_kms *kms = priv->kms;
 	struct msm_framebuffer *msm_fb = NULL;
diff --git a/drivers/gpu/drm/omapdrm/omap_fb.c b/drivers/gpu/drm/omapdrm/omap_fb.c
index 6557b2d6e16e..1d4143adf829 100644
--- a/drivers/gpu/drm/omapdrm/omap_fb.c
+++ b/drivers/gpu/drm/omapdrm/omap_fb.c
@@ -298,8 +298,8 @@ void omap_framebuffer_describe(struct drm_framebuffer *fb, struct seq_file *m)
 struct drm_framebuffer *omap_framebuffer_create(struct drm_device *dev,
 		struct drm_file *file, const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	unsigned int num_planes = info->num_planes;
 	struct drm_gem_object *bos[4];
 	struct drm_framebuffer *fb;
@@ -329,7 +329,7 @@ struct drm_framebuffer *omap_framebuffer_create(struct drm_device *dev,
 struct drm_framebuffer *omap_framebuffer_init(struct drm_device *dev,
 		const struct drm_mode_fb_cmd2 *mode_cmd, struct drm_gem_object **bos)
 {
-	const struct drm_format_info *format = NULL;
+	const struct image_format_info *format = NULL;
 	struct omap_framebuffer *omap_fb = NULL;
 	struct drm_framebuffer *fb = NULL;
 	unsigned int pitch = mode_cmd->pitches[0];
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index 88fc1a6e2e43..4c50166546ca 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -125,8 +125,8 @@ static int radeonfb_create_pinned_object(struct radeon_fbdev *rfbdev,
 					 struct drm_mode_fb_cmd2 *mode_cmd,
 					 struct drm_gem_object **gobj_p)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct radeon_device *rdev = rfbdev->rdev;
 	struct drm_gem_object *gobj = NULL;
 	struct radeon_bo *rbo = NULL;
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
index c602cb2f4d3c..abb6783eb38e 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_fb.c
@@ -74,8 +74,8 @@ static struct drm_framebuffer *
 rockchip_user_fb_create(struct drm_device *dev, struct drm_file *file_priv,
 			const struct drm_mode_fb_cmd2 *mode_cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev,
-								 mode_cmd);
+	const struct image_format_info *info = drm_get_format_info(dev,
+								   mode_cmd);
 	struct drm_framebuffer *fb;
 	struct drm_gem_object *objs[ROCKCHIP_MAX_FB_BUFFER];
 	struct drm_gem_object *obj;
diff --git a/drivers/gpu/drm/stm/ltdc.c b/drivers/gpu/drm/stm/ltdc.c
index b226df7dbf6f..6afd8dcb3fd9 100644
--- a/drivers/gpu/drm/stm/ltdc.c
+++ b/drivers/gpu/drm/stm/ltdc.c
@@ -779,7 +779,7 @@ static void ltdc_plane_atomic_update(struct drm_plane *plane,
 
 	/* Configures the color frame buffer pitch in bytes & line length */
 	pitch_in_bytes = fb->pitches[0];
-	line_length = drm_format_plane_cpp(fb->format, 0) *
+	line_length = image_format_plane_cpp(fb->format, 0) *
 		      (x1 - x0 + 1) + (ldev->caps.bus_width >> 3) - 1;
 	val = ((pitch_in_bytes << 16) | line_length);
 	reg_update_bits(ldev->regs, LTDC_L1CFBLR + lofs,
diff --git a/drivers/gpu/drm/sun4i/sun4i_backend.c b/drivers/gpu/drm/sun4i/sun4i_backend.c
index 4c0d51f73237..f84c5edb234a 100644
--- a/drivers/gpu/drm/sun4i/sun4i_backend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_backend.c
@@ -20,6 +20,7 @@
 #include <drm/drm_probe_helper.h>
 
 #include <linux/component.h>
+#include <linux/image-formats.h>
 #include <linux/list.h>
 #include <linux/of_device.h>
 #include <linux/of_graph.h>
@@ -203,7 +204,7 @@ static int sun4i_backend_update_yuv_format(struct sun4i_backend *backend,
 {
 	struct drm_plane_state *state = plane->state;
 	struct drm_framebuffer *fb = state->fb;
-	const struct drm_format_info *format = fb->format;
+	const struct image_format_info *format = fb->format;
 	const uint32_t fmt = format->format;
 	u32 val = SUN4I_BACKEND_IYUVCTL_EN;
 	int i;
@@ -222,8 +223,8 @@ static int sun4i_backend_update_yuv_format(struct sun4i_backend *backend,
 			   SUN4I_BACKEND_ATTCTL_REG0_LAY_YUVEN);
 
 	/* TODO: Add support for the multi-planar YUV formats */
-	if (drm_format_info_is_yuv_packed(format) &&
-	    drm_format_info_is_yuv_sampling_422(format))
+	if (image_format_info_is_yuv_packed(format) &&
+	    image_format_info_is_yuv_sampling_422(format))
 		val |= SUN4I_BACKEND_IYUVCTL_FBFMT_PACKED_YUV422;
 	else
 		DRM_DEBUG_DRIVER("Unsupported YUV format (0x%x)\n", fmt);
diff --git a/drivers/gpu/drm/sun4i/sun4i_frontend.c b/drivers/gpu/drm/sun4i/sun4i_frontend.c
index 346c8071bd38..389637e9ec9d 100644
--- a/drivers/gpu/drm/sun4i/sun4i_frontend.c
+++ b/drivers/gpu/drm/sun4i/sun4i_frontend.c
@@ -9,6 +9,7 @@
 
 #include <linux/clk.h>
 #include <linux/component.h>
+#include <linux/image-formats.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
@@ -241,18 +242,18 @@ void sun4i_frontend_update_buffer(struct sun4i_frontend *frontend,
 EXPORT_SYMBOL(sun4i_frontend_update_buffer);
 
 static int
-sun4i_frontend_drm_format_to_input_fmt(const struct drm_format_info *format,
+sun4i_frontend_drm_format_to_input_fmt(const struct image_format_info *format,
 				       u32 *val)
 {
 	if (!format->is_yuv)
 		*val = SUN4I_FRONTEND_INPUT_FMT_DATA_FMT_RGB;
-	else if (drm_format_info_is_yuv_sampling_411(format))
+	else if (image_format_info_is_yuv_sampling_411(format))
 		*val = SUN4I_FRONTEND_INPUT_FMT_DATA_FMT_YUV411;
-	else if (drm_format_info_is_yuv_sampling_420(format))
+	else if (image_format_info_is_yuv_sampling_420(format))
 		*val = SUN4I_FRONTEND_INPUT_FMT_DATA_FMT_YUV420;
-	else if (drm_format_info_is_yuv_sampling_422(format))
+	else if (image_format_info_is_yuv_sampling_422(format))
 		*val = SUN4I_FRONTEND_INPUT_FMT_DATA_FMT_YUV422;
-	else if (drm_format_info_is_yuv_sampling_444(format))
+	else if (image_format_info_is_yuv_sampling_444(format))
 		*val = SUN4I_FRONTEND_INPUT_FMT_DATA_FMT_YUV444;
 	else
 		return -EINVAL;
@@ -261,7 +262,7 @@ sun4i_frontend_drm_format_to_input_fmt(const struct drm_format_info *format,
 }
 
 static int
-sun4i_frontend_drm_format_to_input_mode(const struct drm_format_info *format,
+sun4i_frontend_drm_format_to_input_mode(const struct image_format_info *format,
 					uint64_t modifier, u32 *val)
 {
 	bool tiled = (modifier == DRM_FORMAT_MOD_ALLWINNER_TILED);
@@ -287,11 +288,11 @@ sun4i_frontend_drm_format_to_input_mode(const struct drm_format_info *format,
 }
 
 static int
-sun4i_frontend_drm_format_to_input_sequence(const struct drm_format_info *format,
+sun4i_frontend_drm_format_to_input_sequence(const struct image_format_info *format,
 					    u32 *val)
 {
 	/* Planar formats have an explicit input sequence. */
-	if (drm_format_info_is_yuv_planar(format)) {
+	if (image_format_info_is_yuv_planar(format)) {
 		*val = 0;
 		return 0;
 	}
@@ -401,7 +402,7 @@ int sun4i_frontend_update_formats(struct sun4i_frontend *frontend,
 {
 	struct drm_plane_state *state = plane->state;
 	struct drm_framebuffer *fb = state->fb;
-	const struct drm_format_info *format = fb->format;
+	const struct image_format_info *format = fb->format;
 	uint64_t modifier = fb->modifier;
 	u32 out_fmt_val;
 	u32 in_fmt_val, in_mod_val, in_ps_val;
diff --git a/drivers/gpu/drm/sun4i/sun8i_ui_layer.c b/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
index a342ec8b131e..bbd4a2d34eb7 100644
--- a/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_ui_layer.c
@@ -23,6 +23,8 @@
 #include <drm/drm_probe_helper.h>
 #include <drm/drmP.h>
 
+#include <linux/image-formats.h>
+
 #include "sun8i_ui_layer.h"
 #include "sun8i_mixer.h"
 #include "sun8i_ui_scaler.h"
diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
index 8a0616238467..85b1b55ef342 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_layer.c
@@ -17,6 +17,8 @@
 #include <drm/drm_probe_helper.h>
 #include <drm/drmP.h>
 
+#include <linux/image-formats.h>
+
 #include "sun8i_vi_layer.h"
 #include "sun8i_mixer.h"
 #include "sun8i_vi_scaler.h"
@@ -75,7 +77,7 @@ static int sun8i_vi_layer_update_coord(struct sun8i_mixer *mixer, int channel,
 				       unsigned int zpos)
 {
 	struct drm_plane_state *state = plane->state;
-	const struct drm_format_info *format = state->fb->format;
+	const struct image_format_info *format = state->fb->format;
 	u32 src_w, src_h, dst_w, dst_h;
 	u32 bld_base, ch_base;
 	u32 outsize, insize;
@@ -219,7 +221,7 @@ static int sun8i_vi_layer_update_buffer(struct sun8i_mixer *mixer, int channel,
 {
 	struct drm_plane_state *state = plane->state;
 	struct drm_framebuffer *fb = state->fb;
-	const struct drm_format_info *format = fb->format;
+	const struct image_format_info *format = fb->format;
 	struct drm_gem_cma_object *gem;
 	u32 dx, dy, src_x, src_y;
 	dma_addr_t paddr;
diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
index 7ba75011adf9..1d22331af5fe 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.c
@@ -9,6 +9,8 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/image-formats.h>
+
 #include "sun8i_vi_scaler.h"
 
 static const u32 lan3coefftab32_left[480] = {
@@ -869,7 +871,7 @@ static int sun8i_vi_scaler_coef_index(unsigned int step)
 
 static void sun8i_vi_scaler_set_coeff(struct regmap *map, u32 base,
 				      u32 hstep, u32 vstep,
-				      const struct drm_format_info *format)
+				      const struct image_format_info *format)
 {
 	const u32 *ch_left, *ch_right, *cy;
 	int offset, i;
@@ -926,7 +928,7 @@ void sun8i_vi_scaler_enable(struct sun8i_mixer *mixer, int layer, bool enable)
 void sun8i_vi_scaler_setup(struct sun8i_mixer *mixer, int layer,
 			   u32 src_w, u32 src_h, u32 dst_w, u32 dst_h,
 			   u32 hscale, u32 vscale, u32 hphase, u32 vphase,
-			   const struct drm_format_info *format)
+			   const struct image_format_info *format)
 {
 	u32 chphase, cvphase;
 	u32 insize, outsize;
diff --git a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
index 68f6593b369a..878a689e532a 100644
--- a/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
+++ b/drivers/gpu/drm/sun4i/sun8i_vi_scaler.h
@@ -9,7 +9,6 @@
 #ifndef _SUN8I_VI_SCALER_H_
 #define _SUN8I_VI_SCALER_H_
 
-#include <drm/drm_fourcc.h>
 #include "sun8i_mixer.h"
 
 #define DE2_VI_SCALER_UNIT_BASE 0x20000
@@ -69,10 +68,12 @@
 #define SUN50I_SCALER_VSU_ANGLE_SHIFT(x)		(((x) << 16) & 0xF)
 #define SUN50I_SCALER_VSU_ANGLE_OFFSET(x)		((x) & 0xFF)
 
+struct image_format_info;
+
 void sun8i_vi_scaler_enable(struct sun8i_mixer *mixer, int layer, bool enable);
 void sun8i_vi_scaler_setup(struct sun8i_mixer *mixer, int layer,
 			   u32 src_w, u32 src_h, u32 dst_w, u32 dst_h,
 			   u32 hscale, u32 vscale, u32 hphase, u32 vphase,
-			   const struct drm_format_info *format);
+			   const struct image_format_info *format);
 
 #endif
diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
index 0a97458b286a..591a9ede5b9a 100644
--- a/drivers/gpu/drm/tegra/fb.c
+++ b/drivers/gpu/drm/tegra/fb.c
@@ -131,7 +131,7 @@ struct drm_framebuffer *tegra_fb_create(struct drm_device *drm,
 					struct drm_file *file,
 					const struct drm_mode_fb_cmd2 *cmd)
 {
-	const struct drm_format_info *info = drm_get_format_info(dev, cmd);
+	const struct image_format_info *info = drm_get_format_info(dev, cmd);
 	struct tegra_bo *planes[4];
 	struct drm_gem_object *gem;
 	struct drm_framebuffer *fb;
diff --git a/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c b/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
index 57dda9d1a45d..32f8d312b426 100644
--- a/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
+++ b/drivers/gpu/drm/tinydrm/core/tinydrm-helpers.c
@@ -36,7 +36,7 @@ MODULE_PARM_DESC(spi_max, "Set a lower SPI max transfer size");
 void tinydrm_memcpy(void *dst, void *vaddr, struct drm_framebuffer *fb,
 		    struct drm_rect *clip)
 {
-	unsigned int cpp = drm_format_plane_cpp(fb->format, 0);
+	unsigned int cpp = image_format_plane_cpp(fb->format, 0);
 	unsigned int pitch = fb->pitches[0];
 	void *src = vaddr + (clip->y1 * pitch) + (clip->x1 * cpp);
 	size_t len = (clip->x2 - clip->x1) * cpp;
diff --git a/drivers/gpu/drm/zte/zx_plane.c b/drivers/gpu/drm/zte/zx_plane.c
index 41bd0db4e876..054149b57410 100644
--- a/drivers/gpu/drm/zte/zx_plane.c
+++ b/drivers/gpu/drm/zte/zx_plane.c
@@ -222,7 +222,7 @@ static void zx_vl_plane_atomic_update(struct drm_plane *plane,
 		cma_obj = drm_fb_cma_get_gem_obj(fb, i);
 		paddr = cma_obj->paddr + fb->offsets[i];
 		paddr += src_y * fb->pitches[i];
-		paddr += src_x * drm_format_plane_cpp(fb->format, i);
+		paddr += src_x * image_format_plane_cpp(fb->format, i);
 		zx_writel(paddr_reg, paddr);
 		paddr_reg += 4;
 	}
diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
index 2291f2618211..7cc7b99a6569 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -49,6 +49,7 @@
 
 struct drm_device;
 struct drm_mode_fb_cmd2;
+struct image_format_info;
 
 /**
  * struct drm_format_info - information about a DRM format
@@ -262,7 +263,8 @@ drm_format_info_is_yuv_sampling_444(const struct drm_format_info *info)
 
 const struct drm_format_info *__drm_format_info(u32 format);
 const struct drm_format_info *drm_format_info(u32 format);
-const struct drm_format_info *
+
+const struct image_format_info *
 drm_get_format_info(struct drm_device *dev,
 		    const struct drm_mode_fb_cmd2 *mode_cmd);
 uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
diff --git a/include/drm/drm_framebuffer.h b/include/drm/drm_framebuffer.h
index f0b34c977ec5..dc7dc48c8580 100644
--- a/include/drm/drm_framebuffer.h
+++ b/include/drm/drm_framebuffer.h
@@ -24,6 +24,7 @@
 #define __DRM_FRAMEBUFFER_H__
 
 #include <linux/ctype.h>
+#include <linux/image-formats.h>
 #include <linux/list.h>
 #include <linux/sched.h>
 
@@ -134,7 +135,7 @@ struct drm_framebuffer {
 	/**
 	 * @format: framebuffer format information
 	 */
-	const struct drm_format_info *format;
+	const struct image_format_info *format;
 	/**
 	 * @funcs: framebuffer vfunc table
 	 */
diff --git a/include/drm/drm_mode_config.h b/include/drm/drm_mode_config.h
index 7f60e8eb269a..74421d2fefbc 100644
--- a/include/drm/drm_mode_config.h
+++ b/include/drm/drm_mode_config.h
@@ -35,7 +35,7 @@ struct drm_file;
 struct drm_device;
 struct drm_atomic_state;
 struct drm_mode_fb_cmd2;
-struct drm_format_info;
+struct image_format_info;
 struct drm_display_mode;
 
 /**
@@ -89,7 +89,7 @@ struct drm_mode_config_funcs {
 	 * The format information specific to the given fb metadata, or
 	 * NULL if none is found.
 	 */
-	const struct drm_format_info *(*get_format_info)(const struct drm_mode_fb_cmd2 *mode_cmd);
+	const struct image_format_info *(*get_format_info)(const struct drm_mode_fb_cmd2 *mode_cmd);
 
 	/**
 	 * @output_poll_changed:
-- 
git-series 0.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35898 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbcDWXtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 19:49:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 10/13] v4l: vsp1: Group DRM RPF parameters in a structure
Date: Sun, 24 Apr 2016 02:49:57 +0300
Message-Id: <1461455400-28767-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461455400-28767-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1_du_atomic_update_ext() function takes 7 RPF configuration
parameters, and more will likely be added later. This makes the code
difficult to read and error-prone as multiple parameters have the same
type.

Make the API safer and easier to extend in the future by grouping all
parameters in a structure. Use macro magic to ease the transition to the
new function by allowing the old and new functions to be called using
the same name. The macros and static inline wrapper will be removed as
soon as the caller is updated.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 68 +++++++++++++++-------------------
 include/media/vsp1.h                   | 47 ++++++++++++++++-------
 2 files changed, 64 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index fc4bbc401e67..fef53ecefe25 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -230,42 +230,33 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
  * vsp1_du_atomic_update - Setup one RPF input of the VSP pipeline
  * @dev: the VSP device
  * @rpf_index: index of the RPF to setup (0-based)
- * @pixelformat: V4L2 pixel format for the RPF memory input
- * @pitch: number of bytes per line in the image stored in memory
- * @mem: DMA addresses of the memory buffers (one per plane)
- * @src: the source crop rectangle for the RPF
- * @dst: the destination compose rectangle for the BRU input
- * @alpha: global alpha value for the input
- * @zpos: the Z-order position of the input
+ * @cfg: the RPF configuration
  *
- * Configure the VSP to perform composition of the image referenced by @mem
- * through RPF @rpf_index, using the @src crop rectangle and the @dst
+ * Configure the VSP to perform image composition through RPF @rpf_index as
+ * described by the @cfg configuration. The image to compose is referenced by
+ * @cfg.mem and composed using the @cfg.src crop rectangle and the @cfg.dst
  * composition rectangle. The Z-order is configurable with higher @zpos values
  * displayed on top.
  *
- * Image format as stored in memory is expressed as a V4L2 @pixelformat value.
- * As a special case, setting the pixel format to 0 will disable the RPF. The
- * @pitch, @mem, @src and @dst parameters are ignored in that case. Calling the
+ * If the @cfg configuration is NULL, the RPF will be disabled. Calling the
  * function on a disabled RPF is allowed.
  *
- * The memory pitch is configurable to allow for padding at end of lines, or
- * simple for images that extend beyond the crop rectangle boundaries. The
- * @pitch value is expressed in bytes and applies to all planes for multiplanar
- * formats.
+ * Image format as stored in memory is expressed as a V4L2 @cfg.pixelformat
+ * value. The memory pitch is configurable to allow for padding at end of lines,
+ * or simply for images that extend beyond the crop rectangle boundaries. The
+ * @cfg.pitch value is expressed in bytes and applies to all planes for
+ * multiplanar formats.
  *
  * The source memory buffer is referenced by the DMA address of its planes in
- * the @mem array. Up to two planes are supported. The second plane DMA address
- * is ignored for formats using a single plane.
+ * the @cfg.mem array. Up to two planes are supported. The second plane DMA
+ * address is ignored for formats using a single plane.
  *
  * This function isn't reentrant, the caller needs to serialize calls.
  *
  * Return 0 on success or a negative error code on failure.
  */
-int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
-			      u32 pixelformat, unsigned int pitch,
-			      dma_addr_t mem[2], const struct v4l2_rect *src,
-			      const struct v4l2_rect *dst, unsigned int alpha,
-			      unsigned int zpos)
+int __vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
+			    const struct vsp1_du_atomic_config *cfg)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	const struct vsp1_format_info *fmtinfo;
@@ -276,7 +267,7 @@ int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
 
 	rpf = vsp1->rpf[rpf_index];
 
-	if (pixelformat == 0) {
+	if (!cfg) {
 		dev_dbg(vsp1->dev, "%s: RPF%u: disable requested\n", __func__,
 			rpf_index);
 
@@ -287,38 +278,39 @@ int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
 	dev_dbg(vsp1->dev,
 		"%s: RPF%u: (%u,%u)/%ux%u -> (%u,%u)/%ux%u (%08x), pitch %u dma { %pad, %pad } zpos %u\n",
 		__func__, rpf_index,
-		src->left, src->top, src->width, src->height,
-		dst->left, dst->top, dst->width, dst->height,
-		pixelformat, pitch, &mem[0], &mem[1], zpos);
+		cfg->src.left, cfg->src.top, cfg->src.width, cfg->src.height,
+		cfg->dst.left, cfg->dst.top, cfg->dst.width, cfg->dst.height,
+		cfg->pixelformat, cfg->pitch, &cfg->mem[0], &cfg->mem[1],
+		cfg->zpos);
 
 	/* Store the format, stride, memory buffer address, crop and compose
 	 * rectangles and Z-order position and for the input.
 	 */
-	fmtinfo = vsp1_get_format_info(pixelformat);
+	fmtinfo = vsp1_get_format_info(cfg->pixelformat);
 	if (!fmtinfo) {
 		dev_dbg(vsp1->dev, "Unsupport pixel format %08x for RPF\n",
-			pixelformat);
+			cfg->pixelformat);
 		return -EINVAL;
 	}
 
 	rpf->fmtinfo = fmtinfo;
 	rpf->format.num_planes = fmtinfo->planes;
-	rpf->format.plane_fmt[0].bytesperline = pitch;
-	rpf->format.plane_fmt[1].bytesperline = pitch;
-	rpf->alpha = alpha;
+	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
+	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
+	rpf->alpha = cfg->alpha;
 
-	rpf->mem.addr[0] = mem[0];
-	rpf->mem.addr[1] = mem[1];
+	rpf->mem.addr[0] = cfg->mem[0];
+	rpf->mem.addr[1] = cfg->mem[1];
 	rpf->mem.addr[2] = 0;
 
-	vsp1->drm->inputs[rpf_index].crop = *src;
-	vsp1->drm->inputs[rpf_index].compose = *dst;
-	vsp1->drm->inputs[rpf_index].zpos = zpos;
+	vsp1->drm->inputs[rpf_index].crop = cfg->src;
+	vsp1->drm->inputs[rpf_index].compose = cfg->dst;
+	vsp1->drm->inputs[rpf_index].zpos = cfg->zpos;
 	vsp1->drm->inputs[rpf_index].enabled = true;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(vsp1_du_atomic_update_ext);
+EXPORT_SYMBOL_GPL(__vsp1_du_atomic_update);
 
 static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 				  struct vsp1_rwpf *rpf, unsigned int bru_input)
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 3e654a0455bd..ea8ad7537057 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -14,31 +14,52 @@
 #define __MEDIA_VSP1_H__
 
 #include <linux/types.h>
+#include <linux/videodev2.h>
 
 struct device;
-struct v4l2_rect;
 
 int vsp1_du_init(struct device *dev);
 
 int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		      unsigned int height);
 
+struct vsp1_du_atomic_config {
+	u32 pixelformat;
+	unsigned int pitch;
+	dma_addr_t mem[2];
+	struct v4l2_rect src;
+	struct v4l2_rect dst;
+	unsigned int alpha;
+	unsigned int zpos;
+};
+
 void vsp1_du_atomic_begin(struct device *dev);
-int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf,
-			      u32 pixelformat, unsigned int pitch,
-			      dma_addr_t mem[2], const struct v4l2_rect *src,
-			      const struct v4l2_rect *dst, unsigned int alpha,
-			      unsigned int zpos);
+int __vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
+			    const struct vsp1_du_atomic_config *cfg);
 void vsp1_du_atomic_flush(struct device *dev);
 
-static inline int vsp1_du_atomic_update(struct device *dev,
-					unsigned int rpf_index, u32 pixelformat,
-					unsigned int pitch, dma_addr_t mem[2],
-					const struct v4l2_rect *src,
-					const struct v4l2_rect *dst)
+static inline int vsp1_du_atomic_update_old(struct device *dev,
+	unsigned int rpf, u32 pixelformat, unsigned int pitch,
+	dma_addr_t mem[2], const struct v4l2_rect *src,
+	const struct v4l2_rect *dst)
 {
-	return vsp1_du_atomic_update_ext(dev, rpf_index, pixelformat, pitch,
-					 mem, src, dst, 255, 0);
+	struct vsp1_du_atomic_config cfg = {
+		.pixelformat = pixelformat,
+		.pitch = pitch,
+		.mem[0] = mem[0],
+		.mem[1] = mem[1],
+		.src = *src,
+		.dst = *dst,
+		.alpha = 255,
+		.zpos = 0,
+	};
+
+	return __vsp1_du_atomic_update(dev, rpf, &cfg);
 }
 
+#define _vsp1_du_atomic_update(_1, _2, _3, _4, _5, _6, _7, f, ...) f
+#define vsp1_du_atomic_update(...) \
+	_vsp1_du_atomic_update(__VA_ARGS__, vsp1_du_atomic_update_old, 0, 0, \
+			       0, __vsp1_du_atomic_update)(__VA_ARGS__)
+
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.7.3


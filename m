Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbcCYKpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:14 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 52/54] v4l: vsp1: Add global alpha support for DRM pipeline
Date: Fri, 25 Mar 2016 12:44:26 +0200
Message-Id: <1458902668-1141-53-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the global alpha multiplier of DRM planes configurable. All the
necessary infrastructure is there, we just need to store the alpha value
passed through the DRM API.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 5 ++++-
 include/media/vsp1.h                   | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index d85cb0e258c9..fc4bbc401e67 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -235,6 +235,7 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
  * @mem: DMA addresses of the memory buffers (one per plane)
  * @src: the source crop rectangle for the RPF
  * @dst: the destination compose rectangle for the BRU input
+ * @alpha: global alpha value for the input
  * @zpos: the Z-order position of the input
  *
  * Configure the VSP to perform composition of the image referenced by @mem
@@ -263,7 +264,8 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
 int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
 			      u32 pixelformat, unsigned int pitch,
 			      dma_addr_t mem[2], const struct v4l2_rect *src,
-			      const struct v4l2_rect *dst, unsigned int zpos)
+			      const struct v4l2_rect *dst, unsigned int alpha,
+			      unsigned int zpos)
 {
 	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
 	const struct vsp1_format_info *fmtinfo;
@@ -303,6 +305,7 @@ int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf_index,
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = pitch;
 	rpf->format.plane_fmt[1].bytesperline = pitch;
+	rpf->alpha = alpha;
 
 	rpf->mem.addr[0] = mem[0];
 	rpf->mem.addr[1] = mem[1];
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index e54a493bd3ff..3e654a0455bd 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -27,7 +27,8 @@ void vsp1_du_atomic_begin(struct device *dev);
 int vsp1_du_atomic_update_ext(struct device *dev, unsigned int rpf,
 			      u32 pixelformat, unsigned int pitch,
 			      dma_addr_t mem[2], const struct v4l2_rect *src,
-			      const struct v4l2_rect *dst, unsigned int zpos);
+			      const struct v4l2_rect *dst, unsigned int alpha,
+			      unsigned int zpos);
 void vsp1_du_atomic_flush(struct device *dev);
 
 static inline int vsp1_du_atomic_update(struct device *dev,
@@ -37,7 +38,7 @@ static inline int vsp1_du_atomic_update(struct device *dev,
 					const struct v4l2_rect *dst)
 {
 	return vsp1_du_atomic_update_ext(dev, rpf_index, pixelformat, pitch,
-					 mem, src, dst, 0);
+					 mem, src, dst, 255, 0);
 }
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
2.7.3


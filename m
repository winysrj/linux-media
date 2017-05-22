Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934741AbdEVOTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:19:30 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Subject: [PATCH v3 4/5] v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
Date: Mon, 22 May 2017 15:19:21 +0100
Message-Id: <6ffd75ffaf42ab205fcfa42335f0f1a90544e6b3.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The display buffers must be mapped for DMA through the device that
performs memory access. Expose an API to map and unmap memory through
the VSP device to be used by the DU.

As all the buffers allocated by the DU driver are coherent, we can skip
cache handling when mapping and unmapping them. This will need to be
revisited when support for non-coherent buffers will be added to the DU
driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
[Kieran: Remove unused header]
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 24 ++++++++++++++++++++++++
 include/media/vsp1.h                   |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 9d235e830f5a..7e456e482e16 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/slab.h>
 
 #include <media/media-entity.h>
@@ -524,6 +525,29 @@ void vsp1_du_atomic_flush(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
+int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	/*
+	 * As all the buffers allocated by the DU driver are coherent, we can
+	 * skip cache sync. This will need to be revisited when support for
+	 * non-coherent buffers will be added to the DU driver.
+	 */
+	return dma_map_sg_attrs(vsp1->bus_master, sgt->sgl, sgt->nents,
+				DMA_TO_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+}
+EXPORT_SYMBOL_GPL(vsp1_du_map_sg);
+
+void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+
+	dma_unmap_sg_attrs(vsp1->bus_master, sgt->sgl, sgt->nents,
+			   DMA_TO_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
+}
+EXPORT_SYMBOL_GPL(vsp1_du_unmap_sg);
+
 /* -----------------------------------------------------------------------------
  * Initialization
  */
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 38aac554dbba..6aa630c9f7af 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -13,6 +13,7 @@
 #ifndef __MEDIA_VSP1_H__
 #define __MEDIA_VSP1_H__
 
+#include <linux/scatterlist.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
@@ -46,5 +47,7 @@ void vsp1_du_atomic_begin(struct device *dev);
 int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
 			  const struct vsp1_du_atomic_config *cfg);
 void vsp1_du_atomic_flush(struct device *dev);
+int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
+void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
git-series 0.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51092 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755069AbcHSIjc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:32 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/6] v4l: vsp1: Add API to map and unmap DRM buffers through the VSP
Date: Fri, 19 Aug 2016 11:39:33 +0300
Message-Id: <1471595974-28960-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The display buffers must be mapped for DMA through the device that
performs memory access. Expose an API to map and unmap memory through
the VSP device to be used by the DU.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 24 ++++++++++++++++++++++++
 include/media/vsp1.h                   |  3 +++
 2 files changed, 27 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index f76131b192a4..0472cb4bc2e4 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -12,9 +12,11 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/slab.h>
 
 #include <media/media-entity.h>
+#include <media/rcar-fcp.h>
 #include <media/v4l2-subdev.h>
 #include <media/vsp1.h>
 
@@ -521,6 +523,28 @@ void vsp1_du_atomic_flush(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
 
+int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	struct device *map_dev;
+
+	map_dev = vsp1->fcp ? rcar_fcp_get_device(vsp1->fcp) : dev;
+
+	return dma_map_sg(map_dev, sgt->sgl, sgt->nents, DMA_TO_DEVICE);
+}
+EXPORT_SYMBOL_GPL(vsp1_du_map_sg);
+
+void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt)
+{
+	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
+	struct device *map_dev;
+
+	map_dev = vsp1->fcp ? rcar_fcp_get_device(vsp1->fcp) : dev;
+
+	dma_unmap_sg(map_dev, sgt->sgl, sgt->nents, DMA_TO_DEVICE);
+}
+EXPORT_SYMBOL_GPL(vsp1_du_unmap_sg);
+
 /* -----------------------------------------------------------------------------
  * Initialization
  */
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 458b400373d4..8d3d07a3715e 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -13,6 +13,7 @@
 #ifndef __MEDIA_VSP1_H__
 #define __MEDIA_VSP1_H__
 
+#include <linux/scatterlist.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
@@ -37,5 +38,7 @@ void vsp1_du_atomic_begin(struct device *dev);
 int vsp1_du_atomic_update(struct device *dev, unsigned int rpf,
 			  const struct vsp1_du_atomic_config *cfg);
 void vsp1_du_atomic_flush(struct device *dev);
+int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
+void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
 
 #endif /* __MEDIA_VSP1_H__ */
-- 
Regards,

Laurent Pinchart


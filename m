Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38427 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756763AbcBXVMZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 16:12:25 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 2/2] v4l: vsp1: drm: Include correct header file
Date: Wed, 24 Feb 2016 23:12:10 +0200
Message-Id: <1456348330-28928-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456348330-28928-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456348330-28928-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VSP1 DRM API is declared in <media/vsp1.h>, not <linux/vsp1.h>. Fix
it. This also reverts commit 18922936dc28 ("[media] vsp1_drm.h: add
missing prototypes") that added the same declarations in a different
header file.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.h | 11 -----------
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 021fe5778cd1..8cf7c19f4344 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -13,10 +13,10 @@
 
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/vsp1.h>
 
 #include <media/media-entity.h>
 #include <media/v4l2-subdev.h>
+#include <media/vsp1.h>
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
index f68056838319..7704038c3add 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.h
+++ b/drivers/media/platform/vsp1/vsp1_drm.h
@@ -35,15 +35,4 @@ int vsp1_drm_init(struct vsp1_device *vsp1);
 void vsp1_drm_cleanup(struct vsp1_device *vsp1);
 int vsp1_drm_create_links(struct vsp1_device *vsp1);
 
-int vsp1_du_init(struct device *dev);
-int vsp1_du_setup_lif(struct device *dev, unsigned int width,
-		      unsigned int height);
-void vsp1_du_atomic_begin(struct device *dev);
-int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
-			  u32 pixelformat, unsigned int pitch,
-			  dma_addr_t mem[2], const struct v4l2_rect *src,
-			  const struct v4l2_rect *dst);
-void vsp1_du_atomic_flush(struct device *dev);
-
-
 #endif /* __VSP1_DRM_H__ */
-- 
2.4.10


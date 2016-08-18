Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47830 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946030AbcHRN0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 09:26:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Fix tri-planar format support through DRM API
Date: Thu, 18 Aug 2016 16:26:13 +0300
Message-Id: <1471526773-12046-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1 driver supports tri-planar formats, but the DRM API only passes
two memory addresses. Add a third one.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 6 +++---
 include/media/vsp1.h                   | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 0a98a3c49b73..f76131b192a4 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -276,12 +276,12 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	}
 
 	dev_dbg(vsp1->dev,
-		"%s: RPF%u: (%u,%u)/%ux%u -> (%u,%u)/%ux%u (%08x), pitch %u dma { %pad, %pad } zpos %u\n",
+		"%s: RPF%u: (%u,%u)/%ux%u -> (%u,%u)/%ux%u (%08x), pitch %u dma { %pad, %pad, %pad } zpos %u\n",
 		__func__, rpf_index,
 		cfg->src.left, cfg->src.top, cfg->src.width, cfg->src.height,
 		cfg->dst.left, cfg->dst.top, cfg->dst.width, cfg->dst.height,
 		cfg->pixelformat, cfg->pitch, &cfg->mem[0], &cfg->mem[1],
-		cfg->zpos);
+		&cfg->mem[2], cfg->zpos);
 
 	/* Store the format, stride, memory buffer address, crop and compose
 	 * rectangles and Z-order position and for the input.
@@ -301,7 +301,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 
 	rpf->mem.addr[0] = cfg->mem[0];
 	rpf->mem.addr[1] = cfg->mem[1];
-	rpf->mem.addr[2] = 0;
+	rpf->mem.addr[2] = cfg->mem[2];
 
 	vsp1->drm->inputs[rpf_index].crop = cfg->src;
 	vsp1->drm->inputs[rpf_index].compose = cfg->dst;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 9322d9775fb7..458b400373d4 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -26,7 +26,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 struct vsp1_du_atomic_config {
 	u32 pixelformat;
 	unsigned int pitch;
-	dma_addr_t mem[2];
+	dma_addr_t mem[3];
 	struct v4l2_rect src;
 	struct v4l2_rect dst;
 	unsigned int alpha;
-- 
Regards,

Laurent Pinchart


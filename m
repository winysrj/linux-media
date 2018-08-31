Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:44524 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbeHaSsk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 14:48:40 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 2/6] media: vsp1: Correct the pitch on multiplanar formats
Date: Fri, 31 Aug 2018 15:40:40 +0100
Message-Id: <20180831144044.31713-3-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180831144044.31713-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DRM pipelines now support tri-planar as well as packed formats with
YCbCr, however the pitch calculation was not updated to support this.

Correct this by adjusting the bytesperline accordingly when 3 planes are
used.

Fixes: 7863ac504bc5 ("drm: rcar-du: Add tri-planar memory formats support")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drm.c | 10 ++++++++++
 include/media/vsp1.h                   |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index b9c0f695d002..b9afd98f6867 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -814,6 +814,16 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
 	rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
+
+	/*
+	 * Packed YUV formats are subsampled, but the packing of two components
+	 * into a single plane compensates for this leaving the bytesperline
+	 * to be the correct value. For multiplanar formats we must adjust the
+	 * pitch accordingly.
+	 */
+	if (fmtinfo->planes == 3)
+		rpf->format.plane_fmt[1].bytesperline /= fmtinfo->hsub;
+
 	rpf->alpha = cfg->alpha;
 
 	rpf->mem.addr[0] = cfg->mem[0];
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 3093b9cb9067..0ce19b595cc7 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -46,7 +46,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 /**
  * struct vsp1_du_atomic_config - VSP atomic configuration parameters
  * @pixelformat: plane pixel format (V4L2 4CC)
- * @pitch: line pitch in bytes, for all planes
+ * @pitch: line pitch in bytes
  * @mem: DMA memory address for each plane of the frame buffer
  * @src: source rectangle in the frame buffer (integer coordinates)
  * @dst: destination rectangle on the display (integer coordinates)
-- 
2.17.1

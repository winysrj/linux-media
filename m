Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:46480 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753744AbeDVWe2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 18:34:28 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 4/8] v4l: vsp1: Document the vsp1_du_atomic_config structure
Date: Mon, 23 Apr 2018 01:34:26 +0300
Message-Id: <20180422223430.16407-5-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The structure is used in the API that the VSP1 driver exposes to the DU
driver. Documenting it is thus important.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
Changes since v1:

- Fixed typo
---
 include/media/vsp1.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 68a8abe4fac5..ff7ef894465d 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -41,6 +41,16 @@ struct vsp1_du_lif_config {
 int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
 		      const struct vsp1_du_lif_config *cfg);
 
+/**
+ * struct vsp1_du_atomic_config - VSP atomic configuration parameters
+ * @pixelformat: plane pixel format (V4L2 4CC)
+ * @pitch: line pitch in bytes, for all planes
+ * @mem: DMA memory address for each plane of the frame buffer
+ * @src: source rectangle in the frame buffer (integer coordinates)
+ * @dst: destination rectangle on the display (integer coordinates)
+ * @alpha: alpha value (0: fully transparent, 255: fully opaque)
+ * @zpos: Z position of the plane (from 0 to number of planes minus 1)
+ */
 struct vsp1_du_atomic_config {
 	u32 pixelformat;
 	unsigned int pitch;
-- 
Regards,

Laurent Pinchart

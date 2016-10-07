Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:58675 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936473AbcJGQBV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 12:01:21 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 17/22] gpu: ipuv3: add ipu_csi_set_downsize
Date: Fri,  7 Oct 2016 18:01:02 +0200
Message-Id: <20161007160107.5074-18-p.zabel@pengutronix.de>
In-Reply-To: <20161007160107.5074-1-p.zabel@pengutronix.de>
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support downsizing to 1/2 width and/or height in the CSI.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-csi.c | 16 ++++++++++++++++
 include/video/imx-ipu-v3.h   |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/gpu/ipu-v3/ipu-csi.c b/drivers/gpu/ipu-v3/ipu-csi.c
index 06631ac..77f172e 100644
--- a/drivers/gpu/ipu-v3/ipu-csi.c
+++ b/drivers/gpu/ipu-v3/ipu-csi.c
@@ -527,6 +527,22 @@ void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w)
 }
 EXPORT_SYMBOL_GPL(ipu_csi_set_window);
 
+void ipu_csi_set_downsize(struct ipu_csi *csi, bool horiz, bool vert)
+{
+	unsigned long flags;
+	u32 reg;
+
+	spin_lock_irqsave(&csi->lock, flags);
+
+	reg = ipu_csi_read(csi, CSI_OUT_FRM_CTRL);
+	reg &= ~(CSI_HORI_DOWNSIZE_EN | CSI_VERT_DOWNSIZE_EN);
+	reg |= (horiz ? CSI_HORI_DOWNSIZE_EN : 0) |
+	       (vert ? CSI_VERT_DOWNSIZE_EN : 0);
+	ipu_csi_write(csi, reg, CSI_OUT_FRM_CTRL);
+
+	spin_unlock_irqrestore(&csi->lock, flags);
+}
+
 void ipu_csi_set_test_generator(struct ipu_csi *csi, bool active,
 				u32 r_value, u32 g_value, u32 b_value,
 				u32 pix_clk)
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 7adeaae0..5f2f26d 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -271,6 +271,7 @@ int ipu_csi_init_interface(struct ipu_csi *csi,
 bool ipu_csi_is_interlaced(struct ipu_csi *csi);
 void ipu_csi_get_window(struct ipu_csi *csi, struct v4l2_rect *w);
 void ipu_csi_set_window(struct ipu_csi *csi, struct v4l2_rect *w);
+void ipu_csi_set_downsize(struct ipu_csi *csi, bool horiz, bool vert);
 void ipu_csi_set_test_generator(struct ipu_csi *csi, bool active,
 				u32 r_value, u32 g_value, u32 b_value,
 				u32 pix_clk);
-- 
2.9.3


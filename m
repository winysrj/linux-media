Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56269 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbeJSUVe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:34 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 04/22] gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients
Date: Fri, 19 Oct 2018 14:15:21 +0200
Message-Id: <20181019121539.12778-5-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For tiled scaling, we want to compute the scaling coefficients
externally in such a way that the interpolation overshoots tile
boundaries and samples up to the first pixel of the next tile.
Prepare to override the resizing coefficients from the image
conversion code.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-ic.c | 52 +++++++++++++++++++++++--------------
 include/video/imx-ipu-v3.h  |  6 +++++
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
index 67cc820253a9..594c3cbc8291 100644
--- a/drivers/gpu/ipu-v3/ipu-ic.c
+++ b/drivers/gpu/ipu-v3/ipu-ic.c
@@ -442,36 +442,40 @@ int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 }
 EXPORT_SYMBOL_GPL(ipu_ic_task_graphics_init);
 
-int ipu_ic_task_init(struct ipu_ic *ic,
-		     int in_width, int in_height,
-		     int out_width, int out_height,
-		     enum ipu_color_space in_cs,
-		     enum ipu_color_space out_cs)
+int ipu_ic_task_init_rsc(struct ipu_ic *ic,
+			 int in_width, int in_height,
+			 int out_width, int out_height,
+			 enum ipu_color_space in_cs,
+			 enum ipu_color_space out_cs,
+			 u32 rsc)
 {
 	struct ipu_ic_priv *priv = ic->priv;
-	u32 reg, downsize_coeff, resize_coeff;
+	u32 downsize_coeff, resize_coeff;
 	unsigned long flags;
 	int ret = 0;
 
-	/* Setup vertical resizing */
-	ret = calc_resize_coeffs(ic, in_height, out_height,
-				 &resize_coeff, &downsize_coeff);
-	if (ret)
-		return ret;
+	if (!rsc) {
+		/* Setup vertical resizing */
 
-	reg = (downsize_coeff << 30) | (resize_coeff << 16);
+		ret = calc_resize_coeffs(ic, in_height, out_height,
+					 &resize_coeff, &downsize_coeff);
+		if (ret)
+			return ret;
+
+		rsc = (downsize_coeff << 30) | (resize_coeff << 16);
 
-	/* Setup horizontal resizing */
-	ret = calc_resize_coeffs(ic, in_width, out_width,
-				 &resize_coeff, &downsize_coeff);
-	if (ret)
-		return ret;
+		/* Setup horizontal resizing */
+		ret = calc_resize_coeffs(ic, in_width, out_width,
+					 &resize_coeff, &downsize_coeff);
+		if (ret)
+			return ret;
 
-	reg |= (downsize_coeff << 14) | resize_coeff;
+		rsc |= (downsize_coeff << 14) | resize_coeff;
+	}
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	ipu_ic_write(ic, reg, ic->reg->rsc);
+	ipu_ic_write(ic, rsc, ic->reg->rsc);
 
 	/* Setup color space conversion */
 	ic->in_cs = in_cs;
@@ -487,6 +491,16 @@ int ipu_ic_task_init(struct ipu_ic *ic,
 	spin_unlock_irqrestore(&priv->lock, flags);
 	return ret;
 }
+
+int ipu_ic_task_init(struct ipu_ic *ic,
+		     int in_width, int in_height,
+		     int out_width, int out_height,
+		     enum ipu_color_space in_cs,
+		     enum ipu_color_space out_cs)
+{
+	return ipu_ic_task_init_rsc(ic, in_width, in_height, out_width,
+				    out_height, in_cs, out_cs, 0);
+}
 EXPORT_SYMBOL_GPL(ipu_ic_task_init);
 
 int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
index 8bb163cd9314..e582e8e7527a 100644
--- a/include/video/imx-ipu-v3.h
+++ b/include/video/imx-ipu-v3.h
@@ -390,6 +390,12 @@ int ipu_ic_task_init(struct ipu_ic *ic,
 		     int out_width, int out_height,
 		     enum ipu_color_space in_cs,
 		     enum ipu_color_space out_cs);
+int ipu_ic_task_init_rsc(struct ipu_ic *ic,
+			 int in_width, int in_height,
+			 int out_width, int out_height,
+			 enum ipu_color_space in_cs,
+			 enum ipu_color_space out_cs,
+			 u32 rsc);
 int ipu_ic_task_graphics_init(struct ipu_ic *ic,
 			      enum ipu_color_space in_g_cs,
 			      bool galpha_en, u32 galpha,
-- 
2.19.0

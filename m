Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55643 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3KSO2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:28:15 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00CHXLJ0NL90@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:28:14 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 16/16] s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12
 needs
Date: Tue, 19 Nov 2013 15:27:08 +0100
Message-id: <1384871228-6648-17-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whereas S5PC210 device produces decoded JPEG subsampling
values that map on V4L2_JPEG_CHROMA_SUBSAMPLNG values,
the Exynos4x12 device doesn't. This patch adds helper
function decoded_subsampling_to_v4l2, which performs
HW -> V4L2 translation.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   36 ++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3605470..90d2f69 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -358,6 +358,13 @@ static const unsigned char hactblg0[162] = {
 	0xf9, 0xfa
 };
 
+static int exynos4x12_decoded_subsampling[] = {
+	V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_444,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_422,
+	V4L2_JPEG_CHROMA_SUBSAMPLING_420,
+};
+
 static inline struct s5p_jpeg_ctx *ctrl_to_ctx(struct v4l2_ctrl *c)
 {
 	return container_of(c->handler, struct s5p_jpeg_ctx, ctrl_handler);
@@ -368,6 +375,28 @@ static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
 	return container_of(fh, struct s5p_jpeg_ctx, fh);
 }
 
+static inline int decoded_subsampling_to_v4l2(struct s5p_jpeg_ctx *ctx)
+{
+	int subsampling;
+
+	WARN_ON(ctx->subsampling > 3);
+
+	if (ctx->jpeg->variant->version == SJPEG_S5P) {
+		if (ctx->subsampling > 2)
+			subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
+		else
+			subsampling = ctx->subsampling;
+	} else {
+		if (ctx->subsampling > 2)
+			subsampling = V4L2_JPEG_CHROMA_SUBSAMPLING_420;
+		else
+			subsampling =
+			    exynos4x12_decoded_subsampling[ctx->subsampling];
+	}
+
+	return subsampling;
+}
+
 static inline void s5p_jpeg_set_qtbl(void __iomem *regs,
 				     const unsigned char *qtbl,
 				     unsigned long tab, int len)
@@ -1159,12 +1188,7 @@ static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		spin_lock_irqsave(&jpeg->slock, flags);
-
-		WARN_ON(ctx->subsampling > S5P_SUBSAMPLING_MODE_GRAY);
-		if (ctx->subsampling > 2)
-			ctrl->val = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
-		else
-			ctrl->val = ctx->subsampling;
+		ctrl->val = decoded_subsampling_to_v4l2(ctx);
 		spin_unlock_irqrestore(&jpeg->slock, flags);
 		break;
 	}
-- 
1.7.9.5


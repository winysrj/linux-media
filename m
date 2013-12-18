Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45818 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3LROuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:50:13 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0001SCBVONY70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:50:12 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 8/8] s5p-jpeg: Adjust g_volatile_ctrl callback to Exynos4x12
 needs
Date: Wed, 18 Dec 2013 15:49:35 +0100
Message-id: <1387378175-23399-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Whereas S5PC210 device produces decoded JPEG subsampling
values that map on V4L2_JPEG_CHROMA_SUBSAMPLNG values,
the Exynos4x12 device doesn't. This patch adds helper
function s5p_jpeg_to_user_subsampling, which performs
suitable translation.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   29 +++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index c46c9af..a009bd9 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -451,6 +451,13 @@ static int s5p_jpeg_adjust_fourcc_to_subsampling(
 	return 0;
 }
 
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
@@ -461,6 +468,21 @@ static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
 	return container_of(fh, struct s5p_jpeg_ctx, fh);
 }
 
+static int s5p_jpeg_to_user_subsampling(struct s5p_jpeg_ctx *ctx)
+{
+	WARN_ON(ctx->subsampling > 3);
+
+	if (ctx->jpeg->variant->version == SJPEG_S5P) {
+		if (ctx->subsampling > 2)
+			return V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
+		return ctx->subsampling;
+	} else {
+		if (ctx->subsampling > 2)
+			return V4L2_JPEG_CHROMA_SUBSAMPLING_420;
+		return exynos4x12_decoded_subsampling[ctx->subsampling];
+	}
+}
+
 static inline void s5p_jpeg_set_qtbl(void __iomem *regs,
 				     const unsigned char *qtbl,
 				     unsigned long tab, int len)
@@ -1200,12 +1222,7 @@ static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
 		spin_lock_irqsave(&jpeg->slock, flags);
-
-		WARN_ON(ctx->subsampling > S5P_SUBSAMPLING_MODE_GRAY);
-		if (ctx->subsampling > 2)
-			ctrl->val = V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY;
-		else
-			ctrl->val = ctx->subsampling;
+		ctrl->val = s5p_jpeg_to_user_subsampling(ctx);
 		spin_unlock_irqrestore(&jpeg->slock, flags);
 		break;
 	}
-- 
1.7.9.5


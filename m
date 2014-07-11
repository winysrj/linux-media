Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64344 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaGKPUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:20:10 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00GA5ZXK2160@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:20:08 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 7/9] s5p-jpeg: add chroma subsampling adjustment for
 Exynos3250
Date: Fri, 11 Jul 2014 17:19:48 +0200
Message-id: <1405091990-28567-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Take into account limitations specific to the Exynos3250 SoC,
regarding setting chroma subsampling control value.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   59 +++++++++++++++++----------
 1 file changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 1ef004b..283249d 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1603,36 +1603,53 @@ static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int s5p_jpeg_try_ctrl(struct v4l2_ctrl *ctrl)
+static int s5p_jpeg_adjust_subs_ctrl(struct s5p_jpeg_ctx *ctx, int *ctrl_val)
 {
-	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
-	unsigned long flags;
-	int ret = 0;
-
-	spin_lock_irqsave(&ctx->jpeg->slock, flags);
-
-	if (ctrl->id == V4L2_CID_JPEG_CHROMA_SUBSAMPLING) {
-		if (ctx->jpeg->variant->version == SJPEG_S5P)
-			goto error_free;
+	switch (ctx->jpeg->variant->version) {
+	case SJPEG_S5P:
+		return 0;
+	case SJPEG_EXYNOS3250:
+		/*
+		 * The exynos3250 device can produce JPEG image only
+		 * of 4:4:4 subsampling when given RGB32 source image.
+		 */
+		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB32)
+			*ctrl_val = 0;
+		break;
+	case SJPEG_EXYNOS4:
 		/*
 		 * The exynos4x12 device requires input raw image fourcc
 		 * to be V4L2_PIX_FMT_GREY if gray jpeg format
 		 * is to be set.
 		 */
 		if (ctx->out_q.fmt->fourcc != V4L2_PIX_FMT_GREY &&
-		    ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY) {
-			ret = -EINVAL;
-			goto error_free;
-		}
-		/*
-		 * The exynos4x12 device requires resulting jpeg subsampling
-		 * not to be lower than the input raw image subsampling.
-		 */
-		if (ctx->out_q.fmt->subsampling > ctrl->val)
-			ctrl->val = ctx->out_q.fmt->subsampling;
+		    *ctrl_val == V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY)
+			return -EINVAL;
+		break;
 	}
 
-error_free:
+	/*
+	 * The exynos4x12 and exynos3250 devices require resulting
+	 * jpeg subsampling not to be lower than the input raw image
+	 * subsampling.
+	 */
+	if (ctx->out_q.fmt->subsampling > *ctrl_val)
+		*ctrl_val = ctx->out_q.fmt->subsampling;
+
+	return 0;
+}
+
+static int s5p_jpeg_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+
+	if (ctrl->id == V4L2_CID_JPEG_CHROMA_SUBSAMPLING)
+		ret = s5p_jpeg_adjust_subs_ctrl(ctx, &ctrl->val);
+
 	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
 	return ret;
 }
-- 
1.7.9.5


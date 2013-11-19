Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19238 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab3KSO2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:28:13 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI006K9LIUBP10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:28:12 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 15/16] s5p-jpeg: Ensure setting correct value of the chroma
 subsampling control
Date: Tue, 19 Nov 2013 15:27:07 +0100
Message-id: <1384871228-6648-16-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos4x12 has limitations regarding setting chroma subsampling
of an output JPEG image. It cannot be lower than the subsampling
of the raw source image. Also in case of V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY
option the source image fourcc has to be V4L2_PIX_FMT_GREY.
This patch adds mechanism that prevents setting invalid value
of the V4L2_CID_JPEG_CHROMA_SUBSAMPLING control.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d4db612..3605470 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1176,6 +1176,7 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&ctx->jpeg->slock, flags);
 
@@ -1187,12 +1188,34 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->restart_interval = ctrl->val;
 		break;
 	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
-		ctx->subsampling = ctrl->val;
+		if (ctx->jpeg->variant->version == SJPEG_S5P) {
+			ctx->subsampling = ctrl->val;
+			break;
+		}
+		/*
+		 * The exynos4x12 device requires input raw image fourcc
+		 * to be V4L2_PIX_FMT_GREY if gray jpeg format
+		 * is to be set.
+		 */
+		if (ctx->out_q.fmt->fourcc != V4L2_PIX_FMT_GREY &&
+		    ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY) {
+			ret = -EINVAL;
+			goto error_free;
+		}
+		/*
+		 * The exynos4x12 device requires resulting jpeg subsampling
+		 * not to be lower than the input raw image subsampling.
+		 */
+		if (ctx->out_q.fmt->subsampling > ctrl->val)
+			ctx->subsampling = ctx->out_q.fmt->subsampling;
+		else
+			ctx->subsampling = ctrl->val;
 		break;
 	}
 
+error_free:
 	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
-	return 0;
+	return ret;
 }
 
 static const struct v4l2_ctrl_ops s5p_jpeg_ctrl_ops = {
-- 
1.7.9.5


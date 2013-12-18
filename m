Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45817 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab3LROuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:50:11 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0003M0BVMEG60@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:50:10 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 7/8] s5p-jpeg: Ensure setting correct value of the chroma
 subsampling control
Date: Wed, 18 Dec 2013 15:49:34 +0100
Message-id: <1387378175-23399-8-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos4x12 has limitations regarding setting chroma subsampling
of an output JPEG image. It cannot be lower than the subsampling
of the raw source image. Also in case of V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY
option the source image fourcc has to be V4L2_PIX_FMT_GREY.
This patch implements try_ctrl callback containing mechanism
that prevents setting invalid value of the V4L2_CID_JPEG_CHROMA_SUBSAMPLING
control.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   35 +++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index fc14bbc..c46c9af 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1213,6 +1213,40 @@ static int s5p_jpeg_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
+static int s5p_jpeg_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ctx->jpeg->slock, flags);
+
+	if (ctrl->id == V4L2_CID_JPEG_CHROMA_SUBSAMPLING) {
+		if (ctx->jpeg->variant->version == SJPEG_S5P)
+			goto error_free;
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
+			ctrl->val = ctx->out_q.fmt->subsampling;
+	}
+
+error_free:
+	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
+	return ret;
+}
+
 static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
@@ -1238,6 +1272,7 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
 
 static const struct v4l2_ctrl_ops s5p_jpeg_ctrl_ops = {
 	.g_volatile_ctrl	= s5p_jpeg_g_volatile_ctrl,
+	.try_ctrl		= s5p_jpeg_try_ctrl,
 	.s_ctrl			= s5p_jpeg_s_ctrl,
 };
 
-- 
1.7.9.5


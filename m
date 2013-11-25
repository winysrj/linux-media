Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56536 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3KYJ66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:58 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00ANVD29VE20@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:57 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 08/16] s5p-jpeg: Synchronize cached controls with V4L2 core
Date: Mon, 25 Nov 2013 10:58:15 +0100
Message-id: <1385373503-1657-9-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds proper initialization of the in-driver
cached state of JPEG controls with V4L2 core.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 628fde8..e907738 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -865,6 +865,7 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 {
 	unsigned int mask = ~0x27; /* 444, 422, 420, GRAY */
 	struct v4l2_ctrl *ctrl;
+	int ret;
 
 	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
 
@@ -884,13 +885,24 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
 				      V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY, mask,
 				      V4L2_JPEG_CHROMA_SUBSAMPLING_422);
 
-	if (ctx->ctrl_handler.error)
-		return ctx->ctrl_handler.error;
+	if (ctx->ctrl_handler.error) {
+		ret = ctx->ctrl_handler.error;
+		goto error_free;
+	}
 
 	if (ctx->mode == S5P_JPEG_DECODE)
 		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
 			V4L2_CTRL_FLAG_READ_ONLY;
-	return 0;
+
+	ret = v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
+	if (ret < 0)
+		goto error_free;
+
+	return ret;
+
+error_free:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+	return ret;
 }
 
 static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
-- 
1.7.9.5


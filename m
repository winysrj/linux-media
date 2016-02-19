Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44182 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbcBSUAr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 15:00:47 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch] media: ti-vpe: cal: Fix warning: variable dereference before being checked
Date: Fri, 19 Feb 2016 14:00:30 -0600
Message-ID: <1455912030-28089-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported ctx->sensor is being dereferenced before being checked
in cal_get_external_info(). That being the case it was also checked
twice in multiple other location where v4l2_subdev_call is already
checking it so no need to explicitly check it again.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/cal.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 76d81b61ecb3..fa714bf1dce1 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -804,6 +804,9 @@ static int cal_get_external_info(struct cal_ctx *ctx)
 {
 	struct v4l2_ctrl *ctrl;
 
+	if (!ctx->sensor)
+		return -ENODEV;
+
 	ctrl = v4l2_ctrl_find(ctx->sensor->ctrl_handler, V4L2_CID_PIXEL_RATE);
 	if (!ctrl) {
 		ctx_err(ctx, "no pixel rate control in subdev: %s\n",
@@ -950,9 +953,6 @@ static int __subdev_get_format(struct cal_ctx *ctx,
 	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
 	int ret;
 
-	if (!ctx->sensor)
-		return -EINVAL;
-
 	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	sd_fmt.pad = 0;
 
@@ -975,9 +975,6 @@ static int __subdev_set_format(struct cal_ctx *ctx,
 	struct v4l2_mbus_framefmt *mbus_fmt = &sd_fmt.format;
 	int ret;
 
-	if (!ctx->sensor)
-		return -EINVAL;
-
 	sd_fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	sd_fmt.pad = 0;
 	*mbus_fmt = *fmt;
@@ -1152,7 +1149,7 @@ static int cal_enum_framesizes(struct file *file, void *fh,
 
 	ret = v4l2_subdev_call(ctx->sensor, pad, enum_frame_size, NULL, &fse);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	ctx_dbg(1, ctx, "%s: index: %d code: %x W:[%d,%d] H:[%d,%d]\n",
 		__func__, fse.index, fse.code, fse.min_width, fse.max_width,
@@ -1331,13 +1328,11 @@ static int cal_start_streaming(struct vb2_queue *vq, unsigned int count)
 	cal_wr_dma_addr(ctx, addr);
 	csi2_ppi_enable(ctx);
 
-	if (ctx->sensor) {
-		if (v4l2_subdev_call(ctx->sensor, video, s_stream, 1)) {
-			ctx_err(ctx, "stream on failed in subdev\n");
-			cal_runtime_put(ctx->dev);
-			ret = -EINVAL;
-			goto err;
-		}
+	ret = v4l2_subdev_call(ctx->sensor, video, s_stream, 1);
+	if (ret) {
+		ctx_err(ctx, "stream on failed in subdev\n");
+		cal_runtime_put(ctx->dev);
+		goto err;
 	}
 
 	if (debug >= 4)
@@ -1360,10 +1355,8 @@ static void cal_stop_streaming(struct vb2_queue *vq)
 	struct cal_buffer *buf, *tmp;
 	unsigned long flags;
 
-	if (ctx->sensor) {
-		if (v4l2_subdev_call(ctx->sensor, video, s_stream, 0))
-			ctx_err(ctx, "stream off failed in subdev\n");
-	}
+	if (v4l2_subdev_call(ctx->sensor, video, s_stream, 0))
+		ctx_err(ctx, "stream off failed in subdev\n");
 
 	csi2_ppi_disable(ctx);
 	disable_irqs(ctx);
-- 
2.7.1.287.g4943984


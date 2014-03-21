Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33871 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCUIhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Mar 2014 04:37:35 -0400
Received: by mail-pa0-f47.google.com with SMTP id lj1so2109405pab.34
        for <linux-media@vger.kernel.org>; Fri, 21 Mar 2014 01:37:34 -0700 (PDT)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH 2/3] [media] s5p-mfc: Extract open/close MFC instance commands.
Date: Fri, 21 Mar 2014 14:07:14 +0530
Message-Id: <1395391035-27349-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
References: <1395391035-27349-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

This is in preparation for a new flow to fix issues with streamon, which
should not be allocating buffer memory.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |   19 +-------
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c |   61 +++++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h |    3 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   28 +++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   18 ++------
 5 files changed, 74 insertions(+), 55 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index d636789..04030f5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -872,24 +872,7 @@ static int s5p_mfc_release(struct file *file)
 	 * return instance and free resources */
 	if (ctx->inst_no != MFC_NO_INSTANCE_SET) {
 		mfc_debug(2, "Has to free instance\n");
-		ctx->state = MFCINST_RETURN_INST;
-		set_work_bit_irqsave(ctx);
-		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-		/* Wait until instance is returned or timeout occurred */
-		if (s5p_mfc_wait_for_done_ctx
-		    (ctx, S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
-			s5p_mfc_clock_off();
-			mfc_err("Err returning instance\n");
-		}
-		mfc_debug(2, "After free instance\n");
-		/* Free resources */
-		s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
-		if (ctx->type == MFCINST_DECODER)
-			s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer,
-					ctx);
-
+		s5p_mfc_close_mfc_inst(dev, ctx);
 		ctx->inst_no = MFC_NO_INSTANCE_SET;
 	}
 	/* hardware locking scheme */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index ba1d302..ccbfcb3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -402,3 +402,64 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	return 0;
 }
 
+int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
+{
+	int ret = 0;
+
+	ret = s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer, ctx);
+	if (ret) {
+		mfc_err("Failed allocating instance buffer\n");
+		goto err;
+	}
+
+	if (ctx->type == MFCINST_DECODER) {
+		ret = s5p_mfc_hw_call(dev->mfc_ops,
+					alloc_dec_temp_buffers, ctx);
+		if (ret) {
+			mfc_err("Failed allocating temporary buffers\n");
+			goto err_free_inst_buf;
+		}
+	}
+
+	set_work_bit_irqsave(ctx);
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	if (s5p_mfc_wait_for_done_ctx(ctx,
+		S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
+		/* Error or timeout */
+		mfc_err("Error getting instance from hardware\n");
+		ret = -EIO;
+		goto err_free_desc_buf;
+	}
+
+	mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
+	return ret;
+
+err_free_desc_buf:
+	if (ctx->type == MFCINST_DECODER)
+		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
+err_free_inst_buf:
+	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
+err:
+	return ret;
+}
+
+void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
+{
+	ctx->state = MFCINST_RETURN_INST;
+	set_work_bit_irqsave(ctx);
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	/* Wait until instance is returned or timeout occurred */
+	if (s5p_mfc_wait_for_done_ctx(ctx,
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+		mfc_err("Err returning instance\n");
+
+	/* Free resources */
+	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
+	s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
+	if (ctx->type == MFCINST_DECODER)
+		s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer, ctx);
+
+	ctx->state = MFCINST_FREE;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
index 6a9b6f8..8e5df04 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
@@ -28,4 +28,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_reset(struct s5p_mfc_dev *dev);
 
+int s5p_mfc_open_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx);
+void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx);
+
 #endif /* S5P_MFC_CTRL_H */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 1ff82f2..efc78ae 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -25,6 +25,7 @@
 #include <media/v4l2-event.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
+#include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_intr.h"
@@ -674,36 +675,19 @@ static int vidioc_streamon(struct file *file, void *priv,
 
 	mfc_debug_enter();
 	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-
 		if (ctx->state == MFCINST_INIT) {
 			ctx->dst_bufs_cnt = 0;
 			ctx->src_bufs_cnt = 0;
 			ctx->capture_state = QUEUE_FREE;
 			ctx->output_state = QUEUE_FREE;
-			s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer,
-					ctx);
-			s5p_mfc_hw_call(dev->mfc_ops, alloc_dec_temp_buffers,
-					ctx);
-			set_work_bit_irqsave(ctx);
-			s5p_mfc_clean_ctx_int_flags(ctx);
-			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-
-			if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
-				/* Error or timeout */
-				mfc_err("Error getting instance from hardware\n");
-				s5p_mfc_hw_call(dev->mfc_ops,
-						release_instance_buffer, ctx);
-				s5p_mfc_hw_call(dev->mfc_ops,
-						release_dec_desc_buffer, ctx);
-				return -EIO;
-			}
-			mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
+			ret = s5p_mfc_open_mfc_inst(dev, ctx);
+			if (ret)
+				return ret;
 		}
 		ret = vb2_streamon(&ctx->vq_src, type);
-		}
-	else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+	} else if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		ret = vb2_streamon(&ctx->vq_dst, type);
+	}
 	mfc_debug_leave();
 	return ret;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index a67913e..f8c7053 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
+#include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
@@ -1112,20 +1113,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
 		ctx->dst_bufs_cnt = 0;
 		ctx->capture_state = QUEUE_FREE;
-		s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer, ctx);
-		set_work_bit_irqsave(ctx);
-		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
-		if (s5p_mfc_wait_for_done_ctx(ctx, \
-				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
-				/* Error or timeout */
-			mfc_err("Error getting instance from hardware\n");
-			s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer,
-					ctx);
-			ret = -EIO;
-			goto out;
-		}
-		mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
+		ret = s5p_mfc_open_mfc_inst(dev, ctx);
 	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		/* src_fmt is validated by call to vidioc_try_fmt */
 		ctx->src_fmt = find_format(f, MFC_FMT_RAW);
@@ -1146,7 +1134,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ctx->output_state = QUEUE_FREE;
 	} else {
 		mfc_err("invalid buf type\n");
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 out:
 	mfc_debug_leave();
-- 
1.7.9.5


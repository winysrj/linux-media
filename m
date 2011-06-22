Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31204 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab1FVSBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:01:39 -0400
Date: Wed, 22 Jun 2011 20:01:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 11/18] s5p-fimc: Add PM helper function for streaming control
In-reply-to: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1308765684-10677-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Create a helper function for (re)starting streaming in PM resume calls.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   80 ++++++++++++++++-----------
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 +-
 drivers/media/video/s5p-fimc/fimc-core.h    |    3 +
 3 files changed, 52 insertions(+), 35 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index f9beee8..a7d579d 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -31,6 +31,48 @@
 #include "fimc-mdevice.h"
 #include "fimc-core.h"
 
+/**
+ * fimc_start_capture - initialize the H/W for camera capture operation
+ *
+ * Initialize the camera capture datapath so when this function successfuly
+ * completes all what is needed to start the capture pipeline is asserting
+ * the global capture bit ImgCptEn.
+ */
+static int fimc_start_capture(struct fimc_dev *fimc)
+{
+	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
+	struct fimc_sensor_info *sensor;
+	unsigned long flags;
+	int ret = 0;
+
+	if (fimc->pipeline.sensor == NULL || ctx == NULL)
+		return -EIO;
+	sensor = v4l2_get_subdev_hostdata(fimc->pipeline.sensor);
+
+	spin_lock_irqsave(&fimc->slock, flags);
+	fimc_prepare_dma_offset(ctx, &ctx->d_frame);
+	fimc_set_yuv_order(ctx);
+
+	fimc_hw_set_camera_polarity(fimc, sensor->pdata);
+	fimc_hw_set_camera_type(fimc, sensor->pdata);
+	fimc_hw_set_camera_source(fimc, sensor->pdata);
+	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
+
+	ret = fimc_set_scaler_info(ctx);
+	if (!ret) {
+		fimc_hw_set_input_path(ctx);
+		fimc_hw_set_prescaler(ctx);
+		fimc_hw_set_mainscaler(ctx);
+		fimc_hw_set_target_format(ctx);
+		fimc_hw_set_rotation(ctx);
+		fimc_hw_set_effect(ctx);
+		fimc_hw_set_output_path(ctx);
+		fimc_hw_set_out_dma(ctx);
+	}
+	spin_unlock_irqrestore(&fimc->slock, flags);
+	return ret;
+}
+
 static int fimc_stop_capture(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -92,47 +134,19 @@ static int start_streaming(struct vb2_queue *q)
 {
 	struct fimc_ctx *ctx = q->drv_priv;
 	struct fimc_dev *fimc = ctx->fimc_dev;
-	struct s5p_fimc_isp_info *isp_info;
+	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
 	int ret;
 
 	fimc_hw_reset(fimc);
 
-	ret = v4l2_subdev_call(fimc->vid_cap.sd, video, s_stream, 1);
-	if (ret && ret != -ENOIOCTLCMD)
-		return ret;
+	vid_cap->active_buf_cnt = 0;
+	vid_cap->frame_count = 0;
+	vid_cap->buf_index = 0;
 
-	ret = fimc_prepare_config(ctx, ctx->state);
+	ret = fimc_start_capture(fimc);
 	if (ret)
 		return ret;
 
-	isp_info = &fimc->pdata->isp_info[fimc->vid_cap.input_index];
-	fimc_hw_set_camera_type(fimc, isp_info);
-	fimc_hw_set_camera_source(fimc, isp_info);
-	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
-
-	if (ctx->state & FIMC_PARAMS) {
-		ret = fimc_set_scaler_info(ctx);
-		if (ret) {
-			err("Scaler setup error");
-			return ret;
-		}
-		fimc_hw_set_input_path(ctx);
-		fimc_hw_set_prescaler(ctx);
-		fimc_hw_set_mainscaler(ctx);
-		fimc_hw_set_target_format(ctx);
-		fimc_hw_set_rotation(ctx);
-		fimc_hw_set_effect(ctx);
-	}
-
-	fimc_hw_set_output_path(ctx);
-	fimc_hw_set_out_dma(ctx);
-
-	INIT_LIST_HEAD(&fimc->vid_cap.pending_buf_q);
-	INIT_LIST_HEAD(&fimc->vid_cap.active_buf_q);
-	fimc->vid_cap.active_buf_cnt = 0;
-	fimc->vid_cap.frame_count = 0;
-	fimc->vid_cap.buf_index = 0;
-
 	set_bit(ST_CAPT_PEND, &fimc->state);
 	return 0;
 }
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 2aa4612..437d664 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -468,7 +468,7 @@ int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 }
 
 /* Set order for 1 and 2 plane YCBCR 4:2:2 formats. */
-static void fimc_set_yuv_order(struct fimc_ctx *ctx)
+void fimc_set_yuv_order(struct fimc_ctx *ctx)
 {
 	/* The one only mode supported in SoC. */
 	ctx->in_order_2p = S5P_FIMC_LSB_CRCB;
@@ -510,7 +510,7 @@ static void fimc_set_yuv_order(struct fimc_ctx *ctx)
 	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
 }
 
-static void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
+void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f)
 {
 	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
 	u32 i, depth = 0;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index d264f3f..d1d4e32 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -659,6 +659,9 @@ int fimc_set_scaler_info(struct fimc_ctx *ctx);
 int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
 int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,
 		      struct fimc_frame *frame, struct fimc_addr *paddr);
+void fimc_prepare_dma_offset(struct fimc_ctx *ctx, struct fimc_frame *f);
+void fimc_set_yuv_order(struct fimc_ctx *ctx);
+
 int fimc_register_m2m_device(struct fimc_dev *fimc,
 			     struct v4l2_device *v4l2_dev);
 void fimc_unregister_m2m_device(struct fimc_dev *fimc);
-- 
1.7.5.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14705 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760040Ab2D0JxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:23 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M34009Q9U4QCI@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:14 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400JZKU4R62@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:20 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 10/13] s5p-fimc: Minor cleanups
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-11-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   31 ++++++++++++++++-----------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 18f686a1..fde7033 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -31,7 +31,7 @@
 #include "fimc-core.h"
 #include "fimc-reg.h"
 
-static int fimc_init_capture(struct fimc_dev *fimc)
+static int fimc_capture_hw_init(struct fimc_dev *fimc)
 {
 	struct fimc_ctx *ctx = fimc->vid_cap.ctx;
 	struct fimc_pipeline *p = &fimc->pipeline;
@@ -73,7 +73,15 @@ static int fimc_init_capture(struct fimc_dev *fimc)
 	return ret;
 }
 
-static int fimc_capture_state_cleanup(struct fimc_dev *fimc, bool suspend)
+/*
+ * Reinitialize the driver so it is ready to start the streaming again.
+ * Set fimc->state to indicate stream off and the hardware shut down state.
+ * If not suspending (@suspend is false), return any buffers to videobuf2.
+ * Otherwise put any owned buffers onto the pending buffers queue, so they
+ * can be re-spun when the device is being resumed. Also perform FIMC
+ * software reset and disable streaming on the whole pipeline if required.
+ */
+static int fimc_capture_reinit(struct fimc_dev *fimc, bool suspend)
 {
 	struct fimc_vid_cap *cap = &fimc->vid_cap;
 	struct fimc_vid_buffer *buf;
@@ -146,9 +154,6 @@ static int fimc_capture_config_update(struct fimc_ctx *ctx)
 	struct fimc_dev *fimc = ctx->fimc_dev;
 	int ret;
 
-	if (!test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
-		return 0;
-
 	fimc_hw_set_camera_offset(fimc, &ctx->s_frame);
 
 	ret = fimc_set_scaler_info(ctx);
@@ -224,7 +229,8 @@ void fimc_capture_irq_handler(struct fimc_dev *fimc)
 		set_bit(ST_CAPT_RUN, &fimc->state);
 	}
 
-	fimc_capture_config_update(cap->ctx);
+	if (test_bit(ST_CAPT_APPLY_CFG, &fimc->state))
+		fimc_capture_config_update(cap->ctx);
 done:
 	if (cap->active_buf_cnt == 1) {
 		fimc_deactivate_capture(fimc);
@@ -246,9 +252,11 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 
 	vid_cap->frame_count = 0;
 
-	ret = fimc_init_capture(fimc);
-	if (ret)
-		goto error;
+	ret = fimc_capture_hw_init(fimc);
+	if (ret) {
+		fimc_capture_reinit(fimc, false);
+		return ret;
+	}
 
 	set_bit(ST_CAPT_PEND, &fimc->state);
 
@@ -263,9 +271,6 @@ static int start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 
 	return 0;
-error:
-	fimc_capture_state_cleanup(fimc, false);
-	return ret;
 }
 
 static int stop_streaming(struct vb2_queue *q)
@@ -304,7 +309,7 @@ int fimc_capture_resume(struct fimc_dev *fimc)
 	vid_cap->buf_index = 0;
 	fimc_pipeline_initialize(&fimc->pipeline, &vid_cap->vfd->entity,
 				 false);
-	fimc_init_capture(fimc);
+	fimc_capture_hw_init(fimc);
 
 	clear_bit(ST_CAPT_SUSPENDED, &fimc->state);
 
-- 
1.7.10


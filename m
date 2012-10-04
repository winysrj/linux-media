Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2JCRGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:06:20 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB00K5CU699FC0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:18 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBB009RUU5VQI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:18 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH v10 4/7] [media] s5p-mfc: Update MFCv5 driver for callback
 based architecture
Date: Thu, 04 Oct 2012 06:49:08 +0530
Message-id: <1349313551-23368-5-git-send-email-arun.kk@samsung.com>
In-reply-to: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
References: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modifies the driver to use a callback based architecture
for hardware dependent calls. This architecture is suitable
for supporting co-existence with newer versions of MFC hardware.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/media/platform/s5p-mfc/Makefile         |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  152 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c    |   24 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h    |   35 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c |   76 ++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h |   18 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   45 +++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |   35 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   86 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   72 +++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_intr.c   |   11 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   25 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |   84 +++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  419 +++++++++++++++++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h |   88 +-----
 18 files changed, 852 insertions(+), 326 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h

diff --git a/drivers/media/platform/s5p-mfc/Makefile b/drivers/media/platform/s5p-mfc/Makefile
index 39496b8..cfb9ee9 100644
--- a/drivers/media/platform/s5p-mfc/Makefile
+++ b/drivers/media/platform/s5p-mfc/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
-s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr_v5.o
+s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
-s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd_v5.o
+s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd.o
 s5p-mfc-y += s5p_mfc_pm.o
+s5p-mfc-y += s5p_mfc_opr_v5.o s5p_mfc_cmd_v5.o
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 74bb284..d711b0f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -22,13 +22,14 @@
 #include <media/v4l2-event.h>
 #include <linux/workqueue.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
+#include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr_v5.h"
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_pm.h"
 
 #define S5P_MFC_NAME		"s5p-mfc"
@@ -148,10 +149,12 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 		if (!ctx)
 			continue;
 		ctx->state = MFCINST_ERROR;
-		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
-		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
+				&ctx->vq_dst);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
+				&ctx->vq_src);
 		clear_work_bit(ctx);
-		wake_up_ctx(ctx, S5P_FIMV_R2H_CMD_ERR_RET, 0);
+		wake_up_ctx(ctx, S5P_MFC_R2H_CMD_ERR_RET, 0);
 	}
 	clear_bit(0, &dev->hw_lock);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -198,6 +201,7 @@ static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
 static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_buf *dst_buf;
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	ctx->state = MFCINST_FINISHED;
 	ctx->sequence++;
@@ -212,8 +216,8 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 		ctx->dst_queue_cnt--;
 		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
 
-		if (s5p_mfc_read_info_v5(ctx, PIC_TIME_TOP) ==
-			s5p_mfc_read_info_v5(ctx, PIC_TIME_BOT))
+		if (s5p_mfc_hw_call(dev->mfc_ops, get_pic_type_top, ctx) ==
+			s5p_mfc_hw_call(dev->mfc_ops, get_pic_type_bot, ctx))
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 		else
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
@@ -227,8 +231,11 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf, *src_buf;
-	size_t dec_y_addr = s5p_mfc_get_dec_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	size_t dec_y_addr;
+	unsigned int frame_type;
+
+	dec_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dec_y_adr, dev);
+	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
 
 	/* Copy timestamp / timecode from decoded src to dst and set
 	   appropraite flags */
@@ -264,10 +271,13 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf;
-	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	size_t dspl_y_addr;
+	unsigned int frame_type;
 	unsigned int index;
 
+	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
+	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_dec_frame_type, dev);
+
 	/* If frame is same as previous then skip and do not dequeue */
 	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED) {
 		if (!ctx->after_packed_pb)
@@ -284,8 +294,10 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
 			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
-			if (s5p_mfc_read_info_v5(ctx, PIC_TIME_TOP) ==
-				s5p_mfc_read_info_v5(ctx, PIC_TIME_BOT))
+			if (s5p_mfc_hw_call(dev->mfc_ops,
+					get_pic_type_top, ctx) ==
+				s5p_mfc_hw_call(dev->mfc_ops,
+					get_pic_type_bot, ctx))
 				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 			else
 				dst_buf->b->v4l2_buf.field =
@@ -316,21 +328,21 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 
 	unsigned int index;
 
-	dst_frame_status = s5p_mfc_get_dspl_status()
+	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
-	res_change = s5p_mfc_get_dspl_status()
+	res_change = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
 	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
 	if (ctx->state == MFCINST_RES_CHANGE_INIT)
 		ctx->state = MFCINST_RES_CHANGE_FLUSH;
 	if (res_change) {
 		ctx->state = MFCINST_RES_CHANGE_INIT;
-		s5p_mfc_clear_int_flags(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
 		s5p_mfc_clock_off();
-		s5p_mfc_try_run(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		return;
 	}
 	if (ctx->dpb_flush_flag)
@@ -364,9 +376,12 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		&& !list_empty(&ctx->src_queue)) {
 		src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 								list);
-		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
-		if (ctx->codec_mode != S5P_FIMV_CODEC_H264_DEC &&
-			s5p_mfc_get_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
+		ctx->consumed_stream += s5p_mfc_hw_call(dev->mfc_ops,
+						get_consumed_stream, dev);
+		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
+			s5p_mfc_hw_call(dev->mfc_ops,
+				get_dec_frame_type, dev) ==
+					S5P_FIMV_DECODE_FRAME_P_FRAME
 					&& ctx->consumed_stream + STUFF_BYTE <
 					src_buf->b->v4l2_planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
@@ -378,7 +393,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 			ctx->consumed_stream = 0;
 			list_del(&src_buf->list);
 			ctx->src_queue_cnt--;
-			if (s5p_mfc_err_dec(err) > 0)
+			if (s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) > 0)
 				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_ERROR);
 			else
 				vb2_buffer_done(src_buf->b, VB2_BUF_STATE_DONE);
@@ -389,12 +404,12 @@ leave_handle_frame:
 	if ((ctx->src_queue_cnt == 0 && ctx->state != MFCINST_FINISHING)
 				    || ctx->dst_queue_cnt < ctx->dpb_count)
 		clear_work_bit(ctx);
-	s5p_mfc_clear_int_flags(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
 	s5p_mfc_clock_off();
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 /* Error handling for interrupt */
@@ -411,7 +426,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
 
 	dev = ctx->dev;
 	mfc_err("Interrupt Error: %08x\n", err);
-	s5p_mfc_clear_int_flags(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_dev(dev, reason, err);
 
 	/* Error recovery is dependent on the state of context */
@@ -440,9 +455,11 @@ static void s5p_mfc_handle_error(struct s5p_mfc_ctx *ctx,
 		ctx->state = MFCINST_ERROR;
 		/* Mark all dst buffers as having an error */
 		spin_lock_irqsave(&dev->irqlock, flags);
-		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
+				&ctx->vq_dst);
 		/* Mark all src buffers as having an error */
-		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
+				&ctx->vq_src);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
@@ -469,8 +486,10 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		if (ctx->c_ops->post_seq_start(ctx))
 			mfc_err("post_seq_start() failed\n");
 	} else {
-		ctx->img_width = s5p_mfc_get_img_width();
-		ctx->img_height = s5p_mfc_get_img_height();
+		ctx->img_width = s5p_mfc_hw_call(dev->mfc_ops, get_img_width,
+				dev);
+		ctx->img_height = s5p_mfc_hw_call(dev->mfc_ops, get_img_height,
+				dev);
 
 		ctx->buf_width = ALIGN(ctx->img_width,
 						S5P_FIMV_NV12MT_HALIGN);
@@ -506,18 +525,19 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
 			ctx->mv_size = 0;
 		}
-		ctx->dpb_count = s5p_mfc_get_dpb_count();
+		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
+				dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
 			ctx->state = MFCINST_HEAD_PARSED;
 	}
-	s5p_mfc_clear_int_flags(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
 	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 		BUG();
 	s5p_mfc_clock_off();
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
 }
 
@@ -532,7 +552,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	if (ctx == NULL)
 		return;
 	dev = ctx->dev;
-	s5p_mfc_clear_int_flags(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -559,7 +579,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		s5p_mfc_clock_off();
 
 		wake_up(&ctx->queue);
-		s5p_mfc_try_run(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	} else {
 		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 			BUG();
@@ -601,7 +621,7 @@ static void s5p_mfc_handle_stream_complete(struct s5p_mfc_ctx *ctx,
 
 	s5p_mfc_clock_off();
 	wake_up(&ctx->queue);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 /* Interrupt processing */
@@ -617,81 +637,83 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	atomic_set(&dev->watchdog_cnt, 0);
 	ctx = dev->ctx[dev->curr_ctx];
 	/* Get the reason of interrupt and the error code */
-	reason = s5p_mfc_get_int_reason();
-	err = s5p_mfc_get_int_err();
+	reason = s5p_mfc_hw_call(dev->mfc_ops, get_int_reason, dev);
+	err = s5p_mfc_hw_call(dev->mfc_ops, get_int_err, dev);
 	mfc_debug(1, "Int reason: %d (err: %08x)\n", reason, err);
 	switch (reason) {
-	case S5P_FIMV_R2H_CMD_ERR_RET:
+	case S5P_MFC_R2H_CMD_ERR_RET:
 		/* An error has occured */
 		if (ctx->state == MFCINST_RUNNING &&
-			s5p_mfc_err_dec(err) >= S5P_FIMV_ERR_WARNINGS_START)
+			s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) >=
+				dev->warn_start)
 			s5p_mfc_handle_frame(ctx, reason, err);
 		else
 			s5p_mfc_handle_error(ctx, reason, err);
 		clear_bit(0, &dev->enter_suspend);
 		break;
 
-	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
-	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
+	case S5P_MFC_R2H_CMD_SLICE_DONE_RET:
+	case S5P_MFC_R2H_CMD_FIELD_DONE_RET:
+	case S5P_MFC_R2H_CMD_FRAME_DONE_RET:
 		if (ctx->c_ops->post_frame_start) {
 			if (ctx->c_ops->post_frame_start(ctx))
 				mfc_err("post_frame_start() failed\n");
-			s5p_mfc_clear_int_flags(dev);
+			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
 			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
 				BUG();
 			s5p_mfc_clock_off();
-			s5p_mfc_try_run(dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			s5p_mfc_handle_frame(ctx, reason, err);
 		}
 		break;
 
-	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+	case S5P_MFC_R2H_CMD_SEQ_DONE_RET:
 		s5p_mfc_handle_seq_done(ctx, reason, err);
 		break;
 
-	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
-		ctx->inst_no = s5p_mfc_get_inst_no();
+	case S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_hw_call(dev->mfc_ops, get_inst_no, dev);
 		ctx->state = MFCINST_GOT_INST;
 		clear_work_bit(ctx);
 		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
 
-	case S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET:
+	case S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET:
 		clear_work_bit(ctx);
 		ctx->state = MFCINST_FREE;
 		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
 
-	case S5P_FIMV_R2H_CMD_SYS_INIT_RET:
-	case S5P_FIMV_R2H_CMD_FW_STATUS_RET:
-	case S5P_FIMV_R2H_CMD_SLEEP_RET:
-	case S5P_FIMV_R2H_CMD_WAKEUP_RET:
+	case S5P_MFC_R2H_CMD_SYS_INIT_RET:
+	case S5P_MFC_R2H_CMD_FW_STATUS_RET:
+	case S5P_MFC_R2H_CMD_SLEEP_RET:
+	case S5P_MFC_R2H_CMD_WAKEUP_RET:
 		if (ctx)
 			clear_work_bit(ctx);
-		s5p_mfc_clear_int_flags(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_dev(dev, reason, err);
 		clear_bit(0, &dev->hw_lock);
 		clear_bit(0, &dev->enter_suspend);
 		break;
 
-	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
+	case S5P_MFC_R2H_CMD_INIT_BUFFERS_RET:
 		s5p_mfc_handle_init_buffers(ctx, reason, err);
 		break;
 
-	case S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET:
+	case S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET:
 		s5p_mfc_handle_stream_complete(ctx, reason, err);
 		break;
 
 	default:
 		mfc_debug(2, "Unknown int reason\n");
-		s5p_mfc_clear_int_flags(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	}
 	mfc_debug_leave();
 	return IRQ_HANDLED;
 irq_cleanup_hw:
-	s5p_mfc_clear_int_flags(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	ctx->int_type = reason;
 	ctx->int_err = err;
 	ctx->int_cond = 1;
@@ -700,7 +722,7 @@ irq_cleanup_hw:
 
 	s5p_mfc_clock_off();
 
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	mfc_debug(2, "Exit via irq_cleanup_hw\n");
 	return IRQ_HANDLED;
 }
@@ -748,6 +770,7 @@ static int s5p_mfc_open(struct file *file)
 	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
 		ctx->type = MFCINST_DECODER;
 		ctx->c_ops = get_dec_codec_ops();
+		s5p_mfc_dec_init(ctx);
 		/* Setup ctrl handler */
 		ret = s5p_mfc_dec_ctrls_setup(ctx);
 		if (ret) {
@@ -760,6 +783,7 @@ static int s5p_mfc_open(struct file *file)
 		/* only for encoder */
 		INIT_LIST_HEAD(&ctx->ref_queue);
 		ctx->ref_queue_cnt = 0;
+		s5p_mfc_enc_init(ctx);
 		/* Setup ctrl handler */
 		ret = s5p_mfc_enc_ctrls_setup(ctx);
 		if (ret) {
@@ -885,19 +909,20 @@ static int s5p_mfc_release(struct file *file)
 		ctx->state = MFCINST_RETURN_INST;
 		set_work_bit_irqsave(ctx);
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_try_run(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		/* Wait until instance is returned or timeout occured */
 		if (s5p_mfc_wait_for_done_ctx
-		    (ctx, S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
+		    (ctx, S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
 			s5p_mfc_clock_off();
 			mfc_err("Err returning instance\n");
 		}
 		mfc_debug(2, "After free instance\n");
 		/* Free resources */
-		s5p_mfc_release_codec_buffers(ctx);
-		s5p_mfc_release_instance_buffer(ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer, ctx);
 		if (ctx->type == MFCINST_DECODER)
-			s5p_mfc_release_dec_desc_buffer(ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, release_dec_desc_buffer,
+					ctx);
 
 		ctx->inst_no = MFC_NO_INSTANCE_SET;
 	}
@@ -909,6 +934,7 @@ static int s5p_mfc_release(struct file *file)
 		mfc_debug(2, "Last instance - release firmware\n");
 		/* reset <-> F/W release */
 		s5p_mfc_reset(dev);
+		s5p_mfc_deinit_hw(dev);
 		s5p_mfc_release_firmware(dev);
 		del_timer_sync(&dev->watchdog_timer);
 		if (s5p_mfc_power_off() < 0)
@@ -1159,6 +1185,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->watchdog_timer.data = (unsigned long)dev;
 	dev->watchdog_timer.function = s5p_mfc_watchdog;
 
+	/* Initialize HW ops and commands based on MFC version */
+	s5p_mfc_init_hw_ops(dev);
+	s5p_mfc_init_hw_cmds(dev);
+
 	pr_debug("%s--\n", __func__);
 	return 0;
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
new file mode 100644
index 0000000..8ea304b
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
@@ -0,0 +1,24 @@
+/*
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_cmd_v5.h"
+
+static struct s5p_mfc_hw_cmds *s5p_mfc_cmds;
+
+void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v5();
+	dev->mfc_cmds = s5p_mfc_cmds;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
new file mode 100644
index 0000000..282e6c7
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
@@ -0,0 +1,35 @@
+/*
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
+ *
+ * Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef S5P_MFC_CMD_H_
+#define S5P_MFC_CMD_H_
+
+#include "s5p_mfc_common.h"
+
+#define MAX_H2R_ARG	4
+
+struct s5p_mfc_cmd_args {
+	unsigned int	arg[MAX_H2R_ARG];
+};
+
+struct s5p_mfc_hw_cmds {
+	int (*cmd_host2risc)(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args);
+	int (*sys_init_cmd)(struct s5p_mfc_dev *dev);
+	int (*sleep_cmd)(struct s5p_mfc_dev *dev);
+	int (*wakeup_cmd)(struct s5p_mfc_dev *dev);
+	int (*open_inst_cmd)(struct s5p_mfc_ctx *ctx);
+	int (*close_inst_cmd)(struct s5p_mfc_ctx *ctx);
+};
+
+void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev);
+#endif /* S5P_MFC_CMD_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
index cdd02b9..e4eb956 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.c
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
@@ -11,13 +11,13 @@
  */
 
 #include "regs-mfc.h"
-#include "s5p_mfc_cmd_v5.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 
 /* This function is used to send a command to the MFC */
-static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
-						struct s5p_mfc_cmd_args *args)
+int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args)
 {
 	int cur_cmd;
 	unsigned long timeout;
@@ -41,35 +41,37 @@ static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
 }
 
 /* Initialize the MFC */
-int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev)
+int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
 	h2r_args.arg[0] = dev->fw_size;
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SYS_INIT, &h2r_args);
+	return s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_SYS_INIT,
+			&h2r_args);
 }
 
 /* Suspend the MFC hardware */
-int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev)
+int s5p_mfc_sleep_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
+	return s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
 }
 
 /* Wake up the MFC hardware */
-int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev)
+int s5p_mfc_wakeup_cmd_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_cmd_args h2r_args;
 
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_WAKEUP, &h2r_args);
+	return s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_WAKEUP,
+			&h2r_args);
 }
 
 
-int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
@@ -79,11 +81,41 @@ int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Getting instance number (codec: %d)\n", ctx->codec_mode);
 	dev->curr_ctx = ctx->num;
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	h2r_args.arg[0] = ctx->codec_mode;
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_H264_DEC;
+		break;
+	case S5P_MFC_CODEC_VC1_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_VC1_DEC;
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_MPEG4_DEC;
+		break;
+	case S5P_MFC_CODEC_MPEG2_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_MPEG2_DEC;
+		break;
+	case S5P_MFC_CODEC_H263_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_H263_DEC;
+		break;
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_VC1RCV_DEC;
+		break;
+	case S5P_MFC_CODEC_H264_ENC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_H264_ENC;
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_MPEG4_ENC;
+		break;
+	case S5P_MFC_CODEC_H263_ENC:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_H263_ENC;
+		break;
+	default:
+		h2r_args.arg[0] = S5P_FIMV_CODEC_NONE;
+	};
 	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
 	h2r_args.arg[2] = ctx->ctx_ofs;
 	h2r_args.arg[3] = ctx->ctx_size;
-	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
+	ret = s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
 								&h2r_args);
 	if (ret) {
 		mfc_err("Failed to create a new instance\n");
@@ -92,7 +124,7 @@ int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
 	return ret;
 }
 
-int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_close_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_cmd_args h2r_args;
@@ -108,7 +140,7 @@ int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
 	dev->curr_ctx = ctx->num;
 	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
 	h2r_args.arg[0] = ctx->inst_no;
-	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
+	ret = s5p_mfc_cmd_host2risc_v5(dev, S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
 								&h2r_args);
 	if (ret) {
 		mfc_err("Failed to return an instance\n");
@@ -118,3 +150,17 @@ int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
+/* Initialize cmd function pointers for MFC v5 */
+static struct s5p_mfc_hw_cmds s5p_mfc_cmds_v5 = {
+	.cmd_host2risc = s5p_mfc_cmd_host2risc_v5,
+	.sys_init_cmd = s5p_mfc_sys_init_cmd_v5,
+	.sleep_cmd = s5p_mfc_sleep_cmd_v5,
+	.wakeup_cmd = s5p_mfc_wakeup_cmd_v5,
+	.open_inst_cmd = s5p_mfc_open_inst_cmd_v5,
+	.close_inst_cmd = s5p_mfc_close_inst_cmd_v5,
+};
+
+struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v5(void)
+{
+	return &s5p_mfc_cmds_v5;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
index 8b090d3..6928a55 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.h
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v5.h
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com/
@@ -10,21 +10,11 @@
  * (at your option) any later version.
  */
 
-#ifndef S5P_MFC_CMD_H_
-#define S5P_MFC_CMD_H_
+#ifndef S5P_MFC_CMD_V5_H_
+#define S5P_MFC_CMD_V5_H_
 
 #include "s5p_mfc_common.h"
 
-#define MAX_H2R_ARG	4
-
-struct s5p_mfc_cmd_args {
-	unsigned int	arg[MAX_H2R_ARG];
-};
-
-int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev);
-int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev);
-int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev);
-int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx);
-int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx);
+struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v5(void);
 
 #endif /* S5P_MFC_CMD_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 519b0d6..82931d4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -74,7 +74,40 @@ static inline dma_addr_t s5p_mfc_mem_cookie(void *a, void *b)
 #define MFC_ENC_CAP_PLANE_COUNT	1
 #define MFC_ENC_OUT_PLANE_COUNT	2
 #define STUFF_BYTE		4
-#define MFC_MAX_CTRLS		64
+#define MFC_MAX_CTRLS		70
+
+#define S5P_MFC_CODEC_NONE		-1
+#define S5P_MFC_CODEC_H264_DEC		0
+#define S5P_MFC_CODEC_H264_MVC_DEC	1
+#define S5P_MFC_CODEC_VC1_DEC		2
+#define S5P_MFC_CODEC_MPEG4_DEC		3
+#define S5P_MFC_CODEC_MPEG2_DEC		4
+#define S5P_MFC_CODEC_H263_DEC		5
+#define S5P_MFC_CODEC_VC1RCV_DEC	6
+#define S5P_MFC_CODEC_VP8_DEC		7
+
+#define S5P_MFC_CODEC_H264_ENC		20
+#define S5P_MFC_CODEC_H264_MVC_ENC	21
+#define S5P_MFC_CODEC_MPEG4_ENC		22
+#define S5P_MFC_CODEC_H263_ENC		23
+
+#define S5P_MFC_R2H_CMD_EMPTY			0
+#define S5P_MFC_R2H_CMD_SYS_INIT_RET		1
+#define S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET	2
+#define S5P_MFC_R2H_CMD_SEQ_DONE_RET		3
+#define S5P_MFC_R2H_CMD_INIT_BUFFERS_RET	4
+#define S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET	6
+#define S5P_MFC_R2H_CMD_SLEEP_RET		7
+#define S5P_MFC_R2H_CMD_WAKEUP_RET		8
+#define S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET	9
+#define S5P_MFC_R2H_CMD_DPB_FLUSH_RET		10
+#define S5P_MFC_R2H_CMD_NAL_ABORT_RET		11
+#define S5P_MFC_R2H_CMD_FW_STATUS_RET		12
+#define S5P_MFC_R2H_CMD_FRAME_DONE_RET		13
+#define S5P_MFC_R2H_CMD_FIELD_DONE_RET		14
+#define S5P_MFC_R2H_CMD_SLICE_DONE_RET		15
+#define S5P_MFC_R2H_CMD_ENC_BUFFER_FUL_RET	16
+#define S5P_MFC_R2H_CMD_ERR_RET			32
 
 #define mfc_read(dev, offset)		readl(dev->regs_base + (offset))
 #define mfc_write(dev, data, offset)	writel((data), dev->regs_base + \
@@ -212,6 +245,9 @@ struct s5p_mfc_pm {
  * @watchdog_work:	worker for the watchdog
  * @alloc_ctx:		videobuf2 allocator contexts for two memory banks
  * @enter_suspend:	flag set when entering suspend
+ * @warn_start:		hardware error code from which warnings start
+ * @mfc_ops:		ops structure holding HW operation function pointers
+ * @mfc_cmds:		cmd structure holding HW commands function pointers
  *
  */
 struct s5p_mfc_dev {
@@ -248,6 +284,10 @@ struct s5p_mfc_dev {
 	struct work_struct watchdog_work;
 	void *alloc_ctx[2];
 	unsigned long enter_suspend;
+
+	int warn_start;
+	struct s5p_mfc_hw_ops *mfc_ops;
+	struct s5p_mfc_hw_cmds *mfc_cmds;
 };
 
 /**
@@ -565,6 +605,9 @@ struct mfc_control {
 	__u8			is_volatile;
 };
 
+/* Macro for making hardware specific calls */
+#define s5p_mfc_hw_call(f, op, args...) \
+	((f && f->op) ? f->op(args) : -ENODEV)
 
 #define fh_to_ctx(__fh) container_of(__fh, struct s5p_mfc_ctx, fh)
 #define ctrl_to_ctx(__ctrl) \
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index f31bff9..7666e94 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -15,11 +15,11 @@
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
 #include <linux/sched.h>
-#include "regs-mfc.h"
-#include "s5p_mfc_cmd_v5.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
+#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
 
 static void *s5p_mfc_bitproc_buf;
@@ -230,7 +230,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clean_dev_int_flags(dev);
 	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_FW_STATUS_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
 		mfc_err("Failed to load firmware\n");
 		s5p_mfc_reset(dev);
 		s5p_mfc_clock_off();
@@ -238,7 +238,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	}
 	s5p_mfc_clean_dev_int_flags(dev);
 	/* 4. Initialize firmware */
-	ret = s5p_mfc_sys_init_cmd(dev);
+	ret = s5p_mfc_hw_call(dev->mfc_cmds, sys_init_cmd, dev);
 	if (ret) {
 		mfc_err("Failed to send command to MFC - timeout\n");
 		s5p_mfc_reset(dev);
@@ -246,7 +246,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	mfc_debug(2, "Ok, now will write a command to init the system\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SYS_INIT_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_SYS_INIT_RET)) {
 		mfc_err("Failed to load firmware\n");
 		s5p_mfc_reset(dev);
 		s5p_mfc_clock_off();
@@ -254,7 +254,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	}
 	dev->int_cond = 0;
 	if (dev->int_err != 0 || dev->int_type !=
-					S5P_FIMV_R2H_CMD_SYS_INIT_RET) {
+					S5P_MFC_R2H_CMD_SYS_INIT_RET) {
 		/* Failure. */
 		mfc_err("Failed to init firmware - error: %d int: %d\n",
 						dev->int_err, dev->int_type);
@@ -271,6 +271,17 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 }
 
 
+/* Deinitialize hardware */
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_clock_on();
+
+	s5p_mfc_reset(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, release_dev_context_buffer, dev);
+
+	s5p_mfc_clock_off();
+}
+
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
 {
 	int ret;
@@ -278,19 +289,19 @@ int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 	s5p_mfc_clock_on();
 	s5p_mfc_clean_dev_int_flags(dev);
-	ret = s5p_mfc_sleep_cmd(dev);
+	ret = s5p_mfc_hw_call(dev->mfc_cmds, sleep_cmd, dev);
 	if (ret) {
 		mfc_err("Failed to send command to MFC - timeout\n");
 		return ret;
 	}
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SLEEP_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_SLEEP_RET)) {
 		mfc_err("Failed to sleep\n");
 		return -EIO;
 	}
 	s5p_mfc_clock_off();
 	dev->int_cond = 0;
 	if (dev->int_err != 0 || dev->int_type !=
-						S5P_FIMV_R2H_CMD_SLEEP_RET) {
+						S5P_MFC_R2H_CMD_SLEEP_RET) {
 		/* Failure. */
 		mfc_err("Failed to sleep - error: %d int: %d\n", dev->int_err,
 								dev->int_type);
@@ -320,7 +331,7 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	s5p_mfc_clear_cmds(dev);
 	s5p_mfc_clean_dev_int_flags(dev);
 	/* 3. Initialize firmware */
-	ret = s5p_mfc_wakeup_cmd(dev);
+	ret = s5p_mfc_hw_call(dev->mfc_cmds, wakeup_cmd, dev);
 	if (ret) {
 		mfc_err("Failed to send command to MFC - timeout\n");
 		return ret;
@@ -328,14 +339,14 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 	/* 4. Release reset signal to the RISC */
 	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_WAKEUP_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
 		mfc_err("Failed to load firmware\n");
 		return -EIO;
 	}
 	s5p_mfc_clock_off();
 	dev->int_cond = 0;
 	if (dev->int_err != 0 || dev->int_type !=
-						S5P_FIMV_R2H_CMD_WAKEUP_RET) {
+						S5P_MFC_R2H_CMD_WAKEUP_RET) {
 		/* Failure. */
 		mfc_err("Failed to wakeup - error: %d int: %d\n", dev->int_err,
 								dev->int_type);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
index e1e0c54..90aa9b9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.h
@@ -20,6 +20,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev);
 int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev);
 int s5p_mfc_wakeup(struct s5p_mfc_dev *dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 653f14b..107609c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -23,82 +23,84 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr_v5.h"
+#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
 
+#define DEF_SRC_FMT_DEC	V4L2_PIX_FMT_H264
+#define DEF_DST_FMT_DEC	V4L2_PIX_FMT_NV12MT
+
 static struct s5p_mfc_fmt formats[] = {
 	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
-		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-	 },
+	},
 	{
 		.name = "4:2:0 2 Planes",
 		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.codec_mode = S5P_MFC_CODEC_NONE,
 		.type = MFC_FMT_RAW,
 		.num_planes = 2,
 	},
 	{
 		.name = "H264 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_DEC,
+		.codec_mode = S5P_MFC_CODEC_H264_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "H263 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_DEC,
+		.codec_mode = S5P_MFC_CODEC_H263_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "MPEG1 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG1,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
+		.codec_mode = S5P_MFC_CODEC_MPEG2_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "MPEG2 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG2,
-		.codec_mode = S5P_FIMV_CODEC_MPEG2_DEC,
+		.codec_mode = S5P_MFC_CODEC_MPEG2_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "MPEG4 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+		.codec_mode = S5P_MFC_CODEC_MPEG4_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "XviD Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_XVID,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_DEC,
+		.codec_mode = S5P_MFC_CODEC_MPEG4_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "VC1 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_G,
-		.codec_mode = S5P_FIMV_CODEC_VC1_DEC,
+		.codec_mode = S5P_MFC_CODEC_VC1_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
 	{
 		.name = "VC1 RCV Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_L,
-		.codec_mode = S5P_FIMV_CODEC_VC1RCV_DEC,
+		.codec_mode = S5P_MFC_CODEC_VC1RCV_DEC,
 		.type = MFC_FMT_DEC,
 		.num_planes = 1,
 	},
@@ -296,7 +298,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		/* If the MFC is parsing the header,
 		 * so wait until it is finished */
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_SEQ_DONE_RET,
 									0);
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
@@ -379,7 +381,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt || fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
+	if (!fmt || fmt->codec_mode == S5P_MFC_CODEC_NONE) {
 		mfc_err("Unknown codec\n");
 		ret = -EINVAL;
 		goto out;
@@ -475,7 +477,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return -ENOMEM;
 		}
 		ctx->total_dpb_count = reqbufs->count;
-		ret = s5p_mfc_alloc_codec_buffers(ctx);
+		ret = s5p_mfc_hw_call(dev->mfc_ops, alloc_codec_buffers, ctx);
 		if (ret) {
 			mfc_err("Failed to allocate decoding buffers\n");
 			reqbufs->count = 0;
@@ -491,15 +493,16 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			reqbufs->count = 0;
 			s5p_mfc_clock_on();
 			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			s5p_mfc_release_codec_buffers(ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers,
+					ctx);
 			s5p_mfc_clock_off();
 			return -ENOMEM;
 		}
 		if (s5p_mfc_ctx_ready(ctx))
 			set_work_bit_irqsave(ctx);
-		s5p_mfc_try_run(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		s5p_mfc_wait_for_done_ctx(ctx,
-					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+					S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
 	}
 	return ret;
 }
@@ -581,18 +584,22 @@ static int vidioc_streamon(struct file *file, void *priv,
 			ctx->src_bufs_cnt = 0;
 			ctx->capture_state = QUEUE_FREE;
 			ctx->output_state = QUEUE_FREE;
-			s5p_mfc_alloc_instance_buffer(ctx);
-			s5p_mfc_alloc_dec_temp_buffers(ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer,
+					ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, alloc_dec_temp_buffers,
+					ctx);
 			set_work_bit_irqsave(ctx);
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			s5p_mfc_try_run(dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 
 			if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
 				/* Error or timeout */
 				mfc_err("Error getting instance from hardware\n");
-				s5p_mfc_release_instance_buffer(ctx);
-				s5p_mfc_release_dec_desc_buffer(ctx);
+				s5p_mfc_hw_call(dev->mfc_ops,
+						release_instance_buffer, ctx);
+				s5p_mfc_hw_call(dev->mfc_ops,
+						release_dec_desc_buffer, ctx);
 				return -EIO;
 			}
 			mfc_debug(2, "Got instance number: %d\n", ctx->inst_no);
@@ -661,7 +668,7 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 		/* Should wait for the header to be parsed */
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
 		    ctx->state < MFCINST_ABORT) {
 			ctrl->val = ctx->dpb_count;
@@ -685,6 +692,7 @@ static int vidioc_g_crop(struct file *file, void *priv,
 		struct v4l2_crop *cr)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 	u32 left, right, top, bottom;
 
 	if (ctx->state != MFCINST_HEAD_PARSED &&
@@ -694,10 +702,10 @@ static int vidioc_g_crop(struct file *file, void *priv,
 			return -EINVAL;
 		}
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
-		left = s5p_mfc_read_info_v5(ctx, CROP_INFO_H);
+		left = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_h, ctx);
 		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
 		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
-		top = s5p_mfc_read_info_v5(ctx, CROP_INFO_V);
+		top = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_v, ctx);
 		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
 		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
 		cr->c.left = left;
@@ -875,7 +883,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	return 0;
 }
 
@@ -891,19 +899,21 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
 		s5p_mfc_wait_for_done_ctx(ctx,
-					S5P_FIMV_R2H_CMD_FRAME_DONE_RET, 0);
+					S5P_MFC_R2H_CMD_FRAME_DONE_RET, 0);
 		aborted = 1;
 	}
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
+				&ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 		ctx->dpb_flush_flag = 1;
 		ctx->dec_dst_flag = 0;
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
+				&ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
 	}
@@ -943,7 +953,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_dec_qops = {
@@ -1027,3 +1037,13 @@ void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx)
 		ctx->ctrls[i] = NULL;
 }
 
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
+{
+	struct v4l2_format f;
+	f.fmt.pix_mp.pixelformat = DEF_SRC_FMT_DEC;
+	ctx->src_fmt = find_format(&f, MFC_FMT_DEC);
+	f.fmt.pix_mp.pixelformat = DEF_DST_FMT_DEC;
+	ctx->dst_fmt = find_format(&f, MFC_FMT_RAW);
+	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
+			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
index fdf1d99..d06a7ca 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_dec_def_fmt(bool src);
 int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_DEC_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index f5f7e3c..3b0e594 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -25,46 +25,48 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr_v5.h"
+#include "s5p_mfc_opr.h"
+
+#define DEF_SRC_FMT_ENC	V4L2_PIX_FMT_NV12MT
+#define DEF_DST_FMT_ENC	V4L2_PIX_FMT_H264
 
 static struct s5p_mfc_fmt formats[] = {
 	{
 		.name = "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc = V4L2_PIX_FMT_NV12MT,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.codec_mode = S5P_MFC_CODEC_NONE,
 		.type = MFC_FMT_RAW,
 		.num_planes = 2,
 	},
 	{
 		.name = "4:2:0 2 Planes",
 		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_FIMV_CODEC_NONE,
+		.codec_mode = S5P_MFC_CODEC_NONE,
 		.type = MFC_FMT_RAW,
 		.num_planes = 2,
 	},
 	{
 		.name = "H264 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_FIMV_CODEC_H264_ENC,
+		.codec_mode = S5P_MFC_CODEC_H264_ENC,
 		.type = MFC_FMT_ENC,
 		.num_planes = 1,
 	},
 	{
 		.name = "MPEG4 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_FIMV_CODEC_MPEG4_ENC,
+		.codec_mode = S5P_MFC_CODEC_MPEG4_ENC,
 		.type = MFC_FMT_ENC,
 		.num_planes = 1,
 	},
 	{
 		.name = "H263 Encoded Stream",
 		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_FIMV_CODEC_H263_ENC,
+		.codec_mode = S5P_MFC_CODEC_H263_ENC,
 		.type = MFC_FMT_ENC,
 		.num_planes = 1,
 	},
@@ -619,7 +621,8 @@ static int enc_pre_seq_start(struct s5p_mfc_ctx *ctx)
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	return 0;
 }
@@ -638,14 +641,14 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		list_del(&dst_mb->list);
 		ctx->dst_queue_cnt--;
 		vb2_set_plane_payload(dst_mb->b, 0,
-						s5p_mfc_get_enc_strm_size());
+			s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev));
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
 	ctx->state = MFCINST_RUNNING;
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	return 0;
 }
 
@@ -662,14 +665,16 @@ static int enc_pre_frame_start(struct s5p_mfc_ctx *ctx)
 	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
 	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
-	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_frame_buffer, ctx, src_y_addr,
+			src_c_addr);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+	s5p_mfc_hw_call(dev->mfc_ops, set_enc_stream_buffer, ctx, dst_addr,
+			dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 
 	return 0;
@@ -685,15 +690,16 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned int strm_size;
 	unsigned long flags;
 
-	slice_type = s5p_mfc_get_enc_slice_type();
-	strm_size = s5p_mfc_get_enc_strm_size();
+	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
+	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
 	mfc_debug(2, "Encoded slice type: %d", slice_type);
 	mfc_debug(2, "Encoded stream size: %d", strm_size);
 	mfc_debug(2, "Display order: %d",
 		  mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT));
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (slice_type >= 0) {
-		s5p_mfc_get_enc_frame_buffer(ctx, &enc_y_addr, &enc_c_addr);
+		s5p_mfc_hw_call(dev->mfc_ops, get_enc_frame_buffer, ctx,
+				&enc_y_addr, &enc_c_addr);
 		list_for_each_entry(mb_entry, &ctx->src_queue, list) {
 			mb_y_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 0);
 			mb_c_addr = vb2_dma_contig_plane_dma_addr(mb_entry->b, 1);
@@ -939,15 +945,16 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		pix_fmt_mp->plane_fmt[0].bytesperline = 0;
 		ctx->dst_bufs_cnt = 0;
 		ctx->capture_state = QUEUE_FREE;
-		s5p_mfc_alloc_instance_buffer(ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, alloc_instance_buffer, ctx);
 		set_work_bit_irqsave(ctx);
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_try_run(dev);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		if (s5p_mfc_wait_for_done_ctx(ctx, \
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
 				/* Error or timeout */
 			mfc_err("Error getting instance from hardware\n");
-			s5p_mfc_release_instance_buffer(ctx);
+			s5p_mfc_hw_call(dev->mfc_ops, release_instance_buffer,
+					ctx);
 			ret = -EIO;
 			goto out;
 		}
@@ -1042,7 +1049,8 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return ret;
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
-		ret = s5p_mfc_alloc_codec_buffers(ctx);
+		ret = s5p_mfc_hw_call(ctx->dev->mfc_ops, alloc_codec_buffers,
+				ctx);
 		if (ret) {
 			mfc_err("Failed to allocate encoding buffers\n");
 			reqbufs->count = 0;
@@ -1500,7 +1508,7 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
 			mfc_debug(2, "EOS: empty src queue, entering finishing state");
 			ctx->state = MFCINST_FINISHING;
 			spin_unlock_irqrestore(&dev->irqlock, flags);
-			s5p_mfc_try_run(dev);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			mfc_debug(2, "EOS: marking last buffer of stream");
 			buf = list_entry(ctx->src_queue.prev,
@@ -1715,7 +1723,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	return 0;
 }
 
@@ -1729,19 +1737,21 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		ctx->state == MFCINST_RUNNING) &&
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_FRAME_DONE_RET,
 					  0);
 	}
 	ctx->state = MFCINST_FINISHED;
 	spin_lock_irqsave(&dev->irqlock, flags);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->dst_queue,
+				&ctx->vq_dst);
 		INIT_LIST_HEAD(&ctx->dst_queue);
 		ctx->dst_queue_cnt = 0;
 	}
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		cleanup_ref_queue(ctx);
-		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
+		s5p_mfc_hw_call(dev->mfc_ops, cleanup_queue, &ctx->src_queue,
+				&ctx->vq_src);
 		INIT_LIST_HEAD(&ctx->src_queue);
 		ctx->src_queue_cnt = 0;
 	}
@@ -1782,7 +1792,7 @@ static void s5p_mfc_buf_queue(struct vb2_buffer *vb)
 	}
 	if (s5p_mfc_ctx_ready(ctx))
 		set_work_bit_irqsave(ctx);
-	s5p_mfc_try_run(dev);
+	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 }
 
 static struct vb2_ops s5p_mfc_enc_qops = {
@@ -1880,3 +1890,13 @@ void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx)
 	for (i = 0; i < NUM_CTRLS; i++)
 		ctx->ctrls[i] = NULL;
 }
+
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx)
+{
+	struct v4l2_format f;
+	f.fmt.pix_mp.pixelformat = DEF_SRC_FMT_ENC;
+	ctx->src_fmt = find_format(&f, MFC_FMT_RAW);
+	f.fmt.pix_mp.pixelformat = DEF_DST_FMT_ENC;
+	ctx->dst_fmt = find_format(&f, MFC_FMT_ENC);
+}
+
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
index ca9fd66..5118d46 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
 int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_ENC_H_  */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
index 37860e2..5b8f0e0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_intr.c
@@ -17,7 +17,6 @@
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
@@ -28,7 +27,7 @@ int s5p_mfc_wait_for_done_dev(struct s5p_mfc_dev *dev, int command)
 
 	ret = wait_event_interruptible_timeout(dev->queue,
 		(dev->int_cond && (dev->int_type == command
-		|| dev->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+		|| dev->int_type == S5P_MFC_R2H_CMD_ERR_RET)),
 		msecs_to_jiffies(MFC_INT_TIMEOUT));
 	if (ret == 0) {
 		mfc_err("Interrupt (dev->int_type:%d, command:%d) timed out\n",
@@ -40,7 +39,7 @@ int s5p_mfc_wait_for_done_dev(struct s5p_mfc_dev *dev, int command)
 	}
 	mfc_debug(1, "Finished waiting (dev->int_type:%d, command: %d)\n",
 							dev->int_type, command);
-	if (dev->int_type == S5P_FIMV_R2H_CMD_ERR_RET)
+	if (dev->int_type == S5P_MFC_R2H_CMD_ERR_RET)
 		return 1;
 	return 0;
 }
@@ -60,12 +59,12 @@ int s5p_mfc_wait_for_done_ctx(struct s5p_mfc_ctx *ctx,
 	if (interrupt) {
 		ret = wait_event_interruptible_timeout(ctx->queue,
 				(ctx->int_cond && (ctx->int_type == command
-			|| ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+			|| ctx->int_type == S5P_MFC_R2H_CMD_ERR_RET)),
 					msecs_to_jiffies(MFC_INT_TIMEOUT));
 	} else {
 		ret = wait_event_timeout(ctx->queue,
 				(ctx->int_cond && (ctx->int_type == command
-			|| ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)),
+			|| ctx->int_type == S5P_MFC_R2H_CMD_ERR_RET)),
 					msecs_to_jiffies(MFC_INT_TIMEOUT));
 	}
 	if (ret == 0) {
@@ -78,7 +77,7 @@ int s5p_mfc_wait_for_done_ctx(struct s5p_mfc_ctx *ctx,
 	}
 	mfc_debug(1, "Finished waiting (ctx->int_type:%d, command: %d)\n",
 							ctx->int_type, command);
-	if (ctx->int_type == S5P_FIMV_R2H_CMD_ERR_RET)
+	if (ctx->int_type == S5P_MFC_R2H_CMD_ERR_RET)
 		return 1;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
new file mode 100644
index 0000000..b6246b2
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -0,0 +1,25 @@
+/*
+ * drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+ *
+ * Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains hw related functions.
+ *
+ * Kamil Debski, Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_opr_v5.h"
+
+static struct s5p_mfc_hw_ops *s5p_mfc_ops;
+
+void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_ops = s5p_mfc_init_hw_ops_v5();
+	dev->warn_start = S5P_FIMV_ERR_WARNINGS_START;
+	dev->mfc_ops = s5p_mfc_ops;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
new file mode 100644
index 0000000..420abec
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -0,0 +1,84 @@
+/*
+ * drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains declarations of hw related functions.
+ *
+ * Kamil Debski, Copyright (C) 2012 Samsung Electronics Co., Ltd.
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_OPR_H_
+#define S5P_MFC_OPR_H_
+
+#include "s5p_mfc_common.h"
+
+struct s5p_mfc_hw_ops {
+	int (*alloc_dec_temp_buffers)(struct s5p_mfc_ctx *ctx);
+	void (*release_dec_desc_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*alloc_codec_buffers)(struct s5p_mfc_ctx *ctx);
+	void (*release_codec_buffers)(struct s5p_mfc_ctx *ctx);
+	int (*alloc_instance_buffer)(struct s5p_mfc_ctx *ctx);
+	void (*release_instance_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*alloc_dev_context_buffer)(struct s5p_mfc_dev *dev);
+	void (*release_dev_context_buffer)(struct s5p_mfc_dev *dev);
+	void (*dec_calc_dpb_size)(struct s5p_mfc_ctx *ctx);
+	void (*enc_calc_src_size)(struct s5p_mfc_ctx *ctx);
+	int (*set_dec_stream_buffer)(struct s5p_mfc_ctx *ctx,
+			int buf_addr, unsigned int start_num_byte,
+			unsigned int buf_size);
+	int (*set_dec_frame_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*set_enc_stream_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long addr, unsigned int size);
+	void (*set_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long y_addr, unsigned long c_addr);
+	void (*get_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long *y_addr, unsigned long *c_addr);
+	int (*set_enc_ref_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*init_decode)(struct s5p_mfc_ctx *ctx);
+	int (*init_encode)(struct s5p_mfc_ctx *ctx);
+	int (*encode_one_frame)(struct s5p_mfc_ctx *ctx);
+	void (*try_run)(struct s5p_mfc_dev *dev);
+	void (*cleanup_queue)(struct list_head *lh,
+			struct vb2_queue *vq);
+	void (*clear_int_flags)(struct s5p_mfc_dev *dev);
+	void (*write_info)(struct s5p_mfc_ctx *ctx, unsigned int data,
+			unsigned int ofs);
+	unsigned int (*read_info)(struct s5p_mfc_ctx *ctx,
+			unsigned int ofs);
+	int (*get_dspl_y_adr)(struct s5p_mfc_dev *dev);
+	int (*get_dec_y_adr)(struct s5p_mfc_dev *dev);
+	int (*get_dspl_status)(struct s5p_mfc_dev *dev);
+	int (*get_dec_status)(struct s5p_mfc_dev *dev);
+	int (*get_dec_frame_type)(struct s5p_mfc_dev *dev);
+	int (*get_disp_frame_type)(struct s5p_mfc_ctx *ctx);
+	int (*get_consumed_stream)(struct s5p_mfc_dev *dev);
+	int (*get_int_reason)(struct s5p_mfc_dev *dev);
+	int (*get_int_err)(struct s5p_mfc_dev *dev);
+	int (*err_dec)(unsigned int err);
+	int (*err_dspl)(unsigned int err);
+	int (*get_img_width)(struct s5p_mfc_dev *dev);
+	int (*get_img_height)(struct s5p_mfc_dev *dev);
+	int (*get_dpb_count)(struct s5p_mfc_dev *dev);
+	int (*get_mv_count)(struct s5p_mfc_dev *dev);
+	int (*get_inst_no)(struct s5p_mfc_dev *dev);
+	int (*get_enc_strm_size)(struct s5p_mfc_dev *dev);
+	int (*get_enc_slice_type)(struct s5p_mfc_dev *dev);
+	int (*get_enc_dpb_count)(struct s5p_mfc_dev *dev);
+	int (*get_enc_pic_count)(struct s5p_mfc_dev *dev);
+	int (*get_sei_avail_status)(struct s5p_mfc_ctx *ctx);
+	int (*get_mvc_num_views)(struct s5p_mfc_dev *dev);
+	int (*get_mvc_view_id)(struct s5p_mfc_dev *dev);
+	unsigned int (*get_pic_type_top)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*get_pic_type_bot)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*get_crop_info_h)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*get_crop_info_v)(struct s5p_mfc_ctx *ctx);
+};
+
+void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
+
+#endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index baa05af..17928c8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1,5 +1,5 @@
 /*
- * drivers/media/platform/samsung/mfc5/s5p_mfc_opr.c
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_opr_v5.c
  *
  * Samsung MFC (Multi Function Codec - FIMV) driver
  * This file contains hw related functions.
@@ -12,14 +12,14 @@
  * published by the Free Software Foundation.
  */
 
-#include "regs-mfc.h"
-#include "s5p_mfc_cmd_v5.h"
 #include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
-#include "s5p_mfc_opr_v5.h"
 #include "s5p_mfc_pm.h"
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_opr_v5.h"
 #include <asm/cacheflush.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -34,7 +34,7 @@
 #define OFFSETB(x)		(((x) - dev->bank2) >> MFC_OFFSET_SHIFT)
 
 /* Allocate temporary buffers for decoding */
-int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	void *desc_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -63,7 +63,7 @@ int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release temporary buffers for decoding */
-void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	if (ctx->desc_phys) {
 		vb2_dma_contig_memops.put(ctx->desc_buf);
@@ -73,7 +73,7 @@ void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Allocate codec buffers */
-int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int enc_ref_y_size = 0;
@@ -89,7 +89,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
 		enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
 
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
+		if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC) {
 			enc_ref_c_size = ALIGN(ctx->img_width,
 						S5P_FIMV_NV12MT_HALIGN)
 						* ALIGN(ctx->img_height >> 1,
@@ -111,14 +111,14 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 	}
 	/* Codecs have different memory requirements */
 	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_DEC:
+	case S5P_MFC_CODEC_H264_DEC:
 		ctx->bank1_size =
 		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
 					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
 					S5P_FIMV_DEC_BUF_ALIGN);
 		ctx->bank2_size = ctx->total_dpb_count * ctx->mv_size;
 		break;
-	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_MFC_CODEC_MPEG4_DEC:
 		ctx->bank1_size =
 		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
 				     S5P_FIMV_DEC_UPNB_MV_SIZE +
@@ -128,8 +128,8 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 				     S5P_FIMV_DEC_BUF_ALIGN);
 		ctx->bank2_size = 0;
 		break;
-	case S5P_FIMV_CODEC_VC1RCV_DEC:
-	case S5P_FIMV_CODEC_VC1_DEC:
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+	case S5P_MFC_CODEC_VC1_DEC:
 		ctx->bank1_size =
 		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
 			     S5P_FIMV_DEC_UPNB_MV_SIZE +
@@ -139,11 +139,11 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 			     S5P_FIMV_DEC_BUF_ALIGN);
 		ctx->bank2_size = 0;
 		break;
-	case S5P_FIMV_CODEC_MPEG2_DEC:
+	case S5P_MFC_CODEC_MPEG2_DEC:
 		ctx->bank1_size = 0;
 		ctx->bank2_size = 0;
 		break;
-	case S5P_FIMV_CODEC_H263_DEC:
+	case S5P_MFC_CODEC_H263_DEC:
 		ctx->bank1_size =
 		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
 			     S5P_FIMV_DEC_UPNB_MV_SIZE +
@@ -152,7 +152,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 			     S5P_FIMV_DEC_BUF_ALIGN);
 		ctx->bank2_size = 0;
 		break;
-	case S5P_FIMV_CODEC_H264_ENC:
+	case S5P_MFC_CODEC_H264_ENC:
 		ctx->bank1_size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_COLFLG_SIZE +
@@ -162,7 +162,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 				   (enc_ref_c_size * 4) +
 				   S5P_FIMV_ENC_INTRAPRED_SIZE;
 		break;
-	case S5P_FIMV_CODEC_MPEG4_ENC:
+	case S5P_MFC_CODEC_MPEG4_ENC:
 		ctx->bank1_size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_COLFLG_SIZE +
@@ -170,7 +170,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 		ctx->bank2_size = (enc_ref_y_size * 2) +
 				   (enc_ref_c_size * 4);
 		break;
-	case S5P_FIMV_CODEC_H263_ENC:
+	case S5P_MFC_CODEC_H263_ENC:
 		ctx->bank1_size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
@@ -211,7 +211,7 @@ int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release buffers allocated for codec */
-void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	if (ctx->bank1_buf) {
 		vb2_dma_contig_memops.put(ctx->bank1_buf);
@@ -228,7 +228,7 @@ void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Allocate memory for instance data buffer */
-int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	void *context_virt;
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -289,7 +289,7 @@ int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Release instance buffer */
-void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	if (ctx->ctx_buf) {
 		vb2_dma_contig_memops.put(ctx->ctx_buf);
@@ -303,22 +303,44 @@ void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
 	}
 }
 
-void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
+int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+
+	return 0;
+}
+
+void s5p_mfc_release_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+}
+
+static void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
 			unsigned int ofs)
 {
 	writel(data, (ctx->shm + ofs));
 	wmb();
 }
 
-unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
+static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
 				unsigned int ofs)
 {
 	rmb();
 	return readl(ctx->shm + ofs);
 }
 
+void s5p_mfc_dec_calc_dpb_size_v5(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+}
+
+void s5p_mfc_enc_calc_src_size_v5(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+}
+
 /* Set registers for decoding temporary buffers */
-void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+static void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
@@ -334,7 +356,7 @@ static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for decoding stream buffer */
-int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
+int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx, int buf_addr,
 		  unsigned int start_num_byte, unsigned int buf_size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -347,7 +369,7 @@ int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
 }
 
 /* Set decoding frame buffer */
-int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	unsigned int frame_size, i;
 	unsigned int frame_size_ch, frame_size_mv;
@@ -366,7 +388,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 						S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
 	s5p_mfc_set_shared_buffer(ctx);
 	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_DEC:
+	case S5P_MFC_CODEC_H264_DEC:
 		mfc_write(dev, OFFSETA(buf_addr1),
 						S5P_FIMV_H264_VERT_NB_MV_ADR);
 		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
@@ -375,7 +397,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
 		break;
-	case S5P_FIMV_CODEC_MPEG4_DEC:
+	case S5P_MFC_CODEC_MPEG4_DEC:
 		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_NB_DCAC_ADR);
 		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
@@ -392,7 +414,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
 		break;
-	case S5P_FIMV_CODEC_H263_DEC:
+	case S5P_MFC_CODEC_H263_DEC:
 		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_OT_LINE_ADR);
 		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
@@ -406,8 +428,8 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
 		break;
-	case S5P_FIMV_CODEC_VC1_DEC:
-	case S5P_FIMV_CODEC_VC1RCV_DEC:
+	case S5P_MFC_CODEC_VC1_DEC:
+	case S5P_MFC_CODEC_VC1RCV_DEC:
 		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_NB_DCAC_ADR);
 		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
@@ -430,7 +452,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
 		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
 		break;
-	case S5P_FIMV_CODEC_MPEG2_DEC:
+	case S5P_MFC_CODEC_MPEG2_DEC:
 		break;
 	default:
 		mfc_err("Unknown codec for decoding (%x)\n",
@@ -453,7 +475,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 					ctx->dst_bufs[i].cookie.raw.chroma);
 		mfc_write(dev, OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
 					       S5P_FIMV_DEC_CHROMA_ADR + i * 4);
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
+		if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC) {
 			mfc_debug(2, "\tBuf2: %x, size: %d\n",
 							buf_addr2, buf_size2);
 			mfc_write(dev, OFFSETB(buf_addr2),
@@ -471,7 +493,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 	}
 	s5p_mfc_write_info_v5(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
 	s5p_mfc_write_info_v5(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC)
 		s5p_mfc_write_info_v5(ctx, frame_size_mv, ALLOC_MV_SIZE);
 	mfc_write(dev, ((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK)
 					<< S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
@@ -480,7 +502,7 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 }
 
 /* Set registers for encoding stream buffer */
-int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
+int s5p_mfc_set_enc_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long addr, unsigned int size)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -490,7 +512,7 @@ int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+void s5p_mfc_set_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long y_addr, unsigned long c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -499,7 +521,7 @@ void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
 	mfc_write(dev, OFFSETB(c_addr), S5P_FIMV_ENC_SI_CH0_CUR_C_ADR);
 }
 
-void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 		unsigned long *y_addr, unsigned long *c_addr)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -511,7 +533,7 @@ void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
 }
 
 /* Set encoding ref & codec buffer */
-int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	size_t buf_addr1, buf_addr2;
@@ -527,7 +549,7 @@ int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
 	enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
 		* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
 	enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC) {
 		enc_ref_c_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
 			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
 		enc_ref_c_size = ALIGN(enc_ref_c_size, S5P_FIMV_NV12MT_SALIGN);
@@ -541,7 +563,7 @@ int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
 	}
 	mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
 	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_ENC:
+	case S5P_MFC_CODEC_H264_ENC:
 		for (i = 0; i < 2; i++) {
 			mfc_write(dev, OFFSETA(buf_addr1),
 				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
@@ -581,7 +603,7 @@ int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
 			buf_size1, buf_size2);
 		break;
-	case S5P_FIMV_CODEC_MPEG4_ENC:
+	case S5P_MFC_CODEC_MPEG4_ENC:
 		for (i = 0; i < 2; i++) {
 			mfc_write(dev, OFFSETA(buf_addr1),
 				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
@@ -612,7 +634,7 @@ int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
 		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
 			buf_size1, buf_size2);
 		break;
-	case S5P_FIMV_CODEC_H263_ENC:
+	case S5P_MFC_CODEC_H263_ENC:
 		for (i = 0; i < 2; i++) {
 			mfc_write(dev, OFFSETA(buf_addr1),
 				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
@@ -1016,13 +1038,13 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 }
 
 /* Initialize decoding */
-int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_init_decode_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
 	s5p_mfc_set_shared_buffer(ctx);
 	/* Setup loop filter, for decoding this is only valid for MPEG4 */
-	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC)
+	if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC)
 		mfc_write(dev, ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
 	else
 		mfc_write(dev, 0, S5P_FIMV_ENC_LF_CTRL);
@@ -1052,7 +1074,7 @@ static void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
 }
 
 /* Decode a single frame */
-int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
+int s5p_mfc_decode_one_frame_v5(struct s5p_mfc_ctx *ctx,
 					enum s5p_mfc_decode_arg last_frame)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
@@ -1081,15 +1103,15 @@ int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
 	return 0;
 }
 
-int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_init_encode_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
 		s5p_mfc_set_enc_params_h264(ctx);
-	else if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_ENC)
+	else if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_ENC)
 		s5p_mfc_set_enc_params_mpeg4(ctx);
-	else if (ctx->codec_mode == S5P_FIMV_CODEC_H263_ENC)
+	else if (ctx->codec_mode == S5P_MFC_CODEC_H263_ENC)
 		s5p_mfc_set_enc_params_h263(ctx);
 	else {
 		mfc_err("Unknown codec for encoding (%x)\n",
@@ -1103,7 +1125,7 @@ int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
 }
 
 /* Encode a single frame */
-int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_encode_one_frame_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	int cmd;
@@ -1149,10 +1171,10 @@ static void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
+	s5p_mfc_set_dec_stream_buffer_v5(ctx, 0, 0, 0);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_decode_one_frame(ctx, MFC_DEC_RES_CHANGE);
+	s5p_mfc_decode_one_frame_v5(ctx, MFC_DEC_RES_CHANGE);
 }
 
 static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
@@ -1172,9 +1194,9 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	/* Get the next source buffer */
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	temp_vb->flags |= MFC_BUF_FLAG_USED;
-	s5p_mfc_set_dec_stream_buffer(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), ctx->consumed_stream,
-					temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
+		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+		ctx->consumed_stream, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	index = temp_vb->b->v4l2_buf.index;
 	dev->curr_ctx = ctx->num;
@@ -1184,7 +1206,7 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 		mfc_debug(2, "Setting ctx->state to FINISHING\n");
 		ctx->state = MFCINST_FINISHING;
 	}
-	s5p_mfc_decode_one_frame(ctx, last_frame);
+	s5p_mfc_decode_one_frame_v5(ctx, last_frame);
 	return 0;
 }
 
@@ -1210,7 +1232,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	}
 	if (list_empty(&ctx->src_queue)) {
 		/* send null frame */
-		s5p_mfc_set_enc_frame_buffer(ctx, dev->bank2, dev->bank2);
+		s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->bank2, dev->bank2);
 		src_mb = NULL;
 	} else {
 		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
@@ -1218,7 +1240,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		src_mb->flags |= MFC_BUF_FLAG_USED;
 		if (src_mb->b->v4l2_planes[0].bytesused == 0) {
 			/* send null frame */
-			s5p_mfc_set_enc_frame_buffer(ctx, dev->bank2,
+			s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->bank2,
 								dev->bank2);
 			ctx->state = MFCINST_FINISHING;
 		} else {
@@ -1226,7 +1248,7 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 									0);
 			src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b,
 									1);
-			s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr,
+			s5p_mfc_set_enc_frame_buffer_v5(ctx, src_y_addr,
 								src_c_addr);
 			if (src_mb->flags & MFC_BUF_FLAG_EOS)
 				ctx->state = MFCINST_FINISHING;
@@ -1236,13 +1258,13 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	dst_mb->flags |= MFC_BUF_FLAG_USED;
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
 	mfc_debug(2, "encoding buffer with index=%d state=%d",
 			src_mb ? src_mb->b->v4l2_buf.index : -1, ctx->state);
-	s5p_mfc_encode_one_frame(ctx);
+	s5p_mfc_encode_one_frame_v5(ctx);
 	return 0;
 }
 
@@ -1258,13 +1280,13 @@ static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	s5p_mfc_set_dec_desc_buffer(ctx);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
-	s5p_mfc_set_dec_stream_buffer(ctx,
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
 				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_init_decode(ctx);
+	s5p_mfc_init_decode_v5(ctx);
 }
 
 static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
@@ -1275,16 +1297,16 @@ static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
 	unsigned long dst_addr;
 	unsigned int dst_size;
 
-	s5p_mfc_set_enc_ref_buffer(ctx);
+	s5p_mfc_set_enc_ref_buffer_v5(ctx);
 	spin_lock_irqsave(&dev->irqlock, flags);
 	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
 	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
 	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
+	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_init_encode(ctx);
+	s5p_mfc_init_encode_v5(ctx);
 }
 
 static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
@@ -1313,13 +1335,13 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 	}
 	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
 	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
-	s5p_mfc_set_dec_stream_buffer(ctx,
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
 				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
 				0, temp_vb->b->v4l2_planes[0].bytesused);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
 	dev->curr_ctx = ctx->num;
 	s5p_mfc_clean_ctx_int_flags(ctx);
-	ret = s5p_mfc_set_dec_frame_buffer(ctx);
+	ret = s5p_mfc_set_dec_frame_buffer_v5(ctx);
 	if (ret) {
 		mfc_err("Failed to alloc frame mem\n");
 		ctx->state = MFCINST_ERROR;
@@ -1328,7 +1350,7 @@ static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
 }
 
 /* Try running an operation on hardware */
-void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
+void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_ctx *ctx;
 	int new_ctx;
@@ -1373,11 +1395,13 @@ void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
 			break;
 		case MFCINST_INIT:
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_open_inst_cmd(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
+					ctx);
 			break;
 		case MFCINST_RETURN_INST:
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_close_inst_cmd(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
+					ctx);
 			break;
 		case MFCINST_GOT_INST:
 			s5p_mfc_run_init_dec(ctx);
@@ -1409,11 +1433,13 @@ void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
 			break;
 		case MFCINST_INIT:
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_open_inst_cmd(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
+					ctx);
 			break;
 		case MFCINST_RETURN_INST:
 			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_close_inst_cmd(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
+					ctx);
 			break;
 		case MFCINST_GOT_INST:
 			s5p_mfc_run_init_enc(ctx);
@@ -1440,7 +1466,7 @@ void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
 }
 
 
-void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
+void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
 {
 	struct s5p_mfc_buf *b;
 	int i;
@@ -1454,3 +1480,250 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
 	}
 }
 
+void s5p_mfc_clear_int_flags_v5(struct s5p_mfc_dev *dev)
+{
+	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
+	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
+	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
+}
+
+int s5p_mfc_get_dspl_y_adr_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_DISPLAY_Y_ADR) << MFC_OFFSET_SHIFT;
+}
+
+int s5p_mfc_get_dec_y_adr_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_DECODE_Y_ADR) << MFC_OFFSET_SHIFT;
+}
+
+int s5p_mfc_get_dspl_status_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_DISPLAY_STATUS);
+}
+
+int s5p_mfc_get_dec_status_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_DECODE_STATUS);
+}
+
+int s5p_mfc_get_dec_frame_type_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_DECODE_FRAME_TYPE) &
+		S5P_FIMV_DECODE_FRAME_MASK;
+}
+
+int s5p_mfc_get_disp_frame_type_v5(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+	return -1;
+}
+
+int s5p_mfc_get_consumed_stream_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_CONSUMED_BYTES);
+}
+
+int s5p_mfc_get_int_reason_v5(struct s5p_mfc_dev *dev)
+{
+	int reason;
+	reason = mfc_read(dev, S5P_FIMV_RISC2HOST_CMD) &
+		S5P_FIMV_RISC2HOST_CMD_MASK;
+	switch (reason) {
+	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
+		reason = S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET:
+		reason = S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+		reason = S5P_MFC_R2H_CMD_SEQ_DONE_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_FRAME_DONE_RET:
+		reason = S5P_MFC_R2H_CMD_FRAME_DONE_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_SLICE_DONE_RET:
+		reason = S5P_MFC_R2H_CMD_SLICE_DONE_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_SYS_INIT_RET:
+		reason = S5P_MFC_R2H_CMD_SYS_INIT_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_FW_STATUS_RET:
+		reason = S5P_MFC_R2H_CMD_FW_STATUS_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_SLEEP_RET:
+		reason = S5P_MFC_R2H_CMD_SLEEP_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_WAKEUP_RET:
+		reason = S5P_MFC_R2H_CMD_WAKEUP_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
+		reason = S5P_MFC_R2H_CMD_INIT_BUFFERS_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_ENC_COMPLETE_RET:
+		reason = S5P_MFC_R2H_CMD_COMPLETE_SEQ_RET;
+		break;
+	case S5P_FIMV_R2H_CMD_ERR_RET:
+		reason = S5P_MFC_R2H_CMD_ERR_RET;
+		break;
+	default:
+		reason = S5P_MFC_R2H_CMD_EMPTY;
+	};
+	return reason;
+}
+
+int s5p_mfc_get_int_err_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_RISC2HOST_ARG2);
+}
+
+int s5p_mfc_err_dec_v5(unsigned int err)
+{
+	return (err & S5P_FIMV_ERR_DEC_MASK) >> S5P_FIMV_ERR_DEC_SHIFT;
+}
+
+int s5p_mfc_err_dspl_v5(unsigned int err)
+{
+	return (err & S5P_FIMV_ERR_DSPL_MASK) >> S5P_FIMV_ERR_DSPL_SHIFT;
+}
+
+int s5p_mfc_get_img_width_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_HRESOL);
+}
+
+int s5p_mfc_get_img_height_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_VRESOL);
+}
+
+int s5p_mfc_get_dpb_count_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_SI_BUF_NUMBER);
+}
+
+int s5p_mfc_get_mv_count_v5(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+	return -1;
+}
+
+int s5p_mfc_get_inst_no_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_RISC2HOST_ARG1);
+}
+
+int s5p_mfc_get_enc_strm_size_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_ENC_SI_STRM_SIZE);
+}
+
+int s5p_mfc_get_enc_slice_type_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_ENC_SI_SLICE_TYPE);
+}
+
+int s5p_mfc_get_enc_dpb_count_v5(struct s5p_mfc_dev *dev)
+{
+	return -1;
+}
+
+int s5p_mfc_get_enc_pic_count_v5(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_ENC_SI_PIC_CNT);
+}
+
+int s5p_mfc_get_sei_avail_status_v5(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v5(ctx, FRAME_PACK_SEI_AVAIL);
+}
+
+int s5p_mfc_get_mvc_num_views_v5(struct s5p_mfc_dev *dev)
+{
+	return -1;
+}
+
+int s5p_mfc_get_mvc_view_id_v5(struct s5p_mfc_dev *dev)
+{
+	return -1;
+}
+
+unsigned int s5p_mfc_get_pic_type_top_v5(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v5(ctx, PIC_TIME_TOP);
+}
+
+unsigned int s5p_mfc_get_pic_type_bot_v5(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v5(ctx, PIC_TIME_BOT);
+}
+
+unsigned int s5p_mfc_get_crop_info_h_v5(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v5(ctx, CROP_INFO_H);
+}
+
+unsigned int s5p_mfc_get_crop_info_v_v5(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v5(ctx, CROP_INFO_V);
+}
+
+/* Initialize opr function pointers for MFC v5 */
+static struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
+	.alloc_dec_temp_buffers = s5p_mfc_alloc_dec_temp_buffers_v5,
+	.release_dec_desc_buffer = s5p_mfc_release_dec_desc_buffer_v5,
+	.alloc_codec_buffers = s5p_mfc_alloc_codec_buffers_v5,
+	.release_codec_buffers = s5p_mfc_release_codec_buffers_v5,
+	.alloc_instance_buffer = s5p_mfc_alloc_instance_buffer_v5,
+	.release_instance_buffer = s5p_mfc_release_instance_buffer_v5,
+	.alloc_dev_context_buffer = s5p_mfc_alloc_dev_context_buffer_v5,
+	.release_dev_context_buffer = s5p_mfc_release_dev_context_buffer_v5,
+	.dec_calc_dpb_size = s5p_mfc_dec_calc_dpb_size_v5,
+	.enc_calc_src_size = s5p_mfc_enc_calc_src_size_v5,
+	.set_dec_stream_buffer = s5p_mfc_set_dec_stream_buffer_v5,
+	.set_dec_frame_buffer = s5p_mfc_set_dec_frame_buffer_v5,
+	.set_enc_stream_buffer = s5p_mfc_set_enc_stream_buffer_v5,
+	.set_enc_frame_buffer = s5p_mfc_set_enc_frame_buffer_v5,
+	.get_enc_frame_buffer = s5p_mfc_get_enc_frame_buffer_v5,
+	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v5,
+	.init_decode = s5p_mfc_init_decode_v5,
+	.init_encode = s5p_mfc_init_encode_v5,
+	.encode_one_frame = s5p_mfc_encode_one_frame_v5,
+	.try_run = s5p_mfc_try_run_v5,
+	.cleanup_queue = s5p_mfc_cleanup_queue_v5,
+	.clear_int_flags = s5p_mfc_clear_int_flags_v5,
+	.write_info = s5p_mfc_write_info_v5,
+	.read_info = s5p_mfc_read_info_v5,
+	.get_dspl_y_adr = s5p_mfc_get_dspl_y_adr_v5,
+	.get_dec_y_adr = s5p_mfc_get_dec_y_adr_v5,
+	.get_dspl_status = s5p_mfc_get_dspl_status_v5,
+	.get_dec_status = s5p_mfc_get_dec_status_v5,
+	.get_dec_frame_type = s5p_mfc_get_dec_frame_type_v5,
+	.get_disp_frame_type = s5p_mfc_get_disp_frame_type_v5,
+	.get_consumed_stream = s5p_mfc_get_consumed_stream_v5,
+	.get_int_reason = s5p_mfc_get_int_reason_v5,
+	.get_int_err = s5p_mfc_get_int_err_v5,
+	.err_dec = s5p_mfc_err_dec_v5,
+	.err_dspl = s5p_mfc_err_dspl_v5,
+	.get_img_width = s5p_mfc_get_img_width_v5,
+	.get_img_height = s5p_mfc_get_img_height_v5,
+	.get_dpb_count = s5p_mfc_get_dpb_count_v5,
+	.get_mv_count = s5p_mfc_get_mv_count_v5,
+	.get_inst_no = s5p_mfc_get_inst_no_v5,
+	.get_enc_strm_size = s5p_mfc_get_enc_strm_size_v5,
+	.get_enc_slice_type = s5p_mfc_get_enc_slice_type_v5,
+	.get_enc_dpb_count = s5p_mfc_get_enc_dpb_count_v5,
+	.get_enc_pic_count = s5p_mfc_get_enc_pic_count_v5,
+	.get_sei_avail_status = s5p_mfc_get_sei_avail_status_v5,
+	.get_mvc_num_views = s5p_mfc_get_mvc_num_views_v5,
+	.get_mvc_view_id = s5p_mfc_get_mvc_view_id_v5,
+	.get_pic_type_top = s5p_mfc_get_pic_type_top_v5,
+	.get_pic_type_bot = s5p_mfc_get_pic_type_bot_v5,
+	.get_crop_info_h = s5p_mfc_get_crop_info_h_v5,
+	.get_crop_info_v = s5p_mfc_get_crop_info_v_v5,
+};
+
+struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v5(void)
+{
+	return &s5p_mfc_ops_v5;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h
index 97c1eca..ffee39a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.h
@@ -1,5 +1,5 @@
 /*
- * drivers/media/platform/samsung/mfc5/s5p_mfc_opr.h
+ * drivers/media/platform/samsung/mfc5/s5p_mfc_opr_v5.h
  *
  * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
  * Contains declarations of hw related functions.
@@ -12,10 +12,11 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef S5P_MFC_OPR_H_
-#define S5P_MFC_OPR_H_
+#ifndef S5P_MFC_OPR_V5_H_
+#define S5P_MFC_OPR_V5_H_
 
 #include "s5p_mfc_common.h"
+#include "s5p_mfc_opr.h"
 
 enum MFC_SHM_OFS {
 	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
@@ -80,84 +81,5 @@ enum MFC_SHM_OFS {
 	FRAME_PACK_SEI_INFO	= 0x17c, /* E */
 };
 
-int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx);
-int s5p_mfc_init_encode(struct s5p_mfc_ctx *mfc_ctx);
-
-/* Decoding functions */
-int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx);
-int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
-						  unsigned int start_num_byte,
-						  unsigned int buf_size);
-
-/* Encoding functions */
-void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long y_addr, unsigned long c_addr);
-int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long addr, unsigned int size);
-void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long *y_addr, unsigned long *c_addr);
-int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *mfc_ctx);
-
-int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
-					enum s5p_mfc_decode_arg last_frame);
-int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *mfc_ctx);
-
-/* Memory allocation */
-int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx);
-void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
-void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
-
-int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx);
-void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx);
-
-int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx);
-void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx);
-
-void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
-void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
-
-/* Shared memory ops */
-void s5p_mfc_write_info_v5(struct s5p_mfc_ctx *ctx, unsigned int data,
-			unsigned int ofs);
-
-unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
-				unsigned int ofs);
-
-#define s5p_mfc_get_dspl_y_adr()	(readl(dev->regs_base + \
-					S5P_FIMV_SI_DISPLAY_Y_ADR) << \
-					MFC_OFFSET_SHIFT)
-#define s5p_mfc_get_dec_y_adr()		(readl(dev->regs_base + \
-					S5P_FIMV_SI_DECODE_Y_ADR) << \
-					MFC_OFFSET_SHIFT)
-#define s5p_mfc_get_dspl_status()	readl(dev->regs_base + \
-						S5P_FIMV_SI_DISPLAY_STATUS)
-#define s5p_mfc_get_dec_status()	readl(dev->regs_base + \
-						S5P_FIMV_SI_DECODE_STATUS)
-#define s5p_mfc_get_frame_type()	(readl(dev->regs_base + \
-						S5P_FIMV_DECODE_FRAME_TYPE) \
-					& S5P_FIMV_DECODE_FRAME_MASK)
-#define s5p_mfc_get_consumed_stream()	readl(dev->regs_base + \
-						S5P_FIMV_SI_CONSUMED_BYTES)
-#define s5p_mfc_get_int_reason()	(readl(dev->regs_base + \
-					S5P_FIMV_RISC2HOST_CMD) & \
-					S5P_FIMV_RISC2HOST_CMD_MASK)
-#define s5p_mfc_get_int_err()		readl(dev->regs_base + \
-						S5P_FIMV_RISC2HOST_ARG2)
-#define s5p_mfc_err_dec(x)		(((x) & S5P_FIMV_ERR_DEC_MASK) >> \
-							S5P_FIMV_ERR_DEC_SHIFT)
-#define s5p_mfc_err_dspl(x)		(((x) & S5P_FIMV_ERR_DSPL_MASK) >> \
-							S5P_FIMV_ERR_DSPL_SHIFT)
-#define s5p_mfc_get_img_width()		readl(dev->regs_base + \
-						S5P_FIMV_SI_HRESOL)
-#define s5p_mfc_get_img_height()	readl(dev->regs_base + \
-						S5P_FIMV_SI_VRESOL)
-#define s5p_mfc_get_dpb_count()		readl(dev->regs_base + \
-						S5P_FIMV_SI_BUF_NUMBER)
-#define s5p_mfc_get_inst_no()		readl(dev->regs_base + \
-						S5P_FIMV_RISC2HOST_ARG1)
-#define s5p_mfc_get_enc_strm_size()	readl(dev->regs_base + \
-						S5P_FIMV_ENC_SI_STRM_SIZE)
-#define s5p_mfc_get_enc_slice_type()	readl(dev->regs_base + \
-						S5P_FIMV_ENC_SI_SLICE_TYPE)
-
+struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v5(void);
 #endif /* S5P_MFC_OPR_H_ */
-- 
1.7.0.4


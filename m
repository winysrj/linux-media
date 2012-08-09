Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47551 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab2HIKM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2012 06:12:28 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8H009YNGC8K5X0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:25 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8H00MGUGCES850@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 09 Aug 2012 19:12:25 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, janghyuck.kim@samsung.com,
	jaeryul.oh@samsung.com, ch.naveen@samsung.com, arun.kk@samsung.com,
	m.szyprowski@samsung.com, k.debski@samsung.com,
	kmpark@infradead.org, joshi@samsung.com
Subject: [PATCH v4 1/4] [media] s5p-mfc: Update MFCv5 driver for callback based
 architecture
Date: Thu, 09 Aug 2012 15:58:27 +0530
Message-id: <1344508110-16945-2-git-send-email-arun.kk@samsung.com>
In-reply-to: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
References: <1344508110-16945-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modifies the driver to use a callback based architecture
for hardware dependent calls. This architecture is suitable
for supporting co-existence with newer versions of MFC hardware.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/media/video/s5p-mfc/Makefile         |    3 +-
 drivers/media/video/s5p-mfc/s5p_mfc.c        |   86 +-
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |   94 +--
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   13 +
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c |  164 +++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h |   20 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |   38 +-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |   27 +-
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |   48 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   31 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   11 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1399 +++-------------------
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |  178 ++-
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c | 1696 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h |   85 ++
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 -
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   90 --
 20 files changed, 2410 insertions(+), 1623 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
 delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 delete mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

diff --git a/drivers/media/video/s5p-mfc/Makefile b/drivers/media/video/s5p-mfc/Makefile
index d066340..cfb9ee9 100644
--- a/drivers/media/video/s5p-mfc/Makefile
+++ b/drivers/media/video/s5p-mfc/Makefile
@@ -2,4 +2,5 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
 s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
 s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd.o
-s5p-mfc-y += s5p_mfc_pm.o s5p_mfc_shm.o
+s5p-mfc-y += s5p_mfc_pm.o
+s5p-mfc-y += s5p_mfc_opr_v5.o s5p_mfc_cmd_v5.o
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index 9bb68e7..ab66680 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -21,15 +21,15 @@
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
+#include "s5p_mfc_common.h"
 #include "s5p_mfc_ctrl.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
+#include "s5p_mfc_cmd.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
 
 #define S5P_MFC_NAME		"s5p-mfc"
 #define S5P_MFC_DEC_NAME	"s5p-mfc-dec"
@@ -118,7 +118,7 @@ static void s5p_mfc_watchdog_worker(struct work_struct *work)
 		s5p_mfc_cleanup_queue(&ctx->dst_queue, &ctx->vq_dst);
 		s5p_mfc_cleanup_queue(&ctx->src_queue, &ctx->vq_src);
 		clear_work_bit(ctx);
-		wake_up_ctx(ctx, S5P_FIMV_R2H_CMD_ERR_RET, 0);
+		wake_up_ctx(ctx, S5P_MFC_R2H_CMD_ERR_RET, 0);
 	}
 	clear_bit(0, &dev->hw_lock);
 	spin_unlock_irqrestore(&dev->irqlock, flags);
@@ -155,13 +155,6 @@ static enum s5p_mfc_node_type s5p_mfc_get_node_type(struct file *file)
 	return MFCNODE_INVALID;
 }
 
-static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
-{
-	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
-	mfc_write(dev, 0xffff, S5P_FIMV_SI_RTN_CHID);
-}
-
 static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_buf *dst_buf;
@@ -179,8 +172,8 @@ static void s5p_mfc_handle_frame_all_extracted(struct s5p_mfc_ctx *ctx)
 		ctx->dst_queue_cnt--;
 		dst_buf->b->v4l2_buf.sequence = (ctx->sequence++);
 
-		if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
-			s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+		if (s5p_mfc_get_pic_type_top(ctx) ==
+			s5p_mfc_get_pic_type_bot(ctx))
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 		else
 			dst_buf->b->v4l2_buf.field = V4L2_FIELD_INTERLACED;
@@ -194,8 +187,8 @@ static void s5p_mfc_handle_frame_copy_time(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf, *src_buf;
-	size_t dec_y_addr = s5p_mfc_get_dec_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	size_t dec_y_addr = s5p_mfc_get_dec_y_adr(dev);
+	unsigned int frame_type = s5p_mfc_get_dec_frame_type(dev);
 
 	/* Copy timestamp / timecode from decoded src to dst and set
 	   appropraite flags */
@@ -231,8 +224,8 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf  *dst_buf;
-	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr();
-	unsigned int frame_type = s5p_mfc_get_frame_type();
+	size_t dspl_y_addr = s5p_mfc_get_dspl_y_adr(dev);
+	unsigned int frame_type = s5p_mfc_get_dec_frame_type(dev);
 	unsigned int index;
 
 	/* If frame is same as previous then skip and do not dequeue */
@@ -251,8 +244,8 @@ static void s5p_mfc_handle_frame_new(struct s5p_mfc_ctx *ctx, unsigned int err)
 			list_del(&dst_buf->list);
 			ctx->dst_queue_cnt--;
 			dst_buf->b->v4l2_buf.sequence = ctx->sequence;
-			if (s5p_mfc_read_shm(ctx, PIC_TIME_TOP) ==
-				s5p_mfc_read_shm(ctx, PIC_TIME_BOT))
+			if (s5p_mfc_get_pic_type_top(ctx) ==
+				s5p_mfc_get_pic_type_bot(ctx))
 				dst_buf->b->v4l2_buf.field = V4L2_FIELD_NONE;
 			else
 				dst_buf->b->v4l2_buf.field =
@@ -283,9 +276,9 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 
 	unsigned int index;
 
-	dst_frame_status = s5p_mfc_get_dspl_status()
+	dst_frame_status = s5p_mfc_get_dspl_status(dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
-	res_change = s5p_mfc_get_dspl_status()
+	res_change = s5p_mfc_get_dspl_status(dev)
 				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
 	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
 	if (ctx->state == MFCINST_RES_CHANGE_INIT)
@@ -331,9 +324,10 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		&& !list_empty(&ctx->src_queue)) {
 		src_buf = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 								list);
-		ctx->consumed_stream += s5p_mfc_get_consumed_stream();
-		if (ctx->codec_mode != S5P_FIMV_CODEC_H264_DEC &&
-			s5p_mfc_get_frame_type() == S5P_FIMV_DECODE_FRAME_P_FRAME
+		ctx->consumed_stream += s5p_mfc_get_consumed_stream(dev);
+		if (ctx->codec_mode != S5P_MFC_CODEC_H264_DEC &&
+			s5p_mfc_get_dec_frame_type(dev) ==
+					S5P_FIMV_DECODE_FRAME_P_FRAME
 					&& ctx->consumed_stream + STUFF_BYTE <
 					src_buf->b->v4l2_planes[0].bytesused) {
 			/* Run MFC again on the same buffer */
@@ -436,8 +430,8 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 		if (ctx->c_ops->post_seq_start(ctx))
 			mfc_err("post_seq_start() failed\n");
 	} else {
-		ctx->img_width = s5p_mfc_get_img_width();
-		ctx->img_height = s5p_mfc_get_img_height();
+		ctx->img_width = s5p_mfc_get_img_width(dev);
+		ctx->img_height = s5p_mfc_get_img_height(dev);
 
 		ctx->buf_width = ALIGN(ctx->img_width,
 						S5P_FIMV_NV12MT_HALIGN);
@@ -473,7 +467,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 				guard_height, S5P_FIMV_DEC_BUF_ALIGN);
 			ctx->mv_size = 0;
 		}
-		ctx->dpb_count = s5p_mfc_get_dpb_count();
+		ctx->dpb_count = s5p_mfc_get_dpb_count(dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
@@ -552,22 +546,23 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	atomic_set(&dev->watchdog_cnt, 0);
 	ctx = dev->ctx[dev->curr_ctx];
 	/* Get the reason of interrupt and the error code */
-	reason = s5p_mfc_get_int_reason();
-	err = s5p_mfc_get_int_err();
+	reason = s5p_mfc_get_int_reason(dev);
+	err = s5p_mfc_get_int_err(dev);
 	mfc_debug(1, "Int reason: %d (err: %08x)\n", reason, err);
 	switch (reason) {
-	case S5P_FIMV_R2H_CMD_ERR_RET:
+	case S5P_MFC_R2H_CMD_ERR_RET:
 		/* An error has occured */
 		if (ctx->state == MFCINST_RUNNING &&
-			s5p_mfc_err_dec(err) >= S5P_FIMV_ERR_WARNINGS_START)
+			s5p_mfc_err_dec(err) >= s5p_mfc_get_warn_start(dev))
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
@@ -582,27 +577,27 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		}
 		break;
 
-	case S5P_FIMV_R2H_CMD_SEQ_DONE_RET:
+	case S5P_MFC_R2H_CMD_SEQ_DONE_RET:
 		s5p_mfc_handle_seq_done(ctx, reason, err);
 		break;
 
-	case S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET:
-		ctx->inst_no = s5p_mfc_get_inst_no();
+	case S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET:
+		ctx->inst_no = s5p_mfc_get_inst_no(dev);
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
 		s5p_mfc_clear_int_flags(dev);
@@ -611,7 +606,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		clear_bit(0, &dev->enter_suspend);
 		break;
 
-	case S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET:
+	case S5P_MFC_R2H_CMD_INIT_BUFFERS_RET:
 		s5p_mfc_handle_init_buffers(ctx, reason, err);
 		break;
 	default:
@@ -679,6 +674,7 @@ static int s5p_mfc_open(struct file *file)
 	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
 		ctx->type = MFCINST_DECODER;
 		ctx->c_ops = get_dec_codec_ops();
+		s5p_mfc_dec_init(ctx);
 		/* Setup ctrl handler */
 		ret = s5p_mfc_dec_ctrls_setup(ctx);
 		if (ret) {
@@ -691,6 +687,7 @@ static int s5p_mfc_open(struct file *file)
 		/* only for encoder */
 		INIT_LIST_HEAD(&ctx->ref_queue);
 		ctx->ref_queue_cnt = 0;
+		s5p_mfc_enc_init(ctx);
 		/* Setup ctrl handler */
 		ret = s5p_mfc_enc_ctrls_setup(ctx);
 		if (ret) {
@@ -821,7 +818,7 @@ static int s5p_mfc_release(struct file *file)
 		s5p_mfc_try_run(dev);
 		/* Wait until instance is returned or timeout occured */
 		if (s5p_mfc_wait_for_done_ctx
-		    (ctx, S5P_FIMV_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
+		    (ctx, S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)) {
 			s5p_mfc_clock_off();
 			mfc_err("Err returning instance\n");
 		}
@@ -842,6 +839,7 @@ static int s5p_mfc_release(struct file *file)
 		mfc_debug(2, "Last instance - release firmware\n");
 		/* reset <-> F/W release */
 		s5p_mfc_reset(dev);
+		s5p_mfc_deinit_hw(dev);
 		s5p_mfc_release_firmware(dev);
 		del_timer_sync(&dev->watchdog_timer);
 		if (s5p_mfc_power_off() < 0)
@@ -1086,6 +1084,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	dev->watchdog_timer.data = (unsigned long)dev;
 	dev->watchdog_timer.function = s5p_mfc_watchdog;
 
+	/* Initialize HW ops and commands based on MFC version */
+	s5p_mfc_init_hw_ops(dev);
+	s5p_mfc_init_hw_cmds(dev);
+
 	pr_debug("%s--\n", __func__);
 	return 0;
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
index f0665ed..4ab07ba 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
@@ -10,111 +10,49 @@
  * (at your option) any later version.
  */
 
-#include "regs-mfc.h"
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
+#include "s5p_mfc_cmd_v5.h"
 
-/* This function is used to send a command to the MFC */
-static int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
-						struct s5p_mfc_cmd_args *args)
+static const struct s5p_mfc_hw_cmds *s5p_mfc_cmds;
+
+void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev)
 {
-	int cur_cmd;
-	unsigned long timeout;
+	s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v5();
+}
 
-	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
-	/* wait until host to risc command register becomes 'H2R_CMD_EMPTY' */
-	do {
-		if (time_after(jiffies, timeout)) {
-			mfc_err("Timeout while waiting for hardware\n");
-			return -EIO;
-		}
-		cur_cmd = mfc_read(dev, S5P_FIMV_HOST2RISC_CMD);
-	} while (cur_cmd != S5P_FIMV_H2R_CMD_EMPTY);
-	mfc_write(dev, args->arg[0], S5P_FIMV_HOST2RISC_ARG1);
-	mfc_write(dev, args->arg[1], S5P_FIMV_HOST2RISC_ARG2);
-	mfc_write(dev, args->arg[2], S5P_FIMV_HOST2RISC_ARG3);
-	mfc_write(dev, args->arg[3], S5P_FIMV_HOST2RISC_ARG4);
-	/* Issue the command */
-	mfc_write(dev, cmd, S5P_FIMV_HOST2RISC_CMD);
-	return 0;
+/* This function is used to send a command to the MFC */
+int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args)
+{
+	return s5p_mfc_cmds->s5p_mfc_cmd_host2risc(dev, cmd, args);
 }
 
 /* Initialize the MFC */
 int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_cmd_args h2r_args;
-
-	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	h2r_args.arg[0] = dev->fw_size;
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SYS_INIT, &h2r_args);
+	return s5p_mfc_cmds->s5p_mfc_sys_init_cmd(dev);
 }
 
 /* Suspend the MFC hardware */
 int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_cmd_args h2r_args;
-
-	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
+	return s5p_mfc_cmds->s5p_mfc_sleep_cmd(dev);
 }
 
 /* Wake up the MFC hardware */
 int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_cmd_args h2r_args;
-
-	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_WAKEUP, &h2r_args);
+	return s5p_mfc_cmds->s5p_mfc_wakeup_cmd(dev);
 }
 
-
 int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_cmd_args h2r_args;
-	int ret;
-
-	/* Preparing decoding - getting instance number */
-	mfc_debug(2, "Getting instance number (codec: %d)\n", ctx->codec_mode);
-	dev->curr_ctx = ctx->num;
-	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	h2r_args.arg[0] = ctx->codec_mode;
-	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
-	h2r_args.arg[2] = ctx->ctx_ofs;
-	h2r_args.arg[3] = ctx->ctx_size;
-	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
-								&h2r_args);
-	if (ret) {
-		mfc_err("Failed to create a new instance\n");
-		ctx->state = MFCINST_ERROR;
-	}
-	return ret;
+	return s5p_mfc_cmds->s5p_mfc_open_inst_cmd(ctx);
 }
 
 int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_cmd_args h2r_args;
-	int ret;
-
-	if (ctx->state == MFCINST_FREE) {
-		mfc_err("Instance already returned\n");
-		ctx->state = MFCINST_ERROR;
-		return -EINVAL;
-	}
-	/* Closing decoding instance  */
-	mfc_debug(2, "Returning instance number %d\n", ctx->inst_no);
-	dev->curr_ctx = ctx->num;
-	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
-	h2r_args.arg[0] = ctx->inst_no;
-	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
-								&h2r_args);
-	if (ret) {
-		mfc_err("Failed to return an instance\n");
-		ctx->state = MFCINST_ERROR;
-		return -EINVAL;
-	}
-	return 0;
+	return s5p_mfc_cmds->s5p_mfc_close_inst_cmd(ctx);
 }
-
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
index 5ceebfe..2be0b64 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
@@ -21,10 +21,23 @@ struct s5p_mfc_cmd_args {
 	unsigned int	arg[MAX_H2R_ARG];
 };
 
+struct s5p_mfc_hw_cmds {
+	int (*s5p_mfc_cmd_host2risc)(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args);
+	int (*s5p_mfc_sys_init_cmd)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_sleep_cmd)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_wakeup_cmd)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_open_inst_cmd)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_close_inst_cmd)(struct s5p_mfc_ctx *ctx);
+};
+
+int s5p_mfc_cmd_host2risc(struct s5p_mfc_dev *dev, int cmd,
+	struct s5p_mfc_cmd_args *args);
 int s5p_mfc_sys_init_cmd(struct s5p_mfc_dev *dev);
 int s5p_mfc_sleep_cmd(struct s5p_mfc_dev *dev);
 int s5p_mfc_wakeup_cmd(struct s5p_mfc_dev *dev);
 int s5p_mfc_open_inst_cmd(struct s5p_mfc_ctx *ctx);
 int s5p_mfc_close_inst_cmd(struct s5p_mfc_ctx *ctx);
 
+void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev);
 #endif /* S5P_MFC_CMD_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
new file mode 100644
index 0000000..43f0390
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
@@ -0,0 +1,164 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.c
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "regs-mfc.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_debug.h"
+
+/* This function is used to send a command to the MFC */
+int s5p_mfc_cmd_host2risc_v5(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args)
+{
+	int cur_cmd;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+	/* wait until host to risc command register becomes 'H2R_CMD_EMPTY' */
+	do {
+		if (time_after(jiffies, timeout)) {
+			mfc_err("Timeout while waiting for hardware\n");
+			return -EIO;
+		}
+		cur_cmd = mfc_read(dev, S5P_FIMV_HOST2RISC_CMD);
+	} while (cur_cmd != S5P_FIMV_H2R_CMD_EMPTY);
+	mfc_write(dev, args->arg[0], S5P_FIMV_HOST2RISC_ARG1);
+	mfc_write(dev, args->arg[1], S5P_FIMV_HOST2RISC_ARG2);
+	mfc_write(dev, args->arg[2], S5P_FIMV_HOST2RISC_ARG3);
+	mfc_write(dev, args->arg[3], S5P_FIMV_HOST2RISC_ARG4);
+	/* Issue the command */
+	mfc_write(dev, cmd, S5P_FIMV_HOST2RISC_CMD);
+	return 0;
+}
+
+/* Initialize the MFC */
+int s5p_mfc_sys_init_cmd_v5(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	h2r_args.arg[0] = dev->fw_size;
+	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SYS_INIT, &h2r_args);
+}
+
+/* Suspend the MFC hardware */
+int s5p_mfc_sleep_cmd_v5(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_SLEEP, &h2r_args);
+}
+
+/* Wake up the MFC hardware */
+int s5p_mfc_wakeup_cmd_v5(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	return s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_WAKEUP, &h2r_args);
+}
+
+
+int s5p_mfc_open_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	/* Preparing decoding - getting instance number */
+	mfc_debug(2, "Getting instance number (codec: %d)\n", ctx->codec_mode);
+	dev->curr_ctx = ctx->num;
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
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
+	h2r_args.arg[1] = 0; /* no crc & no pixelcache */
+	h2r_args.arg[2] = ctx->ctx_ofs;
+	h2r_args.arg[3] = ctx->ctx_size;
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE,
+								&h2r_args);
+	if (ret) {
+		mfc_err("Failed to create a new instance\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+int s5p_mfc_close_inst_cmd_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret;
+
+	if (ctx->state == MFCINST_FREE) {
+		mfc_err("Instance already returned\n");
+		ctx->state = MFCINST_ERROR;
+		return -EINVAL;
+	}
+	/* Closing decoding instance  */
+	mfc_debug(2, "Returning instance number %d\n", ctx->inst_no);
+	dev->curr_ctx = ctx->num;
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	h2r_args.arg[0] = ctx->inst_no;
+	ret = s5p_mfc_cmd_host2risc(dev, S5P_FIMV_H2R_CMD_CLOSE_INSTANCE,
+								&h2r_args);
+	if (ret) {
+		mfc_err("Failed to return an instance\n");
+		ctx->state = MFCINST_ERROR;
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/* Initialize cmd function pointers for MFC v5 */
+static const struct s5p_mfc_hw_cmds s5p_mfc_cmds_v5 = {
+	.s5p_mfc_cmd_host2risc = s5p_mfc_cmd_host2risc_v5,
+	.s5p_mfc_sys_init_cmd = s5p_mfc_sys_init_cmd_v5,
+	.s5p_mfc_sleep_cmd = s5p_mfc_sleep_cmd_v5,
+	.s5p_mfc_wakeup_cmd = s5p_mfc_wakeup_cmd_v5,
+	.s5p_mfc_open_inst_cmd = s5p_mfc_open_inst_cmd_v5,
+	.s5p_mfc_close_inst_cmd = s5p_mfc_close_inst_cmd_v5,
+};
+
+const struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v5(void)
+{
+	return &s5p_mfc_cmds_v5;
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
new file mode 100644
index 0000000..ef25120
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
@@ -0,0 +1,20 @@
+/*
+ * linux/drivers/media/video/s5p-mfc/s5p_mfc_cmd_v5.h
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef S5P_MFC_CMD_V5_H_
+#define S5P_MFC_CMD_V5_H_
+
+#include "s5p_mfc_common.h"
+
+const struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v5(void);
+
+#endif /* S5P_MFC_CMD_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index bd5706a..e705938 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
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
@@ -209,6 +242,7 @@ struct s5p_mfc_pm {
  * @watchdog_work:	worker for the watchdog
  * @alloc_ctx:		videobuf2 allocator contexts for two memory banks
  * @enter_suspend:	flag set when entering suspend
+ * @warn_start:		hardware error code from which warnings start
  *
  */
 struct s5p_mfc_dev {
@@ -245,6 +279,8 @@ struct s5p_mfc_dev {
 	struct work_struct watchdog_work;
 	void *alloc_ctx[2];
 	unsigned long enter_suspend;
+
+	int warn_start;
 };
 
 /**
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
index 08a5cfe..c9a5189 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
@@ -15,11 +15,11 @@
 #include <linux/firmware.h>
 #include <linux/jiffies.h>
 #include <linux/sched.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_cmd.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_intr.h"
+#include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
 
 static void *s5p_mfc_bitproc_buf;
@@ -226,7 +226,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clean_dev_int_flags(dev);
 	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_FW_STATUS_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
 		mfc_err("Failed to load firmware\n");
 		s5p_mfc_reset(dev);
 		s5p_mfc_clock_off();
@@ -242,7 +242,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	mfc_debug(2, "Ok, now will write a command to init the system\n");
-	if (s5p_mfc_wait_for_done_dev(dev, S5P_FIMV_R2H_CMD_SYS_INIT_RET)) {
+	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_SYS_INIT_RET)) {
 		mfc_err("Failed to load firmware\n");
 		s5p_mfc_reset(dev);
 		s5p_mfc_clock_off();
@@ -250,7 +250,7 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	}
 	dev->int_cond = 0;
 	if (dev->int_err != 0 || dev->int_type !=
-					S5P_FIMV_R2H_CMD_SYS_INIT_RET) {
+					S5P_MFC_R2H_CMD_SYS_INIT_RET) {
 		/* Failure. */
 		mfc_err("Failed to init firmware - error: %d int: %d\n",
 						dev->int_err, dev->int_type);
@@ -267,6 +267,17 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 }
 
 
+/* Deinitialize hardware */
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev)
+{
+	s5p_mfc_clock_on();
+
+	s5p_mfc_reset(dev);
+	s5p_mfc_release_dev_context_buffer(dev);
+
+	s5p_mfc_clock_off();
+}
+
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
 {
 	int ret;
@@ -279,14 +290,14 @@ int s5p_mfc_sleep(struct s5p_mfc_dev *dev)
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
@@ -324,14 +335,14 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
index 61dc23b..b72c8c6 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
@@ -20,6 +20,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev);
 int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_init_hw(struct s5p_mfc_dev *dev);
+void s5p_mfc_deinit_hw(struct s5p_mfc_dev *dev);
 
 int s5p_mfc_sleep(struct s5p_mfc_dev *dev);
 int s5p_mfc_wakeup(struct s5p_mfc_dev *dev);
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index c5d567f..d4ac770 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -23,83 +23,84 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_dec.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
+
+#define DEF_SRC_FMT_DEC	4
+#define DEF_DST_FMT_DEC	0
 
 static struct s5p_mfc_fmt formats[] = {
 	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
-		.codec_mode	= S5P_FIMV_CODEC_NONE,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
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
@@ -297,7 +298,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		/* If the MFC is parsing the header,
 		 * so wait until it is finished */
 		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_SEQ_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_SEQ_DONE_RET,
 									0);
 	}
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
@@ -380,7 +381,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		goto out;
 	}
 	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt || fmt->codec_mode == S5P_FIMV_CODEC_NONE) {
+	if (!fmt || fmt->codec_mode == S5P_MFC_CODEC_NONE) {
 		mfc_err("Unknown codec\n");
 		ret = -EINVAL;
 		goto out;
@@ -504,7 +505,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		}
 		s5p_mfc_try_run(dev);
 		s5p_mfc_wait_for_done_ctx(ctx,
-					 S5P_FIMV_R2H_CMD_INIT_BUFFERS_RET, 0);
+					S5P_MFC_R2H_CMD_INIT_BUFFERS_RET, 0);
 	}
 	return ret;
 }
@@ -596,7 +597,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 			s5p_mfc_try_run(dev);
 
 			if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 0)) {
 				/* Error or timeout */
 				mfc_err("Error getting instance from hardware\n");
 				s5p_mfc_release_instance_buffer(ctx);
@@ -669,7 +670,7 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 		/* Should wait for the header to be parsed */
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+				S5P_MFC_R2H_CMD_SEQ_DONE_RET, 0);
 		if (ctx->state >= MFCINST_HEAD_PARSED &&
 		    ctx->state < MFCINST_ABORT) {
 			ctrl->val = ctx->dpb_count;
@@ -702,10 +703,10 @@ static int vidioc_g_crop(struct file *file, void *priv,
 			return -EINVAL;
 		}
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
-		left = s5p_mfc_read_shm(ctx, CROP_INFO_H);
+		left = s5p_mfc_get_crop_info_h(ctx);
 		right = left >> S5P_FIMV_SHARED_CROP_RIGHT_SHIFT;
 		left = left & S5P_FIMV_SHARED_CROP_LEFT_MASK;
-		top = s5p_mfc_read_shm(ctx, CROP_INFO_V);
+		top = s5p_mfc_get_crop_info_v(ctx);
 		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
 		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
 		cr->c.left = left;
@@ -903,7 +904,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
 		s5p_mfc_wait_for_done_ctx(ctx,
-					S5P_FIMV_R2H_CMD_FRAME_DONE_RET, 0);
+					S5P_MFC_R2H_CMD_FRAME_DONE_RET, 0);
 		aborted = 1;
 	}
 	spin_lock_irqsave(&dev->irqlock, flags);
@@ -1042,3 +1043,10 @@ void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx)
 		ctx->ctrls[i] = NULL;
 }
 
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
+{
+	ctx->src_fmt = &formats[DEF_SRC_FMT_DEC];
+	ctx->dst_fmt = &formats[DEF_DST_FMT_DEC];
+	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
+			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
index fb8b215..c53baf8 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_dec_def_fmt(bool src);
 int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_dec_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_DEC_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index aa1c244..3099774 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -24,46 +24,48 @@
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
 #include <media/videobuf2-core.h>
-#include "regs-mfc.h"
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_enc.h"
 #include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
 
+#define DEF_SRC_FMT_ENC	2
+#define DEF_DST_FMT_ENC	4
+
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
@@ -637,7 +639,7 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		list_del(&dst_mb->list);
 		ctx->dst_queue_cnt--;
 		vb2_set_plane_payload(dst_mb->b, 0,
-						s5p_mfc_get_enc_strm_size());
+						s5p_mfc_get_enc_strm_size(dev));
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
@@ -687,8 +689,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned int strm_size;
 	unsigned long flags;
 
-	slice_type = s5p_mfc_get_enc_slice_type();
-	strm_size = s5p_mfc_get_enc_strm_size();
+	slice_type = s5p_mfc_get_enc_slice_type(dev);
+	strm_size = s5p_mfc_get_enc_strm_size(dev);
 	mfc_debug(2, "Encoded slice type: %d", slice_type);
 	mfc_debug(2, "Encoded stream size: %d", strm_size);
 	mfc_debug(2, "Display order: %d",
@@ -952,7 +954,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		s5p_mfc_clean_ctx_int_flags(ctx);
 		s5p_mfc_try_run(dev);
 		if (s5p_mfc_wait_for_done_ctx(ctx, \
-				S5P_FIMV_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
+				S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET, 1)) {
 				/* Error or timeout */
 			mfc_err("Error getting instance from hardware\n");
 			s5p_mfc_release_instance_buffer(ctx);
@@ -1671,7 +1673,7 @@ static int s5p_mfc_stop_streaming(struct vb2_queue *q)
 		ctx->state == MFCINST_RUNNING) &&
 		dev->curr_ctx == ctx->num && dev->hw_lock) {
 		ctx->state = MFCINST_ABORT;
-		s5p_mfc_wait_for_done_ctx(ctx, S5P_FIMV_R2H_CMD_FRAME_DONE_RET,
+		s5p_mfc_wait_for_done_ctx(ctx, S5P_MFC_R2H_CMD_FRAME_DONE_RET,
 					  0);
 	}
 	ctx->state = MFCINST_FINISHED;
@@ -1832,3 +1834,10 @@ void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx)
 	for (i = 0; i < NUM_CTRLS; i++)
 		ctx->ctrls[i] = NULL;
 }
+
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx)
+{
+	ctx->src_fmt = &formats[DEF_SRC_FMT_ENC];
+	ctx->dst_fmt = &formats[DEF_DST_FMT_ENC];
+}
+
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
index 405bdd3..413f22f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
@@ -19,5 +19,6 @@ const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
 struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
 int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_enc_ctrls_delete(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_init(struct s5p_mfc_ctx *ctx);
 
 #endif /* S5P_MFC_ENC_H_  */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
index 8f2f8bf..37637d6 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_intr.c
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
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index e6217cb..fd1e687 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -12,1386 +12,273 @@
  * published by the Free Software Foundation.
  */
 
-#include "regs-mfc.h"
-#include "s5p_mfc_cmd.h"
-#include "s5p_mfc_common.h"
-#include "s5p_mfc_ctrl.h"
-#include "s5p_mfc_debug.h"
-#include "s5p_mfc_intr.h"
 #include "s5p_mfc_opr.h"
-#include "s5p_mfc_pm.h"
-#include "s5p_mfc_shm.h"
-#include <asm/cacheflush.h>
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
-#include <linux/err.h>
-#include <linux/firmware.h>
-#include <linux/io.h>
-#include <linux/jiffies.h>
-#include <linux/mm.h>
-#include <linux/sched.h>
+#include "s5p_mfc_opr_v5.h"
 
-#define OFFSETA(x)		(((x) - dev->bank1) >> MFC_OFFSET_SHIFT)
-#define OFFSETB(x)		(((x) - dev->bank2) >> MFC_OFFSET_SHIFT)
+static const struct s5p_mfc_hw_ops *s5p_mfc_ops;
 
-/* Allocate temporary buffers for decoding */
-int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
 {
-	void *desc_virt;
-	struct s5p_mfc_dev *dev = ctx->dev;
+	s5p_mfc_ops = s5p_mfc_init_hw_ops_v5();
+	dev->warn_start = S5P_FIMV_ERR_WARNINGS_START;
+}
 
-	ctx->desc_buf = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
-	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
-		ctx->desc_buf = NULL;
-		mfc_err("Allocating DESC buffer failed\n");
-		return -ENOMEM;
-	}
-	ctx->desc_phys = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->desc_buf);
-	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
-	if (desc_virt == NULL) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = NULL;
-		mfc_err("Remapping DESC buffer failed\n");
-		return -ENOMEM;
-	}
-	memset(desc_virt, 0, DESC_BUF_SIZE);
-	wmb();
-	return 0;
+int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_alloc_dec_temp_buffers(ctx);
 }
 
-/* Release temporary buffers for decoding */
 void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->desc_phys) {
-		vb2_dma_contig_memops.put(ctx->desc_buf);
-		ctx->desc_phys = 0;
-		ctx->desc_buf = NULL;
-	}
+	return s5p_mfc_ops->s5p_mfc_release_dec_desc_buffer(ctx);
 }
 
-/* Allocate codec buffers */
 int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned int enc_ref_y_size = 0;
-	unsigned int enc_ref_c_size = 0;
-	unsigned int guard_width, guard_height;
-
-	if (ctx->type == MFCINST_DECODER) {
-		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
-			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
-		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
-	} else if (ctx->type == MFCINST_ENCODER) {
-		enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
-			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
-		enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
-
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
-			enc_ref_c_size = ALIGN(ctx->img_width,
-						S5P_FIMV_NV12MT_HALIGN)
-						* ALIGN(ctx->img_height >> 1,
-						S5P_FIMV_NV12MT_VALIGN);
-			enc_ref_c_size = ALIGN(enc_ref_c_size,
-							S5P_FIMV_NV12MT_SALIGN);
-		} else {
-			guard_width = ALIGN(ctx->img_width + 16,
-							S5P_FIMV_NV12MT_HALIGN);
-			guard_height = ALIGN((ctx->img_height >> 1) + 4,
-							S5P_FIMV_NV12MT_VALIGN);
-			enc_ref_c_size = ALIGN(guard_width * guard_height,
-					       S5P_FIMV_NV12MT_SALIGN);
-		}
-		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
-			  enc_ref_y_size, enc_ref_c_size);
-	} else {
-		return -EINVAL;
-	}
-	/* Codecs have different memory requirements */
-	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_DEC:
-		ctx->bank1_size =
-		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
-					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
-					S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = ctx->total_dpb_count * ctx->mv_size;
-		break;
-	case S5P_FIMV_CODEC_MPEG4_DEC:
-		ctx->bank1_size =
-		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
-				     S5P_FIMV_DEC_UPNB_MV_SIZE +
-				     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
-				     S5P_FIMV_DEC_STX_PARSER_SIZE +
-				     S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE,
-				     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
-		break;
-	case S5P_FIMV_CODEC_VC1RCV_DEC:
-	case S5P_FIMV_CODEC_VC1_DEC:
-		ctx->bank1_size =
-		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
-			     S5P_FIMV_DEC_UPNB_MV_SIZE +
-			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
-			     S5P_FIMV_DEC_NB_DCAC_SIZE +
-			     3 * S5P_FIMV_DEC_VC1_BITPLANE_SIZE,
-			     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
-		break;
-	case S5P_FIMV_CODEC_MPEG2_DEC:
-		ctx->bank1_size = 0;
-		ctx->bank2_size = 0;
-		break;
-	case S5P_FIMV_CODEC_H263_DEC:
-		ctx->bank1_size =
-		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
-			     S5P_FIMV_DEC_UPNB_MV_SIZE +
-			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
-			     S5P_FIMV_DEC_NB_DCAC_SIZE,
-			     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
-		break;
-	case S5P_FIMV_CODEC_H264_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
-				   S5P_FIMV_ENC_UPMV_SIZE +
-				   S5P_FIMV_ENC_COLFLG_SIZE +
-				   S5P_FIMV_ENC_INTRAMD_SIZE +
-				   S5P_FIMV_ENC_NBORINFO_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
-				   (enc_ref_c_size * 4) +
-				   S5P_FIMV_ENC_INTRAPRED_SIZE;
-		break;
-	case S5P_FIMV_CODEC_MPEG4_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
-				   S5P_FIMV_ENC_UPMV_SIZE +
-				   S5P_FIMV_ENC_COLFLG_SIZE +
-				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
-				   (enc_ref_c_size * 4);
-		break;
-	case S5P_FIMV_CODEC_H263_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
-				   S5P_FIMV_ENC_UPMV_SIZE +
-				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
-				   (enc_ref_c_size * 4);
-		break;
-	default:
-		break;
-	}
-	/* Allocate only if memory from bank 1 is necessary */
-	if (ctx->bank1_size > 0) {
-		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
-		if (IS_ERR(ctx->bank1_buf)) {
-			ctx->bank1_buf = NULL;
-			printk(KERN_ERR
-			       "Buf alloc for decoding failed (port A)\n");
-			return -ENOMEM;
-		}
-		ctx->bank1_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
-		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	}
-	/* Allocate only if memory from bank 2 is necessary */
-	if (ctx->bank2_size > 0) {
-		ctx->bank2_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_size);
-		if (IS_ERR(ctx->bank2_buf)) {
-			ctx->bank2_buf = NULL;
-			mfc_err("Buf alloc for decoding failed (port B)\n");
-			return -ENOMEM;
-		}
-		ctx->bank2_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_buf);
-		BUG_ON(ctx->bank2_phys & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
-	}
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_alloc_codec_buffers(ctx);
 }
 
-/* Release buffers allocated for codec */
 void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->bank1_buf) {
-		vb2_dma_contig_memops.put(ctx->bank1_buf);
-		ctx->bank1_buf = NULL;
-		ctx->bank1_phys = 0;
-		ctx->bank1_size = 0;
-	}
-	if (ctx->bank2_buf) {
-		vb2_dma_contig_memops.put(ctx->bank2_buf);
-		ctx->bank2_buf = NULL;
-		ctx->bank2_phys = 0;
-		ctx->bank2_size = 0;
-	}
+	return s5p_mfc_ops->s5p_mfc_release_codec_buffers(ctx);
 }
 
-/* Allocate memory for instance data buffer */
 int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx)
 {
-	void *context_virt;
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
-		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
-		ctx->ctx_size = MFC_H264_CTX_BUF_SIZE;
-	else
-		ctx->ctx_size = MFC_CTX_BUF_SIZE;
-	ctx->ctx_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_size);
-	if (IS_ERR(ctx->ctx_buf)) {
-		mfc_err("Allocating context buffer failed\n");
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
-		return -ENOMEM;
-	}
-	ctx->ctx_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_buf);
-	BUG_ON(ctx->ctx_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->ctx_ofs = OFFSETA(ctx->ctx_phys);
-	context_virt = vb2_dma_contig_memops.vaddr(ctx->ctx_buf);
-	if (context_virt == NULL) {
-		mfc_err("Remapping instance buffer failed\n");
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
-		return -ENOMEM;
-	}
-	/* Zero content of the allocated memory */
-	memset(context_virt, 0, ctx->ctx_size);
-	wmb();
-	if (s5p_mfc_init_shm(ctx) < 0) {
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
-		return -ENOMEM;
-	}
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_alloc_instance_buffer(ctx);
 }
 
-/* Release instance buffer */
 void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->ctx_buf) {
-		vb2_dma_contig_memops.put(ctx->ctx_buf);
-		ctx->ctx_phys = 0;
-		ctx->ctx_buf = NULL;
-	}
-	if (ctx->shm_alloc) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_alloc = NULL;
-		ctx->shm = NULL;
-	}
+	return s5p_mfc_ops->s5p_mfc_release_instance_buffer(ctx);
 }
 
-/* Set registers for decoding temporary buffers */
-void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mfc_write(dev, OFFSETA(ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
-	mfc_write(dev, DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+	return s5p_mfc_ops->s5p_mfc_alloc_dev_context_buffer(dev);
 }
 
-/* Set registers for shared buffer */
-static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
+	return s5p_mfc_ops->s5p_mfc_release_dev_context_buffer(dev);
 }
 
-/* Set registers for decoding stream buffer */
-int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx, int buf_addr,
-		  unsigned int start_num_byte, unsigned int buf_size)
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
+	return s5p_mfc_ops->s5p_mfc_dec_calc_dpb_size(ctx);
+}
 
-	mfc_write(dev, OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
-	mfc_write(dev, ctx->dec_src_buf_size, S5P_FIMV_SI_CH0_CPB_SIZE);
-	mfc_write(dev, buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
-	s5p_mfc_write_shm(ctx, start_num_byte, START_BYTE_NUM);
-	return 0;
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_enc_calc_src_size(ctx);
 }
 
-/* Set decoding frame buffer */
 int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 {
-	unsigned int frame_size, i;
-	unsigned int frame_size_ch, frame_size_mv;
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned int dpb;
-	size_t buf_addr1, buf_addr2;
-	int buf_size1, buf_size2;
-
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
-	buf_addr2 = ctx->bank2_phys;
-	buf_size2 = ctx->bank2_size;
-	dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
-						~S5P_FIMV_DPB_COUNT_MASK;
-	mfc_write(dev, ctx->total_dpb_count | dpb,
-						S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
-	s5p_mfc_set_shared_buffer(ctx);
-	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_DEC:
-		mfc_write(dev, OFFSETA(buf_addr1),
-						S5P_FIMV_H264_VERT_NB_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_VERT_NB_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H264_NB_IP_ADR);
-		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
-		break;
-	case S5P_FIMV_CODEC_MPEG4_DEC:
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_NB_DCAC_ADR);
-		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_NB_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SA_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SP_ADR);
-		buf_addr1 += S5P_FIMV_DEC_STX_PARSER_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_STX_PARSER_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_OT_LINE_ADR);
-		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		break;
-	case S5P_FIMV_CODEC_H263_DEC:
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_OT_LINE_ADR);
-		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_UP_NB_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_SA_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_NB_DCAC_ADR);
-		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
-		break;
-	case S5P_FIMV_CODEC_VC1_DEC:
-	case S5P_FIMV_CODEC_VC1RCV_DEC:
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_NB_DCAC_ADR);
-		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_OT_LINE_ADR);
-		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_UP_NB_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_SA_MV_ADR);
-		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE3_ADR);
-		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE2_ADR);
-		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE1_ADR);
-		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
-		break;
-	case S5P_FIMV_CODEC_MPEG2_DEC:
-		break;
-	default:
-		mfc_err("Unknown codec for decoding (%x)\n",
-			ctx->codec_mode);
-		return -EINVAL;
-		break;
-	}
-	frame_size = ctx->luma_size;
-	frame_size_ch = ctx->chroma_size;
-	frame_size_mv = ctx->mv_size;
-	mfc_debug(2, "Frm size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
-								frame_size_mv);
-	for (i = 0; i < ctx->total_dpb_count; i++) {
-		/* Bank2 */
-		mfc_debug(2, "Luma %d: %x\n", i,
-					ctx->dst_bufs[i].cookie.raw.luma);
-		mfc_write(dev, OFFSETB(ctx->dst_bufs[i].cookie.raw.luma),
-						S5P_FIMV_DEC_LUMA_ADR + i * 4);
-		mfc_debug(2, "\tChroma %d: %x\n", i,
-					ctx->dst_bufs[i].cookie.raw.chroma);
-		mfc_write(dev, OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
-					       S5P_FIMV_DEC_CHROMA_ADR + i * 4);
-		if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC) {
-			mfc_debug(2, "\tBuf2: %x, size: %d\n",
-							buf_addr2, buf_size2);
-			mfc_write(dev, OFFSETB(buf_addr2),
-						S5P_FIMV_H264_MV_ADR + i * 4);
-			buf_addr2 += frame_size_mv;
-			buf_size2 -= frame_size_mv;
-		}
-	}
-	mfc_debug(2, "Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
-	mfc_debug(2, "Buf 1/2 size after: %d/%d (frames %d)\n",
-			buf_size1,  buf_size2, ctx->total_dpb_count);
-	if (buf_size1 < 0 || buf_size2 < 0) {
-		mfc_debug(2, "Not enough memory has been allocated\n");
-		return -ENOMEM;
-	}
-	s5p_mfc_write_shm(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
-	s5p_mfc_write_shm(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC)
-		s5p_mfc_write_shm(ctx, frame_size_mv, ALLOC_MV_SIZE);
-	mfc_write(dev, ((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK)
-					<< S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
-						S5P_FIMV_SI_CH0_INST_ID);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_set_dec_frame_buffer(ctx);
 }
 
-/* Set registers for encoding stream buffer */
 int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long addr, unsigned int size)
+			unsigned long addr, unsigned int size)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mfc_write(dev, OFFSETA(addr), S5P_FIMV_ENC_SI_CH0_SB_ADR);
-	mfc_write(dev, size, S5P_FIMV_ENC_SI_CH0_SB_SIZE);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_set_enc_stream_buffer(ctx, addr, size);
 }
 
 void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long y_addr, unsigned long c_addr)
+			unsigned long y_addr, unsigned long c_addr)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	mfc_write(dev, OFFSETB(y_addr), S5P_FIMV_ENC_SI_CH0_CUR_Y_ADR);
-	mfc_write(dev, OFFSETB(c_addr), S5P_FIMV_ENC_SI_CH0_CUR_C_ADR);
+	return s5p_mfc_ops->s5p_mfc_set_enc_frame_buffer(ctx, y_addr, c_addr);
 }
 
 void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
-		unsigned long *y_addr, unsigned long *c_addr)
+			unsigned long *y_addr, unsigned long *c_addr)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-
-	*y_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_Y_ADDR)
-							<< MFC_OFFSET_SHIFT);
-	*c_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_C_ADDR)
-							<< MFC_OFFSET_SHIFT);
+	return s5p_mfc_ops->s5p_mfc_get_enc_frame_buffer(ctx, y_addr, c_addr);
 }
 
-/* Set encoding ref & codec buffer */
 int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	size_t buf_addr1, buf_addr2;
-	size_t buf_size1, buf_size2;
-	unsigned int enc_ref_y_size, enc_ref_c_size;
-	unsigned int guard_width, guard_height;
-	int i;
-
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
-	buf_addr2 = ctx->bank2_phys;
-	buf_size2 = ctx->bank2_size;
-	enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
-		* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
-	enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC) {
-		enc_ref_c_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
-			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
-		enc_ref_c_size = ALIGN(enc_ref_c_size, S5P_FIMV_NV12MT_SALIGN);
-	} else {
-		guard_width = ALIGN(ctx->img_width + 16,
-						S5P_FIMV_NV12MT_HALIGN);
-		guard_height = ALIGN((ctx->img_height >> 1) + 4,
-						S5P_FIMV_NV12MT_VALIGN);
-		enc_ref_c_size = ALIGN(guard_width * guard_height,
-				       S5P_FIMV_NV12MT_SALIGN);
-	}
-	mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
-	switch (ctx->codec_mode) {
-	case S5P_FIMV_CODEC_H264_ENC:
-		for (i = 0; i < 2; i++) {
-			mfc_write(dev, OFFSETA(buf_addr1),
-				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
-			buf_addr1 += enc_ref_y_size;
-			buf_size1 -= enc_ref_y_size;
-
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_y_size;
-			buf_size2 -= enc_ref_y_size;
-		}
-		for (i = 0; i < 4; i++) {
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_c_size;
-			buf_size2 -= enc_ref_c_size;
-		}
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H264_UP_MV_ADR);
-		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1),
-					S5P_FIMV_H264_COZERO_FLAG_ADR);
-		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1),
-					S5P_FIMV_H264_UP_INTRA_MD_ADR);
-		buf_addr1 += S5P_FIMV_ENC_INTRAMD_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_INTRAMD_SIZE;
-		mfc_write(dev, OFFSETB(buf_addr2),
-					S5P_FIMV_H264_UP_INTRA_PRED_ADR);
-		buf_addr2 += S5P_FIMV_ENC_INTRAPRED_SIZE;
-		buf_size2 -= S5P_FIMV_ENC_INTRAPRED_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1),
-					S5P_FIMV_H264_NBOR_INFO_ADR);
-		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
-			buf_size1, buf_size2);
-		break;
-	case S5P_FIMV_CODEC_MPEG4_ENC:
-		for (i = 0; i < 2; i++) {
-			mfc_write(dev, OFFSETA(buf_addr1),
-				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
-			buf_addr1 += enc_ref_y_size;
-			buf_size1 -= enc_ref_y_size;
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_y_size;
-			buf_size2 -= enc_ref_y_size;
-		}
-		for (i = 0; i < 4; i++) {
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_c_size;
-			buf_size2 -= enc_ref_c_size;
-		}
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_MV_ADR);
-		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1),
-						S5P_FIMV_MPEG4_COZERO_FLAG_ADR);
-		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1),
-						S5P_FIMV_MPEG4_ACDC_COEF_ADR);
-		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
-			buf_size1, buf_size2);
-		break;
-	case S5P_FIMV_CODEC_H263_ENC:
-		for (i = 0; i < 2; i++) {
-			mfc_write(dev, OFFSETA(buf_addr1),
-				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
-			buf_addr1 += enc_ref_y_size;
-			buf_size1 -= enc_ref_y_size;
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_y_size;
-			buf_size2 -= enc_ref_y_size;
-		}
-		for (i = 0; i < 4; i++) {
-			mfc_write(dev, OFFSETB(buf_addr2),
-				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
-			buf_addr2 += enc_ref_c_size;
-			buf_size2 -= enc_ref_c_size;
-		}
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_UP_MV_ADR);
-		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
-		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_ACDC_COEF_ADR);
-		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
-			buf_size1, buf_size2);
-		break;
-	default:
-		mfc_err("Unknown codec set for encoding: %d\n",
-			ctx->codec_mode);
-		return -EINVAL;
-	}
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_set_enc_ref_buffer(ctx);
 }
 
-static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_enc_params *p = &ctx->enc_params;
-	unsigned int reg;
-	unsigned int shm;
-
-	/* width */
-	mfc_write(dev, ctx->img_width, S5P_FIMV_ENC_HSIZE_PX);
-	/* height */
-	mfc_write(dev, ctx->img_height, S5P_FIMV_ENC_VSIZE_PX);
-	/* pictype : enable, IDR period */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	reg |= (1 << 18);
-	reg &= ~(0xFFFF);
-	reg |= p->gop_size;
-	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	mfc_write(dev, 0, S5P_FIMV_ENC_B_RECON_WRITE_ON);
-	/* multi-slice control */
-	/* multi-slice MB number or bit size */
-	mfc_write(dev, p->slice_mode, S5P_FIMV_ENC_MSLICE_CTRL);
-	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
-		mfc_write(dev, p->slice_mb, S5P_FIMV_ENC_MSLICE_MB);
-	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
-		mfc_write(dev, p->slice_bit, S5P_FIMV_ENC_MSLICE_BIT);
-	} else {
-		mfc_write(dev, 0, S5P_FIMV_ENC_MSLICE_MB);
-		mfc_write(dev, 0, S5P_FIMV_ENC_MSLICE_BIT);
-	}
-	/* cyclic intra refresh */
-	mfc_write(dev, p->intra_refresh_mb, S5P_FIMV_ENC_CIR_CTRL);
-	/* memory structure cur. frame */
-	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
-		mfc_write(dev, 0, S5P_FIMV_ENC_MAP_FOR_CUR);
-	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
-		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
-	/* padding control & value */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PADDING_CTRL);
-	if (p->pad) {
-		/** enable */
-		reg |= (1 << 31);
-		/** cr value */
-		reg &= ~(0xFF << 16);
-		reg |= (p->pad_cr << 16);
-		/** cb value */
-		reg &= ~(0xFF << 8);
-		reg |= (p->pad_cb << 8);
-		/** y value */
-		reg &= ~(0xFF);
-		reg |= (p->pad_luma);
-	} else {
-		/** disable & all value clear */
-		reg = 0;
-	}
-	mfc_write(dev, reg, S5P_FIMV_ENC_PADDING_CTRL);
-	/* rate control config. */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
-	/** frame-level rate control */
-	reg &= ~(0x1 << 9);
-	reg |= (p->rc_frame << 9);
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
-	/* bit rate */
-	if (p->rc_frame)
-		mfc_write(dev, p->rc_bitrate,
-			S5P_FIMV_ENC_RC_BIT_RATE);
-	else
-		mfc_write(dev, 0, S5P_FIMV_ENC_RC_BIT_RATE);
-	/* reaction coefficient */
-	if (p->rc_frame)
-		mfc_write(dev, p->rc_reaction_coeff, S5P_FIMV_ENC_RC_RPARA);
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
-	/* seq header ctrl */
-	shm &= ~(0x1 << 3);
-	shm |= (p->seq_hdr_mode << 3);
-	/* frame skip mode */
-	shm &= ~(0x3 << 1);
-	shm |= (p->frame_skip_mode << 1);
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
-	/* fixed target bit */
-	s5p_mfc_write_shm(ctx, p->fixed_target_bit, RC_CONTROL_CONFIG);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_init_decode(ctx);
 }
 
-static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_enc_params *p = &ctx->enc_params;
-	struct s5p_mfc_h264_enc_params *p_264 = &p->codec.h264;
-	unsigned int reg;
-	unsigned int shm;
-
-	s5p_mfc_set_enc_params(ctx);
-	/* pictype : number of B */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	/* num_b_frame - 0 ~ 2 */
-	reg &= ~(0x3 << 16);
-	reg |= (p->num_b_frame << 16);
-	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	/* profile & level */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PROFILE);
-	/* level */
-	reg &= ~(0xFF << 8);
-	reg |= (p_264->level << 8);
-	/* profile - 0 ~ 2 */
-	reg &= ~(0x3F);
-	reg |= p_264->profile;
-	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
-	/* interlace  */
-	mfc_write(dev, p->interlace, S5P_FIMV_ENC_PIC_STRUCT);
-	/* height */
-	if (p->interlace)
-		mfc_write(dev, ctx->img_height >> 1, S5P_FIMV_ENC_VSIZE_PX);
-	/* loopfilter ctrl */
-	mfc_write(dev, p_264->loop_filter_mode, S5P_FIMV_ENC_LF_CTRL);
-	/* loopfilter alpha offset */
-	if (p_264->loop_filter_alpha < 0) {
-		reg = 0x10;
-		reg |= (0xFF - p_264->loop_filter_alpha) + 1;
-	} else {
-		reg = 0x00;
-		reg |= (p_264->loop_filter_alpha & 0xF);
-	}
-	mfc_write(dev, reg, S5P_FIMV_ENC_ALPHA_OFF);
-	/* loopfilter beta offset */
-	if (p_264->loop_filter_beta < 0) {
-		reg = 0x10;
-		reg |= (0xFF - p_264->loop_filter_beta) + 1;
-	} else {
-		reg = 0x00;
-		reg |= (p_264->loop_filter_beta & 0xF);
-	}
-	mfc_write(dev, reg, S5P_FIMV_ENC_BETA_OFF);
-	/* entropy coding mode */
-	if (p_264->entropy_mode == V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC)
-		mfc_write(dev, 1, S5P_FIMV_ENC_H264_ENTROPY_MODE);
-	else
-		mfc_write(dev, 0, S5P_FIMV_ENC_H264_ENTROPY_MODE);
-	/* number of ref. picture */
-	reg = mfc_read(dev, S5P_FIMV_ENC_H264_NUM_OF_REF);
-	/* num of ref. pictures of P */
-	reg &= ~(0x3 << 5);
-	reg |= (p_264->num_ref_pic_4p << 5);
-	/* max number of ref. pictures */
-	reg &= ~(0x1F);
-	reg |= p_264->max_ref_pic;
-	mfc_write(dev, reg, S5P_FIMV_ENC_H264_NUM_OF_REF);
-	/* 8x8 transform enable */
-	mfc_write(dev, p_264->_8x8_transform, S5P_FIMV_ENC_H264_TRANS_FLAG);
-	/* rate control config. */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
-	/* macroblock level rate control */
-	reg &= ~(0x1 << 8);
-	reg |= (p_264->rc_mb << 8);
-	/* frame QP */
-	reg &= ~(0x3F);
-	reg |= p_264->rc_frame_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_denom)
-		mfc_write(dev, p->rc_framerate_num * 1000
-			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
-	else
-		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
-	/* max & min value of QP */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
-	/* max QP */
-	reg &= ~(0x3F << 8);
-	reg |= (p_264->rc_max_qp << 8);
-	/* min QP */
-	reg &= ~(0x3F);
-	reg |= p_264->rc_min_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
-	/* macroblock adaptive scaling features */
-	if (p_264->rc_mb) {
-		reg = mfc_read(dev, S5P_FIMV_ENC_RC_MB_CTRL);
-		/* dark region */
-		reg &= ~(0x1 << 3);
-		reg |= (p_264->rc_mb_dark << 3);
-		/* smooth region */
-		reg &= ~(0x1 << 2);
-		reg |= (p_264->rc_mb_smooth << 2);
-		/* static region */
-		reg &= ~(0x1 << 1);
-		reg |= (p_264->rc_mb_static << 1);
-		/* high activity region */
-		reg &= ~(0x1);
-		reg |= p_264->rc_mb_activity;
-		mfc_write(dev, reg, S5P_FIMV_ENC_RC_MB_CTRL);
-	}
-	if (!p->rc_frame &&
-	    !p_264->rc_mb) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
-		shm &= ~(0xFFF);
-		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
-		shm |= (p_264->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
-	}
-	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
-	/* AR VUI control */
-	shm &= ~(0x1 << 15);
-	shm |= (p_264->vui_sar << 1);
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
-	if (p_264->vui_sar) {
-		/* aspect ration IDC */
-		shm = s5p_mfc_read_shm(ctx, SAMPLE_ASPECT_RATIO_IDC);
-		shm &= ~(0xFF);
-		shm |= p_264->vui_sar_idc;
-		s5p_mfc_write_shm(ctx, shm, SAMPLE_ASPECT_RATIO_IDC);
-		if (p_264->vui_sar_idc == 0xFF) {
-			/* sample  AR info */
-			shm = s5p_mfc_read_shm(ctx, EXTENDED_SAR);
-			shm &= ~(0xFFFFFFFF);
-			shm |= p_264->vui_ext_sar_width << 16;
-			shm |= p_264->vui_ext_sar_height;
-			s5p_mfc_write_shm(ctx, shm, EXTENDED_SAR);
-		}
-	}
-	/* intra picture period for H.264 */
-	shm = s5p_mfc_read_shm(ctx, H264_I_PERIOD);
-	/* control */
-	shm &= ~(0x1 << 16);
-	shm |= (p_264->open_gop << 16);
-	/* value */
-	if (p_264->open_gop) {
-		shm &= ~(0xFFFF);
-		shm |= p_264->open_gop_size;
-	}
-	s5p_mfc_write_shm(ctx, shm, H264_I_PERIOD);
-	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
-	/* vbv buffer size */
-	if (p->frame_skip_mode ==
-			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		shm &= ~(0xFFFF << 16);
-		shm |= (p_264->cpb_size << 16);
-	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_init_encode(ctx);
 }
 
-static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_enc_params *p = &ctx->enc_params;
-	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
-	unsigned int reg;
-	unsigned int shm;
-	unsigned int framerate;
-
-	s5p_mfc_set_enc_params(ctx);
-	/* pictype : number of B */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	/* num_b_frame - 0 ~ 2 */
-	reg &= ~(0x3 << 16);
-	reg |= (p->num_b_frame << 16);
-	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
-	/* profile & level */
-	reg = mfc_read(dev, S5P_FIMV_ENC_PROFILE);
-	/* level */
-	reg &= ~(0xFF << 8);
-	reg |= (p_mpeg4->level << 8);
-	/* profile - 0 ~ 2 */
-	reg &= ~(0x3F);
-	reg |= p_mpeg4->profile;
-	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
-	/* quarter_pixel */
-	mfc_write(dev, p_mpeg4->quarter_pixel, S5P_FIMV_ENC_MPEG4_QUART_PXL);
-	/* qp */
-	if (!p->rc_frame) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
-		shm &= ~(0xFFF);
-		shm |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 6);
-		shm |= (p_mpeg4->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
-	}
-	/* frame rate */
-	if (p->rc_frame) {
-		if (p->rc_framerate_denom > 0) {
-			framerate = p->rc_framerate_num * 1000 /
-						p->rc_framerate_denom;
-			mfc_write(dev, framerate,
-				S5P_FIMV_ENC_RC_FRAME_RATE);
-			shm = s5p_mfc_read_shm(ctx, RC_VOP_TIMING);
-			shm &= ~(0xFFFFFFFF);
-			shm |= (1 << 31);
-			shm |= ((p->rc_framerate_num & 0x7FFF) << 16);
-			shm |= (p->rc_framerate_denom & 0xFFFF);
-			s5p_mfc_write_shm(ctx, shm, RC_VOP_TIMING);
-		}
-	} else {
-		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
-	}
-	/* rate control config. */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
-	/* frame QP */
-	reg &= ~(0x3F);
-	reg |= p_mpeg4->rc_frame_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
-	/* max & min value of QP */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
-	/* max QP */
-	reg &= ~(0x3F << 8);
-	reg |= (p_mpeg4->rc_max_qp << 8);
-	/* min QP */
-	reg &= ~(0x3F);
-	reg |= p_mpeg4->rc_min_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
-	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
-	/* vbv buffer size */
-	if (p->frame_skip_mode ==
-			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		shm &= ~(0xFFFF << 16);
-		shm |= (p->vbv_size << 16);
-	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_encode_one_frame(ctx);
 }
 
-static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_enc_params *p = &ctx->enc_params;
-	struct s5p_mfc_mpeg4_enc_params *p_h263 = &p->codec.mpeg4;
-	unsigned int reg;
-	unsigned int shm;
-
-	s5p_mfc_set_enc_params(ctx);
-	/* qp */
-	if (!p->rc_frame) {
-		shm = s5p_mfc_read_shm(ctx, P_B_FRAME_QP);
-		shm &= ~(0xFFF);
-		shm |= (p_h263->rc_p_frame_qp & 0x3F);
-		s5p_mfc_write_shm(ctx, shm, P_B_FRAME_QP);
-	}
-	/* frame rate */
-	if (p->rc_frame && p->rc_framerate_denom)
-		mfc_write(dev, p->rc_framerate_num * 1000
-			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
-	else
-		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
-	/* rate control config. */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
-	/* frame QP */
-	reg &= ~(0x3F);
-	reg |= p_h263->rc_frame_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
-	/* max & min value of QP */
-	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
-	/* max QP */
-	reg &= ~(0x3F << 8);
-	reg |= (p_h263->rc_max_qp << 8);
-	/* min QP */
-	reg &= ~(0x3F);
-	reg |= p_h263->rc_min_qp;
-	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
-	/* extended encoder ctrl */
-	shm = s5p_mfc_read_shm(ctx, EXT_ENC_CONTROL);
-	/* vbv buffer size */
-	if (p->frame_skip_mode ==
-			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
-		shm &= ~(0xFFFF << 16);
-		shm |= (p->vbv_size << 16);
-	}
-	s5p_mfc_write_shm(ctx, shm, EXT_ENC_CONTROL);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_try_run(dev);
 }
 
-/* Initialize decoding */
-int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
+void s5p_mfc_cleanup_queue(struct list_head *lh,
+			struct vb2_queue *vq)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
+	return s5p_mfc_ops->s5p_mfc_cleanup_queue(lh, vq);
+}
 
-	s5p_mfc_set_shared_buffer(ctx);
-	/* Setup loop filter, for decoding this is only valid for MPEG4 */
-	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC)
-		mfc_write(dev, ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
-	else
-		mfc_write(dev, 0, S5P_FIMV_ENC_LF_CTRL);
-	mfc_write(dev, ((ctx->slice_interface & S5P_FIMV_SLICE_INT_MASK) <<
-		S5P_FIMV_SLICE_INT_SHIFT) | (ctx->display_delay_enable <<
-		S5P_FIMV_DDELAY_ENA_SHIFT) | ((ctx->display_delay &
-		S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
-		S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
-	mfc_write(dev,
-	((S5P_FIMV_CH_SEQ_HEADER & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
-				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
-	return 0;
+void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_clear_int_flags(dev);
 }
 
-static void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data,
+			unsigned int ofs)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned int dpb;
+	return s5p_mfc_ops->s5p_mfc_write_info(ctx, data, ofs);
+}
 
-	if (flush)
-		dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (
-			S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
-	else
-		dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
-			~(S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
-	mfc_write(dev, dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx,
+			unsigned int ofs)
+{
+	return s5p_mfc_ops->s5p_mfc_read_info(ctx, ofs);
 }
 
-/* Decode a single frame */
-int s5p_mfc_decode_one_frame(struct s5p_mfc_ctx *ctx,
-					enum s5p_mfc_decode_arg last_frame)
+int s5p_mfc_get_dspl_y_adr(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
+	return s5p_mfc_ops->s5p_mfc_get_dspl_y_adr(dev);
+}
 
-	mfc_write(dev, ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
-	s5p_mfc_set_shared_buffer(ctx);
-	s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
-	/* Issue different commands to instance basing on whether it
-	 * is the last frame or not. */
-	switch (last_frame) {
-	case MFC_DEC_FRAME:
-		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
-		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
-		break;
-	case MFC_DEC_LAST_FRAME:
-		mfc_write(dev, ((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
-		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
-		break;
-	case MFC_DEC_RES_CHANGE:
-		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START_REALLOC &
-		S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
-		S5P_FIMV_SI_CH0_INST_ID);
-		break;
-	}
-	mfc_debug(2, "Decoding a usual frame\n");
-	return 0;
+int s5p_mfc_get_dec_y_adr(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_dec_y_adr(dev);
+}
+int s5p_mfc_get_dspl_status(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_dspl_status(dev);
 }
 
-int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_dec_status(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
+	return s5p_mfc_ops->s5p_mfc_get_dec_status(dev);
+}
 
-	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
-		s5p_mfc_set_enc_params_h264(ctx);
-	else if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_ENC)
-		s5p_mfc_set_enc_params_mpeg4(ctx);
-	else if (ctx->codec_mode == S5P_FIMV_CODEC_H263_ENC)
-		s5p_mfc_set_enc_params_h263(ctx);
-	else {
-		mfc_err("Unknown codec for encoding (%x)\n",
-			ctx->codec_mode);
-		return -EINVAL;
-	}
-	s5p_mfc_set_shared_buffer(ctx);
-	mfc_write(dev, ((S5P_FIMV_CH_SEQ_HEADER << 16) & 0x70000) |
-		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
-	return 0;
+int s5p_mfc_get_dec_frame_type(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_dec_frame_type(dev);
 }
 
-/* Encode a single frame */
-int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_disp_frame_type(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	/* memory structure cur. frame */
-	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
-		mfc_write(dev, 0, S5P_FIMV_ENC_MAP_FOR_CUR);
-	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
-		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
-	s5p_mfc_set_shared_buffer(ctx);
-	mfc_write(dev, (S5P_FIMV_CH_FRAME_START << 16 & 0x70000) |
-		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
-	return 0;
+	return s5p_mfc_ops->s5p_mfc_get_disp_frame_type(ctx);
 }
 
-static int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
+int s5p_mfc_get_consumed_stream(struct s5p_mfc_dev *dev)
 {
-	unsigned long flags;
-	int new_ctx;
-	int cnt;
+	return s5p_mfc_ops->s5p_mfc_get_consumed_stream(dev);
+}
 
-	spin_lock_irqsave(&dev->condlock, flags);
-	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
-	cnt = 0;
-	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
-		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
-		if (++cnt > MFC_NUM_CONTEXTS) {
-			/* No contexts to run */
-			spin_unlock_irqrestore(&dev->condlock, flags);
-			return -EAGAIN;
-		}
-	}
-	spin_unlock_irqrestore(&dev->condlock, flags);
-	return new_ctx;
+int s5p_mfc_get_int_reason(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_int_reason(dev);
 }
 
-static void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_int_err(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
+	return s5p_mfc_ops->s5p_mfc_get_int_err(dev);
+}
 
-	s5p_mfc_set_dec_stream_buffer(ctx, 0, 0, 0);
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_decode_one_frame(ctx, MFC_DEC_RES_CHANGE);
+int s5p_mfc_get_warn_start(struct s5p_mfc_dev *dev)
+{
+	return dev->warn_start;
 }
 
-static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
+int s5p_mfc_err_dec(unsigned int err)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct s5p_mfc_buf *temp_vb;
-	unsigned long flags;
-	unsigned int index;
+	return s5p_mfc_ops->s5p_mfc_err_dec(err);
+}
 
-	spin_lock_irqsave(&dev->irqlock, flags);
-	/* Frames are being decoded */
-	if (list_empty(&ctx->src_queue)) {
-		mfc_debug(2, "No src buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		return -EAGAIN;
-	}
-	/* Get the next source buffer */
-	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	temp_vb->used = 1;
-	s5p_mfc_set_dec_stream_buffer(ctx,
-		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), ctx->consumed_stream,
-					temp_vb->b->v4l2_planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-	index = temp_vb->b->v4l2_buf.index;
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
-		last_frame = MFC_DEC_LAST_FRAME;
-		mfc_debug(2, "Setting ctx->state to FINISHING\n");
-		ctx->state = MFCINST_FINISHING;
-	}
-	s5p_mfc_decode_one_frame(ctx, last_frame);
-	return 0;
+int s5p_mfc_err_dspl(unsigned int err)
+{
+	return s5p_mfc_ops->s5p_mfc_err_dspl(err);
 }
 
-static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_img_width(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
-	struct s5p_mfc_buf *dst_mb;
-	struct s5p_mfc_buf *src_mb;
-	unsigned long src_y_addr, src_c_addr, dst_addr;
-	unsigned int dst_size;
+	return s5p_mfc_ops->s5p_mfc_get_img_width(dev);
+}
 
-	spin_lock_irqsave(&dev->irqlock, flags);
-	if (list_empty(&ctx->src_queue)) {
-		mfc_debug(2, "no src buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		return -EAGAIN;
-	}
-	if (list_empty(&ctx->dst_queue)) {
-		mfc_debug(2, "no dst buffers\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		return -EAGAIN;
-	}
-	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	src_mb->used = 1;
-	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
-	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
-	s5p_mfc_set_enc_frame_buffer(ctx, src_y_addr, src_c_addr);
-	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_mb->used = 1;
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_encode_one_frame(ctx);
-	return 0;
+int s5p_mfc_get_img_height(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_img_height(dev);
 }
 
-static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_dpb_count(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
-	struct s5p_mfc_buf *temp_vb;
+	return s5p_mfc_ops->s5p_mfc_get_dpb_count(dev);
+}
 
-	/* Initializing decoding - parsing header */
-	spin_lock_irqsave(&dev->irqlock, flags);
-	mfc_debug(2, "Preparing to init decoding\n");
-	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	s5p_mfc_set_dec_desc_buffer(ctx);
-	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
-	s5p_mfc_set_dec_stream_buffer(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-				0, temp_vb->b->v4l2_planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_init_decode(ctx);
+int s5p_mfc_get_mv_count(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_mv_count(dev);
 }
 
-static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_inst_no(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
-	struct s5p_mfc_buf *dst_mb;
-	unsigned long dst_addr;
-	unsigned int dst_size;
+	return s5p_mfc_ops->s5p_mfc_get_inst_no(dev);
+}
 
-	s5p_mfc_set_enc_ref_buffer(ctx);
-	spin_lock_irqsave(&dev->irqlock, flags);
-	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
-	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
-	dst_size = vb2_plane_size(dst_mb->b, 0);
-	s5p_mfc_set_enc_stream_buffer(ctx, dst_addr, dst_size);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	s5p_mfc_init_encode(ctx);
+int s5p_mfc_get_enc_strm_size(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_enc_strm_size(dev);
 }
 
-static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+int s5p_mfc_get_enc_slice_type(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_dev *dev = ctx->dev;
-	unsigned long flags;
-	struct s5p_mfc_buf *temp_vb;
-	int ret;
+	return s5p_mfc_ops->s5p_mfc_get_enc_slice_type(dev);
+}
 
-	/*
-	 * Header was parsed now starting processing
-	 * First set the output frame buffers
-	 */
-	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
-		mfc_err("It seems that not all destionation buffers were "
-			"mmaped\nMFC requires that all destination are mmaped "
-			"before starting processing\n");
-		return -EAGAIN;
-	}
-	spin_lock_irqsave(&dev->irqlock, flags);
-	if (list_empty(&ctx->src_queue)) {
-		mfc_err("Header has been deallocated in the middle of"
-			" initialization\n");
-		spin_unlock_irqrestore(&dev->irqlock, flags);
-		return -EIO;
-	}
-	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
-	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
-	s5p_mfc_set_dec_stream_buffer(ctx,
-				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
-				0, temp_vb->b->v4l2_planes[0].bytesused);
-	spin_unlock_irqrestore(&dev->irqlock, flags);
-	dev->curr_ctx = ctx->num;
-	s5p_mfc_clean_ctx_int_flags(ctx);
-	ret = s5p_mfc_set_dec_frame_buffer(ctx);
-	if (ret) {
-		mfc_err("Failed to alloc frame mem\n");
-		ctx->state = MFCINST_ERROR;
-	}
-	return ret;
+int s5p_mfc_get_enc_dpb_count(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_enc_dpb_count(dev);
 }
 
-/* Try running an operation on hardware */
-void s5p_mfc_try_run(struct s5p_mfc_dev *dev)
+int s5p_mfc_get_enc_pic_count(struct s5p_mfc_dev *dev)
 {
-	struct s5p_mfc_ctx *ctx;
-	int new_ctx;
-	unsigned int ret = 0;
+	return s5p_mfc_ops->s5p_mfc_get_enc_pic_count(dev);
+}
 
-	if (test_bit(0, &dev->enter_suspend)) {
-		mfc_debug(1, "Entering suspend so do not schedule any jobs\n");
-		return;
-	}
-	/* Check whether hardware is not running */
-	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
-		/* This is perfectly ok, the scheduled ctx should wait */
-		mfc_debug(1, "Couldn't lock HW\n");
-		return;
-	}
-	/* Choose the context to run */
-	new_ctx = s5p_mfc_get_new_ctx(dev);
-	if (new_ctx < 0) {
-		/* No contexts to run */
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
-			mfc_err("Failed to unlock hardware\n");
-			return;
-		}
-		mfc_debug(1, "No ctx is scheduled to be run\n");
-		return;
-	}
-	ctx = dev->ctx[new_ctx];
-	/* Got context to run in ctx */
-	/*
-	 * Last frame has already been sent to MFC.
-	 * Now obtaining frames from MFC buffer
-	 */
-	s5p_mfc_clock_on();
-	if (ctx->type == MFCINST_DECODER) {
-		s5p_mfc_set_dec_desc_buffer(ctx);
-		switch (ctx->state) {
-		case MFCINST_FINISHING:
-			s5p_mfc_run_dec_frame(ctx, MFC_DEC_LAST_FRAME);
-			break;
-		case MFCINST_RUNNING:
-			ret = s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
-			break;
-		case MFCINST_INIT:
-			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_open_inst_cmd(ctx);
-			break;
-		case MFCINST_RETURN_INST:
-			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_close_inst_cmd(ctx);
-			break;
-		case MFCINST_GOT_INST:
-			s5p_mfc_run_init_dec(ctx);
-			break;
-		case MFCINST_HEAD_PARSED:
-			ret = s5p_mfc_run_init_dec_buffers(ctx);
-			mfc_debug(1, "head parsed\n");
-			break;
-		case MFCINST_RES_CHANGE_INIT:
-			s5p_mfc_run_res_change(ctx);
-			break;
-		case MFCINST_RES_CHANGE_FLUSH:
-			s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
-			break;
-		case MFCINST_RES_CHANGE_END:
-			mfc_debug(2, "Finished remaining frames after resolution change\n");
-			ctx->capture_state = QUEUE_FREE;
-			mfc_debug(2, "Will re-init the codec\n");
-			s5p_mfc_run_init_dec(ctx);
-			break;
-		default:
-			ret = -EAGAIN;
-		}
-	} else if (ctx->type == MFCINST_ENCODER) {
-		switch (ctx->state) {
-		case MFCINST_FINISHING:
-		case MFCINST_RUNNING:
-			ret = s5p_mfc_run_enc_frame(ctx);
-			break;
-		case MFCINST_INIT:
-			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_open_inst_cmd(ctx);
-			break;
-		case MFCINST_RETURN_INST:
-			s5p_mfc_clean_ctx_int_flags(ctx);
-			ret = s5p_mfc_close_inst_cmd(ctx);
-			break;
-		case MFCINST_GOT_INST:
-			s5p_mfc_run_init_enc(ctx);
-			break;
-		default:
-			ret = -EAGAIN;
-		}
-	} else {
-		mfc_err("Invalid context type: %d\n", ctx->type);
-		ret = -EAGAIN;
-	}
+int s5p_mfc_get_sei_avail_status(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_get_sei_avail_status(ctx);
+}
 
-	if (ret) {
-		/* Free hardware lock */
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			mfc_err("Failed to unlock hardware\n");
+int s5p_mfc_get_mvc_num_views(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_mvc_num_views(dev);
+}
 
-		/* This is in deed imporant, as no operation has been
-		 * scheduled, reduce the clock count as no one will
-		 * ever do this, because no interrupt related to this try_run
-		 * will ever come from hardware. */
-		s5p_mfc_clock_off();
-	}
+int s5p_mfc_get_mvc_view_id(struct s5p_mfc_dev *dev)
+{
+	return s5p_mfc_ops->s5p_mfc_get_mvc_view_id(dev);
 }
 
+unsigned int s5p_mfc_get_pic_type_top(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_get_pic_type_top(ctx);
+}
 
-void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq)
+unsigned int s5p_mfc_get_pic_type_bot(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_buf *b;
-	int i;
+	return s5p_mfc_ops->s5p_mfc_get_pic_type_bot(ctx);
+}
 
-	while (!list_empty(lh)) {
-		b = list_entry(lh->next, struct s5p_mfc_buf, list);
-		for (i = 0; i < b->b->num_planes; i++)
-			vb2_set_plane_payload(b->b, i, 0);
-		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
-		list_del(&b->list);
-	}
+unsigned int s5p_mfc_get_crop_info_h(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_get_crop_info_h(ctx);
 }
 
+unsigned int s5p_mfc_get_crop_info_v(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_ops->s5p_mfc_get_crop_info_v(ctx);
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
index 5932d1c..8e3c839 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.h
@@ -17,77 +17,129 @@
 
 #include "s5p_mfc_common.h"
 
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
+struct s5p_mfc_hw_ops {
+	int (*s5p_mfc_alloc_dec_temp_buffers)(struct s5p_mfc_ctx *ctx);
+	void (*s5p_mfc_release_dec_desc_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_alloc_codec_buffers)(struct s5p_mfc_ctx *ctx);
+	void (*s5p_mfc_release_codec_buffers)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_alloc_instance_buffer)(struct s5p_mfc_ctx *ctx);
+	void (*s5p_mfc_release_instance_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_alloc_dev_context_buffer)(struct s5p_mfc_dev *dev);
+	void (*s5p_mfc_release_dev_context_buffer)(struct s5p_mfc_dev *dev);
+	void (*s5p_mfc_dec_calc_dpb_size)(struct s5p_mfc_ctx *ctx);
+	void (*s5p_mfc_enc_calc_src_size)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_set_dec_stream_buffer)(struct s5p_mfc_ctx *ctx,
+			int buf_addr, unsigned int start_num_byte,
+			unsigned int buf_size);
+	int (*s5p_mfc_set_dec_frame_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_set_enc_stream_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long addr, unsigned int size);
+	void (*s5p_mfc_set_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long y_addr, unsigned long c_addr);
+	void (*s5p_mfc_get_enc_frame_buffer)(struct s5p_mfc_ctx *ctx,
+			unsigned long *y_addr, unsigned long *c_addr);
+	int (*s5p_mfc_set_enc_ref_buffer)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_init_decode)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_init_encode)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_encode_one_frame)(struct s5p_mfc_ctx *ctx);
+	void (*s5p_mfc_try_run)(struct s5p_mfc_dev *dev);
+	void (*s5p_mfc_cleanup_queue)(struct list_head *lh,
+			struct vb2_queue *vq);
+	void (*s5p_mfc_clear_int_flags)(struct s5p_mfc_dev *dev);
+	void (*s5p_mfc_write_info)(struct s5p_mfc_ctx *ctx, unsigned int data,
+			unsigned int ofs);
+	unsigned int (*s5p_mfc_read_info)(struct s5p_mfc_ctx *ctx,
+			unsigned int ofs);
+	int (*s5p_mfc_get_dspl_y_adr)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_dec_y_adr)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_dspl_status)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_dec_status)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_dec_frame_type)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_disp_frame_type)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_get_consumed_stream)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_int_reason)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_int_err)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_err_dec)(unsigned int err);
+	int (*s5p_mfc_err_dspl)(unsigned int err);
+	int (*s5p_mfc_get_img_width)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_img_height)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_dpb_count)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_mv_count)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_inst_no)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_enc_strm_size)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_enc_slice_type)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_enc_dpb_count)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_enc_pic_count)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_sei_avail_status)(struct s5p_mfc_ctx *ctx);
+	int (*s5p_mfc_get_mvc_num_views)(struct s5p_mfc_dev *dev);
+	int (*s5p_mfc_get_mvc_view_id)(struct s5p_mfc_dev *dev);
+	unsigned int (*s5p_mfc_get_pic_type_top)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*s5p_mfc_get_pic_type_bot)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*s5p_mfc_get_crop_info_h)(struct s5p_mfc_ctx *ctx);
+	unsigned int (*s5p_mfc_get_crop_info_v)(struct s5p_mfc_ctx *ctx);
+};
 
-/* Memory allocation */
 int s5p_mfc_alloc_dec_temp_buffers(struct s5p_mfc_ctx *ctx);
-void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_release_dec_desc_buffer(struct s5p_mfc_ctx *ctx);
-
 int s5p_mfc_alloc_codec_buffers(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_release_codec_buffers(struct s5p_mfc_ctx *ctx);
-
 int s5p_mfc_alloc_instance_buffer(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_release_instance_buffer(struct s5p_mfc_ctx *ctx);
-
+int s5p_mfc_alloc_dev_context_buffer(struct s5p_mfc_dev *dev);
+void s5p_mfc_release_dev_context_buffer(struct s5p_mfc_dev *dev);
+void s5p_mfc_dec_calc_dpb_size(struct s5p_mfc_ctx *ctx);
+void s5p_mfc_enc_calc_src_size(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_dec_stream_buffer(struct s5p_mfc_ctx *ctx,
+		int buf_addr, unsigned int start_num_byte,
+		unsigned int buf_size);
+int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_set_enc_stream_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size);
+void s5p_mfc_set_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr);
+void s5p_mfc_get_enc_frame_buffer(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr);
+int s5p_mfc_set_enc_ref_buffer(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_init_encode(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_encode_one_frame(struct s5p_mfc_ctx *ctx);
 void s5p_mfc_try_run(struct s5p_mfc_dev *dev);
-void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
+void s5p_mfc_cleanup_queue(struct list_head *lh,
+		struct vb2_queue *vq);
+void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev);
+void s5p_mfc_write_info(struct s5p_mfc_ctx *ctx, unsigned int data,
+		unsigned int ofs);
+unsigned int s5p_mfc_read_info(struct s5p_mfc_ctx *ctx,
+		unsigned int ofs);
+int s5p_mfc_get_dspl_y_adr(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_dec_y_adr(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_dspl_status(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_dec_status(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_dec_frame_type(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_disp_frame_type(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_get_consumed_stream(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_int_reason(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_int_err(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_warn_start(struct s5p_mfc_dev *dev);
+int s5p_mfc_err_dec(unsigned int err);
+int s5p_mfc_err_dspl(unsigned int err);
+int s5p_mfc_get_img_width(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_img_height(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_dpb_count(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_mv_count(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_inst_no(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_enc_strm_size(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_enc_slice_type(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_enc_dpb_count(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_enc_pic_count(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_sei_avail_status(struct s5p_mfc_ctx *ctx);
+int s5p_mfc_get_mvc_num_views(struct s5p_mfc_dev *dev);
+int s5p_mfc_get_mvc_view_id(struct s5p_mfc_dev *dev);
+unsigned int s5p_mfc_get_pic_type_top(struct s5p_mfc_ctx *ctx);
+unsigned int s5p_mfc_get_pic_type_bot(struct s5p_mfc_ctx *ctx);
+unsigned int s5p_mfc_get_crop_info_h(struct s5p_mfc_ctx *ctx);
+unsigned int s5p_mfc_get_crop_info_v(struct s5p_mfc_ctx *ctx);
 
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
+void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
new file mode 100644
index 0000000..ce1189e
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.c
@@ -0,0 +1,1696 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_opr_v5.c
+ *
+ * Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains hw related functions.
+ *
+ * Kamil Debski, Copyright (c) 2011 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_ctrl.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_pm.h"
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_opr_v5.h"
+#include <asm/cacheflush.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/firmware.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+
+#define OFFSETA(x)		(((x) - dev->bank1) >> MFC_OFFSET_SHIFT)
+#define OFFSETB(x)		(((x) - dev->bank2) >> MFC_OFFSET_SHIFT)
+
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
+{
+	void *desc_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	ctx->desc_buf = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], DESC_BUF_SIZE);
+	if (IS_ERR_VALUE((int)ctx->desc_buf)) {
+		ctx->desc_buf = NULL;
+		mfc_err("Allocating DESC buffer failed\n");
+		return -ENOMEM;
+	}
+	ctx->desc_phys = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->desc_buf);
+	BUG_ON(ctx->desc_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	desc_virt = vb2_dma_contig_memops.vaddr(ctx->desc_buf);
+	if (desc_virt == NULL) {
+		vb2_dma_contig_memops.put(ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = NULL;
+		mfc_err("Remapping DESC buffer failed\n");
+		return -ENOMEM;
+	}
+	memset(desc_virt, 0, DESC_BUF_SIZE);
+	wmb();
+	return 0;
+}
+
+/* Release temporary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->desc_phys) {
+		vb2_dma_contig_memops.put(ctx->desc_buf);
+		ctx->desc_phys = 0;
+		ctx->desc_buf = NULL;
+	}
+}
+
+/* Allocate codec buffers */
+int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int enc_ref_y_size = 0;
+	unsigned int enc_ref_c_size = 0;
+	unsigned int guard_width, guard_height;
+
+	if (ctx->type == MFCINST_DECODER) {
+		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
+			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
+		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
+	} else if (ctx->type == MFCINST_ENCODER) {
+		enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
+
+		if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC) {
+			enc_ref_c_size = ALIGN(ctx->img_width,
+						S5P_FIMV_NV12MT_HALIGN)
+						* ALIGN(ctx->img_height >> 1,
+						S5P_FIMV_NV12MT_VALIGN);
+			enc_ref_c_size = ALIGN(enc_ref_c_size,
+							S5P_FIMV_NV12MT_SALIGN);
+		} else {
+			guard_width = ALIGN(ctx->img_width + 16,
+							S5P_FIMV_NV12MT_HALIGN);
+			guard_height = ALIGN((ctx->img_height >> 1) + 4,
+							S5P_FIMV_NV12MT_VALIGN);
+			enc_ref_c_size = ALIGN(guard_width * guard_height,
+					       S5P_FIMV_NV12MT_SALIGN);
+		}
+		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
+			  enc_ref_y_size, enc_ref_c_size);
+	} else {
+		return -EINVAL;
+	}
+	/* Codecs have different memory requirements */
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+		ctx->bank1_size =
+		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
+					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
+					S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->bank2_size = ctx->total_dpb_count * ctx->mv_size;
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+		ctx->bank1_size =
+		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
+				     S5P_FIMV_DEC_UPNB_MV_SIZE +
+				     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+				     S5P_FIMV_DEC_STX_PARSER_SIZE +
+				     S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE,
+				     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+	case S5P_MFC_CODEC_VC1_DEC:
+		ctx->bank1_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE +
+			     3 * S5P_FIMV_DEC_VC1_BITPLANE_SIZE,
+			     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_MPEG2_DEC:
+		ctx->bank1_size = 0;
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_H263_DEC:
+		ctx->bank1_size =
+		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
+			     S5P_FIMV_DEC_UPNB_MV_SIZE +
+			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
+			     S5P_FIMV_DEC_NB_DCAC_SIZE,
+			     S5P_FIMV_DEC_BUF_ALIGN);
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_H264_ENC:
+		ctx->bank1_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_COLFLG_SIZE +
+				   S5P_FIMV_ENC_INTRAMD_SIZE +
+				   S5P_FIMV_ENC_NBORINFO_SIZE;
+		ctx->bank2_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4) +
+				   S5P_FIMV_ENC_INTRAPRED_SIZE;
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+		ctx->bank1_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_COLFLG_SIZE +
+				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		ctx->bank2_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4);
+		break;
+	case S5P_MFC_CODEC_H263_ENC:
+		ctx->bank1_size = (enc_ref_y_size * 2) +
+				   S5P_FIMV_ENC_UPMV_SIZE +
+				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		ctx->bank2_size = (enc_ref_y_size * 2) +
+				   (enc_ref_c_size * 4);
+		break;
+	default:
+		break;
+	}
+	/* Allocate only if memory from bank 1 is necessary */
+	if (ctx->bank1_size > 0) {
+		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
+		if (IS_ERR(ctx->bank1_buf)) {
+			ctx->bank1_buf = NULL;
+			mfc_err("Buf alloc for decoding failed (port A)\n");
+			return -ENOMEM;
+		}
+		ctx->bank1_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
+		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	}
+	/* Allocate only if memory from bank 2 is necessary */
+	if (ctx->bank2_size > 0) {
+		ctx->bank2_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_size);
+		if (IS_ERR(ctx->bank2_buf)) {
+			ctx->bank2_buf = NULL;
+			mfc_err("Buf alloc for decoding failed (port B)\n");
+			return -ENOMEM;
+		}
+		ctx->bank2_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_buf);
+		BUG_ON(ctx->bank2_phys & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
+	}
+	return 0;
+}
+
+/* Release buffers allocated for codec */
+void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->bank1_buf) {
+		vb2_dma_contig_memops.put(ctx->bank1_buf);
+		ctx->bank1_buf = NULL;
+		ctx->bank1_phys = 0;
+		ctx->bank1_size = 0;
+	}
+	if (ctx->bank2_buf) {
+		vb2_dma_contig_memops.put(ctx->bank2_buf);
+		ctx->bank2_buf = NULL;
+		ctx->bank2_phys = 0;
+		ctx->bank2_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
+{
+	void *context_virt;
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+		ctx->codec_mode == S5P_FIMV_CODEC_H264_ENC)
+		ctx->ctx_size = MFC_H264_CTX_BUF_SIZE;
+	else
+		ctx->ctx_size = MFC_CTX_BUF_SIZE;
+	ctx->ctx_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_size);
+	if (IS_ERR(ctx->ctx_buf)) {
+		mfc_err("Allocating context buffer failed\n");
+		ctx->ctx_phys = 0;
+		ctx->ctx_buf = NULL;
+		return -ENOMEM;
+	}
+	ctx->ctx_phys = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx_buf);
+	BUG_ON(ctx->ctx_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	ctx->ctx_ofs = OFFSETA(ctx->ctx_phys);
+	context_virt = vb2_dma_contig_memops.vaddr(ctx->ctx_buf);
+	if (context_virt == NULL) {
+		mfc_err("Remapping instance buffer failed\n");
+		vb2_dma_contig_memops.put(ctx->ctx_buf);
+		ctx->ctx_phys = 0;
+		ctx->ctx_buf = NULL;
+		return -ENOMEM;
+	}
+	/* Zero content of the allocated memory */
+	memset(context_virt, 0, ctx->ctx_size);
+	wmb();
+
+	/* Initialize shared memory */
+	ctx->shm_alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], SHARED_BUF_SIZE);
+	if (IS_ERR(ctx->shm_alloc)) {
+		mfc_err("failed to allocate shared memory\n");
+		return PTR_ERR(ctx->shm_alloc);
+	}
+	/* shared memory offset only keeps the offset from base (port a) */
+	ctx->shm_ofs = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->shm_alloc)
+								- dev->bank1;
+	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+
+	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
+	if (!ctx->shm) {
+		vb2_dma_contig_memops.put(ctx->shm_alloc);
+		ctx->shm_ofs = 0;
+		ctx->shm_alloc = NULL;
+		mfc_err("failed to virt addr of shared memory\n");
+		return -ENOMEM;
+	}
+	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
+	wmb();
+	return 0;
+}
+
+/* Release instance buffer */
+void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->ctx_buf) {
+		vb2_dma_contig_memops.put(ctx->ctx_buf);
+		ctx->ctx_phys = 0;
+		ctx->ctx_buf = NULL;
+	}
+	if (ctx->shm_alloc) {
+		vb2_dma_contig_memops.put(ctx->shm_alloc);
+		ctx->shm_alloc = NULL;
+		ctx->shm = NULL;
+	}
+}
+
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
+			unsigned int ofs)
+{
+	writel(data, (ctx->shm + ofs));
+	wmb();
+}
+
+static unsigned int s5p_mfc_read_info_v5(struct s5p_mfc_ctx *ctx,
+				unsigned int ofs)
+{
+	rmb();
+	return readl(ctx->shm + ofs);
+}
+
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
+/* Set registers for decoding temporary buffers */
+static void s5p_mfc_set_dec_desc_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_write(dev, OFFSETA(ctx->desc_phys), S5P_FIMV_SI_CH0_DESC_ADR);
+	mfc_write(dev, DESC_BUF_SIZE, S5P_FIMV_SI_CH0_DESC_SIZE);
+}
+
+/* Set registers for shared buffer */
+static void s5p_mfc_set_shared_buffer(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	mfc_write(dev, ctx->shm_ofs, S5P_FIMV_SI_CH0_HOST_WR_ADR);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer_v5(struct s5p_mfc_ctx *ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int buf_size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_write(dev, OFFSETA(buf_addr), S5P_FIMV_SI_CH0_SB_ST_ADR);
+	mfc_write(dev, ctx->dec_src_buf_size, S5P_FIMV_SI_CH0_CPB_SIZE);
+	mfc_write(dev, buf_size, S5P_FIMV_SI_CH0_SB_FRM_SIZE);
+	s5p_mfc_write_info_v5(ctx, start_num_byte, START_BYTE_NUM);
+	return 0;
+}
+
+/* Set decoding frame buffer */
+int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int frame_size, i;
+	unsigned int frame_size_ch, frame_size_mv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	size_t buf_addr1, buf_addr2;
+	int buf_size1, buf_size2;
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+	buf_addr2 = ctx->bank2_phys;
+	buf_size2 = ctx->bank2_size;
+	dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
+						~S5P_FIMV_DPB_COUNT_MASK;
+	mfc_write(dev, ctx->total_dpb_count | dpb,
+						S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	s5p_mfc_set_shared_buffer(ctx);
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+		mfc_write(dev, OFFSETA(buf_addr1),
+						S5P_FIMV_H264_VERT_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VERT_NB_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H264_NB_IP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_IP_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_IP_SIZE;
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_SP_ADR);
+		buf_addr1 += S5P_FIMV_DEC_STX_PARSER_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_STX_PARSER_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		break;
+	case S5P_MFC_CODEC_H263_DEC:
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		break;
+	case S5P_MFC_CODEC_VC1_DEC:
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_NB_DCAC_ADR);
+		buf_addr1 += S5P_FIMV_DEC_NB_DCAC_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_NB_DCAC_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_OT_LINE_ADR);
+		buf_addr1 += S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_UP_NB_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_UPNB_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_UPNB_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_SA_MV_ADR);
+		buf_addr1 += S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE3_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE2_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_VC1_BITPLANE1_ADR);
+		buf_addr1 += S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		buf_size1 -= S5P_FIMV_DEC_VC1_BITPLANE_SIZE;
+		break;
+	case S5P_MFC_CODEC_MPEG2_DEC:
+		break;
+	default:
+		mfc_err("Unknown codec for decoding (%x)\n",
+			ctx->codec_mode);
+		return -EINVAL;
+		break;
+	}
+	frame_size = ctx->luma_size;
+	frame_size_ch = ctx->chroma_size;
+	frame_size_mv = ctx->mv_size;
+	mfc_debug(2, "Frm size: %d ch: %d mv: %d\n", frame_size, frame_size_ch,
+								frame_size_mv);
+	for (i = 0; i < ctx->total_dpb_count; i++) {
+		/* Bank2 */
+		mfc_debug(2, "Luma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.luma);
+		mfc_write(dev, OFFSETB(ctx->dst_bufs[i].cookie.raw.luma),
+						S5P_FIMV_DEC_LUMA_ADR + i * 4);
+		mfc_debug(2, "\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.chroma);
+		mfc_write(dev, OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
+					       S5P_FIMV_DEC_CHROMA_ADR + i * 4);
+		if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC) {
+			mfc_debug(2, "\tBuf2: %x, size: %d\n",
+							buf_addr2, buf_size2);
+			mfc_write(dev, OFFSETB(buf_addr2),
+						S5P_FIMV_H264_MV_ADR + i * 4);
+			buf_addr2 += frame_size_mv;
+			buf_size2 -= frame_size_mv;
+		}
+	}
+	mfc_debug(2, "Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
+	mfc_debug(2, "Buf 1/2 size after: %d/%d (frames %d)\n",
+			buf_size1,  buf_size2, ctx->total_dpb_count);
+	if (buf_size1 < 0 || buf_size2 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated\n");
+		return -ENOMEM;
+	}
+	s5p_mfc_write_info_v5(ctx, frame_size, ALLOC_LUMA_DPB_SIZE);
+	s5p_mfc_write_info_v5(ctx, frame_size_ch, ALLOC_CHROMA_DPB_SIZE);
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC)
+		s5p_mfc_write_info_v5(ctx, frame_size_mv, ALLOC_MV_SIZE);
+	mfc_write(dev, ((S5P_FIMV_CH_INIT_BUFS & S5P_FIMV_CH_MASK)
+					<< S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
+						S5P_FIMV_SI_CH0_INST_ID);
+	return 0;
+}
+
+/* Set registers for encoding stream buffer */
+int s5p_mfc_set_enc_stream_buffer_v5(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_write(dev, OFFSETA(addr), S5P_FIMV_ENC_SI_CH0_SB_ADR);
+	mfc_write(dev, size, S5P_FIMV_ENC_SI_CH0_SB_SIZE);
+	return 0;
+}
+
+void s5p_mfc_set_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_write(dev, OFFSETB(y_addr), S5P_FIMV_ENC_SI_CH0_CUR_Y_ADR);
+	mfc_write(dev, OFFSETB(c_addr), S5P_FIMV_ENC_SI_CH0_CUR_C_ADR);
+}
+
+void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	*y_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_Y_ADDR)
+							<< MFC_OFFSET_SHIFT);
+	*c_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_C_ADDR)
+							<< MFC_OFFSET_SHIFT);
+}
+
+/* Set encoding ref & codec buffer */
+int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	size_t buf_addr1, buf_addr2;
+	size_t buf_size1, buf_size2;
+	unsigned int enc_ref_y_size, enc_ref_c_size;
+	unsigned int guard_width, guard_height;
+	int i;
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+	buf_addr2 = ctx->bank2_phys;
+	buf_size2 = ctx->bank2_size;
+	enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+		* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
+	enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC) {
+		enc_ref_c_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
+			* ALIGN((ctx->img_height >> 1), S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_c_size = ALIGN(enc_ref_c_size, S5P_FIMV_NV12MT_SALIGN);
+	} else {
+		guard_width = ALIGN(ctx->img_width + 16,
+						S5P_FIMV_NV12MT_HALIGN);
+		guard_height = ALIGN((ctx->img_height >> 1) + 4,
+						S5P_FIMV_NV12MT_VALIGN);
+		enc_ref_c_size = ALIGN(guard_width * guard_height,
+				       S5P_FIMV_NV12MT_SALIGN);
+	}
+	mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_ENC:
+		for (i = 0; i < 2; i++) {
+			mfc_write(dev, OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+		for (i = 0; i < 4; i++) {
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H264_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1),
+					S5P_FIMV_H264_COZERO_FLAG_ADR);
+		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1),
+					S5P_FIMV_H264_UP_INTRA_MD_ADR);
+		buf_addr1 += S5P_FIMV_ENC_INTRAMD_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_INTRAMD_SIZE;
+		mfc_write(dev, OFFSETB(buf_addr2),
+					S5P_FIMV_H264_UP_INTRA_PRED_ADR);
+		buf_addr2 += S5P_FIMV_ENC_INTRAPRED_SIZE;
+		buf_size2 -= S5P_FIMV_ENC_INTRAPRED_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1),
+					S5P_FIMV_H264_NBOR_INFO_ADR);
+		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+		for (i = 0; i < 2; i++) {
+			mfc_write(dev, OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+		for (i = 0; i < 4; i++) {
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_MPEG4_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1),
+						S5P_FIMV_MPEG4_COZERO_FLAG_ADR);
+		buf_addr1 += S5P_FIMV_ENC_COLFLG_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_COLFLG_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1),
+						S5P_FIMV_MPEG4_ACDC_COEF_ADR);
+		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+	case S5P_MFC_CODEC_H263_ENC:
+		for (i = 0; i < 2; i++) {
+			mfc_write(dev, OFFSETA(buf_addr1),
+				S5P_FIMV_ENC_REF0_LUMA_ADR + (4 * i));
+			buf_addr1 += enc_ref_y_size;
+			buf_size1 -= enc_ref_y_size;
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF2_LUMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_y_size;
+			buf_size2 -= enc_ref_y_size;
+		}
+		for (i = 0; i < 4; i++) {
+			mfc_write(dev, OFFSETB(buf_addr2),
+				S5P_FIMV_ENC_REF0_CHROMA_ADR + (4 * i));
+			buf_addr2 += enc_ref_c_size;
+			buf_size2 -= enc_ref_c_size;
+		}
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_UP_MV_ADR);
+		buf_addr1 += S5P_FIMV_ENC_UPMV_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_UPMV_SIZE;
+		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_ACDC_COEF_ADR);
+		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
+		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+			buf_size1, buf_size2);
+		break;
+	default:
+		mfc_err("Unknown codec set for encoding: %d\n",
+			ctx->codec_mode);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	unsigned int reg;
+	unsigned int shm;
+
+	/* width */
+	mfc_write(dev, ctx->img_width, S5P_FIMV_ENC_HSIZE_PX);
+	/* height */
+	mfc_write(dev, ctx->img_height, S5P_FIMV_ENC_VSIZE_PX);
+	/* pictype : enable, IDR period */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	reg |= (1 << 18);
+	reg &= ~(0xFFFF);
+	reg |= p->gop_size;
+	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	mfc_write(dev, 0, S5P_FIMV_ENC_B_RECON_WRITE_ON);
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	mfc_write(dev, p->slice_mode, S5P_FIMV_ENC_MSLICE_CTRL);
+	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
+		mfc_write(dev, p->slice_mb, S5P_FIMV_ENC_MSLICE_MB);
+	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
+		mfc_write(dev, p->slice_bit, S5P_FIMV_ENC_MSLICE_BIT);
+	} else {
+		mfc_write(dev, 0, S5P_FIMV_ENC_MSLICE_MB);
+		mfc_write(dev, 0, S5P_FIMV_ENC_MSLICE_BIT);
+	}
+	/* cyclic intra refresh */
+	mfc_write(dev, p->intra_refresh_mb, S5P_FIMV_ENC_CIR_CTRL);
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
+		mfc_write(dev, 0, S5P_FIMV_ENC_MAP_FOR_CUR);
+	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
+	/* padding control & value */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PADDING_CTRL);
+	if (p->pad) {
+		/** enable */
+		reg |= (1 << 31);
+		/** cr value */
+		reg &= ~(0xFF << 16);
+		reg |= (p->pad_cr << 16);
+		/** cb value */
+		reg &= ~(0xFF << 8);
+		reg |= (p->pad_cb << 8);
+		/** y value */
+		reg &= ~(0xFF);
+		reg |= (p->pad_luma);
+	} else {
+		/** disable & all value clear */
+		reg = 0;
+	}
+	mfc_write(dev, reg, S5P_FIMV_ENC_PADDING_CTRL);
+	/* rate control config. */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
+	/** frame-level rate control */
+	reg &= ~(0x1 << 9);
+	reg |= (p->rc_frame << 9);
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
+	/* bit rate */
+	if (p->rc_frame)
+		mfc_write(dev, p->rc_bitrate,
+			S5P_FIMV_ENC_RC_BIT_RATE);
+	else
+		mfc_write(dev, 0, S5P_FIMV_ENC_RC_BIT_RATE);
+	/* reaction coefficient */
+	if (p->rc_frame)
+		mfc_write(dev, p->rc_reaction_coeff, S5P_FIMV_ENC_RC_RPARA);
+	shm = s5p_mfc_read_info_v5(ctx, EXT_ENC_CONTROL);
+	/* seq header ctrl */
+	shm &= ~(0x1 << 3);
+	shm |= (p->seq_hdr_mode << 3);
+	/* frame skip mode */
+	shm &= ~(0x3 << 1);
+	shm |= (p->frame_skip_mode << 1);
+	s5p_mfc_write_info_v5(ctx, shm, EXT_ENC_CONTROL);
+	/* fixed target bit */
+	s5p_mfc_write_info_v5(ctx, p->fixed_target_bit, RC_CONTROL_CONFIG);
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_h264_enc_params *p_264 = &p->codec.h264;
+	unsigned int reg;
+	unsigned int shm;
+
+	s5p_mfc_set_enc_params(ctx);
+	/* pictype : number of B */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/* num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p->num_b_frame << 16);
+	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/* profile & level */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PROFILE);
+	/* level */
+	reg &= ~(0xFF << 8);
+	reg |= (p_264->level << 8);
+	/* profile - 0 ~ 2 */
+	reg &= ~(0x3F);
+	reg |= p_264->profile;
+	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
+	/* interlace  */
+	mfc_write(dev, p->interlace, S5P_FIMV_ENC_PIC_STRUCT);
+	/* height */
+	if (p->interlace)
+		mfc_write(dev, ctx->img_height >> 1, S5P_FIMV_ENC_VSIZE_PX);
+	/* loopfilter ctrl */
+	mfc_write(dev, p_264->loop_filter_mode, S5P_FIMV_ENC_LF_CTRL);
+	/* loopfilter alpha offset */
+	if (p_264->loop_filter_alpha < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_264->loop_filter_alpha) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_264->loop_filter_alpha & 0xF);
+	}
+	mfc_write(dev, reg, S5P_FIMV_ENC_ALPHA_OFF);
+	/* loopfilter beta offset */
+	if (p_264->loop_filter_beta < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_264->loop_filter_beta) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_264->loop_filter_beta & 0xF);
+	}
+	mfc_write(dev, reg, S5P_FIMV_ENC_BETA_OFF);
+	/* entropy coding mode */
+	if (p_264->entropy_mode == V4L2_MPEG_VIDEO_H264_ENTROPY_MODE_CABAC)
+		mfc_write(dev, 1, S5P_FIMV_ENC_H264_ENTROPY_MODE);
+	else
+		mfc_write(dev, 0, S5P_FIMV_ENC_H264_ENTROPY_MODE);
+	/* number of ref. picture */
+	reg = mfc_read(dev, S5P_FIMV_ENC_H264_NUM_OF_REF);
+	/* num of ref. pictures of P */
+	reg &= ~(0x3 << 5);
+	reg |= (p_264->num_ref_pic_4p << 5);
+	/* max number of ref. pictures */
+	reg &= ~(0x1F);
+	reg |= p_264->max_ref_pic;
+	mfc_write(dev, reg, S5P_FIMV_ENC_H264_NUM_OF_REF);
+	/* 8x8 transform enable */
+	mfc_write(dev, p_264->_8x8_transform, S5P_FIMV_ENC_H264_TRANS_FLAG);
+	/* rate control config. */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
+	/* macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= (p_264->rc_mb << 8);
+	/* frame QP */
+	reg &= ~(0x3F);
+	reg |= p_264->rc_frame_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_denom)
+		mfc_write(dev, p->rc_framerate_num * 1000
+			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
+	else
+		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
+	/* max & min value of QP */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
+	/* max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_264->rc_max_qp << 8);
+	/* min QP */
+	reg &= ~(0x3F);
+	reg |= p_264->rc_min_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
+	/* macroblock adaptive scaling features */
+	if (p_264->rc_mb) {
+		reg = mfc_read(dev, S5P_FIMV_ENC_RC_MB_CTRL);
+		/* dark region */
+		reg &= ~(0x1 << 3);
+		reg |= (p_264->rc_mb_dark << 3);
+		/* smooth region */
+		reg &= ~(0x1 << 2);
+		reg |= (p_264->rc_mb_smooth << 2);
+		/* static region */
+		reg &= ~(0x1 << 1);
+		reg |= (p_264->rc_mb_static << 1);
+		/* high activity region */
+		reg &= ~(0x1);
+		reg |= p_264->rc_mb_activity;
+		mfc_write(dev, reg, S5P_FIMV_ENC_RC_MB_CTRL);
+	}
+	if (!p->rc_frame &&
+	    !p_264->rc_mb) {
+		shm = s5p_mfc_read_info_v5(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= ((p_264->rc_b_frame_qp & 0x3F) << 6);
+		shm |= (p_264->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_info_v5(ctx, shm, P_B_FRAME_QP);
+	}
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_info_v5(ctx, EXT_ENC_CONTROL);
+	/* AR VUI control */
+	shm &= ~(0x1 << 15);
+	shm |= (p_264->vui_sar << 1);
+	s5p_mfc_write_info_v5(ctx, shm, EXT_ENC_CONTROL);
+	if (p_264->vui_sar) {
+		/* aspect ration IDC */
+		shm = s5p_mfc_read_info_v5(ctx, SAMPLE_ASPECT_RATIO_IDC);
+		shm &= ~(0xFF);
+		shm |= p_264->vui_sar_idc;
+		s5p_mfc_write_info_v5(ctx, shm, SAMPLE_ASPECT_RATIO_IDC);
+		if (p_264->vui_sar_idc == 0xFF) {
+			/* sample  AR info */
+			shm = s5p_mfc_read_info_v5(ctx, EXTENDED_SAR);
+			shm &= ~(0xFFFFFFFF);
+			shm |= p_264->vui_ext_sar_width << 16;
+			shm |= p_264->vui_ext_sar_height;
+			s5p_mfc_write_info_v5(ctx, shm, EXTENDED_SAR);
+		}
+	}
+	/* intra picture period for H.264 */
+	shm = s5p_mfc_read_info_v5(ctx, H264_I_PERIOD);
+	/* control */
+	shm &= ~(0x1 << 16);
+	shm |= (p_264->open_gop << 16);
+	/* value */
+	if (p_264->open_gop) {
+		shm &= ~(0xFFFF);
+		shm |= p_264->open_gop_size;
+	}
+	s5p_mfc_write_info_v5(ctx, shm, H264_I_PERIOD);
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_info_v5(ctx, EXT_ENC_CONTROL);
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p_264->cpb_size << 16);
+	}
+	s5p_mfc_write_info_v5(ctx, shm, EXT_ENC_CONTROL);
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
+	unsigned int reg;
+	unsigned int shm;
+	unsigned int framerate;
+
+	s5p_mfc_set_enc_params(ctx);
+	/* pictype : number of B */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/* num_b_frame - 0 ~ 2 */
+	reg &= ~(0x3 << 16);
+	reg |= (p->num_b_frame << 16);
+	mfc_write(dev, reg, S5P_FIMV_ENC_PIC_TYPE_CTRL);
+	/* profile & level */
+	reg = mfc_read(dev, S5P_FIMV_ENC_PROFILE);
+	/* level */
+	reg &= ~(0xFF << 8);
+	reg |= (p_mpeg4->level << 8);
+	/* profile - 0 ~ 2 */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->profile;
+	mfc_write(dev, reg, S5P_FIMV_ENC_PROFILE);
+	/* quarter_pixel */
+	mfc_write(dev, p_mpeg4->quarter_pixel, S5P_FIMV_ENC_MPEG4_QUART_PXL);
+	/* qp */
+	if (!p->rc_frame) {
+		shm = s5p_mfc_read_info_v5(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 6);
+		shm |= (p_mpeg4->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_info_v5(ctx, shm, P_B_FRAME_QP);
+	}
+	/* frame rate */
+	if (p->rc_frame) {
+		if (p->rc_framerate_denom > 0) {
+			framerate = p->rc_framerate_num * 1000 /
+						p->rc_framerate_denom;
+			mfc_write(dev, framerate,
+				S5P_FIMV_ENC_RC_FRAME_RATE);
+			shm = s5p_mfc_read_info_v5(ctx, RC_VOP_TIMING);
+			shm &= ~(0xFFFFFFFF);
+			shm |= (1 << 31);
+			shm |= ((p->rc_framerate_num & 0x7FFF) << 16);
+			shm |= (p->rc_framerate_denom & 0xFFFF);
+			s5p_mfc_write_info_v5(ctx, shm, RC_VOP_TIMING);
+		}
+	} else {
+		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
+	}
+	/* rate control config. */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
+	/* frame QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_frame_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
+	/* max & min value of QP */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
+	/* max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_mpeg4->rc_max_qp << 8);
+	/* min QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_min_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_info_v5(ctx, EXT_ENC_CONTROL);
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p->vbv_size << 16);
+	}
+	s5p_mfc_write_info_v5(ctx, shm, EXT_ENC_CONTROL);
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_h263 = &p->codec.mpeg4;
+	unsigned int reg;
+	unsigned int shm;
+
+	s5p_mfc_set_enc_params(ctx);
+	/* qp */
+	if (!p->rc_frame) {
+		shm = s5p_mfc_read_info_v5(ctx, P_B_FRAME_QP);
+		shm &= ~(0xFFF);
+		shm |= (p_h263->rc_p_frame_qp & 0x3F);
+		s5p_mfc_write_info_v5(ctx, shm, P_B_FRAME_QP);
+	}
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_denom)
+		mfc_write(dev, p->rc_framerate_num * 1000
+			/ p->rc_framerate_denom, S5P_FIMV_ENC_RC_FRAME_RATE);
+	else
+		mfc_write(dev, 0, S5P_FIMV_ENC_RC_FRAME_RATE);
+	/* rate control config. */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_CONFIG);
+	/* frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_frame_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_CONFIG);
+	/* max & min value of QP */
+	reg = mfc_read(dev, S5P_FIMV_ENC_RC_QBOUND);
+	/* max QP */
+	reg &= ~(0x3F << 8);
+	reg |= (p_h263->rc_max_qp << 8);
+	/* min QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_min_qp;
+	mfc_write(dev, reg, S5P_FIMV_ENC_RC_QBOUND);
+	/* extended encoder ctrl */
+	shm = s5p_mfc_read_info_v5(ctx, EXT_ENC_CONTROL);
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		shm &= ~(0xFFFF << 16);
+		shm |= (p->vbv_size << 16);
+	}
+	s5p_mfc_write_info_v5(ctx, shm, EXT_ENC_CONTROL);
+	return 0;
+}
+
+/* Initialize decoding */
+int s5p_mfc_init_decode_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_set_shared_buffer(ctx);
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC)
+		mfc_write(dev, ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
+	else
+		mfc_write(dev, 0, S5P_FIMV_ENC_LF_CTRL);
+	mfc_write(dev, ((ctx->slice_interface & S5P_FIMV_SLICE_INT_MASK) <<
+		S5P_FIMV_SLICE_INT_SHIFT) | (ctx->display_delay_enable <<
+		S5P_FIMV_DDELAY_ENA_SHIFT) | ((ctx->display_delay &
+		S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
+		S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	mfc_write(dev,
+	((S5P_FIMV_CH_SEQ_HEADER & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
+				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	return 0;
+}
+
+static void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+
+	if (flush)
+		dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (
+			S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
+	else
+		dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
+			~(S5P_FIMV_DPB_FLUSH_MASK << S5P_FIMV_DPB_FLUSH_SHIFT);
+	mfc_write(dev, dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame_v5(struct s5p_mfc_ctx *ctx,
+					enum s5p_mfc_decode_arg last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_write(dev, ctx->dec_dst_flag, S5P_FIMV_SI_CH0_RELEASE_BUF);
+	s5p_mfc_set_shared_buffer(ctx);
+	s5p_mfc_set_flush(ctx, ctx->dpb_flush_flag);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	switch (last_frame) {
+	case MFC_DEC_FRAME:
+		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_LAST_FRAME:
+		mfc_write(dev, ((S5P_FIMV_CH_LAST_FRAME & S5P_FIMV_CH_MASK) <<
+		S5P_FIMV_CH_SHIFT) | (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	case MFC_DEC_RES_CHANGE:
+		mfc_write(dev, ((S5P_FIMV_CH_FRAME_START_REALLOC &
+		S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT) | (ctx->inst_no),
+		S5P_FIMV_SI_CH0_INST_ID);
+		break;
+	}
+	mfc_debug(2, "Decoding a usual frame\n");
+	return 0;
+}
+
+int s5p_mfc_init_encode_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
+		s5p_mfc_set_enc_params_h264(ctx);
+	else if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_ENC)
+		s5p_mfc_set_enc_params_mpeg4(ctx);
+	else if (ctx->codec_mode == S5P_MFC_CODEC_H263_ENC)
+		s5p_mfc_set_enc_params_h263(ctx);
+	else {
+		mfc_err("Unknown codec for encoding (%x)\n",
+			ctx->codec_mode);
+		return -EINVAL;
+	}
+	s5p_mfc_set_shared_buffer(ctx);
+	mfc_write(dev, ((S5P_FIMV_CH_SEQ_HEADER << 16) & 0x70000) |
+		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	return 0;
+}
+
+/* Encode a single frame */
+int s5p_mfc_encode_one_frame_v5(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M)
+		mfc_write(dev, 0, S5P_FIMV_ENC_MAP_FOR_CUR);
+	else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT)
+		mfc_write(dev, 3, S5P_FIMV_ENC_MAP_FOR_CUR);
+	s5p_mfc_set_shared_buffer(ctx);
+	mfc_write(dev, (S5P_FIMV_CH_FRAME_START << 16 & 0x70000) |
+		(ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+	return 0;
+}
+
+static int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
+{
+	unsigned long flags;
+	int new_ctx;
+	int cnt;
+
+	spin_lock_irqsave(&dev->condlock, flags);
+	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
+	cnt = 0;
+	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
+		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
+		if (++cnt > MFC_NUM_CONTEXTS) {
+			/* No contexts to run */
+			spin_unlock_irqrestore(&dev->condlock, flags);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	return new_ctx;
+}
+
+static void s5p_mfc_run_res_change(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_set_dec_stream_buffer_v5(ctx, 0, 0, 0);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame_v5(ctx, MFC_DEC_RES_CHANGE);
+}
+
+static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+	unsigned int index;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "No src buffers\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	temp_vb->used = 1;
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
+			vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+			ctx->consumed_stream,
+			temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	index = temp_vb->b->v4l2_buf.index;
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+		last_frame = MFC_DEC_LAST_FRAME;
+		mfc_debug(2, "Setting ctx->state to FINISHING\n");
+		ctx->state = MFCINST_FINISHING;
+	}
+	s5p_mfc_decode_one_frame_v5(ctx, last_frame);
+	return 0;
+}
+
+static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "no src buffers\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	if (list_empty(&ctx->dst_queue)) {
+		mfc_debug(2, "no dst buffers\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_mb->used = 1;
+	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+	s5p_mfc_set_enc_frame_buffer_v5(ctx, src_y_addr, src_c_addr);
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_mb->used = 1;
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_encode_one_frame_v5(ctx);
+	return 0;
+}
+
+static void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+
+	/* Initializing decoding - parsing header */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	mfc_debug(2, "Preparing to init decoding\n");
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	s5p_mfc_set_dec_desc_buffer(ctx);
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
+				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_decode_v5(ctx);
+}
+
+static void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long dst_addr;
+	unsigned int dst_size;
+
+	s5p_mfc_set_enc_ref_buffer_v5(ctx);
+	spin_lock_irqsave(&dev->irqlock, flags);
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer_v5(ctx, dst_addr, dst_size);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_encode_v5(ctx);
+}
+
+static int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+	int ret;
+
+	/*
+	 * Header was parsed now starting processing
+	 * First set the output frame buffers
+	 */
+	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
+		mfc_err("It seems that not all destionation buffers were\n"
+			"mmaped\nMFC requires that all destination are\n"
+			"mmaped before starting processing\n");
+		return -EAGAIN;
+	}
+	spin_lock_irqsave(&dev->irqlock, flags);
+	if (list_empty(&ctx->src_queue)) {
+		mfc_err("Header has been deallocated in the middle of\n"
+			" initialization\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EIO;
+	}
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer_v5(ctx,
+				vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+				0, temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_dec_frame_buffer_v5(ctx);
+	if (ret) {
+		mfc_err("Failed to alloc frame mem\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+/* Try running an operation on hardware */
+void s5p_mfc_try_run_v5(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned int ret = 0;
+
+	if (test_bit(0, &dev->enter_suspend)) {
+		mfc_debug(1, "Entering suspend so do not schedule any jobs\n");
+		return;
+	}
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug(1, "Couldn't lock HW\n");
+		return;
+	}
+	/* Choose the context to run */
+	new_ctx = s5p_mfc_get_new_ctx(dev);
+	if (new_ctx < 0) {
+		/* No contexts to run */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware\n");
+			return;
+		}
+		mfc_debug(1, "No ctx is scheduled to be run\n");
+		return;
+	}
+	ctx = dev->ctx[new_ctx];
+	/* Got context to run in ctx */
+	/*
+	 * Last frame has already been sent to MFC.
+	 * Now obtaining frames from MFC buffer
+	 */
+	s5p_mfc_clock_on();
+	if (ctx->type == MFCINST_DECODER) {
+		s5p_mfc_set_dec_desc_buffer(ctx);
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+			s5p_mfc_run_dec_frame(ctx, MFC_DEC_LAST_FRAME);
+			break;
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
+			break;
+		case MFCINST_INIT:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_open_inst_cmd(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_close_inst_cmd(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_HEAD_PARSED:
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			mfc_debug(1, "head parsed\n");
+			break;
+		case MFCINST_RES_CHANGE_INIT:
+			s5p_mfc_run_res_change(ctx);
+			break;
+		case MFCINST_RES_CHANGE_FLUSH:
+			s5p_mfc_run_dec_frame(ctx, MFC_DEC_FRAME);
+			break;
+		case MFCINST_RES_CHANGE_END:
+			mfc_debug(2, "Finished remaining frames after resolution change\n");
+			ctx->capture_state = QUEUE_FREE;
+			mfc_debug(2, "Will re-init the codec\n");
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else if (ctx->type == MFCINST_ENCODER) {
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_enc_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_open_inst_cmd(ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_close_inst_cmd(ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_enc(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else {
+		mfc_err("Invalid context type: %d\n", ctx->type);
+		ret = -EAGAIN;
+	}
+
+	if (ret) {
+		/* Free hardware lock */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			mfc_err("Failed to unlock hardware\n");
+
+		/* This is in deed imporant, as no operation has been
+		 * scheduled, reduce the clock count as no one will
+		 * ever do this, because no interrupt related to this try_run
+		 * will ever come from hardware. */
+		s5p_mfc_clock_off();
+	}
+}
+
+
+void s5p_mfc_cleanup_queue_v5(struct list_head *lh, struct vb2_queue *vq)
+{
+	struct s5p_mfc_buf *b;
+	int i;
+
+	while (!list_empty(lh)) {
+		b = list_entry(lh->next, struct s5p_mfc_buf, list);
+		for (i = 0; i < b->b->num_planes; i++)
+			vb2_set_plane_payload(b->b, i, 0);
+		vb2_buffer_done(b->b, VB2_BUF_STATE_ERROR);
+		list_del(&b->list);
+	}
+}
+
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
+static const struct s5p_mfc_hw_ops s5p_mfc_ops_v5 = {
+	.s5p_mfc_alloc_dec_temp_buffers = s5p_mfc_alloc_dec_temp_buffers_v5,
+	.s5p_mfc_release_dec_desc_buffer = s5p_mfc_release_dec_desc_buffer_v5,
+	.s5p_mfc_alloc_codec_buffers = s5p_mfc_alloc_codec_buffers_v5,
+	.s5p_mfc_release_codec_buffers = s5p_mfc_release_codec_buffers_v5,
+	.s5p_mfc_alloc_instance_buffer = s5p_mfc_alloc_instance_buffer_v5,
+	.s5p_mfc_release_instance_buffer = s5p_mfc_release_instance_buffer_v5,
+	.s5p_mfc_alloc_dev_context_buffer =
+		s5p_mfc_alloc_dev_context_buffer_v5,
+	.s5p_mfc_release_dev_context_buffer =
+		s5p_mfc_release_dev_context_buffer_v5,
+	.s5p_mfc_dec_calc_dpb_size = s5p_mfc_dec_calc_dpb_size_v5,
+	.s5p_mfc_enc_calc_src_size = s5p_mfc_enc_calc_src_size_v5,
+	.s5p_mfc_set_dec_stream_buffer = s5p_mfc_set_dec_stream_buffer_v5,
+	.s5p_mfc_set_dec_frame_buffer = s5p_mfc_set_dec_frame_buffer_v5,
+	.s5p_mfc_set_enc_stream_buffer = s5p_mfc_set_enc_stream_buffer_v5,
+	.s5p_mfc_set_enc_frame_buffer = s5p_mfc_set_enc_frame_buffer_v5,
+	.s5p_mfc_get_enc_frame_buffer = s5p_mfc_get_enc_frame_buffer_v5,
+	.s5p_mfc_set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v5,
+	.s5p_mfc_init_decode = s5p_mfc_init_decode_v5,
+	.s5p_mfc_init_encode = s5p_mfc_init_encode_v5,
+	.s5p_mfc_encode_one_frame = s5p_mfc_encode_one_frame_v5,
+	.s5p_mfc_try_run = s5p_mfc_try_run_v5,
+	.s5p_mfc_cleanup_queue = s5p_mfc_cleanup_queue_v5,
+	.s5p_mfc_clear_int_flags = s5p_mfc_clear_int_flags_v5,
+	.s5p_mfc_write_info = s5p_mfc_write_info_v5,
+	.s5p_mfc_read_info = s5p_mfc_read_info_v5,
+	.s5p_mfc_get_dspl_y_adr = s5p_mfc_get_dspl_y_adr_v5,
+	.s5p_mfc_get_dec_y_adr = s5p_mfc_get_dec_y_adr_v5,
+	.s5p_mfc_get_dspl_status = s5p_mfc_get_dspl_status_v5,
+	.s5p_mfc_get_dec_status = s5p_mfc_get_dec_status_v5,
+	.s5p_mfc_get_dec_frame_type = s5p_mfc_get_dec_frame_type_v5,
+	.s5p_mfc_get_disp_frame_type = s5p_mfc_get_disp_frame_type_v5,
+	.s5p_mfc_get_consumed_stream = s5p_mfc_get_consumed_stream_v5,
+	.s5p_mfc_get_int_reason = s5p_mfc_get_int_reason_v5,
+	.s5p_mfc_get_int_err = s5p_mfc_get_int_err_v5,
+	.s5p_mfc_err_dec = s5p_mfc_err_dec_v5,
+	.s5p_mfc_err_dspl = s5p_mfc_err_dspl_v5,
+	.s5p_mfc_get_img_width = s5p_mfc_get_img_width_v5,
+	.s5p_mfc_get_img_height = s5p_mfc_get_img_height_v5,
+	.s5p_mfc_get_dpb_count = s5p_mfc_get_dpb_count_v5,
+	.s5p_mfc_get_mv_count = s5p_mfc_get_mv_count_v5,
+	.s5p_mfc_get_inst_no = s5p_mfc_get_inst_no_v5,
+	.s5p_mfc_get_enc_strm_size = s5p_mfc_get_enc_strm_size_v5,
+	.s5p_mfc_get_enc_slice_type = s5p_mfc_get_enc_slice_type_v5,
+	.s5p_mfc_get_enc_dpb_count = s5p_mfc_get_enc_dpb_count_v5,
+	.s5p_mfc_get_enc_pic_count = s5p_mfc_get_enc_pic_count_v5,
+	.s5p_mfc_get_sei_avail_status = s5p_mfc_get_sei_avail_status_v5,
+	.s5p_mfc_get_mvc_num_views = s5p_mfc_get_mvc_num_views_v5,
+	.s5p_mfc_get_mvc_view_id = s5p_mfc_get_mvc_view_id_v5,
+	.s5p_mfc_get_pic_type_top = s5p_mfc_get_pic_type_top_v5,
+	.s5p_mfc_get_pic_type_bot = s5p_mfc_get_pic_type_bot_v5,
+	.s5p_mfc_get_crop_info_h = s5p_mfc_get_crop_info_h_v5,
+	.s5p_mfc_get_crop_info_v = s5p_mfc_get_crop_info_v_v5,
+};
+
+const struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v5(void)
+{
+	return &s5p_mfc_ops_v5;
+}
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
new file mode 100644
index 0000000..9592f1a
--- /dev/null
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr_v5.h
@@ -0,0 +1,85 @@
+/*
+ * drivers/media/video/samsung/mfc5/s5p_mfc_opr_v5.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains declarations of hw related functions.
+ *
+ * Kamil Debski, Copyright (C) 2011 Samsung Electronics
+ * http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_OPR_V5_H_
+#define S5P_MFC_OPR_V5_H_
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_opr.h"
+
+enum MFC_SHM_OFS {
+	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
+	SET_FRAME_TAG		= 0x04, /* D */
+	GET_FRAME_TAG_TOP	= 0x08, /* D */
+	GET_FRAME_TAG_BOT	= 0x0C, /* D */
+	PIC_TIME_TOP		= 0x10, /* D */
+	PIC_TIME_BOT		= 0x14, /* D */
+	START_BYTE_NUM		= 0x18, /* D */
+
+	CROP_INFO_H		= 0x20, /* D */
+	CROP_INFO_V		= 0x24, /* D */
+	EXT_ENC_CONTROL		= 0x28,	/* E */
+	ENC_PARAM_CHANGE	= 0x2C,	/* E */
+	RC_VOP_TIMING		= 0x30,	/* E, MPEG4 */
+	HEC_PERIOD		= 0x34,	/* E, MPEG4 */
+	METADATA_ENABLE		= 0x38, /* C */
+	METADATA_STATUS		= 0x3C, /* C */
+	METADATA_DISPLAY_INDEX	= 0x40,	/* C */
+	EXT_METADATA_START_ADDR	= 0x44, /* C */
+	PUT_EXTRADATA		= 0x48, /* C */
+	EXTRADATA_ADDR		= 0x4C, /* C */
+
+	ALLOC_LUMA_DPB_SIZE	= 0x64,	/* D */
+	ALLOC_CHROMA_DPB_SIZE	= 0x68,	/* D */
+	ALLOC_MV_SIZE		= 0x6C,	/* D */
+	P_B_FRAME_QP		= 0x70,	/* E */
+	SAMPLE_ASPECT_RATIO_IDC	= 0x74, /* E, H.264, depend on
+				ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
+	EXTENDED_SAR		= 0x78, /* E, H.264, depned on
+				ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
+	DISP_PIC_PROFILE	= 0x7C, /* D */
+	FLUSH_CMD_TYPE		= 0x80, /* C */
+	FLUSH_CMD_INBUF1	= 0x84, /* C */
+	FLUSH_CMD_INBUF2	= 0x88, /* C */
+	FLUSH_CMD_OUTBUF	= 0x8C, /* E */
+	NEW_RC_BIT_RATE		= 0x90, /* E, format as RC_BIT_RATE(0xC5A8)
+			depend on RC_BIT_RATE_CHANGE in ENC_PARAM_CHANGE */
+	NEW_RC_FRAME_RATE	= 0x94, /* E, format as RC_FRAME_RATE(0xD0D0)
+			depend on RC_FRAME_RATE_CHANGE in ENC_PARAM_CHANGE */
+	NEW_I_PERIOD		= 0x98, /* E, format as I_FRM_CTRL(0xC504)
+			depend on I_PERIOD_CHANGE in ENC_PARAM_CHANGE */
+	H264_I_PERIOD		= 0x9C, /* E, H.264, open GOP */
+	RC_CONTROL_CONFIG	= 0xA0, /* E */
+	BATCH_INPUT_ADDR	= 0xA4, /* E */
+	BATCH_OUTPUT_ADDR	= 0xA8, /* E */
+	BATCH_OUTPUT_SIZE	= 0xAC, /* E */
+	MIN_LUMA_DPB_SIZE	= 0xB0, /* D */
+	DEVICE_FORMAT_ID	= 0xB4, /* C */
+	H264_POC_TYPE		= 0xB8, /* D */
+	MIN_CHROMA_DPB_SIZE	= 0xBC, /* D */
+	DISP_PIC_FRAME_TYPE	= 0xC0, /* D */
+	FREE_LUMA_DPB		= 0xC4, /* D, VC1 MPEG4 */
+	ASPECT_RATIO_INFO	= 0xC8, /* D, MPEG4 */
+	EXTENDED_PAR		= 0xCC, /* D, MPEG4 */
+	DBG_HISTORY_INPUT0	= 0xD0, /* C */
+	DBG_HISTORY_INPUT1	= 0xD4,	/* C */
+	DBG_HISTORY_OUTPUT	= 0xD8,	/* C */
+	HIERARCHICAL_P_QP	= 0xE0, /* E, H.264 */
+	FRAME_PACK_SEI_ENABLE	= 0x168, /* C */
+	FRAME_PACK_SEI_AVAIL	= 0x16c, /* D */
+	FRAME_PACK_SEI_INFO	= 0x17c, /* E */
+};
+
+const struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v5(void);
+#endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c b/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
deleted file mode 100644
index 91fdbac..0000000
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
+++ /dev/null
@@ -1,47 +0,0 @@
-/*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.c
- *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifdef CONFIG_ARCH_EXYNOS4
-#include <linux/dma-mapping.h>
-#endif
-#include <linux/io.h>
-#include "s5p_mfc_common.h"
-#include "s5p_mfc_debug.h"
-
-int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx)
-{
-	struct s5p_mfc_dev *dev = ctx->dev;
-	void *shm_alloc_ctx = dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
-
-	ctx->shm_alloc = vb2_dma_contig_memops.alloc(shm_alloc_ctx,
-							SHARED_BUF_SIZE);
-	if (IS_ERR(ctx->shm_alloc)) {
-		mfc_err("failed to allocate shared memory\n");
-		return PTR_ERR(ctx->shm_alloc);
-	}
-	/* shm_ofs only keeps the offset from base (port a) */
-	ctx->shm_ofs = s5p_mfc_mem_cookie(shm_alloc_ctx, ctx->shm_alloc)
-								- dev->bank1;
-	BUG_ON(ctx->shm_ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->shm = vb2_dma_contig_memops.vaddr(ctx->shm_alloc);
-	if (!ctx->shm) {
-		vb2_dma_contig_memops.put(ctx->shm_alloc);
-		ctx->shm_ofs = 0;
-		ctx->shm_alloc = NULL;
-		mfc_err("failed to virt addr of shared memory\n");
-		return -ENOMEM;
-	}
-	memset((void *)ctx->shm, 0, SHARED_BUF_SIZE);
-	wmb();
-	return 0;
-}
-
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h b/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
deleted file mode 100644
index cf962a4..0000000
--- a/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * linux/drivers/media/video/s5p-mfc/s5p_mfc_shm.h
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef S5P_MFC_SHM_H_
-#define S5P_MFC_SHM_H_
-
-enum MFC_SHM_OFS {
-	EXTENEDED_DECODE_STATUS	= 0x00,	/* D */
-	SET_FRAME_TAG		= 0x04, /* D */
-	GET_FRAME_TAG_TOP	= 0x08, /* D */
-	GET_FRAME_TAG_BOT	= 0x0C, /* D */
-	PIC_TIME_TOP		= 0x10, /* D */
-	PIC_TIME_BOT		= 0x14, /* D */
-	START_BYTE_NUM		= 0x18, /* D */
-
-	CROP_INFO_H		= 0x20, /* D */
-	CROP_INFO_V		= 0x24, /* D */
-	EXT_ENC_CONTROL		= 0x28,	/* E */
-	ENC_PARAM_CHANGE	= 0x2C,	/* E */
-	RC_VOP_TIMING		= 0x30,	/* E, MPEG4 */
-	HEC_PERIOD		= 0x34,	/* E, MPEG4 */
-	METADATA_ENABLE		= 0x38, /* C */
-	METADATA_STATUS		= 0x3C, /* C */
-	METADATA_DISPLAY_INDEX	= 0x40,	/* C */
-	EXT_METADATA_START_ADDR	= 0x44, /* C */
-	PUT_EXTRADATA		= 0x48, /* C */
-	EXTRADATA_ADDR		= 0x4C, /* C */
-
-	ALLOC_LUMA_DPB_SIZE	= 0x64,	/* D */
-	ALLOC_CHROMA_DPB_SIZE	= 0x68,	/* D */
-	ALLOC_MV_SIZE		= 0x6C,	/* D */
-	P_B_FRAME_QP		= 0x70,	/* E */
-	SAMPLE_ASPECT_RATIO_IDC	= 0x74, /* E, H.264, depend on
-				ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
-	EXTENDED_SAR		= 0x78, /* E, H.264, depned on
-				ASPECT_RATIO_VUI_ENABLE in EXT_ENC_CONTROL */
-	DISP_PIC_PROFILE	= 0x7C, /* D */
-	FLUSH_CMD_TYPE		= 0x80, /* C */
-	FLUSH_CMD_INBUF1	= 0x84, /* C */
-	FLUSH_CMD_INBUF2	= 0x88, /* C */
-	FLUSH_CMD_OUTBUF	= 0x8C, /* E */
-	NEW_RC_BIT_RATE		= 0x90, /* E, format as RC_BIT_RATE(0xC5A8)
-			depend on RC_BIT_RATE_CHANGE in ENC_PARAM_CHANGE */
-	NEW_RC_FRAME_RATE	= 0x94, /* E, format as RC_FRAME_RATE(0xD0D0)
-			depend on RC_FRAME_RATE_CHANGE in ENC_PARAM_CHANGE */
-	NEW_I_PERIOD		= 0x98, /* E, format as I_FRM_CTRL(0xC504)
-			depend on I_PERIOD_CHANGE in ENC_PARAM_CHANGE */
-	H264_I_PERIOD		= 0x9C, /* E, H.264, open GOP */
-	RC_CONTROL_CONFIG	= 0xA0, /* E */
-	BATCH_INPUT_ADDR	= 0xA4, /* E */
-	BATCH_OUTPUT_ADDR	= 0xA8, /* E */
-	BATCH_OUTPUT_SIZE	= 0xAC, /* E */
-	MIN_LUMA_DPB_SIZE	= 0xB0, /* D */
-	DEVICE_FORMAT_ID	= 0xB4, /* C */
-	H264_POC_TYPE		= 0xB8, /* D */
-	MIN_CHROMA_DPB_SIZE	= 0xBC, /* D */
-	DISP_PIC_FRAME_TYPE	= 0xC0, /* D */
-	FREE_LUMA_DPB		= 0xC4, /* D, VC1 MPEG4 */
-	ASPECT_RATIO_INFO	= 0xC8, /* D, MPEG4 */
-	EXTENDED_PAR		= 0xCC, /* D, MPEG4 */
-	DBG_HISTORY_INPUT0	= 0xD0, /* C */
-	DBG_HISTORY_INPUT1	= 0xD4,	/* C */
-	DBG_HISTORY_OUTPUT	= 0xD8,	/* C */
-	HIERARCHICAL_P_QP	= 0xE0, /* E, H.264 */
-};
-
-int s5p_mfc_init_shm(struct s5p_mfc_ctx *ctx);
-
-#define s5p_mfc_write_shm(ctx, x, ofs)		\
-	do {					\
-		writel(x, (ctx->shm + ofs));	\
-		wmb();				\
-	} while (0)
-
-static inline u32 s5p_mfc_read_shm(struct s5p_mfc_ctx *ctx, unsigned int ofs)
-{
-	rmb();
-	return readl(ctx->shm + ofs);
-}
-
-#endif /* S5P_MFC_SHM_H_ */
-- 
1.7.0.4


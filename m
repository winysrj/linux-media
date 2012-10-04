Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:61496 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2JCRG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 13:06:27 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBB00K5CU699FC0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:25 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBB009RUU5VQI80@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 02:06:24 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, arun.kk@samsung.com,
	joshi@samsung.com
Subject: [PATCH v10 7/7] [media] s5p-mfc: Update MFC v4l2 driver to support
 MFC6.x
Date: Thu, 04 Oct 2012 06:49:11 +0530
Message-id: <1349313551-23368-8-git-send-email-arun.kk@samsung.com>
In-reply-to: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
References: <1349313551-23368-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jeongtae Park <jtp.park@samsung.com>

Multi Format Codec 6.x is a hardware video coding acceleration
module present in new Exynos5 SoC series. It is capable of
handling several new video codecs for decoding and encoding.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Signed-off-by: Janghyuck Kim <janghyuck.kim@samsung.com>
Signed-off-by: Jaeryul Oh <jaeryul.oh@samsung.com>
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/Kconfig                  |    4 +-
 drivers/media/platform/s5p-mfc/Makefile         |    8 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h       |   21 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   64 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c    |    7 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c |  156 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h |   20 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   61 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |  162 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  193 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |  134 ++-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 1956 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h |   50 +
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |    3 +-
 15 files changed, 2679 insertions(+), 170 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
 create mode 100644 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f588d62..181c768 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -165,12 +165,12 @@ config VIDEO_SAMSUNG_S5P_JPEG
 	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec
 
 config VIDEO_SAMSUNG_S5P_MFC
-	tristate "Samsung S5P MFC 5.1 Video Codec"
+	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
 	select VIDEOBUF2_DMA_CONTIG
 	default n
 	help
-	    MFC 5.1 driver for V4L2.
+	    MFC 5.1 and 6.x driver for V4L2
 
 config VIDEO_MX2_EMMAPRP
 	tristate "MX2 eMMa-PrP support"
diff --git a/drivers/media/platform/s5p-mfc/Makefile b/drivers/media/platform/s5p-mfc/Makefile
index cfb9ee9..379008c 100644
--- a/drivers/media/platform/s5p-mfc/Makefile
+++ b/drivers/media/platform/s5p-mfc/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC) := s5p-mfc.o
-s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o s5p_mfc_opr.o
+s5p-mfc-y += s5p_mfc.o s5p_mfc_intr.o
 s5p-mfc-y += s5p_mfc_dec.o s5p_mfc_enc.o
-s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_cmd.o
-s5p-mfc-y += s5p_mfc_pm.o
-s5p-mfc-y += s5p_mfc_opr_v5.o s5p_mfc_cmd_v5.o
+s5p-mfc-y += s5p_mfc_ctrl.o s5p_mfc_pm.o
+s5p-mfc-y += s5p_mfc_opr.o s5p_mfc_opr_v5.o s5p_mfc_opr_v6.o
+s5p-mfc-y += s5p_mfc_cmd.o s5p_mfc_cmd_v5.o s5p_mfc_cmd_v6.o
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc.h b/drivers/media/platform/s5p-mfc/regs-mfc.h
index f33c54d..9319e93 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc.h
@@ -147,6 +147,7 @@
 #define S5P_FIMV_ENC_PROFILE_H264_MAIN			0
 #define S5P_FIMV_ENC_PROFILE_H264_HIGH			1
 #define S5P_FIMV_ENC_PROFILE_H264_BASELINE		2
+#define S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE	3
 #define S5P_FIMV_ENC_PROFILE_MPEG4_SIMPLE		0
 #define S5P_FIMV_ENC_PROFILE_MPEG4_ADVANCED_SIMPLE	1
 #define S5P_FIMV_ENC_PIC_STRUCT		0x083c /* picture field/frame flag */
@@ -216,6 +217,7 @@
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_MASK		(3<<4)
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_INC		(1<<4)
 #define S5P_FIMV_DEC_STATUS_RESOLUTION_DEC		(2<<4)
+#define S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT		4
 
 /* Decode frame address */
 #define S5P_FIMV_DECODE_Y_ADR			0x2024
@@ -380,6 +382,16 @@
 #define S5P_FIMV_R2H_CMD_EDFU_INIT_RET		16
 #define S5P_FIMV_R2H_CMD_ERR_RET		32
 
+/* Dummy definition for MFCv6 compatibilty */
+#define S5P_FIMV_CODEC_H264_MVC_DEC		-1
+#define S5P_FIMV_R2H_CMD_FIELD_DONE_RET		-1
+#define S5P_FIMV_MFC_RESET			-1
+#define S5P_FIMV_RISC_ON			-1
+#define S5P_FIMV_RISC_BASE_ADDRESS		-1
+#define S5P_FIMV_CODEC_VP8_DEC			-1
+#define S5P_FIMV_REG_CLEAR_BEGIN		0
+#define S5P_FIMV_REG_CLEAR_COUNT		0
+
 /* Error handling defines */
 #define S5P_FIMV_ERR_WARNINGS_START		145
 #define S5P_FIMV_ERR_DEC_MASK			0xFFFF
@@ -435,4 +447,13 @@
 #define MFC_VERSION		0x51
 #define MFC_NUM_PORTS		2
 
+#define S5P_FIMV_SHARED_FRAME_PACK_SEI_AVAIL    0x16C
+#define S5P_FIMV_SHARED_FRAME_PACK_ARRGMENT_ID  0x170
+#define S5P_FIMV_SHARED_FRAME_PACK_SEI_INFO     0x174
+#define S5P_FIMV_SHARED_FRAME_PACK_GRID_POS     0x178
+
+/* Values for resolution change in display status */
+#define S5P_FIMV_RES_INCREASE	1
+#define S5P_FIMV_RES_DECREASE	2
+
 #endif /* _REGS_FIMV_H */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 7feae81..aa55133 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -330,12 +330,14 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 
 	dst_frame_status = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
 				& S5P_FIMV_DEC_STATUS_DECODING_STATUS_MASK;
-	res_change = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
-				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK;
+	res_change = (s5p_mfc_hw_call(dev->mfc_ops, get_dspl_status, dev)
+				& S5P_FIMV_DEC_STATUS_RESOLUTION_MASK)
+				>> S5P_FIMV_DEC_STATUS_RESOLUTION_SHIFT;
 	mfc_debug(2, "Frame Status: %x\n", dst_frame_status);
 	if (ctx->state == MFCINST_RES_CHANGE_INIT)
 		ctx->state = MFCINST_RES_CHANGE_FLUSH;
-	if (res_change) {
+	if (res_change == S5P_FIMV_RES_INCREASE ||
+		res_change == S5P_FIMV_RES_DECREASE) {
 		ctx->state = MFCINST_RES_CHANGE_INIT;
 		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
@@ -494,10 +496,28 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 
 		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops, get_dpb_count,
 				dev);
+		ctx->mv_count = s5p_mfc_hw_call(dev->mfc_ops, get_mv_count,
+				dev);
 		if (ctx->img_width == 0 || ctx->img_height == 0)
 			ctx->state = MFCINST_ERROR;
 		else
 			ctx->state = MFCINST_HEAD_PARSED;
+
+		if ((ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) &&
+				!list_empty(&ctx->src_queue)) {
+			struct s5p_mfc_buf *src_buf;
+			src_buf = list_entry(ctx->src_queue.next,
+					struct s5p_mfc_buf, list);
+			if (s5p_mfc_hw_call(dev->mfc_ops, get_consumed_stream,
+						dev) <
+					src_buf->b->v4l2_planes[0].bytesused)
+				ctx->head_processed = 0;
+			else
+				ctx->head_processed = 1;
+		} else {
+			ctx->head_processed = 1;
+		}
 	}
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
@@ -526,7 +546,7 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 	clear_work_bit(ctx);
 	if (err == 0) {
 		ctx->state = MFCINST_RUNNING;
-		if (!ctx->dpb_flush_flag) {
+		if (!ctx->dpb_flush_flag && ctx->head_processed) {
 			spin_lock_irqsave(&dev->irqlock, flags);
 			if (!list_empty(&ctx->src_queue)) {
 				src_buf = list_entry(ctx->src_queue.next,
@@ -1071,6 +1091,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto err_res;
 	}
+
 	dev->mem_dev_r = device_find_child(&dev->plat_dev->dev, "s5p-mfc-r",
 					   match_child);
 	if (!dev->mem_dev_r) {
@@ -1301,12 +1322,47 @@ static struct s5p_mfc_variant mfc_drvdata_v5 = {
 	.port_num	= MFC_NUM_PORTS,
 	.buf_size	= &buf_size_v5,
 	.buf_align	= &mfc_buf_align_v5,
+	.mclk_name	= "sclk_mfc",
+	.fw_name	= "s5p-mfc.fw",
+};
+
+struct s5p_mfc_buf_size_v6 mfc_buf_size_v6 = {
+	.dev_ctx	= MFC_CTX_BUF_SIZE_V6,
+	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V6,
+	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V6,
+	.h264_enc_ctx	= MFC_H264_ENC_CTX_BUF_SIZE_V6,
+	.other_enc_ctx	= MFC_OTHER_ENC_CTX_BUF_SIZE_V6,
+};
+
+struct s5p_mfc_buf_size buf_size_v6 = {
+	.fw	= MAX_FW_SIZE_V6,
+	.cpb	= MAX_CPB_SIZE_V6,
+	.priv	= &mfc_buf_size_v6,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v6 = {
+	.base = 0,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v6 = {
+	.version	= MFC_VERSION_V6,
+	.port_num	= MFC_NUM_PORTS_V6,
+	.buf_size	= &buf_size_v6,
+	.buf_align	= &mfc_buf_align_v6,
+	.mclk_name      = "aclk_333",
+	.fw_name        = "s5p-mfc-v6.fw",
 };
 
 static struct platform_device_id mfc_driver_ids[] = {
 	{
 		.name = "s5p-mfc",
 		.driver_data = (unsigned long)&mfc_drvdata_v5,
+	}, {
+		.name = "s5p-mfc-v5",
+		.driver_data = (unsigned long)&mfc_drvdata_v5,
+	}, {
+		.name = "s5p-mfc-v6",
+		.driver_data = (unsigned long)&mfc_drvdata_v6,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
index 8ea304b..f0a41c9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd.c
@@ -14,11 +14,16 @@
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_cmd_v5.h"
+#include "s5p_mfc_cmd_v6.h"
 
 static struct s5p_mfc_hw_cmds *s5p_mfc_cmds;
 
 void s5p_mfc_init_hw_cmds(struct s5p_mfc_dev *dev)
 {
-	s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v5();
+	if (IS_MFCV6(dev))
+		s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v6();
+	else
+		s5p_mfc_cmds = s5p_mfc_init_hw_cmds_v5();
+
 	dev->mfc_cmds = s5p_mfc_cmds;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
new file mode 100644
index 0000000..754bfbc
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
@@ -0,0 +1,156 @@
+/*
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.c
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include "s5p_mfc_common.h"
+
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_opr.h"
+
+int s5p_mfc_cmd_host2risc_v6(struct s5p_mfc_dev *dev, int cmd,
+				struct s5p_mfc_cmd_args *args)
+{
+	mfc_debug(2, "Issue the command: %d\n", cmd);
+
+	/* Reset RISC2HOST command */
+	mfc_write(dev, 0x0, S5P_FIMV_RISC2HOST_CMD_V6);
+
+	/* Issue the command */
+	mfc_write(dev, cmd, S5P_FIMV_HOST2RISC_CMD_V6);
+	mfc_write(dev, 0x1, S5P_FIMV_HOST2RISC_INT_V6);
+
+	return 0;
+}
+
+int s5p_mfc_sys_init_cmd_v6(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+
+	s5p_mfc_hw_call(dev->mfc_ops, alloc_dev_context_buffer, dev);
+	mfc_write(dev, dev->ctx_buf.dma, S5P_FIMV_CONTEXT_MEM_ADDR_V6);
+	mfc_write(dev, buf_size->dev_ctx, S5P_FIMV_CONTEXT_MEM_SIZE_V6);
+	return s5p_mfc_cmd_host2risc_v6(dev, S5P_FIMV_H2R_CMD_SYS_INIT_V6,
+					&h2r_args);
+}
+
+int s5p_mfc_sleep_cmd_v6(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	return s5p_mfc_cmd_host2risc_v6(dev, S5P_FIMV_H2R_CMD_SLEEP_V6,
+			&h2r_args);
+}
+
+int s5p_mfc_wakeup_cmd_v6(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_cmd_args h2r_args;
+
+	memset(&h2r_args, 0, sizeof(struct s5p_mfc_cmd_args));
+	return s5p_mfc_cmd_host2risc_v6(dev, S5P_FIMV_H2R_CMD_WAKEUP_V6,
+					&h2r_args);
+}
+
+/* Open a new instance and get its number */
+int s5p_mfc_open_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int codec_type;
+
+	mfc_debug(2, "Requested codec mode: %d\n", ctx->codec_mode);
+	dev->curr_ctx = ctx->num;
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+		codec_type = S5P_FIMV_CODEC_H264_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_H264_MVC_DEC:
+		codec_type = S5P_FIMV_CODEC_H264_MVC_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_VC1_DEC:
+		codec_type = S5P_FIMV_CODEC_VC1_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+		codec_type = S5P_FIMV_CODEC_MPEG4_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_MPEG2_DEC:
+		codec_type = S5P_FIMV_CODEC_MPEG2_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_H263_DEC:
+		codec_type = S5P_FIMV_CODEC_H263_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+		codec_type = S5P_FIMV_CODEC_VC1RCV_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_VP8_DEC:
+		codec_type = S5P_FIMV_CODEC_VP8_DEC_V6;
+		break;
+	case S5P_MFC_CODEC_H264_ENC:
+		codec_type = S5P_FIMV_CODEC_H264_ENC_V6;
+		break;
+	case S5P_MFC_CODEC_H264_MVC_ENC:
+		codec_type = S5P_FIMV_CODEC_H264_MVC_ENC_V6;
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+		codec_type = S5P_FIMV_CODEC_MPEG4_ENC_V6;
+		break;
+	case S5P_MFC_CODEC_H263_ENC:
+		codec_type = S5P_FIMV_CODEC_H263_ENC_V6;
+		break;
+	default:
+		codec_type = S5P_FIMV_CODEC_NONE_V6;
+	};
+	mfc_write(dev, codec_type, S5P_FIMV_CODEC_TYPE_V6);
+	mfc_write(dev, ctx->ctx.dma, S5P_FIMV_CONTEXT_MEM_ADDR_V6);
+	mfc_write(dev, ctx->ctx.size, S5P_FIMV_CONTEXT_MEM_SIZE_V6);
+	mfc_write(dev, 0, S5P_FIMV_D_CRC_CTRL_V6); /* no crc */
+
+	return s5p_mfc_cmd_host2risc_v6(dev, S5P_FIMV_H2R_CMD_OPEN_INSTANCE_V6,
+					&h2r_args);
+}
+
+/* Close instance */
+int s5p_mfc_close_inst_cmd_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_cmd_args h2r_args;
+	int ret = 0;
+
+	dev->curr_ctx = ctx->num;
+	if (ctx->state != MFCINST_FREE) {
+		mfc_write(dev, ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+		ret = s5p_mfc_cmd_host2risc_v6(dev,
+					S5P_FIMV_H2R_CMD_CLOSE_INSTANCE_V6,
+					&h2r_args);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+/* Initialize cmd function pointers for MFC v6 */
+static struct s5p_mfc_hw_cmds s5p_mfc_cmds_v6 = {
+	.cmd_host2risc = s5p_mfc_cmd_host2risc_v6,
+	.sys_init_cmd = s5p_mfc_sys_init_cmd_v6,
+	.sleep_cmd = s5p_mfc_sleep_cmd_v6,
+	.wakeup_cmd = s5p_mfc_wakeup_cmd_v6,
+	.open_inst_cmd = s5p_mfc_open_inst_cmd_v6,
+	.close_inst_cmd = s5p_mfc_close_inst_cmd_v6,
+};
+
+struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v6(void)
+{
+	return &s5p_mfc_cmds_v6;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
new file mode 100644
index 0000000..b7a8e57
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
@@ -0,0 +1,20 @@
+/*
+ * linux/drivers/media/platform/s5p-mfc/s5p_mfc_cmd_v6.h
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
+#ifndef S5P_MFC_CMD_V6_H_
+#define S5P_MFC_CMD_V6_H_
+
+#include "s5p_mfc_common.h"
+
+struct s5p_mfc_hw_cmds *s5p_mfc_init_hw_cmds_v6(void);
+
+#endif /* S5P_MFC_CMD_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index e495b13..f02e049 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -16,13 +16,14 @@
 #ifndef S5P_MFC_COMMON_H_
 #define S5P_MFC_COMMON_H_
 
-#include "regs-mfc.h"
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
+#include "regs-mfc.h"
+#include "regs-mfc-v6.h"
 
 /* Definitions related to MFC memory */
 
@@ -206,6 +207,14 @@ struct s5p_mfc_buf_size_v5 {
 	unsigned int shm;
 };
 
+struct s5p_mfc_buf_size_v6 {
+	unsigned int dev_ctx;
+	unsigned int h264_dec_ctx;
+	unsigned int other_dec_ctx;
+	unsigned int h264_enc_ctx;
+	unsigned int other_enc_ctx;
+};
+
 struct s5p_mfc_buf_size {
 	unsigned int fw;
 	unsigned int cpb;
@@ -221,6 +230,8 @@ struct s5p_mfc_variant {
 	unsigned int port_num;
 	struct s5p_mfc_buf_size *buf_size;
 	struct s5p_mfc_buf_align *buf_align;
+	char	*mclk_name;
+	char	*fw_name;
 };
 
 /**
@@ -277,6 +288,7 @@ struct s5p_mfc_priv_buf {
  * @watchdog_work:	worker for the watchdog
  * @alloc_ctx:		videobuf2 allocator contexts for two memory banks
  * @enter_suspend:	flag set when entering suspend
+ * @ctx_buf:		common context memory (MFCv6)
  * @warn_start:		hardware error code from which warnings start
  * @mfc_ops:		ops structure holding HW operation function pointers
  * @mfc_cmds:		cmd structure holding HW commands function pointers
@@ -318,6 +330,7 @@ struct s5p_mfc_dev {
 	void *alloc_ctx[2];
 	unsigned long enter_suspend;
 
+	struct s5p_mfc_priv_buf ctx_buf;
 	int warn_start;
 	struct s5p_mfc_hw_ops *mfc_ops;
 	struct s5p_mfc_hw_cmds *mfc_cmds;
@@ -354,6 +367,22 @@ struct s5p_mfc_h264_enc_params {
 	int level;
 	u16 cpb_size;
 	int interlace;
+	u8 hier_qp;
+	u8 hier_qp_type;
+	u8 hier_qp_layer;
+	u8 hier_qp_layer_qp[7];
+	u8 sei_frame_packing;
+	u8 sei_fp_curr_frame_0;
+	u8 sei_fp_arrangement_type;
+
+	u8 fmo;
+	u8 fmo_map_type;
+	u8 fmo_slice_grp;
+	u8 fmo_chg_dir;
+	u32 fmo_chg_rate;
+	u32 fmo_run_len[4];
+	u8 aso;
+	u32 aso_slice_order[8];
 };
 
 /**
@@ -396,6 +425,7 @@ struct s5p_mfc_enc_params {
 	u32 rc_bitrate;
 	u16 rc_reaction_coeff;
 	u16 vbv_size;
+	u32 vbv_delay;
 
 	enum v4l2_mpeg_video_header_mode seq_hdr_mode;
 	enum v4l2_mpeg_mfc51_video_frame_skip_mode frame_skip_mode;
@@ -461,6 +491,8 @@ struct s5p_mfc_codec_ops {
  *			decoding buffer
  * @dpb_flush_flag:	flag used to indicate that a DPB buffers are being
  *			flushed
+ * @head_processed:	flag mentioning whether the header data is processed
+ *			completely or not
  * @bank1_buf:		handle to memory allocated for temporary buffers from
  *			memory bank 1
  * @bank1_phys:		address of the temporary buffers from memory bank 1
@@ -485,14 +517,20 @@ struct s5p_mfc_codec_ops {
  * @display_delay_enable:	display delay for H264 enable flag
  * @after_packed_pb:	flag used to track buffer when stream is in
  *			Packed PB format
+ * @sei_fp_parse:	enable/disable parsing of frame packing SEI information
  * @dpb_count:		count of the DPB buffers required by MFC hw
  * @total_dpb_count:	count of DPB buffers with additional buffers
  *			requested by the application
  * @ctx:		context buffer information
  * @dsc:		descriptor buffer information
  * @shm:		shared memory buffer information
+ * @mv_count:		number of MV buffers allocated for decoding
  * @enc_params:		encoding parameters for MFC
  * @enc_dst_buf_size:	size of the buffers for encoder output
+ * @luma_dpb_size:	dpb buffer size for luma
+ * @chroma_dpb_size:	dpb buffer size for chroma
+ * @me_buffer_size:	size of the motion estimation buffer
+ * @tmv_buffer_size:	size of temporal predictor motion vector buffer
  * @frame_type:		used to force the type of the next encoded frame
  * @ref_queue:		list of the reference buffers for encoding
  * @ref_queue_cnt:	number of the buffers in the reference list
@@ -541,6 +579,7 @@ struct s5p_mfc_ctx {
 	unsigned long consumed_stream;
 
 	unsigned int dpb_flush_flag;
+	unsigned int head_processed;
 
 	/* Buffers */
 	void *bank1_buf;
@@ -570,10 +609,11 @@ struct s5p_mfc_ctx {
 	int display_delay;
 	int display_delay_enable;
 	int after_packed_pb;
+	int sei_fp_parse;
 
 	int dpb_count;
 	int total_dpb_count;
-
+	int mv_count;
 	/* Buffers */
 	struct s5p_mfc_priv_buf ctx;
 	struct s5p_mfc_priv_buf dsc;
@@ -582,16 +622,28 @@ struct s5p_mfc_ctx {
 	struct s5p_mfc_enc_params enc_params;
 
 	size_t enc_dst_buf_size;
+	size_t luma_dpb_size;
+	size_t chroma_dpb_size;
+	size_t me_buffer_size;
+	size_t tmv_buffer_size;
 
 	enum v4l2_mpeg_mfc51_video_force_frame_type force_frame_type;
 
 	struct list_head ref_queue;
 	unsigned int ref_queue_cnt;
 
+	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
+	union {
+		unsigned int mb;
+		unsigned int bits;
+	} slice_size;
+
 	struct s5p_mfc_codec_ops *c_ops;
 
 	struct v4l2_ctrl *ctrls[MFC_MAX_CTRLS];
 	struct v4l2_ctrl_handler ctrl_handler;
+	unsigned int frame_tag;
+	size_t scratch_buf_size;
 };
 
 /*
@@ -637,4 +689,9 @@ void set_work_bit(struct s5p_mfc_ctx *ctx);
 void clear_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 
+#define HAS_PORTNUM(dev)	(dev ? (dev->variant ? \
+				(dev->variant->port_num ? 1 : 0) : 0) : 0)
+#define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
+#define IS_MFCV6(dev)		(dev->variant->version >= 0x60 ? 1 : 0)
+
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 311ec90..585b7b0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -37,8 +37,9 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 	/* Firmare has to be present as a separate file or compiled
 	 * into kernel. */
 	mfc_debug_enter();
+
 	err = request_firmware((const struct firmware **)&fw_blob,
-				     "s5p-mfc.fw", dev->v4l2_dev.dev);
+				     dev->variant->fw_name, dev->v4l2_dev.dev);
 	if (err != 0) {
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
@@ -82,32 +83,37 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
 		return -EIO;
 	}
 	dev->bank1 = s5p_mfc_bitproc_phys;
-	b_base = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], 1 << MFC_BASE_ALIGN_ORDER);
-	if (IS_ERR(b_base)) {
-		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = NULL;
-		mfc_err("Allocating bank2 base failed\n");
-	release_firmware(fw_blob);
-		return -ENOMEM;
-	}
-	bank2_base_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], b_base);
-	vb2_dma_contig_memops.put(b_base);
-	if (bank2_base_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
-		mfc_err("The base memory for bank 2 is not aligned to 128KB\n");
-		vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
-		s5p_mfc_bitproc_phys = 0;
-		s5p_mfc_bitproc_buf = NULL;
-		release_firmware(fw_blob);
-		return -EIO;
+	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
+		b_base = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX],
+			1 << MFC_BASE_ALIGN_ORDER);
+		if (IS_ERR(b_base)) {
+			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+			s5p_mfc_bitproc_phys = 0;
+			s5p_mfc_bitproc_buf = NULL;
+			mfc_err("Allocating bank2 base failed\n");
+			release_firmware(fw_blob);
+			return -ENOMEM;
+		}
+		bank2_base_phys = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], b_base);
+		vb2_dma_contig_memops.put(b_base);
+		if (bank2_base_phys & ((1 << MFC_BASE_ALIGN_ORDER) - 1)) {
+			mfc_err("The base memory for bank 2 is not aligned to 128KB\n");
+			vb2_dma_contig_memops.put(s5p_mfc_bitproc_buf);
+			s5p_mfc_bitproc_phys = 0;
+			s5p_mfc_bitproc_buf = NULL;
+			release_firmware(fw_blob);
+			return -EIO;
+		}
+		/* Valid buffers passed to MFC encoder with LAST_FRAME command
+		 * should not have address of bank2 - MFC will treat it as a null frame.
+		 * To avoid such situation we set bank2 address below the pool address.
+		 */
+		dev->bank2 = bank2_base_phys - (1 << MFC_BASE_ALIGN_ORDER);
+	} else {
+		dev->bank2 = dev->bank1;
 	}
-	/* Valid buffers passed to MFC encoder with LAST_FRAME command
-	 * should not have address of bank2 - MFC will treat it as a null frame.
-	 * To avoid such situation we set bank2 address below the pool address.
-	 */
-	dev->bank2 = bank2_base_phys - (1 << MFC_BASE_ALIGN_ORDER);
 	memcpy(s5p_mfc_bitproc_virt, fw_blob->data, fw_blob->size);
 	wmb();
 	release_firmware(fw_blob);
@@ -124,8 +130,9 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
 	/* Firmare has to be present as a separate file or compiled
 	 * into kernel. */
 	mfc_debug_enter();
+
 	err = request_firmware((const struct firmware **)&fw_blob,
-				     "s5p-mfc.fw", dev->v4l2_dev.dev);
+				     dev->variant->fw_name, dev->v4l2_dev.dev);
 	if (err != 0) {
 		mfc_err("Firmware is not present in the /lib/firmware directory nor compiled in kernel\n");
 		return -EINVAL;
@@ -166,46 +173,81 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 {
 	unsigned int mc_status;
 	unsigned long timeout;
+	int i;
 
 	mfc_debug_enter();
-	/* Stop procedure */
-	/*  reset RISC */
-	mfc_write(dev, 0x3f6, S5P_FIMV_SW_RESET);
-	/*  All reset except for MC */
-	mfc_write(dev, 0x3e2, S5P_FIMV_SW_RESET);
-	mdelay(10);
-
-	timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
-	/* Check MC status */
-	do {
-		if (time_after(jiffies, timeout)) {
-			mfc_err("Timeout while resetting MFC\n");
-			return -EIO;
-		}
 
-		mc_status = mfc_read(dev, S5P_FIMV_MC_STATUS);
+	if (IS_MFCV6(dev)) {
+		/* Reset IP */
+		/*  except RISC, reset */
+		mfc_write(dev, 0xFEE, S5P_FIMV_MFC_RESET_V6);
+		/*  reset release */
+		mfc_write(dev, 0x0, S5P_FIMV_MFC_RESET_V6);
+
+		/* Zero Initialization of MFC registers */
+		mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD_V6);
+		mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD_V6);
+		mfc_write(dev, 0, S5P_FIMV_FW_VERSION_V6);
+
+		for (i = 0; i < S5P_FIMV_REG_CLEAR_COUNT_V6; i++)
+			mfc_write(dev, 0, S5P_FIMV_REG_CLEAR_BEGIN_V6 + (i*4));
+
+		/* Reset */
+		mfc_write(dev, 0, S5P_FIMV_RISC_ON_V6);
+		mfc_write(dev, 0x1FFF, S5P_FIMV_MFC_RESET_V6);
+		mfc_write(dev, 0, S5P_FIMV_MFC_RESET_V6);
+	} else {
+		/* Stop procedure */
+		/*  reset RISC */
+		mfc_write(dev, 0x3f6, S5P_FIMV_SW_RESET);
+		/*  All reset except for MC */
+		mfc_write(dev, 0x3e2, S5P_FIMV_SW_RESET);
+		mdelay(10);
 
-	} while (mc_status & 0x3);
+		timeout = jiffies + msecs_to_jiffies(MFC_BW_TIMEOUT);
+		/* Check MC status */
+		do {
+			if (time_after(jiffies, timeout)) {
+				mfc_err("Timeout while resetting MFC\n");
+				return -EIO;
+			}
+
+			mc_status = mfc_read(dev, S5P_FIMV_MC_STATUS);
+
+		} while (mc_status & 0x3);
+
+		mfc_write(dev, 0x0, S5P_FIMV_SW_RESET);
+		mfc_write(dev, 0x3fe, S5P_FIMV_SW_RESET);
+	}
 
-	mfc_write(dev, 0x0, S5P_FIMV_SW_RESET);
-	mfc_write(dev, 0x3fe, S5P_FIMV_SW_RESET);
 	mfc_debug_leave();
 	return 0;
 }
 
 static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
-	mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
-	mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
-	mfc_debug(2, "Bank1: %08x, Bank2: %08x\n", dev->bank1, dev->bank2);
+	if (IS_MFCV6(dev)) {
+		mfc_write(dev, dev->bank1, S5P_FIMV_RISC_BASE_ADDRESS_V6);
+		mfc_debug(2, "Base Address : %08x\n", dev->bank1);
+	} else {
+		mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
+		mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
+		mfc_debug(2, "Bank1: %08x, Bank2: %08x\n",
+				dev->bank1, dev->bank2);
+	}
 }
 
 static inline void s5p_mfc_clear_cmds(struct s5p_mfc_dev *dev)
 {
-	mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
-	mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
-	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
-	mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD);
+	if (IS_MFCV6(dev)) {
+		/* Zero initialization should be done before RESET.
+		 * Nothing to do here. */
+	} else {
+		mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH0_INST_ID);
+		mfc_write(dev, 0xffffffff, S5P_FIMV_SI_CH1_INST_ID);
+		mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD);
+		mfc_write(dev, 0, S5P_FIMV_HOST2RISC_CMD);
+	}
 }
 
 /* Initialize hardware */
@@ -233,7 +275,10 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	s5p_mfc_clear_cmds(dev);
 	/* 3. Release reset signal to the RISC */
 	s5p_mfc_clean_dev_int_flags(dev);
-	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+	if (IS_MFCV6(dev))
+		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+	else
+		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
 		mfc_err("Failed to load firmware\n");
@@ -267,7 +312,11 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		s5p_mfc_clock_off();
 		return -EIO;
 	}
-	ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
+	if (IS_MFCV6(dev))
+		ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
+	else
+		ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
+
 	mfc_debug(2, "MFC F/W version : %02xyy, %02xmm, %02xdd\n",
 		(ver >> 16) & 0xFF, (ver >> 8) & 0xFF, ver & 0xFF);
 	s5p_mfc_clock_off();
@@ -342,7 +391,10 @@ int s5p_mfc_wakeup(struct s5p_mfc_dev *dev)
 		return ret;
 	}
 	/* 4. Release reset signal to the RISC */
-	mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+	if (IS_MFCV6(dev))
+		mfc_write(dev, 0x1, S5P_FIMV_RISC_ON_V6);
+	else
+		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
 	mfc_debug(2, "Ok, now will write a command to wakeup the system\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_WAKEUP_RET)) {
 		mfc_err("Failed to load firmware\n");
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 107609c..eb6a70b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -31,10 +31,17 @@
 #include "s5p_mfc_pm.h"
 
 #define DEF_SRC_FMT_DEC	V4L2_PIX_FMT_H264
-#define DEF_DST_FMT_DEC	V4L2_PIX_FMT_NV12MT
+#define DEF_DST_FMT_DEC	V4L2_PIX_FMT_NV12MT_16X16
 
 static struct s5p_mfc_fmt formats[] = {
 	{
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
 		.name		= "4:2:0 2 Planes 64x32 Tiles",
 		.fourcc		= V4L2_PIX_FMT_NV12MT,
 		.codec_mode	= S5P_MFC_CODEC_NONE,
@@ -42,67 +49,88 @@ static struct s5p_mfc_fmt formats[] = {
 		.num_planes	= 2,
 	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_MFC_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
+	},
+	{
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_MFC_CODEC_H264_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_MFC_CODEC_H264_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "H264/MVC Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264_MVC,
+		.codec_mode	= S5P_MFC_CODEC_H264_MVC_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_MFC_CODEC_H263_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_MFC_CODEC_H263_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG1,
-		.codec_mode = S5P_MFC_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG1,
+		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG2 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG2,
-		.codec_mode = S5P_MFC_CODEC_MPEG2_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG2 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG2,
+		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_MFC_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "XviD Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_XVID,
-		.codec_mode = S5P_MFC_CODEC_MPEG4_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "XviD Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_XVID,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_G,
-		.codec_mode = S5P_MFC_CODEC_VC1_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_G,
+		.codec_mode	= S5P_MFC_CODEC_VC1_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 	{
-		.name = "VC1 RCV Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_VC1_ANNEX_L,
-		.codec_mode = S5P_MFC_CODEC_VC1RCV_DEC,
-		.type = MFC_FMT_DEC,
-		.num_planes = 1,
+		.name		= "VC1 RCV Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VC1_ANNEX_L,
+		.codec_mode	= S5P_MFC_CODEC_VC1RCV_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "VP8 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_VP8,
+		.codec_mode	= S5P_MFC_CODEC_VP8_DEC,
+		.type		= MFC_FMT_DEC,
+		.num_planes	= 1,
 	},
 };
 
@@ -343,21 +371,36 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 /* Try format */
 static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 
-	if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
-		mfc_err("This node supports decoding only\n");
-		return -EINVAL;
-	}
-	fmt = find_format(f, MFC_FMT_DEC);
-	if (!fmt) {
-		mfc_err("Unsupported format\n");
-		return -EINVAL;
-	}
-	if (fmt->type != MFC_FMT_DEC) {
-		mfc_err("\n");
-		return -EINVAL;
+	mfc_debug(2, "Type is %d\n", f->type);
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		fmt = find_format(f, MFC_FMT_DEC);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+	} else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for destination.\n");
+			return -EINVAL;
+		}
+		if (IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (!IS_MFCV6(dev) &&
+				(fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
 	}
+
 	return 0;
 }
 
@@ -380,6 +423,27 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EBUSY;
 		goto out;
 	}
+	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		fmt = find_format(f, MFC_FMT_RAW);
+		if (!fmt) {
+			mfc_err("Unsupported format for source.\n");
+			return -EINVAL;
+		}
+		if (!IS_MFCV6(dev) && (fmt->fourcc != V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+		ctx->dst_fmt = fmt;
+		mfc_debug_leave();
+		return ret;
+	} else if (f->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		mfc_err("Wrong type error for S_FMT : %d", f->type);
+		return -EINVAL;
+	}
 	fmt = find_format(f, MFC_FMT_DEC);
 	if (!fmt || fmt->codec_mode == S5P_MFC_CODEC_NONE) {
 		mfc_err("Unknown codec\n");
@@ -392,6 +456,10 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 		ret = -EINVAL;
 		goto out;
 	}
+	if (!IS_MFCV6(dev) && (fmt->fourcc == V4L2_PIX_FMT_VP8)) {
+		mfc_err("Not supported format.\n");
+		return -EINVAL;
+	}
 	ctx->src_fmt = fmt;
 	ctx->codec_mode = fmt->codec_mode;
 	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
@@ -756,6 +824,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	/* Video output for decoding (source)
 	 * this can be set after getting an instance */
@@ -791,7 +860,13 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 	    vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+
+		if (IS_MFCV6(dev))
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		else
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
 		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index b0879f9..2af6d52 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -36,39 +36,53 @@
 
 static struct s5p_mfc_fmt formats[] = {
 	{
-		.name = "4:2:0 2 Planes 64x32 Tiles",
-		.fourcc = V4L2_PIX_FMT_NV12MT,
-		.codec_mode = S5P_MFC_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes 16x16 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT_16X16,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "4:2:0 2 Planes",
-		.fourcc = V4L2_PIX_FMT_NV12M,
-		.codec_mode = S5P_MFC_CODEC_NONE,
-		.type = MFC_FMT_RAW,
-		.num_planes = 2,
+		.name		= "4:2:0 2 Planes 64x32 Tiles",
+		.fourcc		= V4L2_PIX_FMT_NV12MT,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-		.codec_mode = S5P_MFC_CODEC_H264_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "4:2:0 2 Planes Y/CbCr",
+		.fourcc		= V4L2_PIX_FMT_NV12M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-		.codec_mode = S5P_MFC_CODEC_MPEG4_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "4:2:0 2 Planes Y/CrCb",
+		.fourcc		= V4L2_PIX_FMT_NV21M,
+		.codec_mode	= S5P_MFC_CODEC_NONE,
+		.type		= MFC_FMT_RAW,
+		.num_planes	= 2,
 	},
 	{
-		.name = "H263 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H263,
-		.codec_mode = S5P_MFC_CODEC_H263_ENC,
-		.type = MFC_FMT_ENC,
-		.num_planes = 1,
+		.name		= "H264 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H264,
+		.codec_mode	= S5P_MFC_CODEC_H264_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "MPEG4 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_MPEG4,
+		.codec_mode	= S5P_MFC_CODEC_MPEG4_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
+	},
+	{
+		.name		= "H263 Encoded Stream",
+		.fourcc		= V4L2_PIX_FMT_H263,
+		.codec_mode	= S5P_MFC_CODEC_H263_ENC,
+		.type		= MFC_FMT_ENC,
+		.num_planes	= 1,
 	},
 };
 
@@ -576,7 +590,8 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 	if (ctx->state == MFCINST_GOT_INST && ctx->dst_queue_cnt >= 1)
 		return 1;
 	/* context is ready to encode a frame */
-	if (ctx->state == MFCINST_RUNNING &&
+	if ((ctx->state == MFCINST_RUNNING ||
+		ctx->state == MFCINST_HEAD_PARSED) &&
 		ctx->src_queue_cnt >= 1 && ctx->dst_queue_cnt >= 1)
 		return 1;
 	/* context is ready to encode remaining frames */
@@ -645,10 +660,19 @@ static int enc_post_seq_start(struct s5p_mfc_ctx *ctx)
 		vb2_buffer_done(dst_mb->b, VB2_BUF_STATE_DONE);
 		spin_unlock_irqrestore(&dev->irqlock, flags);
 	}
-	ctx->state = MFCINST_RUNNING;
-	if (s5p_mfc_ctx_ready(ctx))
-		set_work_bit_irqsave(ctx);
-	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	if (IS_MFCV6(dev)) {
+		ctx->state = MFCINST_HEAD_PARSED; /* for INIT_BUFFER cmd */
+	} else {
+		ctx->state = MFCINST_RUNNING;
+		if (s5p_mfc_ctx_ready(ctx))
+			set_work_bit_irqsave(ctx);
+		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+	}
+
+	if (IS_MFCV6(dev))
+		ctx->dpb_count = s5p_mfc_hw_call(dev->mfc_ops,
+				get_enc_dpb_count, dev);
+
 	return 0;
 }
 
@@ -965,6 +989,17 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to set output format\n");
 			return -EINVAL;
 		}
+
+		if (!IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		} else if (IS_MFCV6(dev) &&
+				(fmt->fourcc == V4L2_PIX_FMT_NV12MT)) {
+			mfc_err("Not supported format.\n");
+			return -EINVAL;
+		}
+
 		if (fmt->num_planes != pix_fmt_mp->num_planes) {
 			mfc_err("failed to set output format\n");
 			ret = -EINVAL;
@@ -998,6 +1033,7 @@ out:
 static int vidioc_reqbufs(struct file *file, void *priv,
 					  struct v4l2_requestbuffers *reqbufs)
 {
+	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	int ret = 0;
 
@@ -1017,13 +1053,16 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			return ret;
 		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
-		ret = s5p_mfc_hw_call(ctx->dev->mfc_ops, alloc_codec_buffers,
-				ctx);
-		if (ret) {
-			mfc_err("Failed to allocate encoding buffers\n");
-			reqbufs->count = 0;
-			ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
-			return -ENOMEM;
+
+		if (!IS_MFCV6(dev)) {
+			ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
+					alloc_codec_buffers, ctx);
+			if (ret) {
+				mfc_err("Failed to allocate encoding buffers\n");
+				reqbufs->count = 0;
+				ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
+				return -ENOMEM;
+			}
 		}
 	} else if (reqbufs->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->output_state != QUEUE_FREE) {
@@ -1286,6 +1325,13 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 			p->codec.h264.profile =
 				S5P_FIMV_ENC_PROFILE_H264_BASELINE;
 			break;
+		case V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE:
+			if (IS_MFCV6(dev))
+				p->codec.h264.profile =
+				S5P_FIMV_ENC_PROFILE_H264_CONSTRAINED_BASELINE;
+			else
+				ret = -EINVAL;
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -1559,6 +1605,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			unsigned int psize[], void *allocators[])
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(vq->drv_priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
 
 	if (ctx->state != MFCINST_GOT_INST) {
 		mfc_err("inavlid state: %d\n", ctx->state);
@@ -1587,8 +1634,17 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->luma_size;
 		psize[1] = ctx->chroma_size;
-		allocators[0] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
-		allocators[1] = ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		if (IS_MFCV6(dev)) {
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+			allocators[1] =
+				ctx->dev->alloc_ctx[MFC_BANK1_ALLOC_CTX];
+		} else {
+			allocators[0] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+			allocators[1] =
+				ctx->dev->alloc_ctx[MFC_BANK2_ALLOC_CTX];
+		}
 	} else {
 		mfc_err("inavlid queue type: %d\n", vq->type);
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index b6246b2..6932e90 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -14,12 +14,18 @@
 
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_opr_v5.h"
+#include "s5p_mfc_opr_v6.h"
 
 static struct s5p_mfc_hw_ops *s5p_mfc_ops;
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
 {
-	s5p_mfc_ops = s5p_mfc_init_hw_ops_v5();
-	dev->warn_start = S5P_FIMV_ERR_WARNINGS_START;
+	if (IS_MFCV6(dev)) {
+		s5p_mfc_ops = s5p_mfc_init_hw_ops_v6();
+		dev->warn_start = S5P_FIMV_ERR_WARNINGS_START_V6;
+	} else {
+		s5p_mfc_ops = s5p_mfc_init_hw_ops_v5();
+		dev->warn_start = S5P_FIMV_ERR_WARNINGS_START;
+	}
 	dev->mfc_ops = s5p_mfc_ops;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
new file mode 100644
index 0000000..50b5bee
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -0,0 +1,1956 @@
+/*
+ * drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+ *
+ * Samsung MFC (Multi Function Codec - FIMV) driver
+ * This file contains hw related functions.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#undef DEBUG
+
+#include <linux/delay.h>
+#include <linux/mm.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/firmware.h>
+#include <linux/err.h>
+#include <linux/sched.h>
+#include <linux/dma-mapping.h>
+
+#include <asm/cacheflush.h>
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_cmd.h"
+#include "s5p_mfc_intr.h"
+#include "s5p_mfc_pm.h"
+#include "s5p_mfc_debug.h"
+#include "s5p_mfc_opr.h"
+#include "s5p_mfc_opr_v6.h"
+
+/* #define S5P_MFC_DEBUG_REGWRITE  */
+#ifdef S5P_MFC_DEBUG_REGWRITE
+#undef writel
+#define writel(v, r)							\
+	do {								\
+		pr_err("MFCWRITE(%p): %08x\n", r, (unsigned int)v);	\
+	__raw_writel(v, r);						\
+	} while (0)
+#endif /* S5P_MFC_DEBUG_REGWRITE */
+
+#define READL(offset)		readl(dev->regs_base + (offset))
+#define WRITEL(data, offset)	writel((data), dev->regs_base + (offset))
+#define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
+#define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
+
+/* Allocate temporary buffers for decoding */
+int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+
+	return 0;
+}
+
+/* Release temproary buffers for decoding */
+void s5p_mfc_release_dec_desc_buffer_v6(struct s5p_mfc_ctx *ctx)
+{
+	/* NOP */
+}
+
+int s5p_mfc_get_dec_status_v6(struct s5p_mfc_dev *dev)
+{
+	/* NOP */
+	return -1;
+}
+
+/* Allocate codec buffers */
+int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int mb_width, mb_height;
+
+	mb_width = MB_WIDTH(ctx->img_width);
+	mb_height = MB_HEIGHT(ctx->img_height);
+
+	if (ctx->type == MFCINST_DECODER) {
+		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
+			  ctx->luma_size, ctx->chroma_size, ctx->mv_size);
+		mfc_debug(2, "Totals bufs: %d\n", ctx->total_dpb_count);
+	} else if (ctx->type == MFCINST_ENCODER) {
+		ctx->tmv_buffer_size = S5P_FIMV_NUM_TMV_BUFFERS_V6 *
+			ALIGN(S5P_FIMV_TMV_BUFFER_SIZE_V6(mb_width, mb_height),
+			S5P_FIMV_TMV_BUFFER_ALIGN_V6);
+		ctx->luma_dpb_size = ALIGN((mb_width * mb_height) *
+				S5P_FIMV_LUMA_MB_TO_PIXEL_V6,
+				S5P_FIMV_LUMA_DPB_BUFFER_ALIGN_V6);
+		ctx->chroma_dpb_size = ALIGN((mb_width * mb_height) *
+				S5P_FIMV_CHROMA_MB_TO_PIXEL_V6,
+				S5P_FIMV_CHROMA_DPB_BUFFER_ALIGN_V6);
+		ctx->me_buffer_size = ALIGN(S5P_FIMV_ME_BUFFER_SIZE_V6(
+					ctx->img_width, ctx->img_height,
+					mb_width, mb_height),
+					S5P_FIMV_ME_BUFFER_ALIGN_V6);
+
+		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
+			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
+	} else {
+		return -EINVAL;
+	}
+
+	/* Codecs have different memory requirements */
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+	case S5P_MFC_CODEC_H264_MVC_DEC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size =
+			ctx->scratch_buf_size +
+			(ctx->mv_count * ctx->mv_size);
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_DEC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+	case S5P_MFC_CODEC_VC1_DEC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_VC1_DEC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_MFC_CODEC_MPEG2_DEC:
+		ctx->bank1_size = 0;
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_H263_DEC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_H263_DEC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_MFC_CODEC_VP8_DEC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size = ctx->scratch_buf_size;
+		break;
+	case S5P_MFC_CODEC_H264_ENC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_H264_ENC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->dpb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2_size = 0;
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+	case S5P_MFC_CODEC_H263_ENC:
+		ctx->scratch_buf_size =
+			S5P_FIMV_SCRATCH_BUF_SIZE_MPEG4_ENC_V6(
+					mb_width,
+					mb_height);
+		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
+				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
+		ctx->bank1_size =
+			ctx->scratch_buf_size + ctx->tmv_buffer_size +
+			(ctx->dpb_count * (ctx->luma_dpb_size +
+			ctx->chroma_dpb_size + ctx->me_buffer_size));
+		ctx->bank2_size = 0;
+		break;
+	default:
+		break;
+	}
+
+	/* Allocate only if memory from bank 1 is necessary */
+	if (ctx->bank1_size > 0) {
+		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
+		if (IS_ERR(ctx->bank1_buf)) {
+			ctx->bank1_buf = 0;
+			pr_err("Buf alloc for decoding failed (port A)\n");
+			return -ENOMEM;
+		}
+		ctx->bank1_phys = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
+		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+	}
+
+	return 0;
+}
+
+/* Release buffers allocated for codec */
+void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
+{
+	if (ctx->bank1_buf) {
+		vb2_dma_contig_memops.put(ctx->bank1_buf);
+		ctx->bank1_buf = 0;
+		ctx->bank1_phys = 0;
+		ctx->bank1_size = 0;
+	}
+}
+
+/* Allocate memory for instance data buffer */
+int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+
+	mfc_debug_enter();
+
+	switch (ctx->codec_mode) {
+	case S5P_MFC_CODEC_H264_DEC:
+	case S5P_MFC_CODEC_H264_MVC_DEC:
+		ctx->ctx.size = buf_size->h264_dec_ctx;
+		break;
+	case S5P_MFC_CODEC_MPEG4_DEC:
+	case S5P_MFC_CODEC_H263_DEC:
+	case S5P_MFC_CODEC_VC1RCV_DEC:
+	case S5P_MFC_CODEC_VC1_DEC:
+	case S5P_MFC_CODEC_MPEG2_DEC:
+	case S5P_MFC_CODEC_VP8_DEC:
+		ctx->ctx.size = buf_size->other_dec_ctx;
+		break;
+	case S5P_MFC_CODEC_H264_ENC:
+		ctx->ctx.size = buf_size->h264_enc_ctx;
+		break;
+	case S5P_MFC_CODEC_MPEG4_ENC:
+	case S5P_MFC_CODEC_H263_ENC:
+		ctx->ctx.size = buf_size->other_enc_ctx;
+		break;
+	default:
+		ctx->ctx.size = 0;
+		mfc_err("Codec type(%d) should be checked!\n", ctx->codec_mode);
+		break;
+	}
+
+	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
+	if (IS_ERR(ctx->ctx.alloc)) {
+		mfc_err("Allocating context buffer failed.\n");
+		return PTR_ERR(ctx->ctx.alloc);
+	}
+
+	ctx->ctx.dma = s5p_mfc_mem_cookie(
+		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
+
+	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
+	if (!ctx->ctx.virt) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.dma = 0;
+		ctx->ctx.virt = NULL;
+
+		mfc_err("Remapping context buffer failed.\n");
+		return -ENOMEM;
+	}
+
+	memset(ctx->ctx.virt, 0, ctx->ctx.size);
+	wmb();
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Release instance buffer */
+void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
+{
+	mfc_debug_enter();
+
+	if (ctx->ctx.alloc) {
+		vb2_dma_contig_memops.put(ctx->ctx.alloc);
+		ctx->ctx.alloc = NULL;
+		ctx->ctx.dma = 0;
+		ctx->ctx.virt = NULL;
+	}
+
+	mfc_debug_leave();
+}
+
+/* Allocate context buffers for SYS_INIT */
+int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+
+	mfc_debug_enter();
+
+	dev->ctx_buf.alloc = vb2_dma_contig_memops.alloc(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], buf_size->dev_ctx);
+	if (IS_ERR(dev->ctx_buf.alloc)) {
+		mfc_err("Allocating DESC buffer failed.\n");
+		return PTR_ERR(dev->ctx_buf.alloc);
+	}
+
+	dev->ctx_buf.dma = s5p_mfc_mem_cookie(
+			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
+			dev->ctx_buf.alloc);
+
+	dev->ctx_buf.virt = vb2_dma_contig_memops.vaddr(dev->ctx_buf.alloc);
+	if (!dev->ctx_buf.virt) {
+		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
+		dev->ctx_buf.alloc = NULL;
+		dev->ctx_buf.dma = 0;
+
+		mfc_err("Remapping DESC buffer failed.\n");
+		return -ENOMEM;
+	}
+
+	memset(dev->ctx_buf.virt, 0, buf_size->dev_ctx);
+	wmb();
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Release context buffers for SYS_INIT */
+void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
+{
+	if (dev->ctx_buf.alloc) {
+		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
+		dev->ctx_buf.alloc = NULL;
+		dev->ctx_buf.dma = 0;
+		dev->ctx_buf.virt = NULL;
+	}
+}
+
+static int calc_plane(int width, int height)
+{
+	int mbX, mbY;
+
+	mbX = DIV_ROUND_UP(width, S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6);
+	mbY = DIV_ROUND_UP(height, S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6);
+
+	if (width * height < S5P_FIMV_MAX_FRAME_SIZE_V6)
+		mbY = (mbY + 1) / 2 * 2;
+
+	return (mbX * S5P_FIMV_NUM_PIXELS_IN_MB_COL_V6) *
+		(mbY * S5P_FIMV_NUM_PIXELS_IN_MB_ROW_V6);
+}
+
+void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
+{
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN_V6);
+	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN_V6);
+	mfc_debug(2, "SEQ Done: Movie dimensions %dx%d,\n"
+			"buffer dimensions: %dx%d\n", ctx->img_width,
+			ctx->img_height, ctx->buf_width, ctx->buf_height);
+
+	ctx->luma_size = calc_plane(ctx->img_width, ctx->img_height);
+	ctx->chroma_size = calc_plane(ctx->img_width, (ctx->img_height >> 1));
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
+		ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
+				ctx->img_height);
+		ctx->mv_size = ALIGN(ctx->mv_size, 16);
+	} else {
+		ctx->mv_size = 0;
+	}
+}
+
+void s5p_mfc_enc_calc_src_size_v6(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int mb_width, mb_height;
+
+	mb_width = MB_WIDTH(ctx->img_width);
+	mb_height = MB_HEIGHT(ctx->img_height);
+
+	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12M_HALIGN_V6);
+	ctx->luma_size = ALIGN((mb_width * mb_height) * 256, 256);
+	ctx->chroma_size = ALIGN((mb_width * mb_height) * 128, 256);
+}
+
+/* Set registers for decoding stream buffer */
+int s5p_mfc_set_dec_stream_buffer_v6(struct s5p_mfc_ctx *ctx, int buf_addr,
+		  unsigned int start_num_byte, unsigned int strm_size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;
+
+	mfc_debug_enter();
+	mfc_debug(2, "inst_no: %d, buf_addr: 0x%08x,\n"
+		"buf_size: 0x%08x (%d)\n",
+		ctx->inst_no, buf_addr, strm_size, strm_size);
+	WRITEL(strm_size, S5P_FIMV_D_STREAM_DATA_SIZE_V6);
+	WRITEL(buf_addr, S5P_FIMV_D_CPB_BUFFER_ADDR_V6);
+	WRITEL(buf_size->cpb, S5P_FIMV_D_CPB_BUFFER_SIZE_V6);
+	WRITEL(start_num_byte, S5P_FIMV_D_CPB_BUFFER_OFFSET_V6);
+
+	mfc_debug_leave();
+	return 0;
+}
+
+/* Set decoding frame buffer */
+int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
+{
+	unsigned int frame_size, i;
+	unsigned int frame_size_ch, frame_size_mv;
+	struct s5p_mfc_dev *dev = ctx->dev;
+	size_t buf_addr1;
+	int buf_size1;
+	int align_gap;
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+
+	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
+	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
+	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
+
+	WRITEL(ctx->total_dpb_count, S5P_FIMV_D_NUM_DPB_V6);
+	WRITEL(ctx->luma_size, S5P_FIMV_D_LUMA_DPB_SIZE_V6);
+	WRITEL(ctx->chroma_size, S5P_FIMV_D_CHROMA_DPB_SIZE_V6);
+
+	WRITEL(buf_addr1, S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V6);
+	WRITEL(ctx->scratch_buf_size, S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V6);
+	buf_addr1 += ctx->scratch_buf_size;
+	buf_size1 -= ctx->scratch_buf_size;
+
+	if (ctx->codec_mode == S5P_FIMV_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_FIMV_CODEC_H264_MVC_DEC){
+		WRITEL(ctx->mv_size, S5P_FIMV_D_MV_BUFFER_SIZE_V6);
+		WRITEL(ctx->mv_count, S5P_FIMV_D_NUM_MV_V6);
+	}
+
+	frame_size = ctx->luma_size;
+	frame_size_ch = ctx->chroma_size;
+	frame_size_mv = ctx->mv_size;
+	mfc_debug(2, "Frame size: %d ch: %d mv: %d\n",
+			frame_size, frame_size_ch, frame_size_mv);
+
+	for (i = 0; i < ctx->total_dpb_count; i++) {
+		/* Bank2 */
+		mfc_debug(2, "Luma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.luma);
+		WRITEL(ctx->dst_bufs[i].cookie.raw.luma,
+				S5P_FIMV_D_LUMA_DPB_V6 + i * 4);
+		mfc_debug(2, "\tChroma %d: %x\n", i,
+					ctx->dst_bufs[i].cookie.raw.chroma);
+		WRITEL(ctx->dst_bufs[i].cookie.raw.chroma,
+				S5P_FIMV_D_CHROMA_DPB_V6 + i * 4);
+	}
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
+			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
+		for (i = 0; i < ctx->mv_count; i++) {
+			/* To test alignment */
+			align_gap = buf_addr1;
+			buf_addr1 = ALIGN(buf_addr1, 16);
+			align_gap = buf_addr1 - align_gap;
+			buf_size1 -= align_gap;
+
+			mfc_debug(2, "\tBuf1: %x, size: %d\n",
+					buf_addr1, buf_size1);
+			WRITEL(buf_addr1, S5P_FIMV_D_MV_BUFFER_V6 + i * 4);
+			buf_addr1 += frame_size_mv;
+			buf_size1 -= frame_size_mv;
+		}
+	}
+
+	mfc_debug(2, "Buf1: %u, buf_size1: %d (frames %d)\n",
+			buf_addr1, buf_size1, ctx->total_dpb_count);
+	if (buf_size1 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
+
+	mfc_debug(2, "After setting buffers.\n");
+	return 0;
+}
+
+/* Set registers for encoding stream buffer */
+int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
+		unsigned long addr, unsigned int size)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(addr, S5P_FIMV_E_STREAM_BUFFER_ADDR_V6); /* 16B align */
+	WRITEL(size, S5P_FIMV_E_STREAM_BUFFER_SIZE_V6);
+
+	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d",
+		addr, size);
+
+	return 0;
+}
+
+void s5p_mfc_set_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
+		unsigned long y_addr, unsigned long c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6); /* 256B align */
+	WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
+
+	mfc_debug(2, "enc src y buf addr: 0x%08lx", y_addr);
+	mfc_debug(2, "enc src c buf addr: 0x%08lx", c_addr);
+}
+
+void s5p_mfc_get_enc_frame_buffer_v6(struct s5p_mfc_ctx *ctx,
+		unsigned long *y_addr, unsigned long *c_addr)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long enc_recon_y_addr, enc_recon_c_addr;
+
+	*y_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_LUMA_ADDR_V6);
+	*c_addr = READL(S5P_FIMV_E_ENCODED_SOURCE_CHROMA_ADDR_V6);
+
+	enc_recon_y_addr = READL(S5P_FIMV_E_RECON_LUMA_DPB_ADDR_V6);
+	enc_recon_c_addr = READL(S5P_FIMV_E_RECON_CHROMA_DPB_ADDR_V6);
+
+	mfc_debug(2, "recon y addr: 0x%08lx", enc_recon_y_addr);
+	mfc_debug(2, "recon c addr: 0x%08lx", enc_recon_c_addr);
+}
+
+/* Set encoding ref & codec buffer */
+int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	size_t buf_addr1, buf_size1;
+	int i;
+
+	mfc_debug_enter();
+
+	buf_addr1 = ctx->bank1_phys;
+	buf_size1 = ctx->bank1_size;
+
+	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
+
+	for (i = 0; i < ctx->dpb_count; i++) {
+		WRITEL(buf_addr1, S5P_FIMV_E_LUMA_DPB_V6 + (4 * i));
+		buf_addr1 += ctx->luma_dpb_size;
+		WRITEL(buf_addr1, S5P_FIMV_E_CHROMA_DPB_V6 + (4 * i));
+		buf_addr1 += ctx->chroma_dpb_size;
+		WRITEL(buf_addr1, S5P_FIMV_E_ME_BUFFER_V6 + (4 * i));
+		buf_addr1 += ctx->me_buffer_size;
+		buf_size1 -= (ctx->luma_dpb_size + ctx->chroma_dpb_size +
+			ctx->me_buffer_size);
+	}
+
+	WRITEL(buf_addr1, S5P_FIMV_E_SCRATCH_BUFFER_ADDR_V6);
+	WRITEL(ctx->scratch_buf_size, S5P_FIMV_E_SCRATCH_BUFFER_SIZE_V6);
+	buf_addr1 += ctx->scratch_buf_size;
+	buf_size1 -= ctx->scratch_buf_size;
+
+	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER0_V6);
+	buf_addr1 += ctx->tmv_buffer_size >> 1;
+	WRITEL(buf_addr1, S5P_FIMV_E_TMV_BUFFER1_V6);
+	buf_addr1 += ctx->tmv_buffer_size >> 1;
+	buf_size1 -= ctx->tmv_buffer_size;
+
+	mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
+			buf_addr1, buf_size1, ctx->dpb_count);
+	if (buf_size1 < 0) {
+		mfc_debug(2, "Not enough memory has been allocated.\n");
+		return -ENOMEM;
+	}
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+			S5P_FIMV_CH_INIT_BUFS_V6, NULL);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_slice_mode(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	WRITEL(ctx->slice_mode, S5P_FIMV_E_MSLICE_MODE_V6);
+	if (ctx->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
+		WRITEL(ctx->slice_size.mb, S5P_FIMV_E_MSLICE_SIZE_MB_V6);
+	} else if (ctx->slice_mode ==
+			V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
+		WRITEL(ctx->slice_size.bits, S5P_FIMV_E_MSLICE_SIZE_BITS_V6);
+	} else {
+		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_MB_V6);
+		WRITEL(0x0, S5P_FIMV_E_MSLICE_SIZE_BITS_V6);
+	}
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	/* width */
+	WRITEL(ctx->img_width, S5P_FIMV_E_FRAME_WIDTH_V6); /* 16 align */
+	/* height */
+	WRITEL(ctx->img_height, S5P_FIMV_E_FRAME_HEIGHT_V6); /* 16 align */
+
+	/* cropped width */
+	WRITEL(ctx->img_width, S5P_FIMV_E_CROPPED_FRAME_WIDTH_V6);
+	/* cropped height */
+	WRITEL(ctx->img_height, S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+	/* cropped offset */
+	WRITEL(0x0, S5P_FIMV_E_FRAME_CROP_OFFSET_V6);
+
+	/* pictype : IDR period */
+	reg = 0;
+	reg |= p->gop_size & 0xFFFF;
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+
+	/* multi-slice control */
+	/* multi-slice MB number or bit size */
+	ctx->slice_mode = p->slice_mode;
+	reg = 0;
+	if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB) {
+		reg |= (0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		ctx->slice_size.mb = p->slice_mb;
+	} else if (p->slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES) {
+		reg |= (0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		ctx->slice_size.bits = p->slice_bit;
+	} else {
+		reg &= ~(0x1 << 3);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+	}
+
+	s5p_mfc_set_slice_mode(ctx);
+
+	/* cyclic intra refresh */
+	WRITEL(p->intra_refresh_mb, S5P_FIMV_E_IR_SIZE_V6);
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	if (p->intra_refresh_mb == 0)
+		reg &= ~(0x1 << 4);
+	else
+		reg |= (0x1 << 4);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+
+	/* 'NON_REFERENCE_STORE_ENABLE' for debugging */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg &= ~(0x1 << 9);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+
+	/* memory structure cur. frame */
+	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg &= ~(0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV21M) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg &= ~(0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT_V6);
+	} else if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16) {
+		/* 0: Linear, 1: 2D tiled*/
+		reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+		reg |= (0x1 << 7);
+		WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+		/* 0: NV12(CbCr), 1: NV21(CrCb) */
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+	}
+
+	/* memory structure recon. frame */
+	/* 0: Linear, 1: 2D tiled */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg |= (0x1 << 8);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+
+	/* padding control & value */
+	WRITEL(0x0, S5P_FIMV_E_PADDING_CTRL_V6);
+	if (p->pad) {
+		reg = 0;
+		/** enable */
+		reg |= (1 << 31);
+		/** cr value */
+		reg |= ((p->pad_cr & 0xFF) << 16);
+		/** cb value */
+		reg |= ((p->pad_cb & 0xFF) << 8);
+		/** y value */
+		reg |= p->pad_luma & 0xFF;
+		WRITEL(reg, S5P_FIMV_E_PADDING_CTRL_V6);
+	}
+
+	/* rate control config. */
+	reg = 0;
+	/* frame-level rate control */
+	reg |= ((p->rc_frame & 0x1) << 9);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* bit rate */
+	if (p->rc_frame)
+		WRITEL(p->rc_bitrate,
+			S5P_FIMV_E_RC_BIT_RATE_V6);
+	else
+		WRITEL(1, S5P_FIMV_E_RC_BIT_RATE_V6);
+
+	/* reaction coefficient */
+	if (p->rc_frame) {
+		if (p->rc_reaction_coeff < TIGHT_CBR_MAX) /* tight CBR */
+			WRITEL(1, S5P_FIMV_E_RC_RPARAM_V6);
+		else					  /* loose CBR */
+			WRITEL(2, S5P_FIMV_E_RC_RPARAM_V6);
+	}
+
+	/* seq header ctrl */
+	reg = READL(S5P_FIMV_E_ENC_OPTIONS_V6);
+	reg &= ~(0x1 << 2);
+	reg |= ((p->seq_hdr_mode & 0x1) << 2);
+
+	/* frame skip mode */
+	reg &= ~(0x3);
+	reg |= (p->frame_skip_mode & 0x3);
+	WRITEL(reg, S5P_FIMV_E_ENC_OPTIONS_V6);
+
+	/* 'DROP_CONTROL_ENABLE', disable */
+	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	reg &= ~(0x1 << 10);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* setting for MV range [16, 256] */
+	reg = 0;
+	reg &= ~(0x3FFF);
+	reg = 256;
+	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
+
+	reg = 0;
+	reg &= ~(0x3FFF);
+	reg = 256;
+	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
+
+	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
+	WRITEL(0x0, S5P_FIMV_E_ROI_BUFFER_ADDR_V6);
+	WRITEL(0x0, S5P_FIMV_E_PARAM_CHANGE_V6);
+	WRITEL(0x0, S5P_FIMV_E_RC_ROI_CTRL_V6);
+	WRITEL(0x0, S5P_FIMV_E_PICTURE_TAG_V6);
+
+	WRITEL(0x0, S5P_FIMV_E_BIT_COUNT_ENABLE_V6);
+	WRITEL(0x0, S5P_FIMV_E_MAX_BIT_COUNT_V6);
+	WRITEL(0x0, S5P_FIMV_E_MIN_BIT_COUNT_V6);
+
+	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_ADDR_V6);
+	WRITEL(0x0, S5P_FIMV_E_METADATA_BUFFER_SIZE_V6);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
+	unsigned int reg = 0;
+	int i;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg &= ~(0x3 << 16);
+	reg |= ((p->num_b_frame & 0x3) << 16);
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+
+	/* profile & level */
+	reg = 0;
+	/** level */
+	reg |= ((p_h264->level & 0xFF) << 8);
+	/** profile - 0 ~ 3 */
+	reg |= p_h264->profile & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h264->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_h264->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_h264->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_h264->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_h264->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_h264->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p_h264->cpb_size & 0xFFFF,
+				S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+	}
+
+	/* interlace */
+	reg = 0;
+	reg |= ((p_h264->interlace & 0x1) << 3);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* height */
+	if (p_h264->interlace) {
+		WRITEL(ctx->img_height >> 1,
+				S5P_FIMV_E_FRAME_HEIGHT_V6); /* 32 align */
+		/* cropped height */
+		WRITEL(ctx->img_height >> 1,
+				S5P_FIMV_E_CROPPED_FRAME_HEIGHT_V6);
+	}
+
+	/* loop filter ctrl */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x3 << 1);
+	reg |= ((p_h264->loop_filter_mode & 0x3) << 1);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* loopfilter alpha offset */
+	if (p_h264->loop_filter_alpha < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_h264->loop_filter_alpha) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_h264->loop_filter_alpha & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_E_H264_LF_ALPHA_OFFSET_V6);
+
+	/* loopfilter beta offset */
+	if (p_h264->loop_filter_beta < 0) {
+		reg = 0x10;
+		reg |= (0xFF - p_h264->loop_filter_beta) + 1;
+	} else {
+		reg = 0x00;
+		reg |= (p_h264->loop_filter_beta & 0xF);
+	}
+	WRITEL(reg, S5P_FIMV_E_H264_LF_BETA_OFFSET_V6);
+
+	/* entropy coding mode */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1);
+	reg |= p_h264->entropy_mode & 0x1;
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* number of ref. picture */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 7);
+	reg |= (((p_h264->num_ref_pic_4p - 1) & 0x1) << 7);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* 8x8 transform enable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x3 << 12);
+	reg |= ((p_h264->_8x8_transform & 0x3) << 12);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* macroblock adaptive scaling features */
+	WRITEL(0x0, S5P_FIMV_E_MB_RC_CONFIG_V6);
+	if (p->rc_mb) {
+		reg = 0;
+		/** dark region */
+		reg |= ((p_h264->rc_mb_dark & 0x1) << 3);
+		/** smooth region */
+		reg |= ((p_h264->rc_mb_smooth & 0x1) << 2);
+		/** static region */
+		reg |= ((p_h264->rc_mb_static & 0x1) << 1);
+		/** high activity region */
+		reg |= p_h264->rc_mb_activity & 0x1;
+		WRITEL(reg, S5P_FIMV_E_MB_RC_CONFIG_V6);
+	}
+
+	/* aspect ratio VUI */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 5);
+	reg |= ((p_h264->vui_sar & 0x1) << 5);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	WRITEL(0x0, S5P_FIMV_E_ASPECT_RATIO_V6);
+	WRITEL(0x0, S5P_FIMV_E_EXTENDED_SAR_V6);
+	if (p_h264->vui_sar) {
+		/* aspect ration IDC */
+		reg = 0;
+		reg |= p_h264->vui_sar_idc & 0xFF;
+		WRITEL(reg, S5P_FIMV_E_ASPECT_RATIO_V6);
+		if (p_h264->vui_sar_idc == 0xFF) {
+			/* extended SAR */
+			reg = 0;
+			reg |= (p_h264->vui_ext_sar_width & 0xFFFF) << 16;
+			reg |= p_h264->vui_ext_sar_height & 0xFFFF;
+			WRITEL(reg, S5P_FIMV_E_EXTENDED_SAR_V6);
+		}
+	}
+
+	/* intra picture period for H.264 open GOP */
+	/* control */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 4);
+	reg |= ((p_h264->open_gop & 0x1) << 4);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	/* value */
+	WRITEL(0x0, S5P_FIMV_E_H264_I_PERIOD_V6);
+	if (p_h264->open_gop) {
+		reg = 0;
+		reg |= p_h264->open_gop_size & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_H264_I_PERIOD_V6);
+	}
+
+	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x3 << 9);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 14);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* ASO */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 6);
+	reg |= ((p_h264->aso & 0x1) << 6);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+
+	/* hier qp enable */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 8);
+	reg |= ((p_h264->open_gop & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	reg = 0;
+	if (p_h264->hier_qp && p_h264->hier_qp_layer) {
+		reg |= (p_h264->hier_qp_type & 0x1) << 0x3;
+		reg |= p_h264->hier_qp_layer & 0x7;
+		WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER_V6);
+		/* QP value for each layer */
+		for (i = 0; i < (p_h264->hier_qp_layer & 0x7); i++)
+			WRITEL(p_h264->hier_qp_layer_qp[i],
+				S5P_FIMV_E_H264_HIERARCHICAL_QP_LAYER0_V6 +
+				i * 4);
+	}
+	/* number of coding layer should be zero when hierarchical is disable */
+	WRITEL(reg, S5P_FIMV_E_H264_NUM_T_LAYER_V6);
+
+	/* frame packing SEI generation */
+	reg = READL(S5P_FIMV_E_H264_OPTIONS_V6);
+	reg &= ~(0x1 << 25);
+	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
+	WRITEL(reg, S5P_FIMV_E_H264_OPTIONS_V6);
+	if (p_h264->sei_frame_packing) {
+		reg = 0;
+		/** current frame0 flag */
+		reg |= ((p_h264->sei_fp_curr_frame_0 & 0x1) << 2);
+		/** arrangement type */
+		reg |= p_h264->sei_fp_arrangement_type & 0x3;
+		WRITEL(reg, S5P_FIMV_E_H264_FRAME_PACKING_SEI_INFO_V6);
+	}
+
+	if (p_h264->fmo) {
+		switch (p_h264->fmo_map_type) {
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_INTERLEAVED_SLICES:
+			if (p_h264->fmo_slice_grp > 4)
+				p_h264->fmo_slice_grp = 4;
+			for (i = 0; i < (p_h264->fmo_slice_grp & 0xF); i++)
+				WRITEL(p_h264->fmo_run_len[i] - 1,
+				S5P_FIMV_E_H264_FMO_RUN_LENGTH_MINUS1_0_V6 +
+				i * 4);
+			break;
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_SCATTERED_SLICES:
+			if (p_h264->fmo_slice_grp > 4)
+				p_h264->fmo_slice_grp = 4;
+			break;
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_RASTER_SCAN:
+		case V4L2_MPEG_VIDEO_H264_FMO_MAP_TYPE_WIPE_SCAN:
+			if (p_h264->fmo_slice_grp > 2)
+				p_h264->fmo_slice_grp = 2;
+			WRITEL(p_h264->fmo_chg_dir & 0x1,
+				S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_DIR_V6);
+			/* the valid range is 0 ~ number of macroblocks -1 */
+			WRITEL(p_h264->fmo_chg_rate,
+				S5P_FIMV_E_H264_FMO_SLICE_GRP_CHANGE_RATE_MINUS1_V6);
+			break;
+		default:
+			mfc_err("Unsupported map type for FMO: %d\n",
+					p_h264->fmo_map_type);
+			p_h264->fmo_map_type = 0;
+			p_h264->fmo_slice_grp = 1;
+			break;
+		}
+
+		WRITEL(p_h264->fmo_map_type,
+				S5P_FIMV_E_H264_FMO_SLICE_GRP_MAP_TYPE_V6);
+		WRITEL(p_h264->fmo_slice_grp - 1,
+				S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6);
+	} else {
+		WRITEL(0, S5P_FIMV_E_H264_FMO_NUM_SLICE_GRP_MINUS1_V6);
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_mpeg4(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* pictype : number of B */
+	reg = READL(S5P_FIMV_E_GOP_CONFIG_V6);
+	reg &= ~(0x3 << 16);
+	reg |= ((p->num_b_frame & 0x3) << 16);
+	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
+
+	/* profile & level */
+	reg = 0;
+	/** level */
+	reg |= ((p_mpeg4->level & 0xFF) << 8);
+	/** profile - 0 ~ 1 */
+	reg |= p_mpeg4->profile & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_mpeg4->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_mpeg4->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_mpeg4->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_mpeg4->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_mpeg4->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_mpeg4->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+	}
+
+	/* Disable HEC */
+	WRITEL(0x0, S5P_FIMV_E_MPEG4_OPTIONS_V6);
+	WRITEL(0x0, S5P_FIMV_E_MPEG4_HEC_PERIOD_V6);
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_mpeg4_enc_params *p_h263 = &p->codec.mpeg4;
+	unsigned int reg = 0;
+
+	mfc_debug_enter();
+
+	s5p_mfc_set_enc_params(ctx);
+
+	/* profile & level */
+	reg = 0;
+	/** profile */
+	reg |= (0x1 << 4);
+	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
+
+	/* rate control config. */
+	reg = READL(S5P_FIMV_E_RC_CONFIG_V6);
+	/** macroblock level rate control */
+	reg &= ~(0x1 << 8);
+	reg |= ((p->rc_mb & 0x1) << 8);
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+	/** frame QP */
+	reg &= ~(0x3F);
+	reg |= p_h263->rc_frame_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* max & min value of QP */
+	reg = 0;
+	/** max QP */
+	reg |= ((p_h263->rc_max_qp & 0x3F) << 8);
+	/** min QP */
+	reg |= p_h263->rc_min_qp & 0x3F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_h263->rc_b_frame_qp & 0x3F) << 16);
+		reg |= ((p_h263->rc_p_frame_qp & 0x3F) << 8);
+		reg |= p_h263->rc_frame_qp & 0x3F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	}
+
+	/* frame rate */
+	if (p->rc_frame && p->rc_framerate_num && p->rc_framerate_denom) {
+		reg = 0;
+		reg |= ((p->rc_framerate_num & 0xFFFF) << 16);
+		reg |= p->rc_framerate_denom & 0xFFFF;
+		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
+	}
+
+	/* vbv buffer size */
+	if (p->frame_skip_mode ==
+			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
+		WRITEL(p->vbv_size & 0xFFFF, S5P_FIMV_E_VBV_BUFFER_SIZE_V6);
+
+		if (p->rc_frame)
+			WRITEL(p->vbv_delay, S5P_FIMV_E_VBV_INIT_DELAY_V6);
+	}
+
+	mfc_debug_leave();
+
+	return 0;
+}
+
+/* Initialize decoding */
+int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int reg = 0;
+	int fmo_aso_ctrl = 0;
+
+	mfc_debug_enter();
+	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no,
+			S5P_FIMV_CH_SEQ_HEADER_V6);
+	mfc_debug(2, "BUFs: %08x %08x %08x\n",
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6),
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6),
+		  READL(S5P_FIMV_D_CPB_BUFFER_ADDR_V6));
+
+	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
+	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6);
+
+	/* When user sets desplay_delay to 0,
+	 * It works as "display_delay enable" and delay set to 0.
+	 * If user wants display_delay disable, It should be
+	 * set to negative value. */
+	if (ctx->display_delay >= 0) {
+		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
+		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
+	}
+	/* Setup loop filter, for decoding this is only valid for MPEG4 */
+	if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC) {
+		mfc_debug(2, "Set loop filter to: %d\n",
+				ctx->loop_filter_mpeg4);
+		reg |= (ctx->loop_filter_mpeg4 <<
+				S5P_FIMV_D_OPT_LF_CTRL_SHIFT_V6);
+	}
+	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
+		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
+
+	WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+
+	/* 0: NV12(CbCr), 1: NV21(CrCb) */
+	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
+		WRITEL(0x1, S5P_FIMV_PIXEL_FORMAT_V6);
+	else
+		WRITEL(0x0, S5P_FIMV_PIXEL_FORMAT_V6);
+
+	/* sei parse */
+	WRITEL(ctx->sei_fp_parse & 0x1, S5P_FIMV_D_SEI_ENABLE_V6);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
+
+	mfc_debug_leave();
+	return 0;
+}
+
+static inline void s5p_mfc_set_flush(struct s5p_mfc_ctx *ctx, int flush)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int dpb;
+	if (flush)
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) | (1 << 14);
+	else
+		dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~(1 << 14);
+	WRITEL(dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+}
+
+/* Decode a single frame */
+int s5p_mfc_decode_one_frame_v6(struct s5p_mfc_ctx *ctx,
+			enum s5p_mfc_decode_arg last_frame)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	WRITEL(ctx->dec_dst_flag, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V6);
+	WRITEL(ctx->slice_interface & 0x1, S5P_FIMV_D_SLICE_IF_ENABLE_V6);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	/* Issue different commands to instance basing on whether it
+	 * is the last frame or not. */
+	switch (last_frame) {
+	case 0:
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+				S5P_FIMV_CH_FRAME_START_V6, NULL);
+		break;
+	case 1:
+		s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+				S5P_FIMV_CH_LAST_FRAME_V6, NULL);
+		break;
+	default:
+		mfc_err("Unsupported last frame arg.\n");
+		return -EINVAL;
+	}
+
+	mfc_debug(2, "Decoding a usual frame.\n");
+	return 0;
+}
+
+int s5p_mfc_init_encode_v6(struct s5p_mfc_ctx *ctx)
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
+		mfc_err("Unknown codec for encoding (%x).\n",
+			ctx->codec_mode);
+		return -EINVAL;
+	}
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+			S5P_FIMV_CH_SEQ_HEADER_V6, NULL);
+
+	return 0;
+}
+
+int s5p_mfc_h264_set_aso_slice_order_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_enc_params *p = &ctx->enc_params;
+	struct s5p_mfc_h264_enc_params *p_h264 = &p->codec.h264;
+	int i;
+
+	if (p_h264->aso) {
+		for (i = 0; i < 8; i++)
+			WRITEL(p_h264->aso_slice_order[i],
+				S5P_FIMV_E_H264_ASO_SLICE_ORDER_0_V6 + i * 4);
+	}
+	return 0;
+}
+
+/* Encode a single frame */
+int s5p_mfc_encode_one_frame_v6(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug(2, "++\n");
+
+	/* memory structure cur. frame */
+
+	if (ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
+		s5p_mfc_h264_set_aso_slice_order_v6(ctx);
+
+	s5p_mfc_set_slice_mode(ctx);
+
+	WRITEL(ctx->inst_no, S5P_FIMV_INSTANCE_ID_V6);
+	s5p_mfc_hw_call(dev->mfc_cmds, cmd_host2risc, dev,
+			S5P_FIMV_CH_FRAME_START_V6, NULL);
+
+	mfc_debug(2, "--\n");
+
+	return 0;
+}
+
+static inline int s5p_mfc_get_new_ctx(struct s5p_mfc_dev *dev)
+{
+	unsigned long flags;
+	int new_ctx;
+	int cnt;
+
+	spin_lock_irqsave(&dev->condlock, flags);
+	mfc_debug(2, "Previos context: %d (bits %08lx)\n", dev->curr_ctx,
+							dev->ctx_work_bits);
+	new_ctx = (dev->curr_ctx + 1) % MFC_NUM_CONTEXTS;
+	cnt = 0;
+	while (!test_bit(new_ctx, &dev->ctx_work_bits)) {
+		new_ctx = (new_ctx + 1) % MFC_NUM_CONTEXTS;
+		cnt++;
+		if (cnt > MFC_NUM_CONTEXTS) {
+			/* No contexts to run */
+			spin_unlock_irqrestore(&dev->condlock, flags);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock_irqrestore(&dev->condlock, flags);
+	return new_ctx;
+}
+
+static inline void s5p_mfc_run_dec_last_frames(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "No src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	temp_vb->flags |= MFC_BUF_FLAG_USED;
+	s5p_mfc_set_dec_stream_buffer_v6(ctx,
+			vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0, 0);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_decode_one_frame_v6(ctx, 1);
+}
+
+static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *temp_vb;
+	unsigned long flags;
+	int last_frame = 0;
+	unsigned int index;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* Frames are being decoded */
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "No src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+	/* Get the next source buffer */
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	temp_vb->flags |= MFC_BUF_FLAG_USED;
+	s5p_mfc_set_dec_stream_buffer_v6(ctx,
+		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0),
+			ctx->consumed_stream,
+			temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	index = temp_vb->b->v4l2_buf.index;
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	if (temp_vb->b->v4l2_planes[0].bytesused == 0) {
+		last_frame = 1;
+		mfc_debug(2, "Setting ctx->state to FINISHING\n");
+		ctx->state = MFCINST_FINISHING;
+	}
+	s5p_mfc_decode_one_frame_v6(ctx, last_frame);
+
+	return 0;
+}
+
+static inline int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	struct s5p_mfc_buf *src_mb;
+	unsigned long src_y_addr, src_c_addr, dst_addr;
+	/*
+	unsigned int src_y_size, src_c_size;
+	*/
+	unsigned int dst_size;
+	unsigned int index;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (list_empty(&ctx->src_queue)) {
+		mfc_debug(2, "no src buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	if (list_empty(&ctx->dst_queue)) {
+		mfc_debug(2, "no dst buffers.\n");
+		spin_unlock_irqrestore(&dev->irqlock, flags);
+		return -EAGAIN;
+	}
+
+	src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	src_mb->flags |= MFC_BUF_FLAG_USED;
+	src_y_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 0);
+	src_c_addr = vb2_dma_contig_plane_dma_addr(src_mb->b, 1);
+
+	mfc_debug(2, "enc src y addr: 0x%08lx", src_y_addr);
+	mfc_debug(2, "enc src c addr: 0x%08lx", src_c_addr);
+
+	s5p_mfc_set_enc_frame_buffer_v6(ctx, src_y_addr, src_c_addr);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_mb->flags |= MFC_BUF_FLAG_USED;
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+
+	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	index = src_mb->b->v4l2_buf.index;
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_encode_one_frame_v6(ctx);
+
+	return 0;
+}
+
+static inline void s5p_mfc_run_init_dec(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *temp_vb;
+
+	/* Initializing decoding - parsing header */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	mfc_debug(2, "Preparing to init decoding.\n");
+	temp_vb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf, list);
+	mfc_debug(2, "Header size: %d\n", temp_vb->b->v4l2_planes[0].bytesused);
+	s5p_mfc_set_dec_stream_buffer_v6(ctx,
+		vb2_dma_contig_plane_dma_addr(temp_vb->b, 0), 0,
+			temp_vb->b->v4l2_planes[0].bytesused);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_decode_v6(ctx);
+}
+
+static inline void s5p_mfc_run_init_enc(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned long flags;
+	struct s5p_mfc_buf *dst_mb;
+	unsigned long dst_addr;
+	unsigned int dst_size;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	dst_mb = list_entry(ctx->dst_queue.next, struct s5p_mfc_buf, list);
+	dst_addr = vb2_dma_contig_plane_dma_addr(dst_mb->b, 0);
+	dst_size = vb2_plane_size(dst_mb->b, 0);
+	s5p_mfc_set_enc_stream_buffer_v6(ctx, dst_addr, dst_size);
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	s5p_mfc_init_encode_v6(ctx);
+}
+
+static inline int s5p_mfc_run_init_dec_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+	/* Header was parsed now start processing
+	 * First set the output frame buffers
+	 * s5p_mfc_alloc_dec_buffers(ctx); */
+
+	if (ctx->capture_state != QUEUE_BUFS_MMAPED) {
+		mfc_err("It seems that not all destionation buffers were\n"
+			"mmaped.MFC requires that all destination are mmaped\n"
+			"before starting processing.\n");
+		return -EAGAIN;
+	}
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_dec_frame_buffer_v6(ctx);
+	if (ret) {
+		mfc_err("Failed to alloc frame mem.\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+static inline int s5p_mfc_run_init_enc_buffers(struct s5p_mfc_ctx *ctx)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	ret = s5p_mfc_alloc_codec_buffers_v6(ctx);
+	if (ret) {
+		mfc_err("Failed to allocate encoding buffers.\n");
+		return -ENOMEM;
+	}
+
+	/* Header was generated now starting processing
+	 * First set the reference frame buffers
+	 */
+	if (ctx->capture_state != QUEUE_BUFS_REQUESTED) {
+		mfc_err("It seems that destionation buffers were not\n"
+			"requested.MFC requires that header should be generated\n"
+			"before allocating codec buffer.\n");
+		return -EAGAIN;
+	}
+
+	dev->curr_ctx = ctx->num;
+	s5p_mfc_clean_ctx_int_flags(ctx);
+	ret = s5p_mfc_set_enc_ref_buffer_v6(ctx);
+	if (ret) {
+		mfc_err("Failed to alloc frame mem.\n");
+		ctx->state = MFCINST_ERROR;
+	}
+	return ret;
+}
+
+/* Try running an operation on hardware */
+void s5p_mfc_try_run_v6(struct s5p_mfc_dev *dev)
+{
+	struct s5p_mfc_ctx *ctx;
+	int new_ctx;
+	unsigned int ret = 0;
+
+	mfc_debug(1, "Try run dev: %p\n", dev);
+
+	/* Check whether hardware is not running */
+	if (test_and_set_bit(0, &dev->hw_lock) != 0) {
+		/* This is perfectly ok, the scheduled ctx should wait */
+		mfc_debug(1, "Couldn't lock HW.\n");
+		return;
+	}
+
+	/* Choose the context to run */
+	new_ctx = s5p_mfc_get_new_ctx(dev);
+	if (new_ctx < 0) {
+		/* No contexts to run */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0) {
+			mfc_err("Failed to unlock hardware.\n");
+			return;
+		}
+
+		mfc_debug(1, "No ctx is scheduled to be run.\n");
+		return;
+	}
+
+	mfc_debug(1, "New context: %d\n", new_ctx);
+	ctx = dev->ctx[new_ctx];
+	mfc_debug(1, "Seting new context to %p\n", ctx);
+	/* Got context to run in ctx */
+	mfc_debug(1, "ctx->dst_queue_cnt=%d ctx->dpb_count=%d ctx->src_queue_cnt=%d\n",
+		ctx->dst_queue_cnt, ctx->dpb_count, ctx->src_queue_cnt);
+	mfc_debug(1, "ctx->state=%d\n", ctx->state);
+	/* Last frame has already been sent to MFC
+	 * Now obtaining frames from MFC buffer */
+
+	s5p_mfc_clock_on();
+	if (ctx->type == MFCINST_DECODER) {
+		switch (ctx->state) {
+		case MFCINST_FINISHING:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RUNNING:
+			ret = s5p_mfc_run_dec_frame(ctx);
+			break;
+		case MFCINST_INIT:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
+					ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
+					ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_dec(ctx);
+			break;
+		case MFCINST_HEAD_PARSED:
+			ret = s5p_mfc_run_init_dec_buffers(ctx);
+			break;
+		case MFCINST_RES_CHANGE_INIT:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RES_CHANGE_FLUSH:
+			s5p_mfc_run_dec_last_frames(ctx);
+			break;
+		case MFCINST_RES_CHANGE_END:
+			mfc_debug(2, "Finished remaining frames after resolution change.\n");
+			ctx->capture_state = QUEUE_FREE;
+			mfc_debug(2, "Will re-init the codec`.\n");
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
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, open_inst_cmd,
+					ctx);
+			break;
+		case MFCINST_RETURN_INST:
+			ret = s5p_mfc_hw_call(dev->mfc_cmds, close_inst_cmd,
+					ctx);
+			break;
+		case MFCINST_GOT_INST:
+			s5p_mfc_run_init_enc(ctx);
+			break;
+		case MFCINST_HEAD_PARSED: /* Only for MFC6.x */
+			ret = s5p_mfc_run_init_enc_buffers(ctx);
+			break;
+		default:
+			ret = -EAGAIN;
+		}
+	} else {
+		mfc_err("invalid context type: %d\n", ctx->type);
+		ret = -EAGAIN;
+	}
+
+	if (ret) {
+		/* Free hardware lock */
+		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
+			mfc_err("Failed to unlock hardware.\n");
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
+void s5p_mfc_cleanup_queue_v6(struct list_head *lh, struct vb2_queue *vq)
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
+void s5p_mfc_clear_int_flags_v6(struct s5p_mfc_dev *dev)
+{
+	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_CMD_V6);
+	mfc_write(dev, 0, S5P_FIMV_RISC2HOST_INT_V6);
+}
+
+void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
+		unsigned int ofs)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	s5p_mfc_clock_on();
+	WRITEL(data, ofs);
+	s5p_mfc_clock_off();
+}
+
+unsigned int s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
+{
+	struct s5p_mfc_dev *dev = ctx->dev;
+	int ret;
+
+	s5p_mfc_clock_on();
+	ret = READL(ofs);
+	s5p_mfc_clock_off();
+
+	return ret;
+}
+
+int s5p_mfc_get_dspl_y_adr_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
+}
+
+int s5p_mfc_get_dec_y_adr_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DISPLAY_LUMA_ADDR_V6);
+}
+
+int s5p_mfc_get_dspl_status_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DISPLAY_STATUS_V6);
+}
+
+int s5p_mfc_get_decoded_status_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DECODED_STATUS_V6);
+}
+
+int s5p_mfc_get_dec_frame_type_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DECODED_FRAME_TYPE_V6) &
+		S5P_FIMV_DECODE_FRAME_MASK_V6;
+}
+
+int s5p_mfc_get_disp_frame_type_v6(struct s5p_mfc_ctx *ctx)
+{
+	return mfc_read(ctx->dev, S5P_FIMV_D_DISPLAY_FRAME_TYPE_V6) &
+		S5P_FIMV_DECODE_FRAME_MASK_V6;
+}
+
+int s5p_mfc_get_consumed_stream_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DECODED_NAL_SIZE_V6);
+}
+
+int s5p_mfc_get_int_reason_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_RISC2HOST_CMD_V6) &
+		S5P_FIMV_RISC2HOST_CMD_MASK;
+}
+
+int s5p_mfc_get_int_err_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_ERROR_CODE_V6);
+}
+
+int s5p_mfc_err_dec_v6(unsigned int err)
+{
+	return (err & S5P_FIMV_ERR_DEC_MASK_V6) >> S5P_FIMV_ERR_DEC_SHIFT_V6;
+}
+
+int s5p_mfc_err_dspl_v6(unsigned int err)
+{
+	return (err & S5P_FIMV_ERR_DSPL_MASK_V6) >> S5P_FIMV_ERR_DSPL_SHIFT_V6;
+}
+
+int s5p_mfc_get_img_width_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6);
+}
+
+int s5p_mfc_get_img_height_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V6);
+}
+
+int s5p_mfc_get_dpb_count_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_DPB_V6);
+}
+
+int s5p_mfc_get_mv_count_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_MIN_NUM_MV_V6);
+}
+
+int s5p_mfc_get_inst_no_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_RET_INSTANCE_ID_V6);
+}
+
+int s5p_mfc_get_enc_dpb_count_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_E_NUM_DPB_V6);
+}
+
+int s5p_mfc_get_enc_strm_size_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_E_STREAM_SIZE_V6);
+}
+
+int s5p_mfc_get_enc_slice_type_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_E_SLICE_TYPE_V6);
+}
+
+int s5p_mfc_get_enc_pic_count_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_E_PICTURE_COUNT_V6);
+}
+
+int s5p_mfc_get_sei_avail_status_v6(struct s5p_mfc_ctx *ctx)
+{
+	return mfc_read(ctx->dev, S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V6);
+}
+
+int s5p_mfc_get_mvc_num_views_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_MVC_NUM_VIEWS_V6);
+}
+
+int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
+{
+	return mfc_read(dev, S5P_FIMV_D_MVC_VIEW_ID_V6);
+}
+
+unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v6(ctx, PIC_TIME_TOP_V6);
+}
+
+unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v6(ctx, PIC_TIME_BOT_V6);
+}
+
+unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v6(ctx, CROP_INFO_H_V6);
+}
+
+unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
+{
+	return s5p_mfc_read_info_v6(ctx, CROP_INFO_V_V6);
+}
+
+/* Initialize opr function pointers for MFC v6 */
+static struct s5p_mfc_hw_ops s5p_mfc_ops_v6 = {
+	.alloc_dec_temp_buffers = s5p_mfc_alloc_dec_temp_buffers_v6,
+	.release_dec_desc_buffer = s5p_mfc_release_dec_desc_buffer_v6,
+	.alloc_codec_buffers = s5p_mfc_alloc_codec_buffers_v6,
+	.release_codec_buffers = s5p_mfc_release_codec_buffers_v6,
+	.alloc_instance_buffer = s5p_mfc_alloc_instance_buffer_v6,
+	.release_instance_buffer = s5p_mfc_release_instance_buffer_v6,
+	.alloc_dev_context_buffer =
+		s5p_mfc_alloc_dev_context_buffer_v6,
+	.release_dev_context_buffer =
+		s5p_mfc_release_dev_context_buffer_v6,
+	.dec_calc_dpb_size = s5p_mfc_dec_calc_dpb_size_v6,
+	.enc_calc_src_size = s5p_mfc_enc_calc_src_size_v6,
+	.set_dec_stream_buffer = s5p_mfc_set_dec_stream_buffer_v6,
+	.set_dec_frame_buffer = s5p_mfc_set_dec_frame_buffer_v6,
+	.set_enc_stream_buffer = s5p_mfc_set_enc_stream_buffer_v6,
+	.set_enc_frame_buffer = s5p_mfc_set_enc_frame_buffer_v6,
+	.get_enc_frame_buffer = s5p_mfc_get_enc_frame_buffer_v6,
+	.set_enc_ref_buffer = s5p_mfc_set_enc_ref_buffer_v6,
+	.init_decode = s5p_mfc_init_decode_v6,
+	.init_encode = s5p_mfc_init_encode_v6,
+	.encode_one_frame = s5p_mfc_encode_one_frame_v6,
+	.try_run = s5p_mfc_try_run_v6,
+	.cleanup_queue = s5p_mfc_cleanup_queue_v6,
+	.clear_int_flags = s5p_mfc_clear_int_flags_v6,
+	.write_info = s5p_mfc_write_info_v6,
+	.read_info = s5p_mfc_read_info_v6,
+	.get_dspl_y_adr = s5p_mfc_get_dspl_y_adr_v6,
+	.get_dec_y_adr = s5p_mfc_get_dec_y_adr_v6,
+	.get_dspl_status = s5p_mfc_get_dspl_status_v6,
+	.get_dec_status = s5p_mfc_get_dec_status_v6,
+	.get_dec_frame_type = s5p_mfc_get_dec_frame_type_v6,
+	.get_disp_frame_type = s5p_mfc_get_disp_frame_type_v6,
+	.get_consumed_stream = s5p_mfc_get_consumed_stream_v6,
+	.get_int_reason = s5p_mfc_get_int_reason_v6,
+	.get_int_err = s5p_mfc_get_int_err_v6,
+	.err_dec = s5p_mfc_err_dec_v6,
+	.err_dspl = s5p_mfc_err_dspl_v6,
+	.get_img_width = s5p_mfc_get_img_width_v6,
+	.get_img_height = s5p_mfc_get_img_height_v6,
+	.get_dpb_count = s5p_mfc_get_dpb_count_v6,
+	.get_mv_count = s5p_mfc_get_mv_count_v6,
+	.get_inst_no = s5p_mfc_get_inst_no_v6,
+	.get_enc_strm_size = s5p_mfc_get_enc_strm_size_v6,
+	.get_enc_slice_type = s5p_mfc_get_enc_slice_type_v6,
+	.get_enc_dpb_count = s5p_mfc_get_enc_dpb_count_v6,
+	.get_enc_pic_count = s5p_mfc_get_enc_pic_count_v6,
+	.get_sei_avail_status = s5p_mfc_get_sei_avail_status_v6,
+	.get_mvc_num_views = s5p_mfc_get_mvc_num_views_v6,
+	.get_mvc_view_id = s5p_mfc_get_mvc_view_id_v6,
+	.get_pic_type_top = s5p_mfc_get_pic_type_top_v6,
+	.get_pic_type_bot = s5p_mfc_get_pic_type_bot_v6,
+	.get_crop_info_h = s5p_mfc_get_crop_info_h_v6,
+	.get_crop_info_v = s5p_mfc_get_crop_info_v_v6,
+};
+
+struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void)
+{
+	return &s5p_mfc_ops_v6;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
new file mode 100644
index 0000000..ab164ef
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -0,0 +1,50 @@
+/*
+ * drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+ *
+ * Header file for Samsung MFC (Multi Function Codec - FIMV) driver
+ * Contains declarations of hw related functions.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef S5P_MFC_OPR_V6_H_
+#define S5P_MFC_OPR_V6_H_
+
+#include "s5p_mfc_common.h"
+#include "s5p_mfc_opr.h"
+
+#define MFC_CTRL_MODE_CUSTOM	MFC_CTRL_MODE_SFR
+
+#define MB_WIDTH(x_size)		DIV_ROUND_UP(x_size, 16)
+#define MB_HEIGHT(y_size)		DIV_ROUND_UP(y_size, 16)
+#define S5P_MFC_DEC_MV_SIZE_V6(x, y)	(MB_WIDTH(x) * \
+					(((MB_HEIGHT(y)+1)/2)*2) * 64 + 128)
+
+/* Definition */
+#define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
+#define ENC_MULTI_SLICE_BIT_MIN		2800
+#define ENC_INTRA_REFRESH_MB_MAX	((1 << 18) - 1)
+#define ENC_VBV_BUF_SIZE_MAX		((1 << 30) - 1)
+#define ENC_H264_LOOP_FILTER_AB_MIN	-12
+#define ENC_H264_LOOP_FILTER_AB_MAX	12
+#define ENC_H264_RC_FRAME_RATE_MAX	((1 << 16) - 1)
+#define ENC_H263_RC_FRAME_RATE_MAX	((1 << 16) - 1)
+#define ENC_H264_PROFILE_MAX		3
+#define ENC_H264_LEVEL_MAX		42
+#define ENC_MPEG4_VOP_TIME_RES_MAX	((1 << 16) - 1)
+#define FRAME_DELTA_H264_H263		1
+#define TIGHT_CBR_MAX			10
+
+/* Definitions for shared memory compatibility */
+#define PIC_TIME_TOP_V6		S5P_FIMV_D_RET_PICTURE_TAG_TOP_V6
+#define PIC_TIME_BOT_V6		S5P_FIMV_D_RET_PICTURE_TAG_BOT_V6
+#define CROP_INFO_H_V6		S5P_FIMV_D_DISPLAY_CROP_INFO1_V6
+#define CROP_INFO_V_V6		S5P_FIMV_D_DISPLAY_CROP_INFO2_V6
+
+struct s5p_mfc_hw_ops *s5p_mfc_init_hw_ops_v6(void);
+#endif /* S5P_MFC_OPR_V6_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 0503d14..367db75 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -20,7 +20,6 @@
 #include "s5p_mfc_debug.h"
 #include "s5p_mfc_pm.h"
 
-#define MFC_CLKNAME		"sclk_mfc"
 #define MFC_GATE_CLK_NAME	"mfc"
 
 #define CLK_DEBUG
@@ -51,7 +50,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_p_ip_clk;
 	}
 
-	pm->clock = clk_get(&dev->plat_dev->dev, MFC_CLKNAME);
+	pm->clock = clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
 	if (IS_ERR(pm->clock)) {
 		mfc_err("Failed to get MFC clock\n");
 		ret = PTR_ERR(pm->clock);
-- 
1.7.0.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42133 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaHFLC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Aug 2014 07:02:28 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: checkpatch cleanup
Date: Wed,  6 Aug 2014 13:02:23 +0200
Message-Id: <1407322943-3650-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch breaks most long lines, concatenates broken up text strings,
and adds or removes parentheses where needed to make checkpatch happy.
The long codec list lines and a few 81-wide lines remain.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 143 +++++++++++++++++++-----------
 drivers/media/platform/coda/coda-common.c |  34 ++++---
 2 files changed, 113 insertions(+), 64 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 18fa369..07fc91a 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -37,7 +37,7 @@
 
 static inline int coda_is_initialized(struct coda_dev *dev)
 {
-	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);
+	return coda_read(dev, CODA_REG_BIT_CUR_PC) != 0;
 }
 
 static inline unsigned long coda_isbusy(struct coda_dev *dev)
@@ -165,17 +165,20 @@ static void coda_kfifo_sync_to_device_write(struct coda_ctx *ctx)
 	coda_write(dev, wr_ptr, CODA_REG_BIT_WR_PTR(ctx->reg_idx));
 }
 
-static int coda_bitstream_queue(struct coda_ctx *ctx, struct vb2_buffer *src_buf)
+static int coda_bitstream_queue(struct coda_ctx *ctx,
+				struct vb2_buffer *src_buf)
 {
 	u32 src_size = vb2_get_plane_payload(src_buf, 0);
 	u32 n;
 
-	n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0), src_size);
+	n = kfifo_in(&ctx->bitstream_fifo, vb2_plane_vaddr(src_buf, 0),
+		     src_size);
 	if (n < src_size)
 		return -ENOSPC;
 
-	dma_sync_single_for_device(&ctx->dev->plat_dev->dev, ctx->bitstream.paddr,
-				   ctx->bitstream.size, DMA_TO_DEVICE);
+	dma_sync_single_for_device(&ctx->dev->plat_dev->dev,
+				   ctx->bitstream.paddr, ctx->bitstream.size,
+				   DMA_TO_DEVICE);
 
 	src_buf->v4l2_buf.sequence = ctx->qsequence++;
 
@@ -246,11 +249,12 @@ void coda_bit_stream_end_flag(struct coda_ctx *ctx)
 
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
+	/* If this context is currently running, update the hardware flag */
 	if ((dev->devtype->product == CODA_960) &&
 	    coda_isbusy(dev) &&
 	    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
-		/* If this context is currently running, update the hardware flag */
-		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+		coda_write(dev, ctx->bit_stream_param,
+			   CODA_REG_BIT_BIT_STREAM_PARAM);
 	}
 }
 
@@ -315,9 +319,10 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	/* Register frame buffers in the parameter buffer */
 	for (i = 0; i < ctx->num_internal_frames; i++) {
 		paddr = ctx->internal_frames[i].paddr;
-		coda_parabuf_write(ctx, i * 3 + 0, paddr); /* Y */
-		coda_parabuf_write(ctx, i * 3 + 1, paddr + ysize); /* Cb */
-		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize/4); /* Cr */
+		/* Start addresses of Y, Cb, Cr planes */
+		coda_parabuf_write(ctx, i * 3 + 0, paddr);
+		coda_parabuf_write(ctx, i * 3 + 1, paddr + ysize);
+		coda_parabuf_write(ctx, i * 3 + 2, paddr + ysize + ysize / 4);
 
 		/* mvcol buffer for h.264 */
 		if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
@@ -374,18 +379,22 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		/* worst case slice size */
 		size = (DIV_ROUND_UP(q_data->width, 16) *
 			DIV_ROUND_UP(q_data->height, 16)) * 3200 / 8 + 512;
-		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size, "slicebuf");
+		ret = coda_alloc_context_buf(ctx, &ctx->slicebuf, size,
+					     "slicebuf");
 		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte slice buffer",
+			v4l2_err(&dev->v4l2_dev,
+				 "failed to allocate %d byte slice buffer",
 				 ctx->slicebuf.size);
 			return ret;
 		}
 	}
 
 	if (dev->devtype->product == CODA_7541) {
-		ret = coda_alloc_context_buf(ctx, &ctx->psbuf, CODA7_PS_BUF_SIZE, "psbuf");
+		ret = coda_alloc_context_buf(ctx, &ctx->psbuf,
+					     CODA7_PS_BUF_SIZE, "psbuf");
 		if (ret < 0) {
-			v4l2_err(&dev->v4l2_dev, "failed to allocate psmem buffer");
+			v4l2_err(&dev->v4l2_dev,
+				 "failed to allocate psmem buffer");
 			goto err;
 		}
 	}
@@ -396,7 +405,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 		size += CODA9_PS_SAVE_SIZE;
 	ret = coda_alloc_context_buf(ctx, &ctx->workbuf, size, "workbuf");
 	if (ret < 0) {
-		v4l2_err(&dev->v4l2_dev, "failed to allocate %d byte context buffer",
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to allocate %d byte context buffer",
 			 ctx->workbuf.size);
 		goto err;
 	}
@@ -465,6 +475,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 {
 	struct coda_iram_info *iram_info = &ctx->iram_info;
 	struct coda_dev *dev = ctx->dev;
+	int w64, w128;
 	int mb_width;
 	int dbk_bits;
 	int bit_bits;
@@ -497,13 +508,15 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 		mb_width = DIV_ROUND_UP(q_data_src->width, 16);
+		w128 = mb_width * 128;
+		w64 = mb_width * 64;
 
 		/* Prioritize in case IRAM is too small for everything */
 		if (dev->devtype->product == CODA_7541) {
 			iram_info->search_ram_size = round_up(mb_width * 16 *
 							      36 + 2048, 1024);
 			iram_info->search_ram_paddr = coda_iram_alloc(iram_info,
-							iram_info->search_ram_size);
+						iram_info->search_ram_size);
 			if (!iram_info->search_ram_paddr) {
 				pr_err("IRAM is smaller than the search ram size\n");
 				goto out;
@@ -513,18 +526,18 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		}
 
 		/* Only H.264BP and H.263P3 are considered */
-		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, 64 * mb_width);
-		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, 64 * mb_width);
+		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w64);
+		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w64);
 		if (!iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
-		iram_info->buf_bit_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_bit_use = coda_iram_alloc(iram_info, w128);
 		if (!iram_info->buf_bit_use)
 			goto out;
 		iram_info->axi_sram_use |= bit_bits;
 
-		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, w128);
 		if (!iram_info->buf_ip_ac_dc_use)
 			goto out;
 		iram_info->axi_sram_use |= ip_bits;
@@ -535,19 +548,20 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		mb_width = DIV_ROUND_UP(q_data_dst->width, 16);
+		w128 = mb_width * 128;
 
-		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, 128 * mb_width);
-		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, w128);
+		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, w128);
 		if (!iram_info->buf_dbk_c_use)
 			goto out;
 		iram_info->axi_sram_use |= dbk_bits;
 
-		iram_info->buf_bit_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_bit_use = coda_iram_alloc(iram_info, w128);
 		if (!iram_info->buf_bit_use)
 			goto out;
 		iram_info->axi_sram_use |= bit_bits;
 
-		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, w128);
 		if (!iram_info->buf_ip_ac_dc_use)
 			goto out;
 		iram_info->axi_sram_use |= ip_bits;
@@ -634,8 +648,8 @@ int coda_check_firmware(struct coda_dev *dev)
 	clk_disable_unprepare(dev->clk_ahb);
 
 	if (product != dev->devtype->product) {
-		v4l2_err(&dev->v4l2_dev, "Wrong firmware. Hw: %s, Fw: %s,"
-			 " Version: %u.%u.%u\n",
+		v4l2_err(&dev->v4l2_dev,
+			 "Wrong firmware. Hw: %s, Fw: %s, Version: %u.%u.%u\n",
 			 coda_product_name(dev->devtype->product),
 			 coda_product_name(product), major, minor, release);
 		return -EINVAL;
@@ -648,8 +662,9 @@ int coda_check_firmware(struct coda_dev *dev)
 		v4l2_info(&dev->v4l2_dev, "Firmware version: %u.%u.%u\n",
 			  major, minor, release);
 	} else {
-		v4l2_warn(&dev->v4l2_dev, "Unsupported firmware version: "
-			  "%u.%u.%u\n", major, minor, release);
+		v4l2_warn(&dev->v4l2_dev,
+			  "Unsupported firmware version: %u.%u.%u\n",
+			  major, minor, release);
 	}
 
 	return 0;
@@ -720,27 +735,32 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 
 	if (dev->devtype->product == CODA_DX6) {
 		/* Configure the coda */
-		coda_write(dev, dev->iram.paddr, CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
+		coda_write(dev, dev->iram.paddr,
+			   CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
 	}
 
 	/* Could set rotation here if needed */
 	switch (dev->devtype->product) {
 	case CODA_DX6:
-		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
-		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+		value = (q_data_src->width & CODADX6_PICWIDTH_MASK)
+			<< CODADX6_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK)
+			 << CODA_PICHEIGHT_OFFSET;
 		break;
 	case CODA_7541:
 		if (dst_fourcc == V4L2_PIX_FMT_H264) {
 			value = (round_up(q_data_src->width, 16) &
 				 CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
 			value |= (round_up(q_data_src->height, 16) &
-				  CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+				 CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
 			break;
 		}
 		/* fallthrough */
 	case CODA_960:
-		value = (q_data_src->width & CODA7_PICWIDTH_MASK) << CODA7_PICWIDTH_OFFSET;
-		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
+		value = (q_data_src->width & CODA7_PICWIDTH_MASK)
+			<< CODA7_PICWIDTH_OFFSET;
+		value |= (q_data_src->height & CODA7_PICHEIGHT_MASK)
+			 << CODA_PICHEIGHT_OFFSET;
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_SRC_SIZE);
 	coda_write(dev, ctx->params.framerate,
@@ -750,16 +770,20 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	switch (dst_fourcc) {
 	case V4L2_PIX_FMT_MPEG4:
 		if (dev->devtype->product == CODA_960)
-			coda_write(dev, CODA9_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+			coda_write(dev, CODA9_STD_MPEG4,
+				   CODA_CMD_ENC_SEQ_COD_STD);
 		else
-			coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+			coda_write(dev, CODA_STD_MPEG4,
+				   CODA_CMD_ENC_SEQ_COD_STD);
 		coda_write(dev, 0, CODA_CMD_ENC_SEQ_MP4_PARA);
 		break;
 	case V4L2_PIX_FMT_H264:
 		if (dev->devtype->product == CODA_960)
-			coda_write(dev, CODA9_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
+			coda_write(dev, CODA9_STD_H264,
+				   CODA_CMD_ENC_SEQ_COD_STD);
 		else
-			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
+			coda_write(dev, CODA_STD_H264,
+				   CODA_CMD_ENC_SEQ_COD_STD);
 		if (ctx->params.h264_deblk_enabled) {
 			value = ((ctx->params.h264_deblk_alpha &
 				  CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) <<
@@ -784,13 +808,17 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		value = 0;
 		break;
 	case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB:
-		value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
-		value |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
+		value  = (ctx->params.slice_max_mb & CODA_SLICING_SIZE_MASK)
+			 << CODA_SLICING_SIZE_OFFSET;
+		value |= (1 & CODA_SLICING_UNIT_MASK)
+			 << CODA_SLICING_UNIT_OFFSET;
 		value |=  1 & CODA_SLICING_MODE_MASK;
 		break;
 	case V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES:
-		value  = (ctx->params.slice_max_bits & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
-		value |= (0 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
+		value  = (ctx->params.slice_max_bits & CODA_SLICING_SIZE_MASK)
+			 << CODA_SLICING_SIZE_OFFSET;
+		value |= (0 & CODA_SLICING_UNIT_MASK)
+			 << CODA_SLICING_UNIT_OFFSET;
 		value |=  1 & CODA_SLICING_MODE_MASK;
 		break;
 	}
@@ -800,7 +828,8 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 
 	if (ctx->params.bitrate) {
 		/* Rate control enabled */
-		value = (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
+		value = (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK)
+			<< CODA_RATECONTROL_BITRATE_OFFSET;
 		value |=  1 & CODA_RATECONTROL_ENABLE_MASK;
 		if (dev->devtype->product == CODA_960)
 			value |= BIT(31); /* disable autoskip */
@@ -919,8 +948,10 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 					CODA9_CMD_SET_FRAME_AXI_BTP_ADDR);
 
 			/* FIXME */
-			coda_write(dev, ctx->internal_frames[2].paddr, CODA9_CMD_SET_FRAME_SUBSAMP_A);
-			coda_write(dev, ctx->internal_frames[3].paddr, CODA9_CMD_SET_FRAME_SUBSAMP_B);
+			coda_write(dev, ctx->internal_frames[2].paddr,
+				   CODA9_CMD_SET_FRAME_SUBSAMP_A);
+			coda_write(dev, ctx->internal_frames[3].paddr,
+				   CODA9_CMD_SET_FRAME_SUBSAMP_B);
 		}
 	}
 
@@ -1092,7 +1123,8 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	}
 
 	/* submit */
-	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode, CODA_CMD_ENC_PIC_ROT_MODE);
+	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
+		   CODA_CMD_ENC_PIC_ROT_MODE);
 	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
 
 
@@ -1135,9 +1167,10 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 		   CODA_CMD_ENC_PIC_BB_SIZE);
 
 	if (!ctx->streamon_out) {
-		/* After streamoff on the output side, set the stream end flag */
+		/* After streamoff on the output side, set stream end flag */
 		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
-		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+		coda_write(dev, ctx->bit_stream_param,
+			   CODA_REG_BIT_BIT_STREAM_PARAM);
 	}
 
 	if (dev->devtype->product != CODA_DX6)
@@ -1217,7 +1250,8 @@ static void coda_seq_end_work(struct work_struct *work)
 	mutex_lock(&dev->coda_mutex);
 
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
-		 "%d: %s: sent command 'SEQ_END' to coda\n", ctx->idx, __func__);
+		 "%d: %s: sent command 'SEQ_END' to coda\n", ctx->idx,
+		 __func__);
 	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_END)) {
 		v4l2_err(&dev->v4l2_dev,
 			 "CODA_COMMAND_SEQ_END failed\n");
@@ -1550,7 +1584,8 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		coda_write(dev, CODA_PRE_SCAN_EN, CODA_CMD_DEC_PIC_OPTION);
 		break;
 	case CODA_960:
-		coda_write(dev, (1 << 10), CODA_CMD_DEC_PIC_OPTION); /* 'hardcode to use interrupt disable mode'? */
+		/* 'hardcode to use interrupt disable mode'? */
+		coda_write(dev, (1 << 10), CODA_CMD_DEC_PIC_OPTION);
 		break;
 	}
 
@@ -1666,7 +1701,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		}
 	}
 
-	ctx->frm_dis_flg = coda_read(dev, CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
+	ctx->frm_dis_flg = coda_read(dev,
+				     CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
 
 	/*
 	 * The previous display frame was copied out by the rotator,
@@ -1694,7 +1730,7 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		else if (ctx->display_idx < 0)
 			ctx->hold = true;
 	} else if (decoded_idx == -2) {
-		/* no frame was decoded, we still return the remaining buffers */
+		/* no frame was decoded, we still return remaining buffers */
 	} else if (decoded_idx < 0 || decoded_idx >= ctx->num_internal_frames) {
 		v4l2_err(&dev->v4l2_dev,
 			 "decoded frame index out of range: %d\n", decoded_idx);
@@ -1801,7 +1837,8 @@ irqreturn_t coda_irq_handler(int irq, void *data)
 
 	ctx = v4l2_m2m_get_curr_priv(dev->m2m_dev);
 	if (ctx == NULL) {
-		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
+		v4l2_err(&dev->v4l2_dev,
+			 "Instance released before the end of transaction\n");
 		mutex_unlock(&dev->coda_mutex);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ffb4c76..0997b5c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -75,6 +75,7 @@ void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 unsigned int coda_read(struct coda_dev *dev, u32 reg)
 {
 	u32 data;
+
 	data = readl(dev->regs_base + reg);
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
 		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
@@ -736,7 +737,8 @@ static void coda_pic_run_work(struct work_struct *work)
 		return;
 	}
 
-	if (!wait_for_completion_timeout(&ctx->completion, msecs_to_jiffies(1000))) {
+	if (!wait_for_completion_timeout(&ctx->completion,
+					 msecs_to_jiffies(1000))) {
 		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
 
 		ctx->hold = true;
@@ -812,6 +814,7 @@ static void coda_lock(void *m2m_priv)
 {
 	struct coda_ctx *ctx = m2m_priv;
 	struct coda_dev *pcdev = ctx->dev;
+
 	mutex_lock(&pcdev->dev_mutex);
 }
 
@@ -819,6 +822,7 @@ static void coda_unlock(void *m2m_priv)
 {
 	struct coda_ctx *ctx = m2m_priv;
 	struct coda_dev *pcdev = ctx->dev;
+
 	mutex_unlock(&pcdev->dev_mutex);
 }
 
@@ -995,7 +999,8 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 	if (name && parent) {
 		buf->blob.data = buf->vaddr;
 		buf->blob.size = size;
-		buf->dentry = debugfs_create_blob(name, 0644, parent, &buf->blob);
+		buf->dentry = debugfs_create_blob(name, 0644, parent,
+						  &buf->blob);
 		if (!buf->dentry)
 			dev_warn(&dev->plat_dev->dev,
 				 "failed to create debugfs entry %s\n", name);
@@ -1276,17 +1281,20 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES, 1, 0x3fffffff, 1, 500);
+		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_BYTES, 1, 0x3fffffff, 1,
+		500);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
 		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
 		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
-		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0, 1920 * 1088 / 256, 1, 0);
+		V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB, 0,
+		1920 * 1088 / 256, 1, 0);
 
 	if (ctx->ctrls.error) {
-		v4l2_err(&ctx->dev->v4l2_dev, "control initialization error (%d)",
+		v4l2_err(&ctx->dev->v4l2_dev,
+			"control initialization error (%d)",
 			ctx->ctrls.error);
 		return -EINVAL;
 	}
@@ -1365,7 +1373,7 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type,
 	int ret;
 	int idx;
 
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
 
@@ -1444,7 +1452,8 @@ static int coda_open(struct file *file, enum coda_inst_type inst_type,
 	ctx->bitstream.vaddr = dma_alloc_writecombine(&dev->plat_dev->dev,
 			ctx->bitstream.size, &ctx->bitstream.paddr, GFP_KERNEL);
 	if (!ctx->bitstream.vaddr) {
-		v4l2_err(&dev->v4l2_dev, "failed to allocate bitstream ringbuffer");
+		v4l2_err(&dev->v4l2_dev,
+			 "failed to allocate bitstream ringbuffer");
 		ret = -ENOMEM;
 		goto err_dma_writecombine;
 	}
@@ -1617,10 +1626,12 @@ static int coda_hw_init(struct coda_dev *dev)
 	/* Set default values */
 	switch (dev->devtype->product) {
 	case CODA_DX6:
-		coda_write(dev, CODADX6_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
+		coda_write(dev, CODADX6_STREAM_BUF_PIC_FLUSH,
+			   CODA_REG_BIT_STREAM_CTRL);
 		break;
 	default:
-		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
+		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH,
+			   CODA_REG_BIT_STREAM_CTRL);
 	}
 	if (dev->devtype->product == CODA_960)
 		coda_write(dev, 1 << 12, CODA_REG_BIT_FRAME_MEM_CTRL);
@@ -1854,7 +1865,7 @@ static int coda_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret, irq;
 
-	dev = devm_kzalloc(&pdev->dev, sizeof *dev, GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(&pdev->dev, "Not enough memory for %s\n",
 			CODA_NAME);
@@ -1905,7 +1916,8 @@ static int coda_probe(struct platform_device *pdev)
 		if (ret == -ENOENT || ret == -ENOSYS) {
 			dev->rstc = NULL;
 		} else {
-			dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
+			dev_err(&pdev->dev, "failed get reset control: %d\n",
+				ret);
 			return ret;
 		}
 	}
-- 
2.0.1


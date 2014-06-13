Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44427 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaFMQJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 06/30] [media] coda: Add encoder/decoder support for CODA960
Date: Fri, 13 Jun 2014 18:08:32 +0200
Message-Id: <1402675736-15379-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support for the CODA960 VPU in Freescale i.MX6 SoCs.

It enables h.264 and MPEG4 encoding and decoding support. Besides the usual
register shifting, the CODA960 gains frame memory control and GDI registers
that are set up for linear mapping right now, needs ENC_PIC_SRC_INDEX to be
set beyond the number of internal buffers for some reason, and has subsampling
buffers that need to be set up. Also, the work buffer size is increased to
80 KiB.

The CODA960 firmware spins if there is not enough input data in the bitstream
buffer. To make it continue, buffers need to be copied into the bitstream as
soon as they are queued. As the bitstream fifo is written into from two places,
it must be protected with a mutex. For that, using a threaded interrupt handler
is necessary.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 397 +++++++++++++++++++++++++++++++++++++-----
 drivers/media/platform/coda.h | 115 +++++++++++-
 2 files changed, 464 insertions(+), 48 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 2b27998..10cc031 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -44,19 +44,24 @@
 #define CODA_FMO_BUF_SIZE	32
 #define CODADX6_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
 #define CODA7_WORK_BUF_SIZE	(128 * 1024)
+#define CODA9_WORK_BUF_SIZE	(80 * 1024)
 #define CODA7_TEMP_BUF_SIZE	(304 * 1024)
+#define CODA9_TEMP_BUF_SIZE	(204 * 1024)
 #define CODA_PARA_BUF_SIZE	(10 * 1024)
 #define CODA_ISRAM_SIZE	(2048 * 2)
 #define CODADX6_IRAM_SIZE	0xb000
 #define CODA7_IRAM_SIZE		0x14000
+#define CODA9_IRAM_SIZE		0x21000
 
 #define CODA7_PS_BUF_SIZE	0x28000
+#define CODA9_PS_SAVE_SIZE	(512 * 1024)
 
 #define CODA_MAX_FRAMEBUFFERS	8
 
 #define CODA_MAX_FRAME_SIZE	0x100000
 #define FMO_SLICE_SAVE_BUF_SIZE         (32)
 #define CODA_DEFAULT_GAMMA		4096
+#define CODA9_DEFAULT_GAMMA		24576	/* 0.75 * 32768 */
 
 #define MIN_W 176
 #define MIN_H 144
@@ -84,6 +89,7 @@ enum coda_inst_type {
 enum coda_product {
 	CODA_DX6 = 0xf001,
 	CODA_7541 = 0xf012,
+	CODA_960 = 0xf020,
 };
 
 struct coda_fmt {
@@ -177,6 +183,16 @@ struct coda_iram_info {
 	phys_addr_t	next_paddr;
 };
 
+struct gdi_tiled_map {
+	int xy2ca_map[16];
+	int xy2ba_map[16];
+	int xy2ra_map[16];
+	int rbc2axi_map[32];
+	int xy2rbc_config;
+	int map_type;
+#define GDI_LINEAR_FRAME_MAP 0
+};
+
 struct coda_ctx {
 	struct coda_dev			*dev;
 	struct mutex			buffer_mutex;
@@ -215,8 +231,10 @@ struct coda_ctx {
 	int				idx;
 	int				reg_idx;
 	struct coda_iram_info		iram_info;
+	struct gdi_tiled_map		tiled_map;
 	u32				bit_stream_param;
 	u32				frm_dis_flg;
+	u32				frame_mem_ctrl;
 	int				display_idx;
 };
 
@@ -265,15 +283,23 @@ static void coda_command_async(struct coda_ctx *ctx, int cmd)
 {
 	struct coda_dev *dev = ctx->dev;
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_960 ||
+	    dev->devtype->product == CODA_7541) {
 		/* Restore context related registers to CODA */
 		coda_write(dev, ctx->bit_stream_param,
 				CODA_REG_BIT_BIT_STREAM_PARAM);
 		coda_write(dev, ctx->frm_dis_flg,
 				CODA_REG_BIT_FRM_DIS_FLG(ctx->reg_idx));
+		coda_write(dev, ctx->frame_mem_ctrl,
+				CODA_REG_BIT_FRAME_MEM_CTRL);
 		coda_write(dev, ctx->workbuf.paddr, CODA_REG_BIT_WORK_BUF_ADDR);
 	}
 
+	if (dev->devtype->product == CODA_960) {
+		coda_write(dev, 1, CODA9_GDI_WPROT_ERR_CLR);
+		coda_write(dev, 0, CODA9_GDI_WPROT_RGN_EN);
+	}
+
 	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
 
 	coda_write(dev, ctx->idx, CODA_REG_BIT_RUN_INDEX);
@@ -349,6 +375,13 @@ static struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
 };
 
+static struct coda_codec coda9_codecs[] = {
+	CODA_CODEC(CODA9_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1920, 1080),
+	CODA_CODEC(CODA9_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1920, 1080),
+	CODA_CODEC(CODA9_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1080),
+	CODA_CODEC(CODA9_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1920, 1080),
+};
+
 static bool coda_format_is_yuv(u32 fourcc)
 {
 	switch (fourcc) {
@@ -427,6 +460,8 @@ static char *coda_product_name(int product)
 		return "CodaDx6";
 	case CODA_7541:
 		return "CODA7541";
+	case CODA_960:
+		return "CODA960";
 	default:
 		snprintf(buf, sizeof(buf), "(0x%04x)", product);
 		return buf;
@@ -857,6 +892,7 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 			    struct v4l2_decoder_cmd *dc)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct coda_dev *dev = ctx->dev;
 	int ret;
 
 	ret = coda_try_decoder_cmd(file, fh, dc);
@@ -870,6 +906,13 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 	/* Set the strem-end flag on this context */
 	ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
+	if ((dev->devtype->product == CODA_960) &&
+	    coda_isbusy(dev) &&
+	    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
+		/* If this context is currently running, update the hardware flag */
+		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+	}
+
 	return 0;
 }
 
@@ -1025,6 +1068,27 @@ static void coda_fill_bitstream(struct coda_ctx *ctx)
 	}
 }
 
+static void coda_set_gdi_regs(struct coda_ctx *ctx)
+{
+	struct gdi_tiled_map *tiled_map = &ctx->tiled_map;
+	struct coda_dev *dev = ctx->dev;
+	int i;
+
+	for (i = 0; i < 16; i++)
+		coda_write(dev, tiled_map->xy2ca_map[i],
+				CODA9_GDI_XY2_CAS_0 + 4 * i);
+	for (i = 0; i < 4; i++)
+		coda_write(dev, tiled_map->xy2ba_map[i],
+				CODA9_GDI_XY2_BA_0 + 4 * i);
+	for (i = 0; i < 16; i++)
+		coda_write(dev, tiled_map->xy2ra_map[i],
+				CODA9_GDI_XY2_RAS_0 + 4 * i);
+	coda_write(dev, tiled_map->xy2rbc_config, CODA9_GDI_XY2_RBC_CONFIG);
+	for (i = 0; i < 32; i++)
+		coda_write(dev, tiled_map->rbc2axi_map[i],
+				CODA9_GDI_RBC2_AXI_0 + 4 * i);
+}
+
 /*
  * Mem-to-mem operations.
  */
@@ -1073,6 +1137,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		}
 	}
 
+	if (dev->devtype->product == CODA_960)
+		coda_set_gdi_regs(ctx);
+
 	/* Set rotator output */
 	picture_y = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
 	if (q_data_dst->fourcc == V4L2_PIX_FMT_YVU420) {
@@ -1083,10 +1150,26 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 		picture_cb = picture_y + stridey * height;
 		picture_cr = picture_cb + stridey / 2 * height / 2;
 	}
-	coda_write(dev, picture_y, CODA_CMD_DEC_PIC_ROT_ADDR_Y);
-	coda_write(dev, picture_cb, CODA_CMD_DEC_PIC_ROT_ADDR_CB);
-	coda_write(dev, picture_cr, CODA_CMD_DEC_PIC_ROT_ADDR_CR);
-	coda_write(dev, stridey, CODA_CMD_DEC_PIC_ROT_STRIDE);
+
+	if (dev->devtype->product == CODA_960) {
+		/*
+		 * The CODA960 seems to have an internal list of buffers with
+		 * 64 entries that includes the registered frame buffers as
+		 * well as the rotator buffer output.
+		 * ROT_INDEX needs to be < 0x40, but > ctx->num_internal_frames.
+		 */
+		coda_write(dev, CODA_MAX_FRAMEBUFFERS + dst_buf->v4l2_buf.index,
+				CODA9_CMD_DEC_PIC_ROT_INDEX);
+		coda_write(dev, picture_y, CODA9_CMD_DEC_PIC_ROT_ADDR_Y);
+		coda_write(dev, picture_cb, CODA9_CMD_DEC_PIC_ROT_ADDR_CB);
+		coda_write(dev, picture_cr, CODA9_CMD_DEC_PIC_ROT_ADDR_CR);
+		coda_write(dev, stridey, CODA9_CMD_DEC_PIC_ROT_STRIDE);
+	} else {
+		coda_write(dev, picture_y, CODA_CMD_DEC_PIC_ROT_ADDR_Y);
+		coda_write(dev, picture_cb, CODA_CMD_DEC_PIC_ROT_ADDR_CB);
+		coda_write(dev, picture_cr, CODA_CMD_DEC_PIC_ROT_ADDR_CR);
+		coda_write(dev, stridey, CODA_CMD_DEC_PIC_ROT_STRIDE);
+	}
 	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
 			CODA_CMD_DEC_PIC_ROT_MODE);
 
@@ -1096,6 +1179,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	case CODA_7541:
 		coda_write(dev, CODA_PRE_SCAN_EN, CODA_CMD_DEC_PIC_OPTION);
 		break;
+	case CODA_960:
+		coda_write(dev, (1 << 10), CODA_CMD_DEC_PIC_OPTION); /* 'hardcode to use interrupt disable mode'? */
+		break;
 	}
 
 	coda_write(dev, 0, CODA_CMD_DEC_PIC_SKIP_NUM);
@@ -1140,6 +1226,9 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
 	}
 
+	if (dev->devtype->product == CODA_960)
+		coda_set_gdi_regs(ctx);
+
 	/*
 	 * Copy headers at the beginning of the first frame for H.264 only.
 	 * In MPEG4 they are already copied by the coda.
@@ -1218,15 +1307,31 @@ static void coda_prepare_encode(struct coda_ctx *ctx)
 		break;
 	}
 
-	coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
-	coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
-	coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
+	if (dev->devtype->product == CODA_960) {
+		coda_write(dev, 4/*FIXME: 0*/, CODA9_CMD_ENC_PIC_SRC_INDEX);
+		coda_write(dev, q_data_src->width, CODA9_CMD_ENC_PIC_SRC_STRIDE);
+		coda_write(dev, 0, CODA9_CMD_ENC_PIC_SUB_FRAME_SYNC);
+
+		coda_write(dev, picture_y, CODA9_CMD_ENC_PIC_SRC_ADDR_Y);
+		coda_write(dev, picture_cb, CODA9_CMD_ENC_PIC_SRC_ADDR_CB);
+		coda_write(dev, picture_cr, CODA9_CMD_ENC_PIC_SRC_ADDR_CR);
+	} else {
+		coda_write(dev, picture_y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
+		coda_write(dev, picture_cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
+		coda_write(dev, picture_cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
+	}
 	coda_write(dev, force_ipicture << 1 & 0x2,
 		   CODA_CMD_ENC_PIC_OPTION);
 
 	coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
 	coda_write(dev, pic_stream_buffer_size / 1024,
 		   CODA_CMD_ENC_PIC_BB_SIZE);
+
+	if (!ctx->streamon_out) {
+		/* After streamoff on the output side, set the stream end flag */
+		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+		coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+	}
 }
 
 static void coda_device_run(void *m2m_priv)
@@ -1352,6 +1457,32 @@ static struct v4l2_m2m_ops coda_m2m_ops = {
 	.unlock		= coda_unlock,
 };
 
+static void coda_set_tiled_map_type(struct coda_ctx *ctx, int tiled_map_type)
+{
+	struct gdi_tiled_map *tiled_map = &ctx->tiled_map;
+	int luma_map, chro_map, i;
+
+	memset(tiled_map, 0, sizeof(*tiled_map));
+
+	luma_map = 64;
+	chro_map = 64;
+	tiled_map->map_type = tiled_map_type;
+	for (i = 0; i < 16; i++)
+		tiled_map->xy2ca_map[i] = luma_map << 8 | chro_map;
+	for (i = 0; i < 4; i++)
+		tiled_map->xy2ba_map[i] = luma_map << 8 | chro_map;
+	for (i = 0; i < 16; i++)
+		tiled_map->xy2ra_map[i] = luma_map << 8 | chro_map;
+
+	if (tiled_map_type == GDI_LINEAR_FRAME_MAP) {
+		tiled_map->xy2rbc_config = 0;
+	} else {
+		dev_err(&ctx->dev->plat_dev->dev, "invalid map type: %d\n",
+			tiled_map_type);
+		return;
+	}
+}
+
 static void set_default_params(struct coda_ctx *ctx)
 {
 	int max_w;
@@ -1375,6 +1506,9 @@ static void set_default_params(struct coda_ctx *ctx)
 	ctx->q_data[V4L2_M2M_DST].width = max_w;
 	ctx->q_data[V4L2_M2M_DST].height = max_h;
 	ctx->q_data[V4L2_M2M_DST].sizeimage = CODA_MAX_FRAME_SIZE;
+
+	if (ctx->dev->devtype->product == CODA_960)
+		coda_set_tiled_map_type(ctx, GDI_LINEAR_FRAME_MAP);
 }
 
 /*
@@ -1424,6 +1558,7 @@ static int coda_buf_prepare(struct vb2_buffer *vb)
 static void coda_buf_queue(struct vb2_buffer *vb)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data;
 
 	q_data = get_q_data(ctx, vb->vb2_queue->type);
@@ -1438,8 +1573,15 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 		 * For backwards compatibility, queuing an empty buffer marks
 		 * the stream end
 		 */
-		if (vb2_get_plane_payload(vb, 0) == 0)
+		if (vb2_get_plane_payload(vb, 0) == 0) {
 			ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
+			if ((dev->devtype->product == CODA_960) &&
+			    coda_isbusy(dev) &&
+			    (ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX))) {
+				/* if this decoder instance is running, set the stream end flag */
+				coda_write(dev, ctx->bit_stream_param, CODA_REG_BIT_BIT_STREAM_PARAM);
+			}
+		}
 		mutex_lock(&ctx->bitstream_mutex);
 		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 		coda_fill_bitstream(ctx);
@@ -1614,6 +1756,11 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		bit_bits = CODA7_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
 		ip_bits = CODA7_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;
 		break;
+	case CODA_960:
+		dbk_bits = CODA9_USE_HOST_DBK_ENABLE | CODA9_USE_DBK_ENABLE;
+		bit_bits = CODA9_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
+		ip_bits = CODA9_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;
+		break;
 	default: /* CODA_DX6 */
 		return;
 	}
@@ -1723,6 +1870,11 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 	case CODA_7541:
 		size = CODA7_WORK_BUF_SIZE;
 		break;
+	case CODA_960:
+		size = CODA9_WORK_BUF_SIZE;
+		if (q_data->fourcc == V4L2_PIX_FMT_H264)
+			size += CODA9_PS_SAVE_SIZE;
+		break;
 	default:
 		return 0;
 	}
@@ -1807,12 +1959,17 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 	coda_write(dev, bitstream_buf, CODA_CMD_DEC_SEQ_BB_START);
 	coda_write(dev, bitstream_size / 1024, CODA_CMD_DEC_SEQ_BB_SIZE);
 	val = 0;
-	if (dev->devtype->product == CODA_7541)
+	if ((dev->devtype->product == CODA_7541) ||
+	    (dev->devtype->product == CODA_960))
 		val |= CODA_REORDER_ENABLE;
 	coda_write(dev, val, CODA_CMD_DEC_SEQ_OPTION);
 
 	ctx->params.codec_mode = ctx->codec->mode;
-	ctx->params.codec_mode_aux = 0;
+	if (dev->devtype->product == CODA_960 &&
+	    src_fourcc == V4L2_PIX_FMT_MPEG4)
+		ctx->params.codec_mode_aux = CODA_MP4_AUX_MPEG4;
+	else
+		ctx->params.codec_mode_aux = 0;
 	if (src_fourcc == V4L2_PIX_FMT_H264) {
 		if (dev->devtype->product == CODA_7541) {
 			coda_write(dev, ctx->psbuf.paddr,
@@ -1820,6 +1977,13 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 			coda_write(dev, (CODA7_PS_BUF_SIZE / 1024),
 					CODA_CMD_DEC_SEQ_PS_BB_SIZE);
 		}
+		if (dev->devtype->product == CODA_960) {
+			coda_write(dev, 0, CODA_CMD_DEC_SEQ_X264_MV_EN);
+			coda_write(dev, 512, CODA_CMD_DEC_SEQ_SPP_CHUNK_SIZE);
+		}
+	}
+	if (dev->devtype->product != CODA_960) {
+		coda_write(dev, 0, CODA_CMD_DEC_SEQ_SRC_SIZE);
 	}
 
 	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
@@ -1891,6 +2055,20 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 				CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
 		coda_write(dev, ctx->iram_info.buf_ovl_use,
 				CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
+		if (dev->devtype->product == CODA_960)
+			coda_write(dev, ctx->iram_info.buf_btp_use,
+					CODA9_CMD_SET_FRAME_AXI_BTP_ADDR);
+	}
+
+	if (dev->devtype->product == CODA_960) {
+		coda_write(dev, -1, CODA9_CMD_SET_FRAME_DELAY);
+
+		coda_write(dev, 0x20262024, CODA9_CMD_SET_FRAME_CACHE_SIZE);
+		coda_write(dev, 2 << CODA9_CACHE_PAGEMERGE_OFFSET |
+				32 << CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET |
+				8 << CODA9_CACHE_CB_BUFFER_SIZE_OFFSET |
+				8 << CODA9_CACHE_CR_BUFFER_SIZE_OFFSET,
+				CODA9_CMD_SET_FRAME_CACHE_CONFIG);
 	}
 
 	if (src_fourcc == V4L2_PIX_FMT_H264) {
@@ -1900,7 +2078,13 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 				CODA_CMD_SET_FRAME_SLICE_BB_SIZE);
 	}
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_960) {
+		int max_mb_x = 1920 / 16;
+		int max_mb_y = 1088 / 16;
+		int max_mb_num = max_mb_x * max_mb_y;
+		coda_write(dev, max_mb_num << 16 | max_mb_x << 8 | max_mb_y,
+				CODA9_CMD_SET_FRAME_MAX_DEC_SIZE);
+	} else {
 		int max_mb_x = 1920 / 16;
 		int max_mb_y = 1088 / 16;
 		int max_mb_num = max_mb_x * max_mb_y;
@@ -1921,34 +2105,49 @@ static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
 	struct coda_dev *dev = ctx->dev;
+	size_t bufsize;
 	int ret;
+	int i;
+
+	if (dev->devtype->product == CODA_960)
+		memset(vb2_plane_vaddr(buf, 0), 0, 64);
 
 	coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0),
 		   CODA_CMD_ENC_HEADER_BB_START);
-	coda_write(dev, vb2_plane_size(buf, 0), CODA_CMD_ENC_HEADER_BB_SIZE);
+	bufsize = vb2_plane_size(buf, 0);
+	if (dev->devtype->product == CODA_960)
+		bufsize /= 1024;
+	coda_write(dev, bufsize, CODA_CMD_ENC_HEADER_BB_SIZE);
 	coda_write(dev, header_code, CODA_CMD_ENC_HEADER_CODE);
 	ret = coda_command_sync(ctx, CODA_COMMAND_ENCODE_HEADER);
 	if (ret < 0) {
 		v4l2_err(&dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
 		return ret;
 	}
-	*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx)) -
-		coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+
+	if (dev->devtype->product == CODA_960) {
+		for (i = 63; i > 0; i--)
+			if (((char *)vb2_plane_vaddr(buf, 0))[i] != 0)
+				break;
+		*size = i + 1;
+	} else {
+		*size = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->reg_idx)) -
+			coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
+	}
 	memcpy(header, vb2_plane_vaddr(buf, 0), *size);
 
 	return 0;
 }
 
+static int coda_start_encoding(struct coda_ctx *ctx);
+
 static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
-	u32 bitstream_buf, bitstream_size;
 	struct coda_dev *dev = ctx->dev;
 	struct coda_q_data *q_data_src, *q_data_dst;
-	struct vb2_buffer *buf;
 	u32 dst_fourcc;
-	u32 value;
 	int ret = 0;
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
@@ -1983,10 +2182,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		v4l2_m2m_set_src_buffered(ctx->m2m_ctx, true);
 
 	ctx->gopcounter = ctx->params.gop_size - 1;
-	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
-	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
 	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	bitstream_size = q_data_dst->sizeimage;
 	dst_fourcc = q_data_dst->fourcc;
 
 	ctx->codec = coda_find_codec(ctx->dev, q_data_src->fourcc,
@@ -2005,16 +2201,36 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		mutex_lock(&dev->coda_mutex);
 		ret = coda_start_decoding(ctx);
 		mutex_unlock(&dev->coda_mutex);
-		if (ret == -EAGAIN) {
+		if (ret == -EAGAIN)
 			return 0;
-		} else if (ret < 0) {
+		else if (ret < 0)
 			return ret;
-		} else {
-			ctx->initialized = 1;
-			return 0;
-		}
+	} else {
+		ret = coda_start_encoding(ctx);
 	}
 
+	ctx->initialized = 1;
+	return ret;
+}
+
+static int coda_start_encoding(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
+	struct coda_q_data *q_data_src, *q_data_dst;
+	u32 bitstream_buf, bitstream_size;
+	struct vb2_buffer *buf;
+	int gamma, ret, value;
+	u32 dst_fourcc;
+
+	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	dst_fourcc = q_data_dst->fourcc;
+
+	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
+	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
+	bitstream_size = q_data_dst->sizeimage;
+
 	if (!coda_is_initialized(dev)) {
 		v4l2_err(v4l2_dev, "coda is not initialized.\n");
 		return -EFAULT;
@@ -2030,11 +2246,20 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		coda_write(dev, CODADX6_STREAM_BUF_DYNALLOC_EN |
 			CODADX6_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
 		break;
-	default:
+	case CODA_960:
+		coda_write(dev, 0, CODA9_GDI_WPROT_RGN_EN);
+		/* fallthrough */
+	case CODA_7541:
 		coda_write(dev, CODA7_STREAM_BUF_DYNALLOC_EN |
 			CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
+		break;
 	}
 
+	value = coda_read(dev, CODA_REG_BIT_FRAME_MEM_CTRL);
+	value &= ~(1 << 2 | 0x7 << 9);
+	ctx->frame_mem_ctrl = value;
+	coda_write(dev, value, CODA_REG_BIT_FRAME_MEM_CTRL);
+
 	if (dev->devtype->product == CODA_DX6) {
 		/* Configure the coda */
 		coda_write(dev, dev->iram.paddr, CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
@@ -2057,11 +2282,17 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	ctx->params.codec_mode = ctx->codec->mode;
 	switch (dst_fourcc) {
 	case V4L2_PIX_FMT_MPEG4:
-		coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+		if (dev->devtype->product == CODA_960)
+			coda_write(dev, CODA9_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
+		else
+			coda_write(dev, CODA_STD_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
 		coda_write(dev, 0, CODA_CMD_ENC_SEQ_MP4_PARA);
 		break;
 	case V4L2_PIX_FMT_H264:
-		coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
+		if (dev->devtype->product == CODA_960)
+			coda_write(dev, CODA9_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
+		else
+			coda_write(dev, CODA_STD_H264, CODA_CMD_ENC_SEQ_COD_STD);
 		coda_write(dev, 0, CODA_CMD_ENC_SEQ_264_PARA);
 		break;
 	default:
@@ -2094,6 +2325,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		/* Rate control enabled */
 		value = (ctx->params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
 		value |=  1 & CODA_RATECONTROL_ENABLE_MASK;
+		if (dev->devtype->product == CODA_960)
+			value |= BIT(31); /* disable autoskip */
 	} else {
 		value = 0;
 	}
@@ -2105,31 +2338,48 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	coda_write(dev, bitstream_buf, CODA_CMD_ENC_SEQ_BB_START);
 	coda_write(dev, bitstream_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
 
-	/* set default gamma */
-	value = (CODA_DEFAULT_GAMMA & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
-	coda_write(dev, value, CODA_CMD_ENC_SEQ_RC_GAMMA);
 
-	if (CODA_DEFAULT_GAMMA > 0) {
-		if (dev->devtype->product == CODA_DX6)
-			value  = 1 << CODADX6_OPTION_GAMMA_OFFSET;
-		else
-			value  = 1 << CODA7_OPTION_GAMMA_OFFSET;
+	value = 0;
+	if (dev->devtype->product == CODA_960)
+		gamma = CODA9_DEFAULT_GAMMA;
+	else
+		gamma = CODA_DEFAULT_GAMMA;
+	if (gamma > 0) {
+		coda_write(dev, (gamma & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET,
+			   CODA_CMD_ENC_SEQ_RC_GAMMA);
+	}
+	if (dev->devtype->product == CODA_960) {
+		if (CODA_DEFAULT_GAMMA > 0)
+			value |= 1 << CODA9_OPTION_GAMMA_OFFSET;
 	} else {
-		value = 0;
+		if (CODA_DEFAULT_GAMMA > 0) {
+			if (dev->devtype->product == CODA_DX6)
+				value |= 1 << CODADX6_OPTION_GAMMA_OFFSET;
+			else
+				value |= 1 << CODA7_OPTION_GAMMA_OFFSET;
+		}
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
 
+	coda_write(dev, 0, CODA_CMD_ENC_SEQ_RC_INTERVAL_MODE);
+
 	coda_setup_iram(ctx);
 
 	if (dst_fourcc == V4L2_PIX_FMT_H264) {
-		if (dev->devtype->product == CODA_DX6) {
+		switch (dev->devtype->product) {
+		case CODA_DX6:
 			value = FMO_SLICE_SAVE_BUF_SIZE << 7;
 			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
-		} else {
+			break;
+		case CODA_7541:
 			coda_write(dev, ctx->iram_info.search_ram_paddr,
 					CODA7_CMD_ENC_SEQ_SEARCH_BASE);
 			coda_write(dev, ctx->iram_info.search_ram_size,
 					CODA7_CMD_ENC_SEQ_SEARCH_SIZE);
+			break;
+		case CODA_960:
+			coda_write(dev, 0, CODA9_CMD_ENC_SEQ_ME_OPTION);
+			coda_write(dev, 0, CODA9_CMD_ENC_SEQ_INTRA_WEIGHT);
 		}
 	}
 
@@ -2145,7 +2395,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto out;
 	}
 
-	ctx->num_internal_frames = 2;
+	if (dev->devtype->product == CODA_960)
+		ctx->num_internal_frames = 4;
+	else
+		ctx->num_internal_frames = 2;
 	ret = coda_alloc_framebuffers(ctx, q_data_src, dst_fourcc);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "failed to allocate framebuffers\n");
@@ -2168,7 +2421,16 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 				CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
 		coda_write(dev, ctx->iram_info.buf_ovl_use,
 				CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
+		if (dev->devtype->product == CODA_960) {
+			coda_write(dev, ctx->iram_info.buf_btp_use,
+					CODA9_CMD_SET_FRAME_AXI_BTP_ADDR);
+
+			/* FIXME */
+			coda_write(dev, ctx->internal_frames[2].paddr, CODA9_CMD_SET_FRAME_SUBSAMP_A);
+			coda_write(dev, ctx->internal_frames[3].paddr, CODA9_CMD_SET_FRAME_SUBSAMP_B);
+		}
 	}
+
 	ret = coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF);
 	if (ret < 0) {
 		v4l2_err(v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
@@ -2252,6 +2514,16 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			 "%s: output\n", __func__);
 		ctx->streamon_out = 0;
 
+		if (ctx->inst_type == CODA_INST_DECODER &&
+		    coda_isbusy(dev) && ctx->idx == coda_read(dev, CODA_REG_BIT_RUN_INDEX)) {
+			/* if this decoder instance is running, set the stream end flag */
+			if (dev->devtype->product == CODA_960) {
+				u32 val = coda_read(dev, CODA_REG_BIT_BIT_STREAM_PARAM);
+				val |= CODA_BIT_STREAM_END_FLAG;
+				coda_write(dev, val, CODA_REG_BIT_BIT_STREAM_PARAM);
+				ctx->bit_stream_param = val;
+			}
+		}
 		ctx->bit_stream_param |= CODA_BIT_STREAM_END_FLAG;
 
 		ctx->isequence = 0;
@@ -2453,6 +2725,7 @@ static int coda_open(struct file *file)
 	ctx->idx = idx;
 	switch (dev->devtype->product) {
 	case CODA_7541:
+	case CODA_960:
 		ctx->reg_idx = 0;
 		break;
 	default:
@@ -2772,7 +3045,7 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	u32 wr_ptr, start_ptr;
 
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
-	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
+	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
 
 	/* Get results from the coda */
 	start_ptr = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
@@ -2809,6 +3082,8 @@ static void coda_finish_encode(struct coda_ctx *ctx)
 	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
 
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
+
+	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	ctx->gopcounter--;
@@ -2907,6 +3182,7 @@ static void coda_timeout(struct work_struct *work)
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
+	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
 };
 
 static bool coda_firmware_supported(u32 vernum)
@@ -2961,7 +3237,8 @@ static int coda_hw_init(struct coda_dev *dev)
 		coda_write(dev, 0, CODA_REG_BIT_CODE_BUF_ADDR + i * 4);
 
 	/* Tell the BIT where to find everything it needs */
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_960 ||
+	    dev->devtype->product == CODA_7541) {
 		coda_write(dev, dev->tempbuf.paddr,
 				CODA_REG_BIT_TEMP_BUF_ADDR);
 		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
@@ -2981,7 +3258,10 @@ static int coda_hw_init(struct coda_dev *dev)
 	default:
 		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
 	}
-	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
+	if (dev->devtype->product == CODA_960)
+		coda_write(dev, 1 << 12, CODA_REG_BIT_FRAME_MEM_CTRL);
+	else
+		coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
 
 	if (dev->devtype->product != CODA_DX6)
 		coda_write(dev, 0, CODA7_REG_BIT_AXI_SRAM_USE);
@@ -3011,6 +3291,12 @@ static int coda_hw_init(struct coda_dev *dev)
 		return -EIO;
 	}
 
+	if (dev->devtype->product == CODA_960) {
+		data = coda_read(dev, CODA9_CMD_FIRMWARE_CODE_REV);
+		v4l2_info(&dev->v4l2_dev, "Firmware code revision: %d\n",
+			  data);
+	}
+
 	/* Check we are compatible with the loaded firmware */
 	data = coda_read(dev, CODA_CMD_FIRMWARE_VERNUM);
 	product = CODA_FIRMWARE_PRODUCT(data);
@@ -3126,6 +3412,8 @@ static int coda_firmware_request(struct coda_dev *dev)
 enum coda_platform {
 	CODA_IMX27,
 	CODA_IMX53,
+	CODA_IMX6Q,
+	CODA_IMX6DL,
 };
 
 static const struct coda_devtype coda_devdata[] = {
@@ -3141,6 +3429,18 @@ static const struct coda_devtype coda_devdata[] = {
 		.codecs     = coda7_codecs,
 		.num_codecs = ARRAY_SIZE(coda7_codecs),
 	},
+	[CODA_IMX6Q] = {
+		.firmware   = "v4l-coda960-imx6q.bin",
+		.product    = CODA_960,
+		.codecs     = coda9_codecs,
+		.num_codecs = ARRAY_SIZE(coda9_codecs),
+	},
+	[CODA_IMX6DL] = {
+		.firmware   = "v4l-coda960-imx6dl.bin",
+		.product    = CODA_960,
+		.codecs     = coda9_codecs,
+		.num_codecs = ARRAY_SIZE(coda9_codecs),
+	},
 };
 
 static struct platform_device_id coda_platform_ids[] = {
@@ -3154,6 +3454,8 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
 static const struct of_device_id coda_dt_ids[] = {
 	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
 	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
+	{ .compatible = "fsl,imx6q-vpu", .data = &coda_devdata[CODA_IMX6Q] },
+	{ .compatible = "fsl,imx6dl-vpu", .data = &coda_devdata[CODA_IMX6DL] },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, coda_dt_ids);
@@ -3256,6 +3558,9 @@ static int coda_probe(struct platform_device *pdev)
 	case CODA_7541:
 		dev->tempbuf.size = CODA7_TEMP_BUF_SIZE;
 		break;
+	case CODA_960:
+		dev->tempbuf.size = CODA9_TEMP_BUF_SIZE;
+		break;
 	}
 	if (dev->tempbuf.size) {
 		ret = coda_alloc_aux_buf(dev, &dev->tempbuf,
@@ -3274,6 +3579,8 @@ static int coda_probe(struct platform_device *pdev)
 	case CODA_7541:
 		dev->iram.size = CODA7_IRAM_SIZE;
 		break;
+	case CODA_960:
+		dev->iram.size = CODA9_IRAM_SIZE;
 	}
 	dev->iram.vaddr = gen_pool_dma_alloc(dev->iram_pool, dev->iram.size,
 					     &dev->iram.paddr);
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index 4e32e2e..c791275 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -27,6 +27,14 @@
 #define CODA_REG_BIT_CODE_RESET		0x014
 #define		CODA_REG_RESET_ENABLE		(1 << 0)
 #define CODA_REG_BIT_CUR_PC			0x018
+#define CODA9_REG_BIT_SW_RESET			0x024
+#define		CODA9_SW_RESET_BPU_CORE   0x008
+#define		CODA9_SW_RESET_BPU_BUS    0x010
+#define		CODA9_SW_RESET_VCE_CORE   0x020
+#define		CODA9_SW_RESET_VCE_BUS    0x040
+#define		CODA9_SW_RESET_GDI_CORE   0x080
+#define		CODA9_SW_RESET_GDI_BUS    0x100
+#define CODA9_REG_BIT_SW_RESET_STATUS		0x034
 
 /* Static SW registers */
 #define CODA_REG_BIT_CODE_BUF_ADDR		0x100
@@ -39,9 +47,11 @@
 #define		CODADX6_STREAM_BUF_PIC_FLUSH	(1 << 2)
 #define		CODA7_STREAM_BUF_DYNALLOC_EN	(1 << 5)
 #define		CODADX6_STREAM_BUF_DYNALLOC_EN	(1 << 4)
-#define 	CODA_STREAM_CHKDIS_OFFSET	(1 << 1)
+#define		CODADX6_STREAM_CHKDIS_OFFSET	(1 << 1)
+#define		CODA7_STREAM_SEL_64BITS_ENDIAN	(1 << 1)
 #define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
+#define		CODA_FRAME_CHROMA_INTERLEAVE	(1 << 2)
 #define		CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
 #define CODA_REG_BIT_BIT_STREAM_PARAM		0x114
 #define		CODA_BIT_STREAM_END_FLAG	(1 << 2)
@@ -52,13 +62,21 @@
 #define CODA_REG_BIT_FRM_DIS_FLG(x)		(0x150 + 4 * (x))
 #define CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR	0x140
 #define CODA7_REG_BIT_AXI_SRAM_USE		0x140
+#define		CODA9_USE_HOST_BTP_ENABLE	(1 << 13)
+#define		CODA9_USE_HOST_OVL_ENABLE	(1 << 12)
 #define		CODA7_USE_HOST_ME_ENABLE	(1 << 11)
+#define		CODA9_USE_HOST_DBK_ENABLE	(3 << 10)
 #define		CODA7_USE_HOST_OVL_ENABLE	(1 << 10)
 #define		CODA7_USE_HOST_DBK_ENABLE	(1 << 9)
+#define		CODA9_USE_HOST_IP_ENABLE	(1 << 9)
 #define		CODA7_USE_HOST_IP_ENABLE	(1 << 8)
+#define		CODA9_USE_HOST_BIT_ENABLE	(1 << 8)
 #define		CODA7_USE_HOST_BIT_ENABLE	(1 << 7)
+#define		CODA9_USE_BTP_ENABLE		(1 << 5)
 #define		CODA7_USE_ME_ENABLE		(1 << 4)
+#define		CODA9_USE_OVL_ENABLE		(1 << 4)
 #define		CODA7_USE_OVL_ENABLE		(1 << 3)
+#define		CODA9_USE_DBK_ENABLE		(3 << 2)
 #define		CODA7_USE_DBK_ENABLE		(1 << 2)
 #define		CODA7_USE_IP_ENABLE		(1 << 1)
 #define		CODA7_USE_BIT_ENABLE		(1 << 0)
@@ -93,6 +111,18 @@
 #define		CODA7_MODE_ENCODE_H264		8
 #define		CODA7_MODE_ENCODE_MP4		11
 #define		CODA7_MODE_ENCODE_MJPG		13
+#define		CODA9_MODE_DECODE_H264		0
+#define		CODA9_MODE_DECODE_VC1		1
+#define		CODA9_MODE_DECODE_MP2		2
+#define		CODA9_MODE_DECODE_MP4		3
+#define		CODA9_MODE_DECODE_DV3		3
+#define		CODA9_MODE_DECODE_RV		4
+#define		CODA9_MODE_DECODE_AVS		5
+#define		CODA9_MODE_DECODE_MJPG		6
+#define		CODA9_MODE_DECODE_VPX		7
+#define		CODA9_MODE_ENCODE_H264		8
+#define		CODA9_MODE_ENCODE_MP4		11
+#define		CODA9_MODE_ENCODE_MJPG		13
 #define 	CODA_MODE_INVALID		0xffff
 #define CODA_REG_BIT_INT_ENABLE		0x170
 #define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
@@ -129,6 +159,7 @@
 #define CODA_CMD_DEC_SEQ_SPP_CHUNK_SIZE		0x1a0
 
 #define CODA7_RET_DEC_SEQ_ASPECT		0x1b0
+#define CODA9_RET_DEC_SEQ_BITRATE		0x1b4
 #define CODA_RET_DEC_SEQ_SUCCESS		0x1c0
 #define CODA_RET_DEC_SEQ_SRC_FMT		0x1c4 /* SRC_SIZE on CODA7 */
 #define CODA_RET_DEC_SEQ_SRC_SIZE		0x1c4
@@ -145,13 +176,19 @@
 #define CODA_RET_DEC_SEQ_FRATE_DR		0x1e8
 #define CODA_RET_DEC_SEQ_JPG_PARA		0x1e4
 #define CODA_RET_DEC_SEQ_JPG_THUMB_IND		0x1e8
+#define CODA9_RET_DEC_SEQ_HEADER_REPORT		0x1ec
 
 /* Decoder Picture Run */
 #define CODA_CMD_DEC_PIC_ROT_MODE		0x180
 #define CODA_CMD_DEC_PIC_ROT_ADDR_Y		0x184
+#define CODA9_CMD_DEC_PIC_ROT_INDEX		0x184
 #define CODA_CMD_DEC_PIC_ROT_ADDR_CB		0x188
+#define CODA9_CMD_DEC_PIC_ROT_ADDR_Y		0x188
 #define CODA_CMD_DEC_PIC_ROT_ADDR_CR		0x18c
+#define CODA9_CMD_DEC_PIC_ROT_ADDR_CB		0x18c
 #define CODA_CMD_DEC_PIC_ROT_STRIDE		0x190
+#define CODA9_CMD_DEC_PIC_ROT_ADDR_CR		0x190
+#define CODA9_CMD_DEC_PIC_ROT_STRIDE		0x1b8
 
 #define CODA_CMD_DEC_PIC_OPTION			0x194
 #define		CODA_PRE_SCAN_EN			(1 << 0)
@@ -183,25 +220,39 @@
 #define CODA_RET_DEC_PIC_CROP_TOP_BOTTOM	0x1e4
 #define CODA_RET_DEC_PIC_FRAME_NEED		0x1ec
 
+#define CODA9_RET_DEC_PIC_VP8_PIC_REPORT	0x1e8
+#define CODA9_RET_DEC_PIC_ASPECT		0x1f0
+#define CODA9_RET_DEC_PIC_VP8_SCALE_INFO	0x1f0
+#define CODA9_RET_DEC_PIC_FRATE_NR		0x1f4
+#define CODA9_RET_DEC_PIC_FRATE_DR		0x1f8
+
 /* Encoder Sequence Initialization */
 #define CODA_CMD_ENC_SEQ_BB_START				0x180
 #define CODA_CMD_ENC_SEQ_BB_SIZE				0x184
 #define CODA_CMD_ENC_SEQ_OPTION				0x188
 #define		CODA7_OPTION_AVCINTRA16X16ONLY_OFFSET		9
+#define		CODA9_OPTION_MVC_PREFIX_NAL_OFFSET		9
 #define		CODA7_OPTION_GAMMA_OFFSET			8
+#define		CODA9_OPTION_MVC_PARASET_REFRESH_OFFSET		8
 #define		CODA7_OPTION_RCQPMAX_OFFSET			7
+#define		CODA9_OPTION_GAMMA_OFFSET			7
 #define		CODADX6_OPTION_GAMMA_OFFSET			7
 #define		CODA7_OPTION_RCQPMIN_OFFSET			6
+#define		CODA9_OPTION_RCQPMAX_OFFSET			6
 #define		CODA_OPTION_LIMITQP_OFFSET			6
 #define		CODA_OPTION_RCINTRAQP_OFFSET			5
 #define		CODA_OPTION_FMO_OFFSET				4
+#define		CODA9_OPTION_MVC_INTERVIEW_OFFSET		4
 #define		CODA_OPTION_AVC_AUD_OFFSET			2
 #define		CODA_OPTION_SLICEREPORT_OFFSET			1
 #define CODA_CMD_ENC_SEQ_COD_STD				0x18c
 #define		CODA_STD_MPEG4					0
+#define		CODA9_STD_H264					0
 #define		CODA_STD_H263					1
 #define		CODA_STD_H264					2
 #define		CODA_STD_MJPG					3
+#define		CODA9_STD_MPEG4					3
+
 #define CODA_CMD_ENC_SEQ_SRC_SIZE				0x190
 #define		CODA7_PICWIDTH_OFFSET				16
 #define		CODA7_PICWIDTH_MASK				0xffff
@@ -268,15 +319,26 @@
 #define CODA7_CMD_ENC_SEQ_SEARCH_BASE				0x1b8
 #define CODA7_CMD_ENC_SEQ_SEARCH_SIZE				0x1bc
 #define CODA7_CMD_ENC_SEQ_INTRA_QP				0x1c4
-#define CODA_CMD_ENC_SEQ_RC_QP_MAX				0x1c8
+#define CODA_CMD_ENC_SEQ_RC_QP_MIN_MAX				0x1c8
+#define		CODA_QPMIN_OFFSET				8
+#define		CODA_QPMIN_MASK					0x3f
 #define		CODA_QPMAX_OFFSET				0
 #define		CODA_QPMAX_MASK					0x3f
 #define CODA_CMD_ENC_SEQ_RC_GAMMA				0x1cc
 #define		CODA_GAMMA_OFFSET				0
 #define		CODA_GAMMA_MASK					0xffff
+#define CODA_CMD_ENC_SEQ_RC_INTERVAL_MODE			0x1d0
+#define CODA9_CMD_ENC_SEQ_INTRA_WEIGHT				0x1d4
+#define CODA9_CMD_ENC_SEQ_ME_OPTION				0x1d8
 #define CODA_RET_ENC_SEQ_SUCCESS				0x1c0
 
 /* Encoder Picture Run */
+#define CODA9_CMD_ENC_PIC_SRC_INDEX		0x180
+#define CODA9_CMD_ENC_PIC_SRC_STRIDE		0x184
+#define CODA9_CMD_ENC_PIC_SUB_FRAME_SYNC	0x1a4
+#define CODA9_CMD_ENC_PIC_SRC_ADDR_Y		0x1a8
+#define CODA9_CMD_ENC_PIC_SRC_ADDR_CB		0x1ac
+#define CODA9_CMD_ENC_PIC_SRC_ADDR_CR		0x1b0
 #define CODA_CMD_ENC_PIC_SRC_ADDR_Y	0x180
 #define CODA_CMD_ENC_PIC_SRC_ADDR_CB	0x184
 #define CODA_CMD_ENC_PIC_SRC_ADDR_CR	0x188
@@ -291,7 +353,11 @@
 #define		CODA_MIR_VER					(0x1 << 2)
 #define		CODA_MIR_HOR					(0x2 << 2)
 #define		CODA_MIR_VER_HOR				(0x3 << 2)
-#define CODA_CMD_ENC_PIC_OPTION	0x194
+#define CODA_CMD_ENC_PIC_OPTION		0x194
+#define		CODA_FORCE_IPICTURE				BIT(1)
+#define		CODA_REPORT_MB_INFO				BIT(3)
+#define		CODA_REPORT_MV_INFO				BIT(4)
+#define		CODA_REPORT_SLICE_INFO				BIT(5)
 #define CODA_CMD_ENC_PIC_BB_START	0x198
 #define CODA_CMD_ENC_PIC_BB_SIZE	0x19c
 #define CODA_RET_ENC_FRAME_NUM		0x1c0
@@ -306,13 +372,30 @@
 #define CODA_CMD_SET_FRAME_BUF_STRIDE		0x184
 #define CODA_CMD_SET_FRAME_SLICE_BB_START	0x188
 #define CODA_CMD_SET_FRAME_SLICE_BB_SIZE	0x18c
+#define CODA9_CMD_SET_FRAME_SUBSAMP_A		0x188
+#define CODA9_CMD_SET_FRAME_SUBSAMP_B		0x18c
 #define CODA7_CMD_SET_FRAME_AXI_BIT_ADDR	0x190
 #define CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR	0x194
 #define CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR	0x198
 #define CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR	0x19c
 #define CODA7_CMD_SET_FRAME_AXI_OVL_ADDR	0x1a0
 #define CODA7_CMD_SET_FRAME_MAX_DEC_SIZE	0x1a4
+#define CODA9_CMD_SET_FRAME_AXI_BTP_ADDR	0x1a4
 #define CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE	0x1a8
+#define CODA9_CMD_SET_FRAME_CACHE_SIZE		0x1a8
+#define CODA9_CMD_SET_FRAME_CACHE_CONFIG	0x1ac
+#define		CODA9_CACHE_BYPASS_OFFSET		28
+#define		CODA9_CACHE_DUALCONF_OFFSET		26
+#define		CODA9_CACHE_PAGEMERGE_OFFSET		24
+#define		CODA9_CACHE_LUMA_BUFFER_SIZE_OFFSET	16
+#define		CODA9_CACHE_CB_BUFFER_SIZE_OFFSET	8
+#define		CODA9_CACHE_CR_BUFFER_SIZE_OFFSET	0
+#define CODA9_CMD_SET_FRAME_SUBSAMP_A_MVC	0x1b0
+#define CODA9_CMD_SET_FRAME_SUBSAMP_B_MVC	0x1b4
+#define CODA9_CMD_SET_FRAME_DP_BUF_BASE		0x1b0
+#define CODA9_CMD_SET_FRAME_DP_BUF_SIZE		0x1b4
+#define CODA9_CMD_SET_FRAME_MAX_DEC_SIZE	0x1b8
+#define CODA9_CMD_SET_FRAME_DELAY		0x1bc
 
 /* Encoder Header */
 #define CODA_CMD_ENC_HEADER_CODE	0x180
@@ -322,8 +405,11 @@
 #define		CODA_HEADER_MP4V_VOL	0
 #define		CODA_HEADER_MP4V_VOS	1
 #define		CODA_HEADER_MP4V_VIS	2
+#define		CODA9_HEADER_FRAME_CROP	(1 << 3)
 #define CODA_CMD_ENC_HEADER_BB_START	0x184
 #define CODA_CMD_ENC_HEADER_BB_SIZE	0x188
+#define CODA9_CMD_ENC_HEADER_FRAME_CROP_H	0x18c
+#define CODA9_CMD_ENC_HEADER_FRAME_CROP_V	0x190
 
 /* Get Version */
 #define CODA_CMD_FIRMWARE_VERNUM		0x1c0
@@ -334,5 +420,28 @@
 #define		CODA_FIRMWARE_VERNUM(product, major, minor, release)	\
 			((product) << 16 | ((major) << 12) |		\
 			((minor) << 8) | (release))
+#define CODA9_CMD_FIRMWARE_CODE_REV		0x1c4
+
+#define CODA9_GDMA_BASE				0x1000
+#define CODA9_GDI_WPROT_ERR_CLR			(CODA9_GDMA_BASE + 0x0a0)
+#define CODA9_GDI_WPROT_RGN_EN			(CODA9_GDMA_BASE + 0x0ac)
+
+#define CODA9_GDI_BUS_CTRL			(CODA9_GDMA_BASE + 0x0f0)
+#define CODA9_GDI_BUS_STATUS			(CODA9_GDMA_BASE + 0x0f4)
+
+#define CODA9_GDI_XY2_CAS_0			(CODA9_GDMA_BASE + 0x800)
+#define CODA9_GDI_XY2_CAS_F			(CODA9_GDMA_BASE + 0x83c)
+
+#define CODA9_GDI_XY2_BA_0			(CODA9_GDMA_BASE + 0x840)
+#define CODA9_GDI_XY2_BA_1			(CODA9_GDMA_BASE + 0x844)
+#define CODA9_GDI_XY2_BA_2			(CODA9_GDMA_BASE + 0x848)
+#define CODA9_GDI_XY2_BA_3			(CODA9_GDMA_BASE + 0x84c)
+
+#define CODA9_GDI_XY2_RAS_0			(CODA9_GDMA_BASE + 0x850)
+#define CODA9_GDI_XY2_RAS_F			(CODA9_GDMA_BASE + 0x88c)
+
+#define CODA9_GDI_XY2_RBC_CONFIG		(CODA9_GDMA_BASE + 0x890)
+#define CODA9_GDI_RBC2_AXI_0			(CODA9_GDMA_BASE + 0x8a0)
+#define CODA9_GDI_RBC2_AXI_1F			(CODA9_GDMA_BASE + 0x91c)
 
 #endif
-- 
2.0.0.rc2


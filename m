Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:38779 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752786AbdLMOJh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:09:37 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] media: coda: Add i.MX51 (CodaHx4) support
Date: Wed, 13 Dec 2017 15:09:18 +0100
Message-Id: <20171213140918.22500-2-p.zabel@pengutronix.de>
In-Reply-To: <20171213140918.22500-1-p.zabel@pengutronix.de>
References: <20171213140918.22500-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for the CodaHx4 VPU used on i.MX51.

Decoding h.264, MPEG-4, and MPEG-2 video works, as well as encoding
h.264. MPEG-4 encoding is not enabled, it currently produces visual
artifacts.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c    | 45 ++++++++++++++++++++++---------
 drivers/media/platform/coda/coda-common.c | 44 +++++++++++++++++++++++++++---
 drivers/media/platform/coda/coda.h        |  1 +
 3 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index bfc4ecf6f068b..393d8a1a2a67c 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -68,8 +68,9 @@ static void coda_command_async(struct coda_ctx *ctx, int cmd)
 {
 	struct coda_dev *dev = ctx->dev;
 
-	if (dev->devtype->product == CODA_960 ||
-	    dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_HX4 ||
+	    dev->devtype->product == CODA_7541 ||
+	    dev->devtype->product == CODA_960) {
 		/* Restore context related registers to CODA */
 		coda_write(dev, ctx->bit_stream_param,
 				CODA_REG_BIT_BIT_STREAM_PARAM);
@@ -505,7 +506,8 @@ static int coda_alloc_context_buffers(struct coda_ctx *ctx,
 			goto err;
 	}
 
-	if (!ctx->psbuf.vaddr && dev->devtype->product == CODA_7541) {
+	if (!ctx->psbuf.vaddr && (dev->devtype->product == CODA_HX4 ||
+				  dev->devtype->product == CODA_7541)) {
 		ret = coda_alloc_context_buf(ctx, &ctx->psbuf,
 					     CODA7_PS_BUF_SIZE, "psbuf");
 		if (ret < 0)
@@ -593,6 +595,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 	int dbk_bits;
 	int bit_bits;
 	int ip_bits;
+	int me_bits;
 
 	memset(iram_info, 0, sizeof(*iram_info));
 	iram_info->next_paddr = dev->iram.paddr;
@@ -602,10 +605,17 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		return;
 
 	switch (dev->devtype->product) {
+	case CODA_HX4:
+		dbk_bits = CODA7_USE_HOST_DBK_ENABLE;
+		bit_bits = CODA7_USE_HOST_BIT_ENABLE;
+		ip_bits = CODA7_USE_HOST_IP_ENABLE;
+		me_bits = CODA7_USE_HOST_ME_ENABLE;
+		break;
 	case CODA_7541:
 		dbk_bits = CODA7_USE_HOST_DBK_ENABLE | CODA7_USE_DBK_ENABLE;
 		bit_bits = CODA7_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
 		ip_bits = CODA7_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;
+		me_bits = CODA7_USE_HOST_ME_ENABLE | CODA7_USE_ME_ENABLE;
 		break;
 	case CODA_960:
 		dbk_bits = CODA9_USE_HOST_DBK_ENABLE | CODA9_USE_DBK_ENABLE;
@@ -625,7 +635,8 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		w64 = mb_width * 64;
 
 		/* Prioritize in case IRAM is too small for everything */
-		if (dev->devtype->product == CODA_7541) {
+		if (dev->devtype->product == CODA_HX4 ||
+		    dev->devtype->product == CODA_7541) {
 			iram_info->search_ram_size = round_up(mb_width * 16 *
 							      36 + 2048, 1024);
 			iram_info->search_ram_paddr = coda_iram_alloc(iram_info,
@@ -634,8 +645,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 				pr_err("IRAM is smaller than the search ram size\n");
 				goto out;
 			}
-			iram_info->axi_sram_use |= CODA7_USE_HOST_ME_ENABLE |
-						   CODA7_USE_ME_ENABLE;
+			iram_info->axi_sram_use |= me_bits;
 		}
 
 		/* Only H.264BP and H.263P3 are considered */
@@ -687,7 +697,8 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "IRAM smaller than needed\n");
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_HX4 ||
+	    dev->devtype->product == CODA_7541) {
 		/* TODO - Enabling these causes picture errors on CODA7541 */
 		if (ctx->inst_type == CODA_INST_DECODER) {
 			/* fw 1.4.50 */
@@ -705,6 +716,7 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 
 static u32 coda_supported_firmwares[] = {
 	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
+	CODA_FIRMWARE_VERNUM(CODA_HX4, 1, 4, 50),
 	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
 	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
 	CODA_FIRMWARE_VERNUM(CODA_960, 2, 3, 10),
@@ -889,6 +901,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	case CODA_960:
 		coda_write(dev, 0, CODA9_GDI_WPROT_RGN_EN);
 		/* fallthrough */
+	case CODA_HX4:
 	case CODA_7541:
 		coda_write(dev, CODA7_STREAM_BUF_DYNALLOC_EN |
 			CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
@@ -918,6 +931,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 		value |= (q_data_src->height & CODADX6_PICHEIGHT_MASK)
 			 << CODA_PICHEIGHT_OFFSET;
 		break;
+	case CODA_HX4:
 	case CODA_7541:
 		if (dst_fourcc == V4L2_PIX_FMT_H264) {
 			value = (round_up(q_data_src->width, 16) &
@@ -1085,6 +1099,7 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 			value = FMO_SLICE_SAVE_BUF_SIZE << 7;
 			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
 			break;
+		case CODA_HX4:
 		case CODA_7541:
 			coda_write(dev, ctx->iram_info.search_ram_paddr,
 					CODA7_CMD_ENC_SEQ_SEARCH_BASE);
@@ -1130,7 +1145,8 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	coda_write(dev, num_fb, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, stride, CODA_CMD_SET_FRAME_BUF_STRIDE);
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_HX4 ||
+	    dev->devtype->product == CODA_7541) {
 		coda_write(dev, q_data_src->bytesperline,
 				CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
 	}
@@ -1569,7 +1585,8 @@ static bool coda_reorder_enable(struct coda_ctx *ctx)
 	struct coda_dev *dev = ctx->dev;
 	int profile, level;
 
-	if (dev->devtype->product != CODA_7541 &&
+	if (dev->devtype->product != CODA_HX4 &&
+	    dev->devtype->product != CODA_7541 &&
 	    dev->devtype->product != CODA_960)
 		return false;
 
@@ -1663,7 +1680,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 			   CODA_CMD_DEC_SEQ_MP4_ASP_CLASS);
 	}
 	if (src_fourcc == V4L2_PIX_FMT_H264) {
-		if (dev->devtype->product == CODA_7541) {
+		if (dev->devtype->product == CODA_HX4 ||
+		    dev->devtype->product == CODA_7541) {
 			coda_write(dev, ctx->psbuf.paddr,
 					CODA_CMD_DEC_SEQ_PS_BB_START);
 			coda_write(dev, (CODA7_PS_BUF_SIZE / 1024),
@@ -1790,7 +1808,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 				CODA_CMD_SET_FRAME_SLICE_BB_SIZE);
 	}
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_HX4 ||
+	    dev->devtype->product == CODA_7541) {
 		int max_mb_x = 1920 / 16;
 		int max_mb_y = 1088 / 16;
 		int max_mb_num = max_mb_x * max_mb_y;
@@ -1908,6 +1927,7 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	switch (dev->devtype->product) {
 	case CODA_DX6:
 		/* TBD */
+	case CODA_HX4:
 	case CODA_7541:
 		coda_write(dev, CODA_PRE_SCAN_EN, CODA_CMD_DEC_PIC_OPTION);
 		break;
@@ -2048,7 +2068,8 @@ static void coda_finish_decode(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev,
 			 "errors in %d macroblocks\n", err_mb);
 
-	if (dev->devtype->product == CODA_7541) {
+	if (dev->devtype->product == CODA_HX4 ||
+	    dev->devtype->product == CODA_7541) {
 		val = coda_read(dev, CODA_RET_DEC_PIC_OPTION);
 		if (val == 0) {
 			/* not enough bitstream data */
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 15eb5dc4dff9a..3573fb2599ea6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -128,7 +128,8 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 /*
  * Arrays of codecs supported by each given version of Coda:
  *  i.MX27 -> codadx6
- *  i.MX5x -> coda7
+ *  i.MX51 -> codahx4
+ *  i.MX53 -> coda7
  *  i.MX6  -> coda960
  * Use V4L2_PIX_FMT_YUV420 as placeholder for all supported YUV 4:2:0 variants
  */
@@ -137,6 +138,13 @@ static const struct coda_codec codadx6_codecs[] = {
 	CODA_CODEC(CODADX6_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4, 720, 576),
 };
 
+static const struct coda_codec codahx4_codecs[] = {
+	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   720, 576),
+	CODA_CODEC(CODA7_MODE_DECODE_H264, V4L2_PIX_FMT_H264,   V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA7_MODE_DECODE_MP2,  V4L2_PIX_FMT_MPEG2,  V4L2_PIX_FMT_YUV420, 1920, 1088),
+	CODA_CODEC(CODA7_MODE_DECODE_MP4,  V4L2_PIX_FMT_MPEG4,  V4L2_PIX_FMT_YUV420, 1280, 720),
+};
+
 static const struct coda_codec coda7_codecs[] = {
 	CODA_CODEC(CODA7_MODE_ENCODE_H264, V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_H264,   1280, 720),
 	CODA_CODEC(CODA7_MODE_ENCODE_MP4,  V4L2_PIX_FMT_YUV420, V4L2_PIX_FMT_MPEG4,  1280, 720),
@@ -234,6 +242,11 @@ static const struct coda_video_device *codadx6_video_devices[] = {
 	&coda_bit_encoder,
 };
 
+static const struct coda_video_device *codahx4_video_devices[] = {
+	&coda_bit_encoder,
+	&coda_bit_decoder,
+};
+
 static const struct coda_video_device *coda7_video_devices[] = {
 	&coda_bit_jpeg_encoder,
 	&coda_bit_jpeg_decoder,
@@ -332,6 +345,8 @@ const char *coda_product_name(int product)
 	switch (product) {
 	case CODA_DX6:
 		return "CodaDx6";
+	case CODA_HX4:
+		return "CodaHx4";
 	case CODA_7541:
 		return "CODA7541";
 	case CODA_960:
@@ -1774,7 +1789,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
 		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
-	if (ctx->dev->devtype->product == CODA_7541) {
+	if (ctx->dev->devtype->product == CODA_HX4 ||
+	    ctx->dev->devtype->product == CODA_7541) {
 		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_H264_LEVEL,
 			V4L2_MPEG_VIDEO_H264_LEVEL_3_1,
@@ -1802,7 +1818,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE,
 		V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE, 0x0,
 		V4L2_MPEG_VIDEO_MPEG4_PROFILE_SIMPLE);
-	if (ctx->dev->devtype->product == CODA_7541 ||
+	if (ctx->dev->devtype->product == CODA_HX4 ||
+	    ctx->dev->devtype->product == CODA_7541 ||
 	    ctx->dev->devtype->product == CODA_960) {
 		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL,
@@ -1997,6 +2014,7 @@ static int coda_open(struct file *file)
 		if (enable_bwb || ctx->inst_type == CODA_INST_ENCODER)
 			ctx->frame_mem_ctrl = CODA9_FRAME_ENABLE_BWB;
 		/* fallthrough */
+	case CODA_HX4:
 	case CODA_7541:
 		ctx->reg_idx = 0;
 		break;
@@ -2175,7 +2193,8 @@ static int coda_hw_init(struct coda_dev *dev)
 
 	/* Tell the BIT where to find everything it needs */
 	if (dev->devtype->product == CODA_960 ||
-	    dev->devtype->product == CODA_7541) {
+	    dev->devtype->product == CODA_7541 ||
+	    dev->devtype->product == CODA_HX4) {
 		coda_write(dev, dev->tempbuf.paddr,
 				CODA_REG_BIT_TEMP_BUF_ADDR);
 		coda_write(dev, 0, CODA_REG_BIT_BIT_STREAM_PARAM);
@@ -2380,6 +2399,7 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 
 enum coda_platform {
 	CODA_IMX27,
+	CODA_IMX51,
 	CODA_IMX53,
 	CODA_IMX6Q,
 	CODA_IMX6DL,
@@ -2400,6 +2420,21 @@ static const struct coda_devtype coda_devdata[] = {
 		.workbuf_size = 288 * 1024 + FMO_SLICE_SAVE_BUF_SIZE * 8 * 1024,
 		.iram_size    = 0xb000,
 	},
+	[CODA_IMX51] = {
+		.firmware     = {
+			"vpu_fw_imx51.bin",
+			"vpu/vpu_fw_imx51.bin",
+			"v4l-codahx4-imx51.bin"
+		},
+		.product      = CODA_HX4,
+		.codecs       = codahx4_codecs,
+		.num_codecs   = ARRAY_SIZE(codahx4_codecs),
+		.vdevs        = codahx4_video_devices,
+		.num_vdevs    = ARRAY_SIZE(codahx4_video_devices),
+		.workbuf_size = 128 * 1024,
+		.tempbuf_size = 304 * 1024,
+		.iram_size    = 0x14000,
+	},
 	[CODA_IMX53] = {
 		.firmware     = {
 			"vpu_fw_imx53.bin",
@@ -2456,6 +2491,7 @@ MODULE_DEVICE_TABLE(platform, coda_platform_ids);
 #ifdef CONFIG_OF
 static const struct of_device_id coda_dt_ids[] = {
 	{ .compatible = "fsl,imx27-vpu", .data = &coda_devdata[CODA_IMX27] },
+	{ .compatible = "fsl,imx51-vpu", .data = &coda_devdata[CODA_IMX51] },
 	{ .compatible = "fsl,imx53-vpu", .data = &coda_devdata[CODA_IMX53] },
 	{ .compatible = "fsl,imx6q-vpu", .data = &coda_devdata[CODA_IMX6Q] },
 	{ .compatible = "fsl,imx6dl-vpu", .data = &coda_devdata[CODA_IMX6DL] },
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c5f504d8cf67f..12fab3f1dbfed 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -43,6 +43,7 @@ enum coda_inst_type {
 
 enum coda_product {
 	CODA_DX6 = 0xf001,
+	CODA_HX4 = 0xf00a,
 	CODA_7541 = 0xf012,
 	CODA_960 = 0xf020,
 };
-- 
2.11.0

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51410 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaESMuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:50:11 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 1/2] [media] s5p-mfc: Core support to add v8 decoder
Date: Mon, 19 May 2014 18:20:01 +0530
Message-Id: <1400503802-5543-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400503802-5543-1-git-send-email-arun.kk@samsung.com>
References: <1400503802-5543-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kiran AVND <avnd.kiran@samsung.com>

This patch adds variant data and core support for
V8 decoder. This patch also adds the register definition
file for new firmware version v8 for MFC.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          |    3 +-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h       |   94 ++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   31 +++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |    5 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   28 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |   85 ++++++++++++++++--
 6 files changed, 223 insertions(+), 23 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v8.h

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index f418168..3e3c5f3 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -10,7 +10,8 @@ Required properties:
   - compatible : value should be either one among the following
 	(a) "samsung,mfc-v5" for MFC v5 present in Exynos4 SoCs
 	(b) "samsung,mfc-v6" for MFC v6 present in Exynos5 SoCs
-	(b) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
+	(c) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
+	(d) "samsung,mfc-v8" for MFC v8 present in Exynos5800 SoC
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v8.h b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
new file mode 100644
index 0000000..c84d120
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v8.h
@@ -0,0 +1,94 @@
+/*
+ * Register definition file for Samsung MFC V8.x Interface (FIMV) driver
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGS_MFC_V8_H
+#define _REGS_MFC_V8_H
+
+#include <linux/sizes.h>
+#include "regs-mfc-v7.h"
+
+/* Additional registers for v8 */
+#define S5P_FIMV_D_MVC_NUM_VIEWS_V8		0xf104
+#define S5P_FIMV_D_FIRST_PLANE_DPB_SIZE_V8	0xf144
+#define S5P_FIMV_D_SECOND_PLANE_DPB_SIZE_V8	0xf148
+#define S5P_FIMV_D_MV_BUFFER_SIZE_V8		0xf150
+
+#define S5P_FIMV_D_FIRST_PLANE_DPB_STRIDE_SIZE_V8	0xf138
+#define S5P_FIMV_D_SECOND_PLANE_DPB_STRIDE_SIZE_V8	0xf13c
+
+#define S5P_FIMV_D_FIRST_PLANE_DPB_V8		0xf160
+#define S5P_FIMV_D_SECOND_PLANE_DPB_V8		0xf260
+#define S5P_FIMV_D_MV_BUFFER_V8			0xf460
+
+#define S5P_FIMV_D_NUM_MV_V8			0xf134
+#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V8	0xf154
+
+#define S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V8	0xf560
+#define S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V8	0xf564
+
+#define S5P_FIMV_D_CPB_BUFFER_ADDR_V8		0xf5b0
+#define S5P_FIMV_D_CPB_BUFFER_SIZE_V8		0xf5b4
+#define S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V8	0xf5bc
+#define S5P_FIMV_D_CPB_BUFFER_OFFSET_V8		0xf5c0
+#define S5P_FIMV_D_SLICE_IF_ENABLE_V8		0xf5c4
+#define S5P_FIMV_D_STREAM_DATA_SIZE_V8		0xf5d0
+
+/* Display information register */
+#define S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V8	0xf600
+#define S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V8	0xf604
+
+/* Display status */
+#define S5P_FIMV_D_DISPLAY_STATUS_V8		0xf608
+
+#define S5P_FIMV_D_DISPLAY_FIRST_PLANE_ADDR_V8	0xf60c
+#define S5P_FIMV_D_DISPLAY_SECOND_PLANE_ADDR_V8	0xf610
+
+#define S5P_FIMV_D_DISPLAY_FRAME_TYPE_V8	0xf618
+#define S5P_FIMV_D_DISPLAY_CROP_INFO1_V8	0xf61c
+#define S5P_FIMV_D_DISPLAY_CROP_INFO2_V8	0xf620
+#define S5P_FIMV_D_DISPLAY_PICTURE_PROFILE_V8	0xf624
+
+/* Decoded picture information register */
+#define S5P_FIMV_D_DECODED_STATUS_V8		0xf644
+#define S5P_FIMV_D_DECODED_FIRST_PLANE_ADDR_V8	0xf648
+#define S5P_FIMV_D_DECODED_SECOND_PLANE_ADDR_V8	0xf64c
+#define S5P_FIMV_D_DECODED_THIRD_PLANE_ADDR_V8	0xf650
+#define S5P_FIMV_D_DECODED_FRAME_TYPE_V8	0xf654
+#define S5P_FIMV_D_DECODED_NAL_SIZE_V8          0xf664
+
+/* Returned value register for specific setting */
+#define S5P_FIMV_D_RET_PICTURE_TAG_TOP_V8	0xf674
+#define S5P_FIMV_D_RET_PICTURE_TAG_BOT_V8	0xf678
+#define S5P_FIMV_D_MVC_VIEW_ID_V8		0xf6d8
+
+/* SEI related information */
+#define S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V8	0xf6dc
+
+/* MFCv8 Context buffer sizes */
+#define MFC_CTX_BUF_SIZE_V8		(30 * SZ_1K)	/*  30KB */
+#define MFC_H264_DEC_CTX_BUF_SIZE_V8	(2 * SZ_1M)	/*  2MB */
+#define MFC_OTHER_DEC_CTX_BUF_SIZE_V8	(20 * SZ_1K)	/*  20KB */
+
+/* Buffer size defines */
+#define S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V8(w, h)	(((w) * 704) + 2176)
+#define S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V8(w, h) \
+		(((w) * 576 + (h) * 128)  + 4128)
+
+/* BUffer alignment defines */
+#define S5P_FIMV_D_ALIGN_PLANE_SIZE_V8	64
+
+/* MFCv8 variant defines */
+#define MAX_FW_SIZE_V8			(SZ_1M)		/* 1MB */
+#define MAX_CPB_SIZE_V8			(3 * SZ_1M)	/* 3MB */
+#define MFC_VERSION_V8			0x80
+#define MFC_NUM_PORTS_V8		1
+
+#endif /*_REGS_MFC_V8_H*/
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 06d2678..6c466a3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1400,6 +1400,31 @@ static struct s5p_mfc_variant mfc_drvdata_v7 = {
 	.fw_name        = "s5p-mfc-v7.fw",
 };
 
+struct s5p_mfc_buf_size_v6 mfc_buf_size_v8 = {
+	.dev_ctx	= MFC_CTX_BUF_SIZE_V8,
+	.h264_dec_ctx	= MFC_H264_DEC_CTX_BUF_SIZE_V8,
+	.other_dec_ctx	= MFC_OTHER_DEC_CTX_BUF_SIZE_V8,
+};
+
+struct s5p_mfc_buf_size buf_size_v8 = {
+	.fw	= MAX_FW_SIZE_V8,
+	.cpb	= MAX_CPB_SIZE_V8,
+	.priv	= &mfc_buf_size_v8,
+};
+
+struct s5p_mfc_buf_align mfc_buf_align_v8 = {
+	.base = 0,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v8 = {
+	.version	= MFC_VERSION_V8,
+	.version_bit	= MFC_V8,
+	.port_num	= MFC_NUM_PORTS_V8,
+	.buf_size	= &buf_size_v8,
+	.buf_align	= &mfc_buf_align_v8,
+	.fw_name        = "s5p-mfc-v8.fw",
+};
+
 static struct platform_device_id mfc_driver_ids[] = {
 	{
 		.name = "s5p-mfc",
@@ -1413,6 +1438,9 @@ static struct platform_device_id mfc_driver_ids[] = {
 	}, {
 		.name = "s5p-mfc-v7",
 		.driver_data = (unsigned long)&mfc_drvdata_v7,
+	}, {
+		.name = "s5p-mfc-v8",
+		.driver_data = (unsigned long)&mfc_drvdata_v8,
 	},
 	{},
 };
@@ -1428,6 +1456,9 @@ static const struct of_device_id exynos_mfc_match[] = {
 	}, {
 		.compatible = "samsung,mfc-v7",
 		.data = &mfc_drvdata_v7,
+	}, {
+		.compatible = "samsung,mfc-v8",
+		.data = &mfc_drvdata_v8,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index bee0538..89681c3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -23,8 +23,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-core.h>
 #include "regs-mfc.h"
-#include "regs-mfc-v6.h"
-#include "regs-mfc-v7.h"
+#include "regs-mfc-v8.h"
 
 /* Definitions related to MFC memory */
 
@@ -704,10 +703,12 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
 #define IS_TWOPORT(dev)		(dev->variant->port_num == 2 ? 1 : 0)
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
 #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
+#define IS_MFCV8(dev)		(dev->variant->version >= 0x80 ? 1 : 0)
 
 #define MFC_V5	BIT(0)
 #define MFC_V6	BIT(1)
 #define MFC_V7	BIT(2)
+#define MFC_V8	BIT(3)
 
 
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index a1fee39..5bc87df 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -55,7 +55,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V6 | MFC_V7,
+		.versions	= MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -63,7 +63,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V6 | MFC_V7,
+		.versions	= MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -71,7 +71,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "H264/MVC Encoded Stream",
@@ -79,7 +79,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_MVC_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V6 | MFC_V7,
+		.versions	= MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -87,7 +87,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "MPEG1 Encoded Stream",
@@ -95,7 +95,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "MPEG2 Encoded Stream",
@@ -103,7 +103,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -111,7 +111,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "XviD Encoded Stream",
@@ -119,7 +119,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "VC1 Encoded Stream",
@@ -127,7 +127,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "VC1 RCV Encoded Stream",
@@ -135,7 +135,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1RCV_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5 | MFC_V6 | MFC_V7,
+		.versions	= MFC_V5 | MFC_V6 | MFC_V7 | MFC_V8,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -143,7 +143,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V6 | MFC_V7,
+		.versions	= MFC_V6 | MFC_V7 | MFC_V8,
 	},
 };
 
@@ -1200,7 +1200,9 @@ void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
 	struct v4l2_format f;
 	f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_H264;
 	ctx->src_fmt = find_format(&f, MFC_FMT_DEC);
-	if (IS_MFCV6_PLUS(ctx->dev))
+	if (IS_MFCV8(ctx->dev))
+		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12M;
+	else if (IS_MFCV6_PLUS(ctx->dev))
 		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT_16X16;
 	else
 		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index cbea828..f365f7d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -102,8 +102,14 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_DEC:
 	case S5P_MFC_CODEC_H264_MVC_DEC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(
+		if (IS_MFCV8(dev))
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V8(
+					mb_width,
+					mb_height);
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_H264_DEC_V6(
 					mb_width,
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
@@ -153,10 +159,16 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_VP8_DEC:
-		ctx->scratch_buf_size =
-			S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(
-					mb_width,
-					mb_height);
+		if (IS_MFCV8(dev))
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V8(
+						mb_width,
+						mb_height);
+		else
+			ctx->scratch_buf_size =
+				S5P_FIMV_SCRATCH_BUF_SIZE_VP8_DEC_V6(
+						mb_width,
+						mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
 		ctx->bank1.size = ctx->scratch_buf_size;
@@ -332,6 +344,12 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 
 	ctx->luma_size = calc_plane(ctx->img_width, ctx->img_height);
 	ctx->chroma_size = calc_plane(ctx->img_width, (ctx->img_height >> 1));
+	if (IS_MFCV8(ctx->dev)) {
+		/* MFCv8 needs additional 64 bytes for luma,chroma dpb*/
+		ctx->luma_size += S5P_FIMV_D_ALIGN_PLANE_SIZE_V8;
+		ctx->chroma_size += S5P_FIMV_D_ALIGN_PLANE_SIZE_V8;
+	}
+
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
 		ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
@@ -406,6 +424,14 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	WRITEL(buf_addr1, mfc_regs->d_scratch_buffer_addr);
 	WRITEL(ctx->scratch_buf_size, mfc_regs->d_scratch_buffer_size);
+
+	if (IS_MFCV8(dev)) {
+		WRITEL(ctx->img_width,
+			mfc_regs->d_first_plane_dpb_stride_size);
+		WRITEL(ctx->img_width,
+			mfc_regs->d_second_plane_dpb_stride_size);
+	}
+
 	buf_addr1 += ctx->scratch_buf_size;
 	buf_size1 -= ctx->scratch_buf_size;
 
@@ -2151,7 +2177,7 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 	if (!IS_MFCV7_PLUS(dev))
 		goto done;
 
-	/* Initialize registers used in MFC v7 */
+	/* Initialize registers used in MFC v7+ */
 	R(e_source_first_plane_addr, S5P_FIMV_E_SOURCE_FIRST_ADDR_V7);
 	R(e_source_second_plane_addr, S5P_FIMV_E_SOURCE_SECOND_ADDR_V7);
 	R(e_source_third_plane_addr, S5P_FIMV_E_SOURCE_THIRD_ADDR_V7);
@@ -2164,6 +2190,51 @@ const struct s5p_mfc_regs *s5p_mfc_init_regs_v6_plus(struct s5p_mfc_dev *dev)
 			S5P_FIMV_E_ENCODED_SOURCE_SECOND_ADDR_V7);
 	R(e_vp8_options, S5P_FIMV_E_VP8_OPTIONS_V7);
 
+	if (!IS_MFCV8(dev))
+		goto done;
+
+	/* Initialize registers used in MFC v8 only.
+	 * Also, over-write the registers which have
+	 * a different offset for MFC v8. */
+	R(d_stream_data_size, S5P_FIMV_D_STREAM_DATA_SIZE_V8);
+	R(d_cpb_buffer_addr, S5P_FIMV_D_CPB_BUFFER_ADDR_V8);
+	R(d_cpb_buffer_size, S5P_FIMV_D_CPB_BUFFER_SIZE_V8);
+	R(d_cpb_buffer_offset, S5P_FIMV_D_CPB_BUFFER_OFFSET_V8);
+	R(d_first_plane_dpb_size, S5P_FIMV_D_FIRST_PLANE_DPB_SIZE_V8);
+	R(d_second_plane_dpb_size, S5P_FIMV_D_SECOND_PLANE_DPB_SIZE_V8);
+	R(d_scratch_buffer_addr, S5P_FIMV_D_SCRATCH_BUFFER_ADDR_V8);
+	R(d_scratch_buffer_size, S5P_FIMV_D_SCRATCH_BUFFER_SIZE_V8);
+	R(d_first_plane_dpb_stride_size,
+			S5P_FIMV_D_FIRST_PLANE_DPB_STRIDE_SIZE_V8);
+	R(d_second_plane_dpb_stride_size,
+			S5P_FIMV_D_SECOND_PLANE_DPB_STRIDE_SIZE_V8);
+	R(d_mv_buffer_size, S5P_FIMV_D_MV_BUFFER_SIZE_V8);
+	R(d_num_mv, S5P_FIMV_D_NUM_MV_V8);
+	R(d_first_plane_dpb, S5P_FIMV_D_FIRST_PLANE_DPB_V8);
+	R(d_second_plane_dpb, S5P_FIMV_D_SECOND_PLANE_DPB_V8);
+	R(d_mv_buffer, S5P_FIMV_D_MV_BUFFER_V8);
+	R(d_init_buffer_options, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V8);
+	R(d_available_dpb_flag_lower, S5P_FIMV_D_AVAILABLE_DPB_FLAG_LOWER_V8);
+	R(d_slice_if_enable, S5P_FIMV_D_SLICE_IF_ENABLE_V8);
+	R(d_display_first_plane_addr, S5P_FIMV_D_DISPLAY_FIRST_PLANE_ADDR_V8);
+	R(d_display_second_plane_addr, S5P_FIMV_D_DISPLAY_SECOND_PLANE_ADDR_V8);
+	R(d_decoded_first_plane_addr, S5P_FIMV_D_DECODED_FIRST_PLANE_ADDR_V8);
+	R(d_decoded_second_plane_addr, S5P_FIMV_D_DECODED_SECOND_PLANE_ADDR_V8);
+	R(d_display_status, S5P_FIMV_D_DISPLAY_STATUS_V8);
+	R(d_decoded_status, S5P_FIMV_D_DECODED_STATUS_V8);
+	R(d_decoded_frame_type, S5P_FIMV_D_DECODED_FRAME_TYPE_V8);
+	R(d_display_frame_type, S5P_FIMV_D_DISPLAY_FRAME_TYPE_V8);
+	R(d_decoded_nal_size, S5P_FIMV_D_DECODED_NAL_SIZE_V8);
+	R(d_display_frame_width, S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V8);
+	R(d_display_frame_height, S5P_FIMV_D_DISPLAY_FRAME_HEIGHT_V8);
+	R(d_frame_pack_sei_avail, S5P_FIMV_D_FRAME_PACK_SEI_AVAIL_V8);
+	R(d_mvc_num_views, S5P_FIMV_D_MVC_NUM_VIEWS_V8);
+	R(d_mvc_view_id, S5P_FIMV_D_MVC_VIEW_ID_V8);
+	R(d_ret_picture_tag_top, S5P_FIMV_D_RET_PICTURE_TAG_TOP_V8);
+	R(d_ret_picture_tag_bot, S5P_FIMV_D_RET_PICTURE_TAG_BOT_V8);
+	R(d_display_crop_info1, S5P_FIMV_D_DISPLAY_CROP_INFO1_V8);
+	R(d_display_crop_info2, S5P_FIMV_D_DISPLAY_CROP_INFO2_V8);
+
 done:
 	return &mfc_regs;
 #undef S5P_MFC_REG_ADDR
-- 
1.7.9.5


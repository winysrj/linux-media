Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58934 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755199AbdCaJEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 05:04:34 -0400
From: Smitha T Murthy <smitha.t@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, pankaj.dubey@samsung.com,
        krzk@kernel.org, m.szyprowski@samsung.com, s.nawrocki@samsung.com,
        Smitha T Murthy <smitha.t@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [Patch v3 02/11] [media] s5p-mfc: Adding initial support for MFC v10.10
Date: Fri, 31 Mar 2017 14:36:31 +0530
Message-id: <1490951200-32070-3-git-send-email-smitha.t@samsung.com>
In-reply-to: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
References: <1490951200-32070-1-git-send-email-smitha.t@samsung.com>
 <CGME20170331090431epcas1p41059cb8237d766e8a219b3e6ba0c7930@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding the support for MFC v10.10, with new register file and
necessary hw control, decoder, encoder and structural changes.

CC: Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/s5p-mfc.txt          |  1 +
 drivers/media/platform/s5p-mfc/regs-mfc-v10.h      | 36 ++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 30 ++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  9 +++++-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c      |  4 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 32 ++++++++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 16 ++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c    |  9 ++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h    |  2 ++
 9 files changed, 106 insertions(+), 33 deletions(-)
 create mode 100644 drivers/media/platform/s5p-mfc/regs-mfc-v10.h

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 2c90128..b83727b 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -13,6 +13,7 @@ Required properties:
 	(c) "samsung,mfc-v7" for MFC v7 present in Exynos5420 SoC
 	(d) "samsung,mfc-v8" for MFC v8 present in Exynos5800 SoC
 	(e) "samsung,exynos5433-mfc" for MFC v8 present in Exynos5433 SoC
+	(f) "samsung,mfc-v10" for MFC v10 present in Exynos7880 SoC
 
   - reg : Physical base address of the IP registers and length of memory
 	  mapped region.
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v10.h b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
new file mode 100644
index 0000000..1ca09d6
--- /dev/null
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v10.h
@@ -0,0 +1,36 @@
+/*
+ * Register definition file for Samsung MFC V10.x Interface (FIMV) driver
+ *
+ * Copyright (c) 2017 Samsung Electronics Co., Ltd.
+ *     http://www.samsung.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _REGS_MFC_V10_H
+#define _REGS_MFC_V10_H
+
+#include <linux/sizes.h>
+#include "regs-mfc-v8.h"
+
+/* MFCv10 register definitions*/
+#define S5P_FIMV_MFC_CLOCK_OFF_V10			0x7120
+#define S5P_FIMV_MFC_STATE_V10				0x7124
+
+/* MFCv10 Context buffer sizes */
+#define MFC_CTX_BUF_SIZE_V10		(30 * SZ_1K)
+#define MFC_H264_DEC_CTX_BUF_SIZE_V10	(2 * SZ_1M)
+#define MFC_OTHER_DEC_CTX_BUF_SIZE_V10	(20 * SZ_1K)
+#define MFC_H264_ENC_CTX_BUF_SIZE_V10	(100 * SZ_1K)
+#define MFC_OTHER_ENC_CTX_BUF_SIZE_V10	(15 * SZ_1K)
+
+/* MFCv10 variant defines */
+#define MAX_FW_SIZE_V10		(SZ_1M)
+#define MAX_CPB_SIZE_V10	(3 * SZ_1M)
+#define MFC_VERSION_V10		0xA0
+#define MFC_NUM_PORTS_V10	1
+
+#endif /*_REGS_MFC_V10_H*/
+
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c6f0754..443ff7e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1547,6 +1547,33 @@ static struct s5p_mfc_variant mfc_drvdata_v8_5433 = {
 	.num_clocks	= 3,
 };
 
+static struct s5p_mfc_buf_size_v6 mfc_buf_size_v10 = {
+	.dev_ctx        = MFC_CTX_BUF_SIZE_V10,
+	.h264_dec_ctx   = MFC_H264_DEC_CTX_BUF_SIZE_V10,
+	.other_dec_ctx  = MFC_OTHER_DEC_CTX_BUF_SIZE_V10,
+	.h264_enc_ctx   = MFC_H264_ENC_CTX_BUF_SIZE_V10,
+	.other_enc_ctx  = MFC_OTHER_ENC_CTX_BUF_SIZE_V10,
+};
+
+static struct s5p_mfc_buf_size buf_size_v10 = {
+	.fw     = MAX_FW_SIZE_V10,
+	.cpb    = MAX_CPB_SIZE_V10,
+	.priv   = &mfc_buf_size_v10,
+};
+
+static struct s5p_mfc_buf_align mfc_buf_align_v10 = {
+	.base = 0,
+};
+
+static struct s5p_mfc_variant mfc_drvdata_v10 = {
+	.version        = MFC_VERSION_V10,
+	.version_bit    = MFC_V10_BIT,
+	.port_num       = MFC_NUM_PORTS_V10,
+	.buf_size       = &buf_size_v10,
+	.buf_align      = &mfc_buf_align_v10,
+	.fw_name[0]     = "s5p-mfc-v10.fw",
+};
+
 static const struct of_device_id exynos_mfc_match[] = {
 	{
 		.compatible = "samsung,mfc-v5",
@@ -1563,6 +1590,9 @@ static const struct of_device_id exynos_mfc_match[] = {
 	}, {
 		.compatible = "samsung,exynos5433-mfc",
 		.data = &mfc_drvdata_v8_5433,
+	}, {
+		.compatible = "samsung,mfc-v10",
+		.data = &mfc_drvdata_v10,
 	},
 	{},
 };
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index b45d18c..3a4ca55 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -23,7 +23,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/videobuf2-v4l2.h>
 #include "regs-mfc.h"
-#include "regs-mfc-v8.h"
+#include "regs-mfc-v10.h"
 
 #define S5P_MFC_NAME		"s5p-mfc"
 
@@ -723,11 +723,18 @@ void s5p_mfc_cleanup_queue(struct list_head *lh, struct vb2_queue *vq);
 #define IS_MFCV6_PLUS(dev)	(dev->variant->version >= 0x60 ? 1 : 0)
 #define IS_MFCV7_PLUS(dev)	(dev->variant->version >= 0x70 ? 1 : 0)
 #define IS_MFCV8_PLUS(dev)	(dev->variant->version >= 0x80 ? 1 : 0)
+#define IS_MFCV10(dev)		(dev->variant->version >= 0xA0 ? 1 : 0)
 
 #define MFC_V5_BIT	BIT(0)
 #define MFC_V6_BIT	BIT(1)
 #define MFC_V7_BIT	BIT(2)
 #define MFC_V8_BIT	BIT(3)
+#define MFC_V10_BIT	BIT(5)
 
+#define MFC_V5PLUS_BITS		(MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT | \
+					MFC_V8_BIT | MFC_V10_BIT)
+#define MFC_V6PLUS_BITS		(MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT | \
+					MFC_V10_BIT)
+#define MFC_V7PLUS_BITS		(MFC_V7_BIT | MFC_V8_BIT | MFC_V10_BIT)
 
 #endif /* S5P_MFC_COMMON_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 484af6b..0ded23c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -267,6 +267,10 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 	}
 	else
 		mfc_write(dev, 0x3ff, S5P_FIMV_SW_RESET);
+
+	if (IS_MFCV10(dev))
+		mfc_write(dev, 0x0, S5P_FIMV_MFC_CLOCK_OFF_V10);
+
 	mfc_debug(2, "Will now wait for completion of firmware transfer\n");
 	if (s5p_mfc_wait_for_done_dev(dev, S5P_MFC_R2H_CMD_FW_STATUS_RET)) {
 		mfc_err("Failed to load firmware\n");
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 0ec2928..db6d9fa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -54,7 +54,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V6PLUS_BITS,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -62,7 +62,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V6PLUS_BITS,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -70,8 +70,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "H264/MVC Encoded Stream",
@@ -79,7 +78,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_MVC_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V6PLUS_BITS,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -87,8 +86,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "MPEG1 Encoded Stream",
@@ -96,8 +94,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "MPEG2 Encoded Stream",
@@ -105,8 +102,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG2_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -114,8 +110,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "XviD Encoded Stream",
@@ -123,8 +118,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "VC1 Encoded Stream",
@@ -132,8 +126,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "VC1 RCV Encoded Stream",
@@ -141,8 +134,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VC1RCV_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -150,7 +142,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_DEC,
 		.type		= MFC_FMT_DEC,
 		.num_planes	= 1,
-		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V6PLUS_BITS,
 	},
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e39d9e0..e81b359 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -57,8 +57,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "4:2:0 2 Planes Y/CrCb",
@@ -66,7 +65,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_NONE,
 		.type		= MFC_FMT_RAW,
 		.num_planes	= 2,
-		.versions	= MFC_V6_BIT | MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V6PLUS_BITS,
 	},
 	{
 		.name		= "H264 Encoded Stream",
@@ -74,8 +73,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H264_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "MPEG4 Encoded Stream",
@@ -83,8 +81,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_MPEG4_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "H263 Encoded Stream",
@@ -92,8 +89,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_H263_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V5_BIT | MFC_V6_BIT | MFC_V7_BIT |
-								MFC_V8_BIT,
+		.versions	= MFC_V5PLUS_BITS,
 	},
 	{
 		.name		= "VP8 Encoded Stream",
@@ -101,7 +97,7 @@ static struct s5p_mfc_fmt formats[] = {
 		.codec_mode	= S5P_MFC_CODEC_VP8_ENC,
 		.type		= MFC_FMT_ENC,
 		.num_planes	= 1,
-		.versions	= MFC_V7_BIT | MFC_V8_BIT,
+		.versions	= MFC_V7PLUS_BITS,
 	},
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 7682b0e..9dc106e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -358,6 +358,7 @@ static int calc_plane(int width, int height)
 
 static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 {
+	struct s5p_mfc_dev *dev = ctx->dev;
 	ctx->buf_width = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN_V6);
 	ctx->buf_height = ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN_V6);
 	mfc_debug(2, "SEQ Done: Movie dimensions %dx%d,\n"
@@ -374,8 +375,12 @@ static void s5p_mfc_dec_calc_dpb_size_v6(struct s5p_mfc_ctx *ctx)
 
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
 			ctx->codec_mode == S5P_MFC_CODEC_H264_MVC_DEC) {
-		ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
-				ctx->img_height);
+		if (IS_MFCV10(dev))
+			ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V10(ctx->img_width,
+					ctx->img_height);
+		else
+			ctx->mv_size = S5P_MFC_DEC_MV_SIZE_V6(ctx->img_width,
+					ctx->img_height);
 		ctx->mv_size = ALIGN(ctx->mv_size, 16);
 	} else {
 		ctx->mv_size = 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
index 8055848..021b8db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.h
@@ -24,6 +24,8 @@
 #define MB_HEIGHT(y_size)		DIV_ROUND_UP(y_size, 16)
 #define S5P_MFC_DEC_MV_SIZE_V6(x, y)	(MB_WIDTH(x) * \
 					(((MB_HEIGHT(y)+1)/2)*2) * 64 + 128)
+#define S5P_MFC_DEC_MV_SIZE_V10(x, y)	(MB_WIDTH(x) * \
+					(((MB_HEIGHT(y)+1)/2)*2) * 64 + 512)
 
 /* Definition */
 #define ENC_MULTI_SLICE_MB_MAX		((1 << 30) - 1)
-- 
2.7.4

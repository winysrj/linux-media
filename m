Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:51741 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaCGIbg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 03:31:36 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: add init buffer cmd to MFCV6
Date: Fri,  7 Mar 2014 14:01:29 +0530
Message-Id: <1394181090-16446-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: avnd kiran <avnd.kiran@samsung.com>

Latest MFC v6 firmware requires tile mode and loop filter
setting to be done as part of Init buffer command, in sync
with v7. So, move these settings out of decode options reg.
Also, make this register definition applicable from v6 onwards.

Signed-off-by: avnd kiran <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   11 +++--------
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 8d0b686..b47567c 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -132,6 +132,7 @@
 #define S5P_FIMV_D_METADATA_BUFFER_ADDR_V6	0xf448
 #define S5P_FIMV_D_METADATA_BUFFER_SIZE_V6	0xf44c
 #define S5P_FIMV_D_NUM_MV_V6			0xf478
+#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6	0xf47c
 #define S5P_FIMV_D_CPB_BUFFER_ADDR_V6		0xf4b0
 #define S5P_FIMV_D_CPB_BUFFER_SIZE_V6		0xf4b4
 
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index ea5ec2a..82c96fa 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -18,8 +18,6 @@
 #define S5P_FIMV_CODEC_VP8_ENC_V7	25
 
 /* Additional registers for v7 */
-#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7		0xf47c
-
 #define S5P_FIMV_E_SOURCE_FIRST_ADDR_V7			0xf9e0
 #define S5P_FIMV_E_SOURCE_SECOND_ADDR_V7		0xf9e4
 #define S5P_FIMV_E_SOURCE_THIRD_ADDR_V7			0xf9e8
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 90edb19..b226d75 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1296,10 +1296,8 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
 	}
 
-	if (IS_MFCV7(dev)) {
-		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
-		reg = 0;
-	}
+	WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+	reg = 0;
 
 	/* Setup loop filter, for decoding this is only valid for MPEG4 */
 	if (ctx->codec_mode == S5P_MFC_CODEC_MPEG4_DEC) {
@@ -1311,10 +1309,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	if (IS_MFCV7(dev))
-		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
-	else
-		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
+	WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
 
 	/* 0: NV12(CbCr), 1: NV21(CrCb) */
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV21M)
-- 
1.7.9.5


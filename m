Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:47492 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0LOClB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 21:41:01 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH v2] [media] s5p-fimc: fix the value of YUV422 1-plane formats
Date: Wed, 15 Dec 2010 11:18:48 +0900
Message-Id: <1292379528-16994-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Some color formats are mismatched in s5p-fimc driver.
CICICTRL[1:0], order422_out, should be set 2b'00 not 2b'11
to use V4L2_PIX_FMT_YUYV. Because in V4L2 standard V4L2_PIX_FMT_YUYV means
"start + 0: Y'00 Cb00 Y'01 Cr00 Y'02 Cb01 Y'03 Cr01". According to datasheet
2b'00 is right value for V4L2_PIX_FMT_YUYV.

---------------------------------------------------------
bit |    MSB                                        LSB
---------------------------------------------------------
00  |  Cr1    Y3    Cb1    Y2    Cr0    Y1    Cb0    Y0
---------------------------------------------------------
01  |  Cb1    Y3    Cr1    Y2    Cb0    Y1    Cr0    Y0
---------------------------------------------------------
10  |  Y3    Cr1    Y2    Cb1    Y1    Cr0    Y0    Cb0
---------------------------------------------------------
11  |  Y3    Cb1    Y2    Cr1    Y1    Cb0    Y0    Cr0
---------------------------------------------------------

V4L2_PIX_FMT_YVYU, V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_VYUY are also mismatched
with datasheet. MSCTRL[17:16], order2p_in, is also mismatched
in V4L2_PIX_FMT_UYVY, V4L2_PIX_FMT_YVYU.

Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
Reviewed-by: Jonghun han <jonghun.han@samsung.com>
---
Changes since V1:
=================
- make corrections directly in function fimc_set_yuv_order
  commented by Sylwester Nawrocki.
- remove S5P_FIMC_IN_* and S5P_FIMC_OUT_* definitions from fimc-core.h

 drivers/media/video/s5p-fimc/fimc-core.c |   16 ++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.h |   12 ------------
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 7f56987..71e1536 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -448,34 +448,34 @@ static void fimc_set_yuv_order(struct fimc_ctx *ctx)
 	/* Set order for 1 plane input formats. */
 	switch (ctx->s_frame.fmt->color) {
 	case S5P_FIMC_YCRYCB422:
-		ctx->in_order_1p = S5P_FIMC_IN_YCRYCB;
+		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCRYCB;
 		break;
 	case S5P_FIMC_CBYCRY422:
-		ctx->in_order_1p = S5P_FIMC_IN_CBYCRY;
+		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CBYCRY;
 		break;
 	case S5P_FIMC_CRYCBY422:
-		ctx->in_order_1p = S5P_FIMC_IN_CRYCBY;
+		ctx->in_order_1p = S5P_MSCTRL_ORDER422_CRYCBY;
 		break;
 	case S5P_FIMC_YCBYCR422:
 	default:
-		ctx->in_order_1p = S5P_FIMC_IN_YCBYCR;
+		ctx->in_order_1p = S5P_MSCTRL_ORDER422_YCBYCR;
 		break;
 	}
 	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
 
 	switch (ctx->d_frame.fmt->color) {
 	case S5P_FIMC_YCRYCB422:
-		ctx->out_order_1p = S5P_FIMC_OUT_YCRYCB;
+		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCRYCB;
 		break;
 	case S5P_FIMC_CBYCRY422:
-		ctx->out_order_1p = S5P_FIMC_OUT_CBYCRY;
+		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CBYCRY;
 		break;
 	case S5P_FIMC_CRYCBY422:
-		ctx->out_order_1p = S5P_FIMC_OUT_CRYCBY;
+		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_YCBYCR;
 		break;
 	case S5P_FIMC_YCBYCR422:
 	default:
-		ctx->out_order_1p = S5P_FIMC_OUT_YCBYCR;
+		ctx->out_order_1p = S5P_CIOCTRL_ORDER422_CRYCBY;
 		break;
 	}
 	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 4efc1a1..92cca62 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -95,18 +95,6 @@ enum fimc_color_fmt {
 
 #define fimc_fmt_is_rgb(x) ((x) & 0x10)
 
-/* Y/Cb/Cr components order at DMA output for 1 plane YCbCr 4:2:2 formats. */
-#define	S5P_FIMC_OUT_CRYCBY	S5P_CIOCTRL_ORDER422_YCBYCR
-#define	S5P_FIMC_OUT_CBYCRY	S5P_CIOCTRL_ORDER422_CBYCRY
-#define	S5P_FIMC_OUT_YCRYCB	S5P_CIOCTRL_ORDER422_YCRYCB
-#define	S5P_FIMC_OUT_YCBYCR	S5P_CIOCTRL_ORDER422_CRYCBY
-
-/* Input Y/Cb/Cr components order for 1 plane YCbCr 4:2:2 color formats. */
-#define	S5P_FIMC_IN_CRYCBY	S5P_MSCTRL_ORDER422_CRYCBY
-#define	S5P_FIMC_IN_CBYCRY	S5P_MSCTRL_ORDER422_CBYCRY
-#define	S5P_FIMC_IN_YCRYCB	S5P_MSCTRL_ORDER422_YCRYCB
-#define	S5P_FIMC_IN_YCBYCR	S5P_MSCTRL_ORDER422_YCBYCR
-
 /* Cb/Cr chrominance components order for 2 plane Y/CbCr 4:2:2 formats. */
 #define	S5P_FIMC_LSB_CRCB	S5P_CIOCTRL_ORDER422_2P_LSB_CRCB
 
-- 
1.6.2.5


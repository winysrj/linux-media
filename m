Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51556 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3CZSjA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 14:39:00 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	dh09.lee@samsung.com, shaik.samsung@gmail.com, arun.kk@samsung.com,
	a.hajda@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 4/5] exynos4-is: Correct input DMA YUV order configuration
Date: Tue, 26 Mar 2013 19:38:19 +0100
Message-id: <1364323101-22046-8-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
References: <1364323101-22046-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes erroneous setup of the YUV order caused by not
clearing FIMC_REG_MSCTRL_ORDER422_MASK bit field before setting
proper FIMC_REG_MSCTRL_ORDER422 bits. This resulted in false
colors for YUYV, YVYU, UYVY, VYUY color formats, depending in
what sequence those were configured by user space.

YUV order definitions are corrected so that following convention
is used:

        | byte3 | byte2 | byte1 | byte0
 -------+-------+-------+-------+------
 YCBYCR | CR    | Y     | CB    | Y
 YCRYCB | CB    | Y     | CR    | Y
 CBYCRY | Y     | CR    | Y     | CB
 CRYCBY | Y     | CB    | Y     | CR

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-core.c |   16 ++++++++--------
 drivers/media/platform/exynos4-is/fimc-reg.c  |    3 ++-
 drivers/media/platform/exynos4-is/fimc-reg.h  |   16 ++++++++--------
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/media/platform/exynos4-is/fimc-core.c
index 2e153bb..f6efa47 100644
--- a/drivers/media/platform/exynos4-is/fimc-core.c
+++ b/drivers/media/platform/exynos4-is/fimc-core.c
@@ -412,34 +412,34 @@ void fimc_set_yuv_order(struct fimc_ctx *ctx)
 	/* Set order for 1 plane input formats. */
 	switch (ctx->s_frame.fmt->color) {
 	case FIMC_FMT_YCRYCB422:
-		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CBYCRY;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCRYCB;
 		break;
 	case FIMC_FMT_CBYCRY422:
-		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCRYCB;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CBYCRY;
 		break;
 	case FIMC_FMT_CRYCBY422:
-		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCBYCR;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CRYCBY;
 		break;
 	case FIMC_FMT_YCBYCR422:
 	default:
-		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_CRYCBY;
+		ctx->in_order_1p = FIMC_REG_MSCTRL_ORDER422_YCBYCR;
 		break;
 	}
 	dbg("ctx->in_order_1p= %d", ctx->in_order_1p);
 
 	switch (ctx->d_frame.fmt->color) {
 	case FIMC_FMT_YCRYCB422:
-		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CBYCRY;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCRYCB;
 		break;
 	case FIMC_FMT_CBYCRY422:
-		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCRYCB;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CBYCRY;
 		break;
 	case FIMC_FMT_CRYCBY422:
-		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCBYCR;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CRYCBY;
 		break;
 	case FIMC_FMT_YCBYCR422:
 	default:
-		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_CRYCBY;
+		ctx->out_order_1p = FIMC_REG_CIOCTRL_ORDER422_YCBYCR;
 		break;
 	}
 	dbg("ctx->out_order_1p= %d", ctx->out_order_1p);
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.c b/drivers/media/platform/exynos4-is/fimc-reg.c
index c276eb8..fd144a1 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-reg.c
@@ -449,7 +449,8 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 		 | FIMC_REG_MSCTRL_IN_BURST_COUNT_MASK
 		 | FIMC_REG_MSCTRL_INPUT_MASK
 		 | FIMC_REG_MSCTRL_C_INT_IN_MASK
-		 | FIMC_REG_MSCTRL_2P_IN_ORDER_MASK);
+		 | FIMC_REG_MSCTRL_2P_IN_ORDER_MASK
+		 | FIMC_REG_MSCTRL_ORDER422_MASK);
 
 	cfg |= (FIMC_REG_MSCTRL_IN_BURST_COUNT(4)
 		| FIMC_REG_MSCTRL_INPUT_MEMORY
diff --git a/drivers/media/platform/exynos4-is/fimc-reg.h b/drivers/media/platform/exynos4-is/fimc-reg.h
index 01da7f3..6c97798 100644
--- a/drivers/media/platform/exynos4-is/fimc-reg.h
+++ b/drivers/media/platform/exynos4-is/fimc-reg.h
@@ -95,10 +95,10 @@
 /* Output DMA control */
 #define FIMC_REG_CIOCTRL			0x4c
 #define FIMC_REG_CIOCTRL_ORDER422_MASK		(3 << 0)
-#define FIMC_REG_CIOCTRL_ORDER422_CRYCBY	(0 << 0)
-#define FIMC_REG_CIOCTRL_ORDER422_CBYCRY	(1 << 0)
-#define FIMC_REG_CIOCTRL_ORDER422_YCRYCB	(2 << 0)
-#define FIMC_REG_CIOCTRL_ORDER422_YCBYCR	(3 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_YCBYCR	(0 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_YCRYCB	(1 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_CBYCRY	(2 << 0)
+#define FIMC_REG_CIOCTRL_ORDER422_CRYCBY	(3 << 0)
 #define FIMC_REG_CIOCTRL_LASTIRQ_ENABLE		(1 << 2)
 #define FIMC_REG_CIOCTRL_YCBCR_3PLANE		(0 << 3)
 #define FIMC_REG_CIOCTRL_YCBCR_2PLANE		(1 << 3)
@@ -220,10 +220,10 @@
 #define FIMC_REG_MSCTRL_FLIP_180		(3 << 13)
 #define FIMC_REG_MSCTRL_FIFO_CTRL_FULL		(1 << 12)
 #define FIMC_REG_MSCTRL_ORDER422_SHIFT		4
-#define FIMC_REG_MSCTRL_ORDER422_YCBYCR		(0 << 4)
-#define FIMC_REG_MSCTRL_ORDER422_CBYCRY		(1 << 4)
-#define FIMC_REG_MSCTRL_ORDER422_YCRYCB		(2 << 4)
-#define FIMC_REG_MSCTRL_ORDER422_CRYCBY		(3 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_CRYCBY		(0 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_YCRYCB		(1 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_CBYCRY		(2 << 4)
+#define FIMC_REG_MSCTRL_ORDER422_YCBYCR		(3 << 4)
 #define FIMC_REG_MSCTRL_ORDER422_MASK		(3 << 4)
 #define FIMC_REG_MSCTRL_INPUT_EXTCAM		(0 << 3)
 #define FIMC_REG_MSCTRL_INPUT_MEMORY		(1 << 3)
-- 
1.7.9.5


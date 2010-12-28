Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:13422 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab0L1RDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 12:03:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 28 Dec 2010 18:03:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 10/15] [media] s5p-fimc: Use default input DMA burst count
In-reply-to: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1293555798-31578-11-git-send-email-s.nawrocki@samsung.com>
References: <1293555798-31578-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Increase the input DMA "successive burst count" to default
value 4 to improve DMA performance. Minor cleanup.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c  |   11 +++--------
 drivers/media/video/s5p-fimc/regs-fimc.h |    4 ++--
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 41a6a72..11422e9 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -417,12 +417,10 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 		| S5P_MSCTRL_C_INT_IN_MASK
 		| S5P_MSCTRL_2P_IN_ORDER_MASK);
 
-	cfg |= (S5P_MSCTRL_FRAME_COUNT(1) | S5P_MSCTRL_INPUT_MEMORY);
+	cfg |= S5P_MSCTRL_IN_BURST_COUNT(4) | S5P_MSCTRL_INPUT_MEMORY;
 
 	switch (frame->fmt->color) {
-	case S5P_FIMC_RGB565:
-	case S5P_FIMC_RGB666:
-	case S5P_FIMC_RGB888:
+	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
 		cfg |= S5P_MSCTRL_INFORMAT_RGB;
 		break;
 	case S5P_FIMC_YCBCR420:
@@ -434,10 +432,7 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 			cfg |= S5P_MSCTRL_C_INT_IN_3PLANE;
 
 		break;
-	case S5P_FIMC_YCBYCR422:
-	case S5P_FIMC_YCRYCB422:
-	case S5P_FIMC_CBYCRY422:
-	case S5P_FIMC_CRYCBY422:
+	case S5P_FIMC_YCBYCR422...S5P_FIMC_CRYCBY422:
 		if (frame->fmt->colplanes == 1) {
 			cfg |= ctx->in_order_1p
 				| S5P_MSCTRL_INFORMAT_YCBCR422_1P;
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index 57e33f8..74ca705 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -210,7 +210,7 @@
 
 /* Input DMA control */
 #define S5P_MSCTRL			0xfc
-#define S5P_MSCTRL_IN_BURST_COUNT_MASK	(3 << 24)
+#define S5P_MSCTRL_IN_BURST_COUNT_MASK	(0xF << 24)
 #define S5P_MSCTRL_2P_IN_ORDER_MASK	(3 << 16)
 #define S5P_MSCTRL_2P_IN_ORDER_SHIFT	16
 #define S5P_MSCTRL_C_INT_IN_3PLANE	(0 << 15)
@@ -237,7 +237,7 @@
 #define S5P_MSCTRL_INFORMAT_RGB		(3 << 1)
 #define S5P_MSCTRL_INFORMAT_MASK	(3 << 1)
 #define S5P_MSCTRL_ENVID		(1 << 0)
-#define S5P_MSCTRL_FRAME_COUNT(x)	((x) << 24)
+#define S5P_MSCTRL_IN_BURST_COUNT(x)	((x) << 24)
 
 /* Output DMA Y/Cb/Cr offset */
 #define S5P_CIOYOFF			0x168
-- 
1.7.2.3


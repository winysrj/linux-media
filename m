Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37428 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0L2IOI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 03:14:08 -0500
From: Hyunwoong Kim <khw0178.kim@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, Hyunwoong Kim <khw0178.kim@samsung.com>
Subject: [PATCH] [media] s5p-fimc: fix MSCTRL.FIFO_CTRL for performance enhancement
Date: Wed, 29 Dec 2010 16:50:59 +0900
Message-Id: <1293609059-692-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch fixes the value of FIFO_CTRL in MSCTRL.
Main-scaler has the value to specify a basis FIFO control of input DMA.

The description of FIFO_CTRL has been changed as below.
0 = FIFO Empty (Next burst transaction is possible when FIFO is empty)
1 = FIFO Full (Next burst transaction is possible except Full FIFO)

Value '1' is recommended to enhance the FIMC operation performance.

Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
---
This patch is depended on Hyunwoong Kim's last patch.
- [PATCH v2] [media] s5p-fimc: Support stop_streaming and job_abort 

 drivers/media/video/s5p-fimc/fimc-reg.c  |    4 +++-
 drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 88951b8..0eb9319 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -457,7 +457,9 @@ void fimc_hw_set_in_dma(struct fimc_ctx *ctx)
 		| S5P_MSCTRL_C_INT_IN_MASK
 		| S5P_MSCTRL_2P_IN_ORDER_MASK);
 
-	cfg |= (S5P_MSCTRL_FRAME_COUNT(1) | S5P_MSCTRL_INPUT_MEMORY);
+	cfg |= (S5P_MSCTRL_FRAME_COUNT(1)
+		| S5P_MSCTRL_INPUT_MEMORY
+		| S5P_MSCTRL_FIFO_CTRL_FULL);
 
 	switch (frame->fmt->color) {
 	case S5P_FIMC_RGB565:
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index 28bd2fb..a984e81 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -226,6 +226,7 @@
 #define S5P_MSCTRL_FLIP_X_MIRROR	(1 << 13)
 #define S5P_MSCTRL_FLIP_Y_MIRROR	(2 << 13)
 #define S5P_MSCTRL_FLIP_180		(3 << 13)
+#define S5P_MSCTRL_FIFO_CTRL_FULL	(1 << 12)
 #define S5P_MSCTRL_ORDER422_SHIFT	4
 #define S5P_MSCTRL_ORDER422_YCBYCR	(0 << 4)
 #define S5P_MSCTRL_ORDER422_CBYCRY	(1 << 4)
-- 
1.6.2.5


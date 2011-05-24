Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42716 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1EXAez (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:34:55 -0400
From: Jeongtae Park <jtp.park@samsung.com>
To: Jeongtae Park <jtp.park@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, jonghun.han@samsung.com,
	june.bae@samsung.com, janghyuck.kim@samsung.com,
	younglak1004.kim@samsung.com, m.szyprowski@samsung.com,
	Jeongtae Park <jtp.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 1/4] media: MFC: Remove usused variables & compile warnings
Date: Tue, 24 May 2011 09:28:37 +0900
Message-Id: <1306196920-15467-2-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
References: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch removes unused variables & compile warnings

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    1 -
 drivers/media/video/s5p-mfc/s5p_mfc_mem.c |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c |    1 -
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 981fdfe..530ff0b 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1935,7 +1935,6 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q)
 	struct s5p_mfc_ctx *ctx = q->drv_priv;
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long flags;
-	unsigned ret;
 
 	/* If context is ready then dev = work->data;schedule it to run */
 	if (s5p_mfc_ctx_ready(ctx)) {
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_mem.c b/drivers/media/video/s5p-mfc/s5p_mfc_mem.c
index d5e235f..aeb3306 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_mem.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_mem.c
@@ -20,6 +20,7 @@
 
 
 #ifdef CONFIG_VIDEO_SAMSUNG_S5P_MFC_DMA_IOMMU
+#include <linux/slab.h>
 #include <plat/sysmmu.h>
 
 struct vb2_mem_ops *s5p_mfc_mem_ops(void)
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index a22ea43..24b2e11 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -1061,7 +1061,6 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_enc_params *p = &ctx->enc_params;
-	struct s5p_mfc_mpeg4_enc_params *p_mpeg4 = &p->codec.mpeg4;
 	unsigned int reg;
 	unsigned int shm;
 
-- 
1.7.1


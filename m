Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f44.google.com ([209.85.210.44]:62635 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3DXHm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Apr 2013 03:42:27 -0400
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: [RFC v2 4/6] media: fimc-lite: Fix for DMA output corruption
Date: Wed, 24 Apr 2013 13:11:11 +0530
Message-Id: <1366789273-30184-5-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes Buffer corruption on DMA output from fimc-lite

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-lite-reg.c |    3 ++-
 drivers/media/platform/exynos4-is/fimc-lite.c     |   14 +++++++++-----
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
index a1d566a..46eda5b 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
@@ -68,7 +68,8 @@ void flite_hw_set_interrupt_mask(struct fimc_lite *dev)
 	if (atomic_read(&dev->out_path) == FIMC_IO_DMA) {
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
 			 FLITE_REG_CIGCTRL_IRQ_LASTEN |
-			 FLITE_REG_CIGCTRL_IRQ_STARTEN;
+			 FLITE_REG_CIGCTRL_IRQ_STARTEN |
+			 FLITE_REG_CIGCTRL_IRQ_ENDEN;
 	} else {
 		/* An output to the FIMC-IS */
 		intsrc = FLITE_REG_CIGCTRL_IRQ_OVFEN |
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 1b12ea8..5de2dd4 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -301,8 +301,16 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 
 	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMSTART) &&
 	    test_bit(ST_FLITE_RUN, &fimc->state) &&
-	    !list_empty(&fimc->active_buf_q) &&
 	    !list_empty(&fimc->pending_buf_q)) {
+		vbuf = fimc_lite_pending_queue_pop(fimc);
+		flite_hw_set_output_addr(fimc, vbuf->paddr,
+					vbuf->vb.v4l2_buf.index);
+		fimc_lite_active_queue_add(fimc, vbuf);
+	}
+
+	if ((intsrc & FLITE_REG_CISTATUS_IRQ_SRC_FRMEND) &&
+	    test_bit(ST_FLITE_RUN, &fimc->state) &&
+	    !list_empty(&fimc->active_buf_q)) {
 		vbuf = fimc_lite_active_queue_pop(fimc);
 		ktime_get_ts(&ts);
 		tv = &vbuf->vb.v4l2_buf.timestamp;
@@ -311,10 +319,6 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
 		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
 		flite_hw_clear_output_addr(fimc, vbuf->vb.v4l2_buf.index);
 		vb2_buffer_done(&vbuf->vb, VB2_BUF_STATE_DONE);
-
-		vbuf = fimc_lite_pending_queue_pop(fimc);
-		flite_hw_set_output_addr(fimc, vbuf->paddr,
-					vbuf->vb.v4l2_buf.index);
 	}
 
 	if (test_bit(ST_FLITE_CONFIG, &fimc->state))
-- 
1.7.9.5


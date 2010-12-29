Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43249 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0L2AyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 19:54:06 -0500
From: Sungchun Kang <sungchun.kang@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	Sungchun Kang <sungchun.kang@samsung.com>
Subject: [PATCH] [media]: s5p-fimc: fix ISR and buffer handling for fimc-capture
Date: Wed, 29 Dec 2010 09:30:28 +0900
Message-Id: <1293582628-15547-1-git-send-email-sungchun.kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

These patches are related and it may be summarized as follows.

1. Some of the case are fimc H/W did not stop although there are
no available output DMA buffer. So, it is modified check the
routine fimc deactivation. And, the state of ST_CAPT_RUN is cleared
in LAST-IRQ routine.

2. When request buffer count is less than 4, CIOYSAn register did
not set if VIDIOC_QBUF is called repeatedly. So, clear bit the
state of ST_CAPT_STREAM in ISR.

3. Because fimc interrupt generated when the frame start to write,
it is necessary to use LAST-IRQ for processing of the last frame.
So, added the enumeration for LAST-IRQ.

4. After LAST-IRQ is generated, H/W pointer will be skip 1 frame.
(reference by user manual) So, S/W pointer should be increased too.

Reviewed-by Jonghun Han <jonghun.han@samsung.com>
Signed-off-by: Sungchun Kang <sungchun.kang@samsung.com>
---
This patch is depended on:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

 drivers/media/video/s5p-fimc/fimc-capture.c |   12 +++++++-----
 drivers/media/video/s5p-fimc/fimc-core.c    |   20 ++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.h    |    1 +
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 4e4441f..0a3b344 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -350,13 +350,15 @@ static void buffer_queue(struct vb2_buffer *vb)
 
 	dbg("active_buf_cnt: %d", fimc->vid_cap.active_buf_cnt);
 
-	if (vid_cap->active_buf_cnt >= vid_cap->reqbufs_count ||
-	   vid_cap->active_buf_cnt >= FIMC_MAX_OUT_BUFS) {
-		if (!test_and_set_bit(ST_CAPT_STREAM, &fimc->state)) {
+	if (vid_cap->active_buf_cnt == FIMC_MAX_OUT_BUFS)
+		set_bit(ST_CAPT_STREAM, &fimc->state);
+
+	if (test_bit(ST_CAPT_LAST_IRQ, &fimc->state) ||
+		!test_bit(ST_CAPT_RUN, &fimc->state)) {
 			fimc_activate_capture(ctx);
-			dbg("");
-		}
+		clear_bit(ST_CAPT_LAST_IRQ, &fimc->state);
 	}
+
 	spin_unlock_irqrestore(&fimc->slock, flags);
 }
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 2374fd8..4a85966 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -334,9 +334,14 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
 			cap->buf_index = 0;
 
-	} else if (test_and_clear_bit(ST_CAPT_STREAM, &fimc->state) &&
-		   cap->active_buf_cnt <= 1) {
-		fimc_deactivate_capture(fimc);
+	} else {
+		clear_bit(ST_CAPT_STREAM, &fimc->state);
+	}
+
+	if (cap->active_buf_cnt == 0) {
+		clear_bit(ST_CAPT_RUN, &fimc->state);
+		if (++cap->buf_index >= FIMC_MAX_OUT_BUFS)
+			cap->buf_index = 0;
 	}
 
 	dbg("frame: %d, active_buf_cnt= %d",
@@ -346,6 +351,7 @@ static void fimc_capture_handler(struct fimc_dev *fimc)
 static irqreturn_t fimc_isr(int irq, void *priv)
 {
 	struct fimc_dev *fimc = priv;
+	struct fimc_vid_cap *cap = &fimc->vid_cap;
 
 	BUG_ON(!fimc);
 	fimc_hw_clear_irq(fimc);
@@ -372,10 +378,12 @@ static irqreturn_t fimc_isr(int irq, void *priv)
 
 	if (test_bit(ST_CAPT_RUN, &fimc->state))
 		fimc_capture_handler(fimc);
-
-	if (test_and_clear_bit(ST_CAPT_PEND, &fimc->state)) {
+	else if (test_bit(ST_CAPT_PEND, &fimc->state))
 		set_bit(ST_CAPT_RUN, &fimc->state);
-		wake_up(&fimc->irq_queue);
+
+	if (cap->active_buf_cnt == 1) {
+		fimc_deactivate_capture(fimc);
+		set_bit(ST_CAPT_LAST_IRQ, &fimc->state);
 	}
 
 isr_unlock:
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 1f1beaa..58cb2e0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -56,6 +56,7 @@ enum fimc_dev_flags {
 	ST_CAPT_RUN,
 	ST_CAPT_STREAM,
 	ST_CAPT_SHUT,
+	ST_CAPT_LAST_IRQ,
 };
 
 #define fimc_m2m_active(dev) test_bit(ST_OUTDMA_RUN, &(dev)->state)
-- 
1.6.2.5


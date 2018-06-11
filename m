Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:7985 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932702AbeFKJwq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:52:46 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: revisit stop streaming ops
Date: Mon, 11 Jun 2018 11:52:17 +0200
Message-ID: <1528710737-8946-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not wait for interrupt completion when stopping streaming,
stopping sensor and disabling interruptions are enough.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 29 +----------------------------
 1 file changed, 1 insertion(+), 28 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 581ded0..f0134a6 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -87,7 +87,6 @@ enum state {
 	STOPPED = 0,
 	WAIT_FOR_BUFFER,
 	RUNNING,
-	STOPPING,
 };
 
 #define MIN_WIDTH	16U
@@ -432,18 +431,6 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 
 	spin_lock_irq(&dcmi->irqlock);
 
-	/* Stop capture is required */
-	if (dcmi->state == STOPPING) {
-		reg_clear(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
-
-		dcmi->state = STOPPED;
-
-		complete(&dcmi->complete);
-
-		spin_unlock_irq(&dcmi->irqlock);
-		return IRQ_HANDLED;
-	}
-
 	if ((dcmi->misr & IT_OVR) || (dcmi->misr & IT_ERR)) {
 		dcmi->errors_count++;
 		if (dcmi->misr & IT_OVR)
@@ -701,8 +688,6 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 {
 	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
 	struct dcmi_buf *buf, *node;
-	unsigned long time_ms = msecs_to_jiffies(TIMEOUT_MS);
-	long timeout;
 	int ret;
 
 	/* Disable stream on the sub device */
@@ -712,13 +697,6 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 			__func__, ret);
 
 	spin_lock_irq(&dcmi->irqlock);
-	dcmi->state = STOPPING;
-	spin_unlock_irq(&dcmi->irqlock);
-
-	timeout = wait_for_completion_interruptible_timeout(&dcmi->complete,
-							    time_ms);
-
-	spin_lock_irq(&dcmi->irqlock);
 
 	/* Disable interruptions */
 	reg_clear(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
@@ -726,12 +704,6 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	/* Disable DCMI */
 	reg_clear(dcmi->regs, DCMI_CR, CR_ENABLE);
 
-	if (!timeout) {
-		dev_err(dcmi->dev, "%s: Timeout during stop streaming\n",
-			__func__);
-		dcmi->state = STOPPED;
-	}
-
 	/* Return all queued buffers to vb2 in ERROR state */
 	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
 		list_del_init(&buf->list);
@@ -739,6 +711,7 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	}
 
 	dcmi->active = NULL;
+	dcmi->state = STOPPED;
 
 	spin_unlock_irq(&dcmi->irqlock);
 
-- 
1.9.1

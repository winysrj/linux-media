Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:14654 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934574AbeCHKrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Mar 2018 05:47:02 -0500
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
Subject: [PATCH v2] media: stm32-dcmi: rework overrun/error case
Date: Thu, 8 Mar 2018 11:46:23 +0100
Message-ID: <1520505983-29242-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not stop/restart dma on overrun or errors.
Dma will be restarted on current frame transfer
completion. Frame transfer completion is ensured
even if overrun or error occurs by DCMI continuous
capture mode which restarts data transfer at next
frame sync.
Do no warn on overrun while in irq thread, this slows down
system and lead to more overrun errors. Use a counter
instead and log errors at stop streaming.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
version 2:
  - typo: remove blank line at the end of stop_streaming()

 drivers/media/platform/stm32/stm32-dcmi.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 37d82d3..95ace0f 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -160,6 +160,7 @@ struct stm32_dcmi {
 	dma_cookie_t			dma_cookie;
 	u32				misr;
 	int				errors_count;
+	int				overrun_count;
 	int				buffers_count;
 };
 
@@ -373,23 +374,9 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 	}
 
 	if ((dcmi->misr & IT_OVR) || (dcmi->misr & IT_ERR)) {
-		/*
-		 * An overflow or an error has been detected,
-		 * stop current DMA transfert & restart it
-		 */
-		dev_warn(dcmi->dev, "%s: Overflow or error detected\n",
-			 __func__);
-
 		dcmi->errors_count++;
-		dev_dbg(dcmi->dev, "Restarting capture after DCMI error\n");
-
-		spin_unlock_irq(&dcmi->irqlock);
-		dmaengine_terminate_all(dcmi->dma_chan);
-
-		if (dcmi_start_capture(dcmi))
-			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
-				__func__);
-		return IRQ_HANDLED;
+		if (dcmi->misr & IT_OVR)
+			dcmi->overrun_count++;
 	}
 
 	spin_unlock_irq(&dcmi->irqlock);
@@ -572,6 +559,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	dcmi->sequence = 0;
 	dcmi->errors_count = 0;
+	dcmi->overrun_count = 0;
 	dcmi->buffers_count = 0;
 	dcmi->active = NULL;
 
@@ -682,8 +670,13 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 
 	clk_disable(dcmi->mclk);
 
-	dev_dbg(dcmi->dev, "Stop streaming, errors=%d buffers=%d\n",
-		dcmi->errors_count, dcmi->buffers_count);
+	if (dcmi->errors_count)
+		dev_warn(dcmi->dev, "Some errors found while streaming: errors=%d (overrun=%d), buffers=%d\n",
+			 dcmi->errors_count, dcmi->overrun_count,
+			 dcmi->buffers_count);
+	dev_dbg(dcmi->dev, "Stop streaming, errors=%d (overrun=%d), buffers=%d\n",
+		dcmi->errors_count, dcmi->overrun_count,
+		dcmi->buffers_count);
 }
 
 static const struct vb2_ops dcmi_video_qops = {
-- 
1.9.1

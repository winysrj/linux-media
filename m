Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:7089 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753390AbeBGRj2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:39:28 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: fix lock scheme
Date: Wed, 7 Feb 2018 18:39:07 +0100
Message-ID: <1518025147-3058-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix lock scheme leading to spurious freeze.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 57 ++++++++++++++-----------------
 1 file changed, 25 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2fd8bed..4a75756 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -197,7 +197,7 @@ static void dcmi_dma_callback(void *param)
 	struct dma_tx_state state;
 	enum dma_status status;
 
-	spin_lock(&dcmi->irqlock);
+	spin_lock_irq(&dcmi->irqlock);
 
 	/* Check DMA status */
 	status = dmaengine_tx_status(chan, dcmi->dma_cookie, &state);
@@ -239,7 +239,7 @@ static void dcmi_dma_callback(void *param)
 				dcmi->errors_count++;
 				dcmi->active = NULL;
 
-				spin_unlock(&dcmi->irqlock);
+				spin_unlock_irq(&dcmi->irqlock);
 				return;
 			}
 
@@ -248,13 +248,11 @@ static void dcmi_dma_callback(void *param)
 
 			list_del_init(&dcmi->active->list);
 
-			if (dcmi_start_capture(dcmi)) {
+			spin_unlock_irq(&dcmi->irqlock);
+			if (dcmi_start_capture(dcmi))
 				dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete\n",
 					__func__);
-
-				spin_unlock(&dcmi->irqlock);
-				return;
-			}
+			return;
 		}
 
 		break;
@@ -263,7 +261,7 @@ static void dcmi_dma_callback(void *param)
 		break;
 	}
 
-	spin_unlock(&dcmi->irqlock);
+	spin_unlock_irq(&dcmi->irqlock);
 }
 
 static int dcmi_start_dma(struct stm32_dcmi *dcmi,
@@ -360,7 +358,7 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 {
 	struct stm32_dcmi *dcmi = arg;
 
-	spin_lock(&dcmi->irqlock);
+	spin_lock_irq(&dcmi->irqlock);
 
 	/* Stop capture is required */
 	if (dcmi->state == STOPPING) {
@@ -370,7 +368,7 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 
 		complete(&dcmi->complete);
 
-		spin_unlock(&dcmi->irqlock);
+		spin_unlock_irq(&dcmi->irqlock);
 		return IRQ_HANDLED;
 	}
 
@@ -383,35 +381,34 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 			 __func__);
 
 		dcmi->errors_count++;
-		dmaengine_terminate_all(dcmi->dma_chan);
-
 		dev_dbg(dcmi->dev, "Restarting capture after DCMI error\n");
 
-		if (dcmi_start_capture(dcmi)) {
+		spin_unlock_irq(&dcmi->irqlock);
+		dmaengine_terminate_all(dcmi->dma_chan);
+
+		if (dcmi_start_capture(dcmi))
 			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
 				__func__);
-
-			spin_unlock(&dcmi->irqlock);
-			return IRQ_HANDLED;
-		}
+		return IRQ_HANDLED;
 	}
 
-	spin_unlock(&dcmi->irqlock);
+	spin_unlock_irq(&dcmi->irqlock);
 	return IRQ_HANDLED;
 }
 
 static irqreturn_t dcmi_irq_callback(int irq, void *arg)
 {
 	struct stm32_dcmi *dcmi = arg;
+	unsigned long flags;
 
-	spin_lock(&dcmi->irqlock);
+	spin_lock_irqsave(&dcmi->irqlock, flags);
 
 	dcmi->misr = reg_read(dcmi->regs, DCMI_MIS);
 
 	/* Clear interrupt */
 	reg_set(dcmi->regs, DCMI_ICR, IT_FRAME | IT_OVR | IT_ERR);
 
-	spin_unlock(&dcmi->irqlock);
+	spin_unlock_irqrestore(&dcmi->irqlock, flags);
 
 	return IRQ_WAKE_THREAD;
 }
@@ -490,9 +487,8 @@ static void dcmi_buf_queue(struct vb2_buffer *vb)
 	struct stm32_dcmi *dcmi =  vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct dcmi_buf *buf = container_of(vbuf, struct dcmi_buf, vb);
-	unsigned long flags = 0;
 
-	spin_lock_irqsave(&dcmi->irqlock, flags);
+	spin_lock_irq(&dcmi->irqlock);
 
 	if ((dcmi->state == RUNNING) && (!dcmi->active)) {
 		dcmi->active = buf;
@@ -500,19 +496,17 @@ static void dcmi_buf_queue(struct vb2_buffer *vb)
 		dev_dbg(dcmi->dev, "Starting capture on buffer[%d] queued\n",
 			buf->vb.vb2_buf.index);
 
-		if (dcmi_start_capture(dcmi)) {
+		spin_unlock_irq(&dcmi->irqlock);
+		if (dcmi_start_capture(dcmi))
 			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
 				__func__);
-
-			spin_unlock_irqrestore(&dcmi->irqlock, flags);
-			return;
-		}
+		return;
 	} else {
 		/* Enqueue to video buffers list */
 		list_add_tail(&buf->list, &dcmi->buffers);
 	}
 
-	spin_unlock_irqrestore(&dcmi->irqlock, flags);
+	spin_unlock_irq(&dcmi->irqlock);
 }
 
 static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -598,20 +592,17 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
 
+	spin_unlock_irq(&dcmi->irqlock);
 	ret = dcmi_start_capture(dcmi);
 	if (ret) {
 		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture\n",
 			__func__);
-
-		spin_unlock_irq(&dcmi->irqlock);
 		goto err_subdev_streamoff;
 	}
 
 	/* Enable interruptions */
 	reg_set(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
 
-	spin_unlock_irq(&dcmi->irqlock);
-
 	return 0;
 
 err_subdev_streamoff:
@@ -654,7 +645,9 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 		dev_err(dcmi->dev, "%s: Failed to stop streaming, subdev streamoff error (%d)\n",
 			__func__, ret);
 
+	spin_lock_irq(&dcmi->irqlock);
 	dcmi->state = STOPPING;
+	spin_unlock_irq(&dcmi->irqlock);
 
 	timeout = wait_for_completion_interruptible_timeout(&dcmi->complete,
 							    time_ms);
-- 
1.9.1

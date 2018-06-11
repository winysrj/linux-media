Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37227 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932641AbeFKJvN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:51:13 -0400
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
Subject: [PATCH 4/4] media: stm32-dcmi: revisit buffer list management
Date: Mon, 11 Jun 2018 11:50:27 +0200
Message-ID: <1528710627-8566-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
References: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup "active" field usage and enhance list management
to avoid exceptions when releasing buffers on error or
stopping streaming.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 65 +++++++++++++++----------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 93bb03a..581ded0 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -191,7 +191,7 @@ static inline void reg_clear(void __iomem *base, u32 reg, u32 mask)
 	reg_write(base, reg, reg_read(base, reg) & ~mask);
 }
 
-static int dcmi_start_capture(struct stm32_dcmi *dcmi);
+static int dcmi_start_capture(struct stm32_dcmi *dcmi, struct dcmi_buf *buf);
 
 static void dcmi_buffer_done(struct stm32_dcmi *dcmi,
 			     struct dcmi_buf *buf,
@@ -203,6 +203,8 @@ static void dcmi_buffer_done(struct stm32_dcmi *dcmi,
 	if (!buf)
 		return;
 
+	list_del_init(&buf->list);
+
 	vbuf = &buf->vb;
 
 	vbuf->sequence = dcmi->sequence++;
@@ -220,6 +222,8 @@ static void dcmi_buffer_done(struct stm32_dcmi *dcmi,
 
 static int dcmi_restart_capture(struct stm32_dcmi *dcmi)
 {
+	struct dcmi_buf *buf;
+
 	spin_lock_irq(&dcmi->irqlock);
 
 	if (dcmi->state != RUNNING) {
@@ -230,19 +234,16 @@ static int dcmi_restart_capture(struct stm32_dcmi *dcmi)
 	/* Restart a new DMA transfer with next buffer */
 	if (list_empty(&dcmi->buffers)) {
 		dev_dbg(dcmi->dev, "Capture restart is deferred to next buffer queueing\n");
-		dcmi->active = NULL;
 		dcmi->state = WAIT_FOR_BUFFER;
 		spin_unlock_irq(&dcmi->irqlock);
 		return 0;
 	}
-
-	dcmi->active = list_entry(dcmi->buffers.next,
-				  struct dcmi_buf, list);
-	list_del_init(&dcmi->active->list);
+	buf = list_entry(dcmi->buffers.next, struct dcmi_buf, list);
+	dcmi->active = buf;
 
 	spin_unlock_irq(&dcmi->irqlock);
 
-	return dcmi_start_capture(dcmi);
+	return dcmi_start_capture(dcmi, buf);
 }
 
 static void dcmi_dma_callback(void *param)
@@ -252,6 +253,8 @@ static void dcmi_dma_callback(void *param)
 	enum dma_status status;
 	struct dcmi_buf *buf = dcmi->active;
 
+	spin_lock_irq(&dcmi->irqlock);
+
 	/* Check DMA status */
 	status = dmaengine_tx_status(dcmi->dma_chan, dcmi->dma_cookie, &state);
 
@@ -274,15 +277,19 @@ static void dcmi_dma_callback(void *param)
 		/* Return buffer to V4L2 */
 		dcmi_buffer_done(dcmi, buf, buf->size, 0);
 
+		spin_unlock_irq(&dcmi->irqlock);
+
 		/* Restart capture */
 		if (dcmi_restart_capture(dcmi))
 			dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete\n",
 				__func__);
-		break;
+		return;
 	default:
 		dev_err(dcmi->dev, "%s: Received unknown status\n", __func__);
 		break;
 	}
+
+	spin_unlock_irq(&dcmi->irqlock);
 }
 
 static int dcmi_start_dma(struct stm32_dcmi *dcmi,
@@ -334,10 +341,9 @@ static int dcmi_start_dma(struct stm32_dcmi *dcmi,
 	return 0;
 }
 
-static int dcmi_start_capture(struct stm32_dcmi *dcmi)
+static int dcmi_start_capture(struct stm32_dcmi *dcmi, struct dcmi_buf *buf)
 {
 	int ret;
-	struct dcmi_buf *buf = dcmi->active;
 
 	if (!buf)
 		return -EINVAL;
@@ -491,8 +497,6 @@ static int dcmi_queue_setup(struct vb2_queue *vq,
 	*nplanes = 1;
 	sizes[0] = size;
 
-	dcmi->active = NULL;
-
 	dev_dbg(dcmi->dev, "Setup queue, count=%d, size=%d\n",
 		*nbuffers, size);
 
@@ -550,23 +554,24 @@ static void dcmi_buf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irq(&dcmi->irqlock);
 
-		dcmi->active = buf;
+	/* Enqueue to video buffers list */
+	list_add_tail(&buf->list, &dcmi->buffers);
 
 	if (dcmi->state == WAIT_FOR_BUFFER) {
 		dcmi->state = RUNNING;
+		dcmi->active = buf;
 
 		dev_dbg(dcmi->dev, "Starting capture on buffer[%d] queued\n",
 			buf->vb.vb2_buf.index);
 
 		spin_unlock_irq(&dcmi->irqlock);
-		if (dcmi_start_capture(dcmi))
+		if (dcmi_start_capture(dcmi, buf))
 			dev_err(dcmi->dev, "%s: Cannot restart capture on overflow or error\n",
 				__func__);
-	} else {
-		/* Enqueue to video buffers list */
-		list_add_tail(&buf->list, &dcmi->buffers);
-		spin_unlock_irq(&dcmi->irqlock);
+		return;
 	}
+
+	spin_unlock_irq(&dcmi->irqlock);
 }
 
 static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -638,7 +643,6 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	dcmi->errors_count = 0;
 	dcmi->overrun_count = 0;
 	dcmi->buffers_count = 0;
-	dcmi->active = NULL;
 
 	/*
 	 * Start transfer if at least one buffer has been queued,
@@ -651,15 +655,15 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return 0;
 	}
 
-	dcmi->active = list_entry(dcmi->buffers.next, struct dcmi_buf, list);
-	list_del_init(&dcmi->active->list);
-
-	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
+	buf = list_entry(dcmi->buffers.next, struct dcmi_buf, list);
+	dcmi->active = buf;
 
 	dcmi->state = RUNNING;
 
+	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
+
 	spin_unlock_irq(&dcmi->irqlock);
-	ret = dcmi_start_capture(dcmi);
+	ret = dcmi_start_capture(dcmi, buf);
 	if (ret) {
 		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture\n",
 			__func__);
@@ -683,15 +687,11 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 * Return all buffers to vb2 in QUEUED state.
 	 * This will give ownership back to userspace
 	 */
-	if (dcmi->active) {
-		buf = dcmi->active;
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
-		dcmi->active = NULL;
-	}
 	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
 		list_del_init(&buf->list);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
 	}
+	dcmi->active = NULL;
 	spin_unlock_irq(&dcmi->irqlock);
 
 	return ret;
@@ -733,16 +733,13 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	}
 
 	/* Return all queued buffers to vb2 in ERROR state */
-	if (dcmi->active) {
-		buf = dcmi->active;
-		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
-		dcmi->active = NULL;
-	}
 	list_for_each_entry_safe(buf, node, &dcmi->buffers, list) {
 		list_del_init(&buf->list);
 		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
 	}
 
+	dcmi->active = NULL;
+
 	spin_unlock_irq(&dcmi->irqlock);
 
 	/* Stop all pending DMA operations */
-- 
1.9.1

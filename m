Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57803 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754118AbeBGRgP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:36:15 -0500
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
Subject: [PATCH v1 3/3] media: stm32-dcmi: improve error trace points
Date: Wed, 7 Feb 2018 18:35:36 +0100
Message-ID: <1518024936-2455-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
References: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix some missing "\n".
Trace error returned by subdev streamon/streamoff.
Remove extra "0x" unneeded with %pad formatter.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index dfab867..2fd8bed 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -234,7 +234,7 @@ static void dcmi_dma_callback(void *param)
 		/* Restart a new DMA transfer with next buffer */
 		if (dcmi->state == RUNNING) {
 			if (list_empty(&dcmi->buffers)) {
-				dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer",
+				dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer\n",
 					__func__);
 				dcmi->errors_count++;
 				dcmi->active = NULL;
@@ -249,7 +249,7 @@ static void dcmi_dma_callback(void *param)
 			list_del_init(&dcmi->active->list);
 
 			if (dcmi_start_capture(dcmi)) {
-				dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete",
+				dev_err(dcmi->dev, "%s: Cannot restart capture on DMA complete\n",
 					__func__);
 
 				spin_unlock(&dcmi->irqlock);
@@ -478,7 +478,7 @@ static int dcmi_buf_prepare(struct vb2_buffer *vb)
 
 		vb2_set_plane_payload(&buf->vb.vb2_buf, 0, buf->size);
 
-		dev_dbg(dcmi->dev, "buffer[%d] phy=0x%pad size=%zu\n",
+		dev_dbg(dcmi->dev, "buffer[%d] phy=%pad size=%zu\n",
 			vb->index, &buf->paddr, buf->size);
 	}
 
@@ -524,7 +524,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	ret = clk_enable(dcmi->mclk);
 	if (ret) {
-		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot enable clock",
+		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot enable clock\n",
 			__func__);
 		goto err_release_buffers;
 	}
@@ -600,7 +600,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	ret = dcmi_start_capture(dcmi);
 	if (ret) {
-		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture",
+		dev_err(dcmi->dev, "%s: Start streaming failed, cannot start capture\n",
 			__func__);
 
 		spin_unlock_irq(&dcmi->irqlock);
@@ -651,7 +651,8 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	/* Disable stream on the sub device */
 	ret = v4l2_subdev_call(dcmi->entity.subdev, video, s_stream, 0);
 	if (ret && ret != -ENOIOCTLCMD)
-		dev_err(dcmi->dev, "stream off failed in subdev\n");
+		dev_err(dcmi->dev, "%s: Failed to stop streaming, subdev streamoff error (%d)\n",
+			__func__, ret);
 
 	dcmi->state = STOPPING;
 
@@ -667,7 +668,8 @@ static void dcmi_stop_streaming(struct vb2_queue *vq)
 	reg_clear(dcmi->regs, DCMI_CR, CR_ENABLE);
 
 	if (!timeout) {
-		dev_err(dcmi->dev, "Timeout during stop streaming\n");
+		dev_err(dcmi->dev, "%s: Timeout during stop streaming\n",
+			__func__);
 		dcmi->state = STOPPED;
 	}
 
-- 
1.9.1

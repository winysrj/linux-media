Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44685 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932745AbeFKJuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:50:55 -0400
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
Subject: [PATCH 3/4] media: stm32-dcmi: clarify state logic on buffer starvation
Date: Mon, 11 Jun 2018 11:50:26 +0200
Message-ID: <1528710627-8566-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
References: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce WAIT_FOR_BUFFER state instead of "active" field checking
to manage buffer starvation case.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 6ccf195..93bb03a 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -85,6 +85,7 @@
 
 enum state {
 	STOPPED = 0,
+	WAIT_FOR_BUFFER,
 	RUNNING,
 	STOPPING,
 };
@@ -230,6 +231,7 @@ static int dcmi_restart_capture(struct stm32_dcmi *dcmi)
 	if (list_empty(&dcmi->buffers)) {
 		dev_dbg(dcmi->dev, "Capture restart is deferred to next buffer queueing\n");
 		dcmi->active = NULL;
+		dcmi->state = WAIT_FOR_BUFFER;
 		spin_unlock_irq(&dcmi->irqlock);
 		return 0;
 	}
@@ -548,9 +550,11 @@ static void dcmi_buf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irq(&dcmi->irqlock);
 
-	if (dcmi->state == RUNNING && !dcmi->active) {
 		dcmi->active = buf;
 
+	if (dcmi->state == WAIT_FOR_BUFFER) {
+		dcmi->state = RUNNING;
+
 		dev_dbg(dcmi->dev, "Starting capture on buffer[%d] queued\n",
 			buf->vb.vb2_buf.index);
 
@@ -630,8 +634,6 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* Enable dcmi */
 	reg_set(dcmi->regs, DCMI_CR, CR_ENABLE);
 
-	dcmi->state = RUNNING;
-
 	dcmi->sequence = 0;
 	dcmi->errors_count = 0;
 	dcmi->overrun_count = 0;
@@ -644,6 +646,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	 */
 	if (list_empty(&dcmi->buffers)) {
 		dev_dbg(dcmi->dev, "Start streaming is deferred to next buffer queueing\n");
+		dcmi->state = WAIT_FOR_BUFFER;
 		spin_unlock_irq(&dcmi->irqlock);
 		return 0;
 	}
@@ -653,6 +656,8 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	dev_dbg(dcmi->dev, "Start streaming, starting capture\n");
 
+	dcmi->state = RUNNING;
+
 	spin_unlock_irq(&dcmi->irqlock);
 	ret = dcmi_start_capture(dcmi);
 	if (ret) {
-- 
1.9.1

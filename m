Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44082 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LKQHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 1/7] v4l: atmel-isi: remove SOF wait in start_streaming()
Date: Wed, 11 Dec 2013 17:07:39 +0100
Message-Id: <1386778065-14135-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

when a userspace applications calls the VIDIOC_STREAMON ioctl. The
V4L2 core calls the soc_camera_streamon function, which is responsible
for starting the video stream. It does so by first starting the atmel-isi
host by a call to the vb2_streamon function, and then starting the sensor
by a call to the video.s_stream sensor subdev operation.

That means we wait for a SOF in start_streaming() before call sensor's
s_stream(). It is possible no VSYNC interrupt arrive as the sensor
hasn't been started yet.

To avoid such case, this patch remove the code to wait for the VSYNC
interrupt. And such code is not necessary.

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 47 +--------------------------
 1 file changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 1044856..b46c0ed 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -34,13 +34,6 @@
 #define MIN_FRAME_RATE			15
 #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
 
-/* ISI states */
-enum {
-	ISI_STATE_IDLE = 0,
-	ISI_STATE_READY,
-	ISI_STATE_WAIT_SOF,
-};
-
 /* Frame buffer descriptor */
 struct fbd {
 	/* Physical address of the frame buffer */
@@ -75,11 +68,6 @@ struct atmel_isi {
 	void __iomem			*regs;
 
 	int				sequence;
-	/* State of the ISI module in capturing mode */
-	int				state;
-
-	/* Wait queue for waiting for SOF */
-	wait_queue_head_t		vsync_wq;
 
 	struct vb2_alloc_ctx		*alloc_ctx;
 
@@ -207,12 +195,6 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
 		isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
 		ret = IRQ_HANDLED;
 	} else {
-		if ((pending & ISI_SR_VSYNC) &&
-				(isi->state == ISI_STATE_IDLE)) {
-			isi->state = ISI_STATE_READY;
-			wake_up_interruptible(&isi->vsync_wq);
-			ret = IRQ_HANDLED;
-		}
 		if (likely(pending & ISI_SR_CXFR_DONE))
 			ret = atmel_isi_handle_streaming(isi);
 	}
@@ -407,43 +389,17 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
-
 	u32 sr = 0;
-	int ret;
 
 	spin_lock_irq(&isi->lock);
-	isi->state = ISI_STATE_IDLE;
-	/* Clear any pending SOF interrupt */
+	/* Clear any pending interrupt */
 	sr = isi_readl(isi, ISI_STATUS);
-	/* Enable VSYNC interrupt for SOF */
-	isi_writel(isi, ISI_INTEN, ISI_SR_VSYNC);
-	isi_writel(isi, ISI_CTRL, ISI_CTRL_EN);
-	spin_unlock_irq(&isi->lock);
-
-	dev_dbg(icd->parent, "Waiting for SOF\n");
-	ret = wait_event_interruptible(isi->vsync_wq,
-				       isi->state != ISI_STATE_IDLE);
-	if (ret)
-		goto err;
-
-	if (isi->state != ISI_STATE_READY) {
-		ret = -EIO;
-		goto err;
-	}
 
-	spin_lock_irq(&isi->lock);
-	isi->state = ISI_STATE_WAIT_SOF;
-	isi_writel(isi, ISI_INTDIS, ISI_SR_VSYNC);
 	if (count)
 		start_dma(isi, isi->active);
 	spin_unlock_irq(&isi->lock);
 
 	return 0;
-err:
-	isi->active = NULL;
-	isi->sequence = 0;
-	INIT_LIST_HEAD(&isi->video_buffer_list);
-	return ret;
 }
 
 /* abort streaming and wait for last buffer */
@@ -965,7 +921,6 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	isi->pdata = pdata;
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
-	init_waitqueue_head(&isi->vsync_wq);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
 	INIT_LIST_HEAD(&isi->dma_desc_head);
 
-- 
1.8.3.2


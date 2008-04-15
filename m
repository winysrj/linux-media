Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FDfxC2019538
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 09:41:59 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3FDfkFd023256
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 09:41:47 -0400
Date: Tue, 15 Apr 2008 15:41:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0804151534070.6851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] pxa-camera: handle FIFO overruns
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

FIFO overruns are not seldom on PXA camera interface FIFOs. Handle them by 
dropping the corrupted frame, waiting for the next start-of-frame, and 
restarting capture.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index b999bda..1dcfd91 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -118,6 +118,7 @@ struct pxa_camera_dev {
 	unsigned int		irq;
 	void __iomem		*base;
 
+	int			channels;
 	unsigned int		dma_chans[3];
 
 	struct pxacamera_platform_data *pdata;
@@ -398,14 +399,10 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	} else {
 		struct pxa_cam_dma *buf_dma;
 		struct pxa_cam_dma *act_dma;
-		int channels = 1;
 		int nents;
 		int i;
 
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
-			channels = 3;
-
-		for (i = 0; i < channels; i++) {
+		for (i = 0; i < pcdev->channels; i++) {
 			buf_dma = &buf->dmas[i];
 			act_dma = &active->dmas[i];
 			nents = buf_dma->sglen;
@@ -445,20 +442,6 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 
 			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
 		}
-#ifdef DEBUG
-		if (CISR & (CISR_IFO_0 | CISR_IFO_1 | CISR_IFO_2)) {
-			dev_warn(pcdev->dev, "FIFO overrun\n");
-			for (i = 0; i < channels; i++)
-				DDADR(pcdev->dma_chans[i]) =
-					pcdev->active->dmas[i].sg_dma;
-
-			CICR0 &= ~CICR0_ENB;
-			CIFR |= CIFR_RESET_F;
-			for (i = 0; i < channels; i++)
-				DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
-			CICR0 |= CICR0_ENB;
-		}
-#endif
 	}
 
 	spin_unlock_irqrestore(&pcdev->lock, flags);
@@ -522,7 +505,7 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 {
 	struct pxa_buffer *buf;
 	unsigned long flags;
-	unsigned int status;
+	u32 status, camera_status, overrun;
 	struct videobuf_buffer *vb;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -546,6 +529,25 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
 		goto out;
 	}
 
+	camera_status = CISR;
+	overrun = CISR_IFO_0;
+	if (pcdev->channels == 3)
+		overrun |= CISR_IFO_1 | CISR_IFO_2;
+	if (camera_status & overrun) {
+		dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n", camera_status);
+		/* Stop the Capture Interface */
+		CICR0 &= ~CICR0_ENB;
+		/* Stop DMA */
+		DCSR(channel) = 0;
+		/* Reset the FIFOs */
+		CIFR |= CIFR_RESET_F;
+		/* Enable End-Of-Frame Interrupt */
+		CICR0 &= ~CICR0_EOFM;
+		/* Restart the Capture Interface */
+		CICR0 |= CICR0_ENB;
+		goto out;
+	}
+
 	vb = &pcdev->active->vb;
 	buf = container_of(vb, struct pxa_buffer, vb);
 	WARN_ON(buf->inwork || list_empty(&vb->queue));
@@ -670,7 +672,21 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 
 	dev_dbg(pcdev->dev, "Camera interrupt status 0x%x\n", status);
 
+	if (!status)
+		return IRQ_NONE;
+
 	CISR = status;
+
+	if (status & CISR_EOF) {
+		int i;
+		for (i = 0; i < pcdev->channels; i++) {
+			DDADR(pcdev->dma_chans[i]) =
+				pcdev->active->dmas[i].sg_dma;
+			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
+		}
+		CICR0 |= CICR0_EOFM;
+	}
+
 	return IRQ_HANDLED;
 }
 
@@ -785,6 +801,8 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	if (!common_flags)
 		return -EINVAL;
 
+	pcdev->channels = 1;
+
 	/* Make choises, based on platform preferences */
 	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
 	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
@@ -855,6 +873,7 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_YUV422P:
+		pcdev->channels = 3;
 		cicr1 |= CICR1_YCBCR_F;
 	case V4L2_PIX_FMT_YUYV:
 		cicr1 |= CICR1_COLOR_SP_VAL(2);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

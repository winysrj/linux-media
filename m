Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m39ENvFu012659
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 10:23:57 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m39ENdiX027658
	for <video4linux-list@redhat.com>; Wed, 9 Apr 2008 10:23:39 -0400
Date: Wed, 9 Apr 2008 16:23:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804091616470.5671@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

On Wed, 9 Apr 2008, ·ëöÎ wrote:

> Thank you very much.I will wait for your patch and test it.

Please test the patch below. It should apply on the top of v4l-dvb plus, 
if this patch is yet not there, the patch from 
http://marc.info/?l=linux-video&m=120771921814753&w=2

Please test with your test application, see if the frame origin iw now 
correct, and if you too get the partially inverted frame sequence, i.e., 
like 1, 3, 2, 5, 4,... If yes, try reducing the number of buffers to 2 and 
see if this problem disappears then.

Thanks
Guennadi
---
Guennadi Liakhovetski

--- a/drivers/media/video/pxa_camera.c	2008-04-08 19:02:06.000000000 +0200
+++ b/drivers/media/video/pxa_camera.c	2008-04-09 15:50:25.000000000 +0200
@@ -120,6 +120,7 @@
 	unsigned int		irq;
 	void __iomem		*base;
 
+	int			channels;
 	unsigned int		dma_chans[3];
 
 	struct pxacamera_platform_data *pdata;
@@ -400,14 +401,10 @@
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
@@ -447,20 +444,6 @@
 
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
@@ -524,7 +507,7 @@
 {
 	struct pxa_buffer *buf;
 	unsigned long flags;
-	unsigned int status;
+	u32 status, camera_status, overrun;
 	struct videobuf_buffer *vb;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
@@ -548,6 +531,27 @@
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
+		/* Restart DMA */
+		/*DCSR(channel) = DCSR_RUN;*/
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
@@ -672,7 +676,21 @@
 
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
 
@@ -787,6 +805,8 @@
 	if (!common_flags)
 		return -EINVAL;
 
+	pcdev->channels = 1;
+
 	/* Make choises, based on platform preferences */
 	if ((common_flags & SOCAM_HSYNC_ACTIVE_HIGH) &&
 	    (common_flags & SOCAM_HSYNC_ACTIVE_LOW)) {
@@ -857,6 +877,7 @@
 
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

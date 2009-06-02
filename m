Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753237AbZFBPrC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2009 11:47:02 -0400
Date: Tue, 2 Jun 2009 17:47:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	morimoto.kuninori@renesas.com, matthieu.castet@parrot.com
Subject: [PATCH] sh-mobile-ceu-camera: do not wait for interrupt when releasing
 buffers
In-Reply-To: <20090226103932.30237.96661.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0906021641090.4824@axis700.grange>
References: <20090226103932.30237.96661.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch

[PATCH] video: use videobuf_waiton() in sh_mobile_ceu free_buffer()

was not quite correct. It closed a race, but introduced a potential 
lock-up, if for some reason an interrupt does not come. This has been 
observed in tests with tw9910. This patch safely dequeues buffers without 
waiting for their completion. It also moves a buffer state assignment 
under a spinlock to make it atomic with queuing of the buffer.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index d890f8d..67c7dcd 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -296,8 +306,8 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	vb->state = VIDEOBUF_QUEUED;
 	spin_lock_irqsave(&pcdev->lock, flags);
+	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	if (!pcdev->active) {
@@ -311,6 +321,27 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 static void sh_mobile_ceu_videobuf_release(struct videobuf_queue *vq,
 					   struct videobuf_buffer *vb)
 {
+	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	if (pcdev->active == vb) {
+		/* disable capture (release DMA buffer), reset */
+		ceu_write(pcdev, CAPSR, 1 << 16);
+		pcdev->active = NULL;
+	}
+
+	if ((vb->state == VIDEOBUF_ACTIVE || vb->state == VIDEOBUF_QUEUED) &&
+	    !list_empty(&vb->queue)) {
+		vb->state = VIDEOBUF_ERROR;
+		list_del_init(&vb->queue);
+	}
+
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
 	free_buffer(vq, container_of(vb, struct sh_mobile_ceu_buffer, vb));
 }
 
@@ -330,6 +361,10 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	spin_lock_irqsave(&pcdev->lock, flags);
 
 	vb = pcdev->active;
+	if (!vb)
+		/* Stale interrupt from a released buffer */
+		goto out;
+
 	list_del_init(&vb->queue);
 
 	if (!list_empty(&pcdev->capture))
@@ -344,6 +379,8 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	do_gettimeofday(&vb->ts);
 	vb->field_count++;
 	wake_up(&vb->done);
+
+out:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
 	return IRQ_HANDLED;

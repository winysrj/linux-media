Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35927 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754994AbZHDIao (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2009 04:30:44 -0400
Date: Tue, 4 Aug 2009 10:30:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: fix recursive locking in .buf_queue()
In-Reply-To: <20090804020252.f33f481d.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0908041023450.4627@axis700.grange>
References: <20090804020252.f33f481d.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The .buf_queue() V4L2 driver method is called under 
spinlock_irqsave(q->irqlock,...), don't take the lock again inside the 
function.

Reported-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Subject: Re: [BUG] pxa_camera: possible recursive locking detected

On Tue, 4 Aug 2009, Antonio Ospite wrote:

> Hi,
> 
> verified to be present in linux-2.6.31-rc5, here's some info dumped
> from RAM, since the machine hangs, sorry if it is not complete but I
> couldn't get anything better for now, nothing is printed on
> the screen.

You're right, thanks for the report. Does the patch below fix the problem? 
It only gets a bit tricky in mx3_camera.c, will have to test.

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 9632cb1..3e95c6d 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -235,6 +235,7 @@ static int mx1_camera_setup_dma(struct mx1_camera_dev *pcdev)
 	return ret;
 }
 
+/* Called under spinlock_irqsave(&pcdev->lock, ...) */
 static void mx1_videobuf_queue(struct videobuf_queue *vq,
 						struct videobuf_buffer *vb)
 {
@@ -247,8 +248,6 @@ static void mx1_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	spin_lock_irqsave(&pcdev->lock, flags);
-
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	vb->state = VIDEOBUF_ACTIVE;
@@ -265,8 +264,6 @@ static void mx1_videobuf_queue(struct videobuf_queue *vq,
 			__raw_writel(temp, pcdev->base + CSICR1);
 		}
 	}
-
-	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void mx1_videobuf_release(struct videobuf_queue *vq,
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 6572ce7..1c70165 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -332,7 +332,10 @@ static enum pixel_fmt fourcc_to_ipu_pix(__u32 fourcc)
 	}
 }
 
-/* Called with .vb_lock held */
+/*
+ * Called with .vb_lock mutex held and
+ * under spinlock_irqsave(&mx3_cam->lock, ...)
+ */
 static void mx3_videobuf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
@@ -348,6 +351,8 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	dma_cookie_t cookie;
 	unsigned long flags;
 
+	BUG_ON(!irqs_disabled());
+
 	/* This is the configuration of one sg-element */
 	video->out_pixel_fmt	= fourcc_to_ipu_pix(data_fmt->fourcc);
 	video->out_width	= icd->user_width;
@@ -359,8 +364,6 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	memset((void *)vb->baddr, 0xaa, vb->bsize);
 #endif
 
-	spin_lock_irqsave(&mx3_cam->lock, flags);
-
 	list_add_tail(&vb->queue, &mx3_cam->capture);
 
 	if (!mx3_cam->active) {
@@ -370,7 +373,7 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 		vb->state = VIDEOBUF_QUEUED;
 	}
 
-	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+	spin_unlock_irq(&mx3_cam->lock);
 
 	cookie = txd->tx_submit(txd);
 	dev_dbg(icd->dev.parent, "Submitted cookie %d DMA 0x%08x\n",
@@ -381,14 +384,12 @@ static void mx3_videobuf_queue(struct videobuf_queue *vq,
 	/* Submit error */
 	vb->state = VIDEOBUF_PREPARED;
 
-	spin_lock_irqsave(&mx3_cam->lock, flags);
+	spin_lock_irq(&mx3_cam->lock);
 
 	list_del_init(&vb->queue);
 
 	if (mx3_cam->active == buf)
 		mx3_cam->active = NULL;
-
-	spin_unlock_irqrestore(&mx3_cam->lock, flags);
 }
 
 /* Called with .vb_lock held */
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 7c86ef9..77be871 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -617,6 +617,7 @@ static void pxa_camera_stop_capture(struct pxa_camera_dev *pcdev)
 	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "%s\n", __func__);
 }
 
+/* Called under spinlock_irqsave(&pcdev->lock, ...) */
 static void pxa_videobuf_queue(struct videobuf_queue *vq,
 			       struct videobuf_buffer *vb)
 {
@@ -629,8 +630,6 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d active=%p\n",
 		__func__, vb, vb->baddr, vb->bsize, pcdev->active);
 
-	spin_lock_irqsave(&pcdev->lock, flags);
-
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	vb->state = VIDEOBUF_ACTIVE;
@@ -638,8 +637,6 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 
 	if (!pcdev->active)
 		pxa_camera_start_capture(pcdev);
-
-	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void pxa_videobuf_release(struct videobuf_queue *vq,
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 0aacb31..ce808a1 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -304,6 +304,7 @@ out:
 	return ret;
 }
 
+/* Called under spinlock_irqsave(&pcdev->lock, ...) */
 static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 					 struct videobuf_buffer *vb)
 {
@@ -315,7 +316,6 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
 		vb, vb->baddr, vb->bsize);
 
-	spin_lock_irqsave(&pcdev->lock, flags);
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &pcdev->capture);
 
@@ -323,8 +323,6 @@ static void sh_mobile_ceu_videobuf_queue(struct videobuf_queue *vq,
 		pcdev->active = vb;
 		sh_mobile_ceu_capture(pcdev);
 	}
-
-	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void sh_mobile_ceu_videobuf_release(struct videobuf_queue *vq,

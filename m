Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYHhN027502
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:17 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAY4mi018492
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:04 -0400
Received: by fg-out-1718.google.com with SMTP id e12so175182fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:04 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <7876c2bc2446dc3e3630.1206699512@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:32 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Guennadi Liakhovetski <kernel@pengutronix.de>
Subject: [PATCH 1 of 9] soc_camera: Introduce a spinlock for use with
	videobuf
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699276 25200
# Node ID 7876c2bc2446dc3e3630e7a30a76f50874116cf1
# Parent  1df4f66ca1fc98ccad4c8377484a56adaf23e49d
soc_camera: Introduce a spinlock for use with videobuf

Videobuf will require all drivers to use a spinlock to protect the IRQ queue.
Introduce this lock for the SOC/PXA drivers.

Signed-off-by: Brandon Philips <bphilips@suse.de>
CC: Guennadi Liakhovetski <kernel@pengutronix.de>

---
 linux/drivers/media/video/pxa_camera.c |   11 ++++-------
 linux/drivers/media/video/soc_camera.c |    5 +++--
 linux/include/media/soc_camera.h       |    1 +
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/linux/drivers/media/video/pxa_camera.c b/linux/drivers/media/video/pxa_camera.c
--- a/linux/drivers/media/video/pxa_camera.c
+++ b/linux/drivers/media/video/pxa_camera.c
@@ -108,8 +108,6 @@ struct pxa_camera_dev {
 	unsigned long		platform_mclk_10khz;
 
 	struct list_head	capture;
-
-	spinlock_t		lock;
 
 	struct pxa_buffer	*active;
 };
@@ -283,7 +281,7 @@ static void pxa_videobuf_queue(struct vi
 
 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
 		vb, vb->baddr, vb->bsize);
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irqsave(&icd->irqlock, flags);
 
 	list_add_tail(&vb->queue, &pcdev->capture);
 
@@ -343,7 +341,7 @@ static void pxa_videobuf_queue(struct vi
 			DCSR(pcdev->dma_chan_y) = DCSR_RUN;
 	}
 
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irqrestore(&icd->irqlock, flags);
 
 }
 
@@ -384,7 +382,7 @@ static void pxa_camera_dma_irq_y(int cha
 	unsigned int status;
 	struct videobuf_buffer *vb;
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock_irqsave(&pcdev->icd->irqlock, flags);
 
 	status = DCSR(pcdev->dma_chan_y);
 	DCSR(pcdev->dma_chan_y) = status;
@@ -429,7 +427,7 @@ static void pxa_camera_dma_irq_y(int cha
 				   vb.queue);
 
 out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock_irqrestore(&pcdev->icd->irqlock, flags);
 }
 
 static struct videobuf_queue_ops pxa_videobuf_ops = {
@@ -869,7 +867,6 @@ static int pxa_camera_probe(struct platf
 	}
 
 	INIT_LIST_HEAD(&pcdev->capture);
-	spin_lock_init(&pcdev->lock);
 
 	/*
 	 * Request the regions.
diff --git a/linux/drivers/media/video/soc_camera.c b/linux/drivers/media/video/soc_camera.c
--- a/linux/drivers/media/video/soc_camera.c
+++ b/linux/drivers/media/video/soc_camera.c
@@ -229,8 +229,8 @@ static int soc_camera_open(struct inode 
 	dev_dbg(&icd->dev, "camera device open\n");
 
 	/* We must pass NULL as dev pointer, then all pci_* dma operations
-	 * transform to normal dma_* ones. Do we need an irqlock? */
-	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, NULL,
+	 * transform to normal dma_* ones. */
+	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, &icd->irqlock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				ici->msize, icd);
 
@@ -714,6 +714,7 @@ static int soc_camera_probe(struct devic
 	if (ret >= 0) {
 		const struct v4l2_queryctrl *qctrl;
 
+		spin_lock_init(&icd->irqlock);
 		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_GAIN);
 		icd->gain = qctrl ? qctrl->default_value : (unsigned short)~0;
 		qctrl = soc_camera_find_qctrl(icd->ops, V4L2_CID_EXPOSURE);
diff --git a/linux/include/media/soc_camera.h b/linux/include/media/soc_camera.h
--- a/linux/include/media/soc_camera.h
+++ b/linux/include/media/soc_camera.h
@@ -19,6 +19,7 @@ struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
 	struct device *control;
+	spinlock_t irqlock;
 	unsigned short width;		/* Current window */
 	unsigned short height;		/* sizes */
 	unsigned short x_min;		/* Camera capabilities */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

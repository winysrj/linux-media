Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:58764 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1BRINo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 03:13:44 -0500
Date: Fri, 18 Feb 2011 09:13:42 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: linux-sh@vger.kernel.org
Subject: [PATCH 3/4] V4L: sh_mobile_ceu_camera: fix videobuffer queue locking
In-Reply-To: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
Message-ID: <Pine.LNX.4.64.1102180908110.1851@axis700.grange>
References: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

After the switch to videobuf2, videobuffer callbacks are called unlocked,
therefore they have to protect their internal data themselves.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This one will be merged with https://patchwork.kernel.org/patch/516491/

 drivers/media/video/sh_mobile_ceu_camera.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 5a8d942..325f50d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -100,8 +100,7 @@ struct sh_mobile_ceu_dev {
 	void __iomem *base;
 	unsigned long video_limit;
 
-	/* lock used to protect videobuf */
-	spinlock_t lock;
+	spinlock_t lock;		/* Protects video buffer lists */
 	struct list_head capture;
 	struct vb2_buffer *active;
 	struct vb2_alloc_ctx *alloc_ctx;
@@ -375,17 +374,18 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-/* Called under spinlock_irqsave(&pcdev->lock, ...) */
 static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 {
 	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
+	unsigned long flags;
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
 		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
 
+	spin_lock_irqsave(&pcdev->lock, flags);
 	list_add_tail(&buf->queue, &pcdev->capture);
 
 	if (!pcdev->active) {
@@ -397,6 +397,7 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
 		pcdev->active = vb;
 		sh_mobile_ceu_capture(pcdev);
 	}
+	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
 static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
@@ -442,10 +443,9 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 {
 	struct sh_mobile_ceu_dev *pcdev = data;
 	struct vb2_buffer *vb;
-	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&pcdev->lock, flags);
+	spin_lock(&pcdev->lock);
 
 	vb = pcdev->active;
 	if (!vb)
@@ -469,7 +469,7 @@ static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
 	vb2_buffer_done(vb, ret < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
 out:
-	spin_unlock_irqrestore(&pcdev->lock, flags);
+	spin_unlock(&pcdev->lock);
 
 	return IRQ_HANDLED;
 }
@@ -669,6 +669,7 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 		ceu_write(pcdev, CAPSR, capsr);
 }
 
+/* Capture is not running, no interrupts, no locking needed */
 static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 				       __u32 pixfmt)
 {
-- 
1.7.2.3


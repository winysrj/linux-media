Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51526 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2A3MO0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:14:26 -0500
Received: by werb13 with SMTP id b13so3366296wer.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 04:14:25 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 2/4] media i.MX27 camera: add start_stream and stop_stream callbacks.
Date: Mon, 30 Jan 2012 13:14:11 +0100
Message-Id: <1327925653-13310-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1327925653-13310-1-git-send-email-javier.martin@vista-silicon.com>
References: <1327925653-13310-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add "start_stream" and "stop_stream" callback in order to enable
and disable the eMMa-PrP properly and save CPU usage avoiding
IRQs when the device is not streaming. This also makes the driver
return 0 as the sequence number of the first frame.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 - Make start_streaming cleaner.

---
 drivers/media/video/mx2_camera.c |  100 ++++++++++++++++++++++++++++---------
 1 files changed, 75 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ae7cae6..35ab971 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -377,7 +377,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
-	pcdev->frame_count = 0;
+	pcdev->frame_count = -1;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -656,11 +656,79 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 }
 
+static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
+{
+	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+
+	if (mx27_camera_emma(pcdev)) {
+		unsigned long flags;
+		if (count < 2)
+			return -EINVAL;
+
+		spin_lock_irqsave(&pcdev->lock, flags);
+		if (prp->cfg.channel == 1) {
+			writel(PRP_CNTL_CH1EN |
+				PRP_CNTL_CSIEN |
+				prp->cfg.in_fmt |
+				prp->cfg.out_fmt |
+				PRP_CNTL_CH1_LEN |
+				PRP_CNTL_CH1BYP |
+				PRP_CNTL_CH1_TSKIP(0) |
+				PRP_CNTL_IN_TSKIP(0),
+				pcdev->base_emma + PRP_CNTL);
+		} else {
+			writel(PRP_CNTL_CH2EN |
+				PRP_CNTL_CSIEN |
+				prp->cfg.in_fmt |
+				prp->cfg.out_fmt |
+				PRP_CNTL_CH2_LEN |
+				PRP_CNTL_CH2_TSKIP(0) |
+				PRP_CNTL_IN_TSKIP(0),
+				pcdev->base_emma + PRP_CNTL);
+		}
+		spin_unlock_irqrestore(&pcdev->lock, flags);
+	}
+
+	return 0;
+}
+
+static int mx2_stop_streaming(struct vb2_queue *q)
+{
+	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->parent);
+	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
+	unsigned long flags;
+	u32 cntl;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+	if (mx27_camera_emma(pcdev)) {
+		cntl = readl(pcdev->base_emma + PRP_CNTL);
+		if (prp->cfg.channel == 1) {
+			writel(cntl & ~PRP_CNTL_CH1EN,
+			       pcdev->base_emma + PRP_CNTL);
+		} else {
+			writel(cntl & ~PRP_CNTL_CH2EN,
+			       pcdev->base_emma + PRP_CNTL);
+		}
+	}
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
+	return 0;
+}
+
 static struct vb2_ops mx2_videobuf_ops = {
-	.queue_setup	= mx2_videobuf_setup,
-	.buf_prepare	= mx2_videobuf_prepare,
-	.buf_queue	= mx2_videobuf_queue,
-	.buf_cleanup	= mx2_videobuf_release,
+	.queue_setup	 = mx2_videobuf_setup,
+	.buf_prepare	 = mx2_videobuf_prepare,
+	.buf_queue	 = mx2_videobuf_queue,
+	.buf_cleanup	 = mx2_videobuf_release,
+	.start_streaming = mx2_start_streaming,
+	.stop_streaming	 = mx2_stop_streaming,
 };
 
 static int mx2_camera_init_videobuf(struct vb2_queue *q,
@@ -718,16 +786,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 		writel(pcdev->discard_buffer_dma,
 				pcdev->base_emma + PRP_DEST_RGB2_PTR);
 
-		writel(PRP_CNTL_CH1EN |
-				PRP_CNTL_CSIEN |
-				prp->cfg.in_fmt |
-				prp->cfg.out_fmt |
-				PRP_CNTL_CH1_LEN |
-				PRP_CNTL_CH1BYP |
-				PRP_CNTL_CH1_TSKIP(0) |
-				PRP_CNTL_IN_TSKIP(0),
-				pcdev->base_emma + PRP_CNTL);
-
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 		writel((icd->user_width << 16) | icd->user_height,
@@ -755,15 +813,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 				pcdev->base_emma + PRP_SOURCE_CR_PTR);
 		}
 
-		writel(PRP_CNTL_CH2EN |
-			PRP_CNTL_CSIEN |
-			prp->cfg.in_fmt |
-			prp->cfg.out_fmt |
-			PRP_CNTL_CH2_LEN |
-			PRP_CNTL_CH2_TSKIP(0) |
-			PRP_CNTL_IN_TSKIP(0),
-			pcdev->base_emma + PRP_CNTL);
-
 		writel((icd->user_width << 16) | icd->user_height,
 			pcdev->base_emma + PRP_SRC_FRAME_SIZE);
 
@@ -1169,11 +1218,12 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 
 		list_del_init(&buf->queue);
 		do_gettimeofday(&vb->v4l2_buf.timestamp);
-		pcdev->frame_count++;
 		vb->v4l2_buf.sequence = pcdev->frame_count;
 		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
+	pcdev->frame_count++;
+
 	if (list_empty(&pcdev->capture)) {
 		if (prp->cfg.channel == 1) {
 			writel(pcdev->discard_buffer_dma, pcdev->base_emma +
-- 
1.7.0.4


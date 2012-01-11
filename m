Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:44838 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab2AKQBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:01:14 -0500
Received: by wibhm14 with SMTP id hm14so478078wib.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:01:13 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, g.liakhovetski@gmx.de, lethal@linux-sh.org,
	hans.verkuil@cisco.com, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2] media i.MX27 camera: properly detect frame loss.
Date: Wed, 11 Jan 2012 17:01:04 +0100
Message-Id: <1326297664-19089-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As V4L2 specification states, frame_count must also
regard lost frames so that the user can handle that
case properly.

This patch adds a mechanism to increment the frame
counter even when a video buffer is not available
and a discard buffer is used.

---
Changes since v1:
 - Initialize "frame_count" to -1 instead of using
   "firstirq" variable.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   45 ++++++++++++++++++++-----------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index ca76dd2..68038e7 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -369,7 +369,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
 
 	pcdev->icd = icd;
-	pcdev->frame_count = 0;
+	pcdev->frame_count = -1;
 
 	dev_info(icd->parent, "Camera driver attached to camera %d\n",
 		 icd->devnum);
@@ -572,6 +572,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 	struct soc_camera_host *ici =
 		to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
+	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
 	unsigned long flags;
 
@@ -584,6 +585,26 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
 	list_add_tail(&vb->queue, &pcdev->capture);
 
 	if (mx27_camera_emma(pcdev)) {
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
 		goto out;
 	} else { /* cpu_is_mx25() */
 		u32 csicr3, dma_inten = 0;
@@ -747,16 +768,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
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
@@ -784,15 +795,6 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
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
 
@@ -1214,7 +1216,6 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		vb->state = state;
 		do_gettimeofday(&vb->ts);
 		vb->field_count = pcdev->frame_count * 2;
-		pcdev->frame_count++;
 
 		wake_up(&vb->done);
 	}
@@ -1239,6 +1240,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		return;
 	}
 
+	pcdev->frame_count++;
+
 	buf = list_entry(pcdev->capture.next,
 			struct mx2_buffer, vb.queue);
 
-- 
1.7.0.4


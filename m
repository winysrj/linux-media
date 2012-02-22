Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab2BVKer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 05:34:47 -0500
Received: by wgbdt10 with SMTP id dt10so6567483wgb.1
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 02:34:45 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v4 4/4] media i.MX27 camera: handle overflows properly.
Date: Wed, 22 Feb 2012 11:34:36 +0100
Message-Id: <1329906876-10733-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 Changes since v3:
 - Reset the channels properly.

---
 drivers/media/video/mx2_camera.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 3880d24..cf958ec 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -1211,7 +1211,7 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 };
 
 static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
-		int bufnum)
+		int bufnum, bool err)
 {
 	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
 	struct mx2_buffer *buf;
@@ -1258,7 +1258,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		list_del_init(&buf->queue);
 		do_gettimeofday(&vb->v4l2_buf.timestamp);
 		vb->v4l2_buf.sequence = pcdev->frame_count;
-		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+		if (err)
+			vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
+		else
+			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 	}
 
 	pcdev->frame_count++;
@@ -1309,21 +1312,18 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	}
 
 	if (status & (1 << 7)) { /* overflow */
-		u32 cntl;
-		/*
-		 * We only disable channel 1 here since this is the only
-		 * enabled channel
-		 *
-		 * FIXME: the correct DMA overflow handling should be resetting
-		 * the buffer, returning an error frame, and continuing with
-		 * the next one.
-		 */
-		cntl = readl(pcdev->base_emma + PRP_CNTL);
+		u32 cntl = readl(pcdev->base_emma + PRP_CNTL);
 		writel(cntl & ~(PRP_CNTL_CH1EN | PRP_CNTL_CH2EN),
 		       pcdev->base_emma + PRP_CNTL);
 		writel(cntl, pcdev->base_emma + PRP_CNTL);
-	}
-	if (((status & (3 << 5)) == (3 << 5)) ||
+
+		buf = list_entry(pcdev->active_bufs.next,
+			struct mx2_buffer, queue);
+		mx27_camera_frame_done_emma(pcdev,
+					buf->bufnum, true);
+
+		status &= ~(1 << 7);
+	} else if (((status & (3 << 5)) == (3 << 5)) ||
 		((status & (3 << 3)) == (3 << 3))) {
 		/*
 		 * Both buffers have triggered, process the one we're expecting
@@ -1331,13 +1331,13 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		 */
 		buf = list_entry(pcdev->active_bufs.next,
 			struct mx2_buffer, queue);
-		mx27_camera_frame_done_emma(pcdev, buf->bufnum);
+		mx27_camera_frame_done_emma(pcdev, buf->bufnum, false);
 		status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
+	} else if ((status & (1 << 6)) || (status & (1 << 4))) {
+		mx27_camera_frame_done_emma(pcdev, 0, false);
+	} else if ((status & (1 << 5)) || (status & (1 << 3))) {
+		mx27_camera_frame_done_emma(pcdev, 1, false);
 	}
-	if ((status & (1 << 6)) || (status & (1 << 4)))
-		mx27_camera_frame_done_emma(pcdev, 0);
-	if ((status & (1 << 5)) || (status & (1 << 3)))
-		mx27_camera_frame_done_emma(pcdev, 1);
 
 irq_ok:
 	spin_unlock_irqrestore(&pcdev->lock, flags);
-- 
1.7.0.4


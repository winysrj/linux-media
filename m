Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:51530 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2BVK7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 05:59:43 -0500
Received: by wics10 with SMTP id s10so4111066wic.19
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2012 02:59:42 -0800 (PST)
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, s.hauer@pengutronix.de,
	mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v2 2/6] media: i.MX27 camera: Use list_first_entry() whenever possible.
Date: Wed, 22 Feb 2012 11:59:33 +0100
Message-Id: <1329908374-19769-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 Changes since v1:
 - Adapt to [PATCH v4 4/4] media i.MX27 camera: handle overflows properly.

---
 drivers/media/video/mx2_camera.c |   26 ++++++++++++--------------
 1 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 0ade14e..7793264 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -458,7 +458,7 @@ static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
 		buf = NULL;
 		writel(0, pcdev->base_csi + fb_reg);
 	} else {
-		buf = list_entry(pcdev->capture.next, struct mx2_buffer,
+		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
 				queue);
 		vb = &buf->vb;
 		list_del(&buf->queue);
@@ -718,8 +718,8 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 
 		spin_lock_irqsave(&pcdev->lock, flags);
 
-		buf = list_entry(pcdev->capture.next,
-				 struct mx2_buffer, queue);
+		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
+				       queue);
 		buf->bufnum = 0;
 		vb = &buf->vb;
 		buf->state = MX2_STATE_ACTIVE;
@@ -728,8 +728,8 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 		mx27_update_emma_buf(pcdev, phys, buf->bufnum);
 		list_move_tail(pcdev->capture.next, &pcdev->active_bufs);
 
-		buf = list_entry(pcdev->capture.next,
-				 struct mx2_buffer, queue);
+		buf = list_first_entry(&pcdev->capture, struct mx2_buffer,
+				       queue);
 		buf->bufnum = 1;
 		vb = &buf->vb;
 		buf->state = MX2_STATE_ACTIVE;
@@ -1215,8 +1215,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 	struct vb2_buffer *vb;
 	unsigned long phys;
 
-	buf = list_entry(pcdev->active_bufs.next,
-			 struct mx2_buffer, queue);
+	buf = list_first_entry(&pcdev->active_bufs, struct mx2_buffer, queue);
 
 	BUG_ON(buf->bufnum != bufnum);
 
@@ -1270,8 +1269,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 			return;
 		}
 
-		buf = list_entry(pcdev->discard.next,
-			struct mx2_buffer, queue);
+		buf = list_first_entry(&pcdev->discard, struct mx2_buffer,
+				       queue);
 		buf->bufnum = bufnum;
 
 		list_move_tail(pcdev->discard.next, &pcdev->active_bufs);
@@ -1279,8 +1278,7 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
 		return;
 	}
 
-	buf = list_entry(pcdev->capture.next,
-			struct mx2_buffer, queue);
+	buf = list_first_entry(&pcdev->capture, struct mx2_buffer, queue);
 
 	buf->bufnum = bufnum;
 
@@ -1314,7 +1312,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		       pcdev->base_emma + PRP_CNTL);
 		writel(cntl, pcdev->base_emma + PRP_CNTL);
 
-		buf = list_entry(pcdev->active_bufs.next,
+		buf = list_first_entry(pcdev->active_bufs.next,
 			struct mx2_buffer, queue);
 		mx27_camera_frame_done_emma(pcdev,
 					buf->bufnum, true);
@@ -1326,8 +1324,8 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 		 * Both buffers have triggered, process the one we're expecting
 		 * to first
 		 */
-		buf = list_entry(pcdev->active_bufs.next,
-			struct mx2_buffer, queue);
+		buf = list_first_entry(&pcdev->active_bufs, struct mx2_buffer,
+				       queue);
 		mx27_camera_frame_done_emma(pcdev, buf->bufnum, false);
 		status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
 	} else if ((status & (1 << 6)) || (status & (1 << 4))) {
-- 
1.7.0.4


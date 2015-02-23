Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62890 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbBWPHK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 10:07:10 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: au0828: drop vbi_buffer_filled() and re-use buffer_filled()
Date: Mon, 23 Feb 2015 15:06:52 +0000
Message-Id: <1424704012-15993-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The vbi_buffer_filled() and buffer_filled() did the same functionality
except for incrementing the buffer sequence, this patch drops the
vbi_buffer_filled() and re-uses buffer_filled() for vbi buffers
aswell by adding the check for vb2-queue type while incrementing
the sequence numbers. Along side this patch aligns the code.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/usb/au0828/au0828-video.c | 36 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index a27cb5f..60012ec 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -299,29 +299,23 @@ static int au0828_init_isoc(struct au0828_dev *dev, int max_packets,
  * Announces that a buffer were filled and request the next
  */
 static inline void buffer_filled(struct au0828_dev *dev,
-				  struct au0828_dmaqueue *dma_q,
-				  struct au0828_buffer *buf)
+				 struct au0828_dmaqueue *dma_q,
+				 struct au0828_buffer *buf)
 {
-	/* Advice that buffer was filled */
-	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
-
-	buf->vb.v4l2_buf.sequence = dev->frame_count++;
-	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
-}
+	struct vb2_buffer vb = buf->vb;
+	struct vb2_queue *q = vb.vb2_queue;
 
-static inline void vbi_buffer_filled(struct au0828_dev *dev,
-				     struct au0828_dmaqueue *dma_q,
-				     struct au0828_buffer *buf)
-{
 	/* Advice that buffer was filled */
 	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
-	buf->vb.v4l2_buf.sequence = dev->vbi_frame_count++;
-	buf->vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		vb.v4l2_buf.sequence = dev->frame_count++;
+	else
+		vb.v4l2_buf.sequence = dev->vbi_frame_count++;
+
+	vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&vb.v4l2_buf.timestamp);
+	vb2_buffer_done(&vb, VB2_BUF_STATE_DONE);
 }
 
 /*
@@ -574,9 +568,7 @@ static inline int au0828_isoc_copy(struct au0828_dev *dev, struct urb *urb)
 			if (fbyte & 0x40) {
 				/* VBI */
 				if (vbi_buf != NULL)
-					vbi_buffer_filled(dev,
-							  vbi_dma_q,
-							  vbi_buf);
+					buffer_filled(dev, vbi_dma_q, vbi_buf);
 				vbi_get_next_buf(vbi_dma_q, &vbi_buf);
 				if (vbi_buf == NULL)
 					vbioutp = NULL;
@@ -949,7 +941,7 @@ static void au0828_vbi_buffer_timeout(unsigned long data)
 	if (buf != NULL) {
 		vbi_data = vb2_plane_vaddr(&buf->vb, 0);
 		memset(vbi_data, 0x00, buf->length);
-		vbi_buffer_filled(dev, dma_q, buf);
+		buffer_filled(dev, dma_q, buf);
 	}
 	vbi_get_next_buf(dma_q, &buf);
 
-- 
1.9.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55613 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337AbbCMNlw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 09:41:52 -0400
Message-ID: <5502E913.2020302@xs4all.nl>
Date: Fri, 13 Mar 2015 14:41:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH] au0828: fix broken streaming
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit c5036d61e0bed3f4f51391a145638b426825e69c ("media: au0828: drop
vbi_buffer_filled() and re-use buffer_filled()") broke video and vbi streaming.

The vb2_buffer struct was copied instead of taking a pointer to it, but
vb2_buffer_done() needs the real object, not a copy, since it is hooking
the buffer into a different list.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index bf990a9..1a362a0 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -302,20 +302,20 @@ static inline void buffer_filled(struct au0828_dev *dev,
 				 struct au0828_dmaqueue *dma_q,
 				 struct au0828_buffer *buf)
 {
-	struct vb2_buffer vb = buf->vb;
-	struct vb2_queue *q = vb.vb2_queue;
+	struct vb2_buffer *vb = &buf->vb;
+	struct vb2_queue *q = vb->vb2_queue;
 
 	/* Advice that buffer was filled */
 	au0828_isocdbg("[%p/%d] wakeup\n", buf, buf->top_field);
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		vb.v4l2_buf.sequence = dev->frame_count++;
+		vb->v4l2_buf.sequence = dev->frame_count++;
 	else
-		vb.v4l2_buf.sequence = dev->vbi_frame_count++;
+		vb->v4l2_buf.sequence = dev->vbi_frame_count++;
 
-	vb.v4l2_buf.field = V4L2_FIELD_INTERLACED;
-	v4l2_get_timestamp(&vb.v4l2_buf.timestamp);
-	vb2_buffer_done(&vb, VB2_BUF_STATE_DONE);
+	vb->v4l2_buf.field = V4L2_FIELD_INTERLACED;
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
+	vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
 }
 
 /*

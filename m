Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38682 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaDUM3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Apr 2014 08:29:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 24/26] v4l: vb2: Add a function to discard all DONE buffers
Date: Mon, 21 Apr 2014 14:29:10 +0200
Message-Id: <1398083352-8451-25-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When suspending a device while a video stream is active all buffers
marked as done but not dequeued yet will be kept across suspend and
given back to userspace after resume. This will result in outdated
buffers being dequeued.

Introduce a new vb2 function to mark all done buffers as erroneous
instead, to be used by drivers at resume time.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 24 ++++++++++++++++++++++++
 include/media/videobuf2-core.h           |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f9059bb..6ab13b7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1131,6 +1131,30 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 EXPORT_SYMBOL_GPL(vb2_buffer_done);
 
 /**
+ * vb2_discard_done() - discard all buffers marked as DONE
+ * @q:		videobuf2 queue
+ *
+ * This function is intended to be used with suspend/resume operations. It
+ * discards all 'done' buffers as they would be too old to be requested after
+ * resume.
+ *
+ * Drivers must stop the hardware and synchronize with interrupt handlers and/or
+ * delayed works before calling this function to make sure no buffer will be
+ * touched by the driver and/or hardware.
+ */
+void vb2_discard_done(struct vb2_queue *q)
+{
+	struct vb2_buffer *vb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->done_lock, flags);
+	list_for_each_entry(vb, &q->done_list, done_entry)
+		vb->state = VB2_BUF_STATE_ERROR;
+	spin_unlock_irqrestore(&q->done_lock, flags);
+}
+EXPORT_SYMBOL_GPL(vb2_discard_done);
+
+/**
  * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
  * v4l2_buffer by the userspace. The caller has already verified that struct
  * v4l2_buffer has a valid number of planes.
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index af46211..2c2f23b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -429,6 +429,7 @@ void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
 void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no);
 
 void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state);
+void vb2_discard_done(struct vb2_queue *q);
 int vb2_wait_for_all_buffers(struct vb2_queue *q);
 
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
-- 
1.8.3.2


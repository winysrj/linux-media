Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34570 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab1B0SM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 13:12:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl
Subject: [RFC/PATCH 1/2] v4l: videobuf2: Handle buf_queue errors
Date: Sun, 27 Feb 2011 19:12:32 +0100
Message-Id: <1298830353-9797-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

videobuf2 expects drivers to check buffer in the buf_prepare operation
and to return success only if the buffer can queued without any issue.

For hot-pluggable devices, disconnection events need to be handled at
buf_queue time. Checking the disconnected flag and adding the buffer to
the driver queue need to be performed without releasing the driver
spinlock, otherwise race conditions can occur in which the driver could
still allow a buffer to be queued after the disconnected flag has been
set, resulting in a hang during the next DQBUF operation.

This problem can be solved either in the videobuf2 core or in the device
drivers. To avoid adding a spinlock to videobuf2, make buf_queue return
an int and handle buf_queue failures in videobuf2. Drivers must not
return an error in buf_queue if the condition leading to the error can
be caught in buf_prepare.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/videobuf2-core.c |   32 ++++++++++++++++++++++++++------
 include/media/videobuf2-core.h       |    2 +-
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index cc7ab0a..1d81536 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -798,13 +798,22 @@ static int __qbuf_mmap(struct vb2_buffer *vb, struct v4l2_buffer *b)
 /**
  * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
  */
-static void __enqueue_in_driver(struct vb2_buffer *vb)
+static int __enqueue_in_driver(struct vb2_buffer *vb)
 {
 	struct vb2_queue *q = vb->vb2_queue;
+	int ret;
 
 	vb->state = VB2_BUF_STATE_ACTIVE;
 	atomic_inc(&q->queued_count);
-	q->ops->buf_queue(vb);
+	ret = q->ops->buf_queue(vb);
+	if (ret == 0)
+		return 0;
+
+	vb->state = VB2_BUF_STATE_ERROR;
+	atomic_dec(&q->queued_count);
+	wake_up_all(&q->done_wq);
+
+	return ret;
 }
 
 /**
@@ -890,8 +899,13 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
 	 */
-	if (q->streaming)
-		__enqueue_in_driver(vb);
+	if (q->streaming) {
+		ret = __enqueue_in_driver(vb);
+		if (ret < 0) {
+			dprintk(1, "qbuf: buffer queue failed\n");
+			return ret;
+		}
+	}
 
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->v4l2_buf.index);
 	return 0;
@@ -1101,6 +1115,7 @@ EXPORT_SYMBOL_GPL(vb2_dqbuf);
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 {
 	struct vb2_buffer *vb;
+	int ret;
 
 	if (q->fileio) {
 		dprintk(1, "streamon: file io in progress\n");
@@ -1139,8 +1154,13 @@ int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
 	 * If any buffers were queued before streamon,
 	 * we can now pass them to driver for processing.
 	 */
-	list_for_each_entry(vb, &q->queued_list, queued_entry)
-		__enqueue_in_driver(vb);
+	list_for_each_entry(vb, &q->queued_list, queued_entry) {
+		ret = __enqueue_in_driver(vb);
+		if (ret < 0) {
+			dprintk(1, "streamon: buffer queue failed\n");
+			return ret;
+		}
+	}
 
 	dprintk(3, "Streamon successful\n");
 	return 0;
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 597efe6..3a92f75 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -225,7 +225,7 @@ struct vb2_ops {
 	int (*start_streaming)(struct vb2_queue *q);
 	int (*stop_streaming)(struct vb2_queue *q);
 
-	void (*buf_queue)(struct vb2_buffer *vb);
+	int (*buf_queue)(struct vb2_buffer *vb);
 };
 
 /**
-- 
1.7.3.4


Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39753 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab0KUUcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:51 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 58DE035C96
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:50 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/5] uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
Date: Sun, 21 Nov 2010 21:32:50 +0100
Message-Id: <1290371573-14907-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Callers outside uvc_queue.c should not be forced to lock/unlock the
queue mutex manually. Move the mutex operations inside
uvc_free_buffers().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_queue.c |   57 +++++++++++++++++++++--------------
 drivers/media/video/uvc/uvc_v4l2.c  |    2 -
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index ed6d544..32c1822 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -90,6 +90,39 @@ void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 }
 
 /*
+ * Free the video buffers.
+ *
+ * This function must be called with the queue lock held.
+ */
+static int __uvc_free_buffers(struct uvc_video_queue *queue)
+{
+	unsigned int i;
+
+	for (i = 0; i < queue->count; ++i) {
+		if (queue->buffer[i].vma_use_count != 0)
+			return -EBUSY;
+	}
+
+	if (queue->count) {
+		vfree(queue->mem);
+		queue->count = 0;
+	}
+
+	return 0;
+}
+
+int uvc_free_buffers(struct uvc_video_queue *queue)
+{
+	int ret;
+
+	mutex_lock(&queue->mutex);
+	ret = __uvc_free_buffers(queue);
+	mutex_unlock(&queue->mutex);
+
+	return ret;
+}
+
+/*
  * Allocate the video buffers.
  *
  * Pages are reserved to make sure they will not be swapped, as they will be
@@ -110,7 +143,7 @@ int uvc_alloc_buffers(struct uvc_video_queue *queue, unsigned int nbuffers,
 
 	mutex_lock(&queue->mutex);
 
-	if ((ret = uvc_free_buffers(queue)) < 0)
+	if ((ret = __uvc_free_buffers(queue)) < 0)
 		goto done;
 
 	/* Bail out if no buffers should be allocated. */
@@ -152,28 +185,6 @@ done:
 }
 
 /*
- * Free the video buffers.
- *
- * This function must be called with the queue lock held.
- */
-int uvc_free_buffers(struct uvc_video_queue *queue)
-{
-	unsigned int i;
-
-	for (i = 0; i < queue->count; ++i) {
-		if (queue->buffer[i].vma_use_count != 0)
-			return -EBUSY;
-	}
-
-	if (queue->count) {
-		vfree(queue->mem);
-		queue->count = 0;
-	}
-
-	return 0;
-}
-
-/*
  * Check if buffers have been allocated.
  */
 int uvc_queue_allocated(struct uvc_video_queue *queue)
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 0f865e9..0fd9848b 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -494,11 +494,9 @@ static int uvc_v4l2_release(struct file *file)
 	if (uvc_has_privileges(handle)) {
 		uvc_video_enable(stream, 0);
 
-		mutex_lock(&stream->queue.mutex);
 		if (uvc_free_buffers(&stream->queue) < 0)
 			uvc_printk(KERN_ERR, "uvc_v4l2_release: Unable to "
 					"free buffers.\n");
-		mutex_unlock(&stream->queue.mutex);
 	}
 
 	/* Release the file handle. */
-- 
1.7.2.2


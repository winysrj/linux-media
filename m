Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43075 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab0EKNfh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 2/7] v4l: videobuf: rename videobuf_mmap_free and add sanity checks
Date: Tue, 11 May 2010 15:36:29 +0200
Message-Id: <1273584994-14211-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <p.osciak@samsung.com>

This function is not specific to mmap, hence the rename.
Add a check whether we are not streaming or reading (for read mode that
uses the stream queue) before freeing anything.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
---
 drivers/media/video/videobuf-core.c |   70 +++++++++++++++++++++--------------
 1 files changed, 42 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 4d56583..ce1595b 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -195,6 +195,45 @@ int videobuf_queue_is_busy(struct videobuf_queue *q)
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_is_busy);
 
+/**
+ * __videobuf_free() - free all the buffers and their control structures
+ *
+ * This function can only be called if streaming/reading is off, i.e. no buffers
+ * are under control of the driver.
+ */
+/* Locking: Caller holds q->vb_lock */
+static int __videobuf_free(struct videobuf_queue *q)
+{
+	int i;
+
+	dprintk(1, "%s\n", __func__);
+	if (!q)
+		return 0;
+
+	if (q->streaming || q->reading) {
+		dprintk(1, "Cannot free buffers when streaming or reading\n");
+		return -EBUSY;
+	}
+
+	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
+
+	for (i = 0; i < VIDEO_MAX_FRAME; i++)
+		if (q->bufs[i] && q->bufs[i]->map) {
+			dprintk(1, "Cannot free mmapped buffers\n");
+			return -EBUSY;
+		}
+
+	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+		if (NULL == q->bufs[i])
+			continue;
+		q->ops->buf_release(q, q->bufs[i]);
+		kfree(q->bufs[i]);
+		q->bufs[i] = NULL;
+	}
+
+	return 0;
+}
+
 /* Locking: Caller holds q->vb_lock */
 void videobuf_queue_cancel(struct videobuf_queue *q)
 {
@@ -308,36 +347,11 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	b->sequence  = vb->field_count >> 1;
 }
 
-/* Locking: Caller holds q->vb_lock */
-static int __videobuf_mmap_free(struct videobuf_queue *q)
-{
-	int i;
-
-	if (!q)
-		return 0;
-
-	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
-
-	for (i = 0; i < VIDEO_MAX_FRAME; i++)
-		if (q->bufs[i] && q->bufs[i]->map)
-			return -EBUSY;
-
-	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-		if (NULL == q->bufs[i])
-			continue;
-		q->ops->buf_release(q, q->bufs[i]);
-		kfree(q->bufs[i]);
-		q->bufs[i] = NULL;
-	}
-
-	return 0;
-}
-
 int videobuf_mmap_free(struct videobuf_queue *q)
 {
 	int ret;
 	mutex_lock(&q->vb_lock);
-	ret = __videobuf_mmap_free(q);
+	ret = __videobuf_free(q);
 	mutex_unlock(&q->vb_lock);
 	return ret;
 }
@@ -353,7 +367,7 @@ int __videobuf_mmap_setup(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	err = __videobuf_mmap_free(q);
+	err = __videobuf_free(q);
 	if (0 != err)
 		return err;
 
@@ -970,7 +984,7 @@ static void __videobuf_read_stop(struct videobuf_queue *q)
 	int i;
 
 	videobuf_queue_cancel(q);
-	__videobuf_mmap_free(q);
+	__videobuf_free(q);
 	INIT_LIST_HEAD(&q->stream);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 		if (NULL == q->bufs[i])
-- 
1.6.4.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36722 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab0DUQKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 12:10:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L1800I19I9PIF90@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1800HFEI9PFD@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Date: Wed, 21 Apr 2010 18:10:34 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v1 1/2] v4l: videobuf: Add support for out-of-order buffer
 dequeuing.
In-reply-to: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271866235-14370-2-git-send-email-p.osciak@samsung.com>
References: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Drivers can now finish processing on and return video buffers in
an arbitrary order. Before this patch, this was possible in a FIFO order
only. This is useful e.g. for video codecs, which often need to hold some
buffers (e.g. keyframes) for longer periods of time than others.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/videobuf-core.c |  160 +++++++++++++++++++++++-----------
 include/media/videobuf-core.h       |    9 ++
 2 files changed, 117 insertions(+), 52 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 77899ca..ea5fd39 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -95,6 +95,27 @@ int videobuf_waiton(struct videobuf_buffer *vb, int non_blocking, int intr)
 }
 EXPORT_SYMBOL_GPL(videobuf_waiton);
 
+int videobuf_has_consumers(struct videobuf_queue *q)
+{
+	return waitqueue_active(&q->vb_done_wait);
+}
+EXPORT_SYMBOL_GPL(videobuf_has_consumers);
+
+void videobuf_buf_finish(struct videobuf_queue *q, struct videobuf_buffer *vb)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->vb_done_lock, flags);
+	list_add_tail(&vb->done_list, &q->vb_done_list);
+	spin_unlock_irqrestore(&q->vb_done_lock, flags);
+
+	spin_lock_irqsave(q->irqlock, flags);
+	wake_up(&vb->done);
+	wake_up_interruptible(&q->vb_done_wait);
+	spin_unlock_irqrestore(q->irqlock, flags);
+}
+EXPORT_SYMBOL_GPL(videobuf_buf_finish);
+
 int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		    struct v4l2_framebuffer *fbuf)
 {
@@ -153,7 +174,10 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
 
 	mutex_init(&q->vb_lock);
 	init_waitqueue_head(&q->wait);
+	init_waitqueue_head(&q->vb_done_wait);
 	INIT_LIST_HEAD(&q->stream);
+	INIT_LIST_HEAD(&q->vb_done_list);
+	spin_lock_init(&q->vb_done_lock);
 }
 EXPORT_SYMBOL_GPL(videobuf_queue_core_init);
 
@@ -217,6 +241,7 @@ void videobuf_queue_cancel(struct videobuf_queue *q)
 			wake_up_all(&q->bufs[i]->done);
 		}
 	}
+	wake_up_all(&q->vb_done_wait);
 	spin_unlock_irqrestore(q->irqlock, flags);
 
 	/* free all buffers + clear queue */
@@ -603,67 +628,81 @@ done:
 EXPORT_SYMBOL_GPL(videobuf_qbuf);
 
 /* Locking: Caller holds q->vb_lock */
-static int stream_next_buffer_check_queue(struct videobuf_queue *q, int noblock)
+static int wait_for_buffer(struct videobuf_queue *q, int nonblocking)
 {
-	int retval;
+	int retval = 0;
 
 checks:
 	if (!q->streaming) {
-		dprintk(1, "next_buffer: Not streaming\n");
+		dprintk(1, "Not streaming\n");
 		retval = -EINVAL;
-		goto done;
+		goto end;
 	}
 
-	if (list_empty(&q->stream)) {
-		if (noblock) {
+	/*
+	 * Buffers may be added to vb_done_list without holding the vb_lock,
+	 * but removal is performed only while holding both vb_lock and the
+	 * vb_done_lock spinlock. Thus we can be sure that as long as we hold
+	 * vb_lock, the list will remain not empty if this check succeeds.
+	 */
+	if (list_empty(&q->vb_done_list)) {
+		if (nonblocking) {
+			dprintk(1, "Nonblocking and no buffers to dequeue\n");
 			retval = -EAGAIN;
-			dprintk(2, "next_buffer: no buffers to dequeue\n");
-			goto done;
-		} else {
-			dprintk(2, "next_buffer: waiting on buffer\n");
-
-			/* Drop lock to avoid deadlock with qbuf */
-			mutex_unlock(&q->vb_lock);
-
-			/* Checking list_empty and streaming is safe without
-			 * locks because we goto checks to validate while
-			 * holding locks before proceeding */
-			retval = wait_event_interruptible(q->wait,
-				!list_empty(&q->stream) || !q->streaming);
-			mutex_lock(&q->vb_lock);
-
-			if (retval)
-				goto done;
-
-			goto checks;
+			goto end;
 		}
-	}
 
-	retval = 0;
+		/*
+		 * We are streaming and nonblocking, wait for another buffer to
+		 * become ready or for streamoff. vb_lock is released to allow
+		 * streamoff and qbuf in parallel.
+		 */
+		mutex_unlock(&q->vb_lock);
+		/*
+		 * Although the mutex is released here, we will be reevaluating
+		 * both conditions again after reacquiring it.
+		 */
+		retval = wait_event_interruptible(q->vb_done_wait,
+				!list_empty(&q->vb_done_list) || !q->streaming);
+		mutex_lock(&q->vb_lock);
+
+		if (retval)
+			goto end;
+
+		goto checks;
+	}
 
-done:
+	/*
+	 * At least one buffer is on the vb_done_list and nothing can be removed
+	 * from it without acquiring the vb_lock, which we are holding now.
+	 */
+end:
 	return retval;
 }
 
 /* Locking: Caller holds q->vb_lock */
-static int stream_next_buffer(struct videobuf_queue *q,
-			struct videobuf_buffer **vb, int nonblocking)
+static int get_done_buffer(struct videobuf_queue *q,
+			   struct videobuf_buffer **vb, int nonblocking)
 {
-	int retval;
-	struct videobuf_buffer *buf = NULL;
-
-	retval = stream_next_buffer_check_queue(q, nonblocking);
-	if (retval)
-		goto done;
-
-	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
-	retval = videobuf_waiton(buf, nonblocking, 1);
-	if (retval < 0)
-		goto done;
-
-	*vb = buf;
-done:
-	return retval;
+	unsigned long flags;
+	int ret = 0;
+
+	ret = wait_for_buffer(q, nonblocking);
+	if (ret)
+		goto end;
+
+	/*
+	 * vb_lock has been held since we last verified that vb_done_list is
+	 * not empty, no need for another list_empty().
+	 */
+	spin_lock_irqsave(&q->vb_done_lock, flags);
+	*vb = list_first_entry(&q->vb_done_list, struct videobuf_buffer,
+				done_list);
+	list_del(&((*vb)->done_list));
+	spin_unlock_irqrestore(&q->vb_done_lock, flags);
+
+end:
+	return ret;
 }
 
 int videobuf_dqbuf(struct videobuf_queue *q,
@@ -676,7 +715,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 
 	mutex_lock(&q->vb_lock);
 
-	retval = stream_next_buffer(q, &buf, nonblocking);
+	retval = get_done_buffer(q, &buf, nonblocking);
 	if (retval < 0) {
 		dprintk(1, "dqbuf: next_buffer error: %i\n", retval);
 		goto done;
@@ -1055,12 +1094,25 @@ unsigned int videobuf_poll_stream(struct file *file,
 {
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
+	unsigned long flags;
 
 	mutex_lock(&q->vb_lock);
 	if (q->streaming) {
-		if (!list_empty(&q->stream))
-			buf = list_entry(q->stream.next,
-					 struct videobuf_buffer, stream);
+		if (list_empty(&q->stream)) {
+			rc = POLLERR;
+			goto end;
+		}
+
+		poll_wait(file, &q->vb_done_wait, wait);
+
+		spin_lock_irqsave(&q->vb_done_lock, flags);
+		if (!list_empty(&q->vb_done_list))
+			buf = list_first_entry(&q->vb_done_list,
+						struct videobuf_buffer,
+						done_list);
+		spin_unlock_irqrestore(&q->vb_done_lock, flags);
+		if (!buf)
+			goto end;
 	} else {
 		if (!q->reading)
 			__videobuf_read_start(q);
@@ -1074,12 +1126,15 @@ unsigned int videobuf_poll_stream(struct file *file,
 			q->read_off = 0;
 		}
 		buf = q->read_buf;
+		if (!buf) {
+			rc = POLLERR;
+			goto end;
+		}
+
+		poll_wait(file, &buf->done, wait);
 	}
-	if (!buf)
-		rc = POLLERR;
 
 	if (0 == rc) {
-		poll_wait(file, &buf->done, wait);
 		if (buf->state == VIDEOBUF_DONE ||
 		    buf->state == VIDEOBUF_ERROR) {
 			switch (q->type) {
@@ -1094,6 +1149,7 @@ unsigned int videobuf_poll_stream(struct file *file,
 			}
 		}
 	}
+end:
 	mutex_unlock(&q->vb_lock);
 	return rc;
 }
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index b1f7bf4..7b1cc94 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -82,6 +82,7 @@ struct videobuf_buffer {
 	enum v4l2_field         field;
 	enum videobuf_state     state;
 	struct list_head        stream;  /* QBUF/DQBUF list */
+	struct list_head	done_list;
 
 	/* touched by irq handler */
 	struct list_head        queue;
@@ -160,6 +161,10 @@ struct videobuf_queue {
 
 	wait_queue_head_t	   wait; /* wait if queue is empty */
 
+	wait_queue_head_t	   vb_done_wait;
+	struct list_head	   vb_done_list;
+	spinlock_t		   vb_done_lock;
+
 	enum v4l2_buf_type         type;
 	unsigned int               inputs; /* for V4L2_BUF_FLAG_INPUT */
 	unsigned int               msize;
@@ -206,6 +211,8 @@ void videobuf_queue_core_init(struct videobuf_queue *q,
 int  videobuf_queue_is_busy(struct videobuf_queue *q);
 void videobuf_queue_cancel(struct videobuf_queue *q);
 
+void videobuf_buf_finish(struct videobuf_queue *q, struct videobuf_buffer *vb);
+
 enum v4l2_field videobuf_next_field(struct videobuf_queue *q);
 int videobuf_reqbufs(struct videobuf_queue *q,
 		     struct v4l2_requestbuffers *req);
@@ -235,6 +242,8 @@ unsigned int videobuf_poll_stream(struct file *file,
 				  struct videobuf_queue *q,
 				  poll_table *wait);
 
+int videobuf_has_consumers(struct videobuf_queue *q);
+
 int videobuf_mmap_setup(struct videobuf_queue *q,
 			unsigned int bcount, unsigned int bsize,
 			enum v4l2_memory memory);
-- 
1.7.1.rc1.12.ga601


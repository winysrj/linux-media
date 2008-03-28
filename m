Return-path: <video4linux-list-bounces@redhat.com>
Message-Id: <20080328094022.237808474@ifup.org>
References: <20080328093944.278994792@ifup.org>
Date: Fri, 28 Mar 2008 02:39:52 -0700
From: brandon@ifup.org
To: mchehab@infradead.org
Content-Disposition: inline; filename=videobuf-add-waitqueue-for-dqbuf.patch
Cc: video4linux-list@redhat.com, Brandon Philips <bphilips@suse.de>,
	Jonathan Corbet <corbet@lwn.net>, Trent Piepho <xyzzy@speakeasy.org>,
	v4l-dvb-maintainer@linuxtv.org
Subject: [patch 8/9] videobuf: Avoid deadlock with QBUF and bring up to spec
	for empty queue
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Add a waitqueue to wait on when there are no buffers in the buffer queue.
DQBUF waits on this queue without holding vb_lock to allow a QBUF to happen.
Once a buffer has been queued we recheck that the queue is still streaming and
wait on the new buffer's waitqueue while holding the vb_lock.  The driver
should come along in a timely manner and put the buffer into its next state
finishing the DQBUF.

By implementing this waitqueue it also brings the videobuf DQBUF up to spec and
it now blocks on O_NONBLOCK even when no buffers have been queued via QBUF:

"By default VIDIOC_DQBUF blocks when no buffer is in the outgoing queue." 
 - V4L2 spec

CC: Trent Piepho <xyzzy@speakeasy.org>
CC: Carl Karsten <carl@personnelware.com>
CC: Jonathan Corbet <corbet@lwn.net>

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |   96 +++++++++++++++++++++++-------
 linux/include/media/videobuf-core.h       |    2 
 2 files changed, 78 insertions(+), 20 deletions(-)

Index: v4l-dvb/linux/drivers/media/video/videobuf-core.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/videobuf-core.c
+++ v4l-dvb/linux/drivers/media/video/videobuf-core.c
@@ -140,6 +140,7 @@ void videobuf_queue_core_init(struct vid
 	BUG_ON(!q->int_ops);
 
 	mutex_init(&q->vb_lock);
+	init_waitqueue_head(&q->wait);
 	INIT_LIST_HEAD(&q->stream);
 }
 
@@ -187,6 +188,10 @@ void videobuf_queue_cancel(struct videob
 	unsigned long flags = 0;
 	int i;
 
+	q->streaming = 0;
+	q->reading  = 0;
+	wake_up_all(&q->wait);
+
 	/* remove queued buffers from list */
 	spin_lock_irqsave(q->irqlock, flags);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
@@ -561,6 +566,7 @@ int videobuf_qbuf(struct videobuf_queue 
 	}
 	dprintk(1, "qbuf: succeded\n");
 	retval = 0;
+	wake_up(&q->wait);
 
  done:
 	mutex_unlock(&q->vb_lock);
@@ -571,37 +577,88 @@ int videobuf_qbuf(struct videobuf_queue 
 	return retval;
 }
 
-int videobuf_dqbuf(struct videobuf_queue *q,
-	       struct v4l2_buffer *b, int nonblocking)
+
+/* Locking: Caller holds q->vb_lock */
+static int stream_next_buffer_check_queue(struct videobuf_queue *q, int noblock)
 {
-	struct videobuf_buffer *buf;
 	int retval;
 
-	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
-
-	mutex_lock(&q->vb_lock);
-	retval = -EBUSY;
-	if (q->reading) {
-		dprintk(1, "dqbuf: Reading running...\n");
-		goto done;
-	}
-	retval = -EINVAL;
-	if (b->type != q->type) {
-		dprintk(1, "dqbuf: Wrong type.\n");
+checks:
+	if (!q->streaming) {
+		dprintk(1, "next_buffer: Not streaming\n");
+		retval = -EINVAL;
 		goto done;
 	}
+
 	if (list_empty(&q->stream)) {
-		dprintk(1, "dqbuf: stream running\n");
-		goto done;
+		if (noblock) {
+			retval = -EAGAIN;
+			dprintk(2, "next_buffer: no buffers to dequeue\n");
+			goto done;
+		} else {
+			dprintk(2, "next_buffer: waiting on buffer\n");
+
+			/* Drop lock to avoid deadlock with qbuf */
+			mutex_unlock(&q->vb_lock);
+
+			/* Checking list_empty and streaming is safe without
+			 * locks because we goto checks to validate while
+			 * holding locks before proceeding */
+			retval = wait_event_interruptible(q->wait,
+				!list_empty(&q->stream) || !q->streaming);
+			mutex_lock(&q->vb_lock);
+
+			if (retval)
+				goto done;
+
+			goto checks;
+		}
 	}
+
+	retval = 0;
+
+done:
+	return retval;
+}
+
+
+/* Locking: Caller holds q->vb_lock */
+static int stream_next_buffer(struct videobuf_queue *q,
+			struct videobuf_buffer **vb, int nonblocking)
+{
+	int retval;
+	struct videobuf_buffer *buf = NULL;
+
+	retval = stream_next_buffer_check_queue(q, nonblocking);
+	if (retval)
+		goto done;
+
 	buf = list_entry(q->stream.next, struct videobuf_buffer, stream);
-	mutex_unlock(&q->vb_lock);
 	retval = videobuf_waiton(buf, nonblocking, 1);
+	if (retval < 0)
+		goto done;
+
+	*vb = buf;
+done:
+	return retval;
+}
+
+int videobuf_dqbuf(struct videobuf_queue *q,
+	       struct v4l2_buffer *b, int nonblocking)
+{
+	struct videobuf_buffer *buf = NULL;
+	int retval;
+
+	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
+
 	mutex_lock(&q->vb_lock);
+
+	retval = stream_next_buffer(q, &buf, nonblocking);
 	if (retval < 0) {
-		dprintk(1, "dqbuf: waiton returned %d\n", retval);
+		dprintk(1, "dqbuf: next_buffer error: %i\n", retval);
 		goto done;
 	}
+
 	switch (buf->state) {
 	case VIDEOBUF_ERROR:
 		dprintk(1, "dqbuf: state is error\n");
@@ -648,6 +705,7 @@ int videobuf_streamon(struct videobuf_qu
 			q->ops->buf_queue(q, buf);
 	spin_unlock_irqrestore(q->irqlock, flags);
 
+	wake_up(&q->wait);
  done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
@@ -660,7 +718,6 @@ static int __videobuf_streamoff(struct v
 		return -EINVAL;
 
 	videobuf_queue_cancel(q);
-	q->streaming = 0;
 
 	return 0;
 }
@@ -858,7 +915,6 @@ static void __videobuf_read_stop(struct 
 		q->bufs[i] = NULL;
 	}
 	q->read_buf = NULL;
-	q->reading  = 0;
 
 }
 
Index: v4l-dvb/linux/include/media/videobuf-core.h
===================================================================
--- v4l-dvb.orig/linux/include/media/videobuf-core.h
+++ v4l-dvb/linux/include/media/videobuf-core.h
@@ -159,6 +159,8 @@ struct videobuf_queue {
 	spinlock_t                 *irqlock;
 	struct device		   *dev;
 
+	wait_queue_head_t	   wait; /* wait if queue is empty */
+
 	enum v4l2_buf_type         type;
 	unsigned int               inputs; /* for V4L2_BUF_FLAG_INPUT */
 	unsigned int               msize;

-- 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

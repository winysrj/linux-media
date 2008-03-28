Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2SAYLrw027590
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:22 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2SAXY5O018282
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 06:34:09 -0400
Received: by fg-out-1718.google.com with SMTP id e12so174998fga.7
	for <video4linux-list@redhat.com>; Fri, 28 Mar 2008 03:34:09 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <d9780aaf14ad2fca7eea.1206699513@localhost>
In-Reply-To: <patchbomb.1206699511@localhost>
Date: Fri, 28 Mar 2008 03:18:33 -0700
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: [PATCH 2 of 9] videobuf: Require spinlocks for all videobuf users
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

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1206699277 25200
# Node ID d9780aaf14ad2fca7eeaa79f3a8476e5f551ed25
# Parent  7876c2bc2446dc3e3630e7a30a76f50874116cf1
videobuf: Require spinlocks for all videobuf users

A spinlock is necessary for queue_cancel to work with every driver in the tree.
Otherwise a race exists between IRQ handlers removing buffers from the queue
and queue_cancel invalidating the queue.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 linux/drivers/media/video/videobuf-core.c |   46 +++++++++++-------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/linux/drivers/media/video/videobuf-core.c b/linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c
+++ b/linux/drivers/media/video/videobuf-core.c
@@ -145,6 +145,9 @@ void videobuf_queue_core_init(struct vid
 	BUG_ON(!q->ops->buf_queue);
 	BUG_ON(!q->ops->buf_release);
 
+	/* Lock is mandatory for queue_cancel to work */
+	BUG_ON(!irqlock);
+
 	/* Having implementations for abstract methods are mandatory */
 	BUG_ON(!q->int_ops);
 
@@ -197,8 +200,7 @@ void videobuf_queue_cancel(struct videob
 	int i;
 
 	/* remove queued buffers from list */
-	if (q->irqlock)
-		spin_lock_irqsave(q->irqlock, flags);
+	spin_lock_irqsave(q->irqlock, flags);
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
 		if (NULL == q->bufs[i])
 			continue;
@@ -207,8 +209,7 @@ void videobuf_queue_cancel(struct videob
 			q->bufs[i]->state = VIDEOBUF_ERROR;
 		}
 	}
-	if (q->irqlock)
-		spin_unlock_irqrestore(q->irqlock, flags);
+	spin_unlock_irqrestore(q->irqlock, flags);
 
 	/* free all buffers + clear queue */
 	for (i = 0; i < VIDEO_MAX_FRAME; i++) {
@@ -564,11 +565,9 @@ int videobuf_qbuf(struct videobuf_queue 
 
 	list_add_tail(&buf->stream, &q->stream);
 	if (q->streaming) {
-		if (q->irqlock)
-			spin_lock_irqsave(q->irqlock, flags);
+		spin_lock_irqsave(q->irqlock, flags);
 		q->ops->buf_queue(q, buf);
-		if (q->irqlock)
-			spin_unlock_irqrestore(q->irqlock, flags);
+		spin_unlock_irqrestore(q->irqlock, flags);
 	}
 	dprintk(1, "qbuf: succeded\n");
 	retval = 0;
@@ -653,13 +652,11 @@ int videobuf_streamon(struct videobuf_qu
 	if (q->streaming)
 		goto done;
 	q->streaming = 1;
-	if (q->irqlock)
-		spin_lock_irqsave(q->irqlock, flags);
+	spin_lock_irqsave(q->irqlock, flags);
 	list_for_each_entry(buf, &q->stream, stream)
 		if (buf->state == VIDEOBUF_PREPARED)
 			q->ops->buf_queue(q, buf);
-	if (q->irqlock)
-		spin_unlock_irqrestore(q->irqlock, flags);
+	spin_unlock_irqrestore(q->irqlock, flags);
 
  done:
 	mutex_unlock(&q->vb_lock);
@@ -715,11 +712,9 @@ static ssize_t videobuf_read_zerocopy(st
 		goto done;
 
 	/* start capture & wait */
-	if (q->irqlock)
-		spin_lock_irqsave(q->irqlock, flags);
+	spin_lock_irqsave(q->irqlock, flags);
 	q->ops->buf_queue(q, q->read_buf);
-	if (q->irqlock)
-		spin_unlock_irqrestore(q->irqlock, flags);
+	spin_unlock_irqrestore(q->irqlock, flags);
 	retval = videobuf_waiton(q->read_buf, 0, 0);
 	if (0 == retval) {
 		CALL(q, sync, q, q->read_buf);
@@ -780,12 +775,11 @@ ssize_t videobuf_read_one(struct videobu
 			q->read_buf = NULL;
 			goto done;
 		}
-		if (q->irqlock)
-			spin_lock_irqsave(q->irqlock, flags);
 
+		spin_lock_irqsave(q->irqlock, flags);
 		q->ops->buf_queue(q, q->read_buf);
-		if (q->irqlock)
-			spin_unlock_irqrestore(q->irqlock, flags);
+		spin_unlock_irqrestore(q->irqlock, flags);
+
 		q->read_off = 0;
 	}
 
@@ -851,12 +845,10 @@ static int __videobuf_read_start(struct 
 			return err;
 		list_add_tail(&q->bufs[i]->stream, &q->stream);
 	}
-	if (q->irqlock)
-		spin_lock_irqsave(q->irqlock, flags);
+	spin_lock_irqsave(q->irqlock, flags);
 	for (i = 0; i < count; i++)
 		q->ops->buf_queue(q, q->bufs[i]);
-	if (q->irqlock)
-		spin_unlock_irqrestore(q->irqlock, flags);
+	spin_unlock_irqrestore(q->irqlock, flags);
 	q->reading = 1;
 	return 0;
 }
@@ -970,11 +962,9 @@ ssize_t videobuf_read_stream(struct vide
 		if (q->read_off == q->read_buf->size) {
 			list_add_tail(&q->read_buf->stream,
 				      &q->stream);
-			if (q->irqlock)
-				spin_lock_irqsave(q->irqlock, flags);
+			spin_lock_irqsave(q->irqlock, flags);
 			q->ops->buf_queue(q, q->read_buf);
-			if (q->irqlock)
-				spin_unlock_irqrestore(q->irqlock, flags);
+			spin_unlock_irqrestore(q->irqlock, flags);
 			q->read_buf = NULL;
 		}
 		if (retval < 0)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

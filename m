Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2E9wiQD019887
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 05:58:44 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2E9w8WE015808
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 05:58:08 -0400
Date: Fri, 14 Mar 2008 10:58:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803141040190.4721@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] cleanup variable initialization
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

flags used for spinlocks don't need to be initialized, except where the 
compiler has no way to see, that the spin_unlock_irqrestore is only called 
if the spin_lock_irqsave has been called before. Local variable 
initialization doesn't have to be protected.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/media/video/ivtv/ivtv-queue.c b/drivers/media/video/ivtv/ivtv-queue.c
index 39a2167..3e1deec 100644
--- a/drivers/media/video/ivtv/ivtv-queue.c
+++ b/drivers/media/video/ivtv/ivtv-queue.c
@@ -51,7 +51,7 @@ void ivtv_queue_init(struct ivtv_queue *q)
 
 void ivtv_enqueue(struct ivtv_stream *s, struct ivtv_buffer *buf, struct ivtv_queue *q)
 {
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	/* clear the buffer if it is going to be enqueued to the free queue */
 	if (q == &s->q_free) {
@@ -71,7 +71,7 @@ void ivtv_enqueue(struct ivtv_stream *s, struct ivtv_buffer *buf, struct ivtv_qu
 struct ivtv_buffer *ivtv_dequeue(struct ivtv_stream *s, struct ivtv_queue *q)
 {
 	struct ivtv_buffer *buf = NULL;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	spin_lock_irqsave(&s->qlock, flags);
 	if (!list_empty(&q->list)) {
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index eab79ff..d3857ab 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -740,14 +740,13 @@ ssize_t videobuf_read_one(struct videobuf_queue *q,
 {
 	enum v4l2_field field;
 	unsigned long flags = 0;
-	unsigned size, nbufs;
+	unsigned size = 0, nbufs = 1;
 	int retval;
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
 	mutex_lock(&q->vb_lock);
 
-	nbufs = 1; size = 0;
 	q->ops->buf_setup(q, &nbufs, &size);
 
 	if (NULL == q->read_buf  &&
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

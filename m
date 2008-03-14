Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2EFAcUd021521
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 11:10:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m2EFA1jP021308
	for <video4linux-list@redhat.com>; Fri, 14 Mar 2008 11:10:07 -0400
Date: Fri, 14 Mar 2008 16:10:10 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0803141605370.5362@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] Improve compile-time type-checking in videobuf
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

Make the dev member of the struct videobuf_queue of type "struct device *" 
to avoid future problems. Also change the prototype of the 
videobuf_queue_core_init() function.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

I left videobuf_queue_vmalloc_init with "void *dev", it seems to be a 
generic variant, so far only used by the virtual vivi.c driver, and anyway 
called with dev = NULL there.

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 5ea635f..fe742fd 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -120,7 +120,7 @@ int videobuf_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
 			 struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 9903394..fcdffdd 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -151,7 +151,7 @@ struct videobuf_qtype_ops {
 struct videobuf_queue {
 	struct mutex               vb_lock;
 	spinlock_t                 *irqlock;
-	void			   *dev; /* on pci, points to struct pci_dev */
+	struct device		   *dev;
 
 	enum v4l2_buf_type         type;
 	unsigned int               inputs; /* for V4L2_BUF_FLAG_INPUT */
@@ -185,7 +185,7 @@ void *videobuf_alloc(struct videobuf_queue* q);
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
 			 struct videobuf_queue_ops *ops,
-			 void *dev,
+			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
 			 enum v4l2_field field,

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

Return-path: <linux-media-owner@vger.kernel.org>
Received: from vena.lwn.net ([206.168.112.25]:58949 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbZKNXIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2009 18:08:21 -0500
Date: Sat, 14 Nov 2009 16:08:24 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH] Make struct videobuf_queue_ops constant
Message-ID: <20091114160824.28266c03@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The videobuf_queue_ops function vector is not declared constant, but
there's no need for the videobuf layer to ever change it.  Make it const so
that videobuf users can make their operations const without warnings.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/videobuf-core.c       |    2 +-
 drivers/media/video/videobuf-dma-contig.c |    2 +-
 drivers/media/video/videobuf-dma-sg.c     |    2 +-
 drivers/media/video/videobuf-vmalloc.c    |    2 +-
 include/media/videobuf-core.h             |    4 ++--
 include/media/videobuf-dma-contig.h       |    2 +-
 include/media/videobuf-dma-sg.h           |    2 +-
 include/media/videobuf-vmalloc.h          |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 8e93c6f..2fdc5b3 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL_GPL(videobuf_queue_to_vmalloc);
 
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
index 635ffc7..49650ca 100644
--- a/drivers/media/video/videobuf-dma-contig.c
+++ b/drivers/media/video/videobuf-dma-contig.c
@@ -428,7 +428,7 @@ static struct videobuf_qtype_ops qops = {
 };
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 032ebae..f50e6b5 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -702,7 +702,7 @@ void *videobuf_sg_alloc(size_t size)
 }
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 35f3900..99d646e 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -391,7 +391,7 @@ static struct videobuf_qtype_ops qops = {
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff --git a/include/media/videobuf-core.h b/include/media/videobuf-core.h
index 1c5946c..316fdcc 100644
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -166,7 +166,7 @@ struct videobuf_queue {
 	enum v4l2_field            field;
 	enum v4l2_field            last;   /* for field=V4L2_FIELD_ALTERNATE */
 	struct videobuf_buffer     *bufs[VIDEO_MAX_FRAME];
-	struct videobuf_queue_ops  *ops;
+	const struct videobuf_queue_ops  *ops;
 	struct videobuf_qtype_ops  *int_ops;
 
 	unsigned int               streaming:1;
@@ -195,7 +195,7 @@ void *videobuf_queue_to_vmalloc (struct videobuf_queue* q,
 				 struct videobuf_buffer *buf);
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff --git a/include/media/videobuf-dma-contig.h b/include/media/videobuf-dma-contig.h
index 5493866..ebaa9bc 100644
--- a/include/media/videobuf-dma-contig.h
+++ b/include/media/videobuf-dma-contig.h
@@ -17,7 +17,7 @@
 #include <media/videobuf-core.h>
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
index dda47f0..53e72f7 100644
--- a/include/media/videobuf-dma-sg.h
+++ b/include/media/videobuf-dma-sg.h
@@ -103,7 +103,7 @@ struct videobuf_dmabuf *videobuf_to_dma (struct videobuf_buffer *buf);
 void *videobuf_sg_alloc(size_t size);
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-vmalloc.h
index e87222c..1ffdb66 100644
--- a/include/media/videobuf-vmalloc.h
+++ b/include/media/videobuf-vmalloc.h
@@ -30,7 +30,7 @@ struct videobuf_vmalloc_memory
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
-- 
1.6.2.5


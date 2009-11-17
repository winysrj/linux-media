Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbZKQWoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 17:44:14 -0500
Message-Id: <200911172243.nAHMhfAv029259@imap1.linux-foundation.org>
Subject: [patch 5/5] dvb: make struct videobuf_queue_ops constant
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	corbet@lwn.net
From: akpm@linux-foundation.org
Date: Tue, 17 Nov 2009 14:43:41 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jonathan Corbet <corbet@lwn.net>

The videobuf_queue_ops function vector is not declared constant, but
there's no need for the videobuf layer to ever change it.  Make it const
so that videobuf users can make their operations const without warnings.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

diff -puN drivers/media/video/videobuf-core.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-core.c
--- a/drivers/media/video/videobuf-core.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-core.c
@@ -110,7 +110,7 @@ EXPORT_SYMBOL_GPL(videobuf_queue_to_vmal
 
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-dma-contig.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -428,7 +428,7 @@ static struct videobuf_qtype_ops qops = 
 };
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-dma-sg.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -702,7 +702,7 @@ void *videobuf_sg_alloc(size_t size)
 }
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN drivers/media/video/videobuf-vmalloc.c~dvb-make-struct-videobuf_queue_ops-constant drivers/media/video/videobuf-vmalloc.c
--- a/drivers/media/video/videobuf-vmalloc.c~dvb-make-struct-videobuf_queue_ops-constant
+++ a/drivers/media/video/videobuf-vmalloc.c
@@ -391,7 +391,7 @@ static struct videobuf_qtype_ops qops = 
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-core.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-core.h
--- a/include/media/videobuf-core.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-core.h
@@ -166,7 +166,7 @@ struct videobuf_queue {
 	enum v4l2_field            field;
 	enum v4l2_field            last;   /* for field=V4L2_FIELD_ALTERNATE */
 	struct videobuf_buffer     *bufs[VIDEO_MAX_FRAME];
-	struct videobuf_queue_ops  *ops;
+	const struct videobuf_queue_ops  *ops;
 	struct videobuf_qtype_ops  *int_ops;
 
 	unsigned int               streaming:1;
@@ -195,7 +195,7 @@ void *videobuf_queue_to_vmalloc (struct 
 				 struct videobuf_buffer *buf);
 
 void videobuf_queue_core_init(struct videobuf_queue *q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-dma-contig.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-dma-contig.h
--- a/include/media/videobuf-dma-contig.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-dma-contig.h
@@ -17,7 +17,7 @@
 #include <media/videobuf-core.h>
 
 void videobuf_queue_dma_contig_init(struct videobuf_queue *q,
-				    struct videobuf_queue_ops *ops,
+				    const struct videobuf_queue_ops *ops,
 				    struct device *dev,
 				    spinlock_t *irqlock,
 				    enum v4l2_buf_type type,
diff -puN include/media/videobuf-dma-sg.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-dma-sg.h
--- a/include/media/videobuf-dma-sg.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-dma-sg.h
@@ -103,7 +103,7 @@ struct videobuf_dmabuf *videobuf_to_dma 
 void *videobuf_sg_alloc(size_t size);
 
 void videobuf_queue_sg_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 struct device *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
diff -puN include/media/videobuf-vmalloc.h~dvb-make-struct-videobuf_queue_ops-constant include/media/videobuf-vmalloc.h
--- a/include/media/videobuf-vmalloc.h~dvb-make-struct-videobuf_queue_ops-constant
+++ a/include/media/videobuf-vmalloc.h
@@ -30,7 +30,7 @@ struct videobuf_vmalloc_memory
 };
 
 void videobuf_queue_vmalloc_init(struct videobuf_queue* q,
-			 struct videobuf_queue_ops *ops,
+			 const struct videobuf_queue_ops *ops,
 			 void *dev,
 			 spinlock_t *irqlock,
 			 enum v4l2_buf_type type,
_

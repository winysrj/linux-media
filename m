Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59317 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab2IQS7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 14:59:42 -0400
Received: by yhmm54 with SMTP id m54so1597420yhm.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 11:59:41 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <elezegarcia@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2] videobuf2-core: Replace BUG_ON and return an error at vb2_queue_init()
Date: Mon, 17 Sep 2012 15:59:30 -0300
Message-Id: <1347908370-2560-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This replaces BUG_ON() calls with WARN_ON(), and returns
EINVAL if some parameter is NULL, as suggested by Jonathan and Mauro.

The BUG_ON() call is too drastic to be used in this case.
See the full discussion here:
http://www.spinics.net/lists/linux-media/msg52462.html

Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
Changes from v1: Replace WARN_ON_ONCE with WARN_ON

 drivers/media/v4l2-core/videobuf2-core.c |   19 +++++++++++--------
 include/media/videobuf2-core.h           |    2 +-
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..78a764a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1738,14 +1738,17 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  */
 int vb2_queue_init(struct vb2_queue *q)
 {
-	BUG_ON(!q);
-	BUG_ON(!q->ops);
-	BUG_ON(!q->mem_ops);
-	BUG_ON(!q->type);
-	BUG_ON(!q->io_modes);
-
-	BUG_ON(!q->ops->queue_setup);
-	BUG_ON(!q->ops->buf_queue);
+	/*
+	 * Sanity check
+	 */
+	if (WARN_ON(!q)			  ||
+	    WARN_ON(!q->ops)		  ||
+	    WARN_ON(!q->mem_ops)	  ||
+	    WARN_ON(!q->type)		  ||
+	    WARN_ON(!q->io_modes)	  ||
+	    WARN_ON(!q->ops->queue_setup) ||
+	    WARN_ON(!q->ops->buf_queue))
+		return -EINVAL;
 
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8dd9b6c..e04252a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -324,7 +324,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
-int vb2_queue_init(struct vb2_queue *q);
+int __must_check vb2_queue_init(struct vb2_queue *q);
 
 void vb2_queue_release(struct vb2_queue *q);
 
-- 
1.7.8.6


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:44969 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2HYDJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 23:09:26 -0400
Received: by mail-gg0-f174.google.com with SMTP id k6so581646ggd.19
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 20:09:25 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type to void
Date: Sat, 25 Aug 2012 00:09:06 -0300
Message-Id: <1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    3 +--
 include/media/videobuf2-core.h           |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 4da3df6..ea45842 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1736,7 +1736,7 @@ EXPORT_SYMBOL_GPL(vb2_poll);
  * to the struct vb2_queue description in include/media/videobuf2-core.h
  * for more information.
  */
-int vb2_queue_init(struct vb2_queue *q)
+void vb2_queue_init(struct vb2_queue *q)
 {
 	BUG_ON(!q);
 	BUG_ON(!q->ops);
@@ -1755,7 +1755,6 @@ int vb2_queue_init(struct vb2_queue *q)
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);
 
-	return 0;
 }
 EXPORT_SYMBOL_GPL(vb2_queue_init);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 8dd9b6c..ed6854a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -324,7 +324,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req);
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
-int vb2_queue_init(struct vb2_queue *q);
+void vb2_queue_init(struct vb2_queue *q);
 
 void vb2_queue_release(struct vb2_queue *q);
 
-- 
1.7.8.6


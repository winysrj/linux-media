Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54010 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbeEDUHz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:07:55 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v9 04/15] vb2: move vb2_ops functions to videobuf2-core.[ch]
Date: Fri,  4 May 2018 17:06:01 -0300
Message-Id: <20180504200612.8763-5-ezequiel@collabora.com>
In-Reply-To: <20180504200612.8763-1-ezequiel@collabora.com>
References: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

vb2_ops_wait_prepare() and vb2_ops_wait_finish() were in the
wrong file.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 14 ++++++++++++++
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 14 --------------
 include/media/videobuf2-core.h                  | 18 ++++++++++++++++++
 include/media/videobuf2-v4l2.h                  | 18 ------------------
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb33a54d..6b8e083893ad 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -656,6 +656,20 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 }
 EXPORT_SYMBOL(vb2_verify_memory_type);
 
+/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
+
+void vb2_ops_wait_prepare(struct vb2_queue *vq)
+{
+	mutex_unlock(vq->lock);
+}
+EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
+
+void vb2_ops_wait_finish(struct vb2_queue *vq)
+{
+	mutex_lock(vq->lock);
+}
+EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
+
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		unsigned int *count)
 {
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 886a2d8d5c6c..64503615d00b 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -947,20 +947,6 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
 #endif
 
-/* vb2_ops helpers. Only use if vq->lock is non-NULL. */
-
-void vb2_ops_wait_prepare(struct vb2_queue *vq)
-{
-	mutex_unlock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_prepare);
-
-void vb2_ops_wait_finish(struct vb2_queue *vq)
-{
-	mutex_lock(vq->lock);
-}
-EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
-
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f6818f732f34..f9633de0386c 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -400,6 +400,24 @@ struct vb2_ops {
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
 
+/**
+ * vb2_ops_wait_prepare - helper function to lock a struct &vb2_queue
+ *
+ * @vq: pointer to &struct vb2_queue
+ *
+ * ..note:: only use if vq->lock is non-NULL.
+ */
+void vb2_ops_wait_prepare(struct vb2_queue *vq);
+
+/**
+ * vb2_ops_wait_finish - helper function to unlock a struct &vb2_queue
+ *
+ * @vq: pointer to &struct vb2_queue
+ *
+ * ..note:: only use if vq->lock is non-NULL.
+ */
+void vb2_ops_wait_finish(struct vb2_queue *vq);
+
 /**
  * struct vb2_buf_ops - driver-specific callbacks.
  *
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 3d5e2d739f05..cf83b01dc44e 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -273,22 +273,4 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags);
 #endif
 
-/**
- * vb2_ops_wait_prepare - helper function to lock a struct &vb2_queue
- *
- * @vq: pointer to &struct vb2_queue
- *
- * ..note:: only use if vq->lock is non-NULL.
- */
-void vb2_ops_wait_prepare(struct vb2_queue *vq);
-
-/**
- * vb2_ops_wait_finish - helper function to unlock a struct &vb2_queue
- *
- * @vq: pointer to &struct vb2_queue
- *
- * ..note:: only use if vq->lock is non-NULL.
- */
-void vb2_ops_wait_finish(struct vb2_queue *vq);
-
 #endif /* _MEDIA_VIDEOBUF2_V4L2_H */
-- 
2.16.3

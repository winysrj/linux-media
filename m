Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44280 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753255AbeEURBd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:01:33 -0400
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
Subject: [PATCH v10 01/16] videobuf2: Make struct vb2_buffer refcounted
Date: Mon, 21 May 2018 13:59:31 -0300
Message-Id: <20180521165946.11778-2-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The in-fence implementation involves having a per-buffer fence callback,
that triggers on the fence signal. The fence callback is called asynchronously
and needs a valid reference to the associated ideobuf2 buffer.

Allow this by making the vb2_buffer refcounted, so it can be passed
to other contexts.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 27 ++++++++++++++++++++++---
 include/media/videobuf2-core.h                  |  7 +++++--
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index d3f7bb33a54d..f1feb45c1e37 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -190,6 +190,26 @@ module_param(debug, int, 0644);
 static void __vb2_queue_cancel(struct vb2_queue *q);
 static void __enqueue_in_driver(struct vb2_buffer *vb);
 
+static void __vb2_buffer_free(struct kref *kref)
+{
+	struct vb2_buffer *vb =
+		container_of(kref, struct vb2_buffer, refcount);
+	kfree(vb);
+}
+
+static void __vb2_buffer_put(struct vb2_buffer *vb)
+{
+	if (vb)
+		kref_put(&vb->refcount, __vb2_buffer_free);
+}
+
+static struct vb2_buffer *__vb2_buffer_get(struct vb2_buffer *vb)
+{
+	if (vb)
+		kref_get(&vb->refcount);
+	return vb;
+}
+
 /*
  * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
  */
@@ -346,6 +366,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			break;
 		}
 
+		kref_init(&vb->refcount);
 		vb->state = VB2_BUF_STATE_DEQUEUED;
 		vb->vb2_queue = q;
 		vb->num_planes = num_planes;
@@ -365,7 +386,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 				dprintk(1, "failed allocating memory for buffer %d\n",
 					buffer);
 				q->bufs[vb->index] = NULL;
-				kfree(vb);
+				__vb2_buffer_put(vb);
 				break;
 			}
 			__setup_offsets(vb);
@@ -380,7 +401,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 					buffer, vb);
 				__vb2_buf_mem_free(vb);
 				q->bufs[vb->index] = NULL;
-				kfree(vb);
+				__vb2_buffer_put(vb);
 				break;
 			}
 		}
@@ -520,7 +541,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 	/* Free videobuf buffers */
 	for (buffer = q->num_buffers - buffers; buffer < q->num_buffers;
 	     ++buffer) {
-		kfree(q->bufs[buffer]);
+		__vb2_buffer_put(q->bufs[buffer]);
 		q->bufs[buffer] = NULL;
 	}
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index f6818f732f34..baa4632c7e59 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -12,11 +12,12 @@
 #ifndef _MEDIA_VIDEOBUF2_CORE_H
 #define _MEDIA_VIDEOBUF2_CORE_H
 
+#include <linux/bitops.h>
+#include <linux/dma-buf.h>
+#include <linux/kref.h>
 #include <linux/mm_types.h>
 #include <linux/mutex.h>
 #include <linux/poll.h>
-#include <linux/dma-buf.h>
-#include <linux/bitops.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -249,6 +250,7 @@ struct vb2_buffer {
 
 	/* private: internal use only
 	 *
+	 * refcount:		refcount for this buffer
 	 * state:		current buffer state; do not change
 	 * queued_entry:	entry on the queued buffers list, which holds
 	 *			all buffers queued from userspace
@@ -256,6 +258,7 @@ struct vb2_buffer {
 	 *			to be dequeued to userspace
 	 * vb2_plane:		per-plane information; do not change
 	 */
+	struct kref		refcount;
 	enum vb2_buffer_state	state;
 
 	struct vb2_plane	planes[VB2_MAX_PLANES];
-- 
2.16.3

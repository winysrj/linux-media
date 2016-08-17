Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34870
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbcHQS3b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 14:29:31 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: [RFC PATCH 2/2] [media] vb2: move dma-buf unmap from __vb2_dqbuf() to vb2_done_work()
Date: Wed, 17 Aug 2016 14:28:57 -0400
Message-Id: <1471458537-16859-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
References: <1471458537-16859-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the dma-buf is unmapped when the buffer is dequeued by userspace
but it's not used anymore after the driver finished processing the buffer.

So instead of doing the dma-buf unmapping in __vb2_dqbuf(), it can be made
in vb2_done_work() after the driver notified that has finished processing.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/v4l2-core/videobuf2-core.c | 33 ++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 14bed8acf3cf..5f930dbedfa4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -315,6 +315,21 @@ static void __setup_offsets(struct vb2_buffer *vb)
 	}
 }
 
+ /**
+ * __vb2_unmap_dmabuf() - unmap dma-buf attached to buffer planes
+ */
+static void __vb2_unmap_dmabuf(struct vb2_buffer *vb)
+{
+	int i;
+
+	for (i = 0; i < vb->num_planes; ++i) {
+		if (!vb->planes[i].dbuf_mapped)
+			continue;
+		call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
+		vb->planes[i].dbuf_mapped = 0;
+	}
+}
+
 static void vb2_done_work(struct work_struct *work)
 {
 	struct vb2_buffer *vb = container_of(work, struct vb2_buffer,
@@ -348,6 +363,9 @@ static void vb2_done_work(struct work_struct *work)
 			__enqueue_in_driver(vb);
 		break;
 	default:
+		if (q->memory == VB2_MEMORY_DMABUF)
+			__vb2_unmap_dmabuf(vb);
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1725,23 +1743,11 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
  */
 static void __vb2_dqbuf(struct vb2_buffer *vb)
 {
-	struct vb2_queue *q = vb->vb2_queue;
-	unsigned int i;
-
 	/* nothing to do if the buffer is already dequeued */
 	if (vb->state == VB2_BUF_STATE_DEQUEUED)
 		return;
 
 	vb->state = VB2_BUF_STATE_DEQUEUED;
-
-	/* unmap DMABUF buffer */
-	if (q->memory == VB2_MEMORY_DMABUF)
-		for (i = 0; i < vb->num_planes; ++i) {
-			if (!vb->planes[i].dbuf_mapped)
-				continue;
-			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
-			vb->planes[i].dbuf_mapped = 0;
-		}
 }
 
 /**
@@ -1885,6 +1891,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
 			call_void_vb_qop(vb, buf_finish, vb);
 		}
 		__vb2_dqbuf(vb);
+
+		if (q->memory == VB2_MEMORY_DMABUF)
+			__vb2_unmap_dmabuf(vb);
 	}
 }
 
-- 
2.5.5


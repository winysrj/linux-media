Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47172
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbcGTSWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 14:22:37 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] vb2: move dma-buf unmap from __vb2_dqbuf() to vb2_buffer_done()
Date: Wed, 20 Jul 2016 14:22:21 -0400
Message-Id: <1469038941-5257-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the dma-buf is unmapped when the buffer is dequeued by userspace
but it's not used anymore after the driver finished processing the buffer.

So instead of doing the dma-buf unmapping in __vb2_dqbuf(), it can be made
in vb2_buffer_done() after the driver notified that buf processing is done.

Decoupling the buffer dequeue from the dma-buf unmapping has also the side
effect of making possible to add dma-buf fence support in the future since
the buffer could be dequeued even before the driver has finished using it.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
Hello,

I've tested this patch doing DMA buffer sharing between a
vivid input and output device with both v4l2-ctl and gst:

$ v4l2-ctl -d0 -e1 --stream-dmabuf --stream-out-mmap
$ v4l2-ctl -d0 -e1 --stream-mmap --stream-out-dmabuf
$ gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf ! v4l2sink device=/dev/video1 io-mode=dmabuf-import

And I didn't find any issues but more testing will be appreciated.

Best regards,
Javier

 drivers/media/v4l2-core/videobuf2-core.c | 34 +++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7128b09810be..973331efaf79 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -958,6 +958,22 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
 EXPORT_SYMBOL_GPL(vb2_plane_cookie);
 
 /**
+ * __vb2_unmap_dmabuf() - unmap dma-buf attached to buffer planes
+ */
+static void __vb2_unmap_dmabuf(struct vb2_buffer *vb)
+{
+	int i;
+
+	for (i = 0; i < vb->num_planes; ++i) {
+		if (!vb->planes[i].dbuf_mapped)
+			continue;
+		call_void_memop(vb, unmap_dmabuf,
+				vb->planes[i].mem_priv);
+		vb->planes[i].dbuf_mapped = 0;
+	}
+}
+
+/**
  * vb2_buffer_done() - inform videobuf that an operation on a buffer is finished
  * @vb:		vb2_buffer returned from the driver
  * @state:	either VB2_BUF_STATE_DONE if the operation finished successfully,
@@ -1028,6 +1044,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 			__enqueue_in_driver(vb);
 		return;
 	default:
+		if (q->memory == VB2_MEMORY_DMABUF)
+			__vb2_unmap_dmabuf(vb);
+
 		/* Inform any processes that may be waiting for buffers */
 		wake_up(&q->done_wq);
 		break;
@@ -1708,23 +1727,11 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
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
@@ -1861,6 +1868,9 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
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


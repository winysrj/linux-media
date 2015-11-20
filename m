Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:58518 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbbKTQkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 11:40:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv10 13/15] videobuf2-core: call __setup_offsets before buf_init()
Date: Fri, 20 Nov 2015 17:34:16 +0100
Message-Id: <1448037258-36305-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037258-36305-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that the offsets are correct before buf_init() is called.
As a consequence the __setup_offsets() function now sets up the
offsets for the given buffer instead of for all new buffers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 42 ++++++++++++--------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 98b5449..26ba9e4 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -288,37 +288,29 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 
 /**
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
- * every buffer on the queue
+ * the buffer.
  */
-static void __setup_offsets(struct vb2_queue *q, unsigned int n)
+static void __setup_offsets(struct vb2_buffer *vb)
 {
-	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
-	unsigned long off;
+	struct vb2_queue *q = vb->vb2_queue;
+	unsigned int plane;
+	unsigned long off = 0;
+
+	if (vb->index) {
+		struct vb2_buffer *prev = q->bufs[vb->index - 1];
+		struct vb2_plane *p = &prev->planes[prev->num_planes - 1];
 
-	if (q->num_buffers) {
-		struct vb2_plane *p;
-		vb = q->bufs[q->num_buffers - 1];
-		p = &vb->planes[vb->num_planes - 1];
 		off = PAGE_ALIGN(p->m.offset + p->length);
-	} else {
-		off = 0;
 	}
 
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			vb->planes[plane].m.offset = off;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		vb->planes[plane].m.offset = off;
 
-			dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
-					buffer, plane, off);
+		dprintk(3, "buffer %d, plane %d offset 0x%08lx\n",
+				vb->index, plane, off);
 
-			off += vb->planes[plane].length;
-			off = PAGE_ALIGN(off);
-		}
+		off += vb->planes[plane].length;
+		off = PAGE_ALIGN(off);
 	}
 }
 
@@ -364,6 +356,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 				q->bufs[vb->index] = NULL;
 				break;
 			}
+			__setup_offsets(vb);
 			/*
 			 * Call the driver-provided buffer initialization
 			 * callback, if given. An error in initialization
@@ -381,9 +374,6 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		}
 	}
 
-	if (memory == VB2_MEMORY_MMAP)
-		__setup_offsets(q, buffer);
-
 	dprintk(1, "allocated %d buffers, %d plane(s) each\n",
 			buffer, num_planes);
 
-- 
2.6.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:49297 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3LDOPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 09:15:47 -0500
Message-ID: <529F38AD.7030703@cisco.com>
Date: Wed, 04 Dec 2013 15:14:05 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH for 3.13] vb2: regression fix: always set length field.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit dc77523c5da5513df1bbc74db2a522a94f4cec0e ensured that m.offset is
only set for the MMAP memory mode by calling __setup_offsets only for that
mode.

However, __setup_offsets also initializes the length fields, and that should
be done regardless of the memory mode. Because of that change the v4l2-ctl
test application fails for the USERPTR mode.

This fix creates a __setup_lengths function that sets the length, and
__setup_offsets just sets the offset and no longer touches the length.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 57ba131..0edc165 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -145,6 +145,25 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 }
 
 /**
+ * __setup_lengths() - setup initial lengths for every plane in
+ * every buffer on the queue
+ */
+static void __setup_lengths(struct vb2_queue *q, unsigned int n)
+{
+	unsigned int buffer, plane;
+	struct vb2_buffer *vb;
+
+	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
+		vb = q->bufs[buffer];
+		if (!vb)
+			continue;
+
+		for (plane = 0; plane < vb->num_planes; ++plane)
+			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
+	}
+}
+
+/**
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
  * every buffer on the queue
  */
@@ -169,7 +188,6 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 			continue;
 
 		for (plane = 0; plane < vb->num_planes; ++plane) {
-			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
 			vb->v4l2_planes[plane].m.mem_offset = off;
 
 			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
@@ -241,6 +259,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 		q->bufs[q->num_buffers + buffer] = vb;
 	}
 
+	__setup_lengths(q, buffer);
 	if (memory == V4L2_MEMORY_MMAP)
 		__setup_offsets(q, buffer);
 
-- 
1.8.4.rc3


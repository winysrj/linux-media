Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:42834 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759664AbbKTRB6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 12:01:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv11 12/15] videobuf2-core: move __setup_lengths into __vb2_queue_alloc()
Date: Fri, 20 Nov 2015 17:45:45 +0100
Message-Id: <1448037948-36820-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than setting up the lengths at the end, set them up when
the vb2_buffer is allocated. This also ensures that buf_init()
sees the right length values.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5cd418e..96dca47 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -287,25 +287,6 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
 }
 
 /**
- * __setup_lengths() - setup initial lengths for every plane in
- * every buffer on the queue
- */
-static void __setup_lengths(struct vb2_queue *q, unsigned int n)
-{
-	unsigned int buffer, plane;
-	struct vb2_buffer *vb;
-
-	for (buffer = q->num_buffers; buffer < q->num_buffers + n; ++buffer) {
-		vb = q->bufs[buffer];
-		if (!vb)
-			continue;
-
-		for (plane = 0; plane < vb->num_planes; ++plane)
-			vb->planes[plane].length = q->plane_sizes[plane];
-	}
-}
-
-/**
  * __setup_offsets() - setup unique offsets ("cookies") for every plane in
  * every buffer on the queue
  */
@@ -351,7 +332,7 @@ static void __setup_offsets(struct vb2_queue *q, unsigned int n)
 static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			     unsigned int num_buffers, unsigned int num_planes)
 {
-	unsigned int buffer;
+	unsigned int buffer, plane;
 	struct vb2_buffer *vb;
 	int ret;
 
@@ -369,6 +350,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		vb->index = q->num_buffers + buffer;
 		vb->type = q->type;
 		vb->memory = memory;
+		for (plane = 0; plane < num_planes; ++plane)
+			vb->planes[plane].length = q->plane_sizes[plane];
 
 		/* Allocate video buffer memory for the MMAP type */
 		if (memory == VB2_MEMORY_MMAP) {
@@ -397,7 +380,6 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		q->bufs[q->num_buffers + buffer] = vb;
 	}
 
-	__setup_lengths(q, buffer);
 	if (memory == VB2_MEMORY_MMAP)
 		__setup_offsets(q, buffer);
 
-- 
2.6.2


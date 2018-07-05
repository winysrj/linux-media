Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41871 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754035AbeGEQDo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Jul 2018 12:03:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv16 20/34] vb2: add init_buffer buffer op
Date: Thu,  5 Jul 2018 18:03:23 +0200
Message-Id: <20180705160337.54379-21-hverkuil@xs4all.nl>
In-Reply-To: <20180705160337.54379-1-hverkuil@xs4all.nl>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

We need to initialize the request_fd field in struct vb2_v4l2_buffer
to -1 instead of the default of 0. So we need to add a new op that
is called when struct vb2_v4l2_buffer is allocated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 2 ++
 include/media/videobuf2-core.h                  | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 997673b62afc..a9e958df8324 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -356,6 +356,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 			vb->planes[plane].length = plane_sizes[plane];
 			vb->planes[plane].min_length = plane_sizes[plane];
 		}
+		call_void_bufop(q, init_buffer, vb);
+
 		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5e760d5f280a..cbda3968d018 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -408,6 +408,9 @@ struct vb2_ops {
  * @verify_planes_array: Verify that a given user space structure contains
  *			enough planes for the buffer. This is called
  *			for each dequeued buffer.
+ * @init_buffer:	given a &vb2_buffer initialize the extra data after
+ *			struct vb2_buffer.
+ *			For V4L2 this is a &struct vb2_v4l2_buffer.
  * @fill_user_buffer:	given a &vb2_buffer fill in the userspace structure.
  *			For V4L2 this is a &struct v4l2_buffer.
  * @fill_vb2_buffer:	given a userspace structure, fill in the &vb2_buffer.
@@ -418,6 +421,7 @@ struct vb2_ops {
  */
 struct vb2_buf_ops {
 	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
+	void (*init_buffer)(struct vb2_buffer *vb);
 	void (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, struct vb2_plane *planes);
 	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
-- 
2.18.0

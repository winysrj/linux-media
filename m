Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49737 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbeLCMrD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 07:47:03 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 1/3] vb2: add buf_validate callback
Date: Mon,  3 Dec 2018 13:46:01 +0100
Message-Id: <20181203124603.17932-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Adding the request API uncovered a pre-existing problem with
validating output buffers.

The problem is that for output buffers the driver has to validate
the 'field' field of struct v4l2_buffer. This is critical when
encoding or deinterlacing interlaced video.

Drivers always did this in the buf_prepare callback, but that is
not called from VIDIOC_QBUF in two situations: when queueing a
buffer to a request and if VIDIOC_PREPARE_BUF has been called
earlier for that buffer.

As a result of this the 'field' value is not validated.

This patch adds a new buf_validate callback to validate the
output buffer at QBUF time.

Note that PREPARE_BUF doesn't need to validate this: it just
locks the buffer memory and doesn't need nor want to know about
how this buffer is actually going to be used. It's the QBUF ioctl
that determines this.

This issue was found by v4l2-compliance since it failed to replace
V4L2_FIELD_ANY by a proper field value when testing the vivid video
output in combination with requests.

There never was a test before for the PREPARE_BUF/QBUF case, so even
though this bug has been present for quite some time, it was never
noticed.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 12 +++++++++---
 include/media/videobuf2-core.h                  |  5 +++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 0ca81d495bda..42eb7716f8a9 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -499,9 +499,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 			pr_info("     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
 				vb->cnt_buf_init, vb->cnt_buf_cleanup,
 				vb->cnt_buf_prepare, vb->cnt_buf_finish);
-			pr_info("     buf_queue: %u buf_done: %u buf_request_complete: %u\n",
-				vb->cnt_buf_queue, vb->cnt_buf_done,
-				vb->cnt_buf_request_complete);
+			pr_info("     buf_validate: %u buf_queue: %u buf_done: %u buf_request_complete: %u\n",
+				vb->cnt_buf_validate, vb->cnt_buf_queue,
+				vb->cnt_buf_done, vb->cnt_buf_request_complete);
 			pr_info("     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
 				vb->cnt_mem_alloc, vb->cnt_mem_put,
 				vb->cnt_mem_prepare, vb->cnt_mem_finish,
@@ -1506,6 +1506,12 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
 		return -EBUSY;
 	}
 
+	ret = call_vb_qop(vb, buf_validate, vb);
+	if (ret) {
+		dprintk(1, "buffer validation failed\n");
+		return ret;
+	}
+
 	if (req) {
 		int ret;
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae..c9f0f3f4ef9a 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -294,6 +294,7 @@ struct vb2_buffer {
 	u32		cnt_mem_num_users;
 	u32		cnt_mem_mmap;
 
+	u32		cnt_buf_validate;
 	u32		cnt_buf_init;
 	u32		cnt_buf_prepare;
 	u32		cnt_buf_finish;
@@ -340,6 +341,9 @@ struct vb2_buffer {
  * @wait_finish:	reacquire all locks released in the previous callback;
  *			required to continue operation after sleeping while
  *			waiting for a new buffer to arrive.
+ * @buf_validate:	called every time the buffer is queued from userspace;
+ *			drivers can use this to validate userspace-provided
+ *			information; optional.
  * @buf_init:		called once after allocating a buffer (in MMAP case)
  *			or after acquiring a new USERPTR buffer; drivers may
  *			perform additional buffer-related initialization;
@@ -407,6 +411,7 @@ struct vb2_ops {
 	void (*wait_prepare)(struct vb2_queue *q);
 	void (*wait_finish)(struct vb2_queue *q);
 
+	int (*buf_validate)(struct vb2_buffer *vb);
 	int (*buf_init)(struct vb2_buffer *vb);
 	int (*buf_prepare)(struct vb2_buffer *vb);
 	void (*buf_finish)(struct vb2_buffer *vb);
-- 
2.19.1

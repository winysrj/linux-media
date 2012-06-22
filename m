Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3766 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833Ab2FVMVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 23/34] vb2-core: refactor reqbufs/create_bufs.
Date: Fri, 22 Jun 2012 14:21:17 +0200
Message-Id: <ba29d82aed900a60e0d5c170272bb28614d439ef.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Split off the memory and type validation. This is done both from reqbufs and
create_bufs, and will also be done by vb2 helpers in a later patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |  153 ++++++++++++++++++----------------
 1 file changed, 80 insertions(+), 73 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 9d4e9ed..8486e33 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -454,7 +454,53 @@ static int __verify_mmap_ops(struct vb2_queue *q)
 }
 
 /**
- * vb2_reqbufs() - Initiate streaming
+ * __verify_memory_type() - do basic checks for memory and type
+ */
+static int __verify_memory_type(struct vb2_queue *q, __u32 memory, __u32 type)
+{
+	if (memory != V4L2_MEMORY_MMAP && memory != V4L2_MEMORY_USERPTR) {
+		dprintk(1, "reqbufs: unsupported memory type\n");
+		return -EINVAL;
+	}
+
+	if (type != q->type) {
+		dprintk(1, "reqbufs: requested type is incorrect\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Make sure all the required memory ops for given memory type
+	 * are available.
+	 */
+	if (memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
+		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	if (memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
+		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Place the busy tests at the end: -EBUSY can be ignored when
+	 * create_bufs is called with count == 0, but count == 0 should still
+	 * do the memory and type validation.
+	 */
+	if (q->fileio) {
+		dprintk(1, "reqbufs: file io in progress\n");
+		return -EBUSY;
+	}
+
+	if (q->streaming) {
+		dprintk(1, "reqbufs: streaming active\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+/**
+ * __reqbufs() - Initiate streaming
  * @q:		videobuf2 queue
  * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
  *
@@ -476,45 +522,10 @@ static int __verify_mmap_ops(struct vb2_queue *q)
  * The return values from this function are intended to be directly returned
  * from vidioc_reqbufs handler in driver.
  */
-int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
-	int ret = 0;
-
-	if (q->fileio) {
-		dprintk(1, "reqbufs: file io in progress\n");
-		return -EBUSY;
-	}
-
-	if (req->memory != V4L2_MEMORY_MMAP
-			&& req->memory != V4L2_MEMORY_USERPTR) {
-		dprintk(1, "reqbufs: unsupported memory type\n");
-		return -EINVAL;
-	}
-
-	if (req->type != q->type) {
-		dprintk(1, "reqbufs: requested type is incorrect\n");
-		return -EINVAL;
-	}
-
-	if (q->streaming) {
-		dprintk(1, "reqbufs: streaming active\n");
-		return -EBUSY;
-	}
-
-	/*
-	 * Make sure all the required memory ops for given memory type
-	 * are available.
-	 */
-	if (req->memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
-		dprintk(1, "reqbufs: MMAP for current setup unsupported\n");
-		return -EINVAL;
-	}
-
-	if (req->memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
-		dprintk(1, "reqbufs: USERPTR for current setup unsupported\n");
-		return -EINVAL;
-	}
+	int ret;
 
 	if (req->count == 0 || q->num_buffers != 0 || q->memory != req->memory) {
 		/*
@@ -595,10 +606,23 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 
 	return 0;
 }
+
+/**
+ * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
+ * type values.
+ * @q:		videobuf2 queue
+ * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
+ */
+int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
+{
+	int ret = __verify_memory_type(q, req->memory, req->type);
+
+	return ret ? ret : __reqbufs(q, req);
+}
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
 /**
- * vb2_create_bufs() - Allocate buffers and any required auxiliary structs
+ * __create_bufs() - Allocate buffers and any required auxiliary structs
  * @q:		videobuf2 queue
  * @create:	creation parameters, passed from userspace to vidioc_create_bufs
  *		handler in driver
@@ -612,40 +636,10 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
  * The return values from this function are intended to be directly returned
  * from vidioc_create_bufs handler in driver.
  */
-int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
-	int ret = 0;
-
-	if (q->fileio) {
-		dprintk(1, "%s(): file io in progress\n", __func__);
-		return -EBUSY;
-	}
-
-	if (create->memory != V4L2_MEMORY_MMAP
-			&& create->memory != V4L2_MEMORY_USERPTR) {
-		dprintk(1, "%s(): unsupported memory type\n", __func__);
-		return -EINVAL;
-	}
-
-	if (create->format.type != q->type) {
-		dprintk(1, "%s(): requested type is incorrect\n", __func__);
-		return -EINVAL;
-	}
-
-	/*
-	 * Make sure all the required memory ops for given memory type
-	 * are available.
-	 */
-	if (create->memory == V4L2_MEMORY_MMAP && __verify_mmap_ops(q)) {
-		dprintk(1, "%s(): MMAP for current setup unsupported\n", __func__);
-		return -EINVAL;
-	}
-
-	if (create->memory == V4L2_MEMORY_USERPTR && __verify_userptr_ops(q)) {
-		dprintk(1, "%s(): USERPTR for current setup unsupported\n", __func__);
-		return -EINVAL;
-	}
+	int ret;
 
 	if (q->num_buffers == VIDEO_MAX_FRAME) {
 		dprintk(1, "%s(): maximum number of buffers already allocated\n",
@@ -653,8 +647,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		return -ENOBUFS;
 	}
 
-	create->index = q->num_buffers;
-
 	if (!q->num_buffers) {
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
@@ -719,6 +711,21 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 
 	return 0;
 }
+
+/**
+ * vb2_reqbufs() - Wrapper for __reqbufs() that also verifies the memory and
+ * type values.
+ * @q:		videobuf2 queue
+ * @create:	creation parameters, passed from userspace to vidioc_create_bufs
+ *		handler in driver
+ */
+int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
+{
+	int ret = __verify_memory_type(q, create->memory, create->format.type);
+
+	create->index = q->num_buffers;
+	return ret ? ret : __create_bufs(q, create);
+}
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
-- 
1.7.10


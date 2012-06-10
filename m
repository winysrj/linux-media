Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4072 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab2FJK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 24/32] videobuf2-core: add helper functions.
Date: Sun, 10 Jun 2012 12:25:46 +0200
Message-Id: <25b850acc7ddf6e625ef599a00a0079ec92178ed.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add helper functions to make it easier to adapt drivers to vb2.

These helpers take care of core locking and check if the filehandle is the
owner of the queue.

This patch also adds support for count == 0 in create_bufs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |  353 ++++++++++++++++++++++++++--------
 include/media/videobuf2-core.h       |   19 ++
 2 files changed, 297 insertions(+), 75 deletions(-)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 9d4e9ed..80bcc5d 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -454,7 +454,48 @@ static int __verify_mmap_ops(struct vb2_queue *q)
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
@@ -476,45 +517,10 @@ static int __verify_mmap_ops(struct vb2_queue *q)
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
@@ -595,10 +601,23 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 
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
@@ -612,40 +631,10 @@ EXPORT_SYMBOL_GPL(vb2_reqbufs);
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
@@ -653,8 +642,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 		return -ENOBUFS;
 	}
 
-	create->index = q->num_buffers;
-
 	if (!q->num_buffers) {
 		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
 		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
@@ -706,9 +693,9 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 
 	q->num_buffers += allocated_buffers;
 
-	if (ret < 0) {
+	if (ret == 0) {
 		__vb2_queue_free(q, allocated_buffers);
-		return ret;
+		return -ENOMEM;
 	}
 
 	/*
@@ -719,6 +706,23 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 
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
+	if (create->count == 0)
+		return ret == -EINVAL ? ret : 0;
+	return ret ? ret : __create_bufs(q, create);
+}
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
 /**
@@ -2115,6 +2119,205 @@ size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
 }
 EXPORT_SYMBOL_GPL(vb2_write);
 
+static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
+{
+	return vdev->queue_owner && vdev->queue_owner != file->private_data;
+}
+
+int vb2_ioctl_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p)
+{
+	struct video_device *vdev = video_devdata(file);
+	int res = __verify_memory_type(vdev->queue, p->memory, p->type);
+
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = __reqbufs(vdev->queue, p);
+	if (res == 0)
+		vdev->queue_owner = p->count ? file->private_data : NULL;
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_reqbufs);
+
+int vb2_ioctl_create_bufs(struct file *file, void *priv,
+			  struct v4l2_create_buffers *p)
+{
+	struct video_device *vdev = video_devdata(file);
+	int res = __verify_memory_type(vdev->queue, p->memory, p->format.type);
+
+	p->index = vdev->queue->num_buffers;
+	if (p->count == 0)
+		return res == -EINVAL ? res : 0;
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = __create_bufs(vdev->queue, p);
+	if (res == 0)
+		vdev->queue_owner = file->private_data;
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_create_bufs);
+
+int vb2_ioctl_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_prepare_buf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_prepare_buf);
+
+int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	return vb2_querybuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_querybuf);
+
+int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_qbuf(vdev->queue, p);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_qbuf);
+
+int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_dqbuf(vdev->queue, p, file->f_flags & O_NONBLOCK);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_dqbuf);
+
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamon(vdev->queue, i);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamon);
+
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	return vb2_streamoff(vdev->queue, i);
+}
+EXPORT_SYMBOL_GPL(vb2_ioctl_streamoff);
+
+int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	return vb2_mmap(vdev->queue, vma);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_mmap);
+
+int vb2_fop_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+
+	if (file->private_data == vdev->queue_owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue_owner = NULL;
+	}
+	return v4l2_fh_release(file);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_release);
+
+ssize_t vb2_fop_write(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue_lock ? vdev->queue_lock : vdev->lock;
+	bool must_lock = !test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) && lock;
+	int err = -EBUSY;
+
+	if (must_lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_write(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (err >= 0)
+		vdev->queue_owner = file->private_data;
+exit:
+	if (must_lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_write);
+
+ssize_t vb2_fop_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue_lock ? vdev->queue_lock : vdev->lock;
+	bool must_lock = !test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags) && vdev->lock;
+	int err = -EBUSY;
+
+	if (must_lock && mutex_lock_interruptible(lock))
+		return -ERESTARTSYS;
+	if (vb2_queue_is_busy(vdev, file))
+		goto exit;
+	err = vb2_read(vdev->queue, buf, count, ppos,
+		       file->f_flags & O_NONBLOCK);
+	if (err >= 0)
+		vdev->queue_owner = file->private_data;
+exit:
+	if (must_lock)
+		mutex_unlock(lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_read);
+
+unsigned int vb2_fop_poll(struct file *file, poll_table *wait)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct vb2_queue *q = vdev->queue;
+	struct mutex *lock = vdev->queue_lock ? vdev->queue_lock : vdev->lock;
+	unsigned res;
+	unsigned long req_events = poll_requested_events(wait);
+	void *fileio = q->fileio;
+	bool must_lock = false;
+
+	if (lock && q && q->num_buffers == 0 && fileio == NULL &&
+			!test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags)) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM)))
+			must_lock = true;
+		else if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM)))
+			must_lock = true;
+	}
+
+	if (must_lock && mutex_lock_interruptible(lock))
+		return POLLERR;
+
+	res = vb2_poll(vdev->queue, file, wait);
+	if (!fileio && vdev->queue->fileio)
+		vdev->queue_owner = file->private_data;
+	if (must_lock)
+		mutex_unlock(lock);
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_poll);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a15d1f1..4b1c8d3 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -404,4 +404,23 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 	return 0;
 }
 
+int vb2_ioctl_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *p);
+int vb2_ioctl_create_bufs(struct file *file, void *priv,
+			  struct v4l2_create_buffers *p);
+int vb2_ioctl_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_buffer *p);
+int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
+int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma);
+int vb2_fop_release(struct file *file);
+ssize_t vb2_fop_write(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos);
+ssize_t vb2_fop_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos);
+unsigned int vb2_fop_poll(struct file *file, poll_table *wait);
+
 #endif /* _MEDIA_VIDEOBUF2_CORE_H */
-- 
1.7.10


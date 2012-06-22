Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1623 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761573Ab2FVMVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 27/34] videobuf2-core: add helper functions.
Date: Fri, 22 Jun 2012 14:21:21 +0200
Message-Id: <a538431d6717db3fb47f1b4428379a5196346cd3.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add helper functions to make it easier to adapt drivers to vb2.

These helpers take care of core locking and check if the filehandle is the
owner of the queue.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/videobuf2-core.c |  227 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-core.h       |   32 +++++
 2 files changed, 259 insertions(+)

diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index bfcacaa..d5ff802 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -2124,6 +2124,233 @@ size_t vb2_write(struct vb2_queue *q, char __user *data, size_t count,
 }
 EXPORT_SYMBOL_GPL(vb2_write);
 
+
+/*
+ * The following functions are not part of the vb2 core API, but are helper
+ * functions that plug into struct v4l2_ioctl_ops and struct v4l2_file_operations.
+ * They contain boilerplate code that most if not all drivers have to do
+ * and so they simplify the driver code.
+ */
+
+/* The queue is busy if there is a owner and you are not that owner. */
+static inline bool vb2_queue_is_busy(struct video_device *vdev, struct file *file)
+{
+	return vdev->queue->owner && vdev->queue->owner != file->private_data;
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
+	/* If count == 0, then the owner has released all buffers and he
+	   is no longer owner of the queue. Otherwise we have a new owner. */
+	if (res == 0)
+		vdev->queue->owner = p->count ? file->private_data : NULL;
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
+	/* If count == 0, then just check if memory and type are valid.
+	   Any -EBUSY result from __verify_memory_type can be mapped to 0. */
+	if (p->count == 0)
+		return res != -EBUSY ? res : 0;
+	if (res)
+		return res;
+	if (vb2_queue_is_busy(vdev, file))
+		return -EBUSY;
+	res = __create_bufs(vdev->queue, p);
+	if (res == 0)
+		vdev->queue->owner = file->private_data;
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
+	/* No need to call vb2_queue_is_busy(), anyone can query buffers. */
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
+	if (file->private_data == vdev->queue->owner) {
+		vb2_queue_release(vdev->queue);
+		vdev->queue->owner = NULL;
+	}
+	return v4l2_fh_release(file);
+}
+EXPORT_SYMBOL_GPL(vb2_fop_release);
+
+ssize_t vb2_fop_write(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
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
+		vdev->queue->owner = file->private_data;
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
+	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
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
+		vdev->queue->owner = file->private_data;
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
+	struct mutex *lock = q->lock ? q->lock : vdev->lock;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned res;
+	void *fileio;
+	/* Yuck. We really need to get rid of this flag asap. If it is
+	   set, then the core took the serialization lock before calling
+	   poll(). This is being phased out, but for now we have to handle
+	   this case. */
+	bool locked = test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
+	bool must_lock = false;
+
+	/* Try to be smart: only lock if polling might start fileio,
+	   otherwise locking will only introduce unwanted delays. */
+	if (q->num_buffers == 0 && q->fileio == NULL) {
+		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ) &&
+				(req_events & (POLLIN | POLLRDNORM)))
+			must_lock = true;
+		else if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE) &&
+				(req_events & (POLLOUT | POLLWRNORM)))
+			must_lock = true;
+	}
+
+	/* If locking is needed, but this helper doesn't know how, then you
+	   shouldn't be using this helper but you should write your own. */
+	WARN_ON(must_lock && !locked && !lock);
+
+	if (must_lock && !locked && lock && mutex_lock_interruptible(lock))
+		return POLLERR;
+
+	fileio = q->fileio;
+
+	res = vb2_poll(vdev->queue, file, wait);
+
+	/* If fileio was started, then we have a new queue owner. */
+	if (must_lock && !fileio && q->fileio)
+		q->owner = file->private_data;
+	if (must_lock && !locked && lock)
+		mutex_unlock(lock);
+	return res;
+}
+EXPORT_SYMBOL_GPL(vb2_fop_poll);
+
 MODULE_DESCRIPTION("Driver helper framework for Video for Linux 2");
 MODULE_AUTHOR("Pawel Osciak <pawel@osciak.com>, Marek Szyprowski");
 MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 924e95e..5ca3212 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -417,4 +417,36 @@ vb2_plane_size(struct vb2_buffer *vb, unsigned int plane_no)
 	return 0;
 }
 
+/*
+ * The following functions are not part of the vb2 core API, but are simple
+ * helper functions that you can use in your struct v4l2_file_operations and
+ * struct v4l2_ioctl_ops. They will serialize if vb2_queue->lock or
+ * video_device->lock is set, and they will set and test vb2_queue->owner
+ * to check if the calling filehandle is permitted to do the queuing operation.
+ */
+
+/* struct v4l2_ioctl_ops helpers */
+
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
+
+/* struct v4l2_file_operations helpers */
+
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


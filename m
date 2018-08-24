Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:39543 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726730AbeHXLzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 07:55:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 5/5] vb2: set reqbufs/create_bufs capabilities
Date: Fri, 24 Aug 2018 10:21:56 +0200
Message-Id: <20180824082156.6986-6-hverkuil@xs4all.nl>
In-Reply-To: <20180824082156.6986-1-hverkuil@xs4all.nl>
References: <20180824082156.6986-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Set the capabilities field of v4l2_requestbuffers and v4l2_create_buffers.

The various mapping modes were easy, but for signaling the request capability
a new 'supports_requests' bitfield was added to videobuf2-core.h (and set in
vim2m and vivid). Drivers have to set this bitfield for any queue where
requests are supported.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 .../media/common/videobuf2/videobuf2-v4l2.c   | 19 ++++++++++++++++++-
 drivers/media/platform/vim2m.c                |  1 +
 drivers/media/platform/vivid/vivid-core.c     |  5 +++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  4 +++-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  4 ++--
 include/media/videobuf2-core.h                |  2 ++
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index a70df16d68f1..2caaabd50532 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -384,7 +384,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			return -EPERM;
 		}
 		return 0;
-	} else if (q->uses_qbuf) {
+	} else if (q->uses_qbuf || !q->supports_requests) {
 		dprintk(1, "%s: queue does not use requests\n", opname);
 		return -EPERM;
 	}
@@ -619,10 +619,24 @@ int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL(vb2_querybuf);
 
+static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
+{
+	*caps = 0;
+	if (q->io_modes & VB2_MMAP)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_MMAP;
+	if (q->io_modes & VB2_USERPTR)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_USERPTR;
+	if (q->io_modes & VB2_DMABUF)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_DMABUF;
+	if (q->supports_requests)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
+}
+
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	int ret = vb2_verify_memory_type(q, req->memory, req->type);
 
+	fill_buf_caps(q, &req->capabilities);
 	return ret ? ret : vb2_core_reqbufs(q, req->memory, &req->count);
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
@@ -654,6 +668,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	int ret = vb2_verify_memory_type(q, create->memory, f->type);
 	unsigned i;
 
+	fill_buf_caps(q, &create->capabilities);
 	create->index = q->num_buffers;
 	if (create->count == 0)
 		return ret != -EBUSY ? ret : 0;
@@ -861,6 +876,7 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
 
+	fill_buf_caps(vdev->queue, &p->capabilities);
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
@@ -882,6 +898,7 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			p->format.type);
 
 	p->index = vdev->queue->num_buffers;
+	fill_buf_caps(vdev->queue, &p->capabilities);
 	/*
 	 * If count == 0, then just check if memory and type are valid.
 	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 5423f0dd0821..40fbb1e429af 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -855,6 +855,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *ds
 	src_vq->mem_ops = &vb2_vmalloc_memops;
 	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	src_vq->lock = &ctx->dev->dev_mutex;
+	src_vq->supports_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 3f6f5cbe1b60..e7f1394832fe 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1077,6 +1077,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->supports_requests = true;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1097,6 +1098,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->supports_requests = true;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1117,6 +1119,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->supports_requests = true;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1137,6 +1140,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->supports_requests = true;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1156,6 +1160,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
 		q->dev = dev->v4l2_dev.dev;
+		q->supports_requests = true;
 
 		ret = vb2_queue_init(q);
 		if (ret)
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 633465d21d04..0028e0be6b5b 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -251,7 +251,8 @@ struct v4l2_create_buffers32 {
 	__u32			count;
 	__u32			memory;	/* enum v4l2_memory */
 	struct v4l2_format32	format;
-	__u32			reserved[8];
+	__u32			capabilities;
+	__u32			reserved[7];
 };
 
 static int __bufsize_v4l2_format(struct v4l2_format32 __user *p32, u32 *size)
@@ -411,6 +412,7 @@ static int put_v4l2_create32(struct v4l2_create_buffers __user *p64,
 	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
 	    copy_in_user(p32, p64,
 			 offsetof(struct v4l2_create_buffers32, format)) ||
+	    assign_in_user(&p32->capabilities, &p64->capabilities) ||
 	    copy_in_user(p32->reserved, p64->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 	return __put_v4l2_format32(&p64->format, &p32->format);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 2a84ca9e328a..87dba0b9c0a7 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1877,7 +1877,7 @@ static int v4l_reqbufs(const struct v4l2_ioctl_ops *ops,
 	if (ret)
 		return ret;
 
-	CLEAR_AFTER_FIELD(p, memory);
+	CLEAR_AFTER_FIELD(p, capabilities);
 
 	return ops->vidioc_reqbufs(file, fh, p);
 }
@@ -1918,7 +1918,7 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 	if (ret)
 		return ret;
 
-	CLEAR_AFTER_FIELD(create, format);
+	CLEAR_AFTER_FIELD(create, capabilities);
 
 	v4l_sanitize_format(&create->format);
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 881f53b38b26..6c76b9802589 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -472,6 +472,7 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %EPOLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @supports_requests: this queue supports the Request API.
  * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
  *		time this is called. Set to 0 when the queue is canceled.
  *		If this is 1, then you cannot queue buffers from a request.
@@ -545,6 +546,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			supports_requests:1;
 	unsigned			uses_qbuf:1;
 	unsigned			uses_requests:1;
 
-- 
2.18.0

Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:56984 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752127AbdJZJLz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 05:11:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] v4l2: add extended streaming operations
Date: Thu, 26 Oct 2017 11:11:48 +0200
Message-Id: <20171026091149.29606-2-hverkuil@xs4all.nl>
In-Reply-To: <20171026091149.29606-1-hverkuil@xs4all.nl>
References: <20171026091149.29606-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

For year 2038 and to simplify multiplanar formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-common.c    |  72 +++++++
 drivers/media/v4l2-core/v4l2-dev.c       |   4 +
 drivers/media/v4l2-core/v4l2-ioctl.c     | 146 +++++++++++++-
 drivers/media/v4l2-core/v4l2-mem2mem.c   |  97 +++++++++
 drivers/media/v4l2-core/videobuf2-v4l2.c | 332 +++++++++++++++----------------
 include/media/v4l2-common.h              |   5 +
 include/media/v4l2-ioctl.h               |  17 ++
 include/media/v4l2-mem2mem.h             |   8 +
 include/media/videobuf2-v4l2.h           |   9 +
 include/uapi/linux/videodev2.h           |  47 +++++
 10 files changed, 557 insertions(+), 180 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index a5ea1f517291..9faa77566a32 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -405,3 +405,75 @@ void v4l2_get_timestamp(struct timeval *tv)
 	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
 }
 EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
+
+void v4l2_ext_buffer_to_buffer(const struct v4l2_ext_buffer *e,
+			       struct v4l2_buffer *b)
+{
+	u64 nsecs;
+
+	b->index = e->index;
+	b->type = e->type;
+	b->flags = e->flags;
+	b->field = e->field;
+	b->sequence = e->sequence;
+	b->memory = e->memory;
+	b->timestamp.tv_sec = div64_u64_rem(e->timestamp, NSEC_PER_SEC, &nsecs);
+	b->timestamp.tv_usec = (u32)nsecs / NSEC_PER_USEC;
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		unsigned int i;
+
+		b->length = e->num_planes;
+		for (i = 0; i < e->num_planes; i++) {
+			b->m.planes[i].length = e->planes[i].length;
+			b->m.planes[i].bytesused = e->planes[i].bytesused;
+			b->m.planes[i].m.userptr = e->planes[i].m.userptr;
+			b->m.planes[i].data_offset = e->planes[i].data_offset;
+			memset(b->m.planes[i].reserved, 0,
+			       sizeof(b->m.planes[i].reserved));
+		}
+	} else {
+		b->bytesused = e->planes[0].bytesused;
+		b->length = e->planes[0].length;
+		b->m.userptr = e->planes[0].m.userptr;
+	}
+	b->reserved2 = b->reserved = 0;
+	memset(&b->timecode, 0, sizeof(b->timecode));
+}
+EXPORT_SYMBOL_GPL(v4l2_ext_buffer_to_buffer);
+
+int v4l2_buffer_to_ext_buffer(const struct v4l2_buffer *b,
+			      struct v4l2_ext_buffer *e)
+{
+	e->index = b->index;
+	e->type = b->type;
+	e->flags = b->flags;
+	e->field = b->field;
+	e->sequence = b->sequence;
+	e->memory = b->memory;
+	e->timestamp = b->timestamp.tv_sec * NSEC_PER_SEC +
+		b->timestamp.tv_usec * NSEC_PER_USEC;
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		unsigned int i;
+
+		if (b->m.planes == NULL)
+			return -EINVAL;
+		e->num_planes = b->length;
+		for (i = 0; i < e->num_planes; i++) {
+			e->planes[i].length = b->m.planes[i].length;
+			e->planes[i].bytesused = b->m.planes[i].bytesused;
+			e->planes[i].m.userptr = b->m.planes[i].m.userptr;
+			e->planes[i].data_offset = b->m.planes[i].data_offset;
+			memset(e->planes[i].reserved, 0,
+			       sizeof(e->planes[i].reserved));
+		}
+	} else {
+		e->num_planes = 1;
+		e->planes[0].bytesused = b->bytesused;
+		e->planes[0].length = b->length;
+		e->planes[0].m.userptr = b->m.userptr;
+		e->planes[0].data_offset = 0;
+	}
+	memset(&e->reserved, 0, sizeof(e->reserved));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_buffer_to_ext_buffer);
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index c647ba648805..1ce80636453b 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -678,6 +678,10 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_QUERYBUF, vidioc_ext_querybuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_QBUF, vidioc_ext_qbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_DQBUF, vidioc_ext_dqbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_PREPARE_BUF, vidioc_ext_prepare_buf);
 	}
 
 	if (is_vid || is_vbi || is_tch) {
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 79614992ee21..b014904ec3bc 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -466,6 +466,28 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
+static void v4l_print_ext_buffer(const void *arg, bool write_only)
+{
+	const struct v4l2_ext_buffer *p = arg;
+	const struct v4l2_ext_plane *plane;
+	int i;
+
+	pr_cont("%lld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s\n",
+			p->timestamp,
+			p->index,
+			prt_names(p->type, v4l2_type_names),
+			p->flags, prt_names(p->field, v4l2_field_names),
+			p->sequence, prt_names(p->memory, v4l2_memory_names));
+
+	for (i = 0; i < p->num_planes; ++i) {
+		plane = &p->planes[i];
+		printk(KERN_DEBUG
+			"plane %d: bytesused=%d, data_offset=0x%08x, offset/userptr=0x%llx, length=%d\n",
+			i, plane->bytesused, plane->data_offset,
+			plane->m.userptr, plane->length);
+	}
+}
+
 static void v4l_print_exportbuffer(const void *arg, bool write_only)
 {
 	const struct v4l2_exportbuffer *p = arg;
@@ -1897,27 +1919,51 @@ static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
+	struct v4l2_ext_buffer e;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_querybuf(file, fh, p);
+	if (ret || ops->vidioc_querybuf)
+		return ret ? ret : ops->vidioc_querybuf(file, fh, p);
+
+	v4l2_buffer_to_ext_buffer(p, &e);
+	ret = ops->vidioc_ext_querybuf(file, fh, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, p);
+	return ret;
 }
 
 static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
+	struct v4l2_ext_buffer e;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
+	if (ret || ops->vidioc_qbuf)
+		return ret ? ret : ops->vidioc_qbuf(file, fh, p);
+
+	v4l2_buffer_to_ext_buffer(p, &e);
+	ret = ops->vidioc_ext_qbuf(file, fh, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, p);
+	return ret;
 }
 
 static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *p = arg;
+	struct v4l2_ext_buffer e;
 	int ret = check_fmt(file, p->type);
 
-	return ret ? ret : ops->vidioc_dqbuf(file, fh, p);
+	if (ret || ops->vidioc_dqbuf)
+		return ret ? ret : ops->vidioc_dqbuf(file, fh, p);
+
+	v4l2_buffer_to_ext_buffer(p, &e);
+	ret = ops->vidioc_ext_dqbuf(file, fh, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, p);
+	return ret;
 }
 
 static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
@@ -1946,9 +1992,17 @@ static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_buffer *b = arg;
+	struct v4l2_ext_buffer e;
 	int ret = check_fmt(file, b->type);
 
-	return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
+	if (ret || ops->vidioc_prepare_buf)
+		return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
+
+	v4l2_buffer_to_ext_buffer(b, &e);
+	ret = ops->vidioc_ext_prepare_buf(file, fh, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, b);
+	return ret;
 }
 
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
@@ -2511,6 +2565,86 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	return -ENOTTY;
 }
 
+static int v4l_ext_prepare_buf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_ext_buffer *e = arg;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer b = {
+		.m.planes = planes,
+	};
+	int ret = check_fmt(file, e->type);
+
+	if (ret || ops->vidioc_ext_prepare_buf)
+		return ret ? ret : ops->vidioc_ext_prepare_buf(file, fh, e);
+
+	v4l2_ext_buffer_to_buffer(e, &b);
+	ret = ops->vidioc_prepare_buf(file, fh, &b);
+	if (!ret)
+		v4l2_buffer_to_ext_buffer(&b, e);
+	return ret;
+}
+
+static int v4l_ext_querybuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_ext_buffer *e = arg;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer b = {
+		.m.planes = planes,
+	};
+	int ret = check_fmt(file, e->type);
+
+	if (ret || ops->vidioc_ext_querybuf)
+		return ret ? ret : ops->vidioc_ext_querybuf(file, fh, e);
+
+	v4l2_ext_buffer_to_buffer(e, &b);
+	ret = ops->vidioc_querybuf(file, fh, &b);
+	if (!ret)
+		v4l2_buffer_to_ext_buffer(&b, e);
+	return ret;
+}
+
+static int v4l_ext_qbuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_ext_buffer *e = arg;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer b = {
+		.m.planes = planes,
+	};
+	int ret = check_fmt(file, e->type);
+
+	if (ret || ops->vidioc_ext_qbuf)
+		return ret ? ret : ops->vidioc_ext_qbuf(file, fh, e);
+
+	v4l2_ext_buffer_to_buffer(e, &b);
+	ret = ops->vidioc_qbuf(file, fh, &b);
+	if (!ret)
+		v4l2_buffer_to_ext_buffer(&b, e);
+	return ret;
+}
+
+static int v4l_ext_dqbuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_ext_buffer *e = arg;
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer b = {
+		.m.planes = planes,
+	};
+	int ret = check_fmt(file, e->type);
+
+	if (ret || ops->vidioc_ext_dqbuf)
+		return ret ? ret : ops->vidioc_ext_dqbuf(file, fh, e);
+
+	v4l2_ext_buffer_to_buffer(e, &b);
+	ret = ops->vidioc_dqbuf(file, fh, &b);
+	if (!ret)
+		v4l2_buffer_to_ext_buffer(&b, e);
+	return ret;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -2642,6 +2776,10 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO_FNC(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
 	IOCTL_INFO_FNC(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
+	IOCTL_INFO_FNC(VIDIOC_EXT_QUERYBUF, v4l_ext_querybuf, v4l_print_ext_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_ext_buffer, num_planes)),
+	IOCTL_INFO_FNC(VIDIOC_EXT_QBUF, v4l_ext_qbuf, v4l_print_ext_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_EXT_DQBUF, v4l_ext_dqbuf, v4l_print_ext_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO_FNC(VIDIOC_EXT_PREPARE_BUF, v4l_ext_prepare_buf, v4l_print_ext_buffer, INFO_FL_QUEUE),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index f62e68aa04c4..fe9a7f982085 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -423,6 +423,67 @@ int v4l2_m2m_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 
+int v4l2_m2m_ext_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_ext_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret = 0;
+	unsigned int i;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_ext_querybuf(vq, buf);
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
+		for (i = 0; i < buf->num_planes; ++i)
+			buf->planes[i].m.mem_offset
+					+= DST_QUEUE_OFF_BASE;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ext_querybuf);
+
+int v4l2_m2m_ext_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		  struct v4l2_ext_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_ext_qbuf(vq, buf);
+	if (!ret)
+		v4l2_m2m_try_schedule(m2m_ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ext_qbuf);
+
+int v4l2_m2m_ext_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		   struct v4l2_ext_buffer *buf)
+{
+	struct vb2_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	return vb2_ext_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ext_dqbuf);
+
+int v4l2_m2m_ext_prepare_buf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct v4l2_ext_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_ext_prepare_buf(vq, buf);
+	if (!ret)
+		v4l2_m2m_try_schedule(m2m_ctx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ext_prepare_buf);
+
 int v4l2_m2m_create_bufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 			 struct v4l2_create_buffers *create)
 {
@@ -752,6 +813,42 @@ int v4l2_m2m_ioctl_prepare_buf(struct file *file, void *priv,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_prepare_buf);
 
+int v4l2_m2m_ioctl_ext_querybuf(struct file *file, void *priv,
+				struct v4l2_ext_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_ext_querybuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_ext_querybuf);
+
+int v4l2_m2m_ioctl_ext_qbuf(struct file *file, void *priv,
+				struct v4l2_ext_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_ext_qbuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_ext_qbuf);
+
+int v4l2_m2m_ioctl_ext_dqbuf(struct file *file, void *priv,
+				struct v4l2_ext_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_ext_dqbuf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_ext_dqbuf);
+
+int v4l2_m2m_ioctl_ext_prepare_buf(struct file *file, void *priv,
+			       struct v4l2_ext_buffer *buf)
+{
+	struct v4l2_fh *fh = file->private_data;
+
+	return v4l2_m2m_ext_prepare_buf(file, fh->m2m_ctx, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_ext_prepare_buf);
+
 int v4l2_m2m_ioctl_expbuf(struct file *file, void *priv,
 				struct v4l2_exportbuffer *eb)
 {
diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 0c0669976bdc..34ff016d34ee 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -51,22 +51,16 @@ module_param(debug, int, 0644);
 
 /**
  * __verify_planes_array() - verify that the planes array passed in struct
- * v4l2_buffer from userspace can be safely used
+ * v4l2_ext_buffer from userspace can be safely used
  */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_ext_buffer *b)
 {
 	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
 		return 0;
 
-	/* Is memory for copying plane information present? */
-	if (b->m.planes == NULL) {
-		dprintk(1, "multi-planar buffer passed but planes array not provided\n");
-		return -EINVAL;
-	}
-
-	if (b->length < vb->num_planes || b->length > VB2_MAX_PLANES) {
+	if (b->num_planes < vb->num_planes || b->num_planes > VB2_MAX_PLANES) {
 		dprintk(1, "incorrect planes array length, expected %d, got %d\n",
-			vb->num_planes, b->length);
+			vb->num_planes, b->num_planes);
 		return -EINVAL;
 	}
 
@@ -82,7 +76,7 @@ static int __verify_planes_array_core(struct vb2_buffer *vb, const void *pb)
  * __verify_length() - Verify that the bytesused value for each plane fits in
  * the plane length and that the data offset doesn't exceed the bytesused value.
  */
-static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_length(struct vb2_buffer *vb, const struct v4l2_ext_buffer *b)
 {
 	unsigned int length;
 	unsigned int bytesused;
@@ -91,27 +85,19 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	if (!V4L2_TYPE_IS_OUTPUT(b->type))
 		return 0;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			length = (b->memory == VB2_MEMORY_USERPTR ||
-				  b->memory == VB2_MEMORY_DMABUF)
-			       ? b->m.planes[plane].length
-				: vb->planes[plane].length;
-			bytesused = b->m.planes[plane].bytesused
-				  ? b->m.planes[plane].bytesused : length;
-
-			if (b->m.planes[plane].bytesused > length)
-				return -EINVAL;
-
-			if (b->m.planes[plane].data_offset > 0 &&
-			    b->m.planes[plane].data_offset >= bytesused)
-				return -EINVAL;
-		}
-	} else {
-		length = (b->memory == VB2_MEMORY_USERPTR)
-			? b->length : vb->planes[0].length;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		length = (b->memory == VB2_MEMORY_USERPTR ||
+			  b->memory == VB2_MEMORY_DMABUF)
+		       ? b->planes[plane].length
+			: vb->planes[plane].length;
+		bytesused = b->planes[plane].bytesused
+			  ? b->planes[plane].bytesused : length;
 
-		if (b->bytesused > length)
+		if (b->planes[plane].bytesused > length)
+			return -EINVAL;
+
+		if (b->planes[plane].data_offset > 0 &&
+		    b->planes[plane].data_offset >= bytesused)
 			return -EINVAL;
 	}
 
@@ -120,8 +106,7 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 
 static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 {
-	const struct v4l2_buffer *b = pb;
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	const struct v4l2_ext_buffer *b = pb;
 	struct vb2_queue *q = vb->vb2_queue;
 
 	if (q->is_output) {
@@ -130,10 +115,7 @@ static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
 		 * and the timecode field and flag if needed.
 		 */
 		if (q->copy_timestamp)
-			vb->timestamp = timeval_to_ns(&b->timestamp);
-		vbuf->flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
-		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
-			vbuf->timecode = b->timecode;
+			vb->timestamp = b->timestamp;
 	}
 };
 
@@ -154,7 +136,7 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
 		pr_warn("use the actual size instead.\n");
 }
 
-static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
+static int vb2_queue_or_ext_prepare_buf(struct vb2_queue *q, struct v4l2_ext_buffer *b,
 				    const char *opname)
 {
 	if (b->type != q->type) {
@@ -187,7 +169,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
  */
 static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 {
-	struct v4l2_buffer *b = pb;
+	struct v4l2_ext_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
@@ -196,50 +178,23 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	b->index = vb->index;
 	b->type = vb->type;
 	b->memory = vb->memory;
-	b->bytesused = 0;
 
 	b->flags = vbuf->flags;
 	b->field = vbuf->field;
-	b->timestamp = ns_to_timeval(vb->timestamp);
-	b->timecode = vbuf->timecode;
+	b->timestamp = vb->timestamp;
 	b->sequence = vbuf->sequence;
-	b->reserved2 = 0;
-	b->reserved = 0;
+	memset(b->reserved, 0, sizeof(b->reserved));
 
-	if (q->is_multiplanar) {
-		/*
-		 * Fill in plane-related data if userspace provided an array
-		 * for it. The caller has already verified memory and size.
-		 */
-		b->length = vb->num_planes;
-		for (plane = 0; plane < vb->num_planes; ++plane) {
-			struct v4l2_plane *pdst = &b->m.planes[plane];
-			struct vb2_plane *psrc = &vb->planes[plane];
-
-			pdst->bytesused = psrc->bytesused;
-			pdst->length = psrc->length;
-			if (q->memory == VB2_MEMORY_MMAP)
-				pdst->m.mem_offset = psrc->m.offset;
-			else if (q->memory == VB2_MEMORY_USERPTR)
-				pdst->m.userptr = psrc->m.userptr;
-			else if (q->memory == VB2_MEMORY_DMABUF)
-				pdst->m.fd = psrc->m.fd;
-			pdst->data_offset = psrc->data_offset;
-			memset(pdst->reserved, 0, sizeof(pdst->reserved));
-		}
-	} else {
-		/*
-		 * We use length and offset in v4l2_planes array even for
-		 * single-planar buffers, but userspace does not.
-		 */
-		b->length = vb->planes[0].length;
-		b->bytesused = vb->planes[0].bytesused;
-		if (q->memory == VB2_MEMORY_MMAP)
-			b->m.offset = vb->planes[0].m.offset;
-		else if (q->memory == VB2_MEMORY_USERPTR)
-			b->m.userptr = vb->planes[0].m.userptr;
-		else if (q->memory == VB2_MEMORY_DMABUF)
-			b->m.fd = vb->planes[0].m.fd;
+	/*
+	 * Fill in plane-related data if userspace provided an array
+	 * for it. The caller has already verified memory and size.
+	 */
+	b->num_planes = vb->num_planes;
+	for (plane = 0; plane < vb->num_planes; ++plane) {
+		b->planes[plane].bytesused = vb->planes[plane].bytesused;
+		b->planes[plane].length = vb->planes[plane].length;
+		b->planes[plane].data_offset = vb->planes[plane].data_offset;
+		b->planes[plane].m.userptr = vb->planes[plane].m.userptr;
 	}
 
 	/*
@@ -295,7 +250,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		const void *pb, struct vb2_plane *planes)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	const struct v4l2_buffer *b = pb;
+	const struct v4l2_ext_buffer *b = pb;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	unsigned int plane;
 	int ret;
@@ -321,94 +276,55 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 	vb->timestamp = 0;
 	vbuf->sequence = 0;
 
-	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
-		if (b->memory == VB2_MEMORY_USERPTR) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				planes[plane].m.userptr =
-					b->m.planes[plane].m.userptr;
-				planes[plane].length =
-					b->m.planes[plane].length;
-			}
+	if (b->memory == VB2_MEMORY_USERPTR) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			planes[plane].m.userptr =
+				b->planes[plane].m.userptr;
+			planes[plane].length =
+				b->planes[plane].length;
 		}
-		if (b->memory == VB2_MEMORY_DMABUF) {
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				planes[plane].m.fd =
-					b->m.planes[plane].m.fd;
-				planes[plane].length =
-					b->m.planes[plane].length;
-			}
+	}
+	if (b->memory == VB2_MEMORY_DMABUF) {
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			planes[plane].m.fd =
+				b->planes[plane].m.fd;
+			planes[plane].length =
+				b->planes[plane].length;
 		}
+	}
 
-		/* Fill in driver-provided information for OUTPUT types */
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			/*
-			 * Will have to go up to b->length when API starts
-			 * accepting variable number of planes.
-			 *
-			 * If bytesused == 0 for the output buffer, then fall
-			 * back to the full buffer size. In that case
-			 * userspace clearly never bothered to set it and
-			 * it's a safe assumption that they really meant to
-			 * use the full plane sizes.
-			 *
-			 * Some drivers, e.g. old codec drivers, use bytesused == 0
-			 * as a way to indicate that streaming is finished.
-			 * In that case, the driver should use the
-			 * allow_zero_bytesused flag to keep old userspace
-			 * applications working.
-			 */
-			for (plane = 0; plane < vb->num_planes; ++plane) {
-				struct vb2_plane *pdst = &planes[plane];
-				struct v4l2_plane *psrc = &b->m.planes[plane];
-
-				if (psrc->bytesused == 0)
-					vb2_warn_zero_bytesused(vb);
-
-				if (vb->vb2_queue->allow_zero_bytesused)
-					pdst->bytesused = psrc->bytesused;
-				else
-					pdst->bytesused = psrc->bytesused ?
-						psrc->bytesused : pdst->length;
-				pdst->data_offset = psrc->data_offset;
-			}
-		}
-	} else {
+	/* Fill in driver-provided information for OUTPUT types */
+	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
-		 * Single-planar buffers do not use planes array,
-		 * so fill in relevant v4l2_buffer struct fields instead.
-		 * In videobuf we use our internal V4l2_planes struct for
-		 * single-planar buffers as well, for simplicity.
+		 * Will have to go up to b->length when API starts
+		 * accepting variable number of planes.
 		 *
-		 * If bytesused == 0 for the output buffer, then fall back
-		 * to the full buffer size as that's a sensible default.
+		 * If bytesused == 0 for the output buffer, then fall
+		 * back to the full buffer size. In that case
+		 * userspace clearly never bothered to set it and
+		 * it's a safe assumption that they really meant to
+		 * use the full plane sizes.
 		 *
-		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
-		 * a way to indicate that streaming is finished. In that case,
-		 * the driver should use the allow_zero_bytesused flag to keep
-		 * old userspace applications working.
+		 * Some drivers, e.g. old codec drivers, use bytesused == 0
+		 * as a way to indicate that streaming is finished.
+		 * In that case, the driver should use the
+		 * allow_zero_bytesused flag to keep old userspace
+		 * applications working.
 		 */
-		if (b->memory == VB2_MEMORY_USERPTR) {
-			planes[0].m.userptr = b->m.userptr;
-			planes[0].length = b->length;
-		}
-
-		if (b->memory == VB2_MEMORY_DMABUF) {
-			planes[0].m.fd = b->m.fd;
-			planes[0].length = b->length;
-		}
+		for (plane = 0; plane < vb->num_planes; ++plane) {
+			struct vb2_plane *pdst = &planes[plane];
+			const struct v4l2_ext_plane *psrc = &b->planes[plane];
 
-		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
-			if (b->bytesused == 0)
+			if (psrc->bytesused == 0)
 				vb2_warn_zero_bytesused(vb);
 
 			if (vb->vb2_queue->allow_zero_bytesused)
-				planes[0].bytesused = b->bytesused;
+				pdst->bytesused = psrc->bytesused;
 			else
-				planes[0].bytesused = b->bytesused ?
-					b->bytesused : planes[0].length;
-		} else
-			planes[0].bytesused = 0;
-
+				pdst->bytesused = psrc->bytesused ?
+					psrc->bytesused : pdst->length;
+			pdst->data_offset = psrc->data_offset;
+		}
 	}
 
 	/* Zero flags that the vb2 core handles */
@@ -422,14 +338,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
 		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 	}
 
+	vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
-		 * For output buffers mask out the timecode flag:
-		 * this will be handled later in vb2_qbuf().
 		 * The 'field' is valid metadata for this output buffer
 		 * and so that needs to be copied here.
 		 */
-		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
 		vbuf->field = b->field;
 	} else {
 		/* Zero any output buffer flags as this is a capture buffer */
@@ -446,6 +360,38 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
 	.copy_timestamp		= __copy_timestamp,
 };
 
+int vb2_ext_querybuf(struct vb2_queue *q, struct v4l2_ext_buffer *b)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	if (b->type != q->type) {
+		dprintk(1, "wrong buffer type\n");
+		return -EINVAL;
+	}
+
+	if (b->index >= q->num_buffers) {
+		dprintk(1, "buffer index out of range\n");
+		return -EINVAL;
+	}
+	vb = q->bufs[b->index];
+	ret = __verify_planes_array(vb, b);
+	if (!ret)
+		vb2_core_querybuf(q, b->index, b);
+	return ret;
+}
+EXPORT_SYMBOL(vb2_ext_querybuf);
+
+static int __buffer_to_ext_buffer(const struct v4l2_buffer *b,
+				  struct v4l2_ext_buffer *e)
+{
+	int ret = v4l2_buffer_to_ext_buffer(b, e);
+
+	if (ret)
+		dprintk(1, "multi-planar buffer passed but planes array not provided\n");
+	return ret;
+}
+
 /**
  * vb2_querybuf() - query video buffer information
  * @q:		videobuf queue
@@ -461,22 +407,14 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
  */
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b)
 {
-	struct vb2_buffer *vb;
+	struct v4l2_ext_buffer e;
 	int ret;
 
-	if (b->type != q->type) {
-		dprintk(1, "wrong buffer type\n");
-		return -EINVAL;
-	}
-
-	if (b->index >= q->num_buffers) {
-		dprintk(1, "buffer index out of range\n");
-		return -EINVAL;
-	}
-	vb = q->bufs[b->index];
-	ret = __verify_planes_array(vb, b);
+	ret = __buffer_to_ext_buffer(b, &e);
 	if (!ret)
-		vb2_core_querybuf(q, b->index, b);
+		ret = vb2_ext_querybuf(q, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, b);
 	return ret;
 }
 EXPORT_SYMBOL(vb2_querybuf);
@@ -489,7 +427,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 }
 EXPORT_SYMBOL_GPL(vb2_reqbufs);
 
-int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_ext_prepare_buf(struct vb2_queue *q, struct v4l2_ext_buffer *b)
 {
 	int ret;
 
@@ -498,10 +436,24 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	ret = vb2_queue_or_prepare_buf(q, b, "prepare_buf");
+	ret = vb2_queue_or_ext_prepare_buf(q, b, "ext_prepare_buf");
 
 	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
 }
+EXPORT_SYMBOL_GPL(vb2_ext_prepare_buf);
+
+int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	struct v4l2_ext_buffer e;
+	int ret;
+
+	ret = __buffer_to_ext_buffer(b, &e);
+	if (!ret)
+		ret = vb2_ext_prepare_buf(q, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, b);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(vb2_prepare_buf);
 
 int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
@@ -558,7 +510,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 }
 EXPORT_SYMBOL_GPL(vb2_create_bufs);
 
-int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+int vb2_ext_qbuf(struct vb2_queue *q, struct v4l2_ext_buffer *b)
 {
 	int ret;
 
@@ -567,12 +519,26 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		return -EBUSY;
 	}
 
-	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
+	ret = vb2_queue_or_ext_prepare_buf(q, b, "qbuf");
 	return ret ? ret : vb2_core_qbuf(q, b->index, b);
 }
+EXPORT_SYMBOL_GPL(vb2_ext_qbuf);
+
+int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
+{
+	struct v4l2_ext_buffer e;
+	int ret;
+
+	ret = __buffer_to_ext_buffer(b, &e);
+	if (!ret)
+		ret = vb2_ext_qbuf(q, &e);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, b);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
-int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+int vb2_ext_dqbuf(struct vb2_queue *q, struct v4l2_ext_buffer *b, bool nonblocking)
 {
 	int ret;
 
@@ -596,6 +562,20 @@ int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vb2_ext_dqbuf);
+
+int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking)
+{
+	struct v4l2_ext_buffer e;
+	int ret;
+
+	ret = __buffer_to_ext_buffer(b, &e);
+	if (!ret)
+		ret = vb2_ext_dqbuf(q, &e, nonblocking);
+	if (!ret)
+		v4l2_ext_buffer_to_buffer(&e, b);
+	return ret;
+}
 EXPORT_SYMBOL_GPL(vb2_dqbuf);
 
 int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index aac8b7b6e691..b10d8655cee7 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -264,4 +264,9 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
 
 void v4l2_get_timestamp(struct timeval *tv);
 
+int v4l2_buffer_to_ext_buffer(const struct v4l2_buffer *b,
+			      struct v4l2_ext_buffer *e);
+void v4l2_ext_buffer_to_buffer(const struct v4l2_ext_buffer *e,
+			       struct v4l2_buffer *b);
+
 #endif /* V4L2_COMMON_H_ */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index bd5312118013..4944a421074c 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -159,6 +159,14 @@ struct v4l2_fh;
  *	:ref:`VIDIOC_CREATE_BUFS <vidioc_create_bufs>` ioctl
  * @vidioc_prepare_buf: pointer to the function that implements
  *	:ref:`VIDIOC_PREPARE_BUF <vidioc_prepare_buf>` ioctl
+ * @vidioc_ext_querybuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_QUERYBUF <vidioc_querybuf>` ioctl
+ * @vidioc_ext_qbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_QBUF <vidioc_qbuf>` ioctl
+ * @vidioc_ext_dqbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_DQBUF <vidioc_qbuf>` ioctl
+ * @vidioc_ext_prepare_buf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_PREPARE_BUF <vidioc_prepare_buf>` ioctl
  * @vidioc_overlay: pointer to the function that implements
  *	:ref:`VIDIOC_OVERLAY <vidioc_overlay>` ioctl
  * @vidioc_g_fbuf: pointer to the function that implements
@@ -419,6 +427,15 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_prepare_buf)(struct file *file, void *fh,
 				  struct v4l2_buffer *b);
 
+	int (*vidioc_ext_querybuf)(struct file *file, void *fh,
+				   struct v4l2_ext_buffer *b);
+	int (*vidioc_ext_qbuf)(struct file *file, void *fh,
+			       struct v4l2_ext_buffer *b);
+	int (*vidioc_ext_dqbuf)(struct file *file, void *fh,
+				struct v4l2_ext_buffer *b);
+	int (*vidioc_ext_prepare_buf)(struct file *file, void *fh,
+				      struct v4l2_ext_buffer *b);
+
 	int (*vidioc_overlay)(struct file *file, void *fh, unsigned int i);
 	int (*vidioc_g_fbuf)(struct file *file, void *fh,
 			     struct v4l2_framebuffer *a);
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index e157d5c9b224..bff83873aa1a 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -588,14 +588,22 @@ int v4l2_m2m_ioctl_create_bufs(struct file *file, void *fh,
 				struct v4l2_create_buffers *create);
 int v4l2_m2m_ioctl_querybuf(struct file *file, void *fh,
 				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_ext_querybuf(struct file *file, void *fh,
+				struct v4l2_ext_buffer *buf);
 int v4l2_m2m_ioctl_expbuf(struct file *file, void *fh,
 				struct v4l2_exportbuffer *eb);
 int v4l2_m2m_ioctl_qbuf(struct file *file, void *fh,
 				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_ext_qbuf(struct file *file, void *fh,
+				struct v4l2_ext_buffer *buf);
 int v4l2_m2m_ioctl_dqbuf(struct file *file, void *fh,
 				struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_ext_dqbuf(struct file *file, void *fh,
+				struct v4l2_ext_buffer *buf);
 int v4l2_m2m_ioctl_prepare_buf(struct file *file, void *fh,
 			       struct v4l2_buffer *buf);
+int v4l2_m2m_ioctl_ext_prepare_buf(struct file *file, void *fh,
+			       struct v4l2_ext_buffer *buf);
 int v4l2_m2m_ioctl_streamon(struct file *file, void *fh,
 				enum v4l2_buf_type type);
 int v4l2_m2m_ioctl_streamoff(struct file *file, void *fh,
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 036127c54bbf..e9ea84c65406 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -51,6 +51,7 @@ struct vb2_v4l2_buffer {
 	container_of(vb, struct vb2_v4l2_buffer, vb2_buf)
 
 int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_ext_querybuf(struct vb2_queue *q, struct v4l2_ext_buffer *b);
 
 /**
  * vb2_reqbufs() - Wrapper for vb2_core_reqbufs() that also verifies
@@ -90,6 +91,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
  * from vidioc_prepare_buf handler in driver.
  */
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_ext_prepare_buf(struct vb2_queue *q, struct v4l2_ext_buffer *b);
 
 /**
  * vb2_qbuf() - Queue a buffer from userspace
@@ -111,6 +113,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
  * from VIDIOC_QBUF() handler in driver.
  */
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_ext_qbuf(struct vb2_queue *q, struct v4l2_ext_buffer *b);
 
 /**
  * vb2_expbuf() - Export a buffer as a file descriptor
@@ -147,6 +150,7 @@ int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
  * from VIDIOC_DQBUF() handler in driver.
  */
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
+int vb2_ext_dqbuf(struct vb2_queue *q, struct v4l2_ext_buffer *b, bool nonblocking);
 
 /**
  * vb2_streamon - start streaming
@@ -245,9 +249,14 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 			  struct v4l2_create_buffers *p);
 int vb2_ioctl_prepare_buf(struct file *file, void *priv,
 			  struct v4l2_buffer *p);
+int vb2_ioctl_ext_prepare_buf(struct file *file, void *priv,
+			  struct v4l2_ext_buffer *p);
 int vb2_ioctl_querybuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_ext_querybuf(struct file *file, void *priv, struct v4l2_ext_buffer *p);
 int vb2_ioctl_qbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_ext_qbuf(struct file *file, void *priv, struct v4l2_ext_buffer *p);
 int vb2_ioctl_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p);
+int vb2_ioctl_ext_dqbuf(struct file *file, void *priv, struct v4l2_ext_buffer *p);
 int vb2_ioctl_streamon(struct file *file, void *priv, enum v4l2_buf_type i);
 int vb2_ioctl_streamoff(struct file *file, void *priv, enum v4l2_buf_type i);
 int vb2_ioctl_expbuf(struct file *file, void *priv,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 185d6a0acc06..908eeaa66c7a 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -875,6 +875,18 @@ struct v4l2_plane {
 	__u32			reserved[11];
 };
 
+struct v4l2_ext_plane {
+	__u32			bytesused;
+	__u32			length;
+	union {
+		__u32		mem_offset;
+		__u64		userptr;
+		__s32		fd;
+	} m;
+	__u32			data_offset;
+	__u32			reserved[11];
+};
+
 /**
  * struct v4l2_buffer - video buffer info
  * @index:	id number of the buffer
@@ -928,6 +940,36 @@ struct v4l2_buffer {
 	__u32			reserved;
 };
 
+/**
+ * struct v4l2_ext_buffer - video buffer info
+ * @index:	id number of the buffer
+ * @type:	enum v4l2_buf_type; buffer type (type == *_MPLANE for
+ *		multiplanar buffers);
+ * @flags:	buffer informational flags
+ * @field:	enum v4l2_field; field order of the image in the buffer
+ * @timestamp:	frame timestamp
+ * @sequence:	sequence count of this frame
+ * @memory:	enum v4l2_memory; the method, in which the actual video data is
+ *		passed
+ * @planes:	per-plane buffer information
+ * @num_planes:	number of plane buffers
+ *
+ * Contains data exchanged by application and driver using one of the Streaming
+ * I/O methods.
+ */
+struct v4l2_ext_buffer {
+	__u32			index;
+	__u32			type;
+	__u32			flags;
+	__u32			field;
+	__u64			timestamp;
+	__u32			sequence;
+	__u32			memory;
+	struct v4l2_ext_plane	planes[VIDEO_MAX_PLANES];
+	__u32			num_planes;
+	__u32			reserved[11];
+};
+
 /*  Flags for 'flags' field */
 /* Buffer is mapped (flag) */
 #define V4L2_BUF_FLAG_MAPPED			0x00000001
@@ -2397,6 +2439,11 @@ struct v4l2_create_buffers {
 
 #define VIDIOC_QUERY_EXT_CTRL	_IOWR('V', 103, struct v4l2_query_ext_ctrl)
 
+#define VIDIOC_EXT_QUERYBUF	_IOWR('V', 104, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_QBUF		_IOWR('V', 105, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_DQBUF	_IOWR('V', 106, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_PREPARE_BUF	_IOWR('V', 107, struct v4l2_ext_buffer)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
 
-- 
2.14.2

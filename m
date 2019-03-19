Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC902C4360F
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 14:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3802133D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 14:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfCSOwx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:52:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37500 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfCSOwx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 10:52:53 -0400
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 42F8228139C;
        Tue, 19 Mar 2019 14:52:50 +0000 (GMT)
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Hirokazu Honda <hiroh@chromium.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [RFC PATCH 3/3] media: v4l2: Add extended buffer operations
Date:   Tue, 19 Mar 2019 15:52:43 +0100
Message-Id: <20190319145243.25047-4-boris.brezillon@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319145243.25047-1-boris.brezillon@collabora.com>
References: <20190319145243.25047-1-boris.brezillon@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

Those extended buffer ops have several purpose:
1/ Fix y2038 issues by converting the timestamp into an u64 counting
   the number of ns elapsed since 1970
2/ Unify single/multiplanar handling
3/ Add a new start offset field to each v4l2 plane buffer info struct
   to support the case where a single buffer object is storing all
   planes data, each one being placed at a different offset

New hooks are created in v4l2_ioctl_ops so that drivers can start using
these new objects.

The core takes care of converting new ioctls requests to old ones
if the driver does not support the new hooks, and vice versa.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
---
Hans,

I kept initial autorship as this patch is heavily based on your
initial proposal [1]. Please let me know if you want me to change
it.

Regards,

Boris

[1]https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3
---
 drivers/media/v4l2-core/v4l2-common.c |  92 ++++++++
 drivers/media/v4l2-core/v4l2-dev.c    |   6 +
 drivers/media/v4l2-core/v4l2-ioctl.c  | 315 ++++++++++++++++++++++++--
 include/media/v4l2-common.h           |   6 +
 include/media/v4l2-ioctl.h            |  24 ++
 include/uapi/linux/videodev2.h        | 125 ++++++++++
 6 files changed, 547 insertions(+), 21 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index fb6ba89564d1..2c9c539158c3 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -644,3 +644,95 @@ int v4l2_format_to_ext_format(const struct v4l2_format *f,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_format_to_ext_format);
+
+int v4l2_ext_buffer_to_buffer(const struct v4l2_ext_buffer *e,
+			      struct v4l2_buffer *b, bool mplane_cap)
+{
+	u64 nsecs;
+
+	if (!mplane_cap && e->num_planes > 1)
+		return -EINVAL;
+
+	memset(b, 0, sizeof(*b));
+
+	b->index = e->index;
+	b->flags = e->flags;
+	b->field = e->field;
+	b->sequence = e->sequence;
+	b->memory = e->memory;
+	b->request_fd = e->request_fd;
+	b->timestamp.tv_sec = div64_u64_rem(e->timestamp, NSEC_PER_SEC, &nsecs);
+	b->timestamp.tv_usec = (u32)nsecs / NSEC_PER_USEC;
+	if (mplane_cap) {
+		unsigned int i;
+
+		if (e->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+			b->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		else
+			b->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
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
+		b->type = e->type;
+		b->bytesused = e->planes[0].bytesused;
+		b->length = e->planes[0].length;
+		b->m.userptr = e->planes[0].m.userptr;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_ext_buffer_to_buffer);
+
+int v4l2_buffer_to_ext_buffer(const struct v4l2_buffer *b,
+			      struct v4l2_ext_buffer *e)
+{
+	memset(e, 0, sizeof(*e));
+
+	e->index = b->index;
+	e->flags = b->flags;
+	e->field = b->field;
+	e->sequence = b->sequence;
+	e->memory = b->memory;
+	e->request_fd = b->request_fd;
+	e->timestamp = b->timestamp.tv_sec * NSEC_PER_SEC +
+		b->timestamp.tv_usec * NSEC_PER_USEC;
+	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
+		unsigned int i;
+
+		if (!b->m.planes)
+			return -EINVAL;
+
+		if (b->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+			e->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		else
+			e->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+
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
+		e->type = b->type;
+		e->num_planes = 1;
+		e->planes[0].bytesused = b->bytesused;
+		e->planes[0].length = b->length;
+		e->planes[0].m.userptr = b->m.userptr;
+		e->planes[0].data_offset = 0;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_buffer_to_ext_buffer);
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index a233e0924ed3..ecff3de494ff 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -701,10 +701,16 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		/* ioctls valid for video, metadata, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
+		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_ext_querybuf);
 		SET_VALID_IOCTL(ops, VIDIOC_QBUF, vidioc_qbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_QBUF, vidioc_ext_qbuf);
 		SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_expbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXPBUF, vidioc_ext_expbuf);
 		SET_VALID_IOCTL(ops, VIDIOC_DQBUF, vidioc_dqbuf);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_DQBUF, vidioc_ext_dqbuf);
 		SET_VALID_IOCTL(ops, VIDIOC_CREATE_BUFS, vidioc_create_bufs);
+		SET_VALID_IOCTL(ops, VIDIOC_EXT_CREATE_BUFS,
+				vidioc_ext_create_bufs);
 		SET_VALID_IOCTL(ops, VIDIOC_PREPARE_BUF, vidioc_prepare_buf);
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMON, vidioc_streamon);
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index e995eb6e09a4..31eb7c0a01a2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -584,6 +584,26 @@ static void v4l_print_buffer(const void *arg, bool write_only)
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
+static void v4l_print_ext_buffer(const void *arg, bool write_only)
+{
+	const struct v4l2_ext_buffer *p = arg;
+	const struct v4l2_ext_plane *plane;
+	int i;
+
+	pr_cont("%lld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s\n",
+		p->timestamp, p->index, prt_names(p->type, v4l2_type_names),
+		p->flags, prt_names(p->field, v4l2_field_names),
+		p->sequence, prt_names(p->memory, v4l2_memory_names));
+
+	for (i = 0; i < p->num_planes; ++i) {
+		plane = &p->planes[i];
+		pr_debug("plane %d: bytesused=%d, start_offset=0x%08x, data_offset=0x%08x, offset/userptr=0x%llx, length=%d\n",
+			 i, plane->bytesused, plane->start_offset,
+			 plane->data_offset, plane->m.userptr,
+			 plane->length);
+	}
+}
+
 static void v4l_print_exportbuffer(const void *arg, bool write_only)
 {
 	const struct v4l2_exportbuffer *p = arg;
@@ -593,6 +613,18 @@ static void v4l_print_exportbuffer(const void *arg, bool write_only)
 		p->index, p->plane, p->flags);
 }
 
+static void v4l_print_ext_exportbuffer(const void *arg, bool write_only)
+{
+	const struct v4l2_ext_exportbuffer *p = arg;
+	unsigned int i;
+
+	pr_cont("type=%s, index=%u, first_plane=%u num_planes=%u, flags=%08x\n",
+		prt_names(p->type, v4l2_type_names), p->index, p->first_plane,
+		p->num_planes, p->flags);
+	for (i = p->first_plane; i < p->first_plane + p->num_planes; ++i)
+		pr_debug("plane %u: fd=%d\n", i, p->fds[i]);
+}
+
 static void v4l_print_create_buffers(const void *arg, bool write_only)
 {
 	const struct v4l2_create_buffers *p = arg;
@@ -603,6 +635,15 @@ static void v4l_print_create_buffers(const void *arg, bool write_only)
 	v4l_print_format(&p->format, write_only);
 }
 
+static void v4l_print_ext_create_buffers(const void *arg, bool write_only)
+{
+	const struct v4l2_ext_create_buffers *p = arg;
+
+	pr_cont("index=%d, count=%d, memory=%s, ", p->index, p->count,
+		prt_names(p->memory, v4l2_memory_names));
+	v4l_print_ext_format(&p->format, write_only);
+}
+
 static void v4l_print_streamparm(const void *arg, bool write_only)
 {
 	const struct v4l2_streamparm *p = arg;
@@ -2262,31 +2303,109 @@ static int v4l_reqbufs(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_reqbufs(file, fh, p);
 }
 
-static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
+static int v4l_do_buf_op(int (*op)(struct file *, void *,
+				   struct v4l2_buffer *),
+			 int (*ext_op)(struct file *, void *,
+				       struct v4l2_ext_buffer *),
+			 struct file *file, void *fh, struct v4l2_buffer *b)
 {
-	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(file, p->type);
+	struct v4l2_ext_buffer eb;
+	int ret;
 
-	return ret ? ret : ops->vidioc_querybuf(file, fh, p);
+	ret = check_fmt(file, b->type);
+	if (ret)
+		return ret;
+
+	if (op)
+		return op(file, fh, b);
+
+	ret = v4l2_buffer_to_ext_buffer(b, &eb);
+	if (ret)
+		return ret;
+
+	ret = ext_op(file, fh, &eb);
+	if (ret)
+		return ret;
+
+	v4l2_ext_buffer_to_buffer(&eb, b, V4L2_TYPE_IS_MULTIPLANAR(b->type));
+	return 0;
+}
+
+static int v4l_do_ext_buf_op(int (*op)(struct file *, void *,
+				       struct v4l2_buffer *),
+			     int (*ext_op)(struct file *, void *,
+					   struct v4l2_ext_buffer *),
+			     struct file *file, void *fh,
+			     struct v4l2_ext_buffer *eb)
+{
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_buffer b;
+	bool mplane_cap;
+	int ret;
+
+	ret = check_fmt(file, eb->type);
+	if (ret)
+		return ret;
+
+	if (ext_op)
+		return ext_op(file, fh, eb);
+
+	mplane_cap = !!(vdev->device_caps &
+			(V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			 V4L2_CAP_VIDEO_OUTPUT_MPLANE |
+			 V4L2_CAP_VIDEO_M2M_MPLANE));
+	ret = v4l2_ext_buffer_to_buffer(eb, &b, mplane_cap);
+	if (ret)
+		return ret;
+
+	ret = op(file, fh, &b);
+	if (ret)
+		return ret;
+
+	v4l2_buffer_to_ext_buffer(&b, eb);
+	return 0;
+}
+
+static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
+			struct file *file, void *fh, void *arg)
+{
+	return v4l_do_buf_op(ops->vidioc_querybuf, ops->vidioc_ext_querybuf,
+			     file, fh, arg);
+}
+
+static int v4l_ext_querybuf(const struct v4l2_ioctl_ops *ops,
+			    struct file *file, void *fh, void *arg)
+{
+	return v4l_do_ext_buf_op(ops->vidioc_querybuf,
+				 ops->vidioc_ext_querybuf, file, fh, arg);
 }
 
 static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
+		    struct file *file, void *fh, void *arg)
 {
-	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(file, p->type);
+	return v4l_do_buf_op(ops->vidioc_qbuf, ops->vidioc_ext_qbuf,
+			     file, fh, arg);
+}
 
-	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
+static int v4l_ext_qbuf(const struct v4l2_ioctl_ops *ops,
+			struct file *file, void *fh, void *arg)
+{
+	return v4l_do_ext_buf_op(ops->vidioc_qbuf, ops->vidioc_ext_qbuf,
+				 file, fh, arg);
 }
 
 static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
+		     struct file *file, void *fh, void *arg)
 {
-	struct v4l2_buffer *p = arg;
-	int ret = check_fmt(file, p->type);
+	return v4l_do_buf_op(ops->vidioc_dqbuf, ops->vidioc_ext_dqbuf,
+			     file, fh, arg);
+}
 
-	return ret ? ret : ops->vidioc_dqbuf(file, fh, p);
+static int v4l_ext_dqbuf(const struct v4l2_ioctl_ops *ops,
+			 struct file *file, void *fh, void *arg)
+{
+	return v4l_do_ext_buf_op(ops->vidioc_dqbuf, ops->vidioc_ext_dqbuf,
+				 file, fh, arg);
 }
 
 static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
@@ -2302,7 +2421,27 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 
 	v4l_sanitize_format(&create->format);
 
-	ret = ops->vidioc_create_bufs(file, fh, create);
+	if (ops->vidioc_create_bufs) {
+		ret = ops->vidioc_create_bufs(file, fh, create);
+	} else {
+		struct v4l2_ext_create_buffers ecreate = {
+			.count = create->count,
+			.memory = create->memory,
+		};
+
+		ret = v4l2_format_to_ext_format(&create->format,
+						&ecreate.format);
+		if (ret)
+			return ret;
+
+		ret = ops->vidioc_ext_create_bufs(file, fh, &ecreate);
+		if (ret)
+			return ret;
+
+		create->index = ecreate.index;
+		create->count = ecreate.count;
+		create->capabilities = ecreate.capabilities;
+	}
 
 	if (create->format.type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
 	    create->format.type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
@@ -2311,13 +2450,59 @@ static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
 	return ret;
 }
 
-static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
-				struct file *file, void *fh, void *arg)
+static int v4l_ext_create_bufs(const struct v4l2_ioctl_ops *ops,
+			       struct file *file, void *fh, void *arg)
 {
-	struct v4l2_buffer *b = arg;
-	int ret = check_fmt(file, b->type);
+	struct v4l2_ext_create_buffers *ecreate = arg;
+	struct video_device *vdev = video_devdata(file);
+	struct v4l2_create_buffers create = {
+		.count = ecreate->count,
+		.memory = ecreate->memory,
+	};
+	bool mplane_cap;
+	int ret;
 
-	return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
+	ret = check_fmt(file, ecreate->format.type);
+	if (ret)
+		return ret;
+
+	if (ops->vidioc_ext_create_bufs)
+		return ops->vidioc_ext_create_bufs(file, fh, ecreate);
+
+	mplane_cap = !!(vdev->device_caps &
+			(V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+			 V4L2_CAP_VIDEO_OUTPUT_MPLANE |
+			 V4L2_CAP_VIDEO_M2M_MPLANE));
+	ret = v4l2_ext_format_to_format(&ecreate->format,
+					&create.format, mplane_cap);
+	if (ret)
+		return ret;
+
+	ret = v4l_create_bufs(ops, file, fh, &create);
+	if (ret)
+		return ret;
+
+	ecreate->index = create.index;
+	ecreate->count = create.count;
+	ecreate->capabilities = create.capabilities;
+
+	return 0;
+}
+
+static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
+			   struct file *file, void *fh, void *arg)
+{
+	return v4l_do_buf_op(ops->vidioc_prepare_buf,
+			     ops->vidioc_ext_prepare_buf,
+			     file, fh, arg);
+}
+
+static int v4l_ext_prepare_buf(const struct v4l2_ioctl_ops *ops,
+			       struct file *file, void *fh, void *arg)
+{
+	return v4l_do_ext_buf_op(ops->vidioc_prepare_buf,
+				 ops->vidioc_ext_prepare_buf,
+				 file, fh, arg);
 }
 
 static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
@@ -2909,6 +3094,86 @@ static int v4l_enum_freq_bands(const struct v4l2_ioctl_ops *ops,
 	return -ENOTTY;
 }
 
+static int v4l_expbuf(const struct v4l2_ioctl_ops *ops, struct file *file,
+		      void *fh, void *arg)
+{
+	struct v4l2_exportbuffer *b = arg;
+	struct v4l2_ext_exportbuffer eb = {
+		.type = b->type,
+		.index = b->index,
+		.first_plane = b->plane,
+		.num_planes = 1,
+		.flags = b->flags,
+	};
+	int ret;
+
+	if (ops->vidioc_expbuf)
+		return ops->vidioc_expbuf(file, fh, b);
+
+	if (b->plane >= VIDEO_MAX_PLANES)
+		return -EINVAL;
+
+	ret = ops->vidioc_ext_expbuf(file, fh, &eb);
+	if (ret)
+		return ret;
+
+	b->fd = eb.fds[b->plane];
+	return 0;
+}
+
+static int v4l_ext_expbuf(const struct v4l2_ioctl_ops *ops,
+			  struct file *file, void *fh, void *arg)
+{
+	struct v4l2_ext_exportbuffer *eb = arg;
+	unsigned int i;
+	int ret;
+
+	if (eb->first_plane >= VIDEO_MAX_PLANES ||
+	    eb->num_planes > VIDEO_MAX_PLANES ||
+	    eb->first_plane + eb->num_planes > VIDEO_MAX_PLANES)
+		return -EINVAL;
+
+	if (ops->vidioc_ext_expbuf)
+		return ops->vidioc_ext_expbuf(file, fh, eb);
+
+	for (i = eb->first_plane; i < eb->first_plane + eb->num_planes; i++) {
+		struct v4l2_exportbuffer b = {
+			.type = eb->type,
+			.index = eb->index,
+			.plane = i,
+			.flags = eb->flags,
+		};
+
+		ret = ops->vidioc_expbuf(file, fh, &b);
+		if (ret)
+			goto err_put_dmabufs;
+
+		eb->fds[i] = b.fd;
+	}
+
+	return 0;
+
+err_put_dmabufs:
+	for (i = eb->first_plane; i < eb->first_plane + eb->num_planes; i++) {
+		struct dma_buf *dmabuf;
+
+		if (eb->fds[i] <= 0)
+			break;
+
+		/*
+		 * We must call dma_buf_put() twice because we got one
+		 * reference taken at dmabuf creation time one taken when
+		 * calling dma_buf_get().
+		 * FIXME: not entirely sure this works correctly.
+		 */
+		dmabuf = dma_buf_get(eb->fds[i]);
+		dma_buf_put(dmabuf);
+		dma_buf_put(dmabuf);
+	}
+
+	return ret;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -2951,7 +3216,6 @@ struct v4l2_ioctl_info {
 
 DEFINE_V4L_STUB_FUNC(g_fbuf)
 DEFINE_V4L_STUB_FUNC(s_fbuf)
-DEFINE_V4L_STUB_FUNC(expbuf)
 DEFINE_V4L_STUB_FUNC(g_std)
 DEFINE_V4L_STUB_FUNC(g_audio)
 DEFINE_V4L_STUB_FUNC(s_audio)
@@ -2989,7 +3253,7 @@ static const struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_S_FBUF, v4l_stub_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_OVERLAY, v4l_overlay, v4l_print_u32, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, INFO_FL_QUEUE),
-	IOCTL_INFO(VIDIOC_EXPBUF, v4l_stub_expbuf, v4l_print_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
+	IOCTL_INFO(VIDIOC_EXPBUF, v4l_expbuf, v4l_print_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
 	IOCTL_INFO(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, INFO_FL_QUEUE),
 	IOCTL_INFO(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
 	IOCTL_INFO(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO | INFO_FL_QUEUE),
@@ -3061,6 +3325,15 @@ static const struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_ENUM_FREQ_BANDS, v4l_enum_freq_bands, v4l_print_freq_band, 0),
 	IOCTL_INFO(VIDIOC_DBG_G_CHIP_INFO, v4l_dbg_g_chip_info, v4l_print_dbg_chip_info, INFO_FL_CLEAR(v4l2_dbg_chip_info, match)),
 	IOCTL_INFO(VIDIOC_QUERY_EXT_CTRL, v4l_query_ext_ctrl, v4l_print_query_ext_ctrl, INFO_FL_CTRL | INFO_FL_CLEAR(v4l2_query_ext_ctrl, id)),
+	IOCTL_INFO(VIDIOC_G_EXT_FMT, v4l_g_ext_fmt, v4l_print_ext_format, 0),
+	IOCTL_INFO(VIDIOC_S_EXT_FMT, v4l_s_ext_fmt, v4l_print_ext_format, INFO_FL_PRIO),
+	IOCTL_INFO(VIDIOC_TRY_EXT_FMT, v4l_try_ext_fmt, v4l_print_ext_format, 0),
+	IOCTL_INFO(VIDIOC_EXT_CREATE_BUFS, v4l_ext_create_bufs, v4l_print_ext_create_buffers, INFO_FL_PRIO | INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_EXT_QUERYBUF, v4l_ext_querybuf, v4l_print_ext_buffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_buffer, length)),
+	IOCTL_INFO(VIDIOC_EXT_QBUF, v4l_ext_qbuf, v4l_print_ext_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_EXT_DQBUF, v4l_ext_dqbuf, v4l_print_ext_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_EXT_PREPARE_BUF, v4l_ext_prepare_buf, v4l_print_ext_buffer, INFO_FL_QUEUE),
+	IOCTL_INFO(VIDIOC_EXT_EXPBUF, v4l_ext_expbuf, v4l_print_ext_exportbuffer, INFO_FL_QUEUE | INFO_FL_CLEAR(v4l2_exportbuffer, flags)),
 };
 #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
 
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 6cc88f672405..f8371bb7b3e2 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -407,4 +407,10 @@ int v4l2_ext_format_to_format(const struct v4l2_ext_format *e,
 			      struct v4l2_format *f,
 			      bool mplane_cap);
 
+int v4l2_ext_buffer_to_buffer(const struct v4l2_ext_buffer *e,
+			      struct v4l2_buffer *b,
+			      bool mplane_cap);
+int v4l2_buffer_to_ext_buffer(const struct v4l2_buffer *b,
+			      struct v4l2_ext_buffer *e);
+
 #endif /* V4L2_COMMON_H_ */
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 5cbc3df2a396..1f3c66220946 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -168,16 +168,28 @@ struct v4l2_fh;
  *	:ref:`VIDIOC_REQBUFS <vidioc_reqbufs>` ioctl
  * @vidioc_querybuf: pointer to the function that implements
  *	:ref:`VIDIOC_QUERYBUF <vidioc_querybuf>` ioctl
+ * @vidioc_ext_querybuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_QUERYBUF <vidioc_ext_querybuf>` ioctl
  * @vidioc_qbuf: pointer to the function that implements
  *	:ref:`VIDIOC_QBUF <vidioc_qbuf>` ioctl
+ * @vidioc_ext_qbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_QBUF <vidioc_ext_qbuf>` ioctl
  * @vidioc_expbuf: pointer to the function that implements
  *	:ref:`VIDIOC_EXPBUF <vidioc_expbuf>` ioctl
+ * @vidioc_ext_expbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_EXPBUF <vidioc_ext_expbuf>` ioctl
  * @vidioc_dqbuf: pointer to the function that implements
  *	:ref:`VIDIOC_DQBUF <vidioc_qbuf>` ioctl
+ * @vidioc_ext_dqbuf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_DQBUF <vidioc_ext_qbuf>` ioctl
  * @vidioc_create_bufs: pointer to the function that implements
  *	:ref:`VIDIOC_CREATE_BUFS <vidioc_create_bufs>` ioctl
+ * @vidioc_ext_create_bufs: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_CREATE_BUFS <vidioc_ext_create_bufs>` ioctl
  * @vidioc_prepare_buf: pointer to the function that implements
  *	:ref:`VIDIOC_PREPARE_BUF <vidioc_prepare_buf>` ioctl
+ * @vidioc_ext_prepare_buf: pointer to the function that implements
+ *	:ref:`VIDIOC_EXT_PREPARE_BUF <vidioc_ext_prepare_buf>` ioctl
  * @vidioc_overlay: pointer to the function that implements
  *	:ref:`VIDIOC_OVERLAY <vidioc_overlay>` ioctl
  * @vidioc_g_fbuf: pointer to the function that implements
@@ -438,17 +450,29 @@ struct v4l2_ioctl_ops {
 			      struct v4l2_requestbuffers *b);
 	int (*vidioc_querybuf)(struct file *file, void *fh,
 			       struct v4l2_buffer *b);
+	int (*vidioc_ext_querybuf)(struct file *file, void *fh,
+				   struct v4l2_ext_buffer *b);
 	int (*vidioc_qbuf)(struct file *file, void *fh,
 			   struct v4l2_buffer *b);
+	int (*vidioc_ext_qbuf)(struct file *file, void *fh,
+			       struct v4l2_ext_buffer *b);
 	int (*vidioc_expbuf)(struct file *file, void *fh,
 			     struct v4l2_exportbuffer *e);
+	int (*vidioc_ext_expbuf)(struct file *file, void *fh,
+				 struct v4l2_ext_exportbuffer *e);
 	int (*vidioc_dqbuf)(struct file *file, void *fh,
 			    struct v4l2_buffer *b);
+	int (*vidioc_ext_dqbuf)(struct file *file, void *fh,
+				struct v4l2_ext_buffer *b);
 
 	int (*vidioc_create_bufs)(struct file *file, void *fh,
 				  struct v4l2_create_buffers *b);
+	int (*vidioc_ext_create_bufs)(struct file *file, void *fh,
+				      struct v4l2_ext_create_buffers *b);
 	int (*vidioc_prepare_buf)(struct file *file, void *fh,
 				  struct v4l2_buffer *b);
+	int (*vidioc_ext_prepare_buf)(struct file *file, void *fh,
+				      struct v4l2_ext_buffer *b);
 
 	int (*vidioc_overlay)(struct file *file, void *fh, unsigned int i);
 	int (*vidioc_g_fbuf)(struct file *file, void *fh,
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3dbeb83176bf..290b7f430927 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -916,6 +916,47 @@ struct v4l2_plane {
 	__u32			reserved[11];
 };
 
+/**
+ * struct v4l2_ext_plane - extended plane buffer info
+ * @bytesused: number of bytes occupied by data in the plane (payload)
+ * @length: size of this plane (NOT the payload) in bytes
+ * @mem_offset: when memory in the associated struct v4l2_ext_buffer is
+ *		V4L2_MEMORY_MMAP, equals the offset from the start of the
+ *		device memory for this plane (or is a "cookie" that should be
+ *		passed to mmap() called on the video node)
+ * @userptr: when memory is V4L2_MEMORY_USERPTR, a userspace pointer pointing
+ *	     to this plane
+ * @fd: when memory is V4L2_MEMORY_DMABUF, a userspace file descriptor
+ *	associated with this plane
+ * @start_offset: where the plane starts inside a buffer. All planes might
+ *		  share the same buffer object. In this case we need to know
+ *		  where the plane start inside this buffer.
+ * @data_offset: offset in the plane to the start of data; usually 0, unless
+ *		 there is a header in front of the data. data_offset is
+ *		 relative to start_offset, so absolute data_offset is actually
+ *		 start_offset + data_offset
+ *
+ *
+ * Multi-planar buffers consist of one or more planes, e.g. an YCbCr buffer
+ * with two planes can have one plane for Y, and another for interleaved CbCr
+ * components. Each plane can reside in a separate memory buffer, or even in
+ * a completely separate memory node (e.g. in embedded devices).
+ * Note that this struct is also used for uni-planar buffers, but in that case
+ * you'll only have one plane defined.
+ */
+struct v4l2_ext_plane {
+	__u32 bytesused;
+	__u32 length;
+	union {
+		__u32 mem_offset;
+		__u64 userptr;
+		__s32 fd;
+	} m;
+	__u32 start_offset;
+	__u32 data_offset;
+	__u32 reserved[10];
+};
+
 /**
  * struct v4l2_buffer - video buffer info
  * @index:	id number of the buffer
@@ -973,6 +1014,37 @@ struct v4l2_buffer {
 	};
 };
 
+/**
+ * struct v4l2_ext_buffer - extended video buffer info
+ * @index: id number of the buffer
+ * @type: enum v4l2_buf_type; buffer type. _MPLANE and _OVERLAY formats are
+ *	  invalid
+ * @flags: buffer informational flags
+ * @field: enum v4l2_field; field order of the image in the buffer
+ * @timestamp: frame timestamp
+ * @sequence: sequence count of this frame
+ * @memory: enum v4l2_memory; the method, in which the actual video data is
+ *          passed
+ * @planes: per-plane buffer information
+ * @num_planes: number of plane buffers
+ *
+ * Contains data exchanged by application and driver using one of the Streaming
+ * I/O methods.
+ */
+struct v4l2_ext_buffer {
+	__u32 index;
+	__u32 type;
+	__u32 flags;
+	__u32 field;
+	__u64 timestamp;
+	__u32 sequence;
+	__u32 memory;
+	struct v4l2_ext_plane planes[VIDEO_MAX_PLANES];
+	__u32 num_planes;
+	__u32 request_fd;
+	__u32 reserved[10];
+};
+
 /*  Flags for 'flags' field */
 /* Buffer is mapped (flag) */
 #define V4L2_BUF_FLAG_MAPPED			0x00000001
@@ -1038,6 +1110,35 @@ struct v4l2_exportbuffer {
 	__u32		reserved[11];
 };
 
+/**
+ * struct v4l2_ext_exportbuffer - export of video buffer as DMABUF file
+ *				  descriptor using extended format
+ *
+ * @index: id number of the buffer
+ * @type: enum v4l2_buf_type; buffer type
+ * @flags: flags for newly created file(s), currently only O_CLOEXEC is
+ *	   supported, refer to manual of open syscall for more details
+ * @first_plane: first plane to export. Most likely set to 0
+ * @num_planes: number of planes to export. Most set to the number of planes
+ *		attached to the buffer
+ * @fds: file descriptors associated with DMABUF (set by driver). Note that all
+ *	 planes might share the same buffer and then be returned the same FD
+ *
+ * Contains data used for exporting a video buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by VIDIOC_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero.
+ */
+struct v4l2_ext_exportbuffer {
+	__u32 type; /* enum v4l2_buf_type */
+	__u32 index;
+	__u32 flags;
+	__u32 first_plane;
+	__u32 num_planes;
+	__s32 fds[VIDEO_MAX_PLANES];
+	__u32 reserved;
+};
+
 /*
  *	O V E R L A Y   P R E V I E W
  */
@@ -2435,6 +2536,23 @@ struct v4l2_create_buffers {
 	__u32			reserved[7];
 };
 
+/**
+ * struct v4l2_ext_create_buffers - VIDIOC_EXT_CREATE_BUFS argument
+ * @index:	on return, index of the first created buffer
+ * @count:	entry: number of requested buffers,
+ *		return: number of created buffers
+ * @memory:	enum v4l2_memory; buffer memory type
+ * @capabilities: capabilities of this buffer type.
+ * @format:	frame format, for which buffers are requested
+ */
+struct v4l2_ext_create_buffers {
+	__u32			index;
+	__u32			count;
+	__u32			memory;
+	__u32			capabilities;
+	struct v4l2_ext_format	format;
+};
+
 /*
  *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
  *
@@ -2538,6 +2656,13 @@ struct v4l2_create_buffers {
 #define VIDIOC_G_EXT_FMT	_IOWR('V', 104, struct v4l2_ext_format)
 #define VIDIOC_S_EXT_FMT	_IOWR('V', 105, struct v4l2_ext_format)
 #define VIDIOC_TRY_EXT_FMT	_IOWR('V', 106, struct v4l2_ext_format)
+#define VIDIOC_EXT_CREATE_BUFS	_IOWR('V', 107, struct v4l2_ext_create_buffers)
+#define VIDIOC_EXT_QUERYBUF	_IOWR('V', 108, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_QBUF		_IOWR('V', 109, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_DQBUF	_IOWR('V', 110, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_PREPARE_BUF	_IOWR('V', 111, struct v4l2_ext_buffer)
+#define VIDIOC_EXT_EXPBUF	_IOWR('V', 112, struct v4l2_ext_exportbuffer)
+
 /* Reminder: when adding new ioctls please add support for them to
    drivers/media/v4l2-core/v4l2-compat-ioctl32.c as well! */
 
-- 
2.20.1


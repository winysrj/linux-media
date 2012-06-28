Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2225 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2F1Gsr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 10/33] v4l2-ioctl.c: use the new table for queuing/parm ioctls.
Date: Thu, 28 Jun 2012 08:48:04 +0200
Message-Id: <d2b174b0647fa6545af985426a4f33389d74d3f9.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  317 ++++++++++++++++++++------------------
 1 file changed, 166 insertions(+), 151 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4d2d0d6..1f75a6c 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -426,48 +426,97 @@ static void v4l_print_hw_freq_seek(const void *arg, bool write_only)
 		p->tuner, p->type, p->seek_upward, p->wrap_around, p->spacing);
 }
 
-static void v4l_print_u32(const void *arg, bool write_only)
+static void v4l_print_requestbuffers(const void *arg, bool write_only)
 {
-	pr_cont("value=%u\n", *(const u32 *)arg);
+	const struct v4l2_requestbuffers *p = arg;
+
+	pr_cont("count=%d, type=%s, memory=%s\n",
+		p->count,
+		prt_names(p->type, v4l2_type_names),
+		prt_names(p->memory, v4l2_memory_names));
 }
 
-static void dbgbuf(unsigned int cmd, struct video_device *vfd,
-					struct v4l2_buffer *p)
+static void v4l_print_buffer(const void *arg, bool write_only)
 {
-	struct v4l2_timecode *tc = &p->timecode;
-	struct v4l2_plane *plane;
+	const struct v4l2_buffer *p = arg;
+	const struct v4l2_timecode *tc = &p->timecode;
+	const struct v4l2_plane *plane;
 	int i;
 
-	dbgarg(cmd, "%02ld:%02d:%02d.%08ld index=%d, type=%s, "
-		"flags=0x%08d, field=%0d, sequence=%d, memory=%s\n",
+	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, "
+		"flags=0x%08x, field=%s, sequence=%d, memory=%s",
 			p->timestamp.tv_sec / 3600,
 			(int)(p->timestamp.tv_sec / 60) % 60,
 			(int)(p->timestamp.tv_sec % 60),
 			(long)p->timestamp.tv_usec,
 			p->index,
 			prt_names(p->type, v4l2_type_names),
-			p->flags, p->field, p->sequence,
-			prt_names(p->memory, v4l2_memory_names));
+			p->flags, prt_names(p->field, v4l2_field_names),
+			p->sequence, prt_names(p->memory, v4l2_memory_names));
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(p->type) && p->m.planes) {
+		pr_cont("\n");
 		for (i = 0; i < p->length; ++i) {
 			plane = &p->m.planes[i];
-			dbgarg2("plane %d: bytesused=%d, data_offset=0x%08x "
-				"offset/userptr=0x%08lx, length=%d\n",
+			printk(KERN_DEBUG
+				"plane %d: bytesused=%d, data_offset=0x%08x "
+				"offset/userptr=0x%lx, length=%d\n",
 				i, plane->bytesused, plane->data_offset,
 				plane->m.userptr, plane->length);
 		}
 	} else {
-		dbgarg2("bytesused=%d, offset/userptr=0x%08lx, length=%d\n",
+		pr_cont("bytesused=%d, offset/userptr=0x%lx, length=%d\n",
 			p->bytesused, p->m.userptr, p->length);
 	}
 
-	dbgarg2("timecode=%02d:%02d:%02d type=%d, "
-		"flags=0x%08d, frames=%d, userbits=0x%08x\n",
+	printk(KERN_DEBUG "timecode=%02d:%02d:%02d type=%d, "
+		"flags=0x%08x, frames=%d, userbits=0x%08x\n",
 			tc->hours, tc->minutes, tc->seconds,
 			tc->type, tc->flags, tc->frames, *(__u32 *)tc->userbits);
 }
 
+static void v4l_print_create_buffers(const void *arg, bool write_only)
+{
+	const struct v4l2_create_buffers *p = arg;
+
+	pr_cont("index=%d, count=%d, memory=%s, ",
+			p->index, p->count,
+			prt_names(p->memory, v4l2_memory_names));
+	v4l_print_format(&p->format, write_only);
+}
+
+static void v4l_print_streamparm(const void *arg, bool write_only)
+{
+	const struct v4l2_streamparm *p = arg;
+
+	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
+
+	if (p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    p->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		const struct v4l2_captureparm *c = &p->parm.capture;
+
+		pr_cont(", capability=0x%x, capturemode=0x%x, timeperframe=%d/%d, "
+			"extendedmode=%d, readbuffers=%d\n",
+			c->capability, c->capturemode,
+			c->timeperframe.numerator, c->timeperframe.denominator,
+			c->extendedmode, c->readbuffers);
+	} else if (p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ||
+		   p->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		const struct v4l2_outputparm *c = &p->parm.output;
+
+		pr_cont(", capability=0x%x, outputmode=0x%x, timeperframe=%d/%d, "
+			"extendedmode=%d, writebuffers=%d\n",
+			c->capability, c->outputmode,
+			c->timeperframe.numerator, c->timeperframe.denominator,
+			c->extendedmode, c->writebuffers);
+	}
+}
+
+static void v4l_print_u32(const void *arg, bool write_only)
+{
+	pr_cont("value=%u\n", *(const u32 *)arg);
+}
+
 static inline void dbgrect(struct video_device *vfd, char *s,
 							struct v4l2_rect *r)
 {
@@ -1070,6 +1119,100 @@ static int v4l_s_hw_freq_seek(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_s_hw_freq_seek(file, fh, p);
 }
 
+static int v4l_reqbufs(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_requestbuffers *p = arg;
+	int ret = check_fmt(ops, p->type);
+
+	if (ret)
+		return ret;
+
+	if (p->type < V4L2_BUF_TYPE_PRIVATE)
+		CLEAR_AFTER_FIELD(p, memory);
+
+	return ops->vidioc_reqbufs(file, fh, p);
+}
+
+static int v4l_querybuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer *p = arg;
+	int ret = check_fmt(ops, p->type);
+
+	return ret ? ret : ops->vidioc_querybuf(file, fh, p);
+}
+
+static int v4l_qbuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer *p = arg;
+	int ret = check_fmt(ops, p->type);
+
+	return ret ? ret : ops->vidioc_qbuf(file, fh, p);
+}
+
+static int v4l_dqbuf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer *p = arg;
+	int ret = check_fmt(ops, p->type);
+
+	return ret ? ret : ops->vidioc_dqbuf(file, fh, p);
+}
+
+static int v4l_create_bufs(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_create_buffers *create = arg;
+	int ret = check_fmt(ops, create->format.type);
+
+	return ret ? ret : ops->vidioc_create_bufs(file, fh, create);
+}
+
+static int v4l_prepare_buf(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_buffer *b = arg;
+	int ret = check_fmt(ops, b->type);
+
+	return ret ? ret : ops->vidioc_prepare_buf(file, fh, b);
+}
+
+static int v4l_g_parm(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct video_device *vfd = video_devdata(file);
+	struct v4l2_streamparm *p = arg;
+	v4l2_std_id std;
+	int ret = check_fmt(ops, p->type);
+
+	if (ret)
+		return ret;
+	if (ops->vidioc_g_parm)
+		return ops->vidioc_g_parm(file, fh, p);
+	std = vfd->current_norm;
+	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+	p->parm.capture.readbuffers = 2;
+	if (ops->vidioc_g_std)
+		ret = ops->vidioc_g_std(file, fh, &std);
+	if (ret == 0)
+		v4l2_video_std_frame_period(std,
+			    &p->parm.capture.timeperframe);
+	return ret;
+}
+
+static int v4l_s_parm(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_streamparm *p = arg;
+	int ret = check_fmt(ops, p->type);
+
+	return ret ? ret : ops->vidioc_s_parm(file, fh, p);
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -1125,17 +1268,17 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
 	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
 	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QUERYBUF, INFO_FL_CLEAR(v4l2_buffer, length)),
+	IOCTL_INFO_FNC(VIDIOC_REQBUFS, v4l_reqbufs, v4l_print_requestbuffers, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_QUERYBUF, v4l_querybuf, v4l_print_buffer, INFO_FL_CLEAR(v4l2_buffer, length)),
 	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
 	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO_STD(VIDIOC_OVERLAY, vidioc_overlay, v4l_print_u32, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_QBUF, 0),
-	IOCTL_INFO(VIDIOC_DQBUF, 0),
+	IOCTL_INFO_FNC(VIDIOC_QBUF, v4l_qbuf, v4l_print_buffer, 0),
+	IOCTL_INFO_FNC(VIDIOC_DQBUF, v4l_dqbuf, v4l_print_buffer, 0),
 	IOCTL_INFO_FNC(VIDIOC_STREAMON, v4l_streamon, v4l_print_buftype, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_STREAMOFF, v4l_streamoff, v4l_print_buftype, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_G_PARM, INFO_FL_CLEAR(v4l2_streamparm, type)),
-	IOCTL_INFO(VIDIOC_S_PARM, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_G_PARM, v4l_g_parm, v4l_print_streamparm, INFO_FL_CLEAR(v4l2_streamparm, type)),
+	IOCTL_INFO_FNC(VIDIOC_S_PARM, v4l_s_parm, v4l_print_streamparm, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_G_STD, v4l_g_std, v4l_print_std, 0),
 	IOCTL_INFO_FNC(VIDIOC_S_STD, v4l_s_std, v4l_print_std, INFO_FL_PRIO),
 	IOCTL_INFO_FNC(VIDIOC_ENUMSTD, v4l_enumstd, v4l_print_standard, INFO_FL_CLEAR(v4l2_standard, index)),
@@ -1197,8 +1340,8 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_DQEVENT, 0),
 	IOCTL_INFO(VIDIOC_SUBSCRIBE_EVENT, 0),
 	IOCTL_INFO(VIDIOC_UNSUBSCRIBE_EVENT, 0),
-	IOCTL_INFO(VIDIOC_CREATE_BUFS, INFO_FL_PRIO),
-	IOCTL_INFO(VIDIOC_PREPARE_BUF, 0),
+	IOCTL_INFO_FNC(VIDIOC_CREATE_BUFS, v4l_create_bufs, v4l_print_create_buffers, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_PREPARE_BUF, v4l_prepare_buf, v4l_print_buffer, 0),
 	IOCTL_INFO(VIDIOC_ENUM_DV_TIMINGS, 0),
 	IOCTL_INFO(VIDIOC_QUERY_DV_TIMINGS, 0),
 	IOCTL_INFO(VIDIOC_DV_TIMINGS_CAP, 0),
@@ -1308,68 +1451,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	/* FIXME: Those buf reqs could be handled here,
-	   with some changes on videobuf to allow its header to be included at
-	   videodev2.h or being merged at videodev2.
-	 */
-	case VIDIOC_REQBUFS:
-	{
-		struct v4l2_requestbuffers *p = arg;
-
-		ret = check_fmt(ops, p->type);
-		if (ret)
-			break;
-
-		if (p->type < V4L2_BUF_TYPE_PRIVATE)
-			CLEAR_AFTER_FIELD(p, memory);
-
-		ret = ops->vidioc_reqbufs(file, fh, p);
-		dbgarg(cmd, "count=%d, type=%s, memory=%s\n",
-				p->count,
-				prt_names(p->type, v4l2_type_names),
-				prt_names(p->memory, v4l2_memory_names));
-		break;
-	}
-	case VIDIOC_QUERYBUF:
-	{
-		struct v4l2_buffer *p = arg;
-
-		ret = check_fmt(ops, p->type);
-		if (ret)
-			break;
-
-		ret = ops->vidioc_querybuf(file, fh, p);
-		if (!ret)
-			dbgbuf(cmd, vfd, p);
-		break;
-	}
-	case VIDIOC_QBUF:
-	{
-		struct v4l2_buffer *p = arg;
-
-		ret = check_fmt(ops, p->type);
-		if (ret)
-			break;
-
-		ret = ops->vidioc_qbuf(file, fh, p);
-		if (!ret)
-			dbgbuf(cmd, vfd, p);
-		break;
-	}
-	case VIDIOC_DQBUF:
-	{
-		struct v4l2_buffer *p = arg;
-
-		ret = check_fmt(ops, p->type);
-		if (ret)
-			break;
-
-		ret = ops->vidioc_dqbuf(file, fh, p);
-		if (!ret)
-			dbgbuf(cmd, vfd, p);
-		break;
-	}
-
 	/* --- controls ---------------------------------------------- */
 	case VIDIOC_QUERYCTRL:
 	{
@@ -1732,46 +1813,6 @@ static long __video_do_ioctl(struct file *file,
 			dbgarg(cmd, "cmd=%d, flags=%x\n", p->cmd, p->flags);
 		break;
 	}
-	case VIDIOC_G_PARM:
-	{
-		struct v4l2_streamparm *p = arg;
-
-		if (ops->vidioc_g_parm) {
-			ret = check_fmt(ops, p->type);
-			if (ret)
-				break;
-			ret = ops->vidioc_g_parm(file, fh, p);
-		} else {
-			v4l2_std_id std = vfd->current_norm;
-
-			ret = -EINVAL;
-			if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-				break;
-
-			ret = 0;
-			p->parm.capture.readbuffers = 2;
-			if (ops->vidioc_g_std)
-				ret = ops->vidioc_g_std(file, fh, &std);
-			if (ret == 0)
-				v4l2_video_std_frame_period(std,
-						    &p->parm.capture.timeperframe);
-		}
-
-		dbgarg(cmd, "type=%d\n", p->type);
-		break;
-	}
-	case VIDIOC_S_PARM:
-	{
-		struct v4l2_streamparm *p = arg;
-
-		ret = check_fmt(ops, p->type);
-		if (ret)
-			break;
-
-		dbgarg(cmd, "type=%d\n", p->type);
-		ret = ops->vidioc_s_parm(file, fh, p);
-		break;
-	}
 	case VIDIOC_G_SLICED_VBI_CAP:
 	{
 		struct v4l2_sliced_vbi_cap *p = arg;
@@ -2052,32 +2093,6 @@ static long __video_do_ioctl(struct file *file,
 		dbgarg(cmd, "type=0x%8.8x", sub->type);
 		break;
 	}
-	case VIDIOC_CREATE_BUFS:
-	{
-		struct v4l2_create_buffers *create = arg;
-
-		ret = check_fmt(ops, create->format.type);
-		if (ret)
-			break;
-
-		ret = ops->vidioc_create_bufs(file, fh, create);
-
-		dbgarg(cmd, "count=%d @ %d\n", create->count, create->index);
-		break;
-	}
-	case VIDIOC_PREPARE_BUF:
-	{
-		struct v4l2_buffer *b = arg;
-
-		ret = check_fmt(ops, b->type);
-		if (ret)
-			break;
-
-		ret = ops->vidioc_prepare_buf(file, fh, b);
-
-		dbgarg(cmd, "index=%d", b->index);
-		break;
-	}
 	default:
 		if (!ops->vidioc_default)
 			break;
-- 
1.7.10


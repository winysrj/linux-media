Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20556 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0LVNky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 08:40:54 -0500
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDU002LA0O2N1@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU000910O20G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Date: Wed, 22 Dec 2010 14:40:35 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 05/13] v4l: v4l2-ioctl: add buffer type conversion for
 multi-planar-aware ioctls
In-reply-to: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293025239-9977-6-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Pawel Osciak <pawel@osciak.com>

Drivers that support only one variant of API - single- or multi-planar -
can still be used by applications that support the other variant in most
cases. This adds a conversion layer for buffer types for such situations.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |  206 +++++++++++++++++++++++++++++++++----
 1 files changed, 183 insertions(+), 23 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 5d46aa2..fee8b94 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -605,27 +605,21 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		if (ops->vidioc_g_fmt_vid_cap ||
 				ops->vidioc_g_fmt_vid_cap_mplane)
 			return 0;
 		break;
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-		if (ops->vidioc_g_fmt_vid_cap_mplane)
-			return 0;
-		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 		if (ops->vidioc_g_fmt_vid_overlay)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		if (ops->vidioc_g_fmt_vid_out ||
 				ops->vidioc_g_fmt_vid_out_mplane)
 			return 0;
 		break;
-	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-		if (ops->vidioc_g_fmt_vid_out_mplane)
-			return 0;
-		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 		if (ops->vidioc_g_fmt_vid_out_overlay)
 			return 0;
@@ -654,6 +648,64 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+static enum v4l2_buf_type convert_type(const struct v4l2_ioctl_ops *ops,
+					enum v4l2_buf_type type)
+{
+	if (ops == NULL)
+		return type;
+
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (!ops->vidioc_g_fmt_vid_cap
+				&& ops->vidioc_g_fmt_vid_cap_mplane)
+			return V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (!ops->vidioc_g_fmt_vid_cap_mplane
+				&& ops->vidioc_g_fmt_vid_cap)
+			return V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (!ops->vidioc_g_fmt_vid_out
+				&& ops->vidioc_g_fmt_vid_out_mplane)
+			return V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (!ops->vidioc_g_fmt_vid_out_mplane
+				&& ops->vidioc_g_fmt_vid_out)
+			return V4L2_BUF_TYPE_VIDEO_OUTPUT;
+		break;
+	default:
+		break;
+	}
+
+	return type;
+}
+
+static int type_sp_to_mp(enum v4l2_buf_type t_sp, enum v4l2_buf_type *t_mp)
+{
+	if (t_sp == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		*t_mp = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	else if (t_sp == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		*t_mp = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int type_mp_to_sp(enum v4l2_buf_type t_mp, enum v4l2_buf_type *t_sp)
+{
+	if (t_mp == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		*t_sp = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	else if (t_mp == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		*t_sp = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * fmt_sp_to_mp() - Convert a single-plane format to its multi-planar 1-plane
  * equivalent
@@ -663,13 +715,11 @@ static int fmt_sp_to_mp(const struct v4l2_format *f_sp,
 {
 	struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
 	const struct v4l2_pix_format *pix = &f_sp->fmt.pix;
+	int ret;
 
-	if (f_sp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		f_mp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	else if (f_sp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
-		f_mp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	else
-		return -EINVAL;
+	ret = type_sp_to_mp(f_sp->type, &f_mp->type);
+	if (ret)
+		return ret;
 
 	pix_mp->width = pix->width;
 	pix_mp->height = pix->height;
@@ -692,13 +742,11 @@ static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
 {
 	const struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
 	struct v4l2_pix_format *pix = &f_sp->fmt.pix;
+	int ret;
 
-	if (f_mp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		f_sp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	else if (f_mp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		f_sp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	else
-		return -EINVAL;
+	ret = type_mp_to_sp(f_mp->type, &f_sp->type);
+	if (ret)
+		return ret;
 
 	pix->width = pix_mp->width;
 	pix->height = pix_mp->height;
@@ -711,6 +759,48 @@ static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
 	return 0;
 }
 
+static int buf_sp_to_mp(const struct v4l2_buffer *b_sp,
+			struct v4l2_buffer *b_mp)
+{
+	int ret;
+
+	memcpy(b_mp, b_sp, sizeof *b_mp);
+	ret = type_sp_to_mp(b_sp->type, &b_mp->type);
+	if (ret)
+		return ret;
+	b_mp->m.planes[0].length = b_sp->length;
+	b_mp->m.planes[0].bytesused = b_mp->bytesused;
+	b_mp->length = 1;
+	memcpy(&b_mp->m.planes[0].m, &b_sp->m, sizeof(struct v4l2_plane));
+
+	return 0;
+}
+
+static int buf_mp_to_sp(const struct v4l2_buffer *b_mp,
+			struct v4l2_buffer *b_sp)
+{
+	int ret;
+
+	memcpy(b_sp, b_mp, sizeof *b_sp);
+	ret = type_mp_to_sp(b_mp->type, &b_sp->type);
+	if (ret)
+		return ret;
+	b_sp->length = b_mp->m.planes[0].length;
+	b_sp->bytesused = b_mp->m.planes[0].bytesused;
+	memcpy(&b_sp->m, &b_mp->m.planes[0].m, sizeof(struct v4l2_plane));
+
+	return 0;
+}
+
+static int convert_buffer(const struct v4l2_buffer *b_src,
+				struct v4l2_buffer *b_dst)
+{
+	if (V4L2_TYPE_IS_MULTIPLANAR(b_src->type))
+		return buf_mp_to_sp(b_src, b_dst);
+	else
+		return buf_sp_to_mp(b_src, b_dst);
+}
+
 static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
@@ -718,6 +808,9 @@ static long __video_do_ioctl(struct file *file,
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	void *fh = file->private_data;
 	struct v4l2_format f_copy;
+	enum v4l2_buf_type old_type;
+	struct v4l2_buffer buf_copy;
+	struct v4l2_plane buf_copy_planes[VIDEO_MAX_PLANES];
 	long ret = -EINVAL;
 
 	if (ops == NULL) {
@@ -726,6 +819,8 @@ static long __video_do_ioctl(struct file *file,
 		return -EINVAL;
 	}
 
+	buf_copy.m.planes = buf_copy_planes;
+
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 	/********************************************************
 	 All other V4L1 calls are handled by v4l1_compat module.
@@ -1241,11 +1336,15 @@ static long __video_do_ioctl(struct file *file,
 		if (p->type < V4L2_BUF_TYPE_PRIVATE)
 			CLEAR_AFTER_FIELD(p, memory);
 
+		old_type = p->type;
+		p->type = convert_type(ops, p->type);
+
 		ret = ops->vidioc_reqbufs(file, fh, p);
 		dbgarg(cmd, "count=%d, type=%s, memory=%s\n",
 				p->count,
 				prt_names(p->type, v4l2_type_names),
 				prt_names(p->memory, v4l2_memory_names));
+		p->type = old_type;
 		break;
 	}
 	case VIDIOC_QUERYBUF:
@@ -1258,7 +1357,17 @@ static long __video_do_ioctl(struct file *file,
 		if (ret)
 			break;
 
-		ret = ops->vidioc_querybuf(file, fh, p);
+		buf_copy.type = convert_type(ops, p->type);
+		if (p->type != buf_copy.type) {
+			ret = convert_buffer(p, &buf_copy);
+			if (ret)
+				break;
+			ret = ops->vidioc_querybuf(file, fh, &buf_copy);
+			if (!ret)
+				ret = convert_buffer(&buf_copy, p);
+		} else {
+			ret = ops->vidioc_querybuf(file, fh, p);
+		}
 		if (!ret)
 			dbgbuf(cmd, vfd, p);
 		break;
@@ -1273,7 +1382,17 @@ static long __video_do_ioctl(struct file *file,
 		if (ret)
 			break;
 
-		ret = ops->vidioc_qbuf(file, fh, p);
+		buf_copy.type = convert_type(ops, p->type);
+		if (p->type != buf_copy.type) {
+			ret = convert_buffer(p, &buf_copy);
+			if (ret)
+				break;
+			ret = ops->vidioc_qbuf(file, fh, &buf_copy);
+			if (!ret)
+				ret = convert_buffer(&buf_copy, p);
+		} else {
+			ret = ops->vidioc_qbuf(file, fh, p);
+		}
 		if (!ret)
 			dbgbuf(cmd, vfd, p);
 		break;
@@ -1288,7 +1407,17 @@ static long __video_do_ioctl(struct file *file,
 		if (ret)
 			break;
 
-		ret = ops->vidioc_dqbuf(file, fh, p);
+		buf_copy.type = convert_type(ops, p->type);
+		if (p->type != buf_copy.type) {
+			ret = convert_buffer(p, &buf_copy);
+			if (ret)
+				break;
+			ret = ops->vidioc_dqbuf(file, fh, &buf_copy);
+			if (!ret)
+				ret = convert_buffer(&buf_copy, p);
+		} else {
+			ret = ops->vidioc_dqbuf(file, fh, p);
+		}
 		if (!ret)
 			dbgbuf(cmd, vfd, p);
 		break;
@@ -1337,6 +1466,9 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_streamon)
 			break;
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
+
+		i = convert_type(ops, i);
+
 		ret = ops->vidioc_streamon(file, fh, i);
 		break;
 	}
@@ -1347,6 +1479,9 @@ static long __video_do_ioctl(struct file *file,
 		if (!ops->vidioc_streamoff)
 			break;
 		dbgarg(cmd, "type=%s\n", prt_names(i, v4l2_type_names));
+
+		i = convert_type(ops, i);
+
 		ret = ops->vidioc_streamoff(file, fh, i);
 		break;
 	}
@@ -1811,9 +1946,14 @@ static long __video_do_ioctl(struct file *file,
 			break;
 
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		old_type = p->type;
+		p->type = convert_type(ops, p->type);
+
 		ret = ops->vidioc_g_crop(file, fh, p);
 		if (!ret)
 			dbgrect(vfd, "", &p->c);
+		p->type = old_type;
 		break;
 	}
 	case VIDIOC_S_CROP:
@@ -1824,7 +1964,12 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
 		dbgrect(vfd, "", &p->c);
+
+		old_type = p->type;
+		p->type = convert_type(ops, p->type);
+
 		ret = ops->vidioc_s_crop(file, fh, p);
+		p->type = old_type;
 		break;
 	}
 	case VIDIOC_CROPCAP:
@@ -1836,11 +1981,16 @@ static long __video_do_ioctl(struct file *file,
 			break;
 
 		dbgarg(cmd, "type=%s\n", prt_names(p->type, v4l2_type_names));
+
+		old_type = p->type;
+		p->type = convert_type(ops, p->type);
+
 		ret = ops->vidioc_cropcap(file, fh, p);
 		if (!ret) {
 			dbgrect(vfd, "bounds ", &p->bounds);
 			dbgrect(vfd, "defrect ", &p->defrect);
 		}
+		p->type = old_type;
 		break;
 	}
 	case VIDIOC_G_JPEGCOMP:
@@ -1914,7 +2064,12 @@ static long __video_do_ioctl(struct file *file,
 			ret = check_fmt(ops, p->type);
 			if (ret)
 				break;
+
+			old_type = p->type;
+			p->type = convert_type(ops, p->type);
+
 			ret = ops->vidioc_g_parm(file, fh, p);
+			p->type = old_type;
 		} else {
 			v4l2_std_id std = vfd->current_norm;
 
@@ -1945,7 +2100,12 @@ static long __video_do_ioctl(struct file *file,
 			break;
 
 		dbgarg(cmd, "type=%d\n", p->type);
+
+		old_type = p->type;
+		p->type = convert_type(ops, p->type);
+
 		ret = ops->vidioc_s_parm(file, fh, p);
+		p->type = old_type;
 		break;
 	}
 	case VIDIOC_G_TUNER:
-- 
1.7.1.569.g6f426


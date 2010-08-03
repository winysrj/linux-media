Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33990 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab0HCOSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 10:18:47 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L6K004OHYF8TW00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Aug 2010 15:18:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L6K002SLYF75P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Aug 2010 15:18:44 +0100 (BST)
Date: Tue, 03 Aug 2010 16:18:25 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v6 2/3] v4l: Add multi-planar ioctl handling code
In-reply-to: <1280845106-5761-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, t.fujak@samsung.com
Message-id: <1280845106-5761-3-git-send-email-p.osciak@samsung.com>
References: <1280845106-5761-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add multi-planar API core ioctl handling and conversion functions.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/video/v4l2-ioctl.c |  418 ++++++++++++++++++++++++++++++++++----
 include/media/v4l2-ioctl.h       |   16 ++
 2 files changed, 390 insertions(+), 44 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index a830bbd..193392d 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -476,20 +476,33 @@ static void dbgbuf(unsigned int cmd, struct video_device *vfd,
 					struct v4l2_buffer *p)
 {
 	struct v4l2_timecode *tc = &p->timecode;
+	struct v4l2_plane *plane;
+	int i;
 
 	dbgarg(cmd, "%02ld:%02d:%02d.%08ld index=%d, type=%s, "
-		"bytesused=%d, flags=0x%08d, "
-		"field=%0d, sequence=%d, memory=%s, offset/userptr=0x%08lx, length=%d\n",
+		"flags=0x%08d, field=%0d, sequence=%d, memory=%s\n",
 			p->timestamp.tv_sec / 3600,
 			(int)(p->timestamp.tv_sec / 60) % 60,
 			(int)(p->timestamp.tv_sec % 60),
 			(long)p->timestamp.tv_usec,
 			p->index,
 			prt_names(p->type, v4l2_type_names),
-			p->bytesused, p->flags,
-			p->field, p->sequence,
-			prt_names(p->memory, v4l2_memory_names),
-			p->m.userptr, p->length);
+			p->flags, p->field, p->sequence,
+			prt_names(p->memory, v4l2_memory_names));
+
+	if (V4L2_TYPE_IS_MULTIPLANAR(p->type) && p->m.planes) {
+		for (i = 0; i < p->length; ++i) {
+			plane = &p->m.planes[i];
+			dbgarg2("plane %d: bytesused=%d, data_offset=0x%08x "
+				"offset/userptr=0x%08lx, length=%d\n",
+				i, plane->bytesused, plane->data_offset,
+				plane->m.userptr, plane->length);
+		}
+	} else {
+		dbgarg2("bytesused=%d, offset/userptr=0x%08lx, length=%d\n",
+			p->bytesused, p->m.userptr, p->length);
+	}
+
 	dbgarg2("timecode=%02d:%02d:%02d type=%d, "
 		"flags=0x%08d, frames=%d, userbits=0x%08x\n",
 			tc->hours, tc->minutes, tc->seconds,
@@ -517,6 +530,27 @@ static inline void v4l_print_pix_fmt(struct video_device *vfd,
 		fmt->bytesperline, fmt->sizeimage, fmt->colorspace);
 };
 
+static inline void v4l_print_pix_fmt_mplane(struct video_device *vfd,
+					    struct v4l2_pix_format_mplane *fmt)
+{
+	int i;
+
+	dbgarg2("width=%d, height=%d, format=%c%c%c%c, field=%s, "
+		"colorspace=%d, num_planes=%d\n",
+		fmt->width, fmt->height,
+		(fmt->pixelformat & 0xff),
+		(fmt->pixelformat >>  8) & 0xff,
+		(fmt->pixelformat >> 16) & 0xff,
+		(fmt->pixelformat >> 24) & 0xff,
+		prt_names(fmt->field, v4l2_field_names),
+		fmt->colorspace, fmt->num_planes);
+
+	for (i = 0; i < fmt->num_planes; ++i)
+		dbgarg2("plane %d: bytesperline=%d sizeimage=%d\n", i,
+			fmt->plane_fmt[i].bytesperline,
+			fmt->plane_fmt[i].sizeimage);
+}
+
 static inline void v4l_print_ext_ctrls(unsigned int cmd,
 	struct video_device *vfd, struct v4l2_ext_controls *c, int show_vals)
 {
@@ -570,7 +604,12 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (ops->vidioc_g_fmt_vid_cap)
+		if (ops->vidioc_g_fmt_vid_cap ||
+				ops->vidioc_g_fmt_vid_cap_mplane)
+			return 0;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (ops->vidioc_g_fmt_vid_cap_mplane)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
@@ -578,7 +617,12 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-		if (ops->vidioc_g_fmt_vid_out)
+		if (ops->vidioc_g_fmt_vid_out ||
+				ops->vidioc_g_fmt_vid_out_mplane)
+			return 0;
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (ops->vidioc_g_fmt_vid_out_mplane)
 			return 0;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
@@ -609,12 +653,70 @@ static int check_fmt(const struct v4l2_ioctl_ops *ops, enum v4l2_buf_type type)
 	return -EINVAL;
 }
 
+/**
+ * fmt_sp_to_mp() - Convert a single-plane format to its multi-planar 1-plane
+ * equivalent
+ */
+static int fmt_sp_to_mp(const struct v4l2_format *f_sp,
+			struct v4l2_format *f_mp)
+{
+	struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
+	const struct v4l2_pix_format *pix = &f_sp->fmt.pix;
+
+	if (f_sp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		f_mp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	else if (f_sp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		f_mp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	else
+		return -EINVAL;
+
+	pix_mp->width = pix->width;
+	pix_mp->height = pix->height;
+	pix_mp->pixelformat = pix->pixelformat;
+	pix_mp->field = pix->field;
+	pix_mp->colorspace = pix->colorspace;
+	pix_mp->num_planes = 1;
+	pix_mp->plane_fmt[0].sizeimage = pix->sizeimage;
+	pix_mp->plane_fmt[0].bytesperline = pix->bytesperline;
+
+	return 0;
+}
+
+/**
+ * fmt_mp_to_sp() - Convert a multi-planar 1-plane format to its single-planar
+ * equivalent
+ */
+static int fmt_mp_to_sp(const struct v4l2_format *f_mp,
+			struct v4l2_format *f_sp)
+{
+	const struct v4l2_pix_format_mplane *pix_mp = &f_mp->fmt.pix_mp;
+	struct v4l2_pix_format *pix = &f_sp->fmt.pix;
+
+	if (f_mp->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		f_sp->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	else if (f_mp->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		f_sp->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	else
+		return -EINVAL;
+
+	pix->width = pix_mp->width;
+	pix->height = pix_mp->height;
+	pix->pixelformat = pix_mp->pixelformat;
+	pix->field = pix_mp->field;
+	pix->colorspace = pix_mp->colorspace;
+	pix->sizeimage = pix_mp->plane_fmt[0].sizeimage;
+	pix->bytesperline = pix_mp->plane_fmt[0].bytesperline;
+
+	return 0;
+}
+
 static long __video_do_ioctl(struct file *file,
 		unsigned int cmd, void *arg)
 {
 	struct video_device *vfd = video_devdata(file);
 	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
 	void *fh = file->private_data;
+	struct v4l2_format f_copy;
 	long ret = -EINVAL;
 
 	if (ops == NULL) {
@@ -720,6 +822,11 @@ static long __video_do_ioctl(struct file *file,
 			if (ops->vidioc_enum_fmt_vid_cap)
 				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+			if (ops->vidioc_enum_fmt_vid_cap_mplane)
+				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
+									fh, f);
+			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			if (ops->vidioc_enum_fmt_vid_overlay)
 				ret = ops->vidioc_enum_fmt_vid_overlay(file,
@@ -729,6 +836,11 @@ static long __video_do_ioctl(struct file *file,
 			if (ops->vidioc_enum_fmt_vid_out)
 				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+			if (ops->vidioc_enum_fmt_vid_out_mplane)
+				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
+									fh, f);
+			break;
 		case V4L2_BUF_TYPE_PRIVATE:
 			if (ops->vidioc_enum_fmt_type_private)
 				ret = ops->vidioc_enum_fmt_type_private(file,
@@ -757,22 +869,79 @@ static long __video_do_ioctl(struct file *file,
 
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			if (ops->vidioc_g_fmt_vid_cap)
+			if (ops->vidioc_g_fmt_vid_cap) {
 				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
+			} else if (ops->vidioc_g_fmt_vid_cap_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh,
+								       &f_copy);
+				/* Driver is currently in multi-planar format,
+				 * we can't return it in single-planar API*/
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					ret = -EBUSY;
+					break;
+				}
+
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+			if (ops->vidioc_g_fmt_vid_cap_mplane) {
+				ret = ops->vidioc_g_fmt_vid_cap_mplane(file,
+									fh, f);
+			} else if (ops->vidioc_g_fmt_vid_cap) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_g_fmt_vid_cap(file,
+								fh, &f_copy);
+				ret = fmt_sp_to_mp(&f_copy, f);
+			}
+			if (!ret)
+				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			if (ops->vidioc_g_fmt_vid_overlay)
 				ret = ops->vidioc_g_fmt_vid_overlay(file,
 								    fh, f);
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (ops->vidioc_g_fmt_vid_out)
+			if (ops->vidioc_g_fmt_vid_out) {
 				ret = ops->vidioc_g_fmt_vid_out(file, fh, f);
+			} else if (ops->vidioc_g_fmt_vid_out_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh,
+									&f_copy);
+				/* Driver is currently in multi-planar format,
+				 * we can't return it in single-planar API*/
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					ret = -EBUSY;
+					break;
+				}
+
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+			if (ops->vidioc_g_fmt_vid_out_mplane) {
+				ret = ops->vidioc_g_fmt_vid_out_mplane(file,
+									fh, f);
+			} else if (ops->vidioc_g_fmt_vid_out) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_g_fmt_vid_out(file,
+								fh, &f_copy);
+				ret = fmt_sp_to_mp(&f_copy, f);
+
+			}
+			if (!ret)
+				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 			if (ops->vidioc_g_fmt_vid_out_overlay)
 				ret = ops->vidioc_g_fmt_vid_out_overlay(file,
@@ -816,8 +985,38 @@ static long __video_do_ioctl(struct file *file,
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_cap)
+			if (ops->vidioc_s_fmt_vid_cap) {
 				ret = ops->vidioc_s_fmt_vid_cap(file, fh, f);
+			} else if (ops->vidioc_s_fmt_vid_cap_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_s_fmt_vid_cap_mplane(file, fh,
+									&f_copy);
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					/* Drivers shouldn't adjust from 1-plane
+					 * to more than 1-plane formats */
+					ret = -EBUSY;
+					WARN_ON(1);
+					break;
+				}
+
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
+			break;
+		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
+			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			if (ops->vidioc_s_fmt_vid_cap_mplane) {
+				ret = ops->vidioc_s_fmt_vid_cap_mplane(file,
+									fh, f);
+			} else if (ops->vidioc_s_fmt_vid_cap &&
+					f->fmt.pix_mp.num_planes == 1) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_s_fmt_vid_cap(file,
+								fh, &f_copy);
+				ret = fmt_sp_to_mp(&f_copy, f);
+			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
@@ -828,8 +1027,38 @@ static long __video_do_ioctl(struct file *file,
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
 			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_out)
+			if (ops->vidioc_s_fmt_vid_out) {
 				ret = ops->vidioc_s_fmt_vid_out(file, fh, f);
+			} else if (ops->vidioc_s_fmt_vid_out_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_s_fmt_vid_out_mplane(file, fh,
+									&f_copy);
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					/* Drivers shouldn't adjust from 1-plane
+					 * to more than 1-plane formats */
+					ret = -EBUSY;
+					WARN_ON(1);
+					break;
+				}
+
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
+			break;
+		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
+			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			if (ops->vidioc_s_fmt_vid_out_mplane) {
+				ret = ops->vidioc_s_fmt_vid_out_mplane(file,
+									fh, f);
+			} else if (ops->vidioc_s_fmt_vid_out &&
+					f->fmt.pix_mp.num_planes == 1) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_s_fmt_vid_out(file,
+								fh, &f_copy);
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
@@ -878,11 +1107,41 @@ static long __video_do_ioctl(struct file *file,
 		switch (f->type) {
 		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_cap)
+			if (ops->vidioc_try_fmt_vid_cap) {
 				ret = ops->vidioc_try_fmt_vid_cap(file, fh, f);
+			} else if (ops->vidioc_try_fmt_vid_cap_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_try_fmt_vid_cap_mplane(file,
+								fh, &f_copy);
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					/* Drivers shouldn't adjust from 1-plane
+					 * to more than 1-plane formats */
+					ret = -EBUSY;
+					WARN_ON(1);
+					break;
+				}
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
+			if (ops->vidioc_try_fmt_vid_cap_mplane) {
+				ret = ops->vidioc_try_fmt_vid_cap_mplane(file,
+									 fh, f);
+			} else if (ops->vidioc_try_fmt_vid_cap &&
+					f->fmt.pix_mp.num_planes == 1) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_try_fmt_vid_cap(file,
+								  fh, &f_copy);
+				ret = fmt_sp_to_mp(&f_copy, f);
+			}
+			if (!ret)
+				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			break;
 		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_try_fmt_vid_overlay)
@@ -891,11 +1150,41 @@ static long __video_do_ioctl(struct file *file,
 			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_out)
+			if (ops->vidioc_try_fmt_vid_out) {
 				ret = ops->vidioc_try_fmt_vid_out(file, fh, f);
+			} else if (ops->vidioc_try_fmt_vid_out_mplane) {
+				if (fmt_sp_to_mp(f, &f_copy))
+					break;
+				ret = ops->vidioc_try_fmt_vid_out_mplane(file,
+								fh, &f_copy);
+				if (!ret && f_copy.fmt.pix_mp.num_planes > 1) {
+					/* Drivers shouldn't adjust from 1-plane
+					 * to more than 1-plane formats */
+					ret = -EBUSY;
+					WARN_ON(1);
+					break;
+				}
+				ret = fmt_mp_to_sp(&f_copy, f);
+			}
 			if (!ret)
 				v4l_print_pix_fmt(vfd, &f->fmt.pix);
 			break;
+		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
+			if (ops->vidioc_try_fmt_vid_out_mplane) {
+				ret = ops->vidioc_try_fmt_vid_out_mplane(file,
+									 fh, f);
+			} else if (ops->vidioc_try_fmt_vid_out &&
+					f->fmt.pix_mp.num_planes == 1) {
+				if (fmt_mp_to_sp(f, &f_copy))
+					break;
+				ret = ops->vidioc_try_fmt_vid_out(file,
+								  fh, &f_copy);
+				ret = fmt_sp_to_mp(&f_copy, f);
+			}
+			if (!ret)
+				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
+			break;
 		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
 			CLEAR_AFTER_FIELD(f, fmt.win);
 			if (ops->vidioc_try_fmt_vid_out_overlay)
@@ -2037,7 +2326,7 @@ static unsigned long cmd_input_size(unsigned int cmd)
 	switch (cmd) {
 		CMDINSIZE(ENUM_FMT,		fmtdesc,	type);
 		CMDINSIZE(G_FMT,		format,		type);
-		CMDINSIZE(QUERYBUF,		buffer,		type);
+		CMDINSIZE(QUERYBUF,		buffer,		length);
 		CMDINSIZE(G_PARM,		streamparm,	type);
 		CMDINSIZE(ENUMSTD,		standard,	index);
 		CMDINSIZE(ENUMINPUT,		input,		index);
@@ -2062,6 +2351,49 @@ static unsigned long cmd_input_size(unsigned int cmd)
 	}
 }
 
+static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
+			    void * __user *user_ptr, void ***kernel_ptr)
+{
+	int ret = 0;
+
+	switch(cmd) {
+	case VIDIOC_QUERYBUF:
+	case VIDIOC_QBUF:
+	case VIDIOC_DQBUF: {
+		struct v4l2_buffer *buf = parg;
+
+		if (V4L2_TYPE_IS_MULTIPLANAR(buf->type) && buf->length > 0) {
+			if (buf->length > VIDEO_MAX_PLANES) {
+				ret = -EINVAL;
+				break;
+			}
+			*user_ptr = (void __user *)buf->m.planes;
+			*kernel_ptr = (void **)&buf->m.planes;
+			*array_size = sizeof(struct v4l2_plane) * buf->length;
+			ret = 1;
+		}
+		break;
+	}
+
+	case VIDIOC_S_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS:
+	case VIDIOC_TRY_EXT_CTRLS: {
+		struct v4l2_ext_controls *ctrls = parg;
+
+		if (ctrls->count != 0) {
+			*user_ptr = (void __user *)ctrls->controls;
+			*kernel_ptr = (void **)&ctrls->controls;
+			*array_size = sizeof(struct v4l2_ext_control)
+				    * ctrls->count;
+			ret = 1;
+		}
+		break;
+	}
+	}
+
+	return ret;
+}
+
 long video_ioctl2(struct file *file,
 	       unsigned int cmd, unsigned long arg)
 {
@@ -2069,16 +2401,14 @@ long video_ioctl2(struct file *file,
 	void    *mbuf = NULL;
 	void	*parg = (void *)arg;
 	long	err  = -EINVAL;
-	int     is_ext_ctrl;
-	size_t  ctrls_size = 0;
+	bool	has_array_args;
+	size_t  array_size = 0;
 	void __user *user_ptr = NULL;
+	void	**kernel_ptr = NULL;
 
 #ifdef __OLD_VIDIOC_
 	cmd = video_fix_command(cmd);
 #endif
-	is_ext_ctrl = (cmd == VIDIOC_S_EXT_CTRLS || cmd == VIDIOC_G_EXT_CTRLS ||
-		       cmd == VIDIOC_TRY_EXT_CTRLS);
-
 	/*  Copy arguments into temp kernel buffer  */
 	if (_IOC_DIR(cmd) != _IOC_NONE) {
 		if (_IOC_SIZE(cmd) <= sizeof(sbuf)) {
@@ -2107,43 +2437,43 @@ long video_ioctl2(struct file *file,
 		}
 	}
 
-	if (is_ext_ctrl) {
-		struct v4l2_ext_controls *p = parg;
+	err = check_array_args(cmd, parg, &array_size, &user_ptr, &kernel_ptr);
+	if (err < 0)
+		goto out;
+	has_array_args = err;
 
-		/* In case of an error, tell the caller that it wasn't
-		   a specific control that caused it. */
-		p->error_idx = p->count;
-		user_ptr = (void __user *)p->controls;
-		if (p->count) {
-			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
-			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
-			mbuf = kmalloc(ctrls_size, GFP_KERNEL);
-			err = -ENOMEM;
-			if (NULL == mbuf)
-				goto out_ext_ctrl;
-			err = -EFAULT;
-			if (copy_from_user(mbuf, user_ptr, ctrls_size))
-				goto out_ext_ctrl;
-			p->controls = mbuf;
-		}
+	if (has_array_args) {
+		/*
+		 * When adding new types of array args, make sure that the
+		 * parent argument to ioctl (which contains the pointer to the
+		 * array) fits into sbuf (so that mbuf will still remain
+		 * unused up to here).
+		 */
+		mbuf = kmalloc(array_size, GFP_KERNEL);
+		err = -ENOMEM;
+		if (NULL == mbuf)
+			goto out_array_args;
+		err = -EFAULT;
+		if (copy_from_user(mbuf, user_ptr, array_size))
+			goto out_array_args;
+		*kernel_ptr = mbuf;
 	}
 
 	/* Handles IOCTL */
 	err = __video_do_ioctl(file, cmd, parg);
 	if (err == -ENOIOCTLCMD)
 		err = -EINVAL;
-	if (is_ext_ctrl) {
-		struct v4l2_ext_controls *p = parg;
 
-		p->controls = (void *)user_ptr;
-		if (p->count && err == 0 && copy_to_user(user_ptr, mbuf, ctrls_size))
+	if (has_array_args) {
+		*kernel_ptr = user_ptr;
+		if (copy_to_user(user_ptr, mbuf, array_size))
 			err = -EFAULT;
-		goto out_ext_ctrl;
+		goto out_array_args;
 	}
 	if (err < 0)
 		goto out;
 
-out_ext_ctrl:
+out_array_args:
 	/*  Copy results into user buffer  */
 	switch (_IOC_DIR(cmd)) {
 	case _IOC_READ:
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 06daa6e..9ea2b0e 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -42,6 +42,10 @@ struct v4l2_ioctl_ops {
 					    struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_vid_out)     (struct file *file, void *fh,
 					    struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_vid_cap_mplane)(struct file *file, void *fh,
+					      struct v4l2_fmtdesc *f);
+	int (*vidioc_enum_fmt_vid_out_mplane)(struct file *file, void *fh,
+					      struct v4l2_fmtdesc *f);
 	int (*vidioc_enum_fmt_type_private)(struct file *file, void *fh,
 					    struct v4l2_fmtdesc *f);
 
@@ -62,6 +66,10 @@ struct v4l2_ioctl_ops {
 					struct v4l2_format *f);
 	int (*vidioc_g_fmt_sliced_vbi_out)(struct file *file, void *fh,
 					struct v4l2_format *f);
+	int (*vidioc_g_fmt_vid_cap_mplane)(struct file *file, void *fh,
+					   struct v4l2_format *f);
+	int (*vidioc_g_fmt_vid_out_mplane)(struct file *file, void *fh,
+					   struct v4l2_format *f);
 	int (*vidioc_g_fmt_type_private)(struct file *file, void *fh,
 					struct v4l2_format *f);
 
@@ -82,6 +90,10 @@ struct v4l2_ioctl_ops {
 					struct v4l2_format *f);
 	int (*vidioc_s_fmt_sliced_vbi_out)(struct file *file, void *fh,
 					struct v4l2_format *f);
+	int (*vidioc_s_fmt_vid_cap_mplane)(struct file *file, void *fh,
+					   struct v4l2_format *f);
+	int (*vidioc_s_fmt_vid_out_mplane)(struct file *file, void *fh,
+					   struct v4l2_format *f);
 	int (*vidioc_s_fmt_type_private)(struct file *file, void *fh,
 					struct v4l2_format *f);
 
@@ -102,6 +114,10 @@ struct v4l2_ioctl_ops {
 					  struct v4l2_format *f);
 	int (*vidioc_try_fmt_sliced_vbi_out)(struct file *file, void *fh,
 					  struct v4l2_format *f);
+	int (*vidioc_try_fmt_vid_cap_mplane)(struct file *file, void *fh,
+					     struct v4l2_format *f);
+	int (*vidioc_try_fmt_vid_out_mplane)(struct file *file, void *fh,
+					     struct v4l2_format *f);
 	int (*vidioc_try_fmt_type_private)(struct file *file, void *fh,
 					  struct v4l2_format *f);
 
-- 
1.7.1.569.g6f426


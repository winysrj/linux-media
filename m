Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4115 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab2F1Gsw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 07/33] v4l2-ioctl.c: use the new table for format/framebuffer ioctls.
Date: Thu, 28 Jun 2012 08:48:01 +0200
Message-Id: <8262f122721650d14872047d0b6697ca204af95c.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-ioctl.c |  692 +++++++++++++++++++-------------------
 1 file changed, 346 insertions(+), 346 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4029d12..25c0a8a 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -235,6 +235,130 @@ static void v4l_print_audioout(const void *arg, bool write_only)
 			p->index, p->name, p->capability, p->mode);
 }
 
+static void v4l_print_fmtdesc(const void *arg, bool write_only)
+{
+	const struct v4l2_fmtdesc *p = arg;
+
+	pr_cont("index=%u, type=%s, flags=0x%x, pixelformat=%c%c%c%c, description='%s'\n",
+		p->index, prt_names(p->type, v4l2_type_names),
+		p->flags, (p->pixelformat & 0xff),
+		(p->pixelformat >>  8) & 0xff,
+		(p->pixelformat >> 16) & 0xff,
+		(p->pixelformat >> 24) & 0xff,
+		p->description);
+}
+
+static void v4l_print_format(const void *arg, bool write_only)
+{
+	const struct v4l2_format *p = arg;
+	const struct v4l2_pix_format *pix;
+	const struct v4l2_pix_format_mplane *mp;
+	const struct v4l2_vbi_format *vbi;
+	const struct v4l2_sliced_vbi_format *sliced;
+	const struct v4l2_window *win;
+	const struct v4l2_clip *clip;
+	unsigned i;
+
+	pr_cont("type=%s", prt_names(p->type, v4l2_type_names));
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		pix = &p->fmt.pix;
+		pr_cont(", width=%u, height=%u, "
+			"pixelformat=%c%c%c%c, field=%s, "
+			"bytesperline=%u sizeimage=%u, colorspace=%d\n",
+			pix->width, pix->height,
+			(pix->pixelformat & 0xff),
+			(pix->pixelformat >>  8) & 0xff,
+			(pix->pixelformat >> 16) & 0xff,
+			(pix->pixelformat >> 24) & 0xff,
+			prt_names(pix->field, v4l2_field_names),
+			pix->bytesperline, pix->sizeimage,
+			pix->colorspace);
+		break;
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		mp = &p->fmt.pix_mp;
+		pr_cont(", width=%u, height=%u, "
+			"format=%c%c%c%c, field=%s, "
+			"colorspace=%d, num_planes=%u\n",
+			mp->width, mp->height,
+			(mp->pixelformat & 0xff),
+			(mp->pixelformat >>  8) & 0xff,
+			(mp->pixelformat >> 16) & 0xff,
+			(mp->pixelformat >> 24) & 0xff,
+			prt_names(mp->field, v4l2_field_names),
+			mp->colorspace, mp->num_planes);
+		for (i = 0; i < mp->num_planes; i++)
+			printk(KERN_DEBUG "plane %u: bytesperline=%u sizeimage=%u\n", i,
+					mp->plane_fmt[i].bytesperline,
+					mp->plane_fmt[i].sizeimage);
+		break;
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		win = &p->fmt.win;
+		pr_cont(", wxh=%dx%d, x,y=%d,%d, field=%s, "
+			"chromakey=0x%08x, bitmap=%p, "
+			"global_alpha=0x%02x\n",
+			win->w.width, win->w.height,
+			win->w.left, win->w.top,
+			prt_names(win->field, v4l2_field_names),
+			win->chromakey, win->bitmap, win->global_alpha);
+		clip = win->clips;
+		for (i = 0; i < win->clipcount; i++) {
+			printk(KERN_DEBUG "clip %u: wxh=%dx%d, x,y=%d,%d\n",
+					i, clip->c.width, clip->c.height,
+					clip->c.left, clip->c.top);
+			clip = clip->next;
+		}
+		break;
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		vbi = &p->fmt.vbi;
+		pr_cont(", sampling_rate=%u, offset=%u, samples_per_line=%u, "
+			"sample_format=%c%c%c%c, start=%u,%u, count=%u,%u\n",
+			vbi->sampling_rate, vbi->offset,
+			vbi->samples_per_line,
+			(vbi->sample_format & 0xff),
+			(vbi->sample_format >>  8) & 0xff,
+			(vbi->sample_format >> 16) & 0xff,
+			(vbi->sample_format >> 24) & 0xff,
+			vbi->start[0], vbi->start[1],
+			vbi->count[0], vbi->count[1]);
+		break;
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		sliced = &p->fmt.sliced;
+		pr_cont(", service_set=0x%08x, io_size=%d\n",
+				sliced->service_set, sliced->io_size);
+		for (i = 0; i < 24; i++)
+			printk(KERN_DEBUG "line[%02u]=0x%04x, 0x%04x\n", i,
+				sliced->service_lines[0][i],
+				sliced->service_lines[1][i]);
+		break;
+	case V4L2_BUF_TYPE_PRIVATE:
+		pr_cont("\n");
+		break;
+	}
+}
+
+static void v4l_print_framebuffer(const void *arg, bool write_only)
+{
+	const struct v4l2_framebuffer *p = arg;
+
+	pr_cont("capability=0x%x, flags=0x%x, base=0x%p, width=%u, "
+		"height=%u, pixelformat=%c%c%c%c, "
+		"bytesperline=%u sizeimage=%u, colorspace=%d\n",
+			p->capability, p->flags, p->base,
+			p->fmt.width, p->fmt.height,
+			(p->fmt.pixelformat & 0xff),
+			(p->fmt.pixelformat >>  8) & 0xff,
+			(p->fmt.pixelformat >> 16) & 0xff,
+			(p->fmt.pixelformat >> 24) & 0xff,
+			p->fmt.bytesperline, p->fmt.sizeimage,
+			p->fmt.colorspace);
+}
+
 static void v4l_print_u32(const void *arg, bool write_only)
 {
 	pr_cont("value=%u\n", *(const u32 *)arg);
@@ -312,41 +436,6 @@ static void dbgtimings(struct video_device *vfd,
 	}
 }
 
-static inline void v4l_print_pix_fmt(struct video_device *vfd,
-						struct v4l2_pix_format *fmt)
-{
-	dbgarg2("width=%d, height=%d, format=%c%c%c%c, field=%s, "
-		"bytesperline=%d sizeimage=%d, colorspace=%d\n",
-		fmt->width, fmt->height,
-		(fmt->pixelformat & 0xff),
-		(fmt->pixelformat >>  8) & 0xff,
-		(fmt->pixelformat >> 16) & 0xff,
-		(fmt->pixelformat >> 24) & 0xff,
-		prt_names(fmt->field, v4l2_field_names),
-		fmt->bytesperline, fmt->sizeimage, fmt->colorspace);
-};
-
-static inline void v4l_print_pix_fmt_mplane(struct video_device *vfd,
-					    struct v4l2_pix_format_mplane *fmt)
-{
-	int i;
-
-	dbgarg2("width=%d, height=%d, format=%c%c%c%c, field=%s, "
-		"colorspace=%d, num_planes=%d\n",
-		fmt->width, fmt->height,
-		(fmt->pixelformat & 0xff),
-		(fmt->pixelformat >>  8) & 0xff,
-		(fmt->pixelformat >> 16) & 0xff,
-		(fmt->pixelformat >> 24) & 0xff,
-		prt_names(fmt->field, v4l2_field_names),
-		fmt->colorspace, fmt->num_planes);
-
-	for (i = 0; i < fmt->num_planes; ++i)
-		dbgarg2("plane %d: bytesperline=%d sizeimage=%d\n", i,
-			fmt->plane_fmt[i].bytesperline,
-			fmt->plane_fmt[i].sizeimage);
-}
-
 static inline void v4l_print_ext_ctrls(unsigned int cmd,
 	struct video_device *vfd, struct v4l2_ext_controls *c, int show_vals)
 {
@@ -539,6 +628,222 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	return ops->vidioc_enum_output(file, fh, p);
 }
 
+static int v4l_enum_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_fmtdesc *p = arg;
+
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (unlikely(!ops->vidioc_enum_fmt_vid_cap))
+			break;
+		return ops->vidioc_enum_fmt_vid_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (unlikely(!ops->vidioc_enum_fmt_vid_cap_mplane))
+			break;
+		return ops->vidioc_enum_fmt_vid_cap_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		if (unlikely(!ops->vidioc_enum_fmt_vid_overlay))
+			break;
+		return ops->vidioc_enum_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (unlikely(!ops->vidioc_enum_fmt_vid_out))
+			break;
+		return ops->vidioc_enum_fmt_vid_out(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (unlikely(!ops->vidioc_enum_fmt_vid_out_mplane))
+			break;
+		return ops->vidioc_enum_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_PRIVATE:
+		if (unlikely(!ops->vidioc_enum_fmt_type_private))
+			break;
+		return ops->vidioc_enum_fmt_type_private(file, fh, arg);
+	}
+	return -EINVAL;
+}
+
+static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_format *p = arg;
+
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (unlikely(!ops->vidioc_g_fmt_vid_cap))
+			break;
+		return ops->vidioc_g_fmt_vid_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (unlikely(!ops->vidioc_g_fmt_vid_cap_mplane))
+			break;
+		return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		if (unlikely(!ops->vidioc_g_fmt_vid_overlay))
+			break;
+		return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (unlikely(!ops->vidioc_g_fmt_vid_out))
+			break;
+		return ops->vidioc_g_fmt_vid_out(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (unlikely(!ops->vidioc_g_fmt_vid_out_mplane))
+			break;
+		return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		if (unlikely(!ops->vidioc_g_fmt_vid_out_overlay))
+			break;
+		return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_g_fmt_vbi_cap))
+			break;
+		return ops->vidioc_g_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_g_fmt_vbi_out))
+			break;
+		return ops->vidioc_g_fmt_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_g_fmt_sliced_vbi_cap))
+			break;
+		return ops->vidioc_g_fmt_sliced_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_g_fmt_sliced_vbi_out))
+			break;
+		return ops->vidioc_g_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_PRIVATE:
+		if (unlikely(!ops->vidioc_g_fmt_type_private))
+			break;
+		return ops->vidioc_g_fmt_type_private(file, fh, arg);
+	}
+	return -EINVAL;
+}
+
+static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_format *p = arg;
+
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (unlikely(!ops->vidioc_s_fmt_vid_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix);
+		return ops->vidioc_s_fmt_vid_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.win);
+		return ops->vidioc_s_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (unlikely(!ops->vidioc_s_fmt_vid_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix);
+		return ops->vidioc_s_fmt_vid_out(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.win);
+		return ops->vidioc_s_fmt_vid_out_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_s_fmt_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_s_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_s_fmt_vbi_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_s_fmt_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_s_fmt_sliced_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_s_fmt_sliced_vbi_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_s_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_PRIVATE:
+		if (unlikely(!ops->vidioc_s_fmt_type_private))
+			break;
+		return ops->vidioc_s_fmt_type_private(file, fh, arg);
+	}
+	return -EINVAL;
+}
+
+static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
+				struct file *file, void *fh, void *arg)
+{
+	struct v4l2_format *p = arg;
+
+	switch (p->type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		if (unlikely(!ops->vidioc_try_fmt_vid_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix);
+		return ops->vidioc_try_fmt_vid_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
+		if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
+		if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.win);
+		return ops->vidioc_try_fmt_vid_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		if (unlikely(!ops->vidioc_try_fmt_vid_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix);
+		return ops->vidioc_try_fmt_vid_out(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
+		if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.pix_mp);
+		return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
+		if (unlikely(!ops->vidioc_try_fmt_vid_out_overlay))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.win);
+		return ops->vidioc_try_fmt_vid_out_overlay(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_try_fmt_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_try_fmt_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_try_fmt_vbi_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.vbi);
+		return ops->vidioc_try_fmt_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
+		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_cap))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_try_fmt_sliced_vbi_cap(file, fh, arg);
+	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
+		if (unlikely(!ops->vidioc_try_fmt_sliced_vbi_out))
+			break;
+		CLEAR_AFTER_FIELD(p, fmt.sliced);
+		return ops->vidioc_try_fmt_sliced_vbi_out(file, fh, arg);
+	case V4L2_BUF_TYPE_PRIVATE:
+		if (unlikely(!ops->vidioc_try_fmt_type_private))
+			break;
+		return ops->vidioc_try_fmt_type_private(file, fh, arg);
+	}
+	return -EINVAL;
+}
+
 struct v4l2_ioctl_info {
 	unsigned int ioctl;
 	u32 flags;
@@ -591,13 +896,13 @@ struct v4l2_ioctl_info {
 
 static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO_FNC(VIDIOC_QUERYCAP, v4l_querycap, v4l_print_querycap, 0),
-	IOCTL_INFO(VIDIOC_ENUM_FMT, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
-	IOCTL_INFO(VIDIOC_G_FMT, INFO_FL_CLEAR(v4l2_format, type)),
-	IOCTL_INFO(VIDIOC_S_FMT, INFO_FL_PRIO),
+	IOCTL_INFO_FNC(VIDIOC_ENUM_FMT, v4l_enum_fmt, v4l_print_fmtdesc, INFO_FL_CLEAR(v4l2_fmtdesc, type)),
+	IOCTL_INFO_FNC(VIDIOC_G_FMT, v4l_g_fmt, v4l_print_format, INFO_FL_CLEAR(v4l2_format, type)),
+	IOCTL_INFO_FNC(VIDIOC_S_FMT, v4l_s_fmt, v4l_print_format, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_REQBUFS, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYBUF, INFO_FL_CLEAR(v4l2_buffer, length)),
-	IOCTL_INFO(VIDIOC_G_FBUF, 0),
-	IOCTL_INFO(VIDIOC_S_FBUF, INFO_FL_PRIO),
+	IOCTL_INFO_STD(VIDIOC_G_FBUF, vidioc_g_fbuf, v4l_print_framebuffer, 0),
+	IOCTL_INFO_STD(VIDIOC_S_FBUF, vidioc_s_fbuf, v4l_print_framebuffer, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_OVERLAY, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QBUF, 0),
 	IOCTL_INFO(VIDIOC_DQBUF, 0),
@@ -636,7 +941,7 @@ static struct v4l2_ioctl_info v4l2_ioctls[] = {
 	IOCTL_INFO(VIDIOC_G_JPEGCOMP, 0),
 	IOCTL_INFO(VIDIOC_S_JPEGCOMP, INFO_FL_PRIO),
 	IOCTL_INFO(VIDIOC_QUERYSTD, 0),
-	IOCTL_INFO(VIDIOC_TRY_FMT, 0),
+	IOCTL_INFO_FNC(VIDIOC_TRY_FMT, v4l_try_fmt, v4l_print_format, 0),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDIO, vidioc_enumaudio, v4l_print_audio, INFO_FL_CLEAR(v4l2_audio, index)),
 	IOCTL_INFO_STD(VIDIOC_ENUMAUDOUT, vidioc_enumaudout, v4l_print_audioout, INFO_FL_CLEAR(v4l2_audioout, index)),
 	IOCTL_INFO_FNC(VIDIOC_G_PRIORITY, v4l_g_priority, v4l_print_u32, 0),
@@ -777,288 +1082,6 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	switch (cmd) {
-	/* --- capture ioctls ---------------------------------------- */
-	case VIDIOC_ENUM_FMT:
-	{
-		struct v4l2_fmtdesc *f = arg;
-
-		ret = -EINVAL;
-		switch (f->type) {
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			if (likely(ops->vidioc_enum_fmt_vid_cap))
-				ret = ops->vidioc_enum_fmt_vid_cap(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			if (likely(ops->vidioc_enum_fmt_vid_cap_mplane))
-				ret = ops->vidioc_enum_fmt_vid_cap_mplane(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			if (likely(ops->vidioc_enum_fmt_vid_overlay))
-				ret = ops->vidioc_enum_fmt_vid_overlay(file,
-					fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (likely(ops->vidioc_enum_fmt_vid_out))
-				ret = ops->vidioc_enum_fmt_vid_out(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			if (likely(ops->vidioc_enum_fmt_vid_out_mplane))
-				ret = ops->vidioc_enum_fmt_vid_out_mplane(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_PRIVATE:
-			if (likely(ops->vidioc_enum_fmt_type_private))
-				ret = ops->vidioc_enum_fmt_type_private(file,
-								fh, f);
-			break;
-		default:
-			break;
-		}
-		if (likely(!ret))
-			dbgarg(cmd, "index=%d, type=%d, flags=%d, "
-				"pixelformat=%c%c%c%c, description='%s'\n",
-				f->index, f->type, f->flags,
-				(f->pixelformat & 0xff),
-				(f->pixelformat >>  8) & 0xff,
-				(f->pixelformat >> 16) & 0xff,
-				(f->pixelformat >> 24) & 0xff,
-				f->description);
-		break;
-	}
-	case VIDIOC_G_FMT:
-	{
-		struct v4l2_format *f = (struct v4l2_format *)arg;
-
-		/* FIXME: Should be one dump per type */
-		dbgarg(cmd, "type=%s\n", prt_names(f->type, v4l2_type_names));
-
-		ret = -EINVAL;
-		switch (f->type) {
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			if (ops->vidioc_g_fmt_vid_cap)
-				ret = ops->vidioc_g_fmt_vid_cap(file, fh, f);
-			if (!ret)
-				v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			if (ops->vidioc_g_fmt_vid_cap_mplane)
-				ret = ops->vidioc_g_fmt_vid_cap_mplane(file,
-									fh, f);
-			if (!ret)
-				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			if (likely(ops->vidioc_g_fmt_vid_overlay))
-				ret = ops->vidioc_g_fmt_vid_overlay(file,
-								    fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			if (ops->vidioc_g_fmt_vid_out)
-				ret = ops->vidioc_g_fmt_vid_out(file, fh, f);
-			if (!ret)
-				v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			if (ops->vidioc_g_fmt_vid_out_mplane)
-				ret = ops->vidioc_g_fmt_vid_out_mplane(file,
-									fh, f);
-			if (!ret)
-				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-			if (likely(ops->vidioc_g_fmt_vid_out_overlay))
-				ret = ops->vidioc_g_fmt_vid_out_overlay(file,
-				       fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_CAPTURE:
-			if (likely(ops->vidioc_g_fmt_vbi_cap))
-				ret = ops->vidioc_g_fmt_vbi_cap(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_OUTPUT:
-			if (likely(ops->vidioc_g_fmt_vbi_out))
-				ret = ops->vidioc_g_fmt_vbi_out(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-			if (likely(ops->vidioc_g_fmt_sliced_vbi_cap))
-				ret = ops->vidioc_g_fmt_sliced_vbi_cap(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-			if (likely(ops->vidioc_g_fmt_sliced_vbi_out))
-				ret = ops->vidioc_g_fmt_sliced_vbi_out(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_PRIVATE:
-			if (likely(ops->vidioc_g_fmt_type_private))
-				ret = ops->vidioc_g_fmt_type_private(file,
-								fh, f);
-			break;
-		}
-		break;
-	}
-	case VIDIOC_S_FMT:
-	{
-		struct v4l2_format *f = (struct v4l2_format *)arg;
-
-		ret = -EINVAL;
-
-		/* FIXME: Should be one dump per type */
-		dbgarg(cmd, "type=%s\n", prt_names(f->type, v4l2_type_names));
-
-		switch (f->type) {
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.pix);
-			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_cap)
-				ret = ops->vidioc_s_fmt_vid_cap(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			if (ops->vidioc_s_fmt_vid_cap_mplane)
-				ret = ops->vidioc_s_fmt_vid_cap_mplane(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (ops->vidioc_s_fmt_vid_overlay)
-				ret = ops->vidioc_s_fmt_vid_overlay(file,
-								    fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.pix);
-			v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			if (ops->vidioc_s_fmt_vid_out)
-				ret = ops->vidioc_s_fmt_vid_out(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			if (ops->vidioc_s_fmt_vid_out_mplane)
-				ret = ops->vidioc_s_fmt_vid_out_mplane(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (ops->vidioc_s_fmt_vid_out_overlay)
-				ret = ops->vidioc_s_fmt_vid_out_overlay(file,
-					fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (likely(ops->vidioc_s_fmt_vbi_cap))
-				ret = ops->vidioc_s_fmt_vbi_cap(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (likely(ops->vidioc_s_fmt_vbi_out))
-				ret = ops->vidioc_s_fmt_vbi_out(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (likely(ops->vidioc_s_fmt_sliced_vbi_cap))
-				ret = ops->vidioc_s_fmt_sliced_vbi_cap(file,
-									fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (likely(ops->vidioc_s_fmt_sliced_vbi_out))
-				ret = ops->vidioc_s_fmt_sliced_vbi_out(file,
-									fh, f);
-
-			break;
-		case V4L2_BUF_TYPE_PRIVATE:
-			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
-			if (likely(ops->vidioc_s_fmt_type_private))
-				ret = ops->vidioc_s_fmt_type_private(file,
-								fh, f);
-			break;
-		}
-		break;
-	}
-	case VIDIOC_TRY_FMT:
-	{
-		struct v4l2_format *f = (struct v4l2_format *)arg;
-
-		/* FIXME: Should be one dump per type */
-		dbgarg(cmd, "type=%s\n", prt_names(f->type,
-						v4l2_type_names));
-		ret = -EINVAL;
-		switch (f->type) {
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_cap)
-				ret = ops->vidioc_try_fmt_vid_cap(file, fh, f);
-			if (!ret)
-				v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
-			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			if (ops->vidioc_try_fmt_vid_cap_mplane)
-				ret = ops->vidioc_try_fmt_vid_cap_mplane(file,
-									 fh, f);
-			if (!ret)
-				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OVERLAY:
-			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (likely(ops->vidioc_try_fmt_vid_overlay))
-				ret = ops->vidioc_try_fmt_vid_overlay(file,
-					fh, f);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.pix);
-			if (ops->vidioc_try_fmt_vid_out)
-				ret = ops->vidioc_try_fmt_vid_out(file, fh, f);
-			if (!ret)
-				v4l_print_pix_fmt(vfd, &f->fmt.pix);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
-			CLEAR_AFTER_FIELD(f, fmt.pix_mp);
-			if (ops->vidioc_try_fmt_vid_out_mplane)
-				ret = ops->vidioc_try_fmt_vid_out_mplane(file,
-									 fh, f);
-			if (!ret)
-				v4l_print_pix_fmt_mplane(vfd, &f->fmt.pix_mp);
-			break;
-		case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
-			CLEAR_AFTER_FIELD(f, fmt.win);
-			if (likely(ops->vidioc_try_fmt_vid_out_overlay))
-				ret = ops->vidioc_try_fmt_vid_out_overlay(file,
-				       fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (likely(ops->vidioc_try_fmt_vbi_cap))
-				ret = ops->vidioc_try_fmt_vbi_cap(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_VBI_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.vbi);
-			if (likely(ops->vidioc_try_fmt_vbi_out))
-				ret = ops->vidioc_try_fmt_vbi_out(file, fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
-			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (likely(ops->vidioc_try_fmt_sliced_vbi_cap))
-				ret = ops->vidioc_try_fmt_sliced_vbi_cap(file,
-								fh, f);
-			break;
-		case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
-			CLEAR_AFTER_FIELD(f, fmt.sliced);
-			if (likely(ops->vidioc_try_fmt_sliced_vbi_out))
-				ret = ops->vidioc_try_fmt_sliced_vbi_out(file,
-								fh, f);
-			break;
-		case V4L2_BUF_TYPE_PRIVATE:
-			/* CLEAR_AFTER_FIELD(f, fmt.raw_data); <- does nothing */
-			if (likely(ops->vidioc_try_fmt_type_private))
-				ret = ops->vidioc_try_fmt_type_private(file,
-								fh, f);
-			break;
-		}
-		break;
-	}
 	/* FIXME: Those buf reqs could be handled here,
 	   with some changes on videobuf to allow its header to be included at
 	   videodev2.h or being merged at videodev2.
@@ -1128,29 +1151,6 @@ static long __video_do_ioctl(struct file *file,
 		ret = ops->vidioc_overlay(file, fh, *i);
 		break;
 	}
-	case VIDIOC_G_FBUF:
-	{
-		struct v4l2_framebuffer *p = arg;
-
-		ret = ops->vidioc_g_fbuf(file, fh, arg);
-		if (!ret) {
-			dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
-					p->capability, p->flags,
-					(unsigned long)p->base);
-			v4l_print_pix_fmt(vfd, &p->fmt);
-		}
-		break;
-	}
-	case VIDIOC_S_FBUF:
-	{
-		struct v4l2_framebuffer *p = arg;
-
-		dbgarg(cmd, "capability=0x%x, flags=%d, base=0x%08lx\n",
-			p->capability, p->flags, (unsigned long)p->base);
-		v4l_print_pix_fmt(vfd, &p->fmt);
-		ret = ops->vidioc_s_fbuf(file, fh, arg);
-		break;
-	}
 	case VIDIOC_STREAMON:
 	{
 		enum v4l2_buf_type i = *(int *)arg;
-- 
1.7.10


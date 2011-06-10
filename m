Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58899 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab1FJShI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 10 Jun 2011 20:36:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 13/19] s5p-fimc: Correct color format enumeration
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-14-git-send-email-s.nawrocki@samsung.com>
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Create separate VIDIOC_ENUM_FMT ioctl handlers for video capture
and mem-to-mem video node. This is needed as some formats are
valid only for the video capture and some only for the mem-to-mem
video node. Create single function for pixel format lookup out of
find_mbus_format() and find_format().

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |   32 ++++++++++----
 drivers/media/video/s5p-fimc/fimc-core.c    |   61 +++++++++++++--------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    6 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    2 +-
 4 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 615ca4b..896b3b9 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -382,6 +382,22 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
 	return 0;
 }
 
+static int fimc_cap_enum_fmt_mplane(struct file *file, void *priv,
+				    struct v4l2_fmtdesc *f)
+{
+	struct fimc_fmt *fmt;
+
+	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM | FMT_FLAGS_M2M,
+			       f->index);
+	if (!fmt)
+		return -EINVAL;
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	if (fmt->fourcc == V4L2_MBUS_FMT_JPEG_1X8)
+		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
+	return 0;
+}
+
 /* Synchronize formats of the camera interface input and attached  sensor. */
 static int sync_capture_fmt(struct fimc_ctx *ctx)
 {
@@ -400,7 +416,7 @@ static int sync_capture_fmt(struct fimc_ctx *ctx)
 	}
 	dbg("w: %d, h: %d, code= %d", fmt->width, fmt->height, fmt->code);
 
-	frame->fmt = find_mbus_format(fmt, FMT_FLAGS_CAM);
+	frame->fmt = fimc_find_format(NULL, fmt, FMT_FLAGS_CAM, -1);
 	if (!frame->fmt) {
 		err("fimc source format not found\n");
 		return -EINVAL;
@@ -462,12 +478,10 @@ static int fimc_cap_s_fmt_mplane(struct file *file, void *priv,
 	frame = &ctx->d_frame;
 
 	pix = &f->fmt.pix_mp;
-	frame->fmt = find_format(f, FMT_FLAGS_M2M | FMT_FLAGS_CAM);
-	if (!frame->fmt) {
-		v4l2_err(fimc->vid_cap.vfd,
-			 "Not supported capture (FIMC target) color format\n");
+	frame->fmt = fimc_find_format(f, NULL,
+				      FMT_FLAGS_M2M | FMT_FLAGS_CAM, 0);
+	if (WARN(frame->fmt == NULL, "Pixel format lookup failed\n"))
 		return -EINVAL;
-	}
 
 	for (i = 0; i < frame->fmt->colplanes; i++) {
 		frame->payload[i] =
@@ -647,7 +661,7 @@ static int fimc_cap_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 static const struct v4l2_ioctl_ops fimc_capture_ioctl_ops = {
 	.vidioc_querycap		= fimc_vidioc_querycap_capture,
 
-	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_cap_enum_fmt_mplane,
 	.vidioc_try_fmt_vid_cap_mplane	= fimc_cap_try_fmt_mplane,
 	.vidioc_s_fmt_vid_cap_mplane	= fimc_cap_s_fmt_mplane,
 	.vidioc_g_fmt_vid_cap_mplane	= fimc_cap_g_fmt_mplane,
@@ -708,7 +722,6 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	struct video_device *vfd;
 	struct fimc_vid_cap *vid_cap;
 	struct fimc_ctx *ctx;
-	struct v4l2_format f;
 	struct fimc_frame *fr;
 	struct vb2_queue *q;
 	int ret = -ENOMEM;
@@ -723,9 +736,8 @@ int fimc_register_capture_device(struct fimc_dev *fimc,
 	ctx->state	 = FIMC_CTX_CAP;
 
 	/* Default format of the output frames */
-	f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB32;
 	fr = &ctx->d_frame;
-	fr->fmt = find_format(&f, FMT_FLAGS_M2M);
+	fr->fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_CAM, 0);
 	fr->width = fr->f_width = fr->o_width = 640;
 	fr->height = fr->f_height = fr->o_height = 480;
 
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index da52d4f..49ada07 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -860,18 +860,17 @@ static int fimc_m2m_querycap(struct file *file, void *fh,
 	return 0;
 }
 
-int fimc_vidioc_enum_fmt_mplane(struct file *file, void *priv,
-				struct v4l2_fmtdesc *f)
+static int fimc_m2m_enum_fmt_mplane(struct file *file, void *priv,
+				    struct v4l2_fmtdesc *f)
 {
 	struct fimc_fmt *fmt;
 
-	if (f->index >= ARRAY_SIZE(fimc_formats))
+	fmt = fimc_find_format(NULL, NULL, FMT_FLAGS_M2M, f->index);
+	if (!fmt)
 		return -EINVAL;
 
-	fmt = &fimc_formats[f->index];
 	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
 	f->pixelformat = fmt->fourcc;
-
 	return 0;
 }
 
@@ -910,34 +909,34 @@ static int fimc_m2m_g_fmt_mplane(struct file *file, void *fh,
 	return fimc_fill_format(frame, f);
 }
 
-struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask)
-{
-	struct fimc_fmt *fmt;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
-		fmt = &fimc_formats[i];
-		if (fmt->fourcc == f->fmt.pix_mp.pixelformat &&
-		   (fmt->flags & mask))
-			break;
-	}
-
-	return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
-}
-
-struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
-				  unsigned int mask)
+/**
+ * fimc_find_format - lookup fimc color format by fourcc or media bus format
+ * @f: fourcc to match, ignored if null
+ * @mf: media bus code to match, ignored if null
+ * @mask: the color flags to match
+ * @index: offset in the fimc_formats array, ignored if negative
+ */
+struct fimc_fmt *fimc_find_format(struct v4l2_format *f,
+				  struct v4l2_mbus_framefmt *mf,
+				  unsigned int mask, int index)
 {
-	struct fimc_fmt *fmt;
+	struct fimc_fmt *fmt, *def_fmt = NULL;
 	unsigned int i;
+	int id = 0;
 
 	for (i = 0; i < ARRAY_SIZE(fimc_formats); ++i) {
 		fmt = &fimc_formats[i];
-		if (fmt->mbus_code == f->code && (fmt->flags & mask))
-			break;
+		if (!(fmt->flags & mask))
+			continue;
+		if (f && fmt->fourcc == f->fmt.pix_mp.pixelformat)
+			return fmt;
+		if (mf && fmt->mbus_code == mf->code)
+			return fmt;
+		if (index == id)
+			def_fmt = fmt;
+		id++;
 	}
-
-	return (i == ARRAY_SIZE(fimc_formats)) ? NULL : fmt;
+	return def_fmt;
 }
 
 int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
@@ -960,7 +959,7 @@ int fimc_try_fmt_mplane(struct fimc_ctx *ctx, struct v4l2_format *f)
 	dbg("w: %d, h: %d", pix->width, pix->height);
 
 	mask = is_output ? FMT_FLAGS_M2M : FMT_FLAGS_M2M | FMT_FLAGS_CAM;
-	fmt = find_format(f, mask);
+	fmt = fimc_find_format(f, NULL, mask, -1);
 	if (!fmt) {
 		v4l2_err(fimc->v4l2_dev, "Fourcc format (0x%X) invalid.\n",
 			 pix->pixelformat);
@@ -1055,7 +1054,7 @@ static int fimc_m2m_s_fmt_mplane(struct file *file, void *fh,
 		frame = &ctx->d_frame;
 
 	pix = &f->fmt.pix_mp;
-	frame->fmt = find_format(f, FMT_FLAGS_M2M);
+	frame->fmt = fimc_find_format(f, NULL, FMT_FLAGS_M2M, -1);
 	if (!frame->fmt)
 		return -EINVAL;
 
@@ -1284,8 +1283,8 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
 static const struct v4l2_ioctl_ops fimc_m2m_ioctl_ops = {
 	.vidioc_querycap		= fimc_m2m_querycap,
 
-	.vidioc_enum_fmt_vid_cap_mplane	= fimc_vidioc_enum_fmt_mplane,
-	.vidioc_enum_fmt_vid_out_mplane	= fimc_vidioc_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_cap_mplane	= fimc_m2m_enum_fmt_mplane,
+	.vidioc_enum_fmt_vid_out_mplane	= fimc_m2m_enum_fmt_mplane,
 
 	.vidioc_g_fmt_vid_cap_mplane	= fimc_m2m_g_fmt_mplane,
 	.vidioc_g_fmt_vid_out_mplane	= fimc_m2m_g_fmt_mplane,
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index abf762f..14a24bb 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -650,9 +650,9 @@ void fimc_ctrls_delete(struct fimc_ctx *ctx);
 void fimc_ctrls_activate(struct fimc_ctx *ctx, bool active);
 int fimc_fill_format(struct fimc_frame *frame, struct v4l2_format *f);
 
-struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
-struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
-				  unsigned int mask);
+struct fimc_fmt *fimc_find_format(struct v4l2_format *f,
+				  struct v4l2_mbus_framefmt *mf,
+				  unsigned int mask, int index);
 
 int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot);
 int fimc_set_scaler_info(struct fimc_ctx *ctx);
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index bff370c..0b46fe7 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -195,7 +195,7 @@ int fimc_pipeline_s_stream(struct fimc_dev *fimc, int on)
 	if ((on && p->csis) || !on)
 		ret = v4l2_subdev_call(on ? p->csis : p->sensor,
 				       video, s_stream, on);
-	if (ret && ret != -ENOIOCTLCMD)
+	if (ret < 0 && ret != -ENOIOCTLCMD)
 		return ret;
 	if ((!on && p->csis) || on)
 		ret = v4l2_subdev_call(on ? p->sensor : p->csis,
-- 
1.7.5.4


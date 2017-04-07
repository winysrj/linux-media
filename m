Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58020 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752375AbdDGWhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 18:37:50 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 5/7] [media] vimc: cap: Support several image formats
Date: Fri,  7 Apr 2017 19:37:10 -0300
Message-Id: <1491604632-23544-6-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
 <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow user space to change the image format as the frame size, the
pixel format, colorspace, quantization, field YCbCr encoding
and the transfer function

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v2:
[media] vimc: cap: Support several image formats
	- this is a new commit in the serie (the old one was splitted in two)
	- allow user space to change all fields from struct v4l2_pix_format
	  (e.g. colospace, quantization, field, xfer_func, ycbcr_enc)
	- link_validate and try_fmt: also checks colospace, quantization, field, xfer_func, ycbcr_enc
	- add struct v4l2_pix_format fmt_default
	- add enum_framesizes
	- enum_fmt_vid_cap: enumerate all formats from vimc_pix_map_table
	- add mode dev_dbg


---
 drivers/media/platform/vimc/vimc-capture.c | 167 ++++++++++++++++++++++++-----
 1 file changed, 139 insertions(+), 28 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 93f6a09..a6441f7 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -40,6 +40,16 @@ struct vimc_cap_device {
 	struct media_pipeline pipe;
 };
 
+static const struct v4l2_pix_format fmt_default = {
+	.width = 640,
+	.height = 480,
+	.pixelformat = V4L2_PIX_FMT_RGB24,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_SRGB,
+	.quantization = V4L2_QUANTIZATION_FULL_RANGE,
+	.xfer_func = V4L2_XFER_FUNC_SRGB,
+};
+
 struct vimc_cap_buffer {
 	/*
 	 * struct vb2_v4l2_buffer must be the first element
@@ -64,7 +74,7 @@ static int vimc_cap_querycap(struct file *file, void *priv,
 	return 0;
 }
 
-static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
+static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
@@ -74,16 +84,112 @@ static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct v4l2_pix_format *format = &f->fmt.pix;
+	const struct vimc_pix_map *vpix;
+
+	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
+				VIMC_FRAME_MAX_WIDTH);
+	format->height = clamp_t(u32, format->height, VIMC_FRAME_MIN_HEIGHT,
+				 VIMC_FRAME_MAX_HEIGHT);
+
+	/* Don't accept a pixelformat that is not on the table */
+	vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
+	if (!vpix) {
+		format->pixelformat = fmt_default.pixelformat;
+		vpix = vimc_pix_map_by_pixelformat(format->pixelformat);
+	}
+	/* TODO: Add support for custom bytesperline values */
+	format->bytesperline = format->width * vpix->bpp;
+	format->sizeimage = format->bytesperline * format->height;
+
+	if (format->field == V4L2_FIELD_ANY)
+		format->field = fmt_default.field;
+
+	/* Check if values are out of range */
+	if (format->colorspace == V4L2_COLORSPACE_DEFAULT
+	    || format->colorspace > V4L2_COLORSPACE_DCI_P3)
+		format->colorspace = fmt_default.colorspace;
+	if (format->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT
+	    || format->ycbcr_enc > V4L2_YCBCR_ENC_SMPTE240M)
+		format->ycbcr_enc = fmt_default.ycbcr_enc;
+	if (format->quantization == V4L2_QUANTIZATION_DEFAULT
+	    || format->quantization > V4L2_QUANTIZATION_LIM_RANGE)
+		format->quantization = fmt_default.quantization;
+	if (format->xfer_func == V4L2_XFER_FUNC_DEFAULT
+	    || format->xfer_func > V4L2_XFER_FUNC_SMPTE2084)
+		format->xfer_func = fmt_default.xfer_func;
+
+	return 0;
+}
+
+static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+
+	/* Do not change the format while stream is on */
+	if (vb2_is_busy(&vcap->queue))
+		return -EBUSY;
+
+	vimc_cap_try_fmt_vid_cap(file, priv, f);
+
+	dev_dbg(vcap->vdev.v4l2_dev->dev, "%s: format update: "
+		"old:%dx%d (0x%x, %d, %d, %d, %d) "
+		"new:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
+		/* old */
+		vcap->format.width, vcap->format.height,
+		vcap->format.pixelformat, vcap->format.colorspace,
+		vcap->format.quantization, vcap->format.xfer_func,
+		vcap->format.ycbcr_enc,
+		/* new */
+		f->fmt.pix.width, f->fmt.pix.height,
+		f->fmt.pix.pixelformat,	f->fmt.pix.colorspace,
+		f->fmt.pix.quantization, f->fmt.pix.xfer_func,
+		f->fmt.pix.ycbcr_enc);
+
+	vcap->format = f->fmt.pix;
+
+	return 0;
+}
+
 static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
-	struct vimc_cap_device *vcap = video_drvdata(file);
+	const struct vimc_pix_map *vpix = vimc_pix_map_by_index(f->index);
 
-	if (f->index > 0)
+	if (!vpix)
 		return -EINVAL;
 
-	/* We only support one format for now */
-	f->pixelformat = vcap->format.pixelformat;
+	f->pixelformat = vpix->pixelformat;
+	f->flags = V4L2_FMT_FLAG_COMPRESSED;
+	f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+
+	return 0;
+}
+
+static int vimc_cap_enum_framesizes(struct file *file, void *fh,
+				    struct v4l2_frmsizeenum *fsize)
+{
+	const struct vimc_pix_map *vpix;
+
+	if (fsize->index)
+		return -EINVAL;
+
+	/* Only accept code in the pix map table */
+	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	if (!vpix)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	fsize->stepwise.min_width = VIMC_FRAME_MIN_WIDTH;
+	fsize->stepwise.max_width = VIMC_FRAME_MAX_WIDTH;
+	fsize->stepwise.min_height = VIMC_FRAME_MIN_HEIGHT;
+	fsize->stepwise.max_height = VIMC_FRAME_MAX_HEIGHT;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.step_height = 1;
 
 	return 0;
 }
@@ -101,10 +207,11 @@ static const struct v4l2_file_operations vimc_cap_fops = {
 static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
 	.vidioc_querycap = vimc_cap_querycap,
 
-	.vidioc_g_fmt_vid_cap = vimc_cap_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vimc_cap_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap = vimc_cap_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = vimc_cap_try_fmt_vid_cap,
 	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
+	.vidioc_enum_framesizes = vimc_cap_enum_framesizes,
 
 	.vidioc_reqbufs = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs = vb2_ioctl_create_bufs,
@@ -270,20 +377,21 @@ static int vimc_cap_link_validate(struct media_link *link)
 	if (ret)
 		return ret;
 
-	dev_dbg(vcap->vdev.v4l2_dev->dev,
-		"%s: link validate formats src:%dx%d %d sink:%dx%d %d\n",
-		vcap->vdev.name,
+	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
+
+	dev_dbg(vcap->vdev.v4l2_dev->dev, "%s: link validate formats: "
+		"src:%dx%d (0x%x, %d, %d, %d, %d) "
+		"snk:%dx%d (0x%x, %d, %d, %d, %d)\n", vcap->vdev.name,
+		/* src */
 		source_fmt.format.width, source_fmt.format.height,
-		source_fmt.format.code,
+		source_fmt.format.code,	source_fmt.format.colorspace,
+		source_fmt.format.quantization,	source_fmt.format.xfer_func,
+		source_fmt.format.ycbcr_enc,
+		/* sink */
 		sink_fmt->width, sink_fmt->height,
-		sink_fmt->pixelformat);
-
-	/* The width, height and code must match. */
-	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
-	if (source_fmt.format.width != sink_fmt->width
-	    || source_fmt.format.height != sink_fmt->height
-	    || vpix->code != source_fmt.format.code)
-		return -EPIPE;
+		vpix->code, sink_fmt->colorspace,
+		sink_fmt->quantization,	sink_fmt->xfer_func,
+		sink_fmt->ycbcr_enc);
 
 	/*
 	 * The field order must match, or the sink field order must be NONE
@@ -294,6 +402,15 @@ static int vimc_cap_link_validate(struct media_link *link)
 	    sink_fmt->field != V4L2_FIELD_NONE)
 		return -EPIPE;
 
+	if (source_fmt.format.width != sink_fmt->width
+	    || source_fmt.format.height != sink_fmt->height
+	    || source_fmt.format.colorspace != sink_fmt->colorspace
+	    || source_fmt.format.quantization != sink_fmt->quantization
+	    || source_fmt.format.xfer_func != sink_fmt->xfer_func
+	    || source_fmt.format.ycbcr_enc != sink_fmt->ycbcr_enc
+	    || vpix->code != source_fmt.format.code)
+		return -EPIPE;
+
 	return 0;
 }
 
@@ -417,15 +534,9 @@ struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
 	INIT_LIST_HEAD(&vcap->buf_list);
 	spin_lock_init(&vcap->qlock);
 
-	/* Set the frame format (this is hardcoded for now) */
-	vcap->format.width = 640;
-	vcap->format.height = 480;
-	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
-	vcap->format.field = V4L2_FIELD_NONE;
-	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
-
+	/* Set default frame format */
+	vcap->format = fmt_default;
 	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
-
 	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
 	vcap->format.sizeimage = vcap->format.bytesperline *
 				 vcap->format.height;
-- 
2.7.4

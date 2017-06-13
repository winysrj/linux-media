Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36935 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753996AbdFMThW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Jun 2017 15:37:22 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v4 08/11] [media] vimc: cap: Support several image formats
Date: Tue, 13 Jun 2017 16:35:36 -0300
Message-Id: <1497382545-16408-9-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
References: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow user space to change the image format as the frame size, the
pixel format, colorspace, quantization, field YCbCr encoding
and the transfer function

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v4:
[media] vimc: cap: Support several image formats
	- add vimc_colorimetry_clamp macro
	- replace V4L2_COLORSPACE_SRGB by V4L2_COLORSPACE_DEFAULT in the
	default format struct

Changes in v3:
[media] vimc: cap: Support several image formats
	- use *_DEFAULT macros for colorimetry in the default format
	- clamp height and width of the image by an even value
	- is user try to set colorspace to an invalid format, set all
	colorimetry parameters to _DEFAULT
	- remove V4L2_FMT_FLAG_COMPRESSED from vimc_cap_enum_fmt_vid_cap
	- remove V4L2_BUF_TYPE_VIDEO_CAPTURE from vimc_cap_enum_fmt_vid_cap
	- increase step_width and step_height to 2 instead of 1
	- remove link validate function, use the one in vimc-common.c

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
 drivers/media/platform/vimc/vimc-capture.c | 117 +++++++++++++++++++++++++----
 1 file changed, 101 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 5bdecd1..359f59e 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -40,6 +40,14 @@ struct vimc_cap_device {
 	struct media_pipeline pipe;
 };
 
+static const struct v4l2_pix_format fmt_default = {
+	.width = 640,
+	.height = 480,
+	.pixelformat = V4L2_PIX_FMT_RGB24,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_DEFAULT,
+};
+
 struct vimc_cap_buffer {
 	/*
 	 * struct vb2_v4l2_buffer must be the first element
@@ -73,7 +81,7 @@ static void vimc_cap_get_format(struct vimc_ent_device *ved,
 	*fmt = vcap->format;
 }
 
-static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
+static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
@@ -83,16 +91,98 @@ static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
+				    struct v4l2_format *f)
+{
+	struct v4l2_pix_format *format = &f->fmt.pix;
+	const struct vimc_pix_map *vpix;
+
+	format->width = clamp_t(u32, format->width, VIMC_FRAME_MIN_WIDTH,
+				VIMC_FRAME_MAX_WIDTH) & ~1;
+	format->height = clamp_t(u32, format->height, VIMC_FRAME_MIN_HEIGHT,
+				 VIMC_FRAME_MAX_HEIGHT) & ~1;
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
+	vimc_colorimetry_clamp(format);
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
+	fsize->stepwise.step_width = 2;
+	fsize->stepwise.step_height = 2;
 
 	return 0;
 }
@@ -110,10 +200,11 @@ static const struct v4l2_file_operations vimc_cap_fops = {
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
@@ -360,15 +451,9 @@ struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
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

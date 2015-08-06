Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f173.google.com ([209.85.160.173]:35945 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472AbbHFU0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 16:26:39 -0400
Received: by ykeo23 with SMTP id o23so72329021yke.3
        for <linux-media@vger.kernel.org>; Thu, 06 Aug 2015 13:26:38 -0700 (PDT)
From: Helen Fornazier <helen.fornazier@gmail.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Cc: Helen Fornazier <helen.fornazier@gmail.com>
Subject: [PATCH 7/7] [media] vimc: Implement set format in the nodes
Date: Thu,  6 Aug 2015 17:26:14 -0300
Message-Id: <01dec7ade6f805e3d4ba406d478173c33e93e74a.1438891530.git.helen.fornazier@gmail.com>
In-Reply-To: <cover.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
In-Reply-To: <cover.1438891530.git.helen.fornazier@gmail.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement set format in the topology nodes capture, debayer, sensor and
scaler
Allow user space to change the frame size and the pixel format

Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 56 ++++++++++++++++++++-
 drivers/media/platform/vimc/vimc-core.c    | 81 +++++++++++++++++++-----------
 drivers/media/platform/vimc/vimc-core.h    |  6 +++
 drivers/media/platform/vimc/vimc-debayer.c | 36 ++++++++++++-
 drivers/media/platform/vimc/vimc-scaler.c  | 45 ++++++++++++++++-
 drivers/media/platform/vimc/vimc-sensor.c  | 33 +++++++++++-
 6 files changed, 222 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 7d21966..3b92a35 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -102,6 +102,59 @@ static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static int vimc_cap_s_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct vimc_cap_device *vcap = video_drvdata(file);
+	const struct vimc_pix_map *vpix;
+
+	/* Do not change the format while stream is on */
+	if (vb2_is_busy(&vcap->queue))
+		return -EINVAL;
+
+	/* Accept all non-zero width and height sizes */
+	if (f->fmt.pix.width)
+		vcap->format.width = f->fmt.pix.width;
+	else
+		f->fmt.pix.width = vcap->format.width;
+	if (f->fmt.pix.height)
+		vcap->format.height = f->fmt.pix.height;
+	else
+		f->fmt.pix.height = vcap->format.height;
+
+	/* Don't accept a pixelformat that is not on the table */
+	vpix = vimc_pix_map_by_pixelformat(f->fmt.pix.pixelformat);
+	if (vpix)
+		vcap->format.pixelformat = f->fmt.pix.pixelformat;
+	else {
+		f->fmt.pix.pixelformat = vcap->format.pixelformat;
+		vpix = vimc_pix_map_by_pixelformat(f->fmt.pix.pixelformat);
+	}
+
+	vcap->format.field = f->fmt.pix.field;
+
+	/* Check if bytesperline has the minimum size */
+	if (f->fmt.pix.bytesperline >= vcap->format.width * vpix->bpp)
+		vcap->format.bytesperline = f->fmt.pix.bytesperline;
+	else
+		f->fmt.pix.bytesperline = vcap->format.bytesperline;
+
+	/* Set the size of the image and the flags */
+	f->fmt.pix.sizeimage = vcap->format.width *
+			       vcap->format.height * vpix->bpp;
+	vcap->format.sizeimage = f->fmt.pix.sizeimage;
+	vcap->format.flags = f->fmt.pix.flags;
+
+	/* We don't support changing the colorspace for now */
+	/* TODO: add support for others colorspaces */
+	f->fmt.pix.colorspace = vcap->format.colorspace;
+	f->fmt.pix.ycbcr_enc = vcap->format.ycbcr_enc;
+	f->fmt.pix.quantization = vcap->format.quantization;
+	f->fmt.pix.xfer_func = vcap->format.xfer_func;
+
+	return 0;
+}
+
 static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
@@ -134,7 +187,8 @@ static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
 	.vidioc_s_input = vimc_cap_s_input,
 
 	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = vimc_cap_s_fmt_vid_cap,
+	/* TODO: Add support to try format */
 	.vidioc_try_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
 	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
 
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 8342732..bf2148a 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -39,10 +39,11 @@
 	.flags = link_flags,					\
 }
 
-#define VIMC_PIX_MAP(_code, _bpp, _pixelformat) {	\
-	.code = _code,					\
-	.pixelformat = _pixelformat,			\
-	.bpp = _bpp,					\
+#define VIMC_PIX_MAP(_code, _bpp, _pixelformat, _bayer) {	\
+	.code = _code,						\
+	.pixelformat = _pixelformat,				\
+	.bpp = _bpp,						\
+	.bayer = _bayer,					\
 }
 
 struct vimc_device {
@@ -216,36 +217,36 @@ const struct vimc_pix_map vimc_pix_map_list[] = {
 	/* TODO: add all missing formats */
 
 	/* RGB formats */
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_BGR888_1X24, 3, V4L2_PIX_FMT_BGR24),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_RGB888_1X24, 3, V4L2_PIX_FMT_RGB24),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_ARGB8888_1X32, 4, V4L2_PIX_FMT_ARGB32),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_BGR888_1X24, 3, V4L2_PIX_FMT_BGR24, false),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_RGB888_1X24, 3, V4L2_PIX_FMT_RGB24, false),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_ARGB8888_1X32, 4, V4L2_PIX_FMT_ARGB32, false),
 
 	/* Bayer formats */
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR8_1X8, 1, V4L2_PIX_FMT_SBGGR8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG8_1X8, 1, V4L2_PIX_FMT_SGBRG8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG8_1X8, 1, V4L2_PIX_FMT_SGRBG8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB8_1X8, 1, V4L2_PIX_FMT_SRGGB8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_1X10, 2, V4L2_PIX_FMT_SBGGR10),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_1X10, 2, V4L2_PIX_FMT_SGBRG10),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_1X10, 2, V4L2_PIX_FMT_SGRBG10),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_1X10, 2, V4L2_PIX_FMT_SRGGB10),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR8_1X8, 1, V4L2_PIX_FMT_SBGGR8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG8_1X8, 1, V4L2_PIX_FMT_SGBRG8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG8_1X8, 1, V4L2_PIX_FMT_SGRBG8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB8_1X8, 1, V4L2_PIX_FMT_SRGGB8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_1X10, 2, V4L2_PIX_FMT_SBGGR10, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_1X10, 2, V4L2_PIX_FMT_SGBRG10, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_1X10, 2, V4L2_PIX_FMT_SGRBG10, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_1X10, 2, V4L2_PIX_FMT_SRGGB10, true),
 	/* 10bit raw bayer a-law compressed to 8 bits */
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8, 1, V4L2_PIX_FMT_SBGGR10ALAW8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGBRG10ALAW8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGRBG10ALAW8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8, 1, V4L2_PIX_FMT_SRGGB10ALAW8),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8, 1, V4L2_PIX_FMT_SBGGR10ALAW8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGBRG10ALAW8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGRBG10ALAW8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8, 1, V4L2_PIX_FMT_SRGGB10ALAW8, true),
 	/* 10bit raw bayer DPCM compressed to 8 bits */
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 1, V4L2_PIX_FMT_SBGGR10DPCM8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGBRG10DPCM8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGRBG10DPCM8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 1, V4L2_PIX_FMT_SRGGB10DPCM8),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR12_1X12, 2, V4L2_PIX_FMT_SBGGR12),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG12_1X12, 2, V4L2_PIX_FMT_SGBRG12),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG12_1X12, 2, V4L2_PIX_FMT_SGRBG12),
-	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB12_1X12, 2, V4L2_PIX_FMT_SRGGB12),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 1, V4L2_PIX_FMT_SBGGR10DPCM8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGBRG10DPCM8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGRBG10DPCM8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 1, V4L2_PIX_FMT_SRGGB10DPCM8, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR12_1X12, 2, V4L2_PIX_FMT_SBGGR12, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG12_1X12, 2, V4L2_PIX_FMT_SGBRG12, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG12_1X12, 2, V4L2_PIX_FMT_SGRBG12, true),
+	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB12_1X12, 2, V4L2_PIX_FMT_SRGGB12, true),
 
 	/* End */
-	{0, 0, 0}
+	{0, 0, 0, 0}
 };
 
 const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
@@ -437,6 +438,30 @@ err_free_vsd:
 	return ERR_PTR(ret);
 }
 
+void vimc_ent_sd_set_fsize(struct v4l2_mbus_framefmt *active_fmt,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format)
+{
+	/* Accept all non-zero width and height sizes */
+	if (format->format.width)
+		active_fmt->width = format->format.width;
+	else
+		format->format.width = active_fmt->width;
+	if (format->format.height)
+		active_fmt->height = format->format.height;
+	else
+		format->format.height = active_fmt->height;
+
+	active_fmt->field = format->format.field;
+
+	/* We don't support changing the colorspace for now */
+	/* TODO: add support for others */
+	format->format.colorspace = active_fmt->colorspace;
+	format->format.ycbcr_enc = active_fmt->ycbcr_enc;
+	format->format.quantization = active_fmt->quantization;
+	format->format.xfer_func = active_fmt->xfer_func;
+}
+
 /* TODO: remove this function when all the
  * entities specific code are implemented */
 static void vimc_raw_destroy(struct vimc_ent_device *ved)
diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-core.h
index 892341a..311be04 100644
--- a/drivers/media/platform/vimc/vimc-core.h
+++ b/drivers/media/platform/vimc/vimc-core.h
@@ -28,6 +28,7 @@ struct vimc_pix_map {
 	unsigned int code;
 	unsigned int bpp;
 	u32 pixelformat;
+	bool bayer;
 };
 extern const struct vimc_pix_map vimc_pix_map_list[];
 
@@ -67,6 +68,11 @@ struct vimc_ent_subdevice *vimc_ent_sd_init(size_t struct_size,
 				void (*sd_destroy)(struct vimc_ent_device *));
 void vimc_ent_sd_cleanup(struct vimc_ent_subdevice *vsd);
 
+/* Herper function to set the format of a subdevice node */
+void vimc_ent_sd_set_fsize(struct v4l2_mbus_framefmt *active_fmt,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format);
+
 /* Helper function to call the s_stream of the subdevice
  * directly connected with entity*/
 int vimc_pipeline_s_stream(struct media_entity *entity, int enable);
diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 470b336..5d1e3b3 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -202,12 +202,44 @@ static int vimc_deb_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int vimc_deb_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
+{
+	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
+	const struct vimc_deb_pix_map *vpix;
+
+	/* TODO: Add support for try format */
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return -EINVAL;
+
+	/* Do not change the format while stream is on */
+	if (vdeb->src_frame)
+		return -EINVAL;
+
+	if (vdeb->vsd.sd.entity.pads[format->pad].flags & MEDIA_PAD_FL_SINK) {
+		/* Don't accept a code that is not on the debayer table */
+		vpix = vimc_deb_pix_map_by_code(format->format.code);
+		if (vpix)
+			vdeb->sink_mbus_fmt.code = format->format.code;
+		else
+			format->format.code = vdeb->sink_mbus_fmt.code;
+
+		vimc_ent_sd_set_fsize(&vdeb->sink_mbus_fmt, cfg, format);
+	} else
+		/* We only support one SRC format for now
+		 * don't change the code
+		 * TODO: chage here when adding more src formats */
+		vimc_ent_sd_set_fsize(&vdeb->src_mbus_fmt, cfg, format);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops vimc_deb_pad_ops = {
 	.enum_mbus_code		= vimc_deb_enum_mbus_code,
 	.enum_frame_size	= vimc_deb_enum_frame_size,
 	.get_fmt		= vimc_deb_get_fmt,
-	/* TODO: Add support to other formats */
-	.set_fmt		= vimc_deb_get_fmt,
+	.set_fmt		= vimc_deb_set_fmt,
 };
 
 static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(struct vimc_deb_device *vdeb,
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index ea26930..e1f199b 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -108,12 +108,53 @@ static int vimc_sca_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int vimc_sca_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
+{
+	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
+	const struct vimc_pix_map *vpix;
+
+	/* TODO: Add support for try format */
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return -EINVAL;
+
+	/* Do not change the format while stream is on */
+	if (vsca->src_frame)
+		return -EINVAL;
+
+	/* Do not change the format of the source pad, it is propagated
+	 * from the sink*/
+	if (vsca->vsd.sd.entity.pads[format->pad].flags
+	    & MEDIA_PAD_FL_SOURCE) {
+		format->format = vsca->sink_mbus_fmt;
+		format->format.width = vsca->src_width;
+		format->format.height = vsca->src_height;
+		return 0;
+	}
+
+	/* Don't accept a code that is not on the table
+	 * or are in bayer format */
+	vpix = vimc_pix_map_by_code(format->format.code);
+	if (vpix && !vpix->bayer)
+		vsca->sink_mbus_fmt.code = format->format.code;
+	else
+		format->format.code = vsca->sink_mbus_fmt.code;
+
+	vimc_ent_sd_set_fsize(&vsca->sink_mbus_fmt, cfg, format);
+
+	/* Update the source sizes */
+	vsca->src_width = vsca->sink_mbus_fmt.width * vsca->mult;
+	vsca->src_height = vsca->sink_mbus_fmt.height * vsca->mult;
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
 	.enum_mbus_code		= vimc_sca_enum_mbus_code,
 	.enum_frame_size	= vimc_sca_enum_frame_size,
 	.get_fmt		= vimc_sca_get_fmt,
-	/* TODO: Add support to other formats */
-	.set_fmt		= vimc_sca_get_fmt,
+	.set_fmt		= vimc_sca_set_fmt,
 };
 
 static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 319bebb..a1cd348 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -111,12 +111,41 @@ static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
 	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
 }
 
+static int vimc_sen_set_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_subdev_pad_config *cfg,
+			    struct v4l2_subdev_format *format)
+{
+	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
+	const struct vimc_pix_map *vpix;
+
+	/* TODO: Add support for try format */
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return -EINVAL;
+
+	/* Do not change the format while stream is on */
+	if (vsen->frame)
+		return -EINVAL;
+
+	/* Don't accept a code that is not on the table */
+	vpix = vimc_pix_map_by_code(format->format.code);
+	if (vpix)
+		vsen->mbus_format.code = format->format.code;
+	else
+		format->format.code = vsen->mbus_format.code;
+
+	vimc_ent_sd_set_fsize(&vsen->mbus_format, cfg, format);
+
+	/* Re-configure the test pattern generator */
+	vimc_sen_tpg_s_format(vsen);
+
+	return 0;
+}
+
 static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
 	.enum_mbus_code		= vimc_sen_enum_mbus_code,
 	.enum_frame_size	= vimc_sen_enum_frame_size,
 	.get_fmt		= vimc_sen_get_fmt,
-	/* TODO: Add support to other formats */
-	.set_fmt		= vimc_sen_get_fmt,
+	.set_fmt		= vimc_sen_set_fmt,
 };
 
 static int vimc_thread_sen(void *data)
-- 
1.9.1


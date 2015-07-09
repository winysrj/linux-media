Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbbGIKKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 07/10] [media] coda: drop custom list of pixel format descriptions
Date: Thu,  9 Jul 2015 12:10:18 +0200
Message-Id: <1436436621-12291-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit ba3002045f80 ("[media] v4l2-ioctl: fill in the description
for VIDIOC_ENUM_FMT"), all pixel formats are assigned their description
in a central place. We can now drop the custom list.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 75 +++----------------------------
 1 file changed, 7 insertions(+), 68 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 8b91bda..b265edd 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -61,11 +61,6 @@ int coda_debug;
 module_param(coda_debug, int, 0644);
 MODULE_PARM_DESC(coda_debug, "Debug level (0-2)");
 
-struct coda_fmt {
-	char *name;
-	u32 fourcc;
-};
-
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(2, coda_debug, &dev->v4l2_dev,
@@ -111,40 +106,6 @@ void coda_write_base(struct coda_ctx *ctx, struct coda_q_data *q_data,
 	coda_write(ctx->dev, base_cr, reg_y + 8);
 }
 
-/*
- * Array of all formats supported by any version of Coda:
- */
-static const struct coda_fmt coda_formats[] = {
-	{
-		.name = "YUV 4:2:0 Planar, YCbCr",
-		.fourcc = V4L2_PIX_FMT_YUV420,
-	},
-	{
-		.name = "YUV 4:2:0 Planar, YCrCb",
-		.fourcc = V4L2_PIX_FMT_YVU420,
-	},
-	{
-		.name = "YUV 4:2:0 Partial interleaved Y/CbCr",
-		.fourcc = V4L2_PIX_FMT_NV12,
-	},
-	{
-		.name = "YUV 4:2:2 Planar, YCbCr",
-		.fourcc = V4L2_PIX_FMT_YUV422P,
-	},
-	{
-		.name = "H264 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_H264,
-	},
-	{
-		.name = "MPEG4 Encoded Stream",
-		.fourcc = V4L2_PIX_FMT_MPEG4,
-	},
-	{
-		.name = "JPEG Encoded Images",
-		.fourcc = V4L2_PIX_FMT_JPEG,
-	},
-};
-
 #define CODA_CODEC(mode, src_fourcc, dst_fourcc, max_w, max_h) \
 	{ mode, src_fourcc, dst_fourcc, max_w, max_h }
 
@@ -261,40 +222,23 @@ static const struct coda_video_device *coda9_video_devices[] = {
 	&coda_bit_decoder,
 };
 
-static bool coda_format_is_yuv(u32 fourcc)
+/*
+ * Normalize all supported YUV 4:2:0 formats to the value used in the codec
+ * tables.
+ */
+static u32 coda_format_normalize_yuv(u32 fourcc)
 {
 	switch (fourcc) {
 	case V4L2_PIX_FMT_YUV420:
 	case V4L2_PIX_FMT_YVU420:
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_YUV422P:
-		return true;
+		return V4L2_PIX_FMT_YUV420;
 	default:
-		return false;
+		return fourcc;
 	}
 }
 
-static const char *coda_format_name(u32 fourcc)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(coda_formats); i++) {
-		if (coda_formats[i].fourcc == fourcc)
-			return coda_formats[i].name;
-	}
-
-	return NULL;
-}
-
-/*
- * Normalize all supported YUV 4:2:0 formats to the value used in the codec
- * tables.
- */
-static u32 coda_format_normalize_yuv(u32 fourcc)
-{
-	return coda_format_is_yuv(fourcc) ? V4L2_PIX_FMT_YUV420 : fourcc;
-}
-
 static const struct coda_codec *coda_find_codec(struct coda_dev *dev,
 						int src_fourcc, int dst_fourcc)
 {
@@ -396,7 +340,6 @@ static int coda_enum_fmt(struct file *file, void *priv,
 	struct video_device *vdev = video_devdata(file);
 	const struct coda_video_device *cvd = to_coda_video_device(vdev);
 	const u32 *formats;
-	const char *name;
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		formats = cvd->src_formats;
@@ -408,11 +351,7 @@ static int coda_enum_fmt(struct file *file, void *priv,
 	if (f->index >= CODA_MAX_FORMATS || formats[f->index] == 0)
 		return -EINVAL;
 
-	name = coda_format_name(formats[f->index]);
-	strlcpy(f->description, name, sizeof(f->description));
 	f->pixelformat = formats[f->index];
-	if (!coda_format_is_yuv(formats[f->index]))
-		f->flags |= V4L2_FMT_FLAG_COMPRESSED;
 
 	return 0;
 }
-- 
2.1.4


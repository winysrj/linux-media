Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3427 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3DNP1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 22/30] cx25821: g/s/try/enum_fmt related fixes and cleanups.
Date: Sun, 14 Apr 2013 17:27:18 +0200
Message-Id: <1365953246-8972-23-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- fill in colorspace
- zero priv
- delete unsupported formats
- fix field handling
- s_std should update width/height
- proper mapping of width/height to valid resolutions

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |  134 +++++++----------------------
 1 file changed, 32 insertions(+), 102 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index f82da1e..aec6fdf 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -54,11 +54,6 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 
 static const struct cx25821_fmt formats[] = {
 	{
-		.name = "8 bpp, gray",
-		.fourcc = V4L2_PIX_FMT_GREY,
-		.depth = 8,
-		.flags = FORMAT_FLAGS_PACKED,
-	 }, {
 		.name = "4:1:1, packed, Y41P",
 		.fourcc = V4L2_PIX_FMT_Y41P,
 		.depth = 12,
@@ -68,16 +63,6 @@ static const struct cx25821_fmt formats[] = {
 		.fourcc = V4L2_PIX_FMT_YUYV,
 		.depth = 16,
 		.flags = FORMAT_FLAGS_PACKED,
-	}, {
-		.name = "4:2:2, packed, UYVY",
-		.fourcc = V4L2_PIX_FMT_UYVY,
-		.depth = 16,
-		.flags = FORMAT_FLAGS_PACKED,
-	}, {
-		.name = "4:2:0, YUV",
-		.fourcc = V4L2_PIX_FMT_YUV420,
-		.depth = 12,
-		.flags = FORMAT_FLAGS_PACKED,
 	},
 };
 
@@ -85,14 +70,9 @@ static const struct cx25821_fmt *cx25821_format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
-	if (fourcc == V4L2_PIX_FMT_Y41P || fourcc == V4L2_PIX_FMT_YUV411P)
-		return formats + 1;
-
 	for (i = 0; i < ARRAY_SIZE(formats); i++)
 		if (formats[i].fourcc == fourcc)
 			return formats + i;
-
-	pr_err("%s(0x%08x) NOT FOUND\n", __func__, fourcc);
 	return NULL;
 }
 
@@ -381,8 +361,7 @@ static int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buff
 			bpl_local = buf->bpl;   /* Default */
 
 			if (chan->use_cif_resolution) {
-				if (dev->tvnorm & V4L2_STD_PAL_BG ||
-						dev->tvnorm & V4L2_STD_PAL_DK)
+				if (dev->tvnorm & V4L2_STD_625_50)
 					bpl_local = 352 << 1;
 				else
 					bpl_local = chan->cif_width << 1;
@@ -612,8 +591,10 @@ static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height = chan->height;
 	f->fmt.pix.field = chan->vidq.field;
 	f->fmt.pix.pixelformat = chan->fmt->fourcc;
-	f->fmt.pix.bytesperline = (f->fmt.pix.width * chan->fmt->depth) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.bytesperline = (chan->width * chan->fmt->depth) >> 3;
+	f->fmt.pix.sizeimage = chan->height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -621,48 +602,39 @@ static int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int cx25821_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				   struct v4l2_format *f)
 {
+	struct cx25821_channel *chan = video_drvdata(file);
+	struct cx25821_dev *dev = chan->dev;
 	const struct cx25821_fmt *fmt;
-	enum v4l2_field field;
+	enum v4l2_field field = f->fmt.pix.field;
 	unsigned int maxw, maxh;
+	unsigned w;
 
 	fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
 	if (NULL == fmt)
 		return -EINVAL;
-
-	field = f->fmt.pix.field;
 	maxw = 720;
-	maxh = 576;
-
-	if (V4L2_FIELD_ANY == field) {
-		if (f->fmt.pix.height > maxh / 2)
-			field = V4L2_FIELD_INTERLACED;
-		else
-			field = V4L2_FIELD_TOP;
-	}
-
-	switch (field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-		maxh = maxh / 2;
-		break;
-	case V4L2_FIELD_INTERLACED:
-		break;
-	default:
-		return -EINVAL;
+	maxh = (dev->tvnorm & V4L2_STD_625_50) ? 576 : 480;
+
+	w = f->fmt.pix.width;
+	if (field != V4L2_FIELD_BOTTOM)
+		field = V4L2_FIELD_TOP;
+	if (w < 352) {
+		w = 176;
+		f->fmt.pix.height = maxh / 4;
+	} else if (w < 720) {
+		w = 352;
+		f->fmt.pix.height = maxh / 2;
+	} else {
+		w = 720;
+		f->fmt.pix.height = maxh;
+		field = V4L2_FIELD_INTERLACED;
 	}
-
 	f->fmt.pix.field = field;
-	if (f->fmt.pix.height < 32)
-		f->fmt.pix.height = 32;
-	if (f->fmt.pix.height > maxh)
-		f->fmt.pix.height = maxh;
-	if (f->fmt.pix.width < 48)
-		f->fmt.pix.width = 48;
-	if (f->fmt.pix.width > maxw)
-		f->fmt.pix.width = maxw;
-	f->fmt.pix.width &= ~0x03;
+	f->fmt.pix.width = w;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -696,43 +668,6 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	return videobuf_streamoff(&chan->vidq);
 }
 
-static int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm)
-{
-	if (tvnorm == V4L2_STD_PAL_BG) {
-		if (width == 352 || width == 720)
-			return 1;
-		else
-			return 0;
-	}
-
-	if (tvnorm == V4L2_STD_NTSC_M) {
-		if (width == 320 || width == 352 || width == 720)
-			return 1;
-		else
-			return 0;
-	}
-	return 0;
-}
-
-static int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm)
-{
-	if (tvnorm == V4L2_STD_PAL_BG) {
-		if (height == 576 || height == 288)
-			return 1;
-		else
-			return 0;
-	}
-
-	if (tvnorm == V4L2_STD_NTSC_M) {
-		if (height == 480 || height == 240)
-			return 1;
-		else
-			return 0;
-	}
-
-	return 0;
-}
-
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
@@ -749,20 +684,13 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	chan->fmt = cx25821_format_by_fourcc(f->fmt.pix.pixelformat);
 	chan->vidq.field = f->fmt.pix.field;
-
-	/* check if width and height is valid based on set standard */
-	if (cx25821_is_valid_width(f->fmt.pix.width, dev->tvnorm))
-		chan->width = f->fmt.pix.width;
-
-	if (cx25821_is_valid_height(f->fmt.pix.height, dev->tvnorm))
-		chan->height = f->fmt.pix.height;
+	chan->width = f->fmt.pix.width;
+	chan->height = f->fmt.pix.height;
 
 	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_Y41P)
 		pix_format = PIXEL_FRMT_411;
-	else if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUYV)
-		pix_format = PIXEL_FRMT_422;
 	else
-		return -EINVAL;
+		pix_format = PIXEL_FRMT_422;
 
 	cx25821_set_pixel_format(dev, SRAM_CH00, pix_format);
 
@@ -879,6 +807,8 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 		return 0;
 
 	cx25821_set_tvnorm(dev, tvnorms);
+	chan->width = 720;
+	chan->height = (dev->tvnorm & V4L2_STD_625_50) ? 576 : 480;
 
 	medusa_set_videostandard(dev);
 
-- 
1.7.10.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:41938 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754999AbcA1JJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 04:09:37 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH 10/12] TW686x: handle non-NULL format in queue_setup()
References: <m337tif6om.fsf@t19.piap.pl>
Date: Thu, 28 Jan 2016 10:09:35 +0100
In-Reply-To: <m337tif6om.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Thu, 28 Jan 2016 09:29:29 +0100")
Message-ID: <m3lh7acbow.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 12cc108..cfc15e7 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -82,6 +82,50 @@ static const struct tw686x_format *format_by_fourcc(unsigned fourcc)
 	return NULL;
 }
 
+static void tw686x_get_format(struct tw686x_video_channel *vc,
+			      struct v4l2_format *f)
+{
+	const struct tw686x_format *format;
+	unsigned width, height, height_div = 1;
+
+	format = format_by_fourcc(f->fmt.pix.pixelformat);
+	if (!format) {
+		format = &formats[0];
+		f->fmt.pix.pixelformat = format->fourcc;
+	}
+
+	width = 704;
+	if (f->fmt.pix.width < width * 3 / 4 /* halfway */)
+		width /= 2;
+
+	height = (vc->video_standard & V4L2_STD_625_50) ? 576 : 480;
+	if (f->fmt.pix.height < height * 3 / 4 /* halfway */)
+		height_div = 2;
+
+	switch (f->fmt.pix.field) {
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
+		height_div = 2;
+		break;
+	case V4L2_FIELD_SEQ_BT:
+		if (height_div > 1)
+			f->fmt.pix.field = V4L2_FIELD_BOTTOM;
+		break;
+	default:
+		if (height_div > 1)
+			f->fmt.pix.field = V4L2_FIELD_TOP;
+		else
+			f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
+	}
+	height /= height_div;
+
+	f->fmt.pix.width = width;
+	f->fmt.pix.height = height;
+	f->fmt.pix.bytesperline = f->fmt.pix.width * format->depth / 8;
+	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+}
+
 /* video queue operations */
 
 static int tw686x_queue_setup(struct vb2_queue *vq, const void *arg,
@@ -90,12 +134,17 @@ static int tw686x_queue_setup(struct vb2_queue *vq, const void *arg,
 {
 	struct tw686x_video_channel *vc = vb2_get_drv_priv(vq);
 
-	sizes[0] = vc->width * vc->height * vc->format->depth / 8;
+	if (arg) {
+		struct v4l2_format fmt = *(const struct v4l2_format*)arg;
+		tw686x_get_format(vc, &fmt);
+		sizes[0] = fmt.fmt.pix.sizeimage;
+	} else
+		sizes[0] = vc->width * vc->height * vc->format->depth / 8;
+
 	alloc_ctxs[0] = vc->alloc_ctx;
 	*nplanes = 1;		/* packed formats only */
 	if (*nbuffers < 2)
 		*nbuffers = 2;
-
 	return 0;
 }
 
@@ -340,47 +389,7 @@ static int tw686x_g_fmt_vid_cap(struct file *file, void *priv,
 static int tw686x_try_fmt_vid_cap(struct file *file, void *priv,
 				  struct v4l2_format *f)
 {
-	struct tw686x_video_channel *vc = video_drvdata(file);
-	const struct tw686x_format *format;
-	unsigned width, height, height_div = 1;
-
-	format = format_by_fourcc(f->fmt.pix.pixelformat);
-	if (!format) {
-		format = &formats[0];
-		f->fmt.pix.pixelformat = format->fourcc;
-	}
-
-	width = 704;
-	if (f->fmt.pix.width < width * 3 / 4 /* halfway */)
-		width /= 2;
-
-	height = (vc->video_standard & V4L2_STD_625_50) ? 576 : 480;
-	if (f->fmt.pix.height < height * 3 / 4 /* halfway */)
-		height_div = 2;
-
-	switch (f->fmt.pix.field) {
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
-		height_div = 2;
-		break;
-	case V4L2_FIELD_SEQ_BT:
-		if (height_div > 1)
-			f->fmt.pix.field = V4L2_FIELD_BOTTOM;
-		break;
-	default:
-		if (height_div > 1)
-			f->fmt.pix.field = V4L2_FIELD_TOP;
-		else
-			f->fmt.pix.field = V4L2_FIELD_SEQ_TB;
-	}
-	height /= height_div;
-
-	f->fmt.pix.width = width;
-	f->fmt.pix.height = height;
-	f->fmt.pix.bytesperline = f->fmt.pix.width * format->depth / 8;
-	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
-
+	tw686x_get_format(video_drvdata(file), f);
 	return 0;
 }
 
@@ -388,12 +397,8 @@ static int tw686x_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct tw686x_video_channel *vc = video_drvdata(file);
-	int err;
-
-	err = tw686x_try_fmt_vid_cap(file, priv, f);
-	if (err)
-		return err;
 
+	tw686x_get_format(vc, f);
 	vc->format = format_by_fourcc(f->fmt.pix.pixelformat);
 	vc->field = f->fmt.pix.field;
 	vc->width = f->fmt.pix.width;

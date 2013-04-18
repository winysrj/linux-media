Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f176.google.com ([209.85.160.176]:47713 "EHLO
	mail-gh0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965727Ab3DRO5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 10:57:13 -0400
Received: by mail-gh0-f176.google.com with SMTP id f16so355818ghb.7
        for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 07:57:13 -0700 (PDT)
From: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Subject: [PATCH] solo6x10: Fix pixelformat accepted/reported by the encoder
Date: Thu, 18 Apr 2013 11:56:35 -0300
Message-Id: <1366296995-16198-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 6010 produces MPEG-4 part 2, while 6110 produces H.264.

Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 43 ++++++++++++++++------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index d132d3b..a4c5896 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -519,10 +519,15 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
 	}
 
-	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG4)
+	switch (solo_enc->fmt) {
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_H264:
 		ret = solo_fill_mpeg(solo_enc, vb, vh);
-	else
+		break;
+	default: /* V4L2_PIX_FMT_MJPEG */
 		ret = solo_fill_jpeg(solo_enc, vb, vh);
+		break;
+	}
 
 	if (!ret) {
 		vb->v4l2_buf.sequence = solo_enc->sequence++;
@@ -780,10 +785,21 @@ static int solo_enc_get_input(struct file *file, void *priv,
 static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *f)
 {
+	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	int dev_type = solo_enc->solo_dev->type;
+
 	switch (f->index) {
 	case 0:
-		f->pixelformat = V4L2_PIX_FMT_MPEG4;
-		strcpy(f->description, "MPEG-4 AVC");
+		switch (dev_type) {
+		case SOLO_DEV_6010:
+			f->pixelformat = V4L2_PIX_FMT_MPEG4;
+			strcpy(f->description, "MPEG-4 part 2");
+			break;
+		case SOLO_DEV_6110:
+			f->pixelformat = V4L2_PIX_FMT_H264;
+			strcpy(f->description, "H.264");
+			break;
+		}
 		break;
 	case 1:
 		f->pixelformat = V4L2_PIX_FMT_MJPEG;
@@ -798,6 +814,13 @@ static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 	return 0;
 }
 
+static inline int solo_valid_pixfmt(u32 pixfmt, int dev_type)
+{
+	return (pixfmt == V4L2_PIX_FMT_H264 && dev_type == SOLO_DEV_6110)
+		|| (pixfmt == V4L2_PIX_FMT_MPEG4 && dev_type == SOLO_DEV_6010)
+		|| pixfmt == V4L2_PIX_FMT_MJPEG ? 0 : -EINVAL;
+}
+
 static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
@@ -805,8 +828,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (pix->pixelformat != V4L2_PIX_FMT_MPEG4 &&
-	    pix->pixelformat != V4L2_PIX_FMT_MJPEG)
+	if (solo_valid_pixfmt(pix->pixelformat, solo_dev->type))
 		return -EINVAL;
 
 	if (pix->width < solo_dev->video_hsize ||
@@ -919,8 +941,7 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG4 &&
-	    fsize->pixel_format != V4L2_PIX_FMT_MJPEG)
+	if (solo_valid_pixfmt(fsize->pixel_format, solo_dev->type))
 		return -EINVAL;
 
 	switch (fsize->index) {
@@ -947,8 +968,7 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG4 &&
-	    fintv->pixel_format != V4L2_PIX_FMT_MJPEG)
+	if (solo_valid_pixfmt(fintv->pixel_format, solo_dev->type))
 		return -EINVAL;
 	if (fintv->index)
 		return -EINVAL;
@@ -1217,7 +1237,8 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	mutex_init(&solo_enc->lock);
 	spin_lock_init(&solo_enc->av_lock);
 	INIT_LIST_HEAD(&solo_enc->vidq_active);
-	solo_enc->fmt = V4L2_PIX_FMT_MPEG4;
+	solo_enc->fmt = (solo_dev->type == SOLO_DEV_6010) ?
+		V4L2_PIX_FMT_MPEG4 : V4L2_PIX_FMT_H264;
 	solo_enc->type = SOLO_ENC_TYPE_STD;
 
 	solo_enc->qp = SOLO_DEFAULT_QP;
-- 
1.8.2.1


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2927 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3CBXpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/20] solo6x10: fix various format-related compliancy issues.
Date: Sun,  3 Mar 2013 00:45:23 +0100
Message-Id: <81bd01e3e289158b9691c29ff258f1dd81d928ec.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- try_fmt should never return -EBUSY.
- invalid pix->field values were not mapped to a valid value.
- the priv field of struct v4l2_pix_format wasn't zeroed.
- the try_fmt error code was not checked in set_fmt.
- enum_framesizes/intervals is valid for both MJPEG and MPEG pixel formats.
- enum_frameintervals didn't check width and height and reported the
  wrong range.
- s_parm didn't set readbuffers.
- don't fail on invalid colorspace, just replace with the valid colorspace.
- bytesperline should be 0 for compressed formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |   51 ++++++++++++++++++++---------
 drivers/staging/media/solo6x10/v4l2.c     |   29 +++++++---------
 2 files changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 6b5b8c0..43ce8c5 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -1105,13 +1105,6 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	    pix->pixelformat != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
-	/* We cannot change width/height in mid read */
-	if (atomic_read(&solo_enc->readers) > 0) {
-		if (pix->width != solo_enc->width ||
-		    pix->height != solo_enc->height)
-			return -EBUSY;
-	}
-
 	if (pix->width < solo_dev->video_hsize ||
 	    pix->height < solo_dev->video_vsize << 1) {
 		/* Default to CIF 1/2 size */
@@ -1123,14 +1116,20 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 		pix->height = solo_dev->video_vsize << 1;
 	}
 
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = V4L2_FIELD_INTERLACED;
-	else if (pix->field != V4L2_FIELD_INTERLACED)
+	switch (pix->field) {
+	case V4L2_FIELD_NONE:
+	case V4L2_FIELD_INTERLACED:
+		break;
+	case V4L2_FIELD_ANY:
+	default:
 		pix->field = V4L2_FIELD_INTERLACED;
+		break;
+	}
 
 	/* Just set these */
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->sizeimage = FRAME_BUF_SIZE;
+	pix->priv = 0;
 
 	return 0;
 }
@@ -1147,6 +1146,15 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	spin_lock(&solo_enc->lock);
 
 	ret = solo_enc_try_fmt_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	/* We cannot change width/height in mid read */
+	if (!ret && atomic_read(&solo_enc->readers) > 0) {
+		if (pix->width != solo_enc->width ||
+		    pix->height != solo_enc->height)
+			ret = -EBUSY;
+	}
 	if (ret) {
 		spin_unlock(&solo_enc->lock);
 		return ret;
@@ -1186,6 +1194,7 @@ static int solo_enc_get_fmt_cap(struct file *file, void *priv,
 		     V4L2_FIELD_NONE;
 	pix->sizeimage = FRAME_BUF_SIZE;
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	pix->priv = 0;
 
 	return 0;
 }
@@ -1298,7 +1307,8 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 	struct solo_enc_fh *fh = priv;
 	struct solo_dev *solo_dev = fh->enc->solo_dev;
 
-	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG)
+	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG &&
+	    fsize->pixel_format != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
 	switch (fsize->index) {
@@ -1325,16 +1335,24 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 	struct solo_enc_fh *fh = priv;
 	struct solo_dev *solo_dev = fh->enc->solo_dev;
 
-	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG || fintv->index)
+	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG &&
+	    fintv->pixel_format != V4L2_PIX_FMT_MJPEG)
+		return -EINVAL;
+	if (fintv->index)
+		return -EINVAL;
+	if ((fintv->width != solo_dev->video_hsize >> 1 ||
+	     fintv->height != solo_dev->video_vsize) &&
+	    (fintv->width != solo_dev->video_hsize ||
+	     fintv->height != solo_dev->video_vsize << 1))
 		return -EINVAL;
 
 	fintv->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 
-	fintv->stepwise.min.numerator = solo_dev->fps;
-	fintv->stepwise.min.denominator = 1;
+	fintv->stepwise.min.denominator = solo_dev->fps;
+	fintv->stepwise.min.numerator = 15;
 
-	fintv->stepwise.max.numerator = solo_dev->fps;
-	fintv->stepwise.max.denominator = 15;
+	fintv->stepwise.max.denominator = solo_dev->fps;
+	fintv->stepwise.max.numerator = 1;
 
 	fintv->stepwise.step.numerator = 1;
 	fintv->stepwise.step.denominator = 1;
@@ -1391,6 +1409,7 @@ static int solo_s_parm(struct file *file, void *priv,
 	solo_enc->interval = cp->timeperframe.numerator;
 
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	cp->readbuffers = 2;
 
 	solo_enc->gop = max(solo_dev->fps / solo_enc->interval, 1);
 	solo_update_mode(solo_enc);
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index e0cf498..3db65a7 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -28,7 +28,6 @@
 #include "tw28.h"
 
 #define SOLO_HW_BPL		2048
-#define SOLO_DISP_PIX_FIELD	V4L2_FIELD_INTERLACED
 
 /* Image size is two fields, SOLO_HW_BPL is one horizontal line */
 #define solo_vlines(__solo)	(__solo->video_vsize * 2)
@@ -538,7 +537,7 @@ static int solo_v4l2_open(struct file *file)
 	videobuf_queue_sg_init(&fh->vidq, &solo_video_qops,
 			       &solo_dev->pdev->dev, &fh->slock,
 			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       SOLO_DISP_PIX_FIELD,
+			       V4L2_FIELD_INTERLACED,
 			       sizeof(struct videobuf_buffer), fh, NULL);
 
 	return 0;
@@ -672,23 +671,16 @@ static int solo_try_fmt_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int image_size = solo_image_size(solo_dev);
 
-	/* Check supported sizes */
-	if (pix->width != solo_dev->video_hsize)
-		pix->width = solo_dev->video_hsize;
-	if (pix->height != solo_vlines(solo_dev))
-		pix->height = solo_vlines(solo_dev);
-	if (pix->sizeimage != image_size)
-		pix->sizeimage = image_size;
-
-	/* Check formats */
-	if (pix->field == V4L2_FIELD_ANY)
-		pix->field = SOLO_DISP_PIX_FIELD;
-
-	if (pix->pixelformat != V4L2_PIX_FMT_UYVY ||
-	    pix->field       != SOLO_DISP_PIX_FIELD ||
-	    pix->colorspace  != V4L2_COLORSPACE_SMPTE170M)
+	if (pix->pixelformat != V4L2_PIX_FMT_UYVY)
 		return -EINVAL;
 
+	pix->width = solo_dev->video_hsize;
+	pix->height = solo_vlines(solo_dev);
+	pix->sizeimage = image_size;
+	pix->field = V4L2_FIELD_INTERLACED;
+	pix->pixelformat = V4L2_PIX_FMT_UYVY;
+	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	pix->priv = 0;
 	return 0;
 }
 
@@ -715,10 +707,11 @@ static int solo_get_fmt_cap(struct file *file, void *priv,
 	pix->width = solo_dev->video_hsize;
 	pix->height = solo_vlines(solo_dev);
 	pix->pixelformat = V4L2_PIX_FMT_UYVY;
-	pix->field = SOLO_DISP_PIX_FIELD;
+	pix->field = V4L2_FIELD_INTERLACED;
 	pix->sizeimage = solo_image_size(solo_dev);
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->bytesperline = solo_bytesperline(solo_dev);
+	pix->priv = 0;
 
 	return 0;
 }
-- 
1.7.10.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2395 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3CRMcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 16/19] solo6x10: use V4L2_PIX_FMT_MPEG4, not _FMT_MPEG
Date: Mon, 18 Mar 2013 13:32:15 +0100
Message-Id: <1363609938-21735-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

FMT_MPEG is for multiplexed streams, not elementary streams. The same is
true for the V4L2_CID_MPEG_VIDEO_ENCODING control.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 93f0dc7..ca87fb3 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -516,7 +516,7 @@ static int solo_enc_fillbuf(struct solo_enc_dev *solo_enc,
 			vb->v4l2_buf.flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
 	}
 
-	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG)
+	if (solo_enc->fmt == V4L2_PIX_FMT_MPEG4)
 		ret = solo_fill_mpeg(solo_enc, vb, vh);
 	else
 		ret = solo_fill_jpeg(solo_enc, vb, vh);
@@ -779,7 +779,7 @@ static int solo_enc_enum_fmt_cap(struct file *file, void *priv,
 {
 	switch (f->index) {
 	case 0:
-		f->pixelformat = V4L2_PIX_FMT_MPEG;
+		f->pixelformat = V4L2_PIX_FMT_MPEG4;
 		strcpy(f->description, "MPEG-4 AVC");
 		break;
 	case 1:
@@ -802,7 +802,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	if (pix->pixelformat != V4L2_PIX_FMT_MPEG &&
+	if (pix->pixelformat != V4L2_PIX_FMT_MPEG4 &&
 	    pix->pixelformat != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
@@ -907,7 +907,7 @@ static int solo_enum_framesizes(struct file *file, void *priv,
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG &&
+	if (fsize->pixel_format != V4L2_PIX_FMT_MPEG4 &&
 	    fsize->pixel_format != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
@@ -935,7 +935,7 @@ static int solo_enum_frameintervals(struct file *file, void *priv,
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG &&
+	if (fintv->pixel_format != V4L2_PIX_FMT_MPEG4 &&
 	    fintv->pixel_format != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 	if (fintv->index)
@@ -1024,8 +1024,6 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_SHARPNESS:
 		return tw28_set_ctrl_val(solo_dev, ctrl->id, solo_enc->ch,
 					 ctrl->val);
-	case V4L2_CID_MPEG_VIDEO_ENCODING:
-		return 0;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
 		solo_enc->gop = ctrl->val;
 		return 0;
@@ -1172,10 +1170,6 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	if (tw28_has_sharpness(solo_dev, ch))
 		v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_SHARPNESS, 0, 15, 1, 0);
-	v4l2_ctrl_new_std_menu(hdl, &solo_ctrl_ops,
-			V4L2_CID_MPEG_VIDEO_ENCODING,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC, 3,
-			V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC);
 	v4l2_ctrl_new_std(hdl, &solo_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 255, 1, solo_dev->fps);
 	v4l2_ctrl_new_custom(hdl, &solo_motion_threshold_ctrl, NULL);
@@ -1191,7 +1185,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	mutex_init(&solo_enc->lock);
 	spin_lock_init(&solo_enc->av_lock);
 	INIT_LIST_HEAD(&solo_enc->vidq_active);
-	solo_enc->fmt = V4L2_PIX_FMT_MPEG;
+	solo_enc->fmt = V4L2_PIX_FMT_MPEG4;
 	solo_enc->type = SOLO_ENC_TYPE_STD;
 
 	solo_enc->qp = SOLO_DEFAULT_QP;
-- 
1.7.10.4


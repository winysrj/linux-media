Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:36997 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728170AbeJEOqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/11] s5p_mfc_dec.c: convert g_crop to g_selection
Date: Fri,  5 Oct 2018 09:49:07 +0200
Message-Id: <20181005074911.47574-8-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The g_crop really implemented composition for the CAPTURE stream.

Replace g_crop by g_selection and set the V4L2_FL_QUIRK_INVERTED_CROP
flag since this is one of the old drivers that predates the selection
API. Those old drivers allowed g_crop when it really shouldn't have
since g_crop returns a compose rectangle instead of a crop rectangle.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 49 +++++++++++++-------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 927a1235408d..8a5ba3bec3af 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1342,6 +1342,7 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	vfd->lock	= &dev->mfc_mutex;
 	vfd->v4l2_dev	= &dev->v4l2_dev;
 	vfd->vfl_dir	= VFL_DIR_M2M;
+	set_bit(V4L2_FL_QUIRK_INVERTED_CROP, &vfd->flags);
 	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
 	dev->vfd_dec	= vfd;
 	video_set_drvdata(vfd, dev);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 670ca869babb..eaaf1418b0fa 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -773,19 +773,23 @@ static const struct v4l2_ctrl_ops s5p_mfc_dec_ctrl_ops = {
 	.g_volatile_ctrl = s5p_mfc_dec_g_v_ctrl,
 };
 
-/* Get cropping information */
-static int vidioc_g_crop(struct file *file, void *priv,
-		struct v4l2_crop *cr)
+/* Get compose information */
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_mfc_dev *dev = ctx->dev;
 	u32 left, right, top, bottom;
+	u32 width, height;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
 
 	if (ctx->state != MFCINST_HEAD_PARSED &&
 	    ctx->state != MFCINST_RUNNING &&
 	    ctx->state != MFCINST_FINISHING &&
 	    ctx->state != MFCINST_FINISHED) {
-		mfc_err("Can not get crop information\n");
+		mfc_err("Can not get compose information\n");
 		return -EINVAL;
 	}
 	if (ctx->src_fmt->fourcc == V4L2_PIX_FMT_H264) {
@@ -795,22 +799,33 @@ static int vidioc_g_crop(struct file *file, void *priv,
 		top = s5p_mfc_hw_call(dev->mfc_ops, get_crop_info_v, ctx);
 		bottom = top >> S5P_FIMV_SHARED_CROP_BOTTOM_SHIFT;
 		top = top & S5P_FIMV_SHARED_CROP_TOP_MASK;
-		cr->c.left = left;
-		cr->c.top = top;
-		cr->c.width = ctx->img_width - left - right;
-		cr->c.height = ctx->img_height - top - bottom;
-		mfc_debug(2, "Cropping info [h264]: l=%d t=%d w=%d h=%d (r=%d b=%d fw=%d fh=%d\n",
-			  left, top, cr->c.width, cr->c.height, right, bottom,
+		width = ctx->img_width - left - right;
+		height = ctx->img_height - top - bottom;
+		mfc_debug(2, "Composing info [h264]: l=%d t=%d w=%d h=%d (r=%d b=%d fw=%d fh=%d\n",
+			  left, top, s->r.width, s->r.height, right, bottom,
 			  ctx->buf_width, ctx->buf_height);
 	} else {
-		cr->c.left = 0;
-		cr->c.top = 0;
-		cr->c.width = ctx->img_width;
-		cr->c.height = ctx->img_height;
-		mfc_debug(2, "Cropping info: w=%d h=%d fw=%d fh=%d\n",
-			  cr->c.width,	cr->c.height, ctx->buf_width,
+		left = 0;
+		top = 0;
+		width = ctx->img_width;
+		height = ctx->img_height;
+		mfc_debug(2, "Composing info: w=%d h=%d fw=%d fh=%d\n",
+			  s->r.width, s->r.height, ctx->buf_width,
 			  ctx->buf_height);
 	}
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+		s->r.left = left;
+		s->r.top = top;
+		s->r.width = width;
+		s->r.height = height;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -887,7 +902,7 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_expbuf = vidioc_expbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
-	.vidioc_g_crop = vidioc_g_crop,
+	.vidioc_g_selection = vidioc_g_selection,
 	.vidioc_decoder_cmd = vidioc_decoder_cmd,
 	.vidioc_subscribe_event = vidioc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-- 
2.18.0

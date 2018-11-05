Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41067 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729349AbeKFAlL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:41:11 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] media: imx: add capture compose rectangle
Date: Mon,  5 Nov 2018 16:20:53 +0100
Message-Id: <20181105152055.31254-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allowing to compose captured images into larger memory buffers
will let us lift alignment restrictions on CSI crop width.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-ic-prpencvf.c   |  3 +-
 drivers/staging/media/imx/imx-media-capture.c | 38 +++++++++++++++++++
 drivers/staging/media/imx/imx-media-csi.c     |  3 +-
 drivers/staging/media/imx/imx-media-vdic.c    |  4 +-
 drivers/staging/media/imx/imx-media.h         |  2 +
 5 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 28f41caba05d..fe5a77baa592 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -366,8 +366,7 @@ static int prp_setup_channel(struct prp_priv *priv,
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect = vdev->compose;
 
 	if (rot_swap_width_height) {
 		swap(image.pix.width, image.pix.height);
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index b37e1186eb2f..cace8a51aca8 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -262,6 +262,10 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
 	priv->vdev.fmt.fmt.pix = f->fmt.pix;
 	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
 					      CS_SEL_ANY, true);
+	priv->vdev.compose.left = 0;
+	priv->vdev.compose.top = 0;
+	priv->vdev.compose.width = f->fmt.fmt.pix.width;
+	priv->vdev.compose.height = f->fmt.fmt.pix.height;
 
 	return 0;
 }
@@ -290,6 +294,35 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
 	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
 }
 
+static int capture_g_selection(struct file *file, void *fh,
+			       struct v4l2_selection *s)
+{
+	struct capture_priv *priv = video_drvdata(file);
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_NATIVE_SIZE:
+	case V4L2_SEL_TGT_COMPOSE:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_PADDED:
+		s->r = priv->vdev.compose;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int capture_s_selection(struct file *file, void *fh,
+			       struct v4l2_selection *s)
+{
+	return capture_g_selection(file, fh, s);
+}
+
 static int capture_g_parm(struct file *file, void *fh,
 			  struct v4l2_streamparm *a)
 {
@@ -350,6 +383,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
 	.vidioc_g_std           = capture_g_std,
 	.vidioc_s_std           = capture_s_std,
 
+	.vidioc_g_selection	= capture_g_selection,
+	.vidioc_s_selection	= capture_s_selection,
+
 	.vidioc_g_parm          = capture_g_parm,
 	.vidioc_s_parm          = capture_s_parm,
 
@@ -687,6 +723,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
 	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
 				      &fmt_src.format, NULL);
+	vdev->compose.width = fmt_src.format.width;
+	vdev->compose.height = fmt_src.format.height;
 	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
 					 CS_SEL_ANY, false);
 
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4223f8d418ae..c4523afe7b48 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -413,8 +413,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect = vdev->compose;
 
 	csi_idmac_setup_vb2_buf(priv, phys);
 
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..e08d296cf4eb 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -263,10 +263,10 @@ static int setup_vdi_channel(struct vdic_priv *priv,
 
 	memset(&image, 0, sizeof(image));
 	image.pix = vdev->fmt.fmt.pix;
+	image.rect = vdev->compose;
 	/* one field to VDIC channels */
 	image.pix.height /= 2;
-	image.rect.width = image.pix.width;
-	image.rect.height = image.pix.height;
+	image.rect.height /= 2;
 	image.phys0 = phys0;
 	image.phys1 = phys1;
 
diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index bc7feb81937c..7a0e658753f0 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -80,6 +80,8 @@ struct imx_media_video_dev {
 
 	/* the user format */
 	struct v4l2_format fmt;
+	/* the compose rectangle */
+	struct v4l2_rect compose;
 	const struct imx_media_pixfmt *cc;
 
 	/* links this vdev to master list */
-- 
2.19.1
